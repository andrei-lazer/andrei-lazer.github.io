---
title: HTTP requests
---
Here is an example request:

```
GET /path/to/file/index.html HTTP/1.1
Host: www.educative.io
Connection: close
User-agent: Mozilla/5.0
Accept-language: fr
Accept: text/html
```
^41ee9f

- HTTP messages are in ASCII text
- Each line ends in a carriage return and a newline: `\r\n`
- The first line is a **request line**, and the rest of the lines are **header lines**.

## The request line anatomy

![[Pasted image 20250917144750.png]]

## HTTP methods
- `GET` requests data
- `POST` posts data to the server
	- The server responds with the location of the object - usually used when the client doesn't know where to put the data.
- `HEAD` is similar to get, but only requests the header of the data.
	- Used to check whether some object still exists
- `PUT` uploads data to a specific spot defined by a [[#URI]].
	- Often used after a `POST` request.
- `DELETE` deletes data at a given [[HTTP#URL]]


## URI
A **Universal Resource Identifier** is like a [[HTTP#URL]], but it can also target fragments of a resource. This is encoded as a # in text, for example (https://en.wikipedia.org/wiki/Transmission_Control_Protocol#Network_function) is a URI.

## HTTP Header Lines Anatomy
[Here](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields) is a list of all HTTP header fields. Below are some explanations of commonly used and non-obvious ones

- `Connection` defines whether the connection is persistent or not. In the case of [[#^41ee9f]], it is a non-persistent connection.
- `User-agent` defines the client, and is useful when the server has different versions of an object for different browsers.
- `Accept` defines the sort of response to accept.
