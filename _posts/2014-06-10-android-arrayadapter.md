---
layout: post
title:  "Android ArrayAdapter 界面创建流程"
date:   2014-06-10 11:00:33
categories: android
---

ListAdapter

MVC模式，封装了Mode与View，创建UI更方便

整个View创建的流程

以ApiDemo 中的ListExample为例，继承ListActivity。 


![pic]({{ site.url }}/assets/2014_10_08_simple_listAdapter.jpg)

通过上面的调用栈，再画个执行流程图：

![pic]({{ site.url }}/assets/2014_10_08_simple_listAdapter2.jpg)