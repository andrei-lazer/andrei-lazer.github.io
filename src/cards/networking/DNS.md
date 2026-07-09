# Intro
**Domain Name System** is the most well-known lookup service. A **lookup service** is something that maps domain names (google.com) to IP addresses.

# DNS Namespaces
The parts of a url (the bits separated by full stops) roughly map to DNS servers, which exist in a heirarchy. Here's an example:

![[Pasted image 20250918105936.png]]

## Root DNS Servers
Root servers are the first point of contact for a DNS query. This redirects the query to a **top-level domain** (TLD), such as .io or .com. There are somewhere around 2000 instances of root servers around the world, operated by 12 different organisations - see https://root-servers.org for more info.

# Local DNS Cache

- DNS mappings are often cached locally to save time.
- This is done using a **local resolver library**, which is part of the OS.
- The local resolver library automatically makes a call to a local DNS server if the requested query is not cached.