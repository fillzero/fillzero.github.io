---
layout: post
title:  "高效Terminal操作 -- 修改gnome-terminal源码，实现SecureCRT快捷键功能"
date:   2015-01-15 14:01:22
categories: TOOL
---

无论搞嵌入式开发还是涉及到远程连接网络设备，Windows下必须要用到的神器： SecureCRT。

SecureCRT最大的优势就是下面有快捷键，可以自定义/封装 命令，实现自动化的功能，大大提高工作效率。

例如封装下ssh连接需要的用户名，密码，鼠标单击下快捷键就可以立刻ssh登录板子，方便快捷，如下：

![pic]({{ site.url }}/assets/2015_01_05_SecureCRT_shortcut.png)

可我是个Linuxer， 用惯了Terminal，与其羡慕SecureCRT有这种功能，不如自己动手开发这个功能。

OK，一直用的是gnome-terminal，就在这上面开发吧。

版本：gnome-terminal 2.29

<hr>
大致看下gnome-terminal的代码，看懂了UI流程，添加新功能还是很方便的。

patch： <a href="{{ site.url }}/assets/2015_01_05_gnome_terminal.patch.txt">gnome_terminal.patch</a>

把需要添加的命令放在$HOME/.gnome_terminal_cmd里面

![pic]({{ site.url }}/assets/2015_01_05_gnome_termianl_cmd.png)


效果：

直接纯键盘操作，不需要鼠标，操作更快。 工作效率比之前大大提高！

![pic]({{ site.url }}/assets/2015_01_05_gnome_termianl_show.png)
