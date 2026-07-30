(defpackage #:pages/now
  (:use #:cl)
  (:export #:render))

(defun pages/now:render ()
  (layouts/main:html5
    (:title "now" :icon-file "jellyfish.gif")
    (:p "This is my now page!")))
