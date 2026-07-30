(defpackage #:pages/cards/+slug+/page
  (:use #:cl)
  (:export #:render #:routes))


(defun pages/cards/+slug+/page:routes ()
  (loop for k being the hash-keys of data/cards/main:+by-slug+ collect k))

(defun pages/cards/+slug+/page:render (slug)
    (let* ((card (gethash slug data/cards/main:+by-slug+))
           (title (getf card :title))
           (meta (getf card :meta))
           (mathjax (when meta (gethash "mathjax" meta)))
           (content (getf card :content)))
      (layouts/main:card
          (:title title :mathjax mathjax :icon-file "quill.gif")
          (:raw content))))
