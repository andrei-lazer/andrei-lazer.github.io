(in-package #:app-tests)

(def-suite components :in all :description "the reusable html fragments")
(in-suite components)

;;; head

(test head-emits-the-basics
  (let ((html (collapse-whitespace
                (rendering (components:head :title "a page" :icon-path "/assets/mouse.gif")))))
    (is (contains "<title>a page</title>" html))
    (is (contains "charset=UTF-8" html))
    (is (contains "name=viewport" html) "mobile rendering depends on the viewport meta tag")
    (is (contains "content=\"width=device-width, initial-scale=1\"" html))
    (is (contains "href=\"/styles/style.css\"" html))
    (is (contains "href=\"/assets/mouse.gif\"" html))))

(test head-omits-mathjax-by-default
  "most pages have no maths on them and should not pay for the script"
  (let ((html (rendering (components:head :title "a page" :icon-path "/assets/mouse.gif"))))
    (is-false (contains "MathJax" html))))

(test head-includes-mathjax-on-request
  (let ((html (rendering (components:head :title "a page" :icon-path "/assets/mouse.gif"
                                          :mathjax t))))
    (is (contains "MathJax-script" html))
    (is (contains "tex-mml-chtml.js" html))))

(test head-adds-extra-stylesheets-after-the-site-one
  "an extra sheet has to come second, or it cannot override the site wide rules"
  (let ((html (rendering (components:head :title "a page" :icon-path "/assets/mouse.gif"
                                          :extra-styles '("/styles/email.css")))))
    (is (contains "/styles/style.css" html))
    (is (contains "/styles/email.css" html))
    (is (< (search "/styles/style.css" html) (search "/styles/email.css" html)))))

(test head-adds-no-extra-stylesheets-by-default
  (let ((html (rendering (components:head :title "a page" :icon-path "/assets/mouse.gif"))))
    (is (= 1 (count-substring "rel=stylesheet" html)))))

;;; navbar

(test navbar-links-to-every-section
  (let ((html (collapse-whitespace (rendering (components:navbar)))))
    (is (contains "<nav>" html))
    (dolist (href '("/" "/now" "/cards" "/links" "/email"))
      (is (contains (format nil "href=\"~a\"" href) html)
          "navbar should link to ~a" href))))

(test navbar-labels-match-their-destinations
  (let ((html (collapse-whitespace (rendering (components:navbar)))))
    (dolist (label '("home" "now" "cards" "links" "email"))
      (is (contains (format nil ">~a</a>" label) html)))))

;;; gif-header

(test gif-header-shows-the-icon-and-the-text
  (let ((html (collapse-whitespace
                (rendering (components:gif-header "a heading" "/assets/quill.gif")))))
    (is (contains "id=gif-header" html))
    (is (contains "src=\"/assets/quill.gif\"" html))
    (is (contains "class=gif" html))
    (is (contains "a heading" html))
    (is (contains "id=header-text" html))))
