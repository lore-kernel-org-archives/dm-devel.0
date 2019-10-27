From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Date: Sun, 27 Oct 2019 23:05:42 +0900
Message-ID: <20191027140549.26272-2-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
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

REQ_OP_ZONE_RESET operations cannot be merged as these bios and requests
do not have a size and are never sequential due to the zone start sector
position required for their execution. As a result, there is no point in
using a plug around blkdev_reset_zones() bio issuing loop. This patch
removes this unnecessary plugging.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4bc5f260248a..7fe376eede86 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -258,7 +258,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 	sector_t zone_sectors;
 	sector_t end_sector = sector + nr_sectors;
 	struct bio *bio = NULL;
-	struct blk_plug plug;
 	int ret;
 
 	if (!blk_queue_is_zoned(q))
@@ -283,7 +282,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 	    end_sector != bdev->bd_part->nr_sects)
 		return -EINVAL;
 
-	blk_start_plug(&plug);
 	while (sector < end_sector) {
 
 		bio = blk_next_bio(bio, 0, gfp_mask);
@@ -301,8 +299,6 @@ int blkdev_reset_zones(struct block_device *bdev,
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
 
-	blk_finish_plug(&plug);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_reset_zones);
-- 
2.21.0
