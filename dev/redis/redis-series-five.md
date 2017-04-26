[Redis cluster](https://redis.io/topics/cluster-tutorial)

The ability to automatically split your dataset among multiple nodes.
The ability to continue operations when a subset of the nodes are experiencing failures or are unable to communicate with the rest of the cluster.

Every Redis Cluster node requires two TCP connections open.
The normal Redis TCP port used to serve clients.
This second high port is used for the Cluster bus, that is a node-to-node communication channel using a binary protocol.
The command port and cluster bus port offset is fixed and is always 10000.
The Cluster bus is used by nodes for failure detection, configuration update, failover authorization and so forth.

Redis Cluster data sharding
Redis Cluster does not use consistent hashing, but a different form of sharding where every key is conceptually part of what we call an hash slot.

There are 16384 hash slots in Redis Cluster, and to compute what is the hash slot of a given key, we simply take the CRC16 of the key modulo 16384.

Every node in a Redis Cluster is responsible for a subset of the hash slots.

Redis Cluster supports multiple key operations as long as all the keys involved into a single command execution (or whole transaction, or Lua script execution) all belong to the same hash slot.

The user can force multiple keys to be part of the same hash slot by using a concept called hash tags.

Redis Cluster uses a master-slave model where every hash slot has from 1 (the master itself) to N replicas (N-1 additional slaves nodes).

Redis Cluster is not able to guarantee strong consistency.
The first reason why Redis Cluster can lose writes is because it uses asynchronous replication.
Redis Cluster has support for synchronous writes when absolutely needed, implemented via the WAIT command, this makes losing writes a lot less likely.

There is another notable scenario where Redis Cluster will lose writes, that happens during a network partition where a client is isolated with a minority of instances including at least a master.

After node timeout has elapsed, a master node is considered to be failing, and can be replaced by one of its replicas.

Redis Cluster and Docker
Redis Cluster does not support NATted environments and in general environments where IP addresses or TCP ports are remapped.
In order to make Docker compatible with Redis Cluster you need to use the host networking mode of Docker.
docker pull redis
