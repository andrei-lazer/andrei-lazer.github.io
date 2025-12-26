---
layout: post.njk
name: A simple matching engine for limit orders
link: https://github.com/andrei-lazer/order-book
date: 2025-08-10
tags:
    - personal
---

In {{ date | formatDate }}, I started seriously aiming for quantitative finance roles, and so
decided to create what is probably the most common quant dev project.

This is a price-time priority matching engine written in <nobr>C++</nobr>. I implemented basic
functionality for Good-Till-Cancel limit orders. Unit testing is done with Google test.

The design of this order book is largely influenced by [this
article](https://web.archive.org/web/20110219163448/http://howtohft.wordpress.com/2011/02/15/how-to-build-a-fast-limit-order-book/)
from 2011, especially the use of ordered maps for storing limits, and a lock-free ring buffer for
updating external observers.

It's quite a small project, but it took me a good amount of effort due to my relative lack of
experience with C++ at the time. This is the project which best represents my <nobr>C++</nobr>
skills.

Potential future to-dos:
- Add more order types (Fill-Or-Kill, Market Orders, Stop Orders)
- Create a more thorough API for getting order data.
- Test its performance much more thoroughly using realistic sample data and better profiling tools.
