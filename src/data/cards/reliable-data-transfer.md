---
title: Reliable data transfer
---
There are three types of errors caused by network imperfections:
1. Segments can be **corrupted**
2. Segments can be **lost**
3. Segments can be **reordered** or **duplicated**

# Checksums
A checksum is appended to the end of the data send, and is then verified at the end. This tries to fix issue number 1 (corruption).

# Retransmission timers
This tries to fix issue number 2 (loss). Since a receiver sends an acknowledgement message after every data segment, the simplest solution is to re-send the message if a retransmission timer runs out before the acknowledgement.

This timer needs to be larger than the round-trip time

The acknowledgement can be lost, resulting in **message duplication**. This is fixed by appending a unique-per-message sequence number to each segment, allowing the receiver to detect duplicates.

# Pipelining
Applications often generate data faster than the network can transport it. Therefore, it's more efficient to **pipeline** the delivery process. I.e. instead of waiting for the receiver to acknowledge every message, the sender keeps transmitting messages without waiting.

This may cause the receiver to become **overloaded**, since the sender might produce faster than the receiver can consume.
