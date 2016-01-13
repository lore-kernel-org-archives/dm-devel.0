From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: 4.4 regression/bisected: error message due to "block/sd: Fix
 device-imposed transfer length limits"
Date: Wed, 13 Jan 2016 14:15:12 +0100
Message-ID: <56964DE0.60407@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Martin,

with 4.4 I get messages like

device-mapper: table: 253:4: adding target device sdq caused an alignment inconsistency: physical_block_size=4096, logical_block_size=512, alignment_offset=0, start=0

when I use device mapper multipath on a scsi disk on a FlashSystem-9840 scsi disk.
The disk has a quite interesting layout (physical block size=4k, logical=512)

blockdev --getbsz /dev/sdq
4096
blockdev --getss /dev/sdq
512
blockdev --getpbsz /dev/sdq
4096

the disks seems to work ok, though.
Any ideas?

Christian

