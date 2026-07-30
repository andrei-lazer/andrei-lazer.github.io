---
title: How processes communicate
---
# Program vs Process vs Thread
- **Program**: an application or executable file, such as Word
- **Process**: An instance of a process
- **Thread**: A separate part of a process that shares memory with it, but is run concurrently using virtual or real cores on the CPU.

# Sockets

Processes on separate machines communicate using a computer network. The **software interface** between the process and the network is called a socket. It's made up of an **IP address** and a **port**. When one process sends information to another process, it sends it to the socket, and doesn't worry about it afterwards.

# Addressing
Messages are addressed to an end system using IP addresses and ports.
## Ports
Used to address specific processes on a machine. Some ports are reserved, like port 80 for HTTP requests, and 443 for HTTPS.
