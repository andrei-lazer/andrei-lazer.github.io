(defpackage #:components
  (:use cl)
  (:export #:navbar #:head #:gif-header))

(in-package #:components)

(defun head (&key title mathjax icon-path)
  (spinneret:with-html 
    (:head 
      (:title title) 
      (:meta :charset "UTF-8")
      (when mathjax
        (:script :id "MathJax-script" :async t
         :src "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"))
      (:link :rel "stylesheet" :href "/styles/style.css")
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
