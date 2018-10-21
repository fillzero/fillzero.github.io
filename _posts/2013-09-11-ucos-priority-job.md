---
layout: post
title:  "uCOS/II -- 利用映射找到最高优先级Task"
date:   2013-09-11 13:14:25
categories: ucos
---

今天看下ucos/II创建多个任务后，如何快速找到最高优先级的任务并执行。

ucos/II 最多只能创建64个任务(这里面包含了最低优先级的idle任务)

创建任务用到的变量：

![pic]({{ site.url }}/assets/2013_09_11_ucos_01.png)

为简单说明，这里创建了2个任务，优先级分别为57和29。

![pic]({{ site.url }}/assets/2013_09_11_ucos_02.png)

跟踪下任务创建代码，

![pic]({{ site.url }}/assets/2013_09_11_ucos_03.png)

这里将两个任务的优先级，放到变量OSRdyGrp与OSRdTbl[]里面，

![pic]({{ site.url }}/assets/2013_09_11_ucos_04.png)

后续调用调度代码，在调度函数中将之前的变量通过查表法，找到最高优先级的任务，切换到任务中：

![pic]({{ site.url }}/assets/2013_09_11_ucos_05.png)

这种方法实现的比较巧妙，时间复杂度为O(1)，如果不用这种方法，而是for循环找到最高优先级，时间复杂度则为O(n)。

使用这种方法调度函数运行时间很短，任务切换也很快。