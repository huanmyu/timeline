# Publish/Subscribe messaging paradigm
1. Citing Wikipedia: Senders (publishers) are not programmed to send their messages to specific receivers (subscribers). Rather, published messages are characterized into channels, without knowledge of what (if any) subscribers there may be. Subscribers express interest in one or more channels, and only receive messages that are of interest, without knowledge of what (if any) publishers there are.
2. This decoupling of publishers and subscribers can allow for greater scalability and a more dynamic network topology.
3. Redis Commands
  - SUBSCRIBE： Subscribes the client to the specified channels.
  - PSUBSCRIBE：Subscribes the client to the given patterns.
  - UNSUBSCRIBE： Unsubscribes the client from the given channels, or from all of them if none is given.
  - PUNSUBSCRIBE： Unsubscribes the client from the given patterns, or from all of them if none is given.
  - PUBLISH：Posts a message to the given channel.
  - PUBSUB：Inspect the state of the Pub/Sub subsystem.
  - PING: This command is often used to test if a connection is still alive, or to measure latency.
  - QUIT：Ask the server to close the connection.
4. Redis Pub/Sub is fire and forget currently there is no way to use this feature if you application demands reliable notification of messages, that is, if your Pub/Sub client disconnects, and reconnects later, all messages delivered during the time the client was disconnected are lost.

## Client subscribe and unsubscribe channels
1. The client subscribe to channels foo and bar(the names of the channels), messages sent by other clients to these channels will be pushed by Redis to all the subscribed clients.
  -　SUBSCRIBE foo bar
2. The client can unsubscribe to channels. if without additional arguments, the command will unsubscribes itself from all the channels.
  - UNSUBSCRIBE foo
3. The client may subscribe to glob-style patterns in order to receive all the messages sent to channel names matching a given pattern.
  - PSUBSCRIBE news.*
4. The client unsubscribe to glob-style patterns.
  - PUNSUBSCRIBE news.*
5. The replies to subscription and unsubscription operations are sent in the form of messages, so that the client can just read a coherent stream of messages where the first element indicates the type of message.
6. A client subscribed to one or more channels should not issue commands, although it can subscribe and unsubscribe to and from other channels.
7. The commands that are allowed in the context of a subscribed client are SUBSCRIBE, PSUBSCRIBE, UNSUBSCRIBE, PUNSUBSCRIBE, PING and QUIT.
8. The client will exit the Pub/Sub state only when it still subscribed to the total number of channels and patterns drops to zero as a result of unsubscribing from all the channels and patterns.

## Client publish messages
The client can Posts a message to the given channel.
  - PUBLISH second Hello

## Format of pushed messages
A message is a Array reply with three or four elements.
The first element is the kind of message:
  - subscribe: successfully subscribed, the second element is channel name, the third argument represents the number of channels we are currently subscribed to.
  - unsubscribe: successfully unsubscribed, the second element is channel name, the third argument represents the number of channels we are currently subscribed to.
  - message: message received, the second element is the name of the originating channel, and the third argument is the actual message payload.
  - pmessage: message received matching a pattern-matching subscription, the second element is the original pattern matched, the third element is the name of the originating channel, and the last element the actual message payload.

## Notes
The information refers to this [document](https://redis.io/topics/pubsub)
[redis and why choose it](http://www.infoq.com/cn/articles/tq-why-choose-redis）
