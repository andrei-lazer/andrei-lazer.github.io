(defpackage #:components/main
  (:use #:cl)
  (:export 
    #:navbar
    #:card-preview
    #:gif-header))

; title and header are optional. if title not set, it is nil. if 
; header not set, it is equal to title.
(defun components/main:navbar ()
  (sta6:html
    (:nav 
      (:a :href "/" "home")
      (:a :href "/now" "now")
      (:a :href "/cards" "cards")
      (:a :href "/links" "links")
      (:a :href "/email" "email"))))


(defun components/main:gif-header (text icon-path)
  (sta6:html
    (:div :id "gif-header"
          (:img :src icon-path :alt icon-path :class "gif")
          (:span :id "header-text" text))))
    
