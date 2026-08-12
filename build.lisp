(require :asdf)
(load "~/quicklisp/setup.lisp")
(push #p"./" asdf:*central-registry*)
(ql:quickload :cl-ssg)


(in-package cl-ssg)

(defparameter *base-path* "")

(load (merge-pathnames "layouts.lisp" *base-path*))

(let* ((*input-root* (utils:ensure-and-absolute (merge-pathnames "src/" *base-path*)))
       (*output-root* (utils:ensure-and-absolute (merge-pathnames "build/" *base-path*))))
  (process-input-dir)
  (passthrough-copy "style/")
  (passthrough-copy "assets/"))

(let* ((*input-root* (uiop:getenv-pathname "WIKI" :ensure-directory t))
       (markdown:*link-prefix* "/cards/")
       (*output-root* (utils:ensure-and-absolute (merge-pathnames "build/cards/" *base-path*))))
  (format t "~&compiling from ~a to ~a~%" *input-root* *output-root*)
  (process-input-dir)
  (passthrough-copy "assets/"))
