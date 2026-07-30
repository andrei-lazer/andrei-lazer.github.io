(defpackage #:pages/cards/page
  (:use #:cl)
  (:export #:render))

(format t "number of hash entries: ~a~%" (hash-table-count data/cards/main:+by-slug+))
(format t "number of data entries: ~a~%" (length data/cards/main:+data+))

(defun card-list (category)
  (format *error-output* "generating card list for category ~a~%" category)
  (sta6:html
    (:h2 category)
    (:ul
      (loop for slug being the hash-keys of data/cards/main:+by-slug+ 
            using (hash-value card) 
            for meta = (getf card :meta)
            when (and meta (member category (gethash "tags" meta) :test #'string=))
            do
            (format *error-output* "~tadding slug ~a~%" slug)
            (let* ((date (when meta (gethash "date" meta))))
              (:li (when date (format nil "[~a]" date)) " " (:a :href (format nil "/cards/~a/" slug) (getf card :title))))))))

(defun pages/cards/page:render ()
  (layouts/main:html5
    (:title "cards" :icon-file "quill.gif")
    (:p " This is a collection of notes and projects. Calling them cards is
        inspired by " (:a :href "https://ratfactor.com/cards/" "Dave's Virtual
        Box of Cards") ". Many of these will be incomplete and full of
        dead ends.")
    (card-list "computing")
    (card-list "maths")))
