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
2. 使用到的PHP函数
    is_scalar — 检测变量是否是一个标量
    is_resource — 检测变量是否为资源类型

    php_sapi_name — 返回 web 服务器和 PHP 之间的接口类型

    ob_get_level — 返回输出缓冲机制的嵌套级别
    ob_clean — 清空（擦掉）输出缓冲区
    ob_end_clean — 清空（擦除）缓冲区并关闭输出缓冲

    ReflectionMethod 类报告了一个方法的有关信息（new \ReflectionMethod($this, $methodName)）

    array_unshift — 在数组开头插入一个或多个单元
    array_intersect — 计算数组的交集
    array_combine — 创建一个数组，用一个数组的值作为其键名，另一个数组的值作为其值

    get_called_class — 后期静态绑定（"Late Static Binding"）类的名称
    class_exists — 检查类是否已定义

    strncmp — 二进制安全比较字符串开头的若干个字符
    preg_match — 执行匹配正则表达式
    fnmatch — 用模式匹配文件名（fnmatch() 检查传入的 string 是否匹配给出的 shell 统配符 pattern。）

    date_default_timezone_get — 取得一个脚本中所有日期时间函数所使用的默认时区
    date_default_timezone_set — 设定用于一个脚本中所有日期时间函数的默认时区
