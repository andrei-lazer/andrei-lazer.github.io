(defpackage #:layouts
  (:use #:cl)
  (:export #:simple #:card #:page))

(in-package #:layouts)

;; COMPONENTS
(defun head (&key title mathjax icon-path extra-styles)
  ;; extra-styles is a list of stylesheet urls loaded after the site wide one, for pages
  ;; that need something on top of it
  (spinneret:with-html 
    (:head 
      (:title title) 
      (:meta :charset "UTF-8")
      (:meta :name "viewport" :content "width=device-width, initial-scale=1")
      (when mathjax
        (:script :id "MathJax-script" :async t
         :src "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"))
      (:link :rel "stylesheet" :href "/style/style.css")
      (dolist (href extra-styles)
        (:link :rel "stylesheet" :href href))
      (:link :rel "icon" :href icon-path :type "image/gif"))))
  

(defun navbar ()
  (spinneret:with-html
    (:nav 
      (:a :href "/" "home")
      (:a :href "/now" "now")
      (:a :href "/cards" "cards")
      (:a :href "/links" "links")
      (:a :href "/email" "email"))))

(defun gif-header (text icon-path)
  (spinneret:with-html
    (:div :id "gif-header"
          (:img :src icon-path :alt icon-path :class "gif")
          (:span :id "header-text" text))))

;; LAYOUTS
(defmacro simple (&body body)
  `(with-output-to-string (spinneret:*html*)
     (spinneret:with-html
       (:doctype)
       (:html
         ,@body))))

(defun card (&key html meta)
  (let* ((title (or (gethash "title" meta) ""))
         (icon-file (or (gethash "icon" meta) "computer.gif"))
         (icon-path (format nil "/assets/~a" icon-file))
         (header (or (gethash "header" meta) title))
         (mathjax (gethash "mathjax" meta)))
        (simple
          (head
            :title title :mathjax mathjax :icon-path icon-path :extra-styles '("style/markdown.css"))
          (:body 
            (navbar)
            (:h1 header)
            (:hr)
            (:raw html)))))

(defun page (&key html meta)
  (let* ((title (or (gethash "title" meta) ""))
         (icon-file (or (gethash "icon" meta) "computer.gif"))
         (icon-path (format nil "/assets/~a" icon-file))
         (header (or (gethash "header" meta) title))
         (mathjax (gethash "mathjax" meta)))
        (simple
          (head
            :title title :mathjax mathjax :icon-path icon-path :extra-styles nil)
          (:body 
            (navbar)
            (gif-header header icon-path)
            (:raw html)))))
