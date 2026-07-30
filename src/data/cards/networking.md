---
title: Notes on networking
date: 2026-07-09
tags:
    - computing
---

These are mainly notes on the course [Grokking Computer Networking for Software
Engineers](https://www.educative.io/courses/grokking-computer-networking). It taught me a lot about
computer networking, and the notes I took mean I don't have to pay for it again.

## Fundamentals
- [[TCP IP]] — the Internet protocol suite: the end-to-end argument, packet switching, and the layered model.
- [[Network Topology]] — bus, ring, and star layouts.
- [[Extras]] — types of networks by geography (LAN, MAN, WAN, SONET/SDH).

## Application Layer
- [[Application Layer]] — responsibilities, and client-server vs peer-to-peer architectures.
- [[How processes communicate]] — programs vs processes vs threads, sockets, ports, and addressing.
- [[HTTP]] — objects, URLs, persistent vs non-persistent connections.
	- [[HTTP Requests]] — the request line, HTTP methods, URIs, and header lines.
	- [[HTTP Responses]] — the status line, status codes, and header lines.
- [[DNS]] — the domain name lookup service, namespace hierarchy, and local caching.

## Transport Layer
- [[Transport Layer]] — segmentation, multiplexing, and congestion control.
- [[Reliable Data Transfer]] — checksums, retransmission timers, and pipelining.
- [[TCP]] — reliable, connection-oriented transport and the three-way handshake.
	- [[TCP Segment Header]] — header fields and flags in detail.
- [[UDP]] — connectionless transport: the datagram header and when to prefer it over TCP.

