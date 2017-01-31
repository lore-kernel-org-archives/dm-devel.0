From: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v3] DM: dm-inplace-compress: inplace compressed
	DM target
Date: Mon, 30 Jan 2017 23:42:12 -0800
Message-ID: <1485848533-27778-1-git-send-email-linuxram@us.ibm.com>
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
To: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: hbabu@us.ibm.com, shli@kernel.org, snitzer@redhat.com, agk@redhat.com, corbet@lwn.net
List-Id: dm-devel.ids

This  patch   provides   a   generic     device-mapper   compression  device.
Originally written by Shaohua Li.
https://www.redhat.com/archives/dm-devel/2013-December/msg00143.html

I have optimized and hardened the code.

Testing:
-------
This compression block device  is  tested in the following scenarios
a) backing a ext4 filesystem 
b) backing swap
Its stress tested on PPC64 and x86 system.

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
	Attempt  to  reuse  the  provided  bio  buffer  space   instead
	 of allocating a new one.

Version v3:
	Fixed  sector  alignment  bugs  exposed  while   testing on x86.
	Explicitly set the maximum request size  to 128K.  Without which
	range  locking  failed,  causing  I/Os  to  stamp   each  other.
	Fixed an occasional data corruption  caused by wrong size of the
	compression buffer.
	Added  a   parameter   while  creation  of  the   block  device, 
	to  not  sleep   during  memory  allocations. This can be useful
       	if the device is used as a swap device.

Your comments to improve the code is very much appreciated.

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
