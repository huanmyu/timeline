# PHP

### 变量
1. 标量变量是指那些包含了 integer、float、string 或 boolean的变量，而 array、object 和 resource 则不是标量。
2. 资源 resource 是一种特殊变量，保存了到外部资源的一个引用。资源是通过专门的函数来建立和使用的。由于资源类型变量保存有为打开文件、数据库连接、图形画布区域等的特殊句柄，因此将其它类型的值转换为资源没有意义。

### 预定义常量
1. PHP 常量 PHP_SAPI 具有和 php_sapi_name() 相同的值。php_sapi_name — 返回 web 服务器和 PHP 之间的接口类型，可能返回的值包括了 aolserver、apache、 apache2filter、apache2handler、 caudium、cgi （直到 PHP 5.3）, cgi-fcgi、cli、 cli-server、 continuity、embed、fpm-fcgi、 isapi、litespeed、 milter、nsapi、 phttpd、pi3web、roxen、 thttpd、tux 和 webjames。

### 运算符
1.类型运算符 instanceof 用于确定一个 PHP 变量是否属于某一类 class 的实例

### 输出缓冲控制
1. 当PHP脚本有输出时，输出控制函数可以用这些来控制输出。这在多种不同情况中非常有用，尤其是用来在脚本开始输出数据后，发送http头信息到浏览器。输出控制函数不影响由 header() 或 setcookie()发送的文件头信息，仅影响象 echo这样的函数和PHP代码块间的数据。
2. 你所有需要输出到浏览器的数据将会一直缓存在服务器端，直到你发送他们，这将造成比较大的资源开销。你可以是用输出缓冲来避开这个问题。你可以通过在脚本里使用ob_start()和ob_end_flush()或者直接在你的php.ini文件里设置output_buffering，也可以直接在服务器的配置文件里设置。

### 反射
1. PHP 5 具有完整的反射 API，添加了对类、接口、函数、方法和扩展进行反向工程的能力。 此外，反射 API 提供了方法来取出函数、类和方法中的文档注释。
2. ReflectionMethod 类报告了一个方法的有关信息。

### 类/对象的信息
1. 这些函数允许你获得类和对象实例的相关信息。 你可以获取对象所属的类名，也可以是它的成员属性和方法。 通过使用这些函数，你不仅可以找到对象和类的关系，也可以是它们的继承关系（例如，对象类继承自哪个类）。
2. get_class — 返回对象的类名
3. class_alias — 为一个类创建别名

### 预定义接口
1. IteratorAggregate（聚合式迭代器）接口
  - 创建外部迭代器的接口。
2. ArrayAccess（数组式访问）接口
  - 提供像访问数组一样访问对象的能力的接口。
3. ArrayIterator迭代器允许在遍历数组和对象时删除和更新值与键
4. Closure 类用于代表 匿名函数 的类。
  - 匿名函数（在 PHP 5.3 中被引入）会产生这个类型的对象。
  - 这个类带有一些方法，允许在匿名函数创建后对其进行更多的控制。
  ```
  Closure {
  /* 方法 */
  __construct ( void ) // 用于禁止实例化的构造函数
  public static Closure bind ( Closure $closure , object $newthis [, mixed $newscope = 'static' ] ) // 复制一个闭包，绑定指定的$this对象和类作用域。
  public Closure bindTo ( object $newthis [, mixed $newscope = 'static' ] ) // 复制当前闭包对象，绑定指定的$this对象和类作用域。
  }
  ```

### 函数
1. 匿名函数， 匿名函数目前是通过 Closure 类来实现的。
2. 闭包可以从父作用域中继承变量。 任何此类变量都应该用 use 语言结构传递进去。 PHP 7.1 起，不能传入此类变量： superglobals、 $this 或者和参数重名。

### The Common Gateway Interface [CGI](http://www.faqs.org/rfcs/rfc3875.html)
1. The Common Gateway Interface (CGI) allows an HTTP server and a CGI script to share responsibility for responding to client requests.
2. The server acts as an application gateway.  It receives the request from the client, selects a CGI script to handle the request, converts the client request to a CGI request, executes the script and converts the CGI response into a response for the client.

### FastCGI 进程管理器（FPM）
1. FPM（FastCGI 进程管理器）用于替换 PHP FastCGI 的大部分附加功能，对于高负载网站是非常有用的。
2. 它的功能包括：
  - 支持平滑停止/启动的高级进程管理功能；
  - 可以工作于不同的 uid/gid/chroot 环境下，并监听不同的端口和使用不同的 php.ini 配置文件（可取代 safe_mode 的设置）；
  - stdout 和 stderr 日志记录;
  - 在发生意外情况的时候能够重新启动并缓存被破坏的 opcode;
  - 文件上传优化支持;
  - "慢日志" - 记录脚本（不仅记录文件名，还记录 PHP backtrace 信息，可以使用 ptrace或者类似工具读取和分析远程进程的运行数据）运行所导致的异常缓慢;
  - fastcgi_finish_request() - 特殊功能：用于在请求完成和刷新数据后，继续在后台执行耗时的工作（录入视频转换、统计处理等）；
  - 动态／静态子进程产生；
  - 基本 SAPI 运行状态信息（类似Apache的 mod_status）；
  - 基于 php.ini 的配置文件。

### PHP 的命令行模式（CLI SAPI）
1. CLI SAPI 强制覆盖了 php.ini 中的某些设置
  - implicit_flush: 设置为TRUE; 在命令行模式下，所有来自 print 和 echo 的输出将被立即写到输出端，而不作任何地缓冲操作。如果希望延缓或控制标准输出，仍然可以使用 output buffering 设置项。
  - max_execution_time: 设置为0（无限值）;鉴于在外壳环境下使用 PHP 的无穷的可能性，最大运行时间被设置为了无限值。
  - register_argc_argv: 设置为TRUE; 由于该设置为 TRUE，将总是可以在 CLI SAPI 中访问到 argc（传送给应用程序参数的个数）和 argv（包含有实际参数的数组）。
2. 在命令行下，运行 php -v 便能得知该 php 是 CGI 还是 CLI。
3. The CLI SAPI defines a few constants for I/O streams to make programming for the command line a bit easier.（STDIN, STDOUT, STDERR）
  If you want to read single line from stdin, you can use
  ```
  <?php
  $line = trim(fgets(STDIN)); // reads one line from STDIN
  fscanf(STDIN, "%d\n", $number); // reads number from STDIN
  ?>
  ```
4. CLI SAPI 提供了一个内置的Web服务器。这个内置的Web服务器主要用于本地开发使用，不可用于线上产品环境。URI请求会被发送到PHP所在的的工作目录（Working Directory）进行处理，除非你使用了-t参数来自定义不同的目录。当你在命令行启动这个Web Server时，如果指定了一个PHP文件，则这个文件会作为一个“路由”脚本，意味着每次请求都会先执行这个脚本。如果这个脚本返回 FALSE ，那么直接返回请求的文件（例如请求静态文件不作任何处理）。否则会把输出返回到浏览器。
