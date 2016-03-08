---
layout: post
title:  "linux kernel启动 (自动化调试输出实例图)"
date:   2015-06-22 17:12:43
categories: linux
---

继续我的自动化调试，直接上图。

原理：修改Qemu源码，获取仿真执行kernel代码的地址，匹配system.map中的函数符号，再调用画图脚本输出可视化图形 ！

<font color="#FF0000">完全不用看代码了！</font>

![pic](http://fillzero.qiniudn.com/2015_06-22_kernel_startup.png)