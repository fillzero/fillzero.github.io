---
layout: post
title:  "深入分析FreeDos -- 后续"
date:   2013-09-02 11:15:22
categories: freedos
---

FreeDos还有很多细节，包括Fat文件系统，各种中断，系统调用等等。

其中FAT文件系统，在我给出的FreeDos版本中有个buildimg.c文件，里面实现了个简单的Fat12系统，将KERNEL.SYS，COMMAND.COM放置到虚拟软盘上。

想对FAT的具体实现有了解的可以参考这个文件，没有必要为了研究Fat12文件系统而一头扎到FreeDos代码，那样太耗时。

这些年我也搞过不少文件系统，网络协议等，我的感悟是：
<pre>
像文件系统，网络协议这些规定好的东西，可以先看看规格手册，然后尝试动手写个程序实现下，最后再去看内核代码是如何具体实现的。
</pre>

要想完全分析FreeDos，想象下赵炯博士的《Linux内核完全剖析》那本书的厚度，我还要码多少字。。。。。

到目前为止，我大致分析了：boot加载KERNEL，KERNEL初始化，加载执行COMMAND。

剩下的事情就交给COMMAND了，由它解释执行用户命令。 其它的操作系统基本上也是这种执行路线。

<hr>
总结：

分析FreeDos是为了热身，练练手，为后续研究Linux， FreeBSD做好准备。

剩下的代码分析有空再写，未完，待续。。。。。。。