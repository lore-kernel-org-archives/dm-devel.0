From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Use GFP_NOIO in I/O path
Date: Mon, 24 Jul 2017 16:44:37 +0900
Message-ID: <20170724074437.24008-1-damien.lemoal@wdc.com>
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

Use GFP_NOIO for memory allocations in the I/O path. Other memory
allocations in the initialization path can keep using GFP_KERNEL.

Problem reported by Mikulas Patocka <mpatocka@redhat.com>.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index f694fb98b002..f45ac8b1121d 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -625,7 +625,7 @@ static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
 
 	ret = dmz_rdwr_block(zmd, REQ_OP_WRITE, block, mblk->page);
 	if (ret == 0)
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_KERNEL, NULL);
+		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
 
 	return ret;
 }
@@ -659,7 +659,7 @@ static int dmz_write_dirty_mblocks(struct dmz_metadata *zmd,
 
 	/* Flush drive cache (this will also sync data) */
 	if (ret == 0)
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_KERNEL, NULL);
+		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
 
 	return ret;
 }
@@ -723,7 +723,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 
 	/* If there are no dirty metadata blocks, just flush the device cache */
 	if (list_empty(&write_list)) {
-		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_KERNEL, NULL);
+		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
 		goto out;
 	}
 
@@ -928,7 +928,7 @@ static int dmz_recover_mblocks(struct dmz_metadata *zmd, unsigned int dst_set)
 			(zmd->nr_meta_zones << zmd->dev->zone_nr_blocks_shift);
 	}
 
-	page = alloc_page(GFP_KERNEL);
+	page = alloc_page(GFP_NOIO);
 	if (!page)
 		return -ENOMEM;
 
@@ -1184,7 +1184,7 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 	/* Get zone information from disk */
 	ret = blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd, zone),
-				  &blkz, &nr_blkz, GFP_KERNEL);
+				  &blkz, &nr_blkz, GFP_NOIO);
 	if (ret) {
 		dmz_dev_err(zmd->dev, "Get zone %u report failed",
 			    dmz_id(zmd, zone));
@@ -1258,7 +1258,7 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 		ret = blkdev_reset_zones(dev->bdev,
 					 dmz_start_sect(zmd, zone),
-					 dev->zone_nr_sectors, GFP_KERNEL);
+					 dev->zone_nr_sectors, GFP_NOIO);
 		if (ret) {
 			dmz_dev_err(dev, "Reset zone %u failed %d",
 				    dmz_id(zmd, zone), ret);
-- 
2.13.3
