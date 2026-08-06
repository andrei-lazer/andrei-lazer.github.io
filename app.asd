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
   (:file "src/cards")
   (:file "app"))
  :in-order-to ((asdf:test-op (asdf:test-op "app/tests"))))

(asdf:defsystem
  "app/tests"
  :depends-on ("app" "fiveam" "cl-ppcre")
  :serial t
  :components
  ((:module "tests"
    :serial t
    :components
    ((:file "package")
     (:file "utils")
     (:file "markdown")
     (:file "components")
     (:file "layouts")
     (:file "cards"))))
  :perform (asdf:test-op (op system)
             (uiop:symbol-call :app-tests :run-all-tests!)))
