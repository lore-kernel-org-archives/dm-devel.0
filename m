From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Mon, 13 Jun 2016 16:21:31 -0600
Message-ID: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, toshi.kani@hpe.com, linux-nvdimm@lists.01.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch-set adds DAX support to device-mapper dm-linear devices
used by LVM.  It works with LVM commands as follows:
 - Creation of a logical volume with all DAX capable devices (such
   as pmem) sets the logical volume DAX capable as well.
 - Once a logical volume is set to DAX capable, the volume may not
   be extended with non-DAX capable devices.

The direct_access interface is added to dm and dm-linear to map
a request to a target device.

 - Patch 1-2 introduce GENHD_FL_DAX flag to indicate DAX capability.
 - Patch 3-4 add direct_access functions to dm and dm-linear.
 - Patch 5-6 set GENHD_FL_DAX to dm when all targets are DAX capable.

---
Toshi Kani (6):
 1/6 genhd: Add GENHD_FL_DAX to gendisk flags
 2/6 block: Check GENHD_FL_DAX for DAX capability
 3/6 dm: Add dm_blk_direct_access() for mapped device
 4/6 dm-linear: Add linear_direct_access()
 5/6 dm, dm-linear: Add dax_supported to dm_target
 6/6 dm: Enable DAX support for mapper device

---
 drivers/block/brd.c           |  2 +-
 drivers/md/dm-linear.c        | 19 +++++++++++++++++++
 drivers/md/dm-table.c         | 12 +++++++++---
 drivers/md/dm.c               | 38 ++++++++++++++++++++++++++++++++++++--
 drivers/md/dm.h               |  7 +++++++
 drivers/nvdimm/pmem.c         |  2 +-
 drivers/s390/block/dcssblk.c  |  1 +
 fs/block_dev.c                |  5 +++--
 include/linux/device-mapper.h | 15 +++++++++++++++
 include/linux/genhd.h         |  2 +-
 10 files changed, 93 insertions(+), 10 deletions(-)
