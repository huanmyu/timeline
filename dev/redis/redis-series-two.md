# Pub/Sub
1. Citing Wikipedia: Senders (publishers) are not programmed to send their messages to specific receivers (subscribers). Rather, published messages are characterized into channels, without knowledge of what (if any) subscribers there may be. Subscribers express interest in one or more channels, and only receive messages that are of interest, without knowledge of what (if any) publishers there are.
2. This decoupling of publishers and subscribers can allow for greater scalability and a more dynamic network topology.
3. Commands
  - PSUBSCRIBE：Subscribes the client to the given patterns.
  - PUBLISH：Posts a message to the given channel.
  - PUBSUB：Inspect the state of the Pub/Sub subsystem.
  - PUNSUBSCRIBE： Unsubscribes the client from the given patterns, or from all of them if none is given.
  - SUBSCRIBE： Subscribes the client to the specified channels.
  - UNSUBSCRIBE： Unsubscribes the client from the given channels, or from all of them if none is given.
  - PING: This command is often used to test if a connection is still alive, or to measure latency.
  - QUIT：Ask the server to close the connection.
## Client Subscribe Channels


## Notes
The information refers to this [document](https://redis.io/topics/pubsub)
[redis and why choose it](http://www.infoq.com/cn/articles/tq-why-choose-redis）
