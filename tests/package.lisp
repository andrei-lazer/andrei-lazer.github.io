(defpackage #:app-tests
  (:use #:cl #:fiveam)
  (:export #:run-tests #:run-all-tests! #:all))
(in-package #:app-tests)

(def-suite all
  :description "every test for the site generator")

(defun fixture-path (relative)
  "resolves a path underneath tests/fixtures/, wherever the system happens to be checked out"
  (asdf:system-relative-pathname :app (merge-pathnames relative #p"tests/fixtures/")))

(defun fixture-wiki ()
  (fixture-path #p"wiki/"))

(defmacro with-temp-dir ((var) &body body)
  "runs body with var bound to a fresh empty directory, removed again afterwards"
  `(let ((,var (merge-pathnames (format nil "app-tests-~a/" (random (expt 2 64)))
                                (uiop:temporary-directory))))
     (ensure-directories-exist ,var)
     (unwind-protect (progn ,@body)
       (uiop:delete-directory-tree ,var :validate t :if-does-not-exist :ignore))))

(defmacro quietly (&body body)
  "swallows the progress logging the generator writes as it works"
  `(let ((*standard-output* (make-broadcast-stream)))
     ,@body))

(defun files-of-type (dir type)
  "every file underneath dir with the given extension, recursively"
  (let ((found '()))
    (utils:walk dir (lambda (p) (when (equal (pathname-type p) type) (push p found))))
    found))

(defun render-to-string (thunk)
  "captures whatever a spinneret rendering function writes"
  (with-output-to-string (out)
    (let ((spinneret:*html* out))
      (funcall thunk))))

(defmacro rendering (&body body)
  `(render-to-string (lambda () ,@body)))

(defun contains (needle haystack)
  "substring test, so that assertions do not depend on spinneret's line wrapping"
  (and (search needle haystack) t))

(defun count-substring (needle haystack)
  (loop with step = (max 1 (length needle))
        for start = 0 then (+ found step)
        for found = (search needle haystack :start2 start)
        while found
        count 1))

(defun index-of (needle haystack)
  (search needle haystack))

(defun collapse-whitespace (string)
  "spinneret pretty prints and wraps attributes across lines, so tests that care about a
   run of markup normalise the whitespace inside it first"
  (string-trim " " (cl-ppcre:regex-replace-all "\\s+" string " ")))

(defun run-tests ()
  "runs every suite and returns true when they all pass"
  (and (run! 'all) t))

(defun run-all-tests! ()
  "entry point for asdf test-op, which reports failure by signalling"
  (unless (run-tests)
    (error "test suite failed"))
  t)
