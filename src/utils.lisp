(defpackage #:utils
  (:use #:cl)
  (:export 
    #:split-frontmatter
    #:generate-out-path
    #:walk
    #:print-hash-table))
(in-package #:utils)

;;splits yaml frontmatter from file
(defun split-frontmatter (text)
  ;; splits into lines
  (let ((lines (uiop:split-string text :separator '(#\Newline))))
    ;; checks if first line starts with a --- 
    (if (string= (string-right-trim " " (first lines)) "---")
      ;; end is the line number of the next --- (the end of the front matter)
      ;; the test function ignores whitespace on the right
        (let* ((test-f (lambda (a b) (string= a (string-right-trim " " b))))
               (end (position "---" (rest lines) :test test-f)))
          (if end
              (values (format nil "~{~a~^~%~}" (subseq (rest lines) 0 end))
                      (format nil "~{~a~^~%~}" (nthcdr (+ end 2) lines)))
              (values nil text)))
        (values nil text))))

(defun generate-out-path (in-path in-dir out-dir)
  (let* ((rel-in-path (uiop:enough-pathname in-path in-dir))
         (rel-out-path (if (string= (pathname-name in-path) "index")
                           (make-pathname :type "html" :defaults rel-in-path) 
                           (format nil "~a/index.html" (make-pathname :type nil :defaults rel-in-path))))
         (out-path (merge-pathnames rel-out-path out-dir)))
        (ensure-directories-exist out-path)
        out-path))

;; recursively walk through directories and apply a function to each file
(defun walk (dir fn)
  (mapc fn (uiop:directory-files dir))
  (mapc (lambda (d) (walk d fn)) (uiop:subdirectories dir)))

(defun print-hash-table (h)
  (maphash (lambda (k v) (format t "~a: ~a~%" k v)) h))
