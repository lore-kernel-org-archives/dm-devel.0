From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/11] dm-zoned: add metadata logging functions
Date: Thu,  9 Apr 2020 08:45:25 +0200
Message-ID: <20200409064527.82992-10-hare@suse.de>
References: <20200409064527.82992-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200409064527.82992-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Use the metadata label for logging and not the underlying
device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 95 ++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 34dc5f3abf09..211dee442a01 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -194,6 +194,17 @@ struct dmz_metadata {
 	wait_queue_head_t	free_wq;
 };
 
+#define dmz_zmd_info(zmd, format, args...)	\
+	DMINFO("(%s): " format, (zmd)->devname, ## args)
+
+#define dmz_zmd_err(zmd, format, args...)	\
+	DMERR("(%s): " format, (zmd)->devname, ## args)
+
+#define dmz_zmd_warn(zmd, format, args...)	\
+	DMWARN("(%s): " format, (zmd)->devname, ## args)
+
+#define dmz_zmd_debug(zmd, format, args...)	\
+	DMDEBUG("(%s): " format, (zmd)->devname, ## args)
 /*
  * Various accessors
  */
@@ -1093,7 +1104,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 	int ret;
 
 	if (!zmd->sb[0].zone) {
-		dmz_dev_err(zmd->dev, "Primary super block zone not set");
+		dmz_zmd_err(zmd, "Primary super block zone not set");
 		return -ENXIO;
 	}
 
@@ -1130,7 +1141,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 
 	/* Use highest generation sb first */
 	if (!sb_good[0] && !sb_good[1]) {
-		dmz_dev_err(zmd->dev, "No valid super block found");
+		dmz_zmd_err(zmd, "No valid super block found");
 		return -EIO;
 	}
 
@@ -1243,7 +1254,7 @@ static void dmz_drop_zones(struct dmz_metadata *zmd)
  */
 static int dmz_init_zones(struct dmz_metadata *zmd)
 {
-	struct dmz_dev *dev = zmd->dev;
+	struct dmz_dev *dev = &zmd->dev[0];
 	int ret;
 
 	/* Init */
@@ -1263,8 +1274,8 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 	if (!zmd->zones)
 		return -ENOMEM;
 
-	dmz_dev_info(dev, "Using %zu B for zone information",
-		     sizeof(struct dm_zone) * zmd->nr_zones);
+	DMINFO("(%s): Using %zu B for zone information",
+	       zmd->devname, sizeof(struct dm_zone) * zmd->nr_zones);
 
 	/*
 	 * Get zone information and initialize zone descriptors.  At the same
@@ -1407,7 +1418,6 @@ static void dmz_get_zone_weight(struct dmz_metadata *zmd, struct dm_zone *zone);
  */
 static int dmz_load_mapping(struct dmz_metadata *zmd)
 {
-	struct dmz_dev *dev = zmd->dev;
 	struct dm_zone *dzone, *bzone;
 	struct dmz_mblock *dmap_mblk = NULL;
 	struct dmz_map *dmap;
@@ -1440,7 +1450,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 			goto next;
 
 		if (dzone_id >= zmd->nr_zones) {
-			dmz_dev_err(dev, "Chunk %u mapping: invalid data zone ID %u",
+			dmz_zmd_err(zmd, "Chunk %u mapping: invalid data zone ID %u",
 				    chunk, dzone_id);
 			return -EIO;
 		}
@@ -1461,14 +1471,14 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 			goto next;
 
 		if (bzone_id >= zmd->nr_zones) {
-			dmz_dev_err(dev, "Chunk %u mapping: invalid buffer zone ID %u",
+			dmz_zmd_err(zmd, "Chunk %u mapping: invalid buffer zone ID %u",
 				    chunk, bzone_id);
 			return -EIO;
 		}
 
 		bzone = dmz_get(zmd, bzone_id);
 		if (!dmz_is_rnd(bzone)) {
-			dmz_dev_err(dev, "Chunk %u mapping: invalid buffer zone %u",
+			dmz_zmd_err(zmd, "Chunk %u mapping: invalid buffer zone %u",
 				    chunk, bzone_id);
 			return -EIO;
 		}
@@ -1888,7 +1898,7 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
 		atomic_dec(&zmd->unmap_nr_seq);
 
 	if (dmz_is_offline(zone)) {
-		dmz_dev_warn(zmd->dev, "Zone %u is offline", zone->id);
+		dmz_zmd_warn(zmd, "Zone %u is offline", zone->id);
 		zone = NULL;
 		goto again;
 	}
@@ -2099,7 +2109,7 @@ int dmz_validate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
 	struct dmz_mblock *mblk;
 	unsigned int n = 0;
 
-	dmz_dev_debug(zmd->dev, "=> VALIDATE zone %u, block %llu, %u blocks",
+	dmz_zmd_debug(zmd, "=> VALIDATE zone %u, block %llu, %u blocks",
 		      zone->id, (unsigned long long)chunk_block,
 		      nr_blocks);
 
@@ -2129,7 +2139,7 @@ int dmz_validate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
 	if (likely(zone->weight + n <= zone_nr_blocks))
 		zone->weight += n;
 	else {
-		dmz_dev_warn(zmd->dev, "Zone %u: weight %u should be <= %u",
+		dmz_zmd_warn(zmd, "Zone %u: weight %u should be <= %u",
 			     zone->id, zone->weight,
 			     zone_nr_blocks - n);
 		zone->weight = zone_nr_blocks;
@@ -2179,7 +2189,7 @@ int dmz_invalidate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
 	struct dmz_mblock *mblk;
 	unsigned int n = 0;
 
-	dmz_dev_debug(zmd->dev, "=> INVALIDATE zone %u, block %llu, %u blocks",
+	dmz_zmd_debug(zmd, "=> INVALIDATE zone %u, block %llu, %u blocks",
 		      zone->id, (u64)chunk_block, nr_blocks);
 
 	WARN_ON(chunk_block + nr_blocks > zmd->zone_nr_blocks);
@@ -2209,7 +2219,7 @@ int dmz_invalidate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
 	if (zone->weight >= n)
 		zone->weight -= n;
 	else {
-		dmz_dev_warn(zmd->dev, "Zone %u: weight %u should be >= %u",
+		dmz_zmd_warn(zmd, "Zone %u: weight %u should be >= %u",
 			     zone->id, zone->weight, n);
 		zone->weight = 0;
 	}
@@ -2419,7 +2429,7 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 	while (!list_empty(&zmd->mblk_dirty_list)) {
 		mblk = list_first_entry(&zmd->mblk_dirty_list,
 					struct dmz_mblock, link);
-		dmz_dev_warn(zmd->dev, "mblock %llu still in dirty list (ref %u)",
+		dmz_zmd_warn(zmd, "mblock %llu still in dirty list (ref %u)",
 			     (u64)mblk->no, mblk->ref);
 		list_del_init(&mblk->link);
 		rb_erase(&mblk->node, &zmd->mblk_rbtree);
@@ -2437,7 +2447,7 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 	/* Sanity checks: the mblock rbtree should now be empty */
 	root = &zmd->mblk_rbtree;
 	rbtree_postorder_for_each_entry_safe(mblk, next, root, node) {
-		dmz_dev_warn(zmd->dev, "mblock %llu ref %u still in rbtree",
+		dmz_zmd_warn(zmd, "mblock %llu ref %u still in rbtree",
 			     (u64)mblk->no, mblk->ref);
 		mblk->ref = 0;
 		dmz_free_mblock(zmd, mblk);
@@ -2450,6 +2460,18 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
 	mutex_destroy(&zmd->map_lock);
 }
 
+void dmz_print_dev(struct dmz_metadata *zmd, int num)
+{
+	struct dmz_dev *dev = &zmd->dev[num];
+
+	dmz_dev_info(dev, "Host-%s zoned block device",
+		     bdev_zoned_model(dev->bdev) == BLK_ZONED_HA ?
+		     "aware" : "managed");
+	dmz_dev_info(dev, "  %llu 512-byte logical sectors",
+		     (u64)dev->capacity);
+	dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",
+		     dev->nr_zones, (u64)zmd->zone_nr_sectors);
+}
 /*
  * Initialize the zoned metadata.
  */
@@ -2526,34 +2548,31 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata,
 	/* Metadata cache shrinker */
 	ret = register_shrinker(&zmd->mblk_shrinker);
 	if (ret) {
-		dmz_dev_err(dev, "Register metadata cache shrinker failed");
+		dmz_zmd_err(zmd, "Register metadata cache shrinker failed");
 		goto err;
 	}
 
-	dmz_dev_info(dev, "Host-%s zoned block device",
-		     bdev_zoned_model(dev->bdev) == BLK_ZONED_HA ?
-		     "aware" : "managed");
-	dmz_dev_info(dev, "  %llu 512-byte logical sectors",
-		     (u64)dev->capacity);
-	dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",
+	dmz_zmd_info(zmd, "DM-Zoned metadata version %d", DMZ_META_VER);
+	dmz_print_dev(zmd, 0);
+
+	dmz_zmd_info(zmd, "  %u zones of %llu 512-byte logical sectors",
 		     zmd->nr_zones, (u64)zmd->zone_nr_sectors);
-	dmz_dev_info(dev, "  %u metadata zones",
+	dmz_zmd_info(zmd, "  %u metadata zones",
 		     zmd->nr_meta_zones * 2);
-	dmz_dev_info(dev, "  %u data zones for %u chunks",
+	dmz_zmd_info(zmd, "  %u data zones for %u chunks",
 		     zmd->nr_data_zones, zmd->nr_chunks);
-	dmz_dev_info(dev, "    %u random zones (%u unmapped)",
+	dmz_zmd_info(zmd, "    %u random zones (%u unmapped)",
 		     zmd->nr_rnd, atomic_read(&zmd->unmap_nr_rnd));
-	dmz_dev_info(dev, "    %u sequential zones (%u unmapped)",
+	dmz_zmd_info(zmd, "    %u sequential zones (%u unmapped)",
 		     zmd->nr_seq, atomic_read(&zmd->unmap_nr_seq));
-	dmz_dev_info(dev, "  %u reserved sequential data zones",
+	dmz_zmd_info(zmd, "  %u reserved sequential data zones",
 		     zmd->nr_reserved_seq);
-
-	dmz_dev_debug(dev, "Format:");
-	dmz_dev_debug(dev, "%u metadata blocks per set (%u max cache)",
+	dmz_zmd_debug(zmd, "Format:");
+	dmz_zmd_debug(zmd, "%u metadata blocks per set (%u max cache)",
 		      zmd->nr_meta_blocks, zmd->max_nr_mblks);
-	dmz_dev_debug(dev, "  %u data zone mapping blocks",
+	dmz_zmd_debug(zmd, "  %u data zone mapping blocks",
 		      zmd->nr_map_blocks);
-	dmz_dev_debug(dev, "  %u bitmap blocks",
+	dmz_zmd_debug(zmd, "  %u bitmap blocks",
 		      zmd->nr_bitmap_blocks);
 
 	*metadata = zmd;
@@ -2582,7 +2601,6 @@ void dmz_dtr_metadata(struct dmz_metadata *zmd)
  */
 int dmz_resume_metadata(struct dmz_metadata *zmd)
 {
-	struct dmz_dev *dev = zmd->dev;
 	struct dm_zone *zone;
 	sector_t wp_block;
 	unsigned int i;
@@ -2592,20 +2610,19 @@ int dmz_resume_metadata(struct dmz_metadata *zmd)
 	for (i = 0; i < zmd->nr_zones; i++) {
 		zone = dmz_get(zmd, i);
 		if (!zone) {
-			dmz_dev_err(dev, "Unable to get zone %u", i);
+			dmz_zmd_err(zmd, "Unable to get zone %u", i);
 			return -EIO;
 		}
-
 		wp_block = zone->wp_block;
 
 		ret = dmz_update_zone(zmd, zone);
 		if (ret) {
-			dmz_dev_err(dev, "Broken zone %u", i);
+			dmz_zmd_err(zmd, "Broken zone %u", i);
 			return ret;
 		}
 
 		if (dmz_is_offline(zone)) {
-			dmz_dev_warn(dev, "Zone %u is offline", i);
+			dmz_zmd_warn(zmd, "Zone %u is offline", i);
 			continue;
 		}
 
@@ -2613,7 +2630,7 @@ int dmz_resume_metadata(struct dmz_metadata *zmd)
 		if (!dmz_is_seq(zone))
 			zone->wp_block = 0;
 		else if (zone->wp_block != wp_block) {
-			dmz_dev_err(dev, "Zone %u: Invalid wp (%llu / %llu)",
+			dmz_zmd_err(zmd, "Zone %u: Invalid wp (%llu / %llu)",
 				    i, (u64)zone->wp_block, (u64)wp_block);
 			zone->wp_block = wp_block;
 			dmz_invalidate_blocks(zmd, zone, zone->wp_block,
-- 
2.25.0
