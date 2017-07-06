# PHP执行过程
参考[Laruence: 深入浅出PHP(Exploring PHP)](http://www.laruence.com/2008/08/11/147.html)
编写的PHP脚本->到最后脚本被执行->得到执行结果分为如下几个阶段
1. Zend Engine调用词法分析器（Lex生成，源文件在 Zend/zend_language_sacnner.l), 将我们要执行的PHP源文件，去掉空格，注释，分割成一个个的token。
2. Zend Engine把token foward给语法分析器(yacc生产，源文件在 Zend/zend_language_parser.y), 生成一个个的opcode, opcode一般会以op array的形式存在，它是php执行的中间语言。
3. Zend Engine调用zend_executor来执行oparray输出结果

    script.php  <-----------------------------|
        |                                     |
    Lexer                                     |
             zend compile                     |
    parser                                    |
         |                                    |
      opcodes                                 |
         |                                    |
    executor  zend execute   --->   include/require or function call
      /   |   \
    Output Buffer

Zend Engine是一个虚拟机，正是由于它的存在，所以才能使得我们写PHP脚本，完全不需要考虑所在的操作系统类型是什么。
Zend Engine是一个CISC（复杂指令处理器）， 它支持150条指令（具体指令在 Zend/zend_vm_opcodes.h），
包括从最简单的ZEND_ECHO(echo)到复杂的 ZEND_INCLUDE_OR_EVAL(include,require)，
所有我们编写的PHP都会最终被处理为这150条指令(op code)的序列，从而最终被执行。

## 使用php7.1来分析

### 测试源代码

```
<?php
$i = "This is a string";
//I am comments
echo $i . ' that has been echoed to screen' . PHP_EOL;
```

### 输出Opcodes结果
```
php -d opcache.opt_debug_level=0x10000 testOpcodeGen.php

$_main: ; (lines=5, args=0, vars=1, tmps=3)
    ; (before optimizer)
    ; /home/vagrant/vm/testOpcodeGen.php:1-5
L0:     ASSIGN CV0($i) string("This is a string")
L1:     T2 = CONCAT CV0($i) string(" that has been echoed to screen")
L2:     T3 = CONCAT T2 string("
")
L3:     ECHO T3
L4:     RETURN int(1)
This is a string that has been echoed to screen
```

### Opcodes分析
每条opcode又叫做opline,结构体是在zend_compile.h中
```
struct _zend_op {
	const void *handler;
	znode_op op1;
	znode_op op2;
	znode_op result;
	uint32_t extended_value;
	uint32_t lineno;
	zend_uchar opcode;
	zend_uchar op1_type;
	zend_uchar op2_type;
	zend_uchar result_type;
};
```
其中opcode字段指明了这条opcode的操作类型，handler指明处理器，op1和op2是两个操作数，result是操作结果
查看zend_execute.h发现：
Zend Engine通过zend_compile_file或者zend_compile_string函数把php脚本文件或者字符串编译成zend_opcode_array。
```
extern ZEND_API zend_op_array *(*zend_compile_file)(zend_file_handle *file_handle, int type);
extern ZEND_API zend_op_array *(*zend_compile_string)(zval *source_string, char *filename);
```
zend_opcode_array会被Zend Engine通过zend_execute函数直接执行
```
ZEND_API void zend_execute(zend_op_array *op_array, zval *return_value);
```
zend_op_array的结构体如下：
```
struct _zend_op_array {
	/* Common elements */
	zend_uchar type;
	zend_uchar arg_flags[3]; /* bitset of arg_info.pass_by_reference */
	uint32_t fn_flags;
	zend_string *function_name;
	zend_class_entry *scope;
	zend_function *prototype;
	uint32_t num_args;
	uint32_t required_num_args;
	zend_arg_info *arg_info;
	/* END of common elements */

	uint32_t *refcount;

	uint32_t last;
	zend_op *opcodes;

	int last_var;
	uint32_t T;
	zend_string **vars;

	int last_live_range;
	int last_try_catch;
	zend_live_range *live_range;
	zend_try_catch_element *try_catch_array;

	/* static variables support */
	HashTable *static_variables;

	zend_string *filename;
	uint32_t line_start;
	uint32_t line_end;
	zend_string *doc_comment;
	uint32_t early_binding; /* the linked list of delayed declarations */

	int last_literal;
	zval *literals;

	int  cache_size;
	void **run_time_cache;

	void *reserved[ZEND_MAX_RESERVED_RESOURCES];
};
```
对于在全局作用域的代码，就是不包含在任何function内的op_array,它的function_name为NULL。结构体中的opcodes保存了属于这个op_array的opcode数组，zend_execute会从start_op开始，逐条解释执行传入的每条opcode, 从而实现我们PHP脚本想要的结果。

