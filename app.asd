(asdf:defsystem 
  "app"
  :depends-on ("sta6"
               "3bmd"
               "3bmd-ext-wiki-links"
               "3bmd-ext-code-blocks"
               "3bmd-ext-math"
               "3bmd-ext-tables"
               "cl-yaclyaml")
  :serial t
  :components 
  ((:file "src/data/cards/main")
   (:file "src/components/main")
   (:file "src/layouts/main")

   (:file "src/pages/page")
   (:file "src/pages/now")
   (:file "src/pages/links/page")
   (:file "src/pages/email")
   (:file "src/pages/cards/page")

   (:file "src/pages/cards/+slug+/page")

   (:file "app")))
