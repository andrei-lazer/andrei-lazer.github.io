(defpackage #:cardgen
  (:use #:cl))
(in-package #:cardgen)

(defparameter *tmp-dir* "tmp/")
(ensure-directories-exist *tmp-dir*)
(defparameter *tmp-dir* (truename "tmp/"))

(defparameter *out-dir* (truename "build/cards"))

(defparameter *wiki-dir* (uiop:getenv-pathname "WIKI" :ensure-directory t))

; STEPS:
;; 1. Go through wiki files and add paths to list if publish is set, as well as adding their metadata
;; 2. Run asciidoc with -R on each of those files and put in a tmp directory (with -e)
;; 3. Process those embeds into proper posts.

;; hash table indexed by relative path
(defparameter *data* (make-hash-table :test #'equal))

(defun wiki-path->rel-path (wiki-path)
  (uiop:enough-pathname wiki-path *wiki-dir*))

(defun index-wiki-file (path)
  (if (equal (pathname-type path) "adoc")
    (let* ((raw (uiop:read-file-string path))
           (yaml (utils:split-frontmatter raw))
           (meta (if yaml 
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
                          :absolute-path path
                          :mathjax (when (gethash "mathjax" meta) t))))))))

(defun run-asciidoc (paths)
  (let ((command 
         (append (list "asciidoctor" "-a" "skip-front-matter"
                       "-a" "relfileprefix=/cards/"
                       "-a" "imagesdir=/cards/assets/"
                       "-a" "outfilesuffix=.html"
                       "-e" "-R" (namestring *wiki-dir*)
                       "-D" (namestring *tmp-dir*))
                 (mapcar #'namestring paths))))
    (uiop:run-program command)))

(defun stub-to-page (rel-path tmp-dir out-dir)
  (let* ((tmp-path (make-pathname :type "html" :defaults (merge-pathnames rel-path tmp-dir)))
         (out-path (make-pathname :type "html" :defaults (merge-pathnames rel-path out-dir)))
         (stub-html (uiop:read-file-string tmp-path))
         (meta (gethash rel-path *data*)))
        (ensure-directories-exist out-path)
        (with-open-file (out out-path :direction :output
                           :if-exists :supersede
                           :if-does-not-exist :create
                           :external-format :utf-8)
          (let ((spinneret:*html* out))
            (layouts:card
              (:title (getf meta :title)
               :header (getf meta :header)
               :mathjax (getf meta :mathjax))
              (:raw stub-html))))))                            



(defun main ()
  ;; index each file and read its metadata
  (utils:walk *wiki-dir* 'index-wiki-file) 
  ;; use asciidoc to make html stubs
  (let ((paths (loop for v being the hash-values of *data* collect (getf v :absolute-path))))
    (run-asciidoc paths))

  ;; convert stubs into full pages
  (loop for rel-path being each hash-key of *data* do (stub-to-page rel-path *tmp-dir* *out-dir*))

  ;; copying assets directory
  (let ((wiki-assets-dir (merge-pathnames "assets/" *wiki-dir*))
        (out-assets-dir (merge-pathnames "assets/" *out-dir*)))
    (format t "wiki-assets-dir: ~a~%" wiki-assets-dir)
    (format t "out-assets-dir: ~a~%" out-assets-dir)
    (uiop:run-program (list "cp" "-r" (namestring wiki-assets-dir) (namestring out-assets-dir)))))
  

(main)
