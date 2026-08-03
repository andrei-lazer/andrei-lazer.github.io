; ;; Converts cards from the wiki at $WIKI to things here!
; ; (defparameter *my-tmp-path* (merge-pathnames "asciidoc-output" (uiop:temporary-directory)))
;
;
; (defpackage #:cardgen
;   (:use #:cl))
; (in-package #:cardgen)
;
; (defparameter *embed-dir* "tmp/")
; (ensure-directories-exist *embed-dir*)
; (defparameter *embed-dir* (truename "tmp/"))
;
; (defparameter *out-dir* (truename "build/cards/"))
;
; (let ((home-path (uiop:getenv-pathname "HOME" :ensure-directory t)))
;      (defparameter *wiki-dir* (or (uiop:getenv "WIKI") (merge-pathnames "wiki/" home-path))))
; (defparameter *asciidoctor-wiki-command* 
;   (format nil "asciidoctor -a skip-front-matter -a relfileprefix=/cards/ -a imagesdir=/cards/assets/ -e -R ~a -D ~a '~a/**/*.adoc'"
;           *wiki-dir* *embed-dir* *wiki-dir*))
;
; (format t "command: ~a~%" *asciidoctor-wiki-command*)
;
; ;; goes through directory and 
; (defun walk (dir fn)
;   (mapc fn (uiop:directory-files dir))
;   (mapc (lambda (d) (walk d fn)) (uiop:subdirectories dir)))
;
; (defun generate-out-path-for-wiki (in-path)
;   (let* ((rel-in-path (uiop:enough-pathname in-path *embed-dir*))
;          (out-path (merge-pathnames rel-in-path *out-dir*)))
;         (ensure-directories-exist out-path)
;         out-path))
;
; (defun embed-path-to-wiki-path (path)
;   (let ((out (merge-pathnames (uiop:enough-pathname (make-pathname :type "adoc" :defaults path) *embed-dir*) *wiki-dir*)))
;        out))
;
;
; (defun convert-card-embed (path)
;   (let* ((out-path (generate-out-path-for-wiki path))
;          (raw (uiop:read-file-string (embed-path-to-wiki-path path)))
;          (yaml (utils:split-frontmatter raw))
;          (meta (when yaml (cl-yy:yaml-simple-load yaml))))
;        (if (gethash "publish" meta)
;          (progn
;            ; (format t "adding ~a at path ~a~%" (pathname-name path) out-path)
;            (with-open-file (out out-path :direction :output
;                               :if-exists :supersede
;                               :if-does-not-exist :create
;                               :external-format :utf-8)
;               (let* ((spinneret:*html* out)
;                      (html-embed (uiop:read-file-string path)))
;                 (layouts:card 
;                   (:title (gethash "title" meta)
;                    :header (gethash "header" meta)
;                    :mathjax (gethash "mathjax" meta))
;                   (:raw html-embed))))))))
;
; (defun main ()
;   ;; creates directory with all the html embeds (no heads or anything)
;   (format t "generating cards...~%")
;   (uiop:run-program *asciidoctor-wiki-command*)
;   (let ((wiki-assets-dir (merge-pathnames "assets/" *wiki-dir*))
;         (out-assets-dir (merge-pathnames "assets/" *out-dir*)))
;     (format t "wiki-assets-dir: ~a~%" wiki-assets-dir)
;     (format t "out-assets-dir: ~a~%" out-assets-dir)
;     (uiop:run-program (list "cp" "-r" (namestring wiki-assets-dir) (namestring out-assets-dir))))
;   (utils:walk *embed-dir* 'convert-card-embed))
;
; (main)
