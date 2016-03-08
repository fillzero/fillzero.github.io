---
layout: post
title:  "Qemu分析 -- 01 (虚拟CPU的创建与使用)"
date:   2014-11-02 11:15:22
categories: qemu
---

Bochs, JPC都是X86的仿真器，但无论从功能还是执行速度上，完全比不上Qemu。

最近没事，分析下Qemu。

核心数据结构之一： CPUState,  所有的取址，译码，执行，更新寄存器的操作，全在于此相关。

第一个我要搞懂的是Qemu如何更改虚拟CPU的寄存器，达到执行非Host环境的代码。

直接gdb调试，图片保存，方便回忆：

![pic](http://fillzero.qiniudn.com/2014_11_12_qemu_01.png)

再找到执行目标代码的地方：

<hr>
![pic](http://fillzero.qiniudn.com/2014_11_12_qemu_02.png)

再根据Intel CPU手册，对应Qemu复位CPU的代码，即可大致弄懂Qemu是如何维护使用虚拟CPU的。

<hr>
![pic](http://fillzero.qiniudn.com/2014_11_12_qemu_03.png)
