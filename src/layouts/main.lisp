(defpackage #:layouts/main
  (:use #:cl)
  (:export #:html5
           #:main-page
           #:card))

; title and header are optional. if title not set, it is nil. if 
; header not set, it is equal to title.

(defmacro layouts/main:html5 ((&key title (header title) mathjax (icon-file "computer.gif")) &body body)
  (let ((icon-path (format nil "/assets/~a" icon-file)))
    `(sta6:html5
      (:head 
        (:title ,title) 
        (:meta :charset "UTF-8")
        (when ,mathjax
          (:script :id "MathJax-script" :async t
           :src "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"))
        (:link :rel "stylesheet" :href "/styles/style.css")
        (:link :rel "icon" :href ,icon-path :type "image/gif"))
      (components/main:navbar)
      (components/main:gif-header ,header ,icon-path)
      ,@body)))

(defmacro layouts/main:card ((&key title (header title) mathjax (icon-file "computer.gif")) &body body)
  (let ((icon-path (format nil "/assets/~a" icon-file)))
    `(sta6:html5
      (:head 
        (:title ,title) 
        (:meta :charset "UTF-8")
        (when ,mathjax
          (:script :id "MathJax-script" :async t
           :src "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"))
        (:link :rel "stylesheet" :href "/styles/style.css")
        (:link :rel "icon" :href ,icon-path :type "image/gif"))
      (components/main:navbar)
      (:h1 ,header)
      ,@body)))
