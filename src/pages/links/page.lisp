(defpackage #:pages/links/page
  (:use #:cl)
  (:export #:render))


(defun pages/links/page:render ()
  (let* ((raw (uiop:read-file-string #p"src/data/links.md")))
    (layouts/main:html5
      (:title "links" :icon-file "mouse.gif")
      (:raw (data/cards/main:md->html raw)))))
