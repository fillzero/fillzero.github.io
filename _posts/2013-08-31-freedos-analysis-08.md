---
layout: post
title:  "深入分析FreeDos -- COM文件加载与执行"
date:   2013-08-31 11:15:22
categories: freedos
---
现在已经走到了执行第一个任务的地方了，如下
<pre>
main()
      |-->init_kernel()
      |
      |-->kernel() -> p_0() -> <font color="#ff0000">DosExec(..."COMMAND.COM"...)</font>
</pre>

官方给出的COMMAND.COM是FreeCom，FreeCom有些复杂，既然我们研究的是COM文件加载执行，何不选择一个较小的COM文件，岂不更方便？

很多编程语言的第一个示例都是"Hello World"，这里我们也不脱俗，也用个只显示Hello World的COM文件作为研究对象。

{% highlight asm %}
;HelloWrold.asm
	org	0100h		; COM文件必须从偏移 0x100开始

	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	call	ShowHelloWorld	; 调用显示Hello World
	jmp	$		; 死循环
	;mov ah, 4ch		; 回退到DOS系统，在此不需要
	;int 21h
	
ShowHelloWorld:
	mov	ax, HelloStr
	mov	bp, ax		; ES:BP = 串地址
	mov	cx, 12		; CX = 串长度
	mov	ax, 01301h	; AH = 13,  AL = 01h
	mov	bx, 000ch	; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
	mov	dl, 0
	int	10h		; int 10h
	ret
HelloStr:	db	"Hello World!"
{% endhighlight %}

编译命令： nasm HelloWrold.asm -o COMMAND.COM

将COMMAND.COM放到Image(虚拟软盘)上，有很多种方法，也可以参考第二节，将这个COMMAND.COM放到build目录下，执行build.bat即可。

运行截图如下，左上角显示Hello World：

![pic](http://fillzero.qiniudn.com/2014_09_29_freedos_run_simplecom.jpg)

<hr>

先说下COM文件吧，上面的汇编代码设置 <font color="#0000ff">org	0100h</font>, <font color="#ff0000">为什么是0x100呢</font>？
<pre>
在COM执行前，DOS需要给COM分配256个字节的PSP段，用于保存程序状态。详见<a href="http://en.wikipedia.org/wiki/Program_Segment_Prefix">http://en.wikipedia.org/wiki/Program_Segment_Prefix</a>
将COM载入内存后，设置IP为0x100，即COM起始处。
</pre>

下面就分析COM的加载执行过程：

因为是COM文件，所以流程为DosExec() -> DosComloader()，Kernel先设置好环境变量，然后将COMMAND.COM加载进内存，如下图

![pic](http://fillzero.qiniudn.com/2014_09_29_freedos_comloader1.jpg)

加载完后，在COMMAND.COM内存前0x100处设置PSP，然后设置新任务的寄存器及栈空间，最后执行跳转：

![pic](http://fillzero.qiniudn.com/2014_09_29_freedos_comloader2.jpg)

上面的代码，先在当前段的末尾处划分块空间，保存新任务的寄存器。以当前版本为例，此时mem段为0x13EB，为新任务选择的栈地址为0x13EB:0xFFFE。
切换任务后，CS:IP为 13EB:100，即COMMAND.COM所在内存地址，开始执行COMMAND代码。
下面是任务切换前后CPU的寄存器对比：
<pre>
寄存器   任务切换前      任务切换后，执行COMMAND.COM
      _exec_user执行前   _exec_user执行后
AX       13EB            FFFF       
BX       0000            0000
CX       0004            0000
DX       0080            0000
SP       283E            <font color="#ff0000">FFFE</font>
BP       286A            0000
SI       0005            0000
DI       0000            0000
CS       0060            <font color="#ff0000">13EB</font>
DS       0F40            13EB
SS       0F40            13EB
ES       13EB            13EB
IP       E421            <font color="#ff0000">0100</font>
Flags    0246            0202
</pre>

最后，是COMMAND.COM执行时内存分配图：

![pic](http://fillzero.qiniudn.com/2014_09_29_freedos_command_mem.jpg)