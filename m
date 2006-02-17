From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 0/3] sysfs representation of stacked devices
	(dm/md)
Date: Fri, 17 Feb 2006 13:00:17 -0500
Message-ID: <43F60F31.1030507@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello,

These patches provide common representation of dependencies
between stacked devices (dm and md) in sysfs.
For example, if dm-0 maps to sda, we have the following symlinks;
   /sys/block/dm-0/slaves/sda --> /sys/block/sda
   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0

This makes it easier for user space tools/scripts to find out
device dependencies.


Suppose complicated but quite normal situation like below:
We have a logical volume (dm-2) on md raid1 (md0) which is
build upon dm-multipath (dm-0, dm-1) on FC disks (sda .. sdd).
   dm-2
      +-- md0
             |-- dm-0
             |      |-- sda
             |      +-- sdb
             |
             +-- dm-1
                    |-- sdc
                    +-- sdd

Though md0, dm-0, dm-1 and sd[a-d] contain same LVM2 meta data,
LVM2 should pick up md0 as PV, not dm-0, dm-1 and sdXs.
mdadm should build md0 from dm-0 and dm-1, not from sdXs.
Similar things will happen on 'mount' and 'fsck' if we use
file system labels instead of LVM2.

Currently, these relationships are determined by each tool
combining information like the existence of md metadata
and dm dependency ioctl.

With the patches, symlinks are created as shown below:
   /sys/block/dm-2/slaves/md0 --> /sys/block/md0
   /sys/block/md0/holders/dm-2 --> /sys/block/dm-2
   /sys/block/md0/slaves/dm-1 --> /sys/block/dm-1
   /sys/block/md0/slaves/dm-0 --> /sys/block/dm-0
   /sys/block/dm-0/holders/md0 --> /sys/block/md0
   /sys/block/dm-0/slaves/sda --> /sys/block/sda
   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
   ...

thus we only need to check "holders" directory of the device
to decide whether the device is used by dm/md.
Also we can walk down the "slaves" directories to collect
the devices conposing the given dm/md device.

The idea was raised in dm-devel by Lars in the last year
but I couldn't find follow ups of actual implementation.
https://www.redhat.com/archives/dm-devel/2005-April/msg00040.html


Any comments?

--
Jun'ichi "Nick" Nomura, NEC Solutions (America), Inc.
