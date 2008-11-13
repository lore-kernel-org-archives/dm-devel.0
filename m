From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 1/8] dm-ioband: Introduction
Date: Thu, 13 Nov 2008 12:11:46 +0900 (JST)
Message-ID: <20081113.121146.623571555980959797.ryov@valinux.co.jp>
References: <20081113.121019.104237699577193919.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753856AbYKMDLU@vger.kernel.org>
In-Reply-To: <20081113.121019.104237699577193919.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

What's am-ioband all about?
===========================

dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the
same block device. A job is a group of processes with the same pid or
pgrp or uid or a virtual machine such as KVM or Xen. A job can also be
a cgroup by applying the bio-cgroup patch.

Setup and Installation
======================

Build a kernel with these options enabled:

  CONFIG_MD
  CONFIG_BLK_DEV_DM
  CONFIG_DM_IOBAND

If compiled as module, use modprobe to load dm-ioband.

  # make modules
  # make modules_install
  # depmod -a
  # modprobe dm-ioband
  
"dmsetup targets" command shows all available device-mapper
targets. "ioband" and the version number are displayed when dm-ioband
has been loaded.

  # dmsetup targets | grep ioband
  ioband           v1.9.0

Getting started
===============

The following is a brief description how to control the I/O bandwidth
of disks. In this description, we'll take one disk with two partitions
as an example target.

Create and map ioband devices
-----------------------------

Create two ioband devices "ioband1" and "ioband2". "ioband1" is mapped
to "/dev/sda1" and has a weight of 40. "ioband2" is mapped to "/dev/sda2"
and has a weight of 10. "ioband1" can use 80% --- 40/(40+10)*100 ---
of the bandwidth of the physical disk "/dev/sda" while "ioband2" can use 20%.

 # echo "0 $(blockdev --getsize /dev/sda1) ioband /dev/sda1 1 0 0 none" \
     "weight 0 :40" | dmsetup create ioband1
 # echo "0 $(blockdev --getsize /dev/sda2) ioband /dev/sda2 1 0 0 none" \
     "weight 0 :10" | dmsetup create ioband2

If the commands are successful then the device files "/dev/mapper/ioband1"
and "/dev/mapper/ioband2" will have been created.

Additional bandwidth control
----------------------------

In this example two extra ioband groups are created on "ioband1". The
first group consists of all the processes with user-id 1000 and the
second group consists of all the processes with user-id 2000. Their
weights are 30 and 20 respectively.

 # dmsetup message ioband1 0 type user
 # dmsetup message ioband1 0 attach 1000
 # dmsetup message ioband1 0 attach 2000
 # dmsetup message ioband1 0 weight 1000:30
 # dmsetup message ioband1 0 weight 2000:20
    
Now the processes in the user-id 1000 group can use 30%
--- 30/(30+20+40+10)*100 --- of the bandwidth of the physical disk.

   Table 1. Weight assignments
  ioband device    ioband group    ioband weight
  ioband1          user id 1000         30
  ioband1          user id 2000         20
  ioband1          default group        40
  ioband2          default group        10

Remove the ioband devices
-------------------------

Remove the ioband devices when no longer used.

  # dmsetup remove ioband1
  # dmsetup remove ioband2
