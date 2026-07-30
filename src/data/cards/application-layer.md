---
title: Application layer
---
# Intro
- Exists ENTIRELY on end systems, like PCs or phones.
## Responsibilities
- Writing data to the network in the correct format
- Reading data
- Providing an application to users
- Error handling and recovery

# Network Application Architectures

## Client-Server Architecture
Split into client-side and server-side processes, which communicate using messages.

### Servers
1. Generally, the server should be available all the time.
2. They have at least one reliable IP address with which they can be reached.

### Clients
Clients use the internet to use services and consume content. Clients always initiate connections to servers, and servers wait on clients.

The web is a client-server architecture.

### Data Centres
These are buildings which store servers.

## Peer-to-Peer Architecture

No dedicated server is involved, and all devices involved are peers that communicate with each other. This can scale rapidly, since every machine is capable of being both a client and a server. This is used a lot for torrenting.
