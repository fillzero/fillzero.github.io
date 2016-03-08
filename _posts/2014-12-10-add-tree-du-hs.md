---
layout: post
title:  "给Tree命令添加 显示文件夹大小的功能"
date:   2014-12-10 12:10:23
categories: TOOL
---

Tree 命令很实用，不足之处在于显示文件夹大小的时候，全部都是默认的4K(这个是文件夹节点在文件系统中占用的大小)，

但是我需要的功能是显示这个文件夹下面所有的文件占用的磁盘空间。

![pic](http://fillzero.qiniudn.com/2015_12_10_tree_show_directory_size.png)

现在就要加上这个功能。

改动如下：

tree 版本：1.5.3

![pic](http://fillzero.qiniudn.com/2015_12_10_tree_add_function_show_size.png)


改动后的效果显示，这样一眼就可以看出子目录中哪个文件夹占用空间最大了。

![pic](http://fillzero.qiniudn.com/2015_12_10_mytree_show_directory_size.png)


<hr>

patch： <a href="http://fillzero.qiniudn.com/2015_12_10_tree.patch.txt">tree.patch</a>


<hr>

再来个分析android 编译后out目录下的不同目标文件夹的大小，亿亩了然哈 ^_^

![pic](http://fillzero.qiniudn.com/2015_12_10_tree_dh_python_format.png)