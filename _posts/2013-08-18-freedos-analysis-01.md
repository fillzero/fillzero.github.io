---
layout: post
title:  "深入分析FreeDos -- 前言"
date:   2013-08-18 11:15:22
categories: freedos
---


为什么要研究FreeDos代码呢？

记得刚上大一的时候，学长说linux kernel很牛B，怀着激动无比的心情去图书馆借了赵炯博士的《Linux内核完全剖析》，

陆陆续续看了1年，只看懂皮毛，枯涩的GNU 汇编，单调的软盘读写，复杂的386保护模式。掌握kernel太难了，干脆放弃。

当我接触到计算机时，早就没软驱了，CPU也步入双核了，操作系统已换成VISTA了，连Linux Kernel也已是2.6版本了。

0.11版本，那是多么的遥远。

一次偶然的机会接触到了<a href="http://jpc.sourceforge.net/">JPC</a>模拟器，其demo版本用的是FreeDos。

对呀，FreeDos也是个操作系统啊，16位的，没有保护模式，工作在实模式上的，单任务的，也容易理解，还开源。比linux kernel简单。

然后就开始分析FreeDos，很快掌握了，有了基础，后来再分析Linux kernel 0.11，以前不懂的一下子就理解通了。

我想用我的经历告诉学习linux kernel没有入门的同学：

1. 找个易于上手的X86模拟器，修改模拟器代码，添加自己需要的功能，例如实时查看内部寄存器，内存。
2. 分析FreeDos源码，虽然DOS很老，但它是经典。操作系统很多原理是相通的，弄懂了FreeDos，再研究Linux就很容易了。

下面就开始分析FreeDos吧！
