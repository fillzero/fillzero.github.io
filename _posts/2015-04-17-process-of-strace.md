---
layout: post
title:  "strace 源码分析 (快速分析代码，半小时搞懂)"
date:   2015-04-17 19:35:24
categories: TOOL
---

strace 是我解bug的时候经常用的命令。

今天有空分析下它的内部原理。

strace的内部逻辑比较复杂，文字说不清除，我用自动化分析的方法获取到内部函数调用关系，

精简后的关系图，如下：

![pic](http://fillzero.qiniudn.com/2015_04_17_strace_internal_functions_call.png)


代码分析总结:
<pre>
1. strace 先 fork() 子进程，执行要运行的命令
2. 然后系统调用ptrace(PTRACE_ATTACH， childPid) , ptrace(PTRACE_TRACEME, childPid), 即可跟踪子进程。
   原理是linux kernel支持进程被TRACE，下面是每个进程在kernel内部可能运行的状态，
   当使用系统调用ptrace()后，进程处于TASK_TEACED状态。
   
   kernel/include/linux/sched.h
</pre>

![pic](http://fillzero.qiniudn.com/2015_04_17_strace_kernel_task_traced.png)


<pre>
3. 之后strace 代码死循环调用ptrace(PTRACE_SYSCALL, ..) 跟踪被attach的进程, kernel会返回当前的system call number，然后处理下输出结果。
   根据自动化调试结果，整理了下，如下图，<font color="#FF0000">都不用怎么看代码（strace源码有4万多行），花了不到半小时，就搞懂了strace内部原理！ ^_^</font>
</pre>

![pic](http://fillzero.qiniudn.com/2015_04_17_strace_code_summary.png)
