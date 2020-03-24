From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 3/3] dm zoned: add regular device info to metadata
Date: Tue, 24 Mar 2020 19:02:55 +0800
Message-ID: <20200324110255.8385-4-bob.liu@oracle.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200324110255.8385-1-bob.liu@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, Dmitry.Fomichev@wdc.com, hare@suse.de, Bob Liu <bob.liu@oracle.com>
List-Id: dm-devel.ids

This patch implemented metadata support for regular device by:
 - Emulated zone information for regular device.
 - Store metadata at the beginning of regular device.

     | --- zoned device --- | -- regular device ||
     ^                      ^
     |                      |Metadata
zone 0

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/md/dm-zoned-metadata.c | 135 +++++++++++++++++++++++++++++++----------
 drivers/md/dm-zoned-target.c   |   6 +-
 drivers/md/dm-zoned.h          |   3 +-
 3 files changed, 108 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index e0e8be0..a96158a 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -131,6 +131,7 @@ struct dmz_sb {
  */
 struct dmz_metadata {
 	struct dmz_dev		*zoned_dev;
+	struct dmz_dev		*regu_dmz_dev;
 
 	sector_t		zone_bitmap_size;
 	unsigned int		zone_nr_bitmap_blocks;
@@ -187,6 +188,15 @@ struct dmz_metadata {
 /*
  * Various accessors
  */
+static inline struct dmz_dev *zmd_mdev(struct dmz_metadata *zmd)
+{
+	/* Metadata always stores in regular device if there is. */
+	if (zmd->regu_dmz_dev)
+		return zmd->regu_dmz_dev;
+	else
+		return zmd->zoned_dev;
+}
+
 unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
 	return ((unsigned int)(zone - zmd->zones));
@@ -194,12 +204,33 @@ unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return (sector_t)dmz_id(zmd, zone) << zmd->zoned_dev->zone_nr_sectors_shift;
+	int dmz_real_id;
+
+	dmz_real_id = dmz_id(zmd, zone);
+	if (dmz_real_id >= zmd->zoned_dev->nr_zones) {
+		/* Regular dev. */
+		dmz_real_id -= zmd->zoned_dev->nr_zones;
+		WARN_ON(!zmd->regu_dmz_dev);
+
+		return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_sectors_shift;
+	}
+	return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_sectors_shift;
 }
 
 sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return (sector_t)dmz_id(zmd, zone) << zmd->zoned_dev->zone_nr_blocks_shift;
+	int dmz_real_id;
+
+	dmz_real_id = dmz_id(zmd, zone);
+	if (dmz_real_id >= zmd->zoned_dev->nr_zones) {
+		/* Regular dev. */
+		dmz_real_id -= zmd->zoned_dev->nr_zones;
+		WARN_ON(!zmd->regu_dmz_dev);
+
+		return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_blocks_shift;
+	}
+
+	return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_blocks_shift;
 }
 
 unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)
@@ -403,8 +434,10 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct dmz_metadata *zmd,
 	struct dmz_mblock *mblk, *m;
 	sector_t block = zmd->sb[zmd->mblk_primary].block + mblk_no;
 	struct bio *bio;
+	struct dmz_dev *mdev;
 
-	if (dmz_bdev_is_dying(zmd->zoned_dev))
+	mdev = zmd_mdev(zmd);
+	if (dmz_bdev_is_dying(mdev))
 		return ERR_PTR(-EIO);
 
 	/* Get a new block and a BIO to read it */
@@ -440,7 +473,7 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct dmz_metadata *zmd,
 
 	/* Submit read BIO */
 	bio->bi_iter.bi_sector = dmz_blk2sect(block);
-	bio_set_dev(bio, zmd->zoned_dev->bdev);
+	bio_set_dev(bio, mdev->bdev);
 	bio->bi_private = mblk;
 	bio->bi_end_io = dmz_mblock_bio_end_io;
 	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META | REQ_PRIO);
@@ -555,7 +588,7 @@ static struct dmz_mblock *dmz_get_mblock(struct dmz_metadata *zmd,
 		       TASK_UNINTERRUPTIBLE);
 	if (test_bit(DMZ_META_ERROR, &mblk->state)) {
 		dmz_release_mblock(zmd, mblk);
-		dmz_check_bdev(zmd->zoned_dev);
+		dmz_check_bdev(zmd_mdev(zmd));
 		return ERR_PTR(-EIO);
 	}
 
