(in-package #:app-tests)

(def-suite utils :in all :description "frontmatter splitting, output paths and directory walking")
(in-suite utils)

;;; split-frontmatter

(test frontmatter-absent
  "a file that does not open with --- is all body"
  (multiple-value-bind (yaml body) (utils:split-frontmatter "just a body")
    (is (null yaml))
    (is (string= "just a body" body))))

(test frontmatter-well-formed
  "the block between the two --- lines is metadata, everything after it is body"
  (multiple-value-bind (yaml body)
      (utils:split-frontmatter (format nil "---~%title: A Note~%publish: t~%---~%the body"))
    (is (string= (format nil "title: A Note~%publish: t") yaml))
    (is (string= "the body" body))))

(test frontmatter-unterminated
  "an opening --- with no closing one is not metadata, so the file is left alone"
  (let ((text (format nil "---~%title: A Note~%the body never closes the block")))
    (multiple-value-bind (yaml body) (utils:split-frontmatter text)
      (is (null yaml))
      (is (string= text body)))))

(test frontmatter-empty-block
  "--- immediately followed by --- yields empty metadata rather than nil"
  (multiple-value-bind (yaml body)
      (utils:split-frontmatter (format nil "---~%---~%the body"))
    (is (string= "" yaml))
    (is (string= "the body" body))))

(test frontmatter-trailing-whitespace-on-delimiters
  "trailing spaces on either --- line are ignored"
  (multiple-value-bind (yaml body)
      (utils:split-frontmatter (format nil "---  ~%title: A Note~%---   ~%the body"))
    (is (string= "title: A Note" yaml))
    (is (string= "the body" body))))

(test frontmatter-crlf-line-endings
  "a file saved with crlf endings is split exactly like an lf one, and neither the
   metadata nor the body keeps a stray carriage return"
  (multiple-value-bind (yaml body)
      (utils:split-frontmatter (format nil "---~c~%title: A Note~c~%---~c~%the body~c~%"
                                       #\Return #\Return #\Return #\Return))
    (is (string= "title: A Note" yaml))
    (is (string= (format nil "the body~%") body))
    (is (null (find #\Return yaml)))
    (is (null (find #\Return body)))))

(test frontmatter-horizontal-rule-in-body
  "a --- used as a horizontal rule partway down a file does not open a metadata block"
  (let ((text (format nil "an intro~%~%---~%~%a section after a rule")))
    (multiple-value-bind (yaml body) (utils:split-frontmatter text)
      (is (null yaml))
      (is (string= text body)))))

(test frontmatter-horizontal-rule-after-block
  "a --- in the body is left in the body, not treated as a second delimiter"
  (multiple-value-bind (yaml body)
      (utils:split-frontmatter
        (format nil "---~%title: A Note~%---~%an intro~%~%---~%~%a section after a rule"))
    (is (string= "title: A Note" yaml))
    (is (string= (format nil "an intro~%~%---~%~%a section after a rule") body))))

(test frontmatter-empty-input
  "the empty string is a body of nothing rather than an error"
  (multiple-value-bind (yaml body) (utils:split-frontmatter "")
    (is (null yaml))
    (is (string= "" body))))

;;; out-path

(defun out-path-string (name)
  "the build path for a source file, relative to the build directory, as a string"
  (let ((in-dir #p"/src/pages/")
        (out-dir #p"/build/"))
    (namestring (uiop:enough-pathname
                  (utils:out-path (merge-pathnames name in-dir) in-dir out-dir)
                  out-dir))))

(test out-path-becomes-a-directory-index
  "an ordinary page becomes a directory with an index.html in it, so its url has no .html"
  (is (string= "links/index.html" (out-path-string "links.md"))))

(test out-path-keeps-index-and-404
  "index and 404 keep their own names, since neither wants a directory of its own"
  (is (string= "index.html" (out-path-string "index.md")))
  (is (string= "404.html" (out-path-string "404.html"))))

(test out-path-preserves-nested-directories
  "a page in a subdirectory keeps that subdirectory"
  (is (string= "git/rebasing/index.html" (out-path-string "git/rebasing.md"))))

(test out-path-ignores-source-extension
  "html, markdown and lisp sources all land on the same url"
  (is (string= "email/index.html" (out-path-string "email.lisp")))
  (is (string= "email/index.html" (out-path-string "email.md")))
  (is (string= "email/index.html" (out-path-string "email.html"))))

(test out-path-is-pure
  "working out a path must not create anything on disk"
  (with-temp-dir (dir)
    (let ((out (utils:out-path #p"/src/pages/deep/page.md" #p"/src/pages/" dir)))
      (is (not (uiop:file-exists-p out)))
      (is (not (uiop:directory-exists-p (uiop:pathname-directory-pathname out)))))))

(test generate-out-path-creates-the-directory
  "the effectful wrapper makes the parent directory, but still not the file"
  (with-temp-dir (dir)
    (let ((out (utils:generate-out-path #p"/src/pages/deep/page.md" #p"/src/pages/" dir)))
      (is (uiop:directory-exists-p (uiop:pathname-directory-pathname out)))
      (is (not (uiop:file-exists-p out))))))

;;; walk

(test walk-visits-every-file-recursively
  "walk reaches files in subdirectories, not just the top level"
  (let ((seen '()))
    (utils:walk (fixture-wiki) (lambda (p) (push (file-namestring p) seen)))
    (is (member "published-simple.md" seen :test #'string=))
    (is (member "not-markdown.txt" seen :test #'string=))
    (is (member "relative.md" seen :test #'string=) "should descend into links/")
    (is (member "img.png" seen :test #'string=) "should descend into assets/")))

(test walk-visits-each-file-once
  (let ((count 0))
    (utils:walk (fixture-wiki) (lambda (p) (declare (ignore p)) (incf count)))
    (is (= 9 count) "the fixture wiki has nine files in it")))
