From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/12] dm-zoned: add device pointer to struct
	dm_zone
Date: Fri, 22 May 2020 17:38:54 +0200
Message-ID: <20200522153901.133375-6-hare@suse.de>
References: <20200522153901.133375-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200522153901.133375-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien LeMoal <damien.lemoal@wdc.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Add a pointer to the containing device to struct dm_zone and
kill dmz_zone_to_dev().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 47 ++++++++++++------------------------------
 drivers/md/dm-zoned-reclaim.c  | 18 +++++++---------
 drivers/md/dm-zoned-target.c   |  7 +++----
 drivers/md/dm-zoned.h          |  4 +++-
 4 files changed, 26 insertions(+), 50 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index fdae4e0228e7..7b6e7404f1e8 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -229,16 +229,10 @@ struct dmz_metadata {
  */
 static unsigned int dmz_dev_zone_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	unsigned int zone_id;
-
 	if (WARN_ON(!zone))
 		return 0;
 
-	zone_id = zone->id;
-	if (zmd->nr_devs > 1 &&
-	    (zone_id >= zmd->dev[1].zone_offset))
-		zone_id -= zmd->dev[1].zone_offset;
-	return zone_id;
+	return zone->id - zone->dev->zone_offset;
 }
 
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
@@ -255,18 +249,6 @@ sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
 	return (sector_t)zone_id << zmd->zone_nr_blocks_shift;
 }
 
