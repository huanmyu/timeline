## Redis Lua脚本
在系列一中有提及过Redis可以在服务器端运行Lua脚本来减少延迟和带宽。接下来简述Redis　Lua脚本的命令以及注意事项
1. Redis调用Lua脚本的命令
- EVAL 和 EVALSHA命令用于在Redis内置的Lua环境解释器中运行（evaluate）脚本。
- 在Redis里面有专门管理脚本的子系统（在Redis内部其实是一个字典数据结构，键是Lua脚本的SHA1签名，值是签名对应的脚本。），SCRIPT命令可以用来控制Redis的脚本子系统。
  - SCRIPT FLUSH命令是强制Redis刷新脚本系统缓存的唯一方法。
  - SCRIPT EXISTS sha1 sha2 ... shaN命令用于检查输入的一列SHA1签名是否存在于脚本系统的缓存中。
  - SCRIPT LOAD script 命令用于加载（registers）一个特定的脚本到Redis脚本系统的缓存中。
  - SCRIPT KILL 命令用于中止长时间运行脚本的运行，它是唯一的方法，并且只有在脚本运行时间达到配置的最大时间才能中止。
2. EVAL命令的详细信息
  - EVAL的第一个参数是一个Lua5.1语法的脚本，它是一个Lua的程序，并且在Redis服务端的上下文运行。
  - EVAL的第二个参数是代表Redis键的数目，Lua脚本里面可以直接使用Redis命令，Redis的键是使用参数的形式传入到Lua脚本里面的。从EVAL参数的第三个参数起，一直到第二个参数输入的数目，都是Redis键的名称。在Lua脚本里面使用KEYS的全局数组变量来依次访问每个输入的键名称。
  - EVAL剩下的所有参数可以在Lua脚本里面通过ARGV的全局数组变量来依次访问剩下的参数。
  - 使用这么多参数的一个好处是可以变更参数；另个好处是脚本本身是一个不变的字符串，可以由Redis高效缓存。
  - 在Lua脚本里面需要使用redis.call或者redis.pcall方法来调用Redis命令。
3. EVALSHA命令的详细信息
  - 当Redis通过EVAL命令执行脚本之后，同时会生成脚本的SHA1签名，并把他们缓存在脚本系统中。
  - EVALSHA命令通过把EVAL命令的第一个参数Lua脚本替换成脚本的SHA1签名来进行工作。
  - 使用EVALSHA命令的一个好处是可以节约带宽成本，不用每一次把脚本内容发送给Redis服务器端（＆）。
4. 执行过的脚本，Redis实例会保证该脚本在Redis的脚本系统中有缓存。
5. 在Redis中运行的Lua脚本仅仅是一个函数，它的用途应该仅仅只是传递参数和操作Redis里面的数据，不应该尝试访问外部系统，像文件系统或者其他任何系统调用。
6. Redis确保一个脚本以原子的方式执行，也就是说当一个脚本执行的时候不会有另外的脚本和Redis命令同时运行。
7. Redis的lua脚本为了防止数据泄漏，不允许在脚本中创建全局变量。
8. 可以使用redis.log方法在Lua脚本中记录Redis日志。
9. Redis脚本有一个最大的执行时间，默认是5秒（＆）。
10. 使用Redis脚本的一个巨大优势是它在读写数据的时候有很小的延迟，使得读取，计算，写入的操作可以可以快速运行。

## Redis的一些要点
1. Redis是一个典型的TCP服务器，使用客户端服务器交互模型并且使用请求/响应协议。
2. Redis请求的全过程：
  - 客户端发送一个命令(query)给服务器，然后通常是在阻塞的方式下从与服务器连接的套接字中读取服务器的响应。
  - 服务器处理客户端发送的命令，然后发送回复给客户端。
3. 在Redis请求的全过程中，一个数据包从客户端到服务器，再从服务器返回回复信息到客户端的时间叫做RTT(Round Trip Time)。
4. 每一次命令请求都需要来回的RTT时间，时间成本是很大的。如果一次RTT的时间是250毫秒，即使Redis服务器每秒可以处理1000次请求，我们实际却只能每秒处理最多四次请求。下面介绍的Pipelining，可以改善这种状况。

## Redis Pipelining
1. Redis Pipelining是一种客户端可以发送多条命令给服务器，并且不需要等待服务器的回复，最后在一个步骤中读取回复。
2. 实现的方式是当客户端使用Pipelining发送多条命令给服务器，服务器会强制把把当前命令的回复使用内存保存在队列里面。

Redis Pipelining和Redis Lua脚本可以结合使用，Lua脚本在一些场景下更有效。有是可以使用pipelining发送多条EVAL或者EVALSHA命令。

## 额外
- [参考文档－Lua脚本](https://redis.io/topics/pipelining)
- [参考文档－Pipelining](https://redis.io/topics/pipelining)
- 参考书籍－Redis设计与实现
