---
eleventyNavigation:
    key: Networking
parent: Cards
title: Notes on networking
date: 2026-07-09
tags:
    - posts
    - computing
---

These are mainly notes on the course [Grokking Computer Networking for Software
Engineers](https://www.educative.io/courses/grokking-computer-networking). It taught me a lot about
computer networking, and the notes I took mean I don't have to pay for it again.

## Fundamentals
- [TCP IP](./TCP%20IP) — the Internet protocol suite: the end-to-end argument, packet switching, and the layered model.
- [Network Topology](Network%20Topology) — bus, ring, and star layouts.
- [Extras](Extras) — types of networks by geography (LAN, MAN, WAN, SONET/SDH).

## Application Layer
- [Application Layer](./Application%20Layer) — responsibilities, and client-server vs peer-to-peer architectures.
- [How processes communicate](./How%20processes%20communicate) — programs vs processes vs threads, sockets, ports, and addressing.
- [HTTP](./HTTP) — objects, URLs, persistent vs non-persistent connections.
	- [HTTP Requests](./HTTP%20Requests) — the request line, HTTP methods, URIs, and header lines.
	- [HTTP Responses](./HTTP%20Responses) — the status line, status codes, and header lines.
- [DNS](./DNS) — the domain name lookup service, namespace hierarchy, and local caching.

## Transport Layer
- [Transport Layer](./Transport%20Layer) — segmentation, multiplexing, and congestion control.
- [Reliable Data Transfer](./Reliable%20Data%20Transfer) — checksums, retransmission timers, and pipelining.
- [TCP](./TCP) — reliable, connection-oriented transport and the three-way handshake.
	- [TCP Segment Header](./TCP%20Segment%20Header) — header fields and flags in detail.
- [UDP](./UDP) — connectionless transport: the datagram header and when to prefer it over TCP.
