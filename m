From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] dm-zoned: cache device for zones
Date: Mon, 23 Mar 2020 16:03:51 +0100
Message-ID: <20200323150352.107826-2-hare@suse.de>
References: <20200323150352.107826-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200323150352.107826-1-hare@suse.de>
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
Cc: dm-devel@redhat.com, Johannes Thumshirn <jth@kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Implement 'cache' zones which reside on a different device.
The device is logically split into zones, which then will be
used as 'cache' zones, similar to the existing randow write
zones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 174 ++++++++++++++++++++++++++++-----
 drivers/md/dm-zoned-reclaim.c  |  76 +++++++++++---
 drivers/md/dm-zoned-target.c   | 109 ++++++++++++++++++---
 drivers/md/dm-zoned.h          |  31 +++++-
 4 files changed, 339 insertions(+), 51 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 369de15c4e80..41cc3a29db0b 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -132,6 +132,8 @@ struct dmz_sb {
 struct dmz_metadata {
 	struct dmz_dev		*dev;
 
+	struct dmz_cdev		*cdev;
+
 	sector_t		zone_bitmap_size;
 	unsigned int		zone_nr_bitmap_blocks;
 	unsigned int		zone_bits_per_mblk;
@@ -139,10 +141,12 @@ struct dmz_metadata {
 	unsigned int		nr_bitmap_blocks;
 	unsigned int		nr_map_blocks;
 
+	unsigned int		nr_zones;
 	unsigned int		nr_useable_zones;
 	unsigned int		nr_meta_blocks;
 	unsigned int		nr_meta_zones;
 	unsigned int		nr_data_zones;
+	unsigned int		nr_cache_zones;
 	unsigned int		nr_rnd_zones;
 	unsigned int		nr_reserved_seq;
 	unsigned int		nr_chunks;
@@ -173,6 +177,11 @@ struct dmz_metadata {
 	struct list_head	unmap_rnd_list;
 	struct list_head	map_rnd_list;
 
+	unsigned int		nr_cache;
+	atomic_t		unmap_nr_cache;
+	struct list_head	unmap_cache_list;
+	struct list_head	map_cache_list;
+
 	unsigned int		nr_seq;
 	atomic_t		unmap_nr_seq;
 	struct list_head	unmap_seq_list;
@@ -189,17 +198,25 @@ struct dmz_metadata {
  */
 unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return ((unsigned int)(zone - zmd->zones));
+	return zone->id;
 }
 
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_sectors_shift;
+	sector_t zone_id = dmz_id(zmd, zone);
+
+	if (dmz_is_cache(zone))
+		zone_id -= zmd->dev->nr_zones;
+	return zone_id << zmd->dev->zone_nr_sectors_shift;
 }
 
 sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_blocks_shift;
+	sector_t zone_id = dmz_id(zmd, zone);
+
+	if (dmz_is_cache(zone))
+		zone_id -= zmd->dev->nr_zones;
+	return zone_id << zmd->dev->zone_nr_blocks_shift;
 }
 
 unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)
@@ -217,6 +234,16 @@ unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd)
 	return atomic_read(&zmd->unmap_nr_rnd);
 }
 
+unsigned int dmz_nr_cache_zones(struct dmz_metadata *zmd)
+{
+	return zmd->nr_cache;
+}
+
+unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd)
+{
+	return atomic_read(&zmd->unmap_nr_cache);
+}
+
 /*
  * Lock/unlock mapping table.
  * The map lock also protects all the zone lists.
@@ -865,6 +892,10 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_super *sb)
 		dmz_dev_err(dev, "Invalid number of metadata blocks");
 		return -ENXIO;
 	}
+	if (zmd->nr_cache_zones && nr_meta_zones >= zmd->nr_cache_zones) {
+		dmz_dev_err(dev, "Cache too small to hold metadata");
+		return -ENXIO;\
+	}
 
 	if (!le32_to_cpu(sb->nr_reserved_seq) ||
 	    le32_to_cpu(sb->nr_reserved_seq) >= (zmd->nr_useable_zones - nr_meta_zones)) {
@@ -1104,6 +1135,7 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 
 	INIT_LIST_HEAD(&zone->link);
 	atomic_set(&zone->refcount, 0);
+	zone->id = idx;
 	zone->chunk = DMZ_MAP_UNMAPPED;
 
 	switch (blkz->type) {
@@ -1157,6 +1189,7 @@ static void dmz_drop_zones(struct dmz_metadata *zmd)
 static int dmz_init_zones(struct dmz_metadata *zmd)
 {
 	struct dmz_dev *dev = zmd->dev;
+	struct dmz_cdev *cdev = zmd->cdev;
 	int ret;
 
 	/* Init */
@@ -1167,12 +1200,16 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 					DMZ_BLOCK_SIZE_BITS);
 
 	/* Allocate zone array */
