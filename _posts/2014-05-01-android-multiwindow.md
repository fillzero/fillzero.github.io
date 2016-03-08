---
layout: post
title:  "Android 多窗口"
date:   2014-05-01 15:20:15
categories: android
---

看了InNost的一篇博文：<a href="http://blog.csdn.net/innost/article/details/17324753"> CSDN -- Innost的专栏 -- Tieto公司Android多窗口解决方案展示 </a>

很有感触，反正最近有空，尝试实现下。

修改Android Framework代码，若是在真机或在Emulator上验证测试，光重启就耗费太多时间，还好有simulator，效率大大提高。

陆续花了一个月时间吧，基本上实现了功能。


对于多窗口的实现，思路如下：

1. 将窗口缩小。
2. 多个窗口能同时显示。
3. 窗口的移动。

--------------------------
<pre>
1. 关于窗口缩小，刚开始的想法是将Activity放在一个Dialog或Toast当中，后来逐步跟踪代码，感觉方案不可行。
   然后在创建窗口的过程中尝试修改窗口的宽度到高度，可以了，截图：
   
   <img src="http://fillzero.qiniudn.com/2014_10_08_android_try_small_window.jpg">

2. 下面就是多个窗口可以同时显示，跟踪了ActivityManagerService.java代码，发现所有的窗口都放在一个栈中，只有顶层的窗口才能显示，修改代码，可以显示多个窗口了：

   <img src="http://fillzero.qiniudn.com/2014_10_08_android_show_mulwindow.jpg">

3. 既然有多个窗口同时显示，当点击屏幕的时候，须将焦点放置在对应位置的窗口。而Android总是用最上面的窗口处理Touch Event，跟踪单击屏幕时，系统调用栈：

   <img src="http://fillzero.qiniudn.com/2014_10_08_android_findTargetWindow.jpg">
   
   修改处理流程，当点击其它窗口时，对应的窗口能够获取焦点。下面就是TestDialog的Activity在运行的情况下，可以移动Launcher的桌面时钟widget

   <img src="http://fillzero.qiniudn.com/2014_10_08_android_mulwindow_move.jpg">

4. 当非栈顶窗口获取到焦点时，应将其显示在最上面，修改ActivityManagerService.java
   下面是两个窗口，先运行Gallery，然后运行Browser，Browser在前面；当点击Gallery窗口时，将Gallery窗口显示在最前面
   <img src="http://fillzero.qiniudn.com/2014_10_08_window_switch.jpg">

5. 然后就是窗口移动了，关于窗口的移动，算法如下：
  保存当前窗口的位置，pos_x, pos_y
  第一次点击窗口的时候，记下X，Y坐标位置为x1，y1
  然后移动窗口，获取窗口的位置为x2，y2
  计算窗口位置： pox_x += x2 - x1;  pox_y += y2 - y1;
  更新x1，y1： x1 = x2;  y1 = y2;

6. 还有个问题是设置屏幕大小，若屏幕太小，多窗口就没没什么意义了。
   模拟器中设置屏幕的地方是
   core/java/android/content/res/CompatibilityInfo.java
   core/java/android/util/DisplayMetrics.java
   simulator/app/assets/android-dream/layout.xml
   simulator/wrapsim/DevFb.c 
   
   改完后的效果：
   <img src="http://fillzero.qiniudn.com/2014_10_08_all_0.jpg"><br><br><br>
   <img src="http://fillzero.qiniudn.com/2014_10_08_all_1.jpg">
</pre>

--------------------------------------------

<pre>

奉上修改的patch：
framework的patch： <a href="http://fillzero.qiniudn.com/2014_10_08_0001-multiwindow_framework_base.patch.txt">0001-multiwindow_framework_base.patch</a>
development的patch：<a href="http://fillzero.qiniudn.com/2014_10_08_0001-multiwindow_development.txt">0001-multiwindow_development.patch</a>
</pre>

{% highlight bash %}

编译，运行步骤：
1.下载android 1.6.1源码
2.打上上面的framework，development的patch
3.执行 source build/envsetup.sh
4.执行 lunch sim-eng
5.make -j2      (我电脑双核的，4核的用 -j4)
6.执行 out/host/linux-x86/bin/simulator 
{% endhighlight %}

演示视频： <a href="http://v.youku.com/v_show/id_XNzAzNzg3MjYw.html">http://v.youku.com/v_show/id_XNzAzNzg3MjYw.html</a>



