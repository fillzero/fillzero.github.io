---
layout: post
title:  "Qemu分析 -- 04 (Qemu源码hack，添加自定义硬件！)"
date:   2015-08-24 22:13:21
categories: qemu
---

Qemu源码里面有许多虚拟的硬件，今天手痒，尝试自己写个简单的虚拟硬件。

hw_me.c，初始化放在serial_init()后面，注册端口，当Qemu执行到目标代码访问外部IO的时候，

见我之前的 <a href="./qemu-analysis-03.html">Qemu分析 -- 03 (仿真IO操作)</a>
 
![pic](http://fillzero.qiniudn.com/2015_08_24_qemu_01.png)

<hr>
为了简单访问这个硬件，我直接在BIOS代码中操作这个端口，后续有空再写到linux driver里面。

修改bios的POST代码，加上下面两句，读1044端口寄存器

![pic](http://fillzero.qiniudn.com/2015_08_24_qemu_02.png)

<hr>
然后gdb断点调试，哈哈，搞定！

![pic](http://fillzero.qiniudn.com/2015_08_24_qemu_03.png)
