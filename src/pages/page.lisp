(defpackage #:pages/page
  (:use #:cl)
  (:export #:render))

(defun pages/page:render ()
  (layouts/main:html5
    (:title "andrei lazer")
    (:p 
      "This is my website! I am a master's student in maths going into software engineering. Check out " (:a :href "/now" "now")
      " for what I'm up to now, or " (:a :href "/cards" "cards") " for a collection of notes and projects. I prefer to be contacted
      via " (:a :href "/email" "email") " since I rarely check anything else.")
    (:h2 "warning")
    (:p "I can't promise that this website has been recently updated. It's a
        fun side project of mine, but I'm notoriously bad at keeping on top of
        these kinds of things. Paradoxically, it is also always under
        development, so parts of it might be broken.")))