## PHP函数
在PHP中，函数分为俩种，
一种是zend_internal_function, 这种函数是由扩展或者Zend/PHP内核提供的，用'C/C++'编写的，可以直接执行的函数。
另外一种是zend_user_function, 这种函数呢，就是我们经常在见的，用户在PHP脚本中定义的函数，这种函数最终会被Zend Engine翻译成opcode array来执行。

zend_internal_function 相关结构体，位于zend_compile.h
```
/* zend_internal_function_handler */
typedef void (*zif_handler)(INTERNAL_FUNCTION_PARAMETERS);

typedef struct _zend_internal_function {
	/* Common elements */
	zend_uchar type;
	zend_uchar arg_flags[3]; /* bitset of arg_info.pass_by_reference */
	uint32_t fn_flags;
	zend_string* function_name;
	zend_class_entry *scope;
	zend_function *prototype;
	uint32_t num_args;
	uint32_t required_num_args;
	zend_internal_arg_info *arg_info;
	/* END of common elements */

	zif_handler handler;
	struct _zend_module_entry *module;
	void *reserved[ZEND_MAX_RESERVED_RESOURCES];
} zend_internal_function;
```
当PHP启动的时候 ，_zend_internal_function结构体会遍历每个载入的扩展模块，然后将模块中function_entry中指明的每一个函数， 创建一个zend_internal_function结构， 并将type置为ZEND_INTERNAL_FUNCTION(见下表), 将这个结构填入全局的函数表(一个HashTable);
```
#define ZEND_INTERNAL_FUNCTION				1
#define ZEND_USER_FUNCTION					2
#define ZEND_OVERLOADED_FUNCTION			3
#define	ZEND_EVAL_CODE						4
#define ZEND_OVERLOADED_FUNCTION_TEMPORARY	5
```
在Zend Engine中，用户定义的函数(userland function), 也会被翻译成一个oparray, 并填入全局函数表中。这个时候scope,function_name都不为空。而对于在全局作用域的直接代码来说，最后的op_array的scope为全局，function_name为空。
union _zend_function {
	zend_uchar type;	/* MUST be the first element of this struct! */
	uint32_t   quick_arg_flags;

	struct {
		zend_uchar type;  /* never used */
		zend_uchar arg_flags[3]; /* bitset of arg_info.pass_by_reference */
		uint32_t fn_flags;
		zend_string *function_name;
		zend_class_entry *scope;
		union _zend_function *prototype;
		uint32_t num_args;
		uint32_t required_num_args;
		zend_arg_info *arg_info;
	} common;

	zend_op_array op_array;
	zend_internal_function internal_function;
};
_zend_function的设计目标： zend_internal_function, zend_function, zend_op_array可以安全的互相转换
当在op code中通过ZEND_DO_FCALL调用一个函数的时候，Zend Engine会在函数表中，根据名字（其实是lowercase的函数名字，这也就是为什么PHP的函数名是大小写不敏感的)查找函数， 如果找到，返回一个
zend_function结构的指针(仔细看这个上面的zend_function结构), 然后判断type,如果是ZEND_INTERNAL_FUNCTION， 那么Zend Engine就调用zend_execute_internal,
通过zend_internal_function.handler来执行这个函数， 如果不是，就调用zend_execute来执行这个函数包含的zend_op_array.