-struct dmz_dev *dmz_zone_to_dev(struct dmz_metadata *zmd, struct dm_zone *zone)
-{
-	if (WARN_ON(!zone))
-		return &zmd->dev[0];
-
-	if (zmd->nr_devs > 1 &&
-	    zone->id >= zmd->dev[1].zone_offset)
-		return &zmd->dev[1];
-
-	return &zmd->dev[0];
-}
-
 unsigned int dmz_zone_nr_blocks(struct dmz_metadata *zmd)
 {
 	return zmd->zone_nr_blocks;
@@ -1252,7 +1234,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 
 	/* Read and check the primary super block */
 	zmd->sb[0].block = dmz_start_block(zmd, zmd->sb[0].zone);
-	zmd->sb[0].dev = dmz_zone_to_dev(zmd, zmd->sb[0].zone);
+	zmd->sb[0].dev = zmd->sb[0].zone->dev;
 	ret = dmz_get_sb(zmd, &zmd->sb[0], 0);
 	if (ret) {
 		dmz_dev_err(zmd->sb[0].dev, "Read primary super block failed");
@@ -1383,6 +1365,7 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
 
 	INIT_LIST_HEAD(&zone->link);
 	atomic_set(&zone->refcount, 0);
+	zone->dev = dev;
 	zone->id = idx;
 	zone->chunk = DMZ_MAP_UNMAPPED;
 
@@ -1442,6 +1425,7 @@ static int dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
 			return -EBUSY;
 		INIT_LIST_HEAD(&zone->link);
 		atomic_set(&zone->refcount, 0);
+		zone->dev = dev;
 		zone->id = idx;
 		zone->chunk = DMZ_MAP_UNMAPPED;
 		set_bit(DMZ_CACHE, &zone->flags);
@@ -1567,11 +1551,10 @@ static int dmz_update_zone_cb(struct blk_zone *blkz, unsigned int idx,
  */
 static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
 	unsigned int noio_flag;
 	int ret;
 
-	if (dev->flags & DMZ_BDEV_REGULAR)
+	if (zone->dev->flags & DMZ_BDEV_REGULAR)
 		return 0;
 
 	/*
@@ -1581,16 +1564,16 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	 * GFP_NOIO was specified.
 	 */
 	noio_flag = memalloc_noio_save();
-	ret = blkdev_report_zones(dev->bdev, dmz_start_sect(zmd, zone), 1,
+	ret = blkdev_report_zones(zone->dev->bdev, dmz_start_sect(zmd, zone), 1,
 				  dmz_update_zone_cb, zone);
 	memalloc_noio_restore(noio_flag);
 
 	if (ret == 0)
 		ret = -EIO;
 	if (ret < 0) {
-		dmz_dev_err(dev, "Get zone %u report failed",
+		dmz_dev_err(zone->dev, "Get zone %u report failed",
 			    zone->id);
-		dmz_check_bdev(dev);
+		dmz_check_bdev(zone->dev);
 		return ret;
 	}
 
@@ -1604,7 +1587,6 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 static int dmz_handle_seq_write_err(struct dmz_metadata *zmd,
 				    struct dm_zone *zone)
 {
-	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
 	unsigned int wp = 0;
 	int ret;
 
@@ -1613,7 +1595,8 @@ static int dmz_handle_seq_write_err(struct dmz_metadata *zmd,
 	if (ret)
 		return ret;
 
-	dmz_dev_warn(dev, "Processing zone %u write error (zone wp %u/%u)",
+	dmz_dev_warn(zone->dev,
+		     "Processing zone %u write error (zone wp %u/%u)",
 		     zone->id, zone->wp_block, wp);
 
 	if (zone->wp_block < wp) {
@@ -1641,13 +1624,11 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 		return 0;
 
 	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
-		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
-
-		ret = blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,
+		ret = blkdev_zone_mgmt(zone->dev->bdev, REQ_OP_ZONE_RESET,
 				       dmz_start_sect(zmd, zone),
 				       zmd->zone_nr_sectors, GFP_NOIO);
 		if (ret) {
-			dmz_dev_err(dev, "Reset zone %u failed %d",
+			dmz_dev_err(zone->dev, "Reset zone %u failed %d",
 				    zone->id, ret);
 			return ret;
 		}
@@ -2201,9 +2182,7 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 		goto again;
 	}
 	if (dmz_is_meta(zone)) {
-		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
-
-		dmz_dev_warn(dev, "Zone %u has metadata", zone->id);
+		dmz_zmd_warn(zmd, "Zone %u has metadata", zone->id);
 		zone = NULL;
 		goto again;
 	}
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 571bc1d41bab..d1a72b42dea2 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -58,7 +58,6 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
 				sector_t block)
 {
 	struct dmz_metadata *zmd = zrc->metadata;
-	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
 	sector_t wp_block = zone->wp_block;
 	unsigned int nr_blocks;
 	int ret;
@@ -74,15 +73,15 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
 	 * pointer and the requested position.
 	 */
 	nr_blocks = block - wp_block;
-	ret = blkdev_issue_zeroout(dev->bdev,
+	ret = blkdev_issue_zeroout(zone->dev->bdev,
 				   dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
 				   dmz_blk2sect(nr_blocks), GFP_NOIO, 0);
 	if (ret) {
-		dmz_dev_err(dev,
+		dmz_dev_err(zone->dev,
 			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
 			    zone->id, (unsigned long long)wp_block,
 			    (unsigned long long)block, nr_blocks, ret);
-		dmz_check_bdev(dev);
+		dmz_check_bdev(zone->dev);
 		return ret;
 	}
 
@@ -116,7 +115,6 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
 			    struct dm_zone *src_zone, struct dm_zone *dst_zone)
 {
 	struct dmz_metadata *zmd = zrc->metadata;
-	struct dmz_dev *src_dev, *dst_dev;
 	struct dm_io_region src, dst;
 	sector_t block = 0, end_block;
 	sector_t nr_blocks;
@@ -130,17 +128,15 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
 	else
 		end_block = dmz_zone_nr_blocks(zmd);
 	src_zone_block = dmz_start_block(zmd, src_zone);
-	src_dev = dmz_zone_to_dev(zmd, src_zone);
 	dst_zone_block = dmz_start_block(zmd, dst_zone);
-	dst_dev = dmz_zone_to_dev(zmd, dst_zone);
 
 	if (dmz_is_seq(dst_zone))
 		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
 
 	while (block < end_block) {
-		if (src_dev->flags & DMZ_BDEV_DYING)
+		if (src_zone->dev->flags & DMZ_BDEV_DYING)
 			return -EIO;
-		if (dst_dev->flags & DMZ_BDEV_DYING)
+		if (dst_zone->dev->flags & DMZ_BDEV_DYING)
 			return -EIO;
 
 		if (dmz_reclaim_should_terminate(src_zone))
@@ -163,11 +159,11 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
 				return ret;
 		}
 
-		src.bdev = src_dev->bdev;
+		src.bdev = src_zone->dev->bdev;
 		src.sector = dmz_blk2sect(src_zone_block + block);
 		src.count = dmz_blk2sect(nr_blocks);
 
-		dst.bdev = dst_dev->bdev;
+		dst.bdev = dst_zone->dev->bdev;
 		dst.sector = dmz_blk2sect(dst_zone_block + block);
 		dst.count = src.count;
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 2770e293a97b..bca9a611b8dd 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -123,18 +123,17 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
 {
 	struct dmz_bioctx *bioctx =
 		dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
-	struct dmz_dev *dev = dmz_zone_to_dev(dmz->metadata, zone);
 	struct bio *clone;
 
-	if (dev->flags & DMZ_BDEV_DYING)
+	if (zone->dev->flags & DMZ_BDEV_DYING)
 		return -EIO;
 
 	clone = bio_clone_fast(bio, GFP_NOIO, &dmz->bio_set);
 	if (!clone)
 		return -ENOMEM;
 
-	bio_set_dev(clone, dev->bdev);
-	bioctx->dev = dev;
+	bio_set_dev(clone, zone->dev->bdev);
+	bioctx->dev = zone->dev;
 	clone->bi_iter.bi_sector =
 		dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
 	clone->bi_iter.bi_size = dmz_blk2sect(nr_blocks) << SECTOR_SHIFT;
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 8083607b9535..356b436425e4 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -80,6 +80,9 @@ struct dm_zone {
 	/* For listing the zone depending on its state */
 	struct list_head	link;
 
+	/* Device containing this zone */
+	struct dmz_dev		*dev;
+
 	/* Zone type and state */
 	unsigned long		flags;
 
@@ -188,7 +191,6 @@ const char *dmz_metadata_label(struct dmz_metadata *zmd);
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone);
 sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone);
 unsigned int dmz_nr_chunks(struct dmz_metadata *zmd);
-struct dmz_dev *dmz_zone_to_dev(struct dmz_metadata *zmd, struct dm_zone *zone);
 
 bool dmz_check_dev(struct dmz_metadata *zmd);
 bool dmz_dev_is_dying(struct dmz_metadata *zmd);
-- 
2.16.4
