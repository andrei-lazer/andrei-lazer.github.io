(defpackage #:app
  (:use #:cl)
  (:export #:main))
(in-package #:app)


(let ((rel-build-dir #p"build/"))
  (ensure-directories-exist rel-build-dir)
  (defparameter *build-dir* (truename rel-build-dir)))
  

(defparameter *pwd* (uiop:getcwd))
(defparameter *src-dir* (truename #p"src/"))
(defparameter *page-dir* (truename #p"src/pages/"))
(defparameter *script-dir* (truename #p"src/scripts"))

(defparameter *asciidoctor-stub* 
  (format nil "asciidoctor -a skip-front-matter -a relfileprefix=/ -e -o -"))

(defun generate-asciidoctor-file (in-path)
  (format nil "~a ~a" *asciidoctor-stub* in-path))

(defun asciidoc-file->html-embed (file-path)
  (uiop:run-program (generate-asciidoctor-file file-path) :output :string))

(defun asciidoc-file->html (file-path)
  (let* ((html-embed (asciidoc-file->html-embed file-path))
         (raw (uiop:read-file-string file-path)))
        (multiple-value-bind (yaml body) (utils:split-frontmatter raw)
          (let* ((meta (when yaml (cl-yy:yaml-simple-load yaml)))) 
                (layouts:page
                  (:title (gethash "title" meta)
                   :header (gethash "header" meta)
                   :icon-file (gethash "icon" meta "computer.gif"))
                  (:raw html-embed))))))

(defun asciidoc-file->html-file (in-path out-path)
  ;; name must have no file ending (for example "links", not "links.adoc" or "links.lisp")
  (with-open-file (out out-path :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create
                     :external-format :utf-8)
    (let ((spinneret:*html* out))
      (asciidoc-file->html in-path))))

(defun convert-asciidoc-file (path)
  (asciidoc-file->html-file path (utils:generate-out-path path *page-dir* *build-dir*)))

(defun convert-html-file (path)
  (uiop:copy-file path (utils:generate-out-path path *page-dir* *build-dir*)))

(defun convert-lisp-file (path)
  ;; expecting something that ONLY modifies the spinneret:*html* variable. Any other
  ;; namespace modification is not supported and could break things.
  (with-open-file (out (utils:generate-out-path path *page-dir* *build-dir*) :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create
                     :external-format :utf-8)
    (let ((spinneret:*html* out))
      (load path))))
         
(defun dispatch (path)
  (format t "dispatching ~a~%" (uiop:enough-pathname path *page-dir*))
  (cond
    ((equal (pathname-type path) "adoc") (convert-asciidoc-file path))
    ((equal (pathname-type path) "html") (convert-html-file path))
    ((equal (pathname-type path) "lisp") (convert-lisp-file path))))
  
(defun walk-and-convert ()
  (utils:walk *page-dir* `dispatch))

(defun run-all-scripts ()
  (mapc 'load (uiop:directory-files *script-dir*)))
  
(defun main ()
  (walk-and-convert)
  (run-all-scripts))

