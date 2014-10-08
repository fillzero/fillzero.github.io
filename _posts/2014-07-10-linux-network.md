---
layout: post
title:  "linux-1.0.9 中的网络数据包构造过程"
date:   2014-07-10 11:00:33
categories: linux
---

研究kernel的网络代码有段时间了，一直没找到什么切入点，今天以数据包在不同网络层面上的传输为准则跟踪内核代码，查看数据包是如何构造的。

基于linux-1.0.9代码，运行ping 127.0.0.1，跟踪内核执行流程：

![pic](http://fillzero.qiniudn.com/2014_10_08_kernel_network_data_road.jpg)

可以看到，用户程序调用sendto函数，系统调用_sock_sendto，然后依次构造ETH Header，IP Header，ICMP包。
