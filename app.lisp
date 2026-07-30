(defpackage #:app
  (:use #:cl)
  (:export #:main #:r))

(in-package #:app)

(defun main ()
  (dolist (f (sta6:walk (truename "src/pages/")))
    (let* ((rel (uiop:enough-pathname f (truename "src/pages/")))
           (name (format nil "pages/~a~a"
                         (format nil "~{~a/~}" (rest (pathname-directory rel)))
                         (pathname-name rel))))
      (unless (find-package (string-upcase name))
        (warn "no package ~a — missing from app.asd?" name))))
  (sta6:build))

(defun r ()
  (asdf:load-system :app)
  (app:main))
