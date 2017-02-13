From: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v4] DM: dm-inplace-compress: inplace compressed DM target
Date: Mon, 13 Feb 2017 12:42:24 -0800
Message-ID: <1487018545-5061-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, shli@kernel.org, hbabu@us.ibm.com, linuxram@us.ibm.com
List-Id: dm-devel.ids

This  patch   provides   a   generic  device-mapper  compression device.
Originally written by Shaohua Li.
https://www.redhat.com/archives/dm-devel/2013-December/msg00143.html

I have optimized and hardened the code.

Testing:
-------
This compression block device  is   tested in  the  following scenarios
a) backing a ext4 filesystem 
b) backing swap
Its further stress tested on PPC64 and x86 system.

Version v4:
	fixed kbuild errors; hopefully they are all taken care off.
       	  - no reference to zero_page
	  - convert all divide and mod operations to bit operations

Version v3:
	Fixed  sector  alignment  bugs  exposed  while   testing on x86.
	Explicitly set the maximum request size  to 128K.  Without which
	range  locking  failed,  causing  I/Os  to  stamp   each  other.
	Fixed an occasional data corruption  caused by wrong size of the
	compression buffer.
	Added  a   parameter   while  creation  of  the   block  device, 
	to  not  sleep   during  memory  allocations. This can be useful
       	if the device is used as a swap device.

Version v2:
	All patches are merged into a single patch.
	Major code re-arrangement.
	Data and metablocks allocated based on the length of the device
	map rather than the size of the backing device.
        Size   of   each entry   in  the bitmap array is explicitly set
	 to 32bits.
	Attempt  to  reuse  the  provided  bio  buffer  space   instead
	 of allocating a new one.

Version v1:
	Comments from Alasdair have been incorporated.
	https://www.redhat.com/archives/dm-devel/2013-December/msg00144.html

Your  comments  to  improve  the  code  is  very  much  appreciated. Will be 
requesting for merge if I do not receive any comments.

Ram Pai (1):
  From: Shaohua Li <shli@kernel.org>

 .../device-mapper/dm-inplace-compress.txt          |  155 ++
 drivers/md/Kconfig                                 |    6 +
 drivers/md/Makefile                                |    2 +
 drivers/md/dm-inplace-compress.c                   | 2214 ++++++++++++++++++++
 drivers/md/dm-inplace-compress.h                   |  187 ++
 5 files changed, 2564 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-inplace-compress.txt
 create mode 100644 drivers/md/dm-inplace-compress.c
 create mode 100644 drivers/md/dm-inplace-compress.h

-- 
1.8.3.1

