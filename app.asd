(asdf:defsystem 
  "app"
  :depends-on (
               "cl-yaclyaml"
               "spinneret")
  :serial t
  :components 
  ((:file "src/utils")
   (:file "src/components")
   (:file "src/layouts")
   (:file "app")))
