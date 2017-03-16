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
    创建外部迭代器的接口。
2. ArrayAccess（数组式访问）接口
    提供像访问数组一样访问对象的能力的接口。
3. ArrayIterator迭代器允许在遍历数组和对象时删除和更新值与键
