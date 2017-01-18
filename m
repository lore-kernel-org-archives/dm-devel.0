From: Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH v2] DM: dm-inplace-compress: inplace
	compressed DM target
Date: Wed, 18 Jan 2017 10:31:48 -0800
Message-ID: <1484764309-14383-1-git-send-email-linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This  patch provides a generic device-mapper inplace compression
device.  Originally written by Shaohua Li.
https://www.redhat.com/archives/dm-devel/2013-December/msg00143.html

I have optimized and hardened the code.

Testing:
-------
This compression block device  is  tested in the following scenarios
a) backing a ext4 filesystem 
b) backing swap
Its tested on a PPC64 system only.
More    testing  is  needed on different architectures.

TODO:
-----
For testing, the code was modified to use GFP_ATOMIC allocations when   device
is   used as swap. A more dynamic mechanism is needed to switch allocation
strategy based on usage. Probably a sysfs interface?

Version v1:
	Comments from Alasdair have been incorporated.
	https://www.redhat.com/archives/dm-devel/2013-December/msg00144.html

Version v2:
	All patches are merged into a single patch.
	Major code re-arrangement.
	Data and metablocks allocated based on the length of the device
	map rather than the size of the backing device.
        Size   of   each entry   in  the bitmap array is explicitly set
	 to 32bits.
	Attempt  to  reuse  the  provided  bio  buffer  space   instead  of
	 allocating a new one.

Your comments to improve the code is very much appreciated.

Ram Pai (1):
  From: Shaohua Li <shli@kernel.org>

 .../device-mapper/dm-inplace-compress.txt          |  139 ++
 drivers/md/Kconfig                                 |    6 +
 drivers/md/Makefile                                |    2 +
 drivers/md/dm-inplace-compress.c                   | 2104 ++++++++++++++++++++
 drivers/md/dm-inplace-compress.h                   |  185 ++
 5 files changed, 2436 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-inplace-compress.txt
 create mode 100644 drivers/md/dm-inplace-compress.c
 create mode 100644 drivers/md/dm-inplace-compress.h

-- 
1.8.3.1