-	zmd->zones = kcalloc(dev->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
+	zmd->nr_zones = dev->nr_zones;
+	if (cdev)
+		zmd->nr_zones += cdev->capacity / dev->zone_nr_sectors;
+
+	zmd->zones = kcalloc(zmd->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
 	if (!zmd->zones)
 		return -ENOMEM;
 
 	dmz_dev_info(dev, "Using %zu B for zone information",
-		     sizeof(struct dm_zone) * dev->nr_zones);
+		     sizeof(struct dm_zone) * zmd->nr_zones);
 
 	/*
 	 * Get zone information and initialize zone descriptors.  At the same
@@ -1185,7 +1222,26 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 		dmz_drop_zones(zmd);
 		return ret;
 	}
+	if (cdev) {
+		int idx;
+
+		for (idx = dev->nr_zones; idx < zmd->nr_zones; idx++) {
+			struct dm_zone *zone = &zmd->zones[idx];
 
+			INIT_LIST_HEAD(&zone->link);
+			atomic_set(&zone->refcount, 0);
+			zone->id = idx;
+			zone->chunk = DMZ_MAP_UNMAPPED;
+			set_bit(DMZ_CACHE, &zone->flags);
+			zmd->nr_cache_zones++;
+			zone->wp_block = 0;
+			zmd->nr_useable_zones++;
+			if (!zmd->sb_zone) {
+				/* Super block zone */
+				zmd->sb_zone = zone;
+			}
+		}
+	}
 	return 0;
 }
 
@@ -1216,6 +1272,9 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	unsigned int noio_flag;
 	int ret;
 
+	if (dmz_is_cache(zone))
+		return 0;
+
 	/*
 	 * Get zone information from disk. Since blkdev_report_zones() uses
 	 * GFP_KERNEL by default for memory allocations, set the per-task
@@ -1283,7 +1342,8 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	 */
 	if (dmz_is_offline(zone) ||
 	    dmz_is_readonly(zone) ||
-	    dmz_is_rnd(zone))
+	    dmz_is_rnd(zone) ||
+	    dmz_is_cache(zone))
 		return 0;
 
 	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
@@ -1345,7 +1405,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		if (dzone_id == DMZ_MAP_UNMAPPED)
 			goto next;
 
