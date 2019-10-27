From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/8] Zone management commands support
Date: Sun, 27 Oct 2019 23:05:41 +0900
Message-ID: <20191027140549.26272-1-damien.lemoal@wdc.com>
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
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Keith Busch <kbusch@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, Ajay Joshi <ajay.joshi@wdc.com>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids

This series implements a few improvements and cleanups to zone block
device zone reset operations with the first three patches.

The remaining of the series patches introduce zone open, close and
finish support, allowing users of zoned block devices to explicitly
control the condition (state) of zones.

While these operations are not stricktly necessary for the correct
operation of zoned block devices, the open and close operations can
improve performance for some device implementations of the ZBC and ZAC
standards under write workloads. The finish zone operation, which
transition a zone to the full state, can also be useful to protect a
zone data by preventing further zone writes.

These operations are implemented by introducing the new
REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH request codes
and the function blkdev_zone_mgmt() to issue these requests. This new
function also replaces the former blkdev_reset_zones() function to reset
zones write pointer.

The new ioctls BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE are also
defined to allow applications to issue these new requests without
resorting to a device passthrough interface (e.g. SG_IO).

Support for these operations is added to the SCSI sd driver, to the dm
infrastructure (dm-linear and dm-flakey targets) and to the null_blk
driver.

Ajay Joshi (5):
  block: add zone open, close and finish operations
  block: add zone open, close and finish ioctl support
  scsi: sd_zbc: add zone open, close, and finish support
  dm: add zone open, close and finish support
  null_blk: add zone open, close, and finish support

Damien Le Moal (3):
  block: Remove REQ_OP_ZONE_RESET plugging
  block: Simplify REQ_OP_ZONE_RESET_ALL handling
  scsi: sd_zbc: Fix sd_zbc_complete()

 block/blk-core.c               | 12 +++--
 block/blk-zoned.c              | 99 ++++++++++++++++++----------------
 block/ioctl.c                  |  5 +-
 drivers/block/null_blk_zoned.c | 33 ++++++++++--
 drivers/md/dm-flakey.c         |  7 ++-
 drivers/md/dm-linear.c         |  2 +-
 drivers/md/dm-zoned-metadata.c |  6 +--
 drivers/md/dm.c                |  5 +-
 drivers/scsi/sd.c              | 15 +++++-
 drivers/scsi/sd.h              |  8 +--
 drivers/scsi/sd_zbc.c          | 43 +++++++--------
 fs/f2fs/segment.c              |  3 +-
 include/linux/blk_types.h      | 25 +++++++++
 include/linux/blkdev.h         | 15 +++---
 include/uapi/linux/blkzoned.h  | 17 ++++--
 15 files changed, 192 insertions(+), 103 deletions(-)

-- 
2.21.0
