From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/12] dm-zoned: convert to xarray
Date: Fri, 22 May 2020 17:38:51 +0200
Message-ID: <20200522153901.133375-3-hare@suse.de>
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

The zones array is getting really large, and large arrays
tend to wreak havoc with the caches.
So convert it to xarray to become more cache friendly.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 98 +++++++++++++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index b0d3ed4ac56a..3da6702bb1ae 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -172,7 +172,7 @@ struct dmz_metadata {
 	unsigned int		nr_chunks;
 
 	/* Zone information array */
-	struct dm_zone		*zones;
+	struct xarray		zones;
 
 	struct dmz_sb		sb[3];
 	unsigned int		mblk_primary;
@@ -327,6 +327,11 @@ unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd)
 	return atomic_read(&zmd->unmap_nr_seq);
 }
 
+static struct dm_zone *dmz_get(struct dmz_metadata *zmd, unsigned int zone_id)
+{
+	return xa_load(&zmd->zones, zone_id);
+}
+
 const char *dmz_metadata_label(struct dmz_metadata *zmd)
 {
 	return (const char *)zmd->label;
@@ -1121,6 +1126,7 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
 {
 	unsigned int zone_nr_blocks = zmd->zone_nr_blocks;
 	struct dmz_mblock *mblk;
+	unsigned int zone_id = zmd->sb[0].zone->id;
 	int i;
 
 	/* Allocate a block */
@@ -1133,17 +1139,16 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
 
 	/* Bad first super block: search for the second one */
 	zmd->sb[1].block = zmd->sb[0].block + zone_nr_blocks;
-	zmd->sb[1].zone = zmd->sb[0].zone + 1;
+	zmd->sb[1].zone = xa_load(&zmd->zones, zone_id + 1);
 	zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
-	for (i = 0; i < zmd->nr_rnd_zones - 1; i++) {
+	for (i = 1; i < zmd->nr_rnd_zones; i++) {
 		if (dmz_read_sb(zmd, 1) != 0)
 			break;
-		if (le32_to_cpu(zmd->sb[1].sb->magic) == DMZ_MAGIC) {
-			zmd->sb[1].zone += i;
+		if (le32_to_cpu(zmd->sb[1].sb->magic) == DMZ_MAGIC)
 			return 0;
-		}
 		zmd->sb[1].block += zone_nr_blocks;
-		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone + i);
+		zmd->sb[1].zone = dmz_get(zmd, zone_id + i);
+		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
 	}
 
 	dmz_free_mblock(zmd, mblk);
@@ -1259,8 +1264,12 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 	/* Read and check secondary super block */
 	if (ret == 0) {
 		sb_good[0] = true;
-		if (!zmd->sb[1].zone)
-			zmd->sb[1].zone = zmd->sb[0].zone + zmd->nr_meta_zones;
+		if (!zmd->sb[1].zone) {
+			unsigned int zone_id =
+				zmd->sb[0].zone->id + zmd->nr_meta_zones;
+
+			zmd->sb[1].zone = dmz_get(zmd, zone_id);
+		}
 		zmd->sb[1].block = dmz_start_block(zmd, zmd->sb[1].zone);
 		zmd->sb[1].dev = dmz_zone_to_dev(zmd, zmd->sb[1].zone);
 		ret = dmz_get_sb(zmd, 1);
@@ -1341,7 +1350,12 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
 	struct dmz_metadata *zmd = data;
 	struct dmz_dev *dev = zmd->nr_devs > 1 ? &zmd->dev[1] : &zmd->dev[0];
 	int idx = num + dev->zone_offset;
-	struct dm_zone *zone = &zmd->zones[idx];
+	struct dm_zone *zone = kzalloc(sizeof(struct dm_zone), GFP_KERNEL);
+
+	if (!zone)
+		return -ENOMEM;
+	if (xa_insert(&zmd->zones, idx, zone, GFP_KERNEL))
+		return -EBUSY;
 
 	if (blkz->len != zmd->zone_nr_sectors) {
 		if (zmd->sb_version > 1) {
@@ -1397,14 +1411,18 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
 	return 0;
 }
 
-static void dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
+static int dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
 {
 	int idx;
 	sector_t zone_offset = 0;
 
 	for(idx = 0; idx < dev->nr_zones; idx++) {
-		struct dm_zone *zone = &zmd->zones[idx];
-
+		struct dm_zone *zone =
+			kzalloc(sizeof(struct dm_zone), GFP_KERNEL);
+		if (!zone)
+			return -ENOMEM;
+		if (xa_insert(&zmd->zones, idx, zone, GFP_KERNEL) < 0)
+			return -EBUSY;
 		INIT_LIST_HEAD(&zone->link);
 		atomic_set(&zone->refcount, 0);
 		zone->id = idx;
@@ -1420,6 +1438,7 @@ static void dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
 		}
 		zone_offset += zmd->zone_nr_sectors;
 	}
+	return 0;
 }
 
 /*
@@ -1427,8 +1446,15 @@ static void dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
  */
 static void dmz_drop_zones(struct dmz_metadata *zmd)
 {
-	kfree(zmd->zones);
-	zmd->zones = NULL;
+	int idx;
+
+	for(idx = 0; idx < zmd->nr_zones; idx++) {
+		struct dm_zone *zone = xa_load(&zmd->zones, idx);
+
+		kfree(zone);
+		xa_erase(&zmd->zones, idx);
+	}
+	xa_destroy(&zmd->zones);
 }
 
 /*
@@ -1460,20 +1486,25 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 		DMERR("(%s): No zones found", zmd->devname);
 		return -ENXIO;
 	}
-	zmd->zones = kcalloc(zmd->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
-	if (!zmd->zones)
-		return -ENOMEM;
+	xa_init(&zmd->zones);
 
 	DMDEBUG("(%s): Using %zu B for zone information",
 		zmd->devname, sizeof(struct dm_zone) * zmd->nr_zones);
 
 	if (zmd->nr_devs > 1) {
-		dmz_emulate_zones(zmd, &zmd->dev[0]);
+		ret = dmz_emulate_zones(zmd, &zmd->dev[0]);
+		if (ret < 0) {
+			DMDEBUG("(%s): Failed to emulate zones, error %d",
+				zmd->devname, ret);
+			dmz_drop_zones(zmd);
+			return ret;
+		}
+
 		/*
 		 * Primary superblock zone is always at zone 0 when multiple
 		 * drives are present.
 		 */
-		zmd->sb[0].zone = &zmd->zones[0];
+		zmd->sb[0].zone = dmz_get(zmd, 0);
 
 		zoned_dev = &zmd->dev[1];
 	}
@@ -1576,11 +1607,6 @@ static int dmz_handle_seq_write_err(struct dmz_metadata *zmd,
 	return 0;
 }
 
-static struct dm_zone *dmz_get(struct dmz_metadata *zmd, unsigned int zone_id)
-{
-	return &zmd->zones[zone_id];
-}
-
 /*
  * Reset a zone write pointer.
  */
@@ -1662,6 +1688,11 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		}
 
 		dzone = dmz_get(zmd, dzone_id);
+		if (!dzone) {
+			dmz_zmd_err(zmd, "Chunk %u mapping: data zone %u not present",
+				    chunk, dzone_id);
+			return -EIO;
+		}
 		set_bit(DMZ_DATA, &dzone->flags);
 		dzone->chunk = chunk;
 		dmz_get_zone_weight(zmd, dzone);
@@ -1685,6 +1716,11 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 		}
 
 		bzone = dmz_get(zmd, bzone_id);
