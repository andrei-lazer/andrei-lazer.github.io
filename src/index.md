---
layout: markdown.njk
icon: computer.gif
title: andrei's website
header: welcome
---

This is my website! I'm a UK-based student and soon-to-be quantitative
developer. Check out the about section for more info, or the posts section
to see some of my projects. I prefer to be contacted via 
<a href="/email">email</a>, since I rarely check anything else.

## warning

I can't promise that this website has been recently updated. It's a fun side project of mine, but I'm notoriously bad
at keeping on top of these kinds of things. Paradoxically, it is also always under development, so parts of it might be
broken.



{% from "macros.njk" import footer %}
{{ footer('
Total visitors: <span id="visitorCount">...</span>
') }}

<script src="scripts/hitCount.js"></script>
