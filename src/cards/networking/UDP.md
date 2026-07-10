# Intro
 - **User datagram protocol**
 - No connection required (messages are sent without a handshake)
 - Messages are called "datagrams"
 - Does not ensure in-order delivery, and may drop packets
 - Detects errors, but does not fix them
 - Faster than TCP
 - Examples: DNS, live video streaming, Voice over IP.

# Multiplexing and De-multiplexing
This is how we can send messages to specific applications within one IP address, as well as send multiple messages from one IP address. Both of these are resolved using [[How processes communicate#Ports|ports]] 

Therefore, when using UDP, the transport layer is responsible for labelling packets with the port number of the origin application as well as the port number for the destination application.

# UDP Header
UDP prepends **four 2-byte fields** as a header to every datagram, so the header is **8 bytes in size**.
1. **Source port**
2. **Destination port**
3. **Datagram length**
4. **Checksum**

# Why UDP?
1. UDP is faster, since it doesn't have the overhead of the TCP retransmission mechanism.
2. Reliability can be built on top of UDP.
3. UDP gives finer control over what messages are sent, when they're sent, and how reliably they're sent.
4. UDP allows custom protocols
	1. **Quick UDP Internet Connections** (QUIC) is an experimental transport layer built on top of UDP and designed by Google. It is used by most Chrome connections to Google's servers.
5. UDP has a smaller header, and so is significantly faster.

# Examples of UDP
1. Xbox Live
2. [[DNS]]
	- Failed messages are either resent, or send to another server.
	- Used because DNS is a bottleneck, so it makes web browsing as a whole quicker.
3. Network management & monitoring
	- See [Simple Network Management Protocl](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol).
	
# Exercise:
`tcpdump` captures packets. Here is an example from the output of `tcpdump udp -X -c 1`.

![[Pasted image 20250922133351.png]]
