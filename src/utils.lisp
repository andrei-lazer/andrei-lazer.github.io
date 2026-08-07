(defpackage #:utils
  (:use #:cl)
  (:export 
    #:split-frontmatter
    #:read-document
    #:out-path
    #:write-html
    #:walk
    #:index-directory
    #:print-hash-table))
(in-package #:utils)

(defparameter +line-padding+ '(#\Space #\Tab #\Return)
  "trailing characters ignored when looking for a --- frontmatter delimiter. #\\Return is
   in here so that files with crlf line endings are handled the same as lf ones")

(defun split-lines (text)
  ;; splitting on #\Newline alone leaves a trailing #\Return on every line of a crlf file,
  ;; so it is stripped here rather than left to leak into the yaml and the body
  (mapcar (lambda (line) (string-right-trim '(#\Return) line))
          (uiop:split-string text :separator '(#\Newline))))

;;splits yaml frontmatter from file
(defun split-frontmatter (text)
  ;; splits into lines
  (let ((lines (split-lines text)))
    ;; checks if first line starts with a --- 
    (if (string= (string-right-trim +line-padding+ (first lines)) "---")
      ;; end is the line number of the next --- (the end of the front matter)
      ;; the test function ignores whitespace on the right
        (let* ((test-f (lambda (a b) (string= a (string-right-trim +line-padding+ b))))
               (end (position "---" (rest lines) :test test-f)))
          (if end
              (values (format nil "~{~a~^~%~}" (subseq (rest lines) 0 end))
                      (format nil "~{~a~^~%~}" (nthcdr (+ end 2) lines)))
              (values nil text)))
        (values nil text))))

;; reads a text file and splits its yaml frontmatter from its body: the frontmatter is
;; parsed into a hash table of metadata (empty when the file has none)
(defun read-document (path)
  (multiple-value-bind (yaml body) (split-frontmatter (uiop:read-file-string path))
    (values (if yaml (cl-yy:yaml-simple-load yaml) (make-hash-table :test 'equal))
            body)))

;; where a source file ends up in the build directory. pure: works out the path without
;; touching the filesystem, so it can be reasoned about (and tested) on its own
(defun out-path (in-path in-dir out-dir)
  (let* ((rel-in-path (uiop:enough-pathname in-path in-dir))
         (rel-out-path (if (member (pathname-name in-path) '("index" "404") :test #'equal)
                           ;; index and 404 keep their own name, everything else becomes a
                           ;; directory with an index.html in it, so urls have no .html on them
                           (make-pathname :type "html" :defaults rel-in-path) 
                           (format nil "~a/index.html" (make-pathname :type nil :defaults rel-in-path)))))
        (merge-pathnames rel-out-path out-dir)))

;; opens out-path and runs render-fn with its html output redirected there
(defun write-html (out-path render-fn)
  (with-open-file (out out-path :direction :output
                       :if-exists :supersede
                       :if-does-not-exist :create
                       :external-format :utf-8)
    (let ((spinneret:*html* out))
      (funcall render-fn))))

;; recursively walk through directories and apply a function to each file
(defun walk (dir fn)
  (mapc fn (uiop:directory-files dir))
  (mapc (lambda (d) (walk d fn)) (uiop:subdirectories dir)))

;; walks dir, applies fn to every file, and gathers the non-nil results in a hash table
;; keyed by each file's path relative to dir
(defun index-directory (dir fn)
  (let ((index (make-hash-table :test #'equal)))
    (walk dir (lambda (path)
                (let ((result (funcall fn path)))
                  (when result
                    (setf (gethash (uiop:enough-pathname path dir) index) result)))))
    index))

(defun print-hash-table (h)
  (maphash (lambda (k v) (format t "~a: ~a~%" k v)) h))
