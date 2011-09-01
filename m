From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/2] block: Allow extending partition size online
Date: Thu,  1 Sep 2011 17:55:26 -0400
Message-ID: <1314914128-3171-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, dm-devel@redhat.com
Cc: kzak@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids


Hi,

This is a patch to allow extending the partition size online. There are two
patches in the series. One is kernel patch and other is util-linux patch
to add another command "extendpart".

Kernel patch adds another ioctl to increase the size of partition even when
partition is in use. Currently limitation is that after modification to 
partition table, one needs to reboot the system/stop using the partition
before size changes become visible. It would be nice to allow changing
the size online, hence this change.

This ioctl changes only kernel view of data structures and does not
touch ondisk data structures. So right way to expand the partition
table would be to fist modify on disk copy using fdisk or so and then
extend partition in kernel so that kernel's table and ondisk table
are in sync.

Any feedback is welcome.

Thanks
Vivek
