---
layout: post
title:  "linux-1.0.9 网卡初始化"
date:   2014-07-08 11:00:33
categories: linux
---

内核版本：linux-1.0.9， 网卡型号NE2000

初始化网卡，流程 _start_kernel -> sock_init -> ddi_init -> inet_proto_init -> dev_init -> ethif_probe -> ne_probe -> NS8390_init，

其中探测网卡部分，依次调用kernel包含的驱动探测该驱动是否符合网卡。

![pic]({{ site.url }}/assets/2014_10_08_kernel_ne2k_road.jpg)

<hr>
<br>

初始化网卡代码与虚拟网卡输出比对：

![pic]({{ site.url }}/assets/2014_10_08_kernel_ne2k_02.jpg)