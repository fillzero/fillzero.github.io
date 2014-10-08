---
layout: post
title:  "深入分析FreeDos -- 编译"
date:   2013-08-20 11:15:22
categories: freedos
---

先建立开发环境，我的环境：

主机系统：   Windows XP, 最好再装个虚拟机，在虚拟机里装个Linux系统

FreeDos版本： 我用的是2.0.20版本， <a href="http://sourceforge.net/projects/freedos/files/Kernel/2.0.20/">http://sourceforge.net/projects/freedos/files/Kernel/2.0.20/</a>

编译软件：  <a href="http://pan.baidu.com/s/1mg5e1oG">NASM</a>， <a href="http://pan.baidu.com/s/1tn70U">Turbo C 3.0</a>

x86模拟器： Bochs， JPC， VirtualBox都可以
<hr>

要想让FreeDos运行起来，需要编译如下文件：

1. boot.bin， 即软盘引导文件
2. KERNEL.SYS， 即FreeDos内核
3. FreeCom，  即交互shell，类似linux上的bash。在kernel2020.zip的bin目录下就有编译好的commmand.com，可以直接拿来用。


编译步骤：

1. 将nasm， tcc解压到C盘根目录，并将C:\nasm， C:\tcc\BIN 添加到环境变量中。
2. 解压ker2020.zip, 修改config.m,根据注释选择对应的编译器选项，然后将config.m重命名为config.mak。
3. 进入boot， 执行make -f boot.mak, 编译引导文件。编译完成会生成两个bin文件，其中b_fat12.bin对应FAT12文件系统，b_fat16.bin对应FAT16文件系统。
4. 进入kernel， 执行make -f kernel.mak, 编译完成会生成KERNEL.SYS
5. 下面的操作，是在linux下进行的:
{% highlight bash %}
5.1  输入bximage命令 ， 选择fd， 选择1.44，保存文件为dostest.img  #创建一个1.44M的Image文件，
5.2  losetup /dev/loop1 dostest.img                               #将dostest.img 关联到环回设备1、
5.3  dd if=boot.bin of=/dev/loop1                                 #将boot.bin 写入dostest.img的引导扇区中
5.4  mount -o /dev/loop1 /mnt                                     #将Image挂载在/mnt 目录下
5.3  cp KERNEL.SYS /mnt                                           #将编译好的KERNEL.SYS 拷贝到/mnt下，即写入到Image中
5.4  cp bin/COMMAND.CMD /mnt                                      #将bin下面的COMMAND.COM 拷贝到/mnt下，即写入到Image中
5.5  umount /mnt                                                  #卸载mnt目录
5.6  loset -d /dev/loop1                                          #将dostest.img从环回设备上卸载掉
{% endhighlight %}
 
最后一步：用X86模拟器启动dostest.img

<hr>
如果编译kernel出错，可能与环境有关。

<font color="#ff0000">推荐：</font>

我已经做好了一个版本， <a href="http://pan.baidu.com/s/1gdGKarD">点此下载</a>。

与官方不同的地方：
<pre>
1. 修改了boot.asm。官方的boot.asm不能加载文件较大的KERNEL.SYS
2. 官方的FreeCom需要硬盘支持，所以我重新编译了个不需要硬盘支持的，放在build目录下
3. 如上面编译步骤所述，生成Image比较麻烦，我写了个简单的buildimg.c程序，运行即可将boot.bin，KERNEL.SYS，COMMAND.COM组装到dostest.img中，很方便。
4. 直接用命名行替代了makefile，解压后运行build.bat，在build目录下即可生成dostest.img。
</pre>
OK，下面分别是dostest.img在JPC和Virtualbox下运行的截图：

![pic](http://fillzero.qiniudn.com/2014_09_25_jpc_run_freedos.jpg)
![pic](http://fillzero.qiniudn.com/2014_09_25_virtualbox_run_freedos.jpg)
