(defpackage #:app
  (:use #:cl)
  (:export #:main #:*build-dir* #:*src-dir* #:*page-dir* #:*script-dir*))
(in-package #:app)


;; all four are relative to the working directory the build is started from, and are
;; resolved (and created) in main rather than at load time, so that merely loading the
;; system has no effect on the filesystem. rebind them to build somewhere else
(defparameter *build-dir* #p"build/")
(defparameter *src-dir* #p"src/")
(defparameter *page-dir* #p"src/pages/")
(defparameter *script-dir* #p"src/scripts/")

(defparameter *asciidoctor-stub* 
  (format nil "asciidoctor -a skip-front-matter -a relfileprefix=/ -e -o -"))

(defun generate-asciidoctor-file (in-path)
  (format nil "~a ~a" *asciidoctor-stub* in-path))

(defun asciidoc-file->html-embed (file-path)
  (uiop:run-program (generate-asciidoctor-file file-path) :output :string))

(defun file->html (file-path body->html-embed)
  ;; body->html-embed turns the file's body (frontmatter stripped) into a html fragment,
  ;; which is then wrapped in the page layout using the yaml frontmatter as metadata
  (let ((raw (uiop:read-file-string file-path)))
    (multiple-value-bind (yaml body) (utils:split-frontmatter raw)
      (let* ((meta (if yaml (cl-yy:yaml-simple-load yaml) (make-hash-table :test 'equal)))
             (html-embed (funcall body->html-embed body)))
            (layouts:page
              (:title (gethash "title" meta)
               :header (gethash "header" meta)
               :icon-file (gethash "icon" meta "computer.gif"))
              (:raw html-embed))))))

(defun asciidoc-file->html (file-path)
  ;; asciidoctor reads the file itself and skips the frontmatter, so the body is ignored here
  (file->html file-path (lambda (body)
                          (declare (ignore body))
                          (asciidoc-file->html-embed file-path))))

(defun markdown-file->html (file-path)
  ;; pages link to each other by their final url already, so no link rewriting here
  (file->html file-path #'markdown:render))

(defun write-html-file (path render-fn)
  ;; render-fn takes path and writes its html to the spinneret:*html* stream
  ;; name must have no file ending (for example "links", not "links.md" or "links.lisp")
  (with-open-file (out (utils:generate-out-path path *page-dir* *build-dir*) :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create
                     :external-format :utf-8)
    (let ((spinneret:*html* out))
      (funcall render-fn path))))

(defun convert-asciidoc-file (path)
  (write-html-file path #'asciidoc-file->html))

(defun convert-markdown-file (path)
  (write-html-file path #'markdown-file->html))

(defun convert-html-file (path)
  (uiop:copy-file path (utils:generate-out-path path *page-dir* *build-dir*)))

(defun convert-lisp-file (path)
  ;; expecting something that ONLY modifies the spinneret:*html* variable. Any other
  ;; namespace modification is not supported and could break things.
  (write-html-file path #'load))

(defun dispatch (path)
  (format t "dispatching ~a~%" (uiop:enough-pathname path *page-dir*))
  (cond
    ((equal (pathname-type path) "adoc") (convert-asciidoc-file path))
    ((equal (pathname-type path) "md") (convert-markdown-file path))
    ((equal (pathname-type path) "html") (convert-html-file path))
    ((equal (pathname-type path) "lisp") (convert-lisp-file path))))
  
(defun walk-and-convert ()
  (utils:walk *page-dir* 'dispatch))

(defun run-all-scripts ()
  ;; only source files, so that a stale .fasl sitting next to a script is not loaded
  (mapc 'load (remove-if-not (lambda (p) (equal (pathname-type p) "lisp"))
                             (uiop:directory-files *script-dir*))))

(defun main ()
  (let* ((*build-dir* (ensure-directories-exist
                        (uiop:ensure-absolute-pathname *build-dir* #'uiop:getcwd)))
         (*src-dir* (uiop:ensure-absolute-pathname *src-dir* #'uiop:getcwd))
         (*page-dir* (uiop:ensure-absolute-pathname *page-dir* #'uiop:getcwd))
         (*script-dir* (uiop:ensure-absolute-pathname *script-dir* #'uiop:getcwd)))
        (walk-and-convert)
        (run-all-scripts)))
