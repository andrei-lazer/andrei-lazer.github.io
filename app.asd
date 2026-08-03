(asdf:defsystem
  "app"
  :depends-on (
               "3bmd"
               "3bmd-ext-wiki-links"
               "3bmd-ext-code-blocks"
               "3bmd-ext-math"
               "3bmd-ext-tables"
               "cl-yaclyaml"
               "spinneret")
  :serial t
  :components
  ((:file "src/utils")
   (:file "src/markdown")
   (:file "src/components")
   (:file "src/layouts")
   (:file "app")))
