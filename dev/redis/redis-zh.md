# Redis
1. Redis不仅仅是一个的简单键值存储，实际上是一个数据结构的服务器，可以支持不同种类型的键值。
2. Redis可以递增地迭代大集合的键空间。
3. Redis可以在服务器端运行Lua脚本来减少延迟和带宽。
4. Redis也是发布 - 订阅服务器。

## 安装
1. mac: brew install redis
2. linux: sudo apt-get install redis-server
3. windows: [安装衔接](https://github.com/MSOpenTech/redis)

## Redis 数据类型
### 字符串作为键
- 空字符串也是有效的键。
- 字符串键的最大允许大小是512M。
- 可以更改和查询字符串键。
  - EXISTS命令：用于判断键是否存在
    - 使用方法： exists mykey
  - DEL命令：删除键
    - 使用方法： del mykey
  - TYPE命令：用于查询某个键存储的键值种类
    - 使用方法： type mykey
- 可以通过命令限制键的存活时间。
  - EXPIRE命令： 设置键在几秒内存活
    - 使用方法： expire key 5
    - 扩展： PEXPIRE命令用于设置键在几毫秒内过期
  - PERSIST命令： 设置键永远存活
    - 使用方法： PERSIST mykey
  - TTL命令： 查询键的剩余存活时间（秒）
    - 使用方法： ttl key
    - 扩展： PTTL命令查询键的剩余存活时间（毫秒）

### 复杂的数据类型作为键值
1. 二进制安全的字符串键值
  - 注释
    - 字符串键值的大小不能大于512M。
  - 使用案例
    - 用于缓存HTML片段和页面。  
  - 常用命令
    - SET命令: 给某个键设置字符串键值。
      - 使用方法： set mykey somevalue
      - 注释： SET命令会替换键内已经存在的键值。
      - 扩展： MSET命令可以同时为多个键设置键值。
    - GET命令: 获取某个键的字符串键值。
      - 使用方法： get mykey
      - 扩展1： GETSET命令给某个键设置新的字符串值，同时返回修改之前该键的键值。
      - 扩展2： MGET命令可以同时检索多个键的键值。
    - INCR命令: 把某个键的键值解析为整型数据，然后把该数据加一。
      - 使用方法： incr counter (set counter 100)
      - 注释： 字符串键值存储的是整型数据的字符串
      - 扩展： 还有一些相似的命令INCRBY, DECR and DECRBY.

2. 列表类型的键值
  - 注释
    - 列表中元素的顺序是根据元素添加的先后排列。
    - 列表类型的键值是通过Linked Lists实现的.
    - 在列表的头部或尾部中添加新元素是在恒定时间内执行。
    - 可以在恒定时间内添加恒定长度的元素。
  - 使用案例
    - 用于记录用户在社交网站上最新更新的帖子。
    - 用于进程间通信，可以使用生产者消费者模式，一个生产者产生元素到列表，同时一个消费者（通常是一个worker）消费列表中的元素，并且执行对应的actions。
  - 常用命令
    - LPUSH命令: 在列表的头部添加新元素
      - 使用方法： lpush mylist first
    - RPOP命令: 在列表的尾部中消费一个元素
      - 使用方法： rpop mylist
    - LRANGE命令: 获取列表一段区间的元素
      - 使用方法： lrange mylist 0 -1

3. 哈希键值
  - 注释
    - 哈希键值是有多对字段和字段值组成。
    - 值得注意的是，小哈希键值（即具有几个字段和字段值）在内存中以特殊方式编码，使得它们非常好的存储效率。
  - 使用案例
    - 哈希键值可以很方便的表示一个对象。
  - 常用命令
    - HMSET命令: 可以同时设置多对字段和字段值
      - 使用方法： hmset user:1000 username antirez birthyear 1977 verified 1
    - HGET命令: 可以检索某个键的哈希键值的某个字段的值
      - 使用方法： hget user:1000 username

4. 集合类型的键值
  - 注释
    - 集合类型的键值中的元素是唯一的字符串，并且没有顺序。
  - 使用案例
    - 集合类型的键值可以很好的表示对象之间的关系;我们可以很容易的使用这种类型的键值实现标签的功能。
  - 常用命令
    - SADD命令: 给集合中添加元素
      - 使用方法： sadd news:1000:tags 1 2 5 77; sadd tag:1:news 1000
    - SMEMBERS命令: 查看某个键的集合类型的键值的内容
      - 使用方法： smembers news:1000:tags
    - SINTER命令: 获取多个存储集合类型的键值的键的交集
      - 使用方法： sinter tag:1:news tag:2:news tag:10:news tag:27:news
    - SUNIONSTORE命令: 获取集合的并集，并把结果存储到最后的集合中
      - 使用方法： sunionstore game:1:deck deck
    - SPOP命令: 消费集合中的一个元素
      - 使用方法： spop game:1:deck
    - SCARD命令: 统计集合中元素的数量
      - 使用方法： scard game:1:deck

5. 自带排序的集合类型的键值
  - 注释
    - 自带排序的集合类型的键值是一种类似于混合集合类型和哈希类型的键值的数据结构。
    - 自带排序的集合类型的键值是类似于集合类型，不同之处是它的每个元素都绑定一个浮点型的数据（叫做score）。
    - 自带排序的集合类型的键值是通过包含一个跳跃列表和哈希表的双端口数据结构实现的，每次添加新元素的操作花费O(log(N))的时间。
  - 使用案例
    - Lexicographical scores允许我们使用排序集作为一个通用索引。
    - 用作排行榜显示前N个用户，以及用户的等级。
  - 常用命令
    - ZADD命令: 给排序集中添加元素
      - 使用方法： zadd hackers 1940 "Alan Kay"
    - ZRANGE命令: 获取排序集中一段区间的元素
      - 使用方法： zrange hackers 0 -1
    - ZRANK命令: 获取元素在排序集中的等级
      - 使用方法： zrank hackers "Anita Borg"

6. 字节数组(也叫做简单位图)
  - 注释
    - 位图不是一个实际的数据类型，它有一组面向位操作组成，实际类型仍然是字符串。
    - 位图可以最大存储2的32次方个不同的位.
  - 使用案例
    - 用于对各种类型的实时统计操作（人口统计）。
    - 用于存储与对象ID相关联的高效但高性能的布尔类型信息（统计网站每日访问的最长连续的用户）
  - 常用命令
    - SETBIT命令: 用于设置某个键的某个位的布尔值
      - 使用方法： setbit key 10 1
    - GETBIT命令: 用于获取某个键的某个位的布尔值
      - 使用方法： getbit key 10
    - BITCOUNT命令: 用于统计某个键的所有位的布尔值为1的数量
      - 使用方法： bitcount key

7. HyperLogLogs
  - 注释
    - HyperLogLogs是一个用于统计唯一数据的概率性的数据结构。
    - HyperLogLogs是一个不同的数据结果，它被编码成一个Redis的字符串。
    - 当给HyperLogLogs添加数据时，并没有做真实的添加，只是添加一个状态。
  - 使用案例
    - 用于统计用户每天查询的数据，去掉重复。
  - 常用命令
    - PFADD命令: 添加新的元素
      - 使用方法： pfadd hll a b c d
    - PFCOUNT : 检索当前唯一的近似的元素数目
      - 使用方法： pfcount hll

## 额外
所有的详细信息可以查看这个[document](https://redis.io/topics/data-types-intro)
