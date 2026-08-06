(defpackage #:layouts
  (:use #:cl)
  (:export #:simple #:card #:page))

(in-package #:layouts)

(defmacro simple (&body body)
  `(spinneret:with-html
     (:doctype)
     (:html
       ,@body)))

(defmacro card ((&key title header mathjax icon-file &allow-other-keys) &body body)
 `(let* ((icon-file (or ,icon-file "computer.gif"))
         (icon-path (format nil "/assets/~a" icon-file))
         (header (or ,header ,title)))
        (layouts:simple
               (components:head :title ,title :mathjax ,mathjax :icon-path icon-path
                                :extra-styles '("/styles/asciidoc.css"))
               (:body 
                 (components:navbar)
                 (:h1 header)
                 (:hr)
                 ,@body))))

(defmacro page ((&key title header icon-file) &body body)
 `(let* ((icon-file (or ,icon-file "computer.gif"))
         (icon-path (format nil "/assets/~a" icon-file))
         (header (or ,header ,title)))
        (layouts:simple
               (components:head :title ,title :icon-path icon-path
                                :extra-styles '("/styles/asciidoc.css"))
               (:body
                 (components:navbar)
                 (components:gif-header header icon-path)
                 ,@body))))
