From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 0/9] Zoned block device enhancements and zone
 report rework
Date: Mon, 11 Nov 2019 11:39:21 +0900
Message-ID: <20191111023930.638129-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

This series of patches introduces changes to zoned block device handling
code with the intent to simplify the code while optimizing run-time
operation, particularly in the area of zone reporting.

The first patch lifts the device zone check code out of the sd driver
and reimplements these zone checks generically as part of
blk_revalidate_disk_zones(). This avoids zoned block device drivers to
have to implement these checks. The second patch simplifies this
function code for the !zoned case.

The third patch is a small cleanup of zone report processing in
preparation for the fourth patch which removes support for partitions
on zoned block devices. As mentioned in that patch commit message, none
of the known partitioning tools support zoned devices and there are no
known use case in the field of SMR disks being used with partitions.
Dropping partition supports allows to significantly simplify the code
for zone report as zone sector values remapping becomes unnecessary.

Patch 5 to 6 are small cleanups and fixes of the null_blk driver zoned
mode.

The prep patch 7 optimizes zone report buffer allocation for the SCSI
sd driver. Finally, patch 8 introduces a new interface for report zones
handling using a callback function executed per zone reported by the
device. This allows avoiding the need to allocate large arrays of
blk_zone structures for the execution of zone reports. This can
significantly reduce memory usage and pressure on the memory management
system while significantly simplify the code all over.

Overall, this series not only reduces significantly the code size, it
also improves run-time memory usage for zone report execution.

This series applies cleanly on the for-next block tree on top of the
zone management operation series. It may however create a conflict with
Christoph's reqork of disk size revalidation. Please consider this
series for inclusion in the 5.5 kernel.

As always, comments are welcome.

Changes from V1:
* Use __GFP_NORETRY in patch 8 as suggested by Bart.
* Added reviewed-by tags.

Christoph Hellwig (4):
  block: cleanup the !zoned case in blk_revalidate_disk_zones
  null_blk: clean up the block device operations
  null_blk: clean up report zones
  block: rework zone reporting

Damien Le Moal (5):
  block: Enhance blk_revalidate_disk_zones()
  block: Simplify report zones execution
  block: Remove partition support for zoned block devices
  null_blk: Add zone_nr_conv to features
  scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()

 block/blk-core.c               |   6 +-
 block/blk-zoned.c              | 356 ++++++++++++++-------------------
 block/partition-generic.c      |  74 +------
 drivers/block/null_blk.h       |  11 +-
 drivers/block/null_blk_main.c  |  21 +-
 drivers/block/null_blk_zoned.c |  33 ++-
 drivers/md/dm-flakey.c         |  18 +-
 drivers/md/dm-linear.c         |  20 +-
 drivers/md/dm-zoned-metadata.c | 131 +++++-------
 drivers/md/dm.c                | 130 +++++-------
 drivers/scsi/sd.h              |   4 +-
 drivers/scsi/sd_zbc.c          | 237 ++++++++--------------
 fs/f2fs/super.c                |  51 ++---
 include/linux/blkdev.h         |  15 +-
 include/linux/device-mapper.h  |  24 ++-
 15 files changed, 429 insertions(+), 702 deletions(-)

-- 
2.23.0
