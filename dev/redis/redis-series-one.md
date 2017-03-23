# Redis
1. Redis is not a plain key-value store, actually it is a data structures server, supporting different kind of values.
2. It is possible to iterate the key space of a large collection incrementally.
3. It is possible to run Lua scripts server side to win latency and bandwidth.
4. Redis is also a Pub-Sub server.

## Install
1. mac: brew install redis
2. linux: sudo apt-get install redis-server
3. windows: https://github.com/MSOpenTech/redis

## Redis Data Types
### String Keys
- The empty string is also a valid key.
- The maximum allowed key size is 512 MB.
- Altering and querying the key space
  - EXISTS : exists mykey
  - DEL : del mykey
  - TYPE : type mykey
- Redis expires: keys with limited time to live
  - EXPIRE : expire key 5
    - PEXPIRE(milliseconds)
  - set key 100 ex 10
  - PERSIST : persist mykey
  - TTL : ttl key
    - PTTL(milliseconds)

### Complex Data Structures Values
1. Binary-safe strings
  - Notes
    - value can't be bigger than 512 MB.
  - UseCases
    - Caching HTML fragments or pages.  
  - Commands
    - SET : set mykey somevalue
      - SET will replace any existing value already stored into the key.
      - MSET set the value of multiple keys.
    - GET : get mykey
      - GETSET sets a key to a new value, returning the old value as the result.
      - MGET retrieve the value of multiple keys.
    - INCR : incr counter (set counter 100)
      - Other similar commands like INCRBY, DECR and DECRBY.

2. Lists
  - Notes
    - Collections of string elements sorted according to the order of insertion.
    - Implemented via Linked Lists.
    - Adding a new element in the head or in the tail of the list is performed in constant time.
    - Can be taken at constant length in constant time.
  - UseCases
    - Remember the latest updates posted by users into a social network.
    - Communication between processes, using a consumer-producer pattern where the producer pushes items into a list, and a consumer (usually a worker) consumes those items and executed actions.
  - Commands
    - LPUSH : lpush mylist first
    - RPOP : rpop mylist
    - LRANGE : lrange mylist 0 -1

3. Sets
  - Notes
    - Collections of unique, unsorted string elements.
  - UseCases
    - Sets are good for expressing relations between objects.
    - For instance we can easily use sets in order to implement tags.
  - Commands
    - SADD : sadd news:1000:tags 1 2 5 77; sadd tag:1:news 1000
    - SMEMBERS : smembers news:1000:tags
    - SINTER : sinter tag:1:news tag:2:news tag:10:news tag:27:news
    - SUNIONSTORE : sunionstore game:1:deck deck
    - SPOP : spop game:1:deck
    - SCARD : scard game:1:deck

4. Sorted sets
  - Notes
    - Sorted sets are a data type which is similar to a mix between a Set and a Hash.
    - Composed of unique, non-repeating string elements.
    - Similar to Sets but where every string element is associated to a floating number value, called score.
    - Sorted sets are implemented via a dual-ported data structure containing both a skip list and a hash table, so every time we add an element Redis performs an O(log(N)) operation.
  - UseCases
    - Lexicographical scores allows us to use sorted sets as a generic index.
    - Leader boards show the top-N users, and the user rank.
  - Commands
    - ZADD : zadd hackers 1940 "Alan Kay"
    - ZRANGE : zrange hackers 0 -1
    - ZREVRANGE : zrevrange hackers 0 -1
    - ZRANGEBYSCORE : zrangebyscore hackers -inf 1950
    - ZRANGEBYLEX : zrangebylex hackers [B [P
    - zremrangebyscore : zremrangebyscore hackers 1940 1960
    - ZRANK : zrank hackers "Anita Borg"

5. Hashes
  - Notes
    - With field-value pairs.
    - It is worth noting that small hashes (i.e., a few elements with small values) are encoded in special way in memory that make them very memory efficient.
  - UseCases
    - Hashes are handy to represent objects.
  - Commands
    - HMSET : hmset user:1000 username antirez birthyear 1977 verified 1
    - HGET : hget user:1000 username

6. Bit arrays(or simply bitmaps)
  - Notes
    - Bitmaps are not an actual data type, but a set of bit-oriented operations defined on the String type.
    - Be suitable to set up to 2的32次方 different bits.
  - UseCases
    - Real time analytics of all kinds. (population counting)
    - Storing space efficient but high performance boolean information associated with object IDs.(the longest streak of daily visits users)
  - Commands
    - SETBIT : setbit key 10 1
    - GETBIT : getbit key 10
    - BITCOUNT : bitcount key

7. HyperLogLogs
  - Notes
    - A HyperLogLog is a probabilistic data structure used in order to count unique things.
    - Technically a different data structure, is encoded as a Redis string.
    - While you don't really add items into an HLL, because the data structure only contains a state that does not include actual elements, the API is the same.
  - UseCases
    - Counting unique queries performed by users in a search form every day.
  - Commands
    - PFADD : pfadd hll a b c d
    - PFCOUNT : pfcount hll

## Notes
The information refers to this [document](https://redis.io/topics/data-types-intro)
