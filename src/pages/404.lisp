(layouts:simple
  (components:head :title "lost?" :mathjax nil :icon-path "/assets/hamster.gif" :extra-styles '("/styles/email.css"))
  (:body
    (:div :id "email" 
          (:img :class "gif" :src "/assets/hamster.gif" :alt "mail.gif")
          (:a :href "/" "you're lost!"))
    (:a :href "/" "go home")))
