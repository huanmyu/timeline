# Redis

## Install
1. mac: brew install redis

## Redis Data Types

### string keys
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

### complex data structures values
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

3. Sets: Collections of unique, unsorted string elements.
4. Sorted sets: Similar to Sets but where every string element is associated to a floating number value, called score.
5. Hashes
6. Bit arrays(or simply bitmaps)
7. HyperLogLogs
