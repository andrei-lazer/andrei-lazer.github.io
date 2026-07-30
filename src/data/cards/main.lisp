;;;; Convert markdown files into lisp plists that can then be rendered.
(defpackage #:data/cards/main
  (:use #:cl)
  (:export #:+by-slug+ #:+data+ #:md->html))

;;splits yaml frontmatter from markdown file
(defun split-frontmatter (text)
  ;; splits into lines
  (let ((lines (uiop:split-string text :separator '(#\Newline))))
    ;; checks if first line starts with a --- 
    (if (string= (string-right-trim " " (first lines)) "---")
      ;; end is the line number of the next --- (the end of the front matter)
      ;; the test function ignores whitespace on the right
        (let* ((test-f (lambda (a b) (string= a (string-right-trim " " b))))
               (end (position "---" (rest lines) :test test-f)))
          (if end
              (values (format nil "~{~a~^~%~}" (subseq (rest lines) 0 end))
                      (format nil "~{~a~^~%~}" (nthcdr (+ end 2) lines)))
              (values nil text)))
        (values nil text))))

;; simple slugify - lowercase and replaces spaces with -
(defun slugify (s)
  (substitute #\- #\Space (string-downcase s)))


;;
(defun convert-image-wikilinks (md)
  (cl-ppcre:regex-replace-all "!\\[\\[([^\\]]*)\\]\\]" md "![](\\1)"))

;; fixes spaces in image names
(defun fix-image-spaces (md)
  (cl-ppcre:regex-replace-all
   "!\\[([^\\]]*)\\]\\(([^)]*)\\)" md
   (lambda (match alt src)
     (declare (ignore match))
     (format nil "![~a](/assets/~a)" alt (cl-ppcre:regex-replace-all " " src "%20")))
   :simple-calls t))


;; converts wikilinks to html links - assumes all files are in a flat structure in /cards/
(defmethod 3bmd-wiki:process-wiki-link ((w (eql :cards)) normalized formatted args stream)
  (declare (ignore w))
  (let ((slug (slugify normalized)))
    (if `(gethash ,slug data/cards/main:+by-slug+)
        (format stream "<a href=\"/cards/~a/\">~a</a>" slug (or (first args) formatted))
        (format stream "<span class=\"broken-link\">~a</span>" formatted))))

;; md->html converter with a bunch of addons to suppose maths, code blocks, wikilinks, and tables.
(defun data/cards/main:md->html (md)
  (let ((3bmd:*smart-quotes* t)
        (3bmd-code-blocks:*code-blocks* t)
        (3bmd-math:*math* t)
        (3bmd-wiki:*wiki-links* t)
        (3bmd-tables:*tables* t)
        (3bmd-wiki:*wiki-processor* :cards))
    (with-output-to-string (s)
      (3bmd:parse-string-and-print-to-stream (fix-image-spaces (convert-image-wikilinks md)) s))))

;; for debug purposes
(defmethod print-object ((object hash-table) stream)
  (format stream "#HASH{~{~{(~a : ~a)~}~^ ~}}"
          (loop for key being the hash-keys of object
                using (hash-value value)
                collect (list key value))))

;; automatically generating the raw data from markdown files. allows more
;; data to be generated and added further down the line without modifying
;; render code
(format t "starting to index cards")
(defparameter data/cards/main:+data+ 
  (let* ((md-test (lambda (p) (string= (pathname-type p) "md")))
         (all-paths (uiop:directory-files #p"src/data/cards/"))
         (paths (remove-if-not md-test all-paths)))
        (loop for path in paths
              ;; collect lets loop act like a list comprehension
              collect 
              (let* ((title (pathname-name path))
                     (raw (uiop:read-file-string path)))
                    ;; AFAIK I have to do this strange double-let thing because
                    ;; multiple-value-bind doesn't fit in a let. I'm sure
                    ;; there's a cleaner way to do this, but I don't know it.
                    (multiple-value-bind (yaml body) (split-frontmatter raw)
                      (let* ((meta (when yaml (cl-yy:yaml-simple-load yaml))))
                            ;; this is the actual output per path - a plist
                            (format t "~tindexing ~a~%" title)
                            (list
                              ; if there's no title specified in the metadata, just use the file name
                              :title (or (when meta (gethash "title" meta)) title)
                              :meta (when meta meta)
                              :content (data/cards/main:md->html body))))))))

;; returns date (as a string) if it exists,
;; otherwise nil
(defun get-card-date (card)
  (let ((meta (getf card :meta)))
      (when meta (gethash "date" meta))))
      
;; sorts based on date. if no date, "0" is the date (so oldest possible date). Only
;; works in Y-M-D format, since it uses string comparisons.

(setf data/cards/main:+data+ (sort data/cards/main:+data+ #'string> :key (lambda (card) (or (get-card-date card) "0"))))

;; slugifies the data and turns it into a hash table for easy access
(defparameter data/cards/main:+by-slug+
  (let ((h (make-hash-table :test #'equal)))
    (dolist (p data/cards/main:+data+ h)
      (setf (gethash (slugify (getf p :title)) h) p))))
