From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v2 0/3] Support DAX for device-mapper dm-linear devices
Date: Wed, 22 Jun 2016 17:54:51 -0600
Message-ID: <1466639694-25394-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

This patch-set adds DAX support to device-mapper dm-linear devices
used by LVM.  It works with LVM commands as follows:
 - Creation of a logical volume with all DAX capable devices (such
   as pmem) sets the logical volume DAX capable as well.
 - Once a logical volume is set to DAX capable, the volume may not
   be extended with non-DAX capable devices.

The direct_access interface is added to dm and dm-linear to map
a request to a target device.

The patches replace v1 series at:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

v2:
 - Fix issue with partitioning.
 - Change to add DAX flag to a request queue.

---
Toshi Kani (3):
 1/3 block: add QUEUE_FLAG_DAX for devices to advertise their DAX support
 2/3 dm: add infrastructure for DAX support
 3/3 dm linear: add DAX support

---
 drivers/block/brd.c           |  4 +++-
 drivers/md/dm-linear.c        | 23 ++++++++++++++++++++++-
 drivers/md/dm-table.c         | 23 ++++++++++++++++++++---
 drivers/md/dm.c               | 36 +++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |  1 +
 drivers/nvdimm/pmem.c         |  1 +
 drivers/s390/block/dcssblk.c  |  1 +
 fs/block_dev.c                |  5 +++--
 include/linux/blkdev.h        |  2 ++
 include/linux/device-mapper.h | 16 ++++++++++++++++
 10 files changed, 104 insertions(+), 8 deletions(-)
