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
    (multiple-value-bind (meta body) (utils:read-document path)
      (when (published-p meta)
        ;; a note need not name itself: the file name is a good enough title, and a note
        ;; that does not want a separate header just reuses its title
        (let* ((title (gethash "title" meta (pathname-name path)))
               (header (gethash "header" meta title)))
              (list :title title
                    :header header
                    :body body
                    :mathjax (when (gethash "mathjax" meta) t)))))))

(defun index-wiki (wiki-dir)
  "walks wiki-dir and returns a hash table of every published note, keyed by the note's
   path relative to wiki-dir"
  (utils:index-directory wiki-dir #'read-card))

(defun card-out-path (rel-path out-dir)
  (make-pathname :type "html" :defaults (merge-pathnames rel-path out-dir)))

(defun card->page (rel-path card out-path)
  "renders one indexed note as a full html page at out-path. the out-path's directory
   must already exist; creating directories is generate-cards' job, not a renderer's"
  (let (;; notes link to each other (and to their images) by relative file name
        (markdown:*link-prefix* "/cards/")
        (markdown:*link-dir* (make-pathname :directory (pathname-directory rel-path))))
       (utils:write-html out-path
         (lambda ()
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
      (uiop:run-program (list "cp" "-r" "-T"
                              (namestring wiki-assets-dir)
                              (namestring out-assets-dir))))))

(defun do-job (rel-path card out-path)
  (ensure-directories-exist out-path) ;; mkdir is thread safe (as long as we don't care about failures)
  (card->page rel-path card out-path))
  
(defparameter *errors* '())
(defparameter *errors-lock* (bt:make-lock))

(defun try-job (job)
  "wraps error handling around the job so that all errors aren't asynchronously
  printed to stdout. assumes the job is passed as '(fn arg1 arg2 ... argn)"
  (handler-case (apply (first job) (rest job))
    (error (e)
      (bt:with-lock-held (*errors-lock*)
        (push e *errors*)))))

(defun generate-cards (wiki-dir out-dir)
  "the only place in the build that creates directories. every note's output
  directory is made up front, before any rendering happens, so the renderers
  can write blind"
  (let* ((index (index-wiki wiki-dir))
         (out-paths (loop for rel-path being each hash-key of index
                          collect (card-out-path rel-path out-dir))))
    (ensure-directories-exist out-dir)
    (let* ((jobs (loop for rel-path being each hash-key of index using (hash-value card)
                       for out-path in out-paths
                       collect `(do-job ,rel-path ,card ,out-path)))
           (handles (mapcar (lambda (job)
                              (bt:make-thread (lambda () (try-job job))))
                            jobs)))
        
      (mapc #'bt:join-thread handles))

    (dolist (e *errors*)
      (format *error-output* "~&~a~%" e))

    ;; make sure assets dir exists and copy it over
    (when (uiop:directory-exists-p (merge-pathnames "assets/" wiki-dir))
      (ensure-directories-exist (merge-pathnames "assets/" out-dir)))
    (copy-assets wiki-dir out-dir)
    index))
