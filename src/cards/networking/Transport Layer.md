# Intro
This is the layer under the application layer. It is responsible for connecting the larger network to the end-user application.
- Provides a layer of abstraction, so that applications can talk to eachother
- Segments data into smaller pieces (called datagrams or packets)
- Allows multiple conversations to occur at once, without the application having to manage each individual message.
- **Multiplexes and de-multiplexes data.** Ensures that multiple messages sent to different machines on the same host arrive correctly.

Importantly, it does **not** transfer messages between hosts. It simply passes messages to and from the application to the larger inter-device network.

The transport layer has two protocols: [[TCP]] and [[UDP]].


# Congestion Control
When more packets are sent than a network has bandwidth for, some of them start getting dropped.

## Where is it fixed?
Congestion actually occurs at the network layer (so between routers). However, it is caused by the transport layer sending too many messages at once, and so has to be repaired by the transport layer. This is also another example of the [[TCP IP#End-to-end argument|end to end argument]].

## How should bandwidth be allocated?
Bandwidth can be allocated in one of two ways - per device (host) or per connection (application on the host). If we allocate per host, some hosts may have much higher bandwidth capabilities than what they're allocated - for example, google servers and a Ring doorbell are both independent hosts, and would have the same bandwidth allocation.

On the other hand, allocating per connection is quite effective, since if a process would like more bandwidth with another process, it can simply open up several ports on the host.

Bandwidth is therefore usually allocated **per connection**

## Efficiency and Power
### Bursts of traffic
In the real world, messages tend to not be uniformly distributed.

![[Pasted image 20250920113740.png]]

Packets are often sent in bursts, which means that statically and evenly allocating bandwidth amongst end-systems is not effective.

### Transmission Threshold

Below are some graphs of _received transmission rate_ and _delay_ as functions of _sent transmission rate_. We can see a critical point (transmission threshold) where these quantities do not plateau, but actually get worse.

![[Pasted image 20250920114026.png]]

![[Pasted image 20250920114041.png]]

This worsening might be surprising for the transmission rate case (we would expect for the received rate to plateau towards the limit). This is due to **spurious retransmissions**, which occur when a message is re-sent after a transmission timer times out, even though the message is on the way but slowly. This results in a small number of packets being re-transmitting and hogging all of the bandwidth.

The optimal transmission rate maximises the _power_:
$$
P = \frac{R_T}{D(R_T)}
$$
For $P:=$ power, $R_T =$ transmission rate, and $D =$ delay, which is a function of transmission rate.

## Max-min Fairness

The congestion scheme should be fair. Most congestion schemes aim at achieving **max-min fairness**. An allocation of transmission rates is considered to be max-min fair if
1. No link is congested
2. To increase the allocation of link $j$, you would need to lower the allocation of link $i$, which has an allocation $\leq$ that of $j$.
