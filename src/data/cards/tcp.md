---
title: TCP
---
# Intro
- **Transmission control protocol**
- Requires a connection to be set up first (handshakes)
- Delivers messages (also called "segments") reliably and in order.
- Detects errors and can fix them
- Handles volumes of traffic by modulating the amount of data.
- Examples: HTTP, e-mail, file transfers

# Responsibilites
1. Send data at an appropriate transmission rate (to avoid congestion or inefficiency).
2. Segment data.
3. End-to-end flow control.
	- This means not overwhelming the receiver.
4. Identify and re-transmit messages that weren't delivered
5. Identify when messages arrive out of order and reassemble them.

# Examples
1. File transfer
2. SSH
3. Email
4. Web browsing

# Features
1. **Connection-oriented**. It creates a long-term connection between hosts.
2. **Full-duplex**, which means that both hosts can send eachother messages at the same time.
3. **Point-to-point**. Broadcasting and multi-casting is not possible with TCP - there are exactly two endpoints.
4. **Error control**. TCP both detects and fixes errors.
5. **Flow control**. TCP adjusts the amount of data being sent based on the receiver's stated capacity to process it.
6. **Congestion control**. TCP has built-in congestion control mechanisms.

# Segment Header
This is much more complicated than the UDP case, so see [[TCP Segment Header]].

# Three-way handshake
This is how connections are established. They use the **sequence number**, **acknowledgement number**, and **SYN** flag. (See the header section for definitions).

## Client initial message
The client sends a TCP message with:
1. the SYN flag set
2. the sequence number set to a random value
This is often called the **SYN segment**.
## Server response
Upon receiving this message, the server replies with:
1. the SYN flag set
2. the sequence number set to a random value
3. the ACK flag set
4. The acknowledgement number is set to the client's sequence number + 1.

This is often called a **SYN+ACK** segment.

## Client acknowledgement
1. ACK flag set
2. Sequence number = previous _client_ sequence number + 1.
3. Acknowledgement number = server sequence number + 1.

![[Pasted image 20250922152823.png]]

