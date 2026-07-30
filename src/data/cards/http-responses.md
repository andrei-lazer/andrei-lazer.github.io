---
title: HTTP responses
---
Here's an example of a HTTP response:

```
HTTP/1.1 200 OK
Connection: close
Date: Tue, 18 Aug 2015 15: 44 : 04 GMT
Server: Apache/2.2.3 (CentOS)
Last-Modified: Tue, 18 Aug 2015 15:11:03 GMT 
Content-Length: 6821
Content-Type: text/html

[The object that was requested]
```

![[Pasted image 20250917151035.png]]

There are 3 parts: the **status line**, **header lines**, and the **object line**

# Status line
The HTTP response also has a HTTP version.

## Status code
The status code is one of a bunch of different codes which tell the client the status of their request.
- 1XX is informational
- 2XX is success
- 3XX is redirection
- 4XX is client error
- 5XX is server error

# Header lines
- `Connection`: same thing as the request - in this case, means that the TCP connection will be closed after this response.
- `Date` time of response
- `Server`: Similar to the `user-agent` in the request.
- `Last-Modified`: Time when the object requested was last modified.
- `Content-Length`: size of the object in bytes
- `Content-Type`: type of content being sent.