-		if (dzone_id >= dev->nr_zones) {
+		if (dzone_id >= zmd->nr_zones) {
 			dmz_dev_err(dev, "Chunk %u mapping: invalid data zone ID %u",
 				    chunk, dzone_id);
 			return -EIO;
@@ -1358,6 +1418,8 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 
 		if (dmz_is_rnd(dzone))
 			list_add_tail(&dzone->link, &zmd->map_rnd_list);
+		else if (dmz_is_cache(dzone))
+			list_add_tail(&dzone->link, &zmd->map_cache_list);
 		else
 			list_add_tail(&dzone->link, &zmd->map_seq_list);
 
@@ -1366,14 +1428,14 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		if (bzone_id == DMZ_MAP_UNMAPPED)
 			goto next;
 
-		if (bzone_id >= dev->nr_zones) {
+		if (bzone_id >= zmd->nr_zones) {
 			dmz_dev_err(dev, "Chunk %u mapping: invalid buffer zone ID %u",
 				    chunk, bzone_id);
 			return -EIO;
 		}
 
 		bzone = dmz_get(zmd, bzone_id);
-		if (!dmz_is_rnd(bzone)) {
+		if (!dmz_is_rnd(bzone) && !dmz_is_cache(bzone)) {
 			dmz_dev_err(dev, "Chunk %u mapping: invalid buffer zone %u",
 				    chunk, bzone_id);
 			return -EIO;
@@ -1385,7 +1447,10 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		bzone->bzone = dzone;
 		dzone->bzone = bzone;
 		dmz_get_zone_weight(zmd, bzone);
-		list_add_tail(&bzone->link, &zmd->map_rnd_list);
+		if (dmz_is_cache(bzone))
+			list_add_tail(&bzone->link, &zmd->map_cache_list);
+		else
+			list_add_tail(&bzone->link, &zmd->map_rnd_list);
 next:
 		chunk++;
 		e++;
@@ -1398,13 +1463,15 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 	 * fully initialized. All remaining zones are unmapped data
 	 * zones. Finish initializing those here.
 	 */
-	for (i = 0; i < dev->nr_zones; i++) {
+	for (i = 0; i < zmd->nr_zones; i++) {
 		dzone = dmz_get(zmd, i);
 		if (dmz_is_meta(dzone))
 			continue;
 
 		if (dmz_is_rnd(dzone))
 			zmd->nr_rnd++;
+		else if (dmz_is_cache(dzone))
+			zmd->nr_cache++;
 		else
 			zmd->nr_seq++;
 
@@ -1419,6 +1486,9 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		if (dmz_is_rnd(dzone)) {
 			list_add_tail(&dzone->link, &zmd->unmap_rnd_list);
 			atomic_inc(&zmd->unmap_nr_rnd);
+		} else if (dmz_is_cache(dzone)) {
+			list_add_tail(&dzone->link, &zmd->unmap_cache_list);
+			atomic_inc(&zmd->unmap_nr_cache);
 		} else if (atomic_read(&zmd->nr_reserved_seq_zones) < zmd->nr_reserved_seq) {
 			list_add_tail(&dzone->link, &zmd->reserved_seq_zones_list);
 			atomic_inc(&zmd->nr_reserved_seq_zones);
@@ -1460,6 +1530,9 @@ static void __dmz_lru_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	if (dmz_is_seq(zone)) {
 		/* LRU rotate sequential zone */
 		list_add_tail(&zone->link, &zmd->map_seq_list);
+	} else if (dmz_is_cache(zone)) {
+		/* LRU rotate cache zone */
+		list_add_tail(&zone->link, &zmd->map_cache_list);
 	} else {
 		/* LRU rotate random zone */
 		list_add_tail(&zone->link, &zmd->map_rnd_list);
@@ -1557,6 +1630,29 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
 	return ERR_PTR(-EBUSY);
 }
 
+/*
+ * Select a cache zone for reclaim.
+ */
+static struct dm_zone *dmz_get_cache_zone_for_reclaim(struct dmz_metadata *zmd)
+{
+	struct dm_zone *dzone = NULL;
+	struct dm_zone *zone;
+
+	if (list_empty(&zmd->map_cache_list))
+		return ERR_PTR(-EBUSY);
+
+	list_for_each_entry(zone, &zmd->map_cache_list, link) {
+		if (dmz_is_buf(zone))
+			dzone = zone->bzone;
+		else
+			dzone = zone;
+		if (dmz_lock_zone_reclaim(dzone))
+			return dzone;
+	}
+
+	return ERR_PTR(-EBUSY);
+}
+
 /*
  * Select a buffered sequential zone for reclaim.
  */
@@ -1590,13 +1686,17 @@ struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd)
 	 *     cannot be reclaimed. So choose a sequential zone to reclaim so
 	 *     that afterward a random zone can be reclaimed.
 	 * (2) At least one free sequential zone is available, then choose
-	 *     the oldest random zone (data or buffer) that can be locked.
+	 *     either the oldest cache zone, or, failing that, the oldest
+	 *     random zone (data or buffer) that can be locked.
 	 */
 	dmz_lock_map(zmd);
 	if (list_empty(&zmd->reserved_seq_zones_list))
 		zone = dmz_get_seq_zone_for_reclaim(zmd);
-	else
-		zone = dmz_get_rnd_zone_for_reclaim(zmd);
+	else {
+		zone = dmz_get_cache_zone_for_reclaim(zmd);
+		if (!zone)
+			zone = dmz_get_rnd_zone_for_reclaim(zmd);
+	}
 	dmz_unlock_map(zmd);
 
 	return zone;
@@ -1629,8 +1729,12 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
 		if (op != REQ_OP_WRITE)
 			goto out;
 
-		/* Allocate a random zone */
-		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
+		/* Try to allocate a cache zone first */
+		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_CACHE);
+		if (!dzone) {
+			/* Allocate a random zone */
+			dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
+		}
 		if (!dzone) {
 			if (dmz_bdev_is_dying(zmd->dev)) {
 				dzone = ERR_PTR(-EIO);
@@ -1730,8 +1834,12 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 	if (bzone)
 		goto out;
 
-	/* Allocate a random zone */
-	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
+	/* Try to allocate a cache zone first */
+	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_CACHE);
+	if (!bzone) {
+		/* Allocate a random zone */
+		bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
+	}
 	if (!bzone) {
 		if (dmz_bdev_is_dying(zmd->dev)) {
 			bzone = ERR_PTR(-EIO);
@@ -1749,7 +1857,10 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 	bzone->chunk = dzone->chunk;
 	bzone->bzone = dzone;
 	dzone->bzone = bzone;
-	list_add_tail(&bzone->link, &zmd->map_rnd_list);
+	if (dmz_is_cache(bzone))
+		list_add_tail(&bzone->link, &zmd->map_cache_list);
+	else
+		list_add_tail(&bzone->link, &zmd->map_rnd_list);
 out:
 	dmz_unlock_map(zmd);
 
@@ -1765,7 +1876,9 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 	struct list_head *list;
 	struct dm_zone *zone;
 
-	if (flags & DMZ_ALLOC_RND)
+	if (flags & DMZ_ALLOC_CACHE)
+		list = &zmd->unmap_cache_list;
+	else if (flags & DMZ_ALLOC_RND)
 		list = &zmd->unmap_rnd_list;
 	else
 		list = &zmd->unmap_seq_list;
@@ -1791,6 +1904,8 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 
 	if (dmz_is_rnd(zone))
 		atomic_dec(&zmd->unmap_nr_rnd);
+	else if (dmz_is_cache(zone))
+		atomic_dec(&zmd->unmap_nr_cache);
 	else
 		atomic_dec(&zmd->unmap_nr_seq);
 
@@ -1817,6 +1932,9 @@ void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	if (dmz_is_rnd(zone)) {
 		list_add_tail(&zone->link, &zmd->unmap_rnd_list);
 		atomic_inc(&zmd->unmap_nr_rnd);
+	} else if (dmz_is_cache(zone)) {
+		list_add_tail(&zone->link, &zmd->unmap_cache_list);
+		atomic_inc(&zmd->unmap_nr_cache);
 	} else if (atomic_read(&zmd->nr_reserved_seq_zones) <
 		   zmd->nr_reserved_seq) {
 		list_add_tail(&zone->link, &zmd->reserved_seq_zones_list);
@@ -1842,6 +1960,8 @@ void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *dzone,
 	dzone->chunk = chunk;
 	if (dmz_is_rnd(dzone))
 		list_add_tail(&dzone->link, &zmd->map_rnd_list);
+	else if (dmz_is_cache(dzone))
+		list_add_tail(&dzone->link, &zmd->map_cache_list);
 	else
 		list_add_tail(&dzone->link, &zmd->map_seq_list);
 }
@@ -2360,7 +2480,8 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 /*
  * Initialize the zoned metadata.
  */
-int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
+int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_cdev *cdev,
+		     struct dmz_metadata **metadata)
 {
 	struct dmz_metadata *zmd;
 	unsigned int i, zid;
@@ -2372,6 +2493,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 		return -ENOMEM;
 
 	zmd->dev = dev;
+	zmd->cdev = cdev;
 	zmd->mblk_rbtree = RB_ROOT;
 	init_rwsem(&zmd->mblk_sem);
 	mutex_init(&zmd->mblk_flush_lock);
@@ -2384,6 +2506,10 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 	INIT_LIST_HEAD(&zmd->unmap_rnd_list);
 	INIT_LIST_HEAD(&zmd->map_rnd_list);
 
+	atomic_set(&zmd->unmap_nr_cache, 0);
+	INIT_LIST_HEAD(&zmd->unmap_cache_list);
+	INIT_LIST_HEAD(&zmd->map_cache_list);
+
 	atomic_set(&zmd->unmap_nr_seq, 0);
 	INIT_LIST_HEAD(&zmd->unmap_seq_list);
 	INIT_LIST_HEAD(&zmd->map_seq_list);
@@ -2407,7 +2533,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 	zid = dmz_id(zmd, zmd->sb_zone);
 	for (i = 0; i < zmd->nr_meta_zones << 1; i++) {
 		zone = dmz_get(zmd, zid + i);
-		if (!dmz_is_rnd(zone))
+		if (!dmz_is_rnd(zone) && !dmz_is_cache(zone))
 			goto err;
 		set_bit(DMZ_META, &zone->flags);
 	}
@@ -2449,6 +2575,8 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
 		     zmd->nr_data_zones, zmd->nr_chunks);
 	dmz_dev_info(dev, "    %u random zones (%u unmapped)",
 		     zmd->nr_rnd, atomic_read(&zmd->unmap_nr_rnd));
+	dmz_dev_info(dev, "    %u cache zones (%u unmapped)",
+		     zmd->nr_cache, atomic_read(&zmd->unmap_nr_cache));
 	dmz_dev_info(dev, "    %u sequential zones (%u unmapped)",
 		     zmd->nr_seq, atomic_read(&zmd->unmap_nr_seq));
 	dmz_dev_info(dev, "  %u reserved sequential data zones",
@@ -2495,7 +2623,7 @@ int dmz_resume_metadata(struct dmz_metadata *zmd)
 	int ret;
 
 	/* Check zones */
-	for (i = 0; i < dev->nr_zones; i++) {
+	for (i = 0; i < zmd->nr_zones; i++) {
 		zone = dmz_get(zmd, i);
 		if (!zone) {
 			dmz_dev_err(dev, "Unable to get zone %u", i);
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index e7ace908a9b7..c394ba19cf9b 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -14,6 +14,7 @@
 struct dmz_reclaim {
 	struct dmz_metadata     *metadata;
 	struct dmz_dev		*dev;
+	struct dmz_cdev		*cdev;
 
 	struct delayed_work	work;
 	struct workqueue_struct *wq;
@@ -44,13 +45,15 @@ enum {
  * Percentage of unmapped (free) random zones below which reclaim starts
  * even if the target is busy.
  */
-#define DMZ_RECLAIM_LOW_UNMAP_RND	30
+#define DMZ_RECLAIM_LOW_UNMAP_RND	25
+#define DMZ_RECLAIM_LOW_UNMAP_CACHE	40
 
 /*
  * Percentage of unmapped (free) random zones above which reclaim will
  * stop if the target is busy.
  */
 #define DMZ_RECLAIM_HIGH_UNMAP_RND	50
+#define DMZ_RECLAIM_HIGH_UNMAP_CACHE	60
 
 /*
  * Align a sequential zone write pointer to chunk_block.
@@ -117,6 +120,7 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
 {
 	struct dmz_metadata *zmd = zrc->metadata;
 	struct dmz_dev *dev = zrc->dev;
+	struct dmz_cdev *cdev = zrc->cdev;
 	struct dm_io_region src, dst;
 	sector_t block = 0, end_block;
 	sector_t nr_blocks;
@@ -156,11 +160,17 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
 				return ret;
 		}
 
-		src.bdev = dev->bdev;
+		if (dmz_is_cache(src_zone))
+			src.bdev = cdev->bdev;
+		else
+			src.bdev = dev->bdev;
 		src.sector = dmz_blk2sect(src_zone_block + block);
 		src.count = dmz_blk2sect(nr_blocks);
 
-		dst.bdev = dev->bdev;
+		if (dmz_is_cache(dst_zone))
+			dst.bdev = cdev->bdev;
+		else
+			dst.bdev = dev->bdev;
 		dst.sector = dmz_blk2sect(dst_zone_block + block);
 		dst.count = src.count;
 
@@ -354,7 +364,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
 
 	start = jiffies;
 
-	if (dmz_is_rnd(dzone)) {
+	if (dmz_is_rnd(dzone) || dmz_is_cache(dzone)) {
 		if (!dmz_weight(dzone)) {
 			/* Empty zone */
 			dmz_reclaim_empty(zrc, dzone);
@@ -423,7 +433,7 @@ static inline int dmz_target_idle(struct dmz_reclaim *zrc)
 /*
  * Test if reclaim is necessary.
  */
-static bool dmz_should_reclaim(struct dmz_reclaim *zrc)
+static bool dmz_should_rnd_reclaim(struct dmz_reclaim *zrc)
 {
 	struct dmz_metadata *zmd = zrc->metadata;
 	unsigned int nr_rnd = dmz_nr_rnd_zones(zmd);
@@ -445,6 +455,32 @@ static bool dmz_should_reclaim(struct dmz_reclaim *zrc)
 	return p_unmap_rnd <= DMZ_RECLAIM_LOW_UNMAP_RND;
 }
 
+static bool dmz_should_cache_reclaim(struct dmz_reclaim *zrc)
+{
+	struct dmz_metadata *zmd = zrc->metadata;
+	unsigned int nr_cache = dmz_nr_cache_zones(zmd);
+	unsigned int nr_unmap_cache = dmz_nr_unmap_cache_zones(zmd);
+	unsigned int p_unmap_cache;
+
+	if (!nr_cache)
+		return false;
+
+	/* Reclaim when idle */
+	if (dmz_target_idle(zrc) && nr_unmap_cache < nr_cache)
+		return true;
+
+	/* If there are still plenty of cache zones, do not reclaim */
+	p_unmap_cache = nr_unmap_cache * 100 / nr_cache;
+	if (p_unmap_cache >= DMZ_RECLAIM_HIGH_UNMAP_CACHE)
+		return false;
+
+	/*
+	 * If the percentage of unmapped cache zones is low,
+	 * reclaim even if the target is busy.
+	 */
+	return p_unmap_cache <= DMZ_RECLAIM_LOW_UNMAP_CACHE;
+}
+
 /*
  * Reclaim work function.
  */
@@ -452,14 +488,14 @@ static void dmz_reclaim_work(struct work_struct *work)
 {
 	struct dmz_reclaim *zrc = container_of(work, struct dmz_reclaim, work.work);
 	struct dmz_metadata *zmd = zrc->metadata;
-	unsigned int nr_rnd, nr_unmap_rnd;
-	unsigned int p_unmap_rnd;
+	unsigned int nr_rnd, nr_unmap_rnd, nr_cache, nr_unmap_cache;
+	unsigned int p_unmap_rnd, p_unmap_cache = 100;
 	int ret;
 
 	if (dmz_bdev_is_dying(zrc->dev))
 		return;
 
-	if (!dmz_should_reclaim(zrc)) {
+	if (!dmz_should_cache_reclaim(zrc) && !dmz_should_rnd_reclaim(zrc)) {
 		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
 		return;
 	}
@@ -470,21 +506,33 @@ static void dmz_reclaim_work(struct work_struct *work)
 	 * and slower if there are still some free random zones to avoid
 	 * as much as possible to negatively impact the user workload.
 	 */
+	nr_cache = dmz_nr_cache_zones(zmd);
+	if (nr_cache) {
+		nr_unmap_cache = dmz_nr_unmap_cache_zones(zmd);
+		p_unmap_cache = nr_unmap_cache * 100 / nr_cache;
+	}
 	nr_rnd = dmz_nr_rnd_zones(zmd);
 	nr_unmap_rnd = dmz_nr_unmap_rnd_zones(zmd);
 	p_unmap_rnd = nr_unmap_rnd * 100 / nr_rnd;
-	if (dmz_target_idle(zrc) || p_unmap_rnd < DMZ_RECLAIM_LOW_UNMAP_RND / 2) {
-		/* Idle or very low percentage: go fast */
+	if (dmz_target_idle(zrc)) {
+		/* Idle; go fast */
+		zrc->kc_throttle.throttle = 100;
+	} else if (p_unmap_rnd < DMZ_RECLAIM_LOW_UNMAP_CACHE / 2) {
+		/* Low percentage of cache zones; go fast */
 		zrc->kc_throttle.throttle = 100;
+	} else if (p_unmap_rnd < DMZ_RECLAIM_LOW_UNMAP_RND / 2) {
+		/* Busy, but low percentage of random zones; throttle */
+		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap_cache / 2);
 	} else {
 		/* Busy but we still have some random zone: throttle */
 		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap_rnd / 2);
 	}
 
 	dmz_dev_debug(zrc->dev,
-		      "Reclaim (%u): %s, %u%% free rnd zones (%u/%u)",
+		      "Reclaim (%u): %s, free zones: cache %u%% (%u/%u) rnd %uy%% (%u/%u)",
 		      zrc->kc_throttle.throttle,
 		      (dmz_target_idle(zrc) ? "Idle" : "Busy"),
+		      p_unmap_cache, nr_unmap_cache, nr_cache,
 		      p_unmap_rnd, nr_unmap_rnd, nr_rnd);
 
 	ret = dmz_do_reclaim(zrc);
@@ -500,7 +548,8 @@ static void dmz_reclaim_work(struct work_struct *work)
 /*
  * Initialize reclaim.
  */
-int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
+int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_cdev *cdev,
+		    struct dmz_metadata *zmd,
 		    struct dmz_reclaim **reclaim)
 {
 	struct dmz_reclaim *zrc;
@@ -511,6 +560,7 @@ int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
 		return -ENOMEM;
 
 	zrc->dev = dev;
+	zrc->cdev = cdev;
 	zrc->metadata = zmd;
 	zrc->atime = jiffies;
 
@@ -583,7 +633,7 @@ void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc)
  */
 void dmz_schedule_reclaim(struct dmz_reclaim *zrc)
 {
-	if (dmz_should_reclaim(zrc))
+	if (dmz_should_cache_reclaim(zrc) || dmz_should_rnd_reclaim(zrc))
 		mod_delayed_work(zrc->wq, &zrc->work, 0);
 }
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index f4f83d39b3dc..3f25953672b9 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -39,12 +39,16 @@ struct dm_chunk_work {
  */
 struct dmz_target {
 	struct dm_dev		*ddev;
+	struct dm_dev		*cddev;
 
 	unsigned long		flags;
 
 	/* Zoned block device information */
 	struct dmz_dev		*dev;
 
+	/* Cache block device information */
+	struct dmz_cdev		*cdev;
+
 	/* For metadata handling */
 	struct dmz_metadata     *metadata;
 
@@ -125,7 +129,10 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
 	if (!clone)
 		return -ENOMEM;
 
-	bio_set_dev(clone, dmz->dev->bdev);
+	if (dmz_is_cache(zone))
+		bio_set_dev(clone, dmz->cdev->bdev);
+	else
+		bio_set_dev(clone, dmz->dev->bdev);
 	clone->bi_iter.bi_sector =
 		dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
 	clone->bi_iter.bi_size = dmz_blk2sect(nr_blocks) << SECTOR_SHIFT;
@@ -179,7 +186,8 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 
 	dmz_dev_debug(dmz->dev, "READ chunk %llu -> %s zone %u, block %llu, %u blocks",
 		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),
-		      (dmz_is_rnd(zone) ? "RND" : "SEQ"),
+		      (dmz_is_rnd(zone) ?
+		       (dmz_is_cache(zone) ? "CACHE" : "RND") : "SEQ"),
 		      dmz_id(dmz->metadata, zone),
 		      (unsigned long long)chunk_block, nr_blocks);
 
@@ -187,7 +195,8 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 	bzone = zone->bzone;
 	while (chunk_block < end_block) {
 		nr_blocks = 0;
-		if (dmz_is_rnd(zone) || chunk_block < zone->wp_block) {
+		if (dmz_is_rnd(zone) || dmz_is_cache(zone) ||
+		    chunk_block < zone->wp_block) {
 			/* Test block validity in the data zone */
 			ret = dmz_block_valid(dmz->metadata, zone, chunk_block);
 			if (ret < 0)
@@ -316,11 +325,13 @@ static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone,
 
 	dmz_dev_debug(dmz->dev, "WRITE chunk %llu -> %s zone %u, block %llu, %u blocks",
 		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),
-		      (dmz_is_rnd(zone) ? "RND" : "SEQ"),
+		      (dmz_is_rnd(zone) ?
+		       (dmz_is_cache(zone) ? "CACHE" : "RND") : "SEQ"),
 		      dmz_id(dmz->metadata, zone),
 		      (unsigned long long)chunk_block, nr_blocks);
 
-	if (dmz_is_rnd(zone) || chunk_block == zone->wp_block) {
+	if (dmz_is_rnd(zone) || dmz_is_cache(zone) ||
+	    chunk_block == zone->wp_block) {
 		/*
 		 * zone is a random zone or it is a sequential zone
 		 * and the BIO is aligned to the zone write pointer:
@@ -364,7 +375,8 @@ static int dmz_handle_discard(struct dmz_target *dmz, struct dm_zone *zone,
 	 * Invalidate blocks in the data zone and its
 	 * buffer zone if one is mapped.
 	 */
-	if (dmz_is_rnd(zone) || chunk_block < zone->wp_block)
+	if (dmz_is_rnd(zone) || dmz_is_cache(zone) ||
+	    chunk_block < zone->wp_block)
 		ret = dmz_invalidate_blocks(zmd, zone, chunk_block, nr_blocks);
 	if (ret == 0 && zone->bzone)
 		ret = dmz_invalidate_blocks(zmd, zone->bzone,
@@ -714,8 +726,7 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
 	dev->capacity = i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
 	aligned_capacity = dev->capacity &
 				~((sector_t)blk_queue_zone_sectors(q) - 1);
-	if (ti->begin ||
-	    ((ti->len != dev->capacity) && (ti->len != aligned_capacity))) {
+	if (ti->begin || ti->len < dev->capacity) {
 		ti->error = "Partial mapping not supported";
 		ret = -EINVAL;
 		goto err;
@@ -751,6 +762,64 @@ static void dmz_put_zoned_device(struct dm_target *ti)
 	dmz->dev = NULL;
 }
 
+/*
+ * Get cache device information.
+ */
+static int dmz_get_cache_device(struct dm_target *ti, char *path)
+{
+	struct dmz_target *dmz = ti->private;
+	struct dmz_cdev *cdev;
+	int ret;
+
+	/* Get the target device */
+	ret = dm_get_device(ti, path, dm_table_get_mode(ti->table),
+			    &dmz->cddev);
+	if (ret) {
+		ti->error = "Get target device failed";
+		dmz->cdev = NULL;
+		return ret;
+	}
+
+	cdev = kzalloc(sizeof(struct dmz_cdev), GFP_KERNEL);
+	if (!cdev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	cdev->bdev = dmz->cddev->bdev;
+	(void)bdevname(cdev->bdev, cdev->name);
+
+	if (bdev_zoned_model(cdev->bdev) != BLK_ZONED_NONE) {
+		ti->error = "Cache device must not be a zoned block device";
+		ret = -EINVAL;
+		goto err;
+	}
+
+	cdev->capacity = i_size_read(cdev->bdev->bd_inode) >> SECTOR_SHIFT;
+	dmz->cdev = cdev;
+
+	return 0;
+err:
+	dm_put_device(ti, dmz->cddev);
+	kfree(cdev);
+
+	return ret;
+}
+
+/*
+ * Cleanup cache device information.
+ */
+static void dmz_put_cache_device(struct dm_target *ti)
+{
+	struct dmz_target *dmz = ti->private;
+
+	if (!dmz->cdev)
+		return;
+	dm_put_device(ti, dmz->cddev);
+	kfree(dmz->cdev);
+	dmz->cdev = NULL;
+}
+
 /*
  * Setup target.
  */
@@ -758,10 +827,11 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dmz_target *dmz;
 	struct dmz_dev *dev;
+	struct dmz_cdev *cdev;
 	int ret;
 
 	/* Check arguments */
-	if (argc != 1) {
+	if (argc > 2) {
 		ti->error = "Invalid argument count";
 		return -EINVAL;
 	}
@@ -781,12 +851,23 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
+	/* Get the cache device for random zones */
+	if (argc == 2) {
+		ret = dmz_get_cache_device(ti, argv[1]);
+		if (ret) {
+			dmz->cdev = NULL;
+			ti->error = "Cache device failed";
+			goto err_dev;
+		}
+	}
+
 	/* Initialize metadata */
 	dev = dmz->dev;
-	ret = dmz_ctr_metadata(dev, &dmz->metadata);
+	cdev = dmz->cdev;
+	ret = dmz_ctr_metadata(dev, cdev, &dmz->metadata);
 	if (ret) {
 		ti->error = "Metadata initialization failed";
-		goto err_dev;
+		goto err_cdev;
 	}
 
 	/* Set target (no write same support) */
@@ -833,7 +914,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mod_delayed_work(dmz->flush_wq, &dmz->flush_work, DMZ_FLUSH_PERIOD);
 
 	/* Initialize reclaim */
-	ret = dmz_ctr_reclaim(dev, dmz->metadata, &dmz->reclaim);
+	ret = dmz_ctr_reclaim(dev, cdev, dmz->metadata, &dmz->reclaim);
 	if (ret) {
 		ti->error = "Zone reclaim initialization failed";
 		goto err_fwq;
@@ -853,6 +934,8 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	bioset_exit(&dmz->bio_set);
 err_meta:
 	dmz_dtr_metadata(dmz->metadata);
+err_cdev:
+	dmz_put_cache_device(ti);
 err_dev:
 	dmz_put_zoned_device(ti);
 err:
@@ -882,6 +965,8 @@ static void dmz_dtr(struct dm_target *ti)
 
 	bioset_exit(&dmz->bio_set);
 
+	dmz_put_cache_device(ti);
+
 	dmz_put_zoned_device(ti);
 
 	mutex_destroy(&dmz->chunk_lock);
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 5b5e493d479c..c2b6a919681a 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -66,6 +66,21 @@ struct dmz_dev {
 	sector_t		zone_nr_blocks_shift;
 };
 
+/*
+ * Cache block device information.
+ */
+struct dmz_cdev {
+	struct block_device	*bdev;
+
+	char			name[BDEVNAME_SIZE];
+
+	sector_t		capacity;
+
+	unsigned int		nr_zones;
+
+	unsigned int		flags;
+};
+
 #define dmz_bio_chunk(dev, bio)	((bio)->bi_iter.bi_sector >> \
 				 (dev)->zone_nr_sectors_shift)
 #define dmz_chunk_block(dev, b)	((b) & ((dev)->zone_nr_blocks - 1))
@@ -73,6 +88,7 @@ struct dmz_dev {
 /* Device flags. */
 #define DMZ_BDEV_DYING		(1 << 0)
 #define DMZ_CHECK_BDEV		(2 << 0)
+#define DMZ_BDEV_CACHE		(4 << 0)
 
 /*
  * Zone descriptor.
@@ -87,6 +103,9 @@ struct dm_zone {
 	/* Zone activation reference count */
 	atomic_t		refcount;
 
+	/* Zone id */
+	unsigned int		id;
+
 	/* Zone write pointer block (relative to the zone start block) */
 	unsigned int		wp_block;
 
@@ -111,6 +130,7 @@ enum {
 	/* Zone write type */
 	DMZ_RND,
 	DMZ_SEQ,
+	DMZ_CACHE,
 
 	/* Zone critical condition */
 	DMZ_OFFLINE,
@@ -131,6 +151,7 @@ enum {
  */
 #define dmz_is_rnd(z)		test_bit(DMZ_RND, &(z)->flags)
 #define dmz_is_seq(z)		test_bit(DMZ_SEQ, &(z)->flags)
+#define dmz_is_cache(z)		test_bit(DMZ_CACHE, &(z)->flags)
 #define dmz_is_empty(z)		((z)->wp_block == 0)
 #define dmz_is_offline(z)	test_bit(DMZ_OFFLINE, &(z)->flags)
 #define dmz_is_readonly(z)	test_bit(DMZ_READ_ONLY, &(z)->flags)
@@ -164,7 +185,8 @@ struct dmz_reclaim;
 /*
  * Functions defined in dm-zoned-metadata.c
  */
-int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **zmd);
+int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_cdev *cdev,
+		     struct dmz_metadata **zmd);
 void dmz_dtr_metadata(struct dmz_metadata *zmd);
 int dmz_resume_metadata(struct dmz_metadata *zmd);
 
@@ -183,6 +205,7 @@ unsigned int dmz_nr_chunks(struct dmz_metadata *zmd);
 
 #define DMZ_ALLOC_RND		0x01
 #define DMZ_ALLOC_RECLAIM	0x02
+#define DMZ_ALLOC_CACHE		0x04
 
 struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags);
 void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
@@ -192,6 +215,8 @@ void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *zone,
 void dmz_unmap_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
 unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd);
 unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd);
+unsigned int dmz_nr_cache_zones(struct dmz_metadata *zmd);
+unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd);
 
 /*
  * Activate a zone (increment its reference count).
@@ -244,8 +269,8 @@ int dmz_merge_valid_blocks(struct dmz_metadata *zmd, struct dm_zone *from_zone,
 /*
  * Functions defined in dm-zoned-reclaim.c
  */
-int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
-		    struct dmz_reclaim **zrc);
+int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_cdev *cdev,
+		    struct dmz_metadata *zmd, struct dmz_reclaim **zrc);
 void dmz_dtr_reclaim(struct dmz_reclaim *zrc);
 void dmz_suspend_reclaim(struct dmz_reclaim *zrc);
 void dmz_resume_reclaim(struct dmz_reclaim *zrc);
-- 
2.25.0
