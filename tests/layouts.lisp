(in-package #:app-tests)

(def-suite layouts :in all :description "the page and card page templates")
(in-suite layouts)

(defun nested-in-body-p (html tag)
  "true when tag opens after <body> and closes before </body>. guards against the markup
   that browsers silently reparent for us but that is not actually valid"
  (let ((body-start (index-of "<body" html))
        (body-end (index-of "</body>" html))
        (tag-start (index-of (format nil "<~a" tag) html))
        (tag-end (index-of (format nil "</~a>" tag) html)))
    (and body-start body-end tag-start tag-end
         (< body-start tag-start)
         (< tag-end body-end))))

(defun in-head-p (html needle)
  (let ((head-end (index-of "</head>" html))
        (at (index-of needle html)))
    (and head-end at (< at head-end))))

;;; simple

;; spinneret leaves out end tags that html5 makes optional, so </p> never appears in
;; its output and assertions here match on the opening tag and the text instead

(test simple-emits-a-document
  (let ((html (rendering (layouts:simple (:p "hello")))))
    (is (contains "<!DOCTYPE html>" html))
    (is (contains "<html" html))
    (is (contains "<p>hello" html))))

;;; page

(defun render-page (&rest args)
  (collapse-whitespace
    (rendering
      (let ((title (getf args :title "a page"))
            (header (getf args :header))
            (icon (getf args :icon-file)))
        (layouts:page (:title title :header header :icon-file icon)
          (:p "the content"))))))

(test page-emits-a-whole-document
  (let ((html (render-page)))
    (is (contains "<!DOCTYPE html>" html))
    (is (contains "<title>a page</title>" html))
    (is (contains "<p>the content" html))))

(test page-puts-its-stylesheets-in-the-head
  "a stylesheet emitted after </head> is invalid, however forgiving browsers are"
  (let ((html (render-page)))
    (is-true (in-head-p html "/styles/style.css"))
    (is-true (in-head-p html "/styles/asciidoc.css"))))

(test page-puts-the-nav-inside-the-body
  (let ((html (render-page)))
    (is-true (nested-in-body-p html "nav"))))

(test page-puts-the-header-inside-the-body
  (let ((html (render-page)))
    (is-true (nested-in-body-p html "div"))
    (is (contains "id=gif-header" html))))

(test page-falls-back-from-header-to-title
  "a page that names no header reuses its title as one"
  (let ((html (render-page :title "just a title")))
    (is (contains "<title>just a title</title>" html))
    (is (contains ">just a title</span>" html))))

(test page-prefers-an-explicit-header
  (let ((html (render-page :title "a title" :header "a different header")))
    (is (contains "<title>a title</title>" html))
    (is (contains ">a different header</span>" html))))

(test page-defaults-its-icon
  (let ((html (render-page)))
    (is (contains "/assets/computer.gif" html))))

(test page-uses-a-given-icon
  (let ((html (render-page :icon-file "crab.gif")))
    (is (contains "/assets/crab.gif" html))
    (is-false (contains "computer.gif" html))))

;;; card

(defun render-card (&rest args)
  (collapse-whitespace
    (rendering
      (let ((title (getf args :title "a card"))
            (header (getf args :header))
            (mathjax (getf args :mathjax))
            (icon (getf args :icon-file)))
        (layouts:card (:title title :header header :mathjax mathjax :icon-file icon)
          (:p "the note"))))))

(test card-emits-a-whole-document
  (let ((html (render-card)))
    (is (contains "<!DOCTYPE html>" html))
    (is (contains "<title>a card</title>" html))
    (is (contains "<p>the note" html))))

(test card-puts-the-nav-inside-the-body
  (let ((html (render-card)))
    (is-true (nested-in-body-p html "nav"))))

(test card-puts-its-stylesheets-in-the-head
  (let ((html (render-card)))
    (is-true (in-head-p html "/styles/style.css"))
    (is-true (in-head-p html "/styles/asciidoc.css"))))

(test card-shows-its-header-as-a-heading
  "unlike a page, a card writes its header as an h1 with a rule under it"
  (let ((html (render-card :title "a title" :header "a header")))
    (is (contains "<h1>a header</h1>" html))
    (is (contains "<hr>" html))))

(test card-falls-back-from-header-to-title
  (let ((html (render-card :title "just a title")))
    (is (contains "<h1>just a title</h1>" html))))

(test card-omits-mathjax-by-default
  (is-false (contains "MathJax" (render-card))))

(test card-includes-mathjax-on-request
  (is (contains "MathJax" (render-card :mathjax t))))

(test card-defaults-its-icon
  (is (contains "/assets/computer.gif" (render-card))))
