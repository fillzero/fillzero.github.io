---
layout: post
title:  "深入分析FreeDos -- KERNEL.MAP"
date:   2013-08-26 11:15:22
categories: freedos
---

虽然CPU已经开始执行KERNEL代码了，先不急分析KERNEL。

不知道对于上节boot将KERNEL放置在0x600处还有没有其它疑问？

<font color="#ff0000">必须要放到0x600处吗?</font>
<pre>
如果KERNEL.SYS已经给定好了，那boot必须得将KERNEL放到0x600处。
编译KERNEL有如下命令中：
exeflat kernel.exe kernel.sys 0x60
即将KERNEL的所有符号(变量啊，函数啊)的段偏移地址加上0x60，如果KERNEL.EXE中的某个函数地址为0x153，那么其在KERNEL.SYS中的地址为0x753。
因为KERNEL要被放置在内存0x600处，起始地址都换成0x600了，不是默认的0x0，所以所有的符号地址都得加上0x600。
</pre>

编译我给出的版本，在build目录下会生成个KERNEL.MAP。下面开始分析这个文件，这个文件很重要，等同于Linux Kernel的 System.map

KERNEL.MAP列出了KERNEL.SYS文件由哪些内容组成。

KERNEL.SYS由上往下分布着：CODE段， DATA段，BSS段， INIT段，STACK段。

![pic](http://fillzero.qiniudn.com/2014_09_28_kernel_map.jpg)

重点在于INIT段，<font color="#ff0000">别有用心的将其放在最后，后面跟着statck段，而且设置Stack大小为0，为什么这样设计？</font>

<pre>
先看下INIT段的编译命令：
tcc -1- -O -Z -d -I. -D__STDC__=0;DEBUG;KERNEL;I86;PROTO;ASMSUPT <font color="#ff0000">-zAINIT -zCINIT_TEXT</font> -zPIGROUP -c <font color="#ff0000">initoem.c</font>
tcc -1- -O -Z -d -I. -D__STDC__=0;DEBUG;KERNEL;I86;PROTO;ASMSUPT <font color="#ff0000">-zAINIT -zCINIT_TEXT</font> -zPIGROUP -c <font color="#ff0000">main.c</font>
tcc -1- -O -Z -d -I. -D__STDC__=0;DEBUG;KERNEL;I86;PROTO;ASMSUPT <font color="#ff0000">-zAINIT -zCINIT_TEXT</font> -zPIGROUP -c <font color="#ff0000">config.c</font>
这些都是初始化代码，简而言之<font color="#0000ff">只运行一次</font>，从KERNEL.MAP中看下INIT段大小，约为6.2KB，
在内存吃紧的DOS年代，这只用了一次的6.2KB是不能浪费的。
那怎么利用呢？KERNEL本身有些数据结构需要大块内存的，例如构建文件系统，缓冲区，还需要栈，存放各种临时数据，如调用函数时，将参数啊，下条指令地址啊放在栈中。
所以INIT段就用于存放KERNEL本身需要的数据，这样，6.2KB的空间就被利用起来了。
<!--
那怎么利用呢？干脆用于系统堆栈区吧， 存放各种临时数据，如调用函数时，将参数啊，下条指令地址啊放在栈中。
因为一般是操作栈顶，后进先出，栈底的值不变，所以将栈底放置在INIT段末尾，这样，6.2KB的空间就被利用起来了。-->
</pre>


问题又来了，<font color="#ff0000">怎么判断INIT段全部执行完了，即"这块内存没有利用价值呢"？</font>
<pre>
先看下INIT代码会干嘛，INIT段会做很多事情，除了设置我们熟悉的INIT 21中断，初始化硬件驱动，如软盘啊，串口啊，打印机啊。。 设置好文件系统。。。
总而言之，言而总之，设置好环境，再跳到CODE段，让第一个任务执行起来。

细心的你，有没有发现，这些初始化代码很多都是C代码耶，<font color="#0000ff">调用C函数，必须要用到栈</font>，栈就放在INIT段里面，push操作，就将段里的内容给改了，
万一 CS:IP指向了栈里修改过的地方，后果<font color="#ff0000">”不堪设想“</font>

那肿么办？
还记得上一节，boot为防止自己被KERNEL覆盖，会将自己从0:7C00处挪到1FE0:7C00处吗？
这里KERNLE也一样，在用到栈之前，将INIT段重找个位置安家，就放置在内存的最末端吧，然后和boot一样，跳到内存末端的INIT段执行，
<!--这样原先的INIT段被Stack段占用了，管你Stack把内存改成啥样，也不影响INIT执行了，是不是很巧妙？-->
这样原先的INIT段就可以存放KERNEL需要的数据啦，管你把内存改成啥样，也不影响INIT执行了，是不是很巧妙？

<font color="#0000ff">嘿嘿，这个技巧在Linux Kernel里面也有</font>，linux kernel的头部也是用于初始化的，用完之后就不用了，头部占用的内存被用作页目录项，页表项了。
正如我在前言中所说，操作系统很多原理是相通的，弄懂一个，其它的自然触类旁通。
</pre>

说了这么多，KERNEL.MAP详细组成部分还没有详细列出，列举如下：

![pic](http://fillzero.qiniudn.com/2014_09_28_kernel_map_contains.jpg)

<pre>
解释下，CODE段由_TEXT, _IO_TEXT, _IO_FIXED_DATA三部分组成。
而_IO_TEXT 又由Io.asm， Console.asm， Printer.asm三个文件中的部分Symbol(符号，一段汇编代码的起始标记，类似于C语言的函数名)组成

BSS段由 _BSS，_BSS_END两部分组成。
其中_BSS段由 Kernel.asm， Globals.h， Config.c三个文件中的部分未初始化的变量组成
_BSS_END由Kernel.asm部分未初始化变量组成（查看代码可以看出是用于存放设备堆栈）。

还可以看出，一个文件的内容会分布在不同的段中。函数代码放在TEXT段，变量放在DATA段或BSS段。

从上面这张图，顺路还验证了C语言的几个知识点：
1. 声明并赋值的变量放在DATA段，声明未赋值的变量放在BSS段。
  例如int i = 1; 变量i会放在DATA段。
  int j; 变量j会放在BSS段，这个段里面的内存值未知，若使用前未赋值，直接将其值赋给其它变量，那结果就未知了。
  
2. 还发现，static 函数的符号没有出现在KERNEL.MAP中。
  因为一个被声明为静态的函数只可被这一模块内的其它函数调用。即，其它文件中的函数是看不到这个函数的，无法调用此函数。
  所以static函数不会出现在符号表(KERNEL.MAP)中。

</pre>

看了上面的图，大家应该会对KERNEL各个代码在内存中的布局有大致印象。

接下来，CPU的的IP指针会在CODE段，INIT段里跳来跳去，偶尔也会跑到BIOS里逛逛。

期间DATA段，BSS段里的内容陆陆续续的被修改了，屏幕上也会跳出一行行黑刷刷的英文。。。。。

哦，对了，还有个重要细节：在KERNEL链接的时候，kernel.asm代码是放在最前面的，所以在内存0x600处的就是kernel.asm代码。

OK，下面就正式进入KERNEL代码分析了。