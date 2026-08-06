(in-package #:app-tests)

(def-suite markdown :in all :description "link rewriting and markdown rendering")
(in-suite markdown)

;;; external-link-p
;;; internal to the markdown package, reached with :: rather than widening its exports

(test external-links-are-left-alone
  "anything already absolute, anchored, schemed or empty is not ours to rewrite"
  (is-true (markdown::external-link-p ""))
  (is-true (markdown::external-link-p "/links"))
  (is-true (markdown::external-link-p "#a-section"))
  (is-true (markdown::external-link-p "https://example.com"))
  (is-true (markdown::external-link-p "http://example.com"))
  (is-true (markdown::external-link-p "mailto:someone@example.com")))

(test relative-links-are-ours-to-rewrite
  (is-false (markdown::external-link-p "sibling.md"))
  (is-false (markdown::external-link-p "../assets/img.png"))
  (is-false (markdown::external-link-p "./sibling.md")))

;;; collapse-updirs

(test collapse-updirs-removes-a-parent-hop
  (is (equal '(:relative "assets")
             (markdown::collapse-updirs '(:relative "git" :up "assets")))))

(test collapse-updirs-leaves-plain-directories-alone
  (is (equal '(:relative "git" "internals")
             (markdown::collapse-updirs '(:relative "git" "internals")))))

(test collapse-updirs-handles-several-hops
  (is (equal '(:relative "assets")
             (markdown::collapse-updirs '(:relative "a" "b" :up :up "assets")))))

(test collapse-updirs-keeps-an-unmatched-hop
  "a hop above the root has nothing to cancel against, so it survives"
  (is (equal '(:relative :up "assets")
             (markdown::collapse-updirs '(:relative :up "assets")))))

;;; resolve-link

(defmacro with-card-links ((&optional (dir #p"")) &body body)
  `(let ((markdown:*link-prefix* "/cards/")
         (markdown:*link-dir* ,dir))
     ,@body))

(test resolve-link-is-identity-without-a-prefix
  "with no prefix set, links are published exactly as they were written"
  (let ((markdown:*link-prefix* nil)
        (markdown:*link-dir* #p"links/"))
    (is (string= "sibling.md" (markdown::resolve-link "sibling.md")))))

(test resolve-link-rewrites-md-to-html
  "notes refer to each other by source name but are published as html"
  (with-card-links ()
    (is (string= "/cards/sibling.html" (markdown::resolve-link "sibling.md")))))

(test resolve-link-resolves-against-the-notes-directory
  "a bare name means a sibling of the note being rendered, not of the wiki root"
  (with-card-links (#p"links/")
    (is (string= "/cards/links/sibling.html" (markdown::resolve-link "sibling.md")))))

(test resolve-link-follows-parent-hops
  (with-card-links (#p"links/")
    (is (string= "/cards/assets/img.png" (markdown::resolve-link "../assets/img.png")))
    (is (string= "/cards/published-simple.html"
                 (markdown::resolve-link "../published-simple.md")))))

(test resolve-link-keeps-anchors
  "an anchor is not part of the file name and must survive the .md to .html swap"
  (with-card-links (#p"links/")
    (is (string= "/cards/links/sibling.html#section"
                 (markdown::resolve-link "sibling.md#section")))))

(test resolve-link-leaves-non-note-files-alone
  "only .md becomes .html, an image keeps its own extension"
  (with-card-links (#p"links/")
    (is (string= "/cards/links/diagram.png" (markdown::resolve-link "diagram.png")))))

(test resolve-link-never-touches-external-links
  "even with a prefix set, absolute and off site links are published unchanged"
  (with-card-links (#p"links/")
    (is (string= "https://example.com" (markdown::resolve-link "https://example.com")))
    (is (string= "/links" (markdown::resolve-link "/links")))
    (is (string= "#section" (markdown::resolve-link "#section")))
    (is (string= "mailto:someone@example.com"
                 (markdown::resolve-link "mailto:someone@example.com")))))

;;; render

(test render-produces-a-fragment-not-a-document
  "rendering returns something to embed in a layout, so it has no html or body tag"
  (let ((html (markdown:render "just a paragraph")))
    (is (contains "<p>" html))
    (is-false (contains "<html" html))
    (is-false (contains "<body" html))))

(test render-generates-header-ids
  "notes link to each other's sections, which needs ids on the headings"
  (let ((html (markdown:render (format nil "## Some Section~%~%text"))))
    (is (contains "<h2" html))
    (is (contains "id=" html))))

(test render-handles-code-blocks
  (let ((html (markdown:render (format nil "```lisp~%(+ 1 2)~%```"))))
    (is (contains "<code" html))))

(test render-handles-tables
  (let ((html (markdown:render (format nil "| a | b |~%|---|---|~%| 1 | 2 |"))))
    (is (contains "<table" html))))

(test render-rewrites-explicit-links
  (with-card-links (#p"links/")
    (is (contains "href=\"/cards/links/sibling.html\""
                  (markdown:render "a [sibling](sibling.md)")))))

(test render-rewrites-image-sources
  "images arrive from the parser shaped differently to every other tag, so they get
   their own rewriting path and their own test"
  (with-card-links (#p"links/")
    (is (contains "src=\"/cards/assets/img.png\""
                  (markdown:render "![diagram](../assets/img.png)")))))

(test render-rewrites-wiki-links
  "[[target]] names another note in the same collection"
  (with-card-links (#p"links/")
    (let ((html (markdown:render "a [[sibling]] link")))
      (is (contains "href=\"/cards/links/sibling.html\"" html))
      (is (contains ">sibling</a>" html)))))

(test render-leaves-external-links-alone
  (with-card-links (#p"links/")
    (let ((html (markdown:render "an [external site](https://example.com)")))
      (is (contains "href=\"https://example.com\"" html)))))
