(defpackage #:pages/email
  (:use #:cl)
  (:export #:render))

(defun pages/email:render ()
  (sta6:html5
    (:head 
      (:title "email") 
      (:meta :charset "UTF-8")
      (:link :rel "stylesheet" :href "/styles/style.css")
      (:link :rel "stylesheet" :href "/styles/email.css")
      (:link :rel "icon" :href "/assets/mail.gif" :type "image/gif"))
    (:div :id "email" 
          (:img :class "gif" :src "/assets/mail.gif" :alt "mail.gif")
          (:a :href "mailto:andrei.lucian.lazer@gmail.com" "andrei.lucian.lazer@gmail.com"))
    (:a :href "/" "go home")))

