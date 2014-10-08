---
layout: post
title:  "深入分析FreeDos -- KERNEL.ASM"
date:   2013-08-28 11:15:22
categories: freedos
---

终于开始KERNEL代码分析了

这一节关注KERNEL.ASM文件，如前一节所述，KERNEL.ASM代码主要目的就是将INIT段copy 到内存高处，跳转到高处的INIT段执行，旧的INIT段被用作内核数据区和Stack区。

![pic](http://fillzero.qiniudn.com/2014-09-28_kernel_asm_remove.jpg)

有一点须注意下，int 12中断获取的是内存大小，一般DOS系统内存为640KB，这里的bochs bios返回的是639KB，因为最后的1KB是bochs bios保留用的，用于
键盘缓冲区等。


retf执行后CS=内存高处段地址, IP=cont偏移地址，所以CPU往后执行的是高端内存的cont代码，然后跳转执行main.c中的main函数 (main函数也在高端内存)
{% highlight asm %}
;
	push	es			;	ES=内存高处段地址, 压栈
	mov		ax,cont		;	ax=cont的偏移地址， 压栈
	push	ax			;	retf执行完后，CPU自动将栈中的内容POP给IP，CS
	retf
cont:
	.............
	mov     ax,ds
	mov     es,ax
	jmp	_main
segment	INIT_TEXT_END
{% endhighlight %}



KERNEL.ASM还有其它部分分布放在_TEXT，_FIXED_DATA， _BSS， _BSSEND， 如下：
{% highlight asm %}
segment	_TEXT
	_nul_strtgy:
		....
	_nul_intr:
		....
	_printf
		.....
segment	_FIXED_DATA
	;所谓FIXED_DATA，即这块内存的值是固定了，因为要和DOS系统兼容。
	;存放各种数据及指针，如用户可用内存区地址，系统文件表头。。。
segment	_BSS
	_api_sp
	_api_ss
	_usr_sp
	_usr_ss
	_ram_top
segment	_BSSEND
	blk_stk_top
	clk_stk_top
	intr_stk_top
	last
segment	_STACK
{% endhighlight %}