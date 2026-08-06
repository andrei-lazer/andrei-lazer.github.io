(defpackage #:cards
  (:use #:cl)
  (:export
    #:read-card
    #:index-wiki
    #:card-out-path
    #:card->page
    #:copy-assets
    #:generate-cards))
(in-package #:cards)

;; cards are the notes from a personal wiki that have been marked for publication. this
;; file only knows how to turn such a wiki into a directory of html pages: which wiki and
;; which output directory are passed in, so nothing here depends on the process working
;; directory or on the environment

(defun published-p (meta)
  (gethash "publish" meta))

(defun read-card (path)
  "reads a wiki note and returns a plist of its metadata and body, or nil if the file is
   not a markdown note or is not marked for publication"
  (when (equal (pathname-type path) "md")
    (multiple-value-bind (yaml body) (utils:split-frontmatter (uiop:read-file-string path))
      (let ((meta (if yaml (cl-yy:yaml-simple-load yaml) (make-hash-table :test 'equal))))
        (when (published-p meta)
          ;; a note need not name itself: the file name is a good enough title, and a note
          ;; that does not want a separate header just reuses its title
          (let* ((title (gethash "title" meta (pathname-name path)))
                 (header (gethash "header" meta title)))
                (list :title title
                      :header header
                      :body body
                      :mathjax (when (gethash "mathjax" meta) t))))))))

(defun index-wiki (wiki-dir)
  "walks wiki-dir and returns a hash table of every published note, keyed by the note's
   path relative to wiki-dir"
  (let ((index (make-hash-table :test #'equal)))
    (utils:walk wiki-dir
                (lambda (path)
                  (let ((card (read-card path)))
                    (when card
                      (let ((rel-path (uiop:enough-pathname path wiki-dir)))
                        (format t "indexing ~a~%" rel-path)
                        (setf (gethash rel-path index) card))))))
    index))

(defun card-out-path (rel-path out-dir)
  (make-pathname :type "html" :defaults (merge-pathnames rel-path out-dir)))

(defun card->page (rel-path card out-dir)
  "renders one indexed note as a full html page underneath out-dir"
  (let ((out-path (card-out-path rel-path out-dir))
        ;; notes link to each other (and to their images) by relative file name
        (markdown:*link-prefix* "/cards/")
        (markdown:*link-dir* (make-pathname :directory (pathname-directory rel-path))))
       (ensure-directories-exist out-path)
       (with-open-file (out out-path :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create
                          :external-format :utf-8)
         (let ((spinneret:*html* out))
           (layouts:card
             (:title (getf card :title)
              :header (getf card :header)
              :mathjax (getf card :mathjax))
             (:raw (markdown:render (getf card :body))))))
       out-path))

(defun copy-assets (wiki-dir out-dir)
  (let ((wiki-assets-dir (merge-pathnames "assets/" wiki-dir))
        (out-assets-dir (merge-pathnames "assets/" out-dir)))
    (when (uiop:directory-exists-p wiki-assets-dir)
      (ensure-directories-exist out-assets-dir)
      (uiop:run-program (list "cp" "-r" "-T"
                              (namestring wiki-assets-dir)
                              (namestring out-assets-dir))))))

(defun generate-cards (wiki-dir out-dir)
  (let ((index (index-wiki wiki-dir)))
    (ensure-directories-exist out-dir)
    (loop for rel-path being each hash-key of index using (hash-value card)
          do (card->page rel-path card out-dir))
    (copy-assets wiki-dir out-dir)
    index))
