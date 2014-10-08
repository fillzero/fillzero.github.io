---
layout: post
title:  "Android 开机自启动流程"
date:   2014-06-07 11:00:33
categories: android
---

Android有开机启动项，很多应用（闹钟，微信）都是开机自启动。

今天跟踪下代码，看看执行流程，以闹钟为例：

系统启动 -> zygote -> system_server -> 创建各种服务  -> systemReady。 ActivityManagerService 发出BOOT_COMPLETED 广播，

层层调用，最终调到Alarm 的 onReceive(…)

下图左边为AMS进程， 右边为App进程

![pic](http://fillzero.qiniudn.com/2014_10_08_onbootcomplate_road.jpg)