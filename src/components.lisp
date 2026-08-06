(defpackage #:components
  (:use cl)
  (:export #:navbar #:head #:gif-header))

(in-package #:components)

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
      (:link :rel "stylesheet" :href "/styles/style.css")
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
