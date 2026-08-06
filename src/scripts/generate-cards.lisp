;; publishes the notes marked with `publish` in the wiki pointed at by $WIKI. the work
;; itself lives in src/cards.lisp; this file only supplies the two directories

(let ((wiki-dir (uiop:getenv-pathname "WIKI" :ensure-directory t))
      (out-dir (merge-pathnames "cards/" app:*build-dir*)))
  (if wiki-dir
      (cards:generate-cards wiki-dir out-dir)
      (format t "WIKI is not set, skipping cards~%")))
