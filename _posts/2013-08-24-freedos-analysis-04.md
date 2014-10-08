---
layout: post
title:  "深入分析FreeDos -- 引导代码"
date:   2013-08-24 11:15:22
categories: freedos
---

好了，下面开始分析boot.bin了，放置在软盘的前512字节中。

如何判断一个软盘是引导软盘呢？ 这个任务是交给在BIOS的。

BIOS会读取软盘的前512字节，如果第511个，512个字节的内容为0x55AA，就认定这是个引导软盘，将这512字节放置在内存0x7c00处，并跳转执行。

boot的目的我前一节说过了，就是查找KERNEL.SYS所在软盘位置，将其读到内存中，并跳转执行。

下面是详细细节：
<pre>
BIOS执行时，设置好了中断向量，boot执行前，内存分布如下：
;	| ROM    |
;	| BIOS   | 0xE000:0000
;	|        |
;	|        |
;	| VGA    |
;	| BIOS   | 0xC000:0000
;	|        |
;	|        |
;	|        |
;	|        |
;	|        |
;	|        |
;	|--------|
;	|BOOT SEC|
;	|ORIGIN  | 07C0:0000
;	|--------|
;	|        |
;	|--------| 0x40:0000
;	|中断向量|
;	|_______ | 0x0:0000
</pre>

boot会先将自己copy到内存1FE0:7c00处， 0x1FE00+0x7C00=0x27a00 = 158.5K, 即内存偏移158.5K处。
{% highlight asm %}

    ;
    mov ax, 0x1FE0    ;目的段地址1FE0
    mov	es, ax
    mov	si, bp        ;bp=0x7C00
    mov	di, bp
    mov	cx, 0x0100    ;copy 256次，每次copy 2个字节，=> copy 512个字节
    rep movsw         
{% endhighlight %}

执行完后，内存分布如下：
<pre>
;	|--------| 2000:0000
;	|BOOT SEC|
;	|RELOCATE|
;	|--------| 1FE0:0000
;	|        |
;	|        |
;	|--------|
;	|BOOT SEC|
;	|ORIGIN  | 07C0:0000
;	|--------|
;	|        |
;	|--------| 0x40:0000
;	|中断向量|
;	|_______ | 0x0:0000
</pre>

然后如下操作, retf执行后CS=0x1FE0， IP=cont偏移地址，所以下面CPU就在copy过去的boot.bin中执行了
{% highlight asm %}
;
    push	es			;	ES=0x1FE0, 压栈
    mov		bx, cont
    push	bx			;	bx=cont的偏移地址， 压栈
    retf				;	retf执行完后，CPU自动将栈中的内容POP给IP，CS
{% endhighlight %}

也就是说0x7C00那块的512字节内存已经没有"利用价值了"。

<font color="#ff0000">疑问：boot为什么要将自己挪到断地址为1FE0处？</font>
<pre>
先算下0000:7C00所在的内存偏移：0+0x7C00 = 31KB， 0x7C00之前只有31K的可用内存空间。
boot的目的就是将KERNEL.SYS载入内存，而KERNEL.SYS一般比较大，这个版本的大小约为77KB，
如果从内存开始的地方就放置KERNEL，0x7C00处会被覆盖掉，那boot还怎么执行啊？
所以boot先要将自己挪到内存高处，方便加载KERNEL。

但是目的段不一定必须为1FE0，将其改为3BC0，重新编译运行，也是可以正常加载KERNEL的，可以试试。
</pre>

剩下的就是读盘，因软盘系统为FAT12格式，所以要找到KERNEL.SYS文件，如前一节所述，要有一段的逻辑代码，先弄懂FAT12格式，再看汇编代码就容易了。

将KERNEL.SYS放到偏移0x60:0000处，然后来个跳转到执行KERNEL代码。
{% highlight asm %}
;
%define LOADSEG         0x0060
boot_success:   
	mov     bl, [drive]
	jmp	word LOADSEG:0
{% endhighlight %}

<font color="#ff0000">疑问：为什么要将KERNEL放到0x600处?</font>
<pre>
0-0x3FF存放的是中断向量。 0x400-0x5FF 存放BIOS的数据，如当前时间等。
即前面的内容都被占用了，所以KERNEL只能放置在偏移0x600往后的空间了。

在KERNEL执行之前的内容分布如下：
;	| ROM    |
;	| BIOS   | 0xE000:0000
;	|        |
;	|        |
;	| VGA    |
;	| BIOS   | 0xC000:0000
;	|        |
;	|        |
;	|        |
;	|        |
;	|        |
;	|        |
;	|--------|
;	|KERNEL  |
;	|LOADED  |
;	|--------| 0060:0000
;	|        |
;	|--------| 0x40:0000
;	|中断向量|
;	|_______ | 0x0:0000

</pre>