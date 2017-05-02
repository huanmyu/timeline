# PHP执行过程
1. Zend Engine 调用词法分析器（Lex生成，　Zend/zend_language_sacnner.l)
（去掉源代码空格，注释，分割成一个个的token
2. Zend Engine 把token　foward给语法分析器(yacc生产，　Zend/zend_language_parser.y)
  (生成一个个的opcode, opcode会以op array的形式存在，它是php执行的中间语言)
3. Zend Engine 调用zend_executor来执行op array输出结果


ZE是一个虚拟机，正是由于它的存在，所以才能使得我们写PHP脚本，完全不需要考虑所在的操作系统类型是什么。
ZE是一个CISC（复杂指令处理器）， 它支持150条指令（具体指令在 Zend/zend_vm_opcodes.h），
包括从最简单的ZEND_ECHO(echo)到复杂的 ZEND_INCLUDE_OR_EVAL(include,require)，
所有我们编写的PHP都会最终被处理为这150条指令(op code)的序列，从而最终被执行。












作者: Laruence
本文地址: http://www.laruence.com/2008/08/11/147.html
转载请注明出处
