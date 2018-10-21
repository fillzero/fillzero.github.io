---
layout: post
title:  "深入分析FreeDos -- Kernel初始化"
date:   2013-08-30 11:15:22
categories: freedos
---

KERNAL.asm跳转到Main.c中的main函数，下面代码可读性就很强了，跟踪代码的执行流程应该不是难事。

我想说的是，kernel定义了很多全局变量，掌握了这些变量的用处，理解kernel基本上就没什么障碍了。

OK，下面主要以变量使用为切入点分析kernel，

几个关键的变量：

Config: 配置KERNEL初始化需要的空间及默认加载的command文件

![pic]({{ site.url }}/assets/2014_09_29_freedos_config.jpg)
<pre>
cu_psp
f_node* f_nodes:	
sfttbl* FCBp:		FCB table pointer
sfttbl*	sfthead:
cdstbl* CDSp:		Current Directory Structure
BYTE* lpBase:       系统可用空间指针
UWORD first_mcb:	用户可用空间起始段
</pre> 


<pre>
初始化的主要执行流程如下：
main()
      |-->init_kernel() -> init_io() -> 初始化con_dev， clk_dev， blk_dev
                        |
                        |->PreConfig    //为几个重要数据分配内存,使用默认的Config
                        |->FsConfig     //创建文件系统
                        |->DoConfig     //处理Fdconfig.sys, CONFIG.SYS，重置Config，没有也没关系
                        |->PostConfig   //如果有CONFIG.SYS，那么Config的cfgFiles个数啊，cfgBuffers大小啊都变了，所以还得重新分配内存
                        |->FsConfig     //上面的内存重新分配了，地址偏移都变了，所以文件系统也得重新构造了
                        |->DoConfig     //内存重新分配了，所以CONFIG.SYS得重新处理
                        |->configDone   //剩下的内存就留给用户了，标记用户可用空间地址
                        |->FsConfig     //因为上面的操作直接影响文件系统，保险起见，重新构造下
      |
      |-->kernel() -> p_0()
	   
</pre>

下面是这几个config函数执行期间的输出，注意，我的软盘里没有放FDCONFIG, CONFIG.SYS文件。
![pic]({{ site.url }}/assets/2014_09_28_freedos_initkernel.jpg)

<hr>
KERNEL初始化完毕后，KERNEL需要的内存指针放在BSS段，具体分配的内容放在INIT段，大致被划分如下图，

关于Kernel需要的stack，这里有个细节：
在执行main函数之前，会将BSSEND段中的最后256个字节作为临时statck，这样C代码中函数调用需要的数据先放在这里。
在PostConfig()函数中，根据Config.cfgStacks， Config.cfgStackSize会专门为KERNEL分配更大的栈空间。

![pic]({{ site.url }}/assets/2014_09_28_init_seg_use.jpg)

内核所需空间分配完毕后，可用内存起始地址为：0x1382:0x400 = 0x13C20，
所以lpbase = 0x13C20, first_mcb = 0x13C2

此时KERNEL已初始化完毕，下面就是创建执行第一个任务，默认的第一个任务为COMMAND.COM，详见上面Config定义。

OK，下节就分析任务的加载与执行。