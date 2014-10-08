---
layout: post
title:  "Bochs BIOS 研究 -- 编译运行"
date:   2013-05-10 12:15:22
categories: freedos
---
许多分析操作系统的书都是从分析软盘的bootloader开始的。

BIOS将软盘的前512个字节的内容copy到内存0x7c00处，然后跳转过去，执行引导扇区代码。

在此之前，BIOS的执行代码，书上基本没有，若对BIOS功能不熟，分析引导扇区代码，会是一头雾水。

OK，现在就开始分析BIOS。
我的环境：

操作系统：  Ubuntu 10.04

x86模拟器：JPC，JPC的使用参考我之前的文章：<a href="/jpc/2013/04/25/jpc.html">JPC使用</a>

开发环境： Eclipse，在eclipse中打开JPC工程，方便查看运行代码。

-------------------------------------------------
<br>
下载编译bios：

在ubuntu中apt-get source bochs，就可以得到bochs的bios代码。

我提取了BIOS-bochs-legacy相关代码，下载链接： <a href="http://pan.baidu.com/s/1jGl5If0">bios_bios.zip</a>

编译BISO-bochs-legacy命令如下，或者执行压缩包里的build.sh ：
{% highlight bash %}
cc    -c -o biossums.o biossums.c
cc   biossums.o   -o biossums
gcc -m32 -fno-stack-protector "-DBIOS_BUILD_DATE=\"`date '+%m/%d/%y'`\"" -DLEGACY -E -P rombios.c > _rombiosl_.c
bcc -o rombiosl.s -C-c -D__i86__ -0 -S _rombiosl_.c
sed -e 's/^\.text//' -e 's/^\.data//' rombiosl.s > _rombiosl_.s
as86 _rombiosl_.s -b tmpl.bin -u- -w- -g -0 -j -O -l rombiosl.txt
perl ./makesym.perl < rombiosl.txt > rombiosl.sym
mv tmpl.bin BIOS-bochs-legacy
./biossums BIOS-bochs-legacy
{% endhighlight %}

将生成的BIOS-bochs-legacy重命名为bios.bin，放置jpc的 resources/bios目录下,然后运行JPC，BIOS启动界面如下：

![pic](http://fillzero.qiniudn.com/2014_09_25_jpc_bochs.jpg)

