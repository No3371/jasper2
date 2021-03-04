---
layout: post
current: post
navigation: True
title: 趣聞：Internet Archive Infrastructure
date: 2020-07-17 13:28:00
tags: [Coding]
class: post-template
subclass: 'post'
author: No3371
lang: zh_TW
---

來源：https://archive.org/details/jonah-edwards-presentation
作者：Jonah Edwards

- 750 Servers, up to 9yr old
- 1300 VMs
- 30k storage devices
- \>20k spinning disks (in paired storage)
- Almost 200 PB raw storage capacity
- Currently growing by >25% **per year**
- Currently growing 2-6 PB **per quarter** (10-12PB raw capacity)
- Items in the Archive are directories on disks
- The basic unit of storage is the disk
- Disks are replicated across datacenters
- Content is serverd from all customProperties
- Formats evolves as needed, old content is re-derived
- At current Disk Sizes, it'd require 15 racks of servers to house one copy 
 ![](/2021-03-02-note-internet-archive-infrastructure/2021-03-03-16-05-24.png)