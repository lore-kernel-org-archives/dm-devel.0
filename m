From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2] dm-zoned: Use GFP_NOIO in I/O path
Date: Wed, 26 Jul 2017 18:50:20 +0900
Message-ID: <20170726095020.3967-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Use GFP_NOIO for all memory allocations in the I/O path. Other memory
allocations in the initialization path can keep using GFP_KERNEL.

Problem reported by Mikulas Patocka <mpatocka@redhat.com>.

While at it, also fix the call to blkdev_issue_zeroout() in
dm-zoned-reclaim.c so that the last argument specifies 0 (for unsigned
flags) instead of false (for bool unmap of the older 4.11 API).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 12 ++++++------
 drivers/md/dm-zoned-reclaim.c  |  2 +-
 drivers/md/dm-zoned-target.c   |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 884ff7c170a0..a4fa2ada6883 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -624,7 +624,7 @@ static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
 
 	ret = dmz_rdwr_block(zmd, REQ_OP_WRITE, block, mblk->page);
 	if (ret == 0)
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_KERNEL, NULL);
+		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
 
 	return ret;
 }
@@ -658,7 +658,7 @@ static int dmz_write_dirty_mblocks(struct dmz_metadata *zmd,
 
 	/* Flush drive cache (this will also sync data) */
 	if (ret == 0)
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_KERNEL, NULL);
+		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
 
 	return ret;
 }
@@ -722,7 +722,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 
 	/* If there are no dirty metadata blocks, just flush the device cache */
 	if (list_empty(&write_list)) {
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_KERNEL, NULL);
+		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
 		goto out;
 	}
 
@@ -927,7 +927,7 @@ static int dmz_recover_mblocks(struct dmz_metadata *zmd, unsigned int dst_set)
 			(zmd->nr_meta_zones << zmd->dev->zone_nr_blocks_shift);
 	}
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(GFP_NOIO);
 	if (!page)
 		return -ENOMEM;
 
@@ -1183,7 +1183,7 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 	/* Get zone information from disk */
 	ret = blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd, zone),
-				  &blkz, &nr_blkz, GFP_KERNEL);
+				  &blkz, &nr_blkz, GFP_NOIO);
 	if (ret) {
 		dmz_dev_err(zmd->dev, "Get zone %u report failed",
 			    dmz_id(zmd, zone));
@@ -1257,7 +1257,7 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 		ret = blkdev_reset_zones(dev->bdev,
 					 dmz_start_sect(zmd, zone),
-					 dev->zone_nr_sectors, GFP_KERNEL);
+					 dev->zone_nr_sectors, GFP_NOIO);
 		if (ret) {
 			dmz_dev_err(dev, "Reset zone %u failed %d",
 				    dmz_id(zmd, zone), ret);
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 05c0a126f5c8..44a119e12f1a 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -75,7 +75,7 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
 	nr_blocks = block - wp_block;
 	ret = blkdev_issue_zeroout(zrc->dev->bdev,
 				   dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
-				   dmz_blk2sect(nr_blocks), GFP_NOFS, false);
+				   dmz_blk2sect(nr_blocks), GFP_NOIO, 0);
 	if (ret) {
 		dmz_dev_err(zrc->dev,
 			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 71eae8a23dae..01152e198236 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -541,7 +541,7 @@ static void dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
 		int ret;
 
 		/* Create a new chunk work */
-		cw = kmalloc(sizeof(struct dm_chunk_work), GFP_NOFS);
+		cw = kmalloc(sizeof(struct dm_chunk_work), GFP_NOIO);
 		if (!cw)
 			goto out;
 
@@ -785,7 +785,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Chunk BIO work */
 	mutex_init(&dmz->chunk_lock);
-	INIT_RADIX_TREE(&dmz->chunk_rxtree, GFP_NOFS);
+	INIT_RADIX_TREE(&dmz->chunk_rxtree, GFP_NOIO);
 	dmz->chunk_wq = alloc_workqueue("dmz_cwq_%s", WQ_MEM_RECLAIM | WQ_UNBOUND,
 					0, dev->name);
 	if (!dmz->chunk_wq) {
-- 
2.13.3
