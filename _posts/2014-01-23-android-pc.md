---
layout: post
title:  "将Android安装到PC并设置双系统"
date:   2014-01-23 15:01:15
categories: android
---
2014-01-23 


折腾大半天，找到一个方法将Android安装在PC上，并设置双系统

我的主机系统是linux slack13.7

先下载android-x86源码，地址： <a href="http://www.android-x86.org">www.android-x86.org</a>，我下载的版本是android-x86-froyo

编译整个系统，找出编译出来的kernel文件，放置在/boot/kernel

然后修改/boot/lilo.conf

<pre>
<li>添加：
{% highlight bash %}
image = /boot/kernel
  root = /dev/ram0
  label = android-pc  
  append = " androidboot_hardware=vm acpi_sleep=s3_bios,s3_mode video=-16 SDCARD=sda DEBUG=1"
  initrd = /initrd.img
  read-only
{% endhighlight %} </li>
<li>将编译生成的initrd.img, ramdisk.img, system.img放到根目录下</li>
<li>在根目录中创建data文件夹</li>
</pre>

![pic]({{ site.url }}/assets/2014_10_08_add_android_img.jpg)

然后重启，选择android-pc即可进入android 系统

截图如下：