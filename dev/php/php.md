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
4. 要创建一个类的实例，必须使用 new 关键字。在类定义内部，可以用 new self 和 new parent 创建新对象。
5. 使用 ClassName::class 你可以获取一个字符串，包含了类 ClassName 的完全限定名称。
6. $this 指向当前的 object, self 指向当前的 class。
7. class_exists — 检查类是否已定义; interface_exists — 检查接口是否已被定义; trait_exists — 检查指定的 trait 是否存在。
8. 在编写面向对象（OOP） 程序时，很多开发者为每个类新建一个 PHP 文件。 这会带来一个烦恼：每个脚本的开头，都需要包含（include）一个长长的列表（每个类都有个文件）。在 PHP 5 中，已经不再需要这样了。 spl_autoload_register() 函数可以注册任意数量的自动加载器，当使用尚未被定义的类（class）和接口（interface）时自动去加载。通过注册自动加载器，脚本引擎在 PHP 出错失败前有了最后一个机会加载所需的类。
9. get_called_class — 后期静态绑定（"Late Static Binding"）类的名称
10. require 和 include 几乎完全一样，除了处理失败的方式不同之外。require 在出错时产生 E_COMPILE_ERROR 级别的错误。换句话说将导致脚本中止而 include 只产生警告（E_WARNING），脚本会继续运行。
11. 当一个文件被包含时，其中所包含的代码继承了 include 所在行的变量范围。从该处开始，调用文件在该行处可用的任何变量在被调用的文件中也都可用。不过所有在包含文件中定义的函数和类都具有全局作用域。
12. self，parent 和 static这三个特殊的关键字是用于在类定义的内部对其属性或方法进行访问的。 

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
### 异常
#### 预定义异常
1. Exception是所有异常的基类。
2. ErrorException是错误异常。
#### SPL异常
1. SPL 提供一系列标准异常。
2. LogicException (extends Exception)
  - BadFunctionCallException
    - BadMethodCallException
  - DomainException
  - InvalidArgumentException
  - LengthException
  - OutOfRangeException
3. RuntimeException (extends Exception)
  - OutOfBoundsException
  - OverflowException
  - RangeException
  - UnderflowException
  - UnexpectedValueException

## 重载
1. PHP所提供的"重载"（overloading）是指动态地"创建"类属性和方法。我们是通过魔术方法（magic methods）来实现的。当调用当前环境下未定义或不可见的类属性或方法时，重载方法会被调用。
2. 属性重载
- 在给不可访问属性赋值时，__set() 会被调用。public void __set ( string $name , mixed $value )
- 读取不可访问属性的值时，__get() 会被调用。public mixed __get ( string $name )
- 当对不可访问属性调用 isset() 或 empty() 时，__isset() 会被调用。public bool __isset ( string $name )
- 当对不可访问属性调用 unset() 时，__unset() 会被调用。public void __unset ( string $name )
- 参数 $name 是指要操作的变量名称。__set() 方法的 $value 参数指定了 $name 变量的值。
- 属性重载只能在对象中进行。在静态方法中，这些魔术方法将不会被调用。所以这些方法都不能被 声明为 static。
3. 方法重载
- 在对象中调用一个不可访问方法时，__call() 会被调用。public mixed __call ( string $name , array $arguments )
- 在静态上下文中调用一个不可访问方法时，__callStatic() 会被调用。public static mixed __callStatic ( string $name , array $arguments )
- $name 参数是要调用的方法名称。$arguments 参数是一个枚举数组，包含着要传递给方法 $name 的参数。

## 对象复制
1. 对象复制可以通过 clone 关键字来完成（如果可能，这将调用对象的 __clone() 方法）。对象中的 __clone() 方法不能被直接调用。
2. 当对象被复制后，PHP 5 会对对象的所有属性执行一个浅复制（shallow copy）。所有的引用属性 仍然会是一个指向原来的变量的引用。
3. 当复制完成时，如果定义了 __clone() 方法，则新创建的对象（复制生成的对象）中的 __clone() 方法会被调用，可用于修改属性的值（如果有必要的话）。void __clone ( void )
## 函数
### 匿名函数
1. 匿名函数目前是通过 Closure 类来实现的。
2. 闭包可以从父作用域中继承变量。 任何此类变量都应该用 use 语言结构传递进去。 PHP 7.1 起，不能传入此类变量： superglobals、 $this 或者和参数重名。
### SPL 函数
1. spl_autoload_register — 注册给定的函数作为 __autoload 的实现。
  - 将函数注册到SPL __autoload函数队列中。如果该队列中的函数尚未激活，则激活它们。

## 命名空间
1. PHP 命名空间提供了一种将相关的类、函数和常量组合到一起的途径。 在PHP中，命名空间用来解决在编写类库或应用程序时创建可重用的代码如类或函数时碰到的两类问题：
- 用户编写的代码与PHP内部的类/函数/常量或第三方类/函数/常量之间的名字冲突。
- 为很长的标识符名称(通常是为了缓解第一类问题而定义的)创建一个别名（或简短）的名称，提高源代码的可读性。
2. 命名空间通过关键字namespace 来声明。
3. 访问任意全局类、函数或常量，都可以使用完全限定名称，例如 \strlen() 或 \Exception 或 \INI_ALL。
4. PHP支持两种抽象的访问当前命名空间内部元素的方法，__NAMESPACE__ 魔术常量和namespace关键字。
5. 如果没有定义任何命名空间，所有的类与函数的定义都是在全局空间，与 PHP 引入命名空间概念前一样。在名称前加上前缀 \ 表示该名称是全局空间中的名称，即使该名称位于其它的命名空间中时也是如此。
6. 使用use操作符导入/使用别名

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