@@ -581,8 +614,10 @@ static int dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
 {
 	sector_t block = zmd->sb[set].block + mblk->no;
 	struct bio *bio;
+	struct dmz_dev *mdev;
 
-	if (dmz_bdev_is_dying(zmd->zoned_dev))
+	mdev = zmd_mdev(zmd);
+	if (dmz_bdev_is_dying(mdev))
 		return -EIO;
 
 	bio = bio_alloc(GFP_NOIO, 1);
@@ -594,7 +629,7 @@ static int dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
 	set_bit(DMZ_META_WRITING, &mblk->state);
 
 	bio->bi_iter.bi_sector = dmz_blk2sect(block);
-	bio_set_dev(bio, zmd->zoned_dev->bdev);
+	bio_set_dev(bio, mdev->bdev);
 	bio->bi_private = mblk;
 	bio->bi_end_io = dmz_mblock_bio_end_io;
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
@@ -612,8 +647,10 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, int op, sector_t block,
 {
 	struct bio *bio;
 	int ret;
+	struct dmz_dev *mdev;
 
-	if (dmz_bdev_is_dying(zmd->zoned_dev))
+	mdev = zmd_mdev(zmd);
+	if (dmz_bdev_is_dying(mdev))
 		return -EIO;
 
 	bio = bio_alloc(GFP_NOIO, 1);
@@ -621,14 +658,14 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, int op, sector_t block,
 		return -ENOMEM;
 
 	bio->bi_iter.bi_sector = dmz_blk2sect(block);
-	bio_set_dev(bio, zmd->zoned_dev->bdev);
+	bio_set_dev(bio, mdev->bdev);
 	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);
 	bio_add_page(bio, page, DMZ_BLOCK_SIZE, 0);
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
 
 	if (ret)
-		dmz_check_bdev(zmd->zoned_dev);
+		dmz_check_bdev(mdev);
 	return ret;
 }
 
@@ -661,7 +698,7 @@ static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
 
 	ret = dmz_rdwr_block(zmd, REQ_OP_WRITE, block, mblk->page);
 	if (ret == 0)
-		ret = blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);
+		ret = blkdev_issue_flush(zmd_mdev(zmd)->bdev, GFP_NOIO, NULL);
 
 	return ret;
 }
@@ -695,15 +732,20 @@ static int dmz_write_dirty_mblocks(struct dmz_metadata *zmd,
 			       TASK_UNINTERRUPTIBLE);
 		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
 			clear_bit(DMZ_META_ERROR, &mblk->state);
-			dmz_check_bdev(zmd->zoned_dev);
+			dmz_check_bdev(zmd_mdev(zmd));
 			ret = -EIO;
 		}
 		nr_mblks_submitted--;
 	}
 
 	/* Flush drive cache (this will also sync data) */
-	if (ret == 0)
-		ret = blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);
+	if (ret == 0) {
+		/* Flush metadata device */
+		ret = blkdev_issue_flush(zmd_mdev(zmd)->bdev, GFP_NOIO, NULL);
+		if ((ret == 0) && zmd->regu_dmz_dev)
+			/* Flush data device. */
+			ret = blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);
+	}
 
 	return ret;
 }
@@ -760,7 +802,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 	 */
 	dmz_lock_flush(zmd);
 
-	if (dmz_bdev_is_dying(zmd->zoned_dev)) {
+	if (dmz_bdev_is_dying(zmd_mdev(zmd))) {
 		ret = -EIO;
 		goto out;
 	}
@@ -772,7 +814,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 
 	/* If there are no dirty metadata blocks, just flush the device cache */
 	if (list_empty(&write_list)) {
-		ret = blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);
+		ret = blkdev_issue_flush(zmd_mdev(zmd)->bdev, GFP_NOIO, NULL);
 		goto err;
 	}
 
@@ -821,7 +863,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 		list_splice(&write_list, &zmd->mblk_dirty_list);
 		spin_unlock(&zmd->mblk_lock);
 	}
-	if (!dmz_check_bdev(zmd->zoned_dev))
+	if (!dmz_check_bdev(zmd_mdev(zmd)))
 		ret = -EIO;
 	goto out;
 }
