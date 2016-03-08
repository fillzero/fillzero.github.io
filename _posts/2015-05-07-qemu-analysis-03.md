---
layout: post
title:  "Qemu分析 -- 03 (仿真IO操作)"
date:   2015-05-07 21:42:39
categories: qemu
---

今天有空，继续分析Qemu。

研究下qemu串口read操作”serial_ioport_read”是如何调用的

在bios的启动detect_serial中,读取serial寄存器,调用栈如下:


![pic](http://fillzero.qiniudn.com/2015_05_07_qemu_01.png)

<hr>

![pic](http://fillzero.qiniudn.com/2015_05_07_qemu_02.png)
