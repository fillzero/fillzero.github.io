---
layout: post
title:  "Bochs BIOS 研究 -- 代码分析"
date:   2013-05-11 12:15:22
categories: freedos
---

基础知识：

BIOS是放在EEPROM中的。x86 PC上电的时候，BIOS被映射在1M内存的末端。

1. 如果BIOS大小是64k，则其地址空间为0xF0000-0xFFFFF
2. 如果BIOS大小是128k，则其地址空间为0xE0000-0xFFFFF

还有个是VGABIOS，显示芯片驱动。大小一般不超过64K，映射在0xC0000-0xD0000区间

----------------------------------------------------

CPU上电复位时，内部寄存器的状态如下图所示(来自Intel Arch Volume3: System Programming Guide)，其中CS:IP=F000:FFF0H
![pic](http://fillzero.qiniudn.com/2014_09_25_intel_reset_register.jpg)

也就是说CPU执行的第一条指令是来自内存0xFFFF0处。这正好是1M内存的末端，存放BIOS的地方。

<hr>

OK,用ndisasm反汇编bios.bin，指定偏移地址为0xF0000, 将汇编代码输出到bios.asm文件中：
{% highlight bash %}
ndisasm -o 0xf0000 bios.bin > bios.asm
{% endhighlight %}

看看0xFFFF0处代码，如下，是个跳转：
{% highlight asm %}
000FFFF0  EA5BE000F0        jmp word 0xf000:0xe05b
{% endhighlight %}

也可以查看rombios.c代码，找到org 0xFFF0处汇编代码：
{% highlight asm %}
.org 0xfff0 ; Power-up Entry Point
  jmp 0xf000:post
{% endhighlight %}

跳转到post (Powser On Self Test, 上电自检) 处，然后执行一系列初始化函数，设置中断向量。

最后调用int 19中断，若第一启动项为软盘，将软盘的前512字节载入到0x7c00出并跳转执行。

![pic](http://fillzero.qiniudn.com/2014_09_25_bios_post.jpg)

<hr>
需要注意的是，在rom_scan的代码中，会检测vgabios，并跳到vgabios中初始化，初始化过程中显示如下版本信息：

![pic](http://fillzero.qiniudn.com/2014_09_25_vgabios_init.jpg)

好了，到这里应该对bios功能有大致了解，更多细节请查看源码。