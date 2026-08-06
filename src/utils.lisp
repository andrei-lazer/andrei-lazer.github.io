(defpackage #:utils
  (:use #:cl)
  (:export 
    #:split-frontmatter
    #:out-path
    #:generate-out-path
    #:walk
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

(defun generate-out-path (in-path in-dir out-dir)
  (let ((out-path (out-path in-path in-dir out-dir)))
    (ensure-directories-exist out-path)
    out-path))

;; recursively walk through directories and apply a function to each file
(defun walk (dir fn)
  (mapc fn (uiop:directory-files dir))
  (mapc (lambda (d) (walk d fn)) (uiop:subdirectories dir)))

(defun print-hash-table (h)
  (maphash (lambda (k v) (format t "~a: ~a~%" k v)) h))
