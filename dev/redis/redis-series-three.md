## Redis Lua scripting
1. Commands
- EVAL and EVALSHA are used to evaluate scripts using the Lua interpreter built into Redis.
- SCRIPT command can be used in order to control the scripting subsystem.
  - SCRIPT FLUSH command is the only way to force Redis to flush the scripts cache.
  - SCRIPT EXISTS sha1 sha2 ... shaN command check the list of SHA1 digests is or not present in the scripting cache.
  - SCRIPT LOAD script command registers the specified script in the Redis script cache.
  - SCRIPT KILL command is the only way to interrupt a long-running script that reaches the configured maximum execution time for scripts.
2. EVAL Detail
  - The first argument of EVAL is a Lua 5.1 script. It is just a Lua program that will run in the context of the Redis server.
  - The second argument of EVAL is the number of arguments that follows the script (starting from the third argument) that represent Redis key names, can be accessed by Lua using the KEYS global variable.
  - All the additional arguments can be accessed by Lua using the ARGV global variable.
  - Use redis.call() and redis.pcall() call Redis commands from a Lua script.
3. EVALSHA works exactly like EVAL, but instead of having a script as the first argument it has the SHA1 digest of a script.
4. Redis guarantees that a script is executed in an atomic way: no other script or Redis command will be executed while a script is being executed.
5. Executed scripts are guaranteed to be in the script cache of a given execution of a Redis instance forever.
6. Scripts as pure functions. a script should only operate on Redis data and passed arguments.
7. Redis scripts are not allowed to create global variables, in order to avoid leaking data into the Lua state.
8. It is possible to write to the Redis log file from Lua scripts using the redis.log function.
9. Scripts are also subject to a maximum execution time (five seconds by default).
10. A big advantage of scripting is that it is able to both read and write data with minimal latency, making operations like read, compute, write very fast .

## Redis Pipelining
1. It is possible to send multiple commands to the server without waiting for the replies at all, and finally read the replies in a single step.
2. While the client sends commands using pipelining, the server will be forced to queue the replies, using memory.

## Request/Response protocols
- The client sends a query to the server, and reads from the socket, usually in a blocking way, for the server response.
- The server processes the command and sends the response back to the client.

## RTT (Round Trip Time)
It is a time for the packets to travel from the client to the server, and back from the server to the client to carry the reply.
