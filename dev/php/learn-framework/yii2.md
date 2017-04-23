## Yii
1. 安装composer
2. 安装php-mbstring, php-xml扩展
3. php composer.phar global require "fxp/composer-asset-plugin:^1.2.0"
4. php composer.phar create-project yiisoft/yii2-app-advanced yii-advanced 2.0.11
5. [start-document](https://github.com/yiisoft/yii2-app-advanced/blob/master/docs/guide/start-installation.md)
6. 如果直接git clone,只需要前两步和additional的第一步，然后composer install或者composer update

### additional
1. 安装php-mongodb扩展 to use yii2-mongodb
2. php composer.phar require --prefer-dist yiisoft/yii2-mongodb
3. mac安装php扩展的命令(brew install php71-mcrypt php71-redis php71-mongodb)

### work1
1. yii framework初始化
2. 继承关系
  ==> 实现
  --> 继承
  Object类 ==> Configurable接口
  Behavior类 --> Object类
  Event类 --> Object类
  Component类 --> Object类
  Container类 --> Component类
  ServiceLocator类 --> Component类
  Module类 --> ServiceLocator类
  Application类 --> Module类

3. 使用到的PHP函数
    - is_scalar — 检测变量是否是一个标量
    - is_resource — 检测变量是否为资源类型
    - ctype_digit — 做纯数字检测

    - php_sapi_name — 返回 web 服务器和 PHP 之间的接口类型

    - ob_get_level — 返回输出缓冲机制的嵌套级别
    - ob_clean — 清空（擦掉）输出缓冲区
    - ob_end_clean — 清空（擦除）缓冲区并关闭输出缓冲

    - ReflectionMethod 类报告了一个方法的有关信息（new \ReflectionMethod($this, $methodName)）

    - array_shift — 将数组开头的单元移出数组
    - array_unshift — 在数组开头插入一个或多个单元
    - array_intersect — 计算数组的交集
    - array_combine — 创建一个数组，用一个数组的值作为其键名，另一个数组的值作为其值
    - array_walk — 使用用户自定义函数对数组中的每个元素做回调处理
      - 典型情况下 callback 接受两个参数。array 参数的值作为第一个，键名作为第二个。
    - array_filter — 用回调函数过滤数组中的单元
    - array_intersect_key — 使用键名比较计算数组的交集
    - array_diff — 计算数组的差集
    - array_values — 返回 input 数组中所有的值并给其建立数字索引。

    - implode — 将一个一维数组的值转化为字符串
    - explode — 使用一个字符串分割另一个字符串

    - get_called_class — 后期静态绑定（"Late Static Binding"）类的名称
    - class_exists — 检查类是否已定义
    - func_get_args — 返回一个包含函数参数列表的数组
    - class_parents — 返回一个包含了指定类class父类名称的数组
    - class_implements — 返回一个数组，该数组中包含了指定类class及其父类所实现的所有接口的名称
    - call_user_func — 把第一个参数作为回调函数调用;第一个参数 callback 是被调用的回调函数，其余参数是回调函数的参数
    - is_callable — 检测参数是否为合法的可调用结构
    - gettype — 获取变量的类型
    - instanceof 用于确定一个 PHP 变量是否属于某一类 class 的实例;也可用来确定一个变量是不是继承自某一父类的子类的实例;也可用于确定一个变量是不是实现了某个接口的对象的实例
    - is_a — 如果对象属于该类或该类是此对象的父类则返回 TRUE

    - strncmp — 二进制安全比较字符串开头的若干个字符
    - strncasecmp — 二进制安全比较字符串开头的若干个字符（不区分大小写）
    - preg_match — 执行匹配正则表达式
    - fnmatch — 用模式匹配文件名（fnmatch() 检查传入的 string 是否匹配给出的 shell 统配符 pattern。）

    - date_default_timezone_get — 取得一个脚本中所有日期时间函数所使用的默认时区
    - date_default_timezone_set — 设定用于一个脚本中所有日期时间函数的默认时区

    - $_SERVER — 服务器和执行环境信息
    - $_SERVER['argv'] — 传递给该脚本的参数的数组。当脚本以命令行方式运行时，argv 变量传递给程序 C 语言样式的命令行参数。当通过 GET 方式调用时，该变量包含query string。

    - exit — 输出一个消息并且退出当前脚本(尽管调用了 exit()， Shutdown函数 以及 object destructors 总是会被执行。)

    - openssl_random_pseudo_bytes — Generate a pseudo-random string of bytes
    - strtr — 转换指定字符
    - strpos — 查找字符串首次出现的位置
    - ltrim — 删除字符串开头的空白字符（或其他字符）

    - spl_autoload_register — 注册给定的函数作为 __autoload 的实现
    - BadMethodCallException — 当一个回调方法是一个未定义的方法或缺失一些参数时会抛出该异常。
