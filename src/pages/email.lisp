(layouts:simple
  (components:head :title "email" :mathjax nil :icon-path "/assets/mail.gif" :extra-styles '("/styles/email.css"))
  (:div :id "email" 
        (:img :class "gif" :src "/assets/mail.gif" :alt "mail.gif")
        (:a :href "mailto:andrei.lucian.lazer@gmail.com" "andrei.lucian.lazer@gmail.com"))
  (:a :href "/" "go home"))
