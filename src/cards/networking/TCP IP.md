# What is TCP/IP?
It's a networking model made up of two widely used Internet protocols: **Transmission Control Protocol** (TCP) and **Internet Protocol** (IP). It's also known as the Internet protocol suite [Wikipedia](https://en.wikipedia.org/wiki/Internet_protocol_suite.

# End-to-end argument
Implementing complex functionality into the core of the network is expensive and hard to fix in the long term, so the _end-to-end_ argument was used: intelligent and complex end devices with a dumb and fast core network.

# Packet switching
The core was made **packet-switched**, which means discrete, small packets of data are delivered separately. Also, they're routed *per-hop*, so that they can circumvent failures at each step.

This is in contrast to **circuit-switched** networks, which involves allocating a dedicated channel (circuit) with a fixed bandwidth. The downside is that if this circuit breaks, the information sent is lost.

# Layers

> ![[Pasted image 20250917135853.png]]
> One example of the TCP/IP network stack - this isn't always unanimous.

[[Application Layer]]
[[Transport Layer]]