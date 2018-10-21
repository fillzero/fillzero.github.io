---
layout: post
title:  "深入分析FreeDos -- Image分析"
date:   2013-08-22 11:15:22
categories: freedos
---
好了，代码编译OK，也可以运行。现在是不是可以分析Kernel了呢？

别急，先分析下Image， 即dostest.img， 这里说的Image可以认为是虚拟软盘。

前面我写了个程序buildimg.c。就是将boot.bin，KERNEL.SYS，COMMAND.COM组装到dostest.img中，看似简单，其实里面有很多细节，下面一一道来。

要先分析Image，因为Image是Fat12文件系统，引导扇区执行的时候，就是读取FAT12文件系统，找到KERNEL.SYS，将其加载到内存中并执行的。

![pic]({{ site.url }}/assets/2014_09_25_1.44_floppy.jpg)

上面是1.44M Image的大致结构图，1.44M = 1.44 * 1000 * 1024 = 0x168000

简单理解如下：
<pre>
引导扇区放在第一个sector中，每512个字节就是一个sector(磁道)，

FAT1是存放文件占用的cluster，FAT2内容同FAT1，备份用的

下面根目录区是用来存放文件属性的，例如文件名，文件时间，文件大小等。

再下面的数据区就是存放文件内容的
</pre>

更多FAT12细节，参考手册： <a href="http://pan.baidu.com/s/1qWLRty0">FAT12Description.pdf</a>

OK，下面是具体的1.44M虚拟软盘里面的内容，截图如下：

![pic]({{ site.url }}/assets/2014_09_26_1.44_floppy_content_.jpg)


<br>
好了，那如何读盘找到KERNEL.SYS文件呢？

方法是这样的：

先读取根目录区里面的内容，查找KERNEL.SYS文件，如下，偏移地址0x261a处的0x2表示KERNEL.SYS文件从cluster 2处开始，

{% highlight asm %}
2600:  4b45 524e 454c 2020 5359 5320 0000 0000     KERNEL  SYS ....
2610:  0000 0000 0000 0000 0000 0200 2830 0100     ............(0..
2620:  434f 4d4d 414e 4420 434f 4d20 0000 0000     COMMAND COM ....
2630:  0000 0000 0000 0000 0000 9b00 288d 0000     ............(...
{% endhighlight %}

下面就是读FAT系统表了，从地址0x200处开始，03,04,05,。。。。。一直读到0xFF截止。。。。。,98,99,9A,FF

好了，不读了，下面的9C,9D，9E啊，那是COMMAND.COM占用的cluster，如上图所示。

算一下，0x9B-0x3+1= 153个cluster，每个cluster为512个字节

<pre>
PS： 也可以反算下，我们知道KERNEL.SYS文件大小为77864，  
     77864 / 512 = 152.078，所以KERNE.SYS的内容占用了153个cluster
</pre>

OK，既然知道了从第三个cluster开始，连续读153个，剩下的就是驱动软驱马达，将KERNEL.SYS读取到内存中，然后将控制权交给KERNEL，内核不就执行了吗！

是不是很简单？其实上面的这些步骤就是引导扇区(boot.bin)做的事！下面就开始分析boot.bin吧  ^_^