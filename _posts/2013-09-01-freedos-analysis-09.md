---
layout: post
title:  "深入分析FreeDos -- FreeCom编译"
date:   2013-09-01 11:15:22
categories: freedos
---

DOS的交互命令工具是COMMAND，FreeDos用的是开源的FreeCom，这里我选择的版本为<a href="http://freedos.bbnx.net/files/dos/command/0.72/com072bs.zip">http://freedos.bbnx.net/files/dos/command/0.72/com072bs.zip</a>

编译此版本还需要TASM汇编软件：<a href="http://pan.baidu.com/s/1k0uxK">Tasm</a>

由于版本较老，在Windows XP下执行MakeFile，编译后不能正常运行(可能与我环境有关)。

折腾了一段时间，找到了正确编译的方法，如下，注：需要将tcc lib目录下的c0t.lib拷贝到FreeCom目录下

{% highlight batch %}
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c alias.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c batch.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c cmdinput.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c command.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c dir.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c environ.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c exec.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c history.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c internal.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c loadhigh.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c prompt.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c redir.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c where.c
tcc -mt -f- -ff- -O -Z -k- -vi- -w-ret -w-nci -w-inl -wpin -wamb -wamp -w-par -IC:\TCC\INCLUDE -LC:\TCC\LIB -c tempfile.c

C:\TASM\BIN\tasm /MX /ZI /O LOWEXEC.ASM,LOWEXEC.OBJ
C:\TASM\BIN\tasm /MX /ZI /O LH.ASM,LH.OBJ

tlib command +alias +batch +cmdinput +command +dir +environ +exec +history +internal
tlib command +c0t +alias +batch +cmdinput +dir +environ +exec +history +internal
tlib command +loadhigh +prompt +redir +where +lowexec +lh +tempfile

tlink /m/L. c0t,command,command,command+cs.lib

exe2bin command.exe COMMAND.COM
{% endhighlight %}

将生成的COMMAND.COM放置虚拟软盘后，可用模拟器验证运行下。
