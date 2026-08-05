(defpackage #:cardgen
  (:use #:cl))
(in-package #:cardgen)

(ensure-directories-exist "build/cards/")
(defparameter *out-dir* (truename "build/cards/"))

(defparameter *wiki-dir* (uiop:getenv-pathname "WIKI" :ensure-directory t))

; STEPS:
;; 1. Go through wiki files and index the ones with publish set, keeping their metadata
;;    and their body
;; 2. Render each of those bodies and wrap it in the card layout

;; hash table indexed by relative path
(defparameter *data* (make-hash-table :test #'equal))

(defun wiki-path->rel-path (wiki-path)
  (uiop:enough-pathname wiki-path *wiki-dir*))

(defun index-wiki-file (path)
  (if (equal (pathname-type path) "md")
    (let ((raw (uiop:read-file-string path)))
      (multiple-value-bind (yaml body) (utils:split-frontmatter raw)
        (let ((meta (if yaml
                      (cl-yy:yaml-simple-load yaml)
                      (make-hash-table))))
          (when (gethash "publish" meta)
            (let* ((rel-path (wiki-path->rel-path path))
                   (file-name (pathname-name path))
                   (title (gethash "title" meta file-name))
                   (header (gethash "header" meta title)))
                  (format t "indexing ~a~%" rel-path)
                  (setf (gethash rel-path *data*)
                        (list
                          :title title
                          :header header
                          :body body
                          :mathjax (when (gethash "mathjax" meta) t))))))))))

(defun card-to-page (rel-path out-dir)
  (let* ((out-path (make-pathname :type "html" :defaults (merge-pathnames rel-path out-dir)))
         (card (gethash rel-path *data*))
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
              (:raw (markdown:render (getf card :body))))))))

(defun main ()
  ;; index each file and read its metadata
  (utils:walk *wiki-dir* 'index-wiki-file)

  ;; render each indexed note as a full page
  (loop for rel-path being each hash-key of *data* do (card-to-page rel-path *out-dir*))

  ;; copying assets directory
  (let ((wiki-assets-dir (merge-pathnames "assets/" *wiki-dir*))
        (out-assets-dir (merge-pathnames "assets/" *out-dir*)))
    (format t "wiki-assets-dir: ~a~%" wiki-assets-dir)
    (format t "out-assets-dir: ~a~%" out-assets-dir)
    (uiop:run-program (list "cp" "-r" (namestring wiki-assets-dir) (namestring out-assets-dir)))))

(main)
