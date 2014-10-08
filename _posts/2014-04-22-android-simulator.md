---
layout: post
title:  "Android Simulator"
date:   2014-02-22 11:30:40
categories: android
---
最近要搞Androd Framework开发，相比App，麻烦的就是每次编译的Framework.jar，都要手动push到Emulator或手机上，然后重启到进Launcher，要等好久。

反复的编译， push ，重启，浪费了很多时间。这种低效率的开发方式，实在受不了。。。

有没有快速的开发环境呢？

上网搜索，参考下面的链接：
<pre>
<a href="http://phandroid.com/2009/05/27/what-if-ubuntu-could-run-android-applications-it-can/">What If Ubuntu Could Run Android Applications? It Can.</a>
可以直接在Ubuntu下运行Android应用，而不是传统的Ubuntu上运行虚拟机，再在虚拟机上跑Android。

<a href="http://stackoverflow.com/questions/5155296/is-there-an-android-simulator-not-the-default-emulator-similar-to-the-iphone">StackOverFlow: Is there an Android simulator (not the default emulator), similar to the iPhone one?</a>
提到了simulator，貌似编译的时候有这个选项。
</pre>

下载完Android 源码后，我下的是Android 1.6.1版本。执行source build/envsetup.sh，然后lunch
会提示
<pre>
Lunch menu... pick a combo:
     1. generic-eng
     2. simulator
</pre>
平常都选generic-eng，从没试过simualtor，关于simulator，网上也啥没有帖子介绍过。

不管了，先试下吧，编译果然有很多错误。

------------------------------------------
经过1个星期的折腾，基本可以正常运行了。

改动的地方：

1. 修改development/simualtor/app/Android.mk, LOCAL_CFLAGS后面加上-DNO_GCC_PRAGMA
2. 改MemoryDealer.cpp
3. SystemServer.java中的HeadsetObserver service
4. frameworks/base/core/java/android/view/ViewGroup.java， 注释掉 return more;
5. 修改frameworks/base/libs/utils/IPCThreadState.cpp，mCallingPid = getpid();//-1; mCallingUid = 1000;//-1;
6. 编译加-k选项： make -k -j2

patch如下：
<pre>
Framework的patch： <a href="http://fillzero.qiniudn.com/0001-1.6.1_frameworks_base.patch.txt">http://fillzero.qiniudn.com/0001-1.6.1_frameworks_base.patch</a>
development的patch： <a href="http://fillzero.qiniudn.com/0001-1.6.1_development.patch.txt">http://fillzero.qiniudn.com/0001-1.6.1_development.patch.txt</a>
</pre>

编译出来的simulator放在 out/host/linux-x86/bin/下面
运行命令： out/host/linux-x86/bin/simulator

这样<font color="#ff0000">整个Android系统在Ubuntu下只是个普通进程，可以很方便的用gdb，jdb进行调试</font>

体验：

1. 启动超快，2秒就能经Launcher
2. 修改完framwork 代码，执行make framework，生成的jar包直接放在host simulator下，不需要push操作，直接重启即可，很方便。

![pic](http://fillzero.qiniudn.com/2014_09_29_android_simulator_show.png)