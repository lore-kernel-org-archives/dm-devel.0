From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/4] zoned block device report zones enhancements
Date: Thu, 24 Oct 2019 15:50:02 +0900
Message-ID: <20191024065006.8684-1-damien.lemoal@wdc.com>
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
List-Id: dm-devel.ids

This series of patches improve the handling and execution of report
zones operations for zoned block devices.

The first patch enhances device revalidation by moving zone information
checks from the low level driver into the block layer. The second patch
remove some unnecessary code. The last two patches introduce generic
allocation of report zones command buffer, further enhancing zoned disk
revalidation.

As always, comments are welcome.

Damien Le Moal (4):
  block: Enhance blk_revalidate_disk_zones()
  block: Simplify report zones execution
  block: Introduce report zones queue limits
  block: Generically handle report zones buffer

 block/blk-settings.c           |   3 +
 block/blk-zoned.c              | 178 +++++++++++++++++----------
 drivers/block/null_blk.h       |   6 +-
 drivers/block/null_blk_zoned.c |   3 +-
 drivers/md/dm.c                |   9 +-
 drivers/scsi/sd.h              |   3 +-
 drivers/scsi/sd_zbc.c          | 212 +++++++++------------------------
 include/linux/blkdev.h         |  12 +-
 8 files changed, 193 insertions(+), 233 deletions(-)

-- 
2.21.0