+		if (!bzone) {
+			dmz_zmd_err(zmd, "Chunk %u mapping: buffer zone %u not present",
+				    chunk, bzone_id);
+			return -EIO;
+		}
 		if (!dmz_is_rnd(bzone) && !dmz_is_cache(bzone)) {
 			dmz_zmd_err(zmd, "Chunk %u mapping: invalid buffer zone %u",
 				    chunk, bzone_id);
@@ -1715,6 +1751,8 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
 	 */
 	for (i = 0; i < zmd->nr_zones; i++) {
 		dzone = dmz_get(zmd, i);
+		if (!dzone)
+			continue;
 		if (dmz_is_meta(dzone))
 			continue;
 		if (dmz_is_offline(dzone))
@@ -1977,6 +2015,10 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
 	} else {
 		/* The chunk is already mapped: get the mapping zone */
 		dzone = dmz_get(zmd, dzone_id);
+		if (!dzone) {
+			dzone = ERR_PTR(-EIO);
+			goto out;
+		}
 		if (dzone->chunk != chunk) {
 			dzone = ERR_PTR(-EIO);
 			goto out;
@@ -2794,6 +2836,12 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	/* Set metadata zones starting from sb_zone */
 	for (i = 0; i < zmd->nr_meta_zones << 1; i++) {
 		zone = dmz_get(zmd, zmd->sb[0].zone->id + i);
+		if (!zone) {
+			dmz_zmd_err(zmd,
+				    "metadata zone %u not present", i);
+			ret = -ENXIO;
+			goto err;
+		}
 		if (!dmz_is_rnd(zone) && !dmz_is_cache(zone)) {
 			dmz_zmd_err(zmd,
 				    "metadata zone %d is not random", i);
-- 
2.16.4
