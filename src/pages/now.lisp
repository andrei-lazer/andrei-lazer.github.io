(defpackage #:pages/now
  (:use #:cl)
  (:export #:render))


(defun pages/now:render ()
  (let* ((raw (uiop:read-file-string #p"src/data/now.md")))
    (layouts/main:html5
      (:title "now" :icon-file "jellyfish.gif")
      (:raw (data/cards/main:md->html raw)))))
