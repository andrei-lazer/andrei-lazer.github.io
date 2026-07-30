---
title: HTTP
---

# Intro
This is a client-server protocol used to send requests and receive responses. It is stateless (the server doesn't remember the client).

HTTP relies on lower levels being reliable
- HTTP uses TCP as its transport protocol, since it ensures packets are always delivered **correctly** and **in order**, as opposed to UDP.
- TCP is **connection-oriented**, i.e. it needs a connection to be established before messages can be sent.

# Objects
- An object is a file like a HTML file, PNG file, MP3, etc.
- Each object has a **URL**.
- The **base object** of a web page is usually an HTML file that has references to other objects.

# URL
A **Universal Resource Locator** (URL) is used to locate files that exist on servers. They have the following parts:
- Protocol in use
- Hostname of the server
- location of the file
- Arguments to the file

![[Pasted image 20250917143437.png]]

# Non-persistent HTTP
Non-persistent connections involve one TCP connection per HTTP request. Once a response has been sent by the server, the HTTP connection is closed.

The main downside is that a whole TCP session has to be built up and torn down every time a single HTTP request is sent. For example, if the client receives a file with several JavaScript elements and images, it will have to open many more TCP connections, which is slow.

# Persistent HTTP

This uses a single client-server TCP connection for all the HTTP requests and responses.

# HTTP Messages
There are two types of HTTP message: [[HTTP Requests]], and [[HTTP Responses]]
