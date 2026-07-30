The TCP header is a lot more complex than UDP. It is flexibly sized between **20 and 40 bytes**.

![[Pasted image 20250922135400.png]]

## Source and destination ports
These are self-explanatory
## Sequence Number
Every byte of the TCP segment is labelled with a sequence number, and the one in the header is the number of the first byte in this packet. It's used for ordering the packets on arrival.
## Acknowledgement Number
4-byte field containing the sequence number of the next expected segment. Used to check for out-of-order segments.
## Header Length
4-bit (half a byte) about the length of the TCP header. It's actually the number of **4-byte words** in the header, since there are only 4 bits, so 16 possibilites.
## Reserved Field
Padding so that the header is a multiple of 4 bytes long.
## Header flags

![[Pasted image 20250922135925.png]]

These make up the 8 bits of flags in the middle of the header.

### ACK
Used to acknowledge a previous segment that was recieved.
### RST
**Reset** flag. Immediately terminates a connection based on refused connections, confusion, or crashes.
### SYN
**Synchronization** flag initiates a connection with a new host.
### FIN
Terminates a connection normally.
### CWR & ECN
**Congestion window reduced** and **Explicit Congestion Notification** are used to handle congestion.
### PSH
Short for **push**. Used to stop the receiving end from bundling messages together before handing them to the application layer. The PSH flag will force the receiving TCP handler to flush the buffer after the message arrives.
### URG
Marks a message as urgent, so that it is processed first on the host. An example if it being useful is for cancelling a file transfer.

## Window Size
This is the remaining size of the aforementioned buffer. It is used to let the sender know how much space is currently left in the buffer, and is used for flow control.
## Checksum
Standard checksum
## Urgent Pointer
Used to point at the byte which contains the urgent data, since one segment can send both urgent and non-urgent data. Irrelevant if the urgent flag is not set.
# Options and padding
An extra 40 bytes to implement other things that are not supported by the stock header. A **timestamp** is an example of something in this section.
