(in-package #:app-tests)

(def-suite cards :in all :description "publishing wiki notes as card pages")
(in-suite cards)

(defun fixture-card (name)
  (cards:read-card (merge-pathnames name (fixture-wiki))))

(defun index-fixture-wiki ()
  (quietly (cards:index-wiki (fixture-wiki))))

(defun generate-fixture-cards (out)
  (quietly (cards:generate-cards (fixture-wiki) out)))

;;; read-card

(test read-card-reads-a-published-note
  (let ((card (fixture-card "published-simple.md")))
    (is (not (null card)))
    (is (string= "Simple Note" (getf card :title)))
    (is (string= "A Simple Note" (getf card :header)))
    (is (contains "both a title and a separate header" (getf card :body)))))

(test read-card-body-excludes-the-frontmatter
  (let ((card (fixture-card "published-simple.md")))
    (is-false (contains "publish:" (getf card :body)))
    (is-false (contains "title:" (getf card :body)))))

(test read-card-skips-a-note-with-no-publish-key
  (is (null (fixture-card "unpublished.md"))))

(test read-card-skips-an-explicitly-unpublished-note
  "yaml turns false into nil, so publish: false reads as not published"
  (is (null (fixture-card "publish-false.md"))))

(test read-card-skips-files-that-are-not-markdown
  "a .txt marked for publication is still not a note"
  (is (null (fixture-card "not-markdown.txt"))))

(test read-card-falls-back-to-the-file-name
  "a note that names neither a title nor a header gets both from its file name"
  (let ((card (fixture-card "published-no-title.md")))
    (is (string= "published-no-title" (getf card :title)))
    (is (string= "published-no-title" (getf card :header)))))

(test read-card-header-falls-back-to-title
  (let ((card (fixture-card "links/sibling.md")))
    (is (string= "Sibling" (getf card :title)))
    (is (string= "Sibling" (getf card :header)))))

(test read-card-reports-mathjax
  (is (eq t (getf (fixture-card "mathjax.md") :mathjax)))
  (is (null (getf (fixture-card "published-simple.md") :mathjax))))

;;; index-wiki

(test index-wiki-collects-only-published-notes
  (let ((index (index-fixture-wiki)))
    (is (= 5 (hash-table-count index))
        "five of the fixture notes are published markdown")))

(test index-wiki-keys-notes-by-relative-path
  (let ((index (index-fixture-wiki)))
    (is-true (gethash #p"published-simple.md" index))
    (is-true (gethash #p"links/relative.md" index) "should descend into subdirectories")
    (is-false (gethash #p"unpublished.md" index))
    (is-false (gethash #p"publish-false.md" index))
    (is-false (gethash #p"not-markdown.txt" index))))

;;; card-out-path

(test card-out-path-swaps-the-extension
  (is (string= "published-simple.html"
               (namestring (uiop:enough-pathname
                             (cards:card-out-path #p"published-simple.md" #p"/build/cards/")
                             #p"/build/cards/")))))

(test card-out-path-keeps-subdirectories
  (is (string= "links/relative.html"
               (namestring (uiop:enough-pathname
                             (cards:card-out-path #p"links/relative.md" #p"/build/cards/")
                             #p"/build/cards/")))))

;;; card->page

(defun render-fixture-card (rel-path)
  "publishes one fixture note into a temp directory and returns the html written"
  (with-temp-dir (out)
    (let* ((card (fixture-card rel-path))
           (out-path (cards:card-out-path (pathname rel-path) out)))
      (ensure-directories-exist out-path)
      (uiop:read-file-string (cards:card->page (pathname rel-path) card out-path)))))

(test card->page-writes-a-whole-document
  (let ((html (render-fixture-card "published-simple.md")))
    (is (contains "<!DOCTYPE html>" html))
    (is (contains "<title>Simple Note</title>" html))
    (is (contains "<h1>A Simple Note</h1>" html))
    (is (contains "both a title and a separate header" html))))

(test card->page-does-not-create-missing-directories
  "making directories is generate-cards' job; a lone renderer must not"
  (with-temp-dir (out)
    (let* ((card (fixture-card "links/relative.md"))
           (out-path (cards:card-out-path #p"links/relative.md" out)))
      (signals (error) (cards:card->page #p"links/relative.md" card out-path))
      (is-false (uiop:file-exists-p out-path)))))

(test card->page-turns-on-mathjax-for-notes-that-ask-for-it
  (is (contains "MathJax" (render-fixture-card "mathjax.md")))
  (is-false (contains "MathJax" (render-fixture-card "published-simple.md"))))

(test card->page-rewrites-links-relative-to-the-note
  "a note in links/ refers to its neighbours by bare name, and they publish under /cards/"
  (let ((html (render-fixture-card "links/relative.md")))
    (is (contains "href=\"/cards/links/sibling.html\"" html))
    (is (contains "href=\"/cards/published-simple.html\"" html) "a parent hop")
    (is (contains "href=\"/cards/links/sibling.html#section\"" html) "an anchor")
    (is (contains "src=\"/cards/assets/img.png\"" html) "an image a directory up")))

(test card->page-rewrites-wiki-links-too
  (is (contains "href=\"/cards/links/sibling.html\"" (render-fixture-card "links/relative.md"))))

(test card->page-leaves-external-links-alone
  (let ((html (render-fixture-card "links/relative.md")))
    (is (contains "href=\"https://example.com\"" html))
    (is (contains "href=\"/links\"" html))
    (is (contains "href=\"mailto:someone@example.com\"" html))))

(test card->page-does-not-leak-link-settings
  "the link prefix is bound only while a card renders, so ordinary pages are unaffected"
  (render-fixture-card "links/relative.md")
  (is (null markdown:*link-prefix*))
  (is (null markdown:*link-dir*)))

;;; generate-cards

(test generate-cards-publishes-every-published-note
  (with-temp-dir (out)
    (generate-fixture-cards out)
    (is-true (uiop:file-exists-p (merge-pathnames "published-simple.html" out)))
    (is-true (uiop:file-exists-p (merge-pathnames "published-no-title.html" out)))
    (is-true (uiop:file-exists-p (merge-pathnames "mathjax.html" out)))
    (is-true (uiop:file-exists-p (merge-pathnames "links/relative.html" out)))
    (is-true (uiop:file-exists-p (merge-pathnames "links/sibling.html" out)))))

(test generate-cards-publishes-nothing-else
  (with-temp-dir (out)
    (generate-fixture-cards out)
    (is-false (uiop:file-exists-p (merge-pathnames "unpublished.html" out)))
    (is-false (uiop:file-exists-p (merge-pathnames "publish-false.html" out)))
    (is-false (uiop:file-exists-p (merge-pathnames "not-markdown.html" out)))
    (is (= 5 (length (files-of-type out "html")))
        "exactly the five published notes and nothing more")))

(test generate-cards-copies-the-assets-directory
  "images live beside the notes in the wiki and have to come along"
  (with-temp-dir (out)
    (generate-fixture-cards out)
    (is-true (uiop:file-exists-p (merge-pathnames "assets/img.png" out)))))

(test generate-cards-copes-with-a-wiki-that-has-no-assets
  "a wiki with no assets directory should publish rather than fall over"
  (with-temp-dir (wiki)
    (with-temp-dir (out)
      (uiop:copy-file (merge-pathnames "published-simple.md" (fixture-wiki))
                      (merge-pathnames "a-note.md" wiki))
      (finishes (quietly (cards:generate-cards wiki out)))
      (is-true (uiop:file-exists-p (merge-pathnames "a-note.html" out))))))