@@ -832,10 +874,11 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
 static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_super *sb)
 {
 	unsigned int nr_meta_zones, nr_data_zones;
-	struct dmz_dev *dev = zmd->zoned_dev;
+	struct dmz_dev *dev;
 	u32 crc, stored_crc;
 	u64 gen;
 
+	dev = zmd_mdev(zmd);
 	gen = le64_to_cpu(sb->gen);
 	stored_crc = le32_to_cpu(sb->crc);
 	sb->crc = 0;
@@ -1131,8 +1174,11 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 		zmd->nr_useable_zones++;
 		if (dmz_is_rnd(zone)) {
 			zmd->nr_rnd_zones++;
-			if (!zmd->sb_zone) {
-				/* Super block zone */
+			if (!zmd->sb_zone && !zmd->regu_dmz_dev) {
+				/*
+				 * Super block zone goes to regular
+				 * device by default.
+				 */
 				zmd->sb_zone = zone;
 			}
 		}
@@ -1157,7 +1203,8 @@ static void dmz_drop_zones(struct dmz_metadata *zmd)
 static int dmz_init_zones(struct dmz_metadata *zmd)
 {
 	struct dmz_dev *dev = zmd->zoned_dev;
-	int ret;
+	int ret, i;
+	unsigned int total_nr_zones;
 
 	/* Init */
 	zmd->zone_bitmap_size = dev->zone_nr_blocks >> 3;
@@ -1167,7 +1214,10 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 					DMZ_BLOCK_SIZE_BITS);
 
 	/* Allocate zone array */
-	zmd->zones = kcalloc(dev->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
+	total_nr_zones = dev->nr_zones;
+	if (zmd->regu_dmz_dev)
+		total_nr_zones += zmd->regu_dmz_dev->nr_zones;
+	zmd->zones = kcalloc(total_nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
 	if (!zmd->zones)
 		return -ENOMEM;
 
@@ -1186,6 +1236,25 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 		return ret;
 	}
 
+	if (zmd->regu_dmz_dev) {
+		/* Emulate zone information for regular device zone. */
+		for (i = 0; i < zmd->regu_dmz_dev->nr_zones; i++) {
+			struct dm_zone *zone = &zmd->zones[i + dev->nr_zones];
+
+			INIT_LIST_HEAD(&zone->link);
+			atomic_set(&zone->refcount, 0);
+			zone->chunk = DMZ_MAP_UNMAPPED;
+
+			set_bit(DMZ_RND, &zone->flags);
+			zmd->nr_rnd_zones++;
+			zmd->nr_useable_zones++;
+			zone->wp_block = 0;
+			if (!zmd->sb_zone)
+				/* Super block zone */
+				zmd->sb_zone = zone;
+		}
+	}
+
 	return 0;
 }
 
@@ -1313,13 +1382,13 @@ static void dmz_get_zone_weight(struct dmz_metadata *zmd, struct dm_zone *zone);
  */
 static int dmz_load_mapping(struct dmz_metadata *zmd)
 {
-	struct dmz_dev *dev = zmd->zoned_dev;
 	struct dm_zone *dzone, *bzone;
 	struct dmz_mblock *dmap_mblk = NULL;
 	struct dmz_map *dmap;
 	unsigned int i = 0, e = 0, chunk = 0;
 	unsigned int dzone_id;
 	unsigned int bzone_id;
+	struct dmz_dev *dev = zmd_mdev(zmd);
 
 	/* Metadata block array for the chunk mapping table */
 	zmd->map_mblk = kcalloc(zmd->nr_map_blocks,
@@ -1345,7 +1414,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		if (dzone_id == DMZ_MAP_UNMAPPED)
 			goto next;
 
-		if (dzone_id >= dev->nr_zones) {
+		if (dzone_id >= dev->target->nr_zones) {
 			dmz_dev_err(dev, "Chunk %u mapping: invalid data zone ID %u",
 				    chunk, dzone_id);
 			return -EIO;
@@ -1366,7 +1435,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		if (bzone_id == DMZ_MAP_UNMAPPED)
 			goto next;
 
-		if (bzone_id >= dev->nr_zones) {
+		if (bzone_id >= dev->target->nr_zones) {
 			dmz_dev_err(dev, "Chunk %u mapping: invalid buffer zone ID %u",
 				    chunk, bzone_id);
 			return -EIO;
@@ -1398,7 +1467,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 	 * fully initialized. All remaining zones are unmapped data
 	 * zones. Finish initializing those here.
 	 */
-	for (i = 0; i < dev->nr_zones; i++) {
+	for (i = 0; i < dev->target->nr_zones; i++) {
 		dzone = dmz_get(zmd, i);
 		if (dmz_is_meta(dzone))
 			continue;
@@ -1632,7 +1701,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
 		/* Allocate a random zone */
 		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
 		if (!dzone) {
-			if (dmz_bdev_is_dying(zmd->zoned_dev)) {
+			if (dmz_bdev_is_dying(zmd_mdev(zmd))) {
 				dzone = ERR_PTR(-EIO);
 				goto out;
 			}
@@ -1733,7 +1802,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 	/* Allocate a random zone */
 	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
 	if (!bzone) {
-		if (dmz_bdev_is_dying(zmd->zoned_dev)) {
+		if (dmz_bdev_is_dying(zmd_mdev(zmd))) {
 			bzone = ERR_PTR(-EIO);
 			goto out;
 		}
@@ -2360,7 +2429,8 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 /*
  * Initialize the zoned metadata.
  */
-int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
+int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_dev *regu_dmz_dev,
+		struct dmz_metadata **metadata)
 {
 	struct dmz_metadata *zmd;
 	unsigned int i, zid;
@@ -2372,6 +2442,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 		return -ENOMEM;
 
 	zmd->zoned_dev = dev;
+	zmd->regu_dmz_dev = regu_dmz_dev;
 	zmd->mblk_rbtree = RB_ROOT;
 	init_rwsem(&zmd->mblk_sem);
 	mutex_init(&zmd->mblk_flush_lock);
@@ -2440,9 +2511,9 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 		     bdev_zoned_model(dev->bdev) == BLK_ZONED_HA ?
 		     "aware" : "managed");
 	dmz_dev_info(dev, "  %llu 512-byte logical sectors",
-		     (u64)dev->capacity);
+		     (u64)dev->capacity  + (u64)regu_dmz_dev->capacity);
 	dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",
-		     dev->nr_zones, (u64)dev->zone_nr_sectors);
+		     dev->nr_zones + regu_dmz_dev->nr_zones, (u64)dev->zone_nr_sectors);
 	dmz_dev_info(dev, "  %u metadata zones",
 		     zmd->nr_meta_zones * 2);
 	dmz_dev_info(dev, "  %u data zones for %u chunks",
@@ -2488,7 +2559,7 @@ void dmz_dtr_metadata(struct dmz_metadata *zmd)
  */
 int dmz_resume_metadata(struct dmz_metadata *zmd)
 {
-	struct dmz_dev *dev = zmd->zoned_dev;
+	struct dmz_dev *dev = zmd_mdev(zmd);
 	struct dm_zone *zone;
 	sector_t wp_block;
 	unsigned int i;
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index cae4bfe..41dbb9d 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -803,7 +803,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Initialize metadata */
 	dev = dmz->zoned_dev;
-	ret = dmz_ctr_metadata(dev, &dmz->metadata);
+	ret = dmz_ctr_metadata(dev, dmz->regu_dmz_dev, &dmz->metadata);
 	if (ret) {
 		ti->error = "Metadata initialization failed";
 		goto err_dev;
@@ -852,8 +852,8 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	mod_delayed_work(dmz->flush_wq, &dmz->flush_work, DMZ_FLUSH_PERIOD);
 
-	/* Initialize reclaim */
-	ret = dmz_ctr_reclaim(dev, dmz->metadata, &dmz->reclaim);
+	/* Initialize reclaim, only reclaim from regular device. */
+	ret = dmz_ctr_reclaim(dmz->regu_dmz_dev, dmz->metadata, &dmz->reclaim);
 	if (ret) {
 		ti->error = "Zone reclaim initialization failed";
 		goto err_fwq;
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index a3535bc..7aa1a30 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -206,7 +206,8 @@ struct dmz_reclaim;
 /*
  * Functions defined in dm-zoned-metadata.c
  */
-int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **zmd);
+int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_dev *regu_dmz_dev,
+		struct dmz_metadata **zmd);
 void dmz_dtr_metadata(struct dmz_metadata *zmd);
 int dmz_resume_metadata(struct dmz_metadata *zmd);
 
-- 
2.9.5
