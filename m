From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/11] dm-zoned: metadata version 2
Date: Mon,  6 Apr 2020 16:35:05 +0200
Message-ID: <20200406143505.133271-12-hare@suse.de>
References: <20200406143505.133271-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200406143505.133271-1-hare@suse.de>
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

Implement handling for metadata version 2. The new metadata adds
a label and UUID for the device mapper device, and additional UUID
for the underlying block devices.
It also allows for an additional regular drive to be used for
emulating random access zones. The emulated zones will be placed
logically in front of the zones from the zoned block device, causing
the superblocks and metadata to be stored on that device.
The first zone of the original zoned device will be used to hold
another, tertiary copy of the metadata. This copy carries a
generation number of 0 and is never updated; it's just used
for identification.
The zones are spaced equidistant, which means that any eventual
runt zones will be counted, too. They are marked as 'offline' and
ignored when selecting zones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-metadata.c | 269 +++++++++++++++++++++++++++------
 drivers/md/dm-zoned-target.c   | 128 +++++++++-------
 drivers/md/dm-zoned.h          |   7 +-
 3 files changed, 304 insertions(+), 100 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index e036ba4bfe57..e498e1aee915 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -16,7 +16,7 @@
 /*
  * Metadata version.
  */
-#define DMZ_META_VER	1
+#define DMZ_META_VER	2
 
 /*
  * On-disk super block magic.
@@ -69,8 +69,17 @@ struct dmz_super {
 	/* Checksum */
 	__le32		crc;			/*  48 */
 
+	/* DM-Zoned label */
+	u8		dmz_label[32];		/*  80 */
+
+	/* DM-Zoned UUID */
+	u8		dmz_uuid[16];		/*  96 */
+
+	/* Device UUID */
+	u8		dev_uuid[16];		/* 112 */
+
 	/* Padding to full 512B sector */
-	u8		reserved[464];		/* 512 */
+	u8		reserved[400];		/* 512 */
 };
 
 /*
@@ -135,6 +144,8 @@ struct dmz_metadata {
 	struct dmz_dev		*dev;
 
 	char			devname[BDEVNAME_SIZE];
+	char			label[BDEVNAME_SIZE];
+	uuid_t			uuid;
 
 	sector_t		zone_bitmap_size;
 	unsigned int		zone_nr_bitmap_blocks;
@@ -161,8 +172,9 @@ struct dmz_metadata {
 	/* Zone information array */
 	struct dm_zone		*zones;
 
-	struct dmz_sb		sb[2];
+	struct dmz_sb		sb[3];
 	unsigned int		mblk_primary;
+	unsigned int		sb_version;
 	u64			sb_gen;
 	unsigned int		min_nr_mblks;
 	unsigned int		max_nr_mblks;
@@ -195,16 +207,16 @@ struct dmz_metadata {
 };
 
 #define dmz_zmd_info(zmd, format, args...)	\
-	DMINFO("(%s): " format, (zmd)->devname, ## args)
+	DMINFO("(%s): " format, (zmd)->label, ## args)
 
 #define dmz_zmd_err(zmd, format, args...)	\
-	DMERR("(%s): " format, (zmd)->devname, ## args)
+	DMERR("(%s): " format, (zmd)->label, ## args)
 
 #define dmz_zmd_warn(zmd, format, args...)	\
-	DMWARN("(%s): " format, (zmd)->devname, ## args)
+	DMWARN("(%s): " format, (zmd)->label, ## args)
 
 #define dmz_zmd_debug(zmd, format, args...)	\
-	DMDEBUG("(%s): " format, (zmd)->devname, ## args)
+	DMDEBUG("(%s): " format, (zmd)->label, ## args)
 /*
  * Various accessors
  */
@@ -215,16 +227,41 @@ unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return (sector_t)dmz_id(zmd, zone) << zmd->zone_nr_sectors_shift;
+	unsigned int zone_id;
+
+	if (WARN_ON(!zone))
+		return 0;
+
+	zone_id = zone->id;
+	if (zmd->dev[0].zone_offset &&
+	    (zone_id >= zmd->dev[0].zone_offset))
+		zone_id -= zmd->dev[0].zone_offset;
+	return (sector_t)zone_id << zmd->zone_nr_sectors_shift;
 }
 
 sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
-	return (sector_t)dmz_id(zmd, zone) << zmd->zone_nr_blocks_shift;
+	unsigned int zone_id;
+
+	if (WARN_ON(!zone))
+		return 0;
+
+	zone_id = zone->id;
+	if (zmd->dev[0].zone_offset &&
+	    (zone_id >= zmd->dev[0].zone_offset))
+		zone_id -= zmd->dev[0].zone_offset;
+	return (sector_t)zone_id << zmd->zone_nr_blocks_shift;
 }
 
 struct dmz_dev *dmz_zone_to_dev(struct dmz_metadata *zmd, struct dm_zone *zone)
 {
+	if (WARN_ON(!zone))
+		return &zmd->dev[0];
+
+	if (zmd->dev[0].zone_offset &&
+	    zone->id < zmd->dev[0].zone_offset)
+			return &zmd->dev[1];
+
 	return &zmd->dev[0];
 }
 
@@ -280,7 +317,7 @@ unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd)
 
 const char *dmz_metadata_label(struct dmz_metadata *zmd)
 {
-	return (const char *)zmd->devname;
+	return (const char *)zmd->label;
 }
 
 bool dmz_check_dev(struct dmz_metadata *zmd)
@@ -687,6 +724,9 @@ static int dmz_rdwr_block(struct dmz_dev *dev, int op,
 	struct bio *bio;
 	int ret;
 
+	if (WARN_ON(!dev))
+		return -EIO;
+
 	if (dmz_bdev_is_dying(dev))
 		return -EIO;
 
@@ -711,7 +751,8 @@ static int dmz_rdwr_block(struct dmz_dev *dev, int op,
  */
 static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
 {
-	sector_t block = zmd->sb[set].block;
+	unsigned int sb_zid = dmz_id(zmd, zmd->sb[set].zone);
+	sector_t sb_block = sb_zid << zmd->zone_nr_blocks_shift;
 	struct dmz_mblock *mblk = zmd->sb[set].mblk;
 	struct dmz_super *sb = zmd->sb[set].sb;
 	struct dmz_dev *dev = zmd->sb[set].dev;
@@ -719,11 +760,17 @@ static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
 	int ret;
 
 	sb->magic = cpu_to_le32(DMZ_MAGIC);
-	sb->version = cpu_to_le32(DMZ_META_VER);
+
+	sb->version = cpu_to_le32(zmd->sb_version);
+	if (zmd->sb_version > 1) {
+		uuid_copy((uuid_t *)sb->dmz_uuid, &zmd->uuid);
+		memcpy(sb->dmz_label, zmd->label, BDEVNAME_SIZE);
+		uuid_copy((uuid_t *)sb->dev_uuid, &dev->uuid);
+	}
 
 	sb->gen = cpu_to_le64(sb_gen);
 
-	sb->sb_block = cpu_to_le64(block);
+	sb->sb_block = cpu_to_le64(sb_block);
 	sb->nr_meta_blocks = cpu_to_le32(zmd->nr_meta_blocks);
 	sb->nr_reserved_seq = cpu_to_le32(zmd->nr_reserved_seq);
 	sb->nr_chunks = cpu_to_le32(zmd->nr_chunks);
@@ -734,7 +781,8 @@ static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
 	sb->crc = 0;
 	sb->crc = cpu_to_le32(crc32_le(sb_gen, (unsigned char *)sb, DMZ_BLOCK_SIZE));
 
-	ret = dmz_rdwr_block(dev, REQ_OP_WRITE, block, mblk->page);
+	ret = dmz_rdwr_block(dev, REQ_OP_WRITE, zmd->sb[set].block,
+			     mblk->page);
 	if (ret == 0)
 		ret = blkdev_issue_flush(dev->bdev, GFP_NOIO, NULL);
 
@@ -915,6 +963,23 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
 	u32 crc, stored_crc;
 	u64 gen;
 
+	if (le32_to_cpu(sb->magic) != DMZ_MAGIC) {
+		dmz_dev_err(dev, "Invalid meta magic (needed 0x%08x, got 0x%08x)",
+			    DMZ_MAGIC, le32_to_cpu(sb->magic));
+		return -ENXIO;
+	}
+
+	zmd->sb_version = le32_to_cpu(sb->version);
+	if (zmd->sb_version > DMZ_META_VER) {
+		dmz_dev_err(dev, "Invalid meta version (needed %d, got %d)",
+			    DMZ_META_VER, zmd->sb_version);
+		return -EINVAL;
+	}
+	if ((zmd->sb_version < 1) && (set == 2)) {
+		dmz_dev_err(dev, "Tertiary superblocks are not supported");
+		return -EINVAL;
+	}
+
 	gen = le64_to_cpu(sb->gen);
 	stored_crc = le32_to_cpu(sb->crc);
 	sb->crc = 0;
@@ -925,18 +990,41 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
 		return -ENXIO;
 	}
 
-	if (le32_to_cpu(sb->magic) != DMZ_MAGIC) {
-		dmz_dev_err(dev, "Invalid meta magic (needed 0x%08x, got 0x%08x)",
-			    DMZ_MAGIC, le32_to_cpu(sb->magic));
-		return -ENXIO;
-	}
+	if (zmd->sb_version > 1) {
+		if (uuid_is_null((uuid_t *)sb->dmz_uuid)) {
+			dmz_dev_err(dev, "sb%d: NULL DM-Zoned uuid", set);
+			return -ENXIO;
+		} else if (uuid_is_null(&zmd->uuid)) {
+			uuid_copy(&zmd->uuid, (uuid_t *)sb->dmz_uuid);
+		} else if (!uuid_equal(&zmd->uuid, (uuid_t *)sb->dmz_uuid)) {
+			dmz_dev_err(dev, "sb%d: mismatching DM-Zoned uuid, "
+				    "is %pUl expected %pUl", set,
+				    (uuid_t *)sb->dmz_uuid, &zmd->uuid);
+			return -ENXIO;
+		}
+		if (!strlen(zmd->label))
+			memcpy(zmd->label, sb->dmz_label, BDEVNAME_SIZE);
+		else if (memcmp(zmd->label, sb->dmz_label, BDEVNAME_SIZE)) {
+			dmz_dev_err(dev, "sb%d: mismatching DM-Zoned label, "
+				    "is %s expected %s",
+				    set, sb->dmz_label, zmd->label);
+			return -ENXIO;
+		}
+		if (uuid_is_null((uuid_t *)sb->dev_uuid)) {
+			dmz_dev_err(dev, "sb%d: NULL device uuid", set);
+			return -ENXIO;
+		}
+		uuid_copy(&dev->uuid, (uuid_t *)sb->dev_uuid);
 
-	if (le32_to_cpu(sb->version) != DMZ_META_VER) {
-		dmz_dev_err(dev, "Invalid meta version (needed %d, got %d)",
-			    DMZ_META_VER, le32_to_cpu(sb->version));
-		return -ENXIO;
+		if (set == 2) {
+			if (gen != 0) {
+				dmz_dev_err(dev, "sb%d: Invalid generation %llu",
+					    set, gen);
+				return -ENXIO;
+			}
+			return 0;
+		}
 	}
-
 	nr_meta_zones = (le32_to_cpu(sb->nr_meta_blocks) + zmd->zone_nr_blocks - 1)
 		>> zmd->zone_nr_blocks_shift;
 	if (!nr_meta_zones ||
@@ -1185,21 +1273,37 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
 		      "Using super block %u (gen %llu)",
 		      zmd->mblk_primary, zmd->sb_gen);
 
+	if ((zmd->sb_version > 1) && zmd->sb[2].zone) {
+		zmd->sb[2].block = dmz_start_block(zmd, zmd->sb[2].zone);
+		zmd->sb[2].dev = dmz_zone_to_dev(zmd, zmd->sb[2].zone);
+		ret = dmz_get_sb(zmd, 2);
+		if (ret) {
+			dmz_dev_err(zmd->sb[2].dev,
+				    "Read tertiary super block failed");
+			return ret;
+		}
+		ret = dmz_check_sb(zmd, 2);
+		if (ret == -EINVAL)
+			return ret;
+	}
 	return 0;
 }
 
 /*
  * Initialize a zone descriptor.
  */
-static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
+static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
 {
 	struct dmz_metadata *zmd = data;
+	int idx = num + zmd->dev[0].zone_offset;
 	struct dm_zone *zone = &zmd->zones[idx];
-	struct dmz_dev *dev = zmd->dev;
 
-	/* Ignore the eventual last runt (smaller) zone */
 	if (blkz->len != zmd->zone_nr_sectors) {
-		if (blkz->start + blkz->len == dev->capacity)
+		if (zmd->sb_version > 1) {
+			/* Ignore the eventual runt (smaller) zone */
+			set_bit(DMZ_OFFLINE, &zone->flags);
+			return 0;
+		} else if (blkz->start + blkz->len == dev->capacity)
 			return 0;
 		return -ENXIO;
 	}
@@ -1235,10 +1339,14 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 		if (dmz_is_rnd(zone)) {
 			zmd->nr_rnd_zones++;
 			if (!zmd->sb[0].zone) {
-				/* Super block zone */
+				/* Primary super block zone */
 				zmd->sb[0].zone = zone;
 			}
 		}
+		if (zmd->dev[1].bdev && !zmd->sb[2].zone) {
+			/* Tertiary superblock zone */
+			zmd->sb[2].zone = zone;
+		}
 	}
 
 	return 0;
@@ -1259,11 +1367,10 @@ static void dmz_drop_zones(struct dmz_metadata *zmd)
  */
 static int dmz_init_zones(struct dmz_metadata *zmd)
 {
-	struct dmz_dev *dev = &zmd->dev[0];
 	int ret;
 
 	/* Init */
-	zmd->zone_nr_sectors = dev->zone_nr_sectors;
+	zmd->zone_nr_sectors = zmd->dev[0].zone_nr_sectors;
 	zmd->zone_nr_sectors_shift = ilog2(zmd->zone_nr_sectors);
 	zmd->zone_nr_blocks = dmz_sect2blk(zmd->zone_nr_sectors);
 	zmd->zone_nr_blocks_shift = ilog2(zmd->zone_nr_blocks);
@@ -1274,7 +1381,14 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 					DMZ_BLOCK_SIZE_BITS);
 
 	/* Allocate zone array */
-	zmd->nr_zones = dev->nr_zones;
+	zmd->nr_zones = zmd->dev[0].nr_zones;
+	if (zmd->dev[1].bdev)
+		zmd->nr_zones += zmd->dev[1].nr_zones;
+
+	if (!zmd->nr_zones) {
+		DMERR("(%s): No zones found", zmd->devname);
+		return -ENXIO;
+	}
 	zmd->zones = kcalloc(zmd->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
 	if (!zmd->zones)
 		return -ENOMEM;
@@ -1282,13 +1396,43 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
 	DMINFO("(%s): Using %zu B for zone information",
 	       zmd->devname, sizeof(struct dm_zone) * zmd->nr_zones);
 
+	if (zmd->dev[1].bdev) {
+		int idx;
+		sector_t zone_offset = 0;
+
+		for(idx = 0; idx < zmd->dev[1].nr_zones; idx++) {
+			struct dm_zone *zone = &zmd->zones[idx];
+
+			INIT_LIST_HEAD(&zone->link);
+			atomic_set(&zone->refcount, 0);
+			zone->id = idx;
+			zone->chunk = DMZ_MAP_UNMAPPED;
+			set_bit(DMZ_RND, &zone->flags);
+			zone->wp_block = 0;
+			zmd->nr_rnd_zones++;
+			zmd->nr_useable_zones++;
+			if (zmd->dev[1].capacity - zone_offset <
+			    zmd->zone_nr_sectors) {
+				/* Disable runt zone */
+				set_bit(DMZ_OFFLINE, &zone->flags);
+				break;
+			}
+			zone_offset += zmd->zone_nr_sectors;
+			if (!zmd->sb[0].zone) {
+				/* Primary superblock zone */
+				zmd->sb[0].zone = zone;
+			}
+		}
+		zmd->dev[0].zone_offset = zmd->dev[1].nr_zones;
+	}
+
 	/*
 	 * Get zone information and initialize zone descriptors.  At the same
 	 * time, determine where the super block should be: first block of the
 	 * first randomly writable zone.
 	 */
-	ret = blkdev_report_zones(dev->bdev, 0, BLK_ALL_ZONES, dmz_init_zone,
-				  zmd);
+	ret = blkdev_report_zones(zmd->dev[0].bdev, 0, BLK_ALL_ZONES,
+				  dmz_init_zone, zmd);
 	if (ret < 0) {
 		dmz_drop_zones(zmd);
 		return ret;
@@ -1325,6 +1469,9 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 	unsigned int noio_flag;
 	int ret;
 
+	if (dev->flags & DMZ_BDEV_REGULAR)
+		return 0;
+
 	/*
 	 * Get zone information from disk. Since blkdev_report_zones() uses
 	 * GFP_KERNEL by default for memory allocations, set the per-task
@@ -1741,7 +1888,8 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
 		/* Allocate a random zone */
 		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
 		if (!dzone) {
-			if (dmz_bdev_is_dying(zmd->dev)) {
+			if (dmz_bdev_is_dying(&zmd->dev[0]) ||
+			    dmz_bdev_is_dying(&zmd->dev[1])) {
 				dzone = ERR_PTR(-EIO);
 				goto out;
 			}
@@ -1842,7 +1990,8 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
 	/* Allocate a random zone */
 	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
 	if (!bzone) {
-		if (dmz_bdev_is_dying(zmd->dev)) {
+		if (dmz_bdev_is_dying(&zmd->dev[0]) ||
+		    dmz_bdev_is_dying(&zmd->dev[1])) {
 			bzone = ERR_PTR(-EIO);
 			goto out;
 		}
@@ -2480,18 +2629,34 @@ void dmz_print_dev(struct dmz_metadata *zmd, int num)
 {
 	struct dmz_dev *dev = &zmd->dev[num];
 
-	dmz_dev_info(dev, "Host-%s zoned block device",
-		     bdev_zoned_model(dev->bdev) == BLK_ZONED_HA ?
-		     "aware" : "managed");
-	dmz_dev_info(dev, "  %llu 512-byte logical sectors",
-		     (u64)dev->capacity);
-	dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",
-		     dev->nr_zones, (u64)zmd->zone_nr_sectors);
+	if (bdev_zoned_model(dev->bdev) == BLK_ZONED_NONE)
+		dmz_dev_info(dev, "Regular block device");
+	else
+		dmz_dev_info(dev, "Host-%s zoned block device",
+			     bdev_zoned_model(dev->bdev) == BLK_ZONED_HA ?
+			     "aware" : "managed");
+	if (zmd->sb_version > 1) {
+		sector_t sector_offset =
+			dev->zone_offset << zmd->zone_nr_sectors_shift;
+
+		dmz_dev_info(dev, "  uuid %pUl", &dev->uuid);
+		dmz_dev_info(dev, "  %llu 512-byte logical sectors (offset %llu)",
+			     (u64)dev->capacity, (u64)sector_offset);
+		dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors (offset %llu)",
+			     dev->nr_zones, (u64)zmd->zone_nr_sectors,
+			     (u64)dev->zone_offset);
+	} else {
+		dmz_dev_info(dev, "  %llu 512-byte logical sectors",
+			     (u64)dev->capacity);
+		dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",
+			     dev->nr_zones, (u64)zmd->zone_nr_sectors);
+	}
 }
 /*
  * Initialize the zoned metadata.
  */
-int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata,
+int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
+		     struct dmz_metadata **metadata,
 		     const char *devname)
 {
 	struct dmz_metadata *zmd;
@@ -2544,7 +2709,13 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata,
 			goto err;
 		set_bit(DMZ_META, &zone->flags);
 	}
-
+	if (zmd->sb[2].zone) {
+		zid = dmz_id(zmd, zmd->sb[2].zone);
+		zone = dmz_get(zmd, zid);
+		if (!zone)
+			goto err;
+		set_bit(DMZ_META, &zone->flags);
+	}
 	/* Load mapping table */
 	ret = dmz_load_mapping(zmd);
 	if (ret)
@@ -2569,8 +2740,14 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata,
 		goto err;
 	}
 
-	dmz_zmd_info(zmd, "DM-Zoned metadata version %d", DMZ_META_VER);
+	dmz_zmd_info(zmd, "DM-Zoned metadata version %d", zmd->sb_version);
+	if (zmd->sb_version > 1) {
+		dmz_zmd_info(zmd, "DM UUID %pUl", &zmd->uuid);
+		dmz_zmd_info(zmd, "DM Label %s", zmd->label);
+	}
 	dmz_print_dev(zmd, 0);
+	if (zmd->dev[1].bdev)
+		dmz_print_dev(zmd, 1);
 
 	dmz_zmd_info(zmd, "  %u zones of %llu 512-byte logical sectors",
 		     zmd->nr_zones, (u64)zmd->zone_nr_sectors);
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ccf90608f434..4cfb34b38659 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -38,7 +38,7 @@ struct dm_chunk_work {
  * Target descriptor.
  */
 struct dmz_target {
-	struct dm_dev		*ddev;
+	struct dm_dev		*ddev[2];
 
 	unsigned long		flags;
 
@@ -223,6 +223,9 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dmz_dev *dev,
 		}
 
 		if (nr_blocks) {
+			if (rzone != zone)
+				dev = dmz_zone_to_dev(zmd, rzone);
+
 			/* Valid blocks found: read them */
 			nr_blocks = min_t(unsigned int, nr_blocks, end_block - chunk_block);
 			ret = dmz_submit_bio(dmz, dev, rzone, bio,
@@ -298,6 +301,7 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
 		return -EROFS;
 
 	/* Submit write */
+	dev = dmz_zone_to_dev(zmd, bzone);
 	ret = dmz_submit_bio(dmz, dev, bzone, bio, chunk_block, nr_blocks);
 	if (ret)
 		return ret;
@@ -591,6 +595,10 @@ static int dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
  */
 bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev)
 {
+	/* Device not configured, no error */
+	if (!dmz_dev->bdev)
+		return false;
+
 	if (dmz_dev->flags & DMZ_BDEV_DYING)
 		return true;
 
@@ -698,60 +706,47 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 /*
  * Get zoned device information.
  */
-static int dmz_get_zoned_device(struct dm_target *ti, char *path)
+static int dmz_get_zoned_device(struct dm_target *ti, char *path,
+				struct dmz_dev *dev, int num)
 {
 	struct dmz_target *dmz = ti->private;
 	struct request_queue *q;
-	struct dmz_dev *dev;
-	sector_t aligned_capacity;
 	int ret;
 
 	/* Get the target device */
-	ret = dm_get_device(ti, path, dm_table_get_mode(ti->table), &dmz->ddev);
+	ret = dm_get_device(ti, path, dm_table_get_mode(ti->table),
+			    &dmz->ddev[num]);
 	if (ret) {
 		ti->error = "Get target device failed";
-		dmz->ddev = NULL;
+		dmz->ddev[num] = NULL;
 		return ret;
 	}
 
-	dev = kzalloc(sizeof(struct dmz_dev), GFP_KERNEL);
-	if (!dev) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	dev->bdev = dmz->ddev->bdev;
+	dev->bdev = dmz->ddev[num]->bdev;
 	(void)bdevname(dev->bdev, dev->name);
 
-	if (bdev_zoned_model(dev->bdev) == BLK_ZONED_NONE) {
-		ti->error = "Not a zoned block device";
-		ret = -EINVAL;
-		goto err;
-	}
+	if (bdev_zoned_model(dev->bdev) == BLK_ZONED_NONE)
+		dev->flags = DMZ_BDEV_REGULAR;
 
 	q = bdev_get_queue(dev->bdev);
 	dev->capacity = i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
-	aligned_capacity = dev->capacity &
-				~((sector_t)blk_queue_zone_sectors(q) - 1);
-	if (ti->begin ||
-	    ((ti->len != dev->capacity) && (ti->len != aligned_capacity))) {
-		ti->error = "Partial mapping not supported";
-		ret = -EINVAL;
-		goto err;
+	if (ti->begin) {
+		ti->error = "Partial mapping is not supported";
+		dm_put_device(ti, dmz->ddev[num]);
+		dmz->ddev[num] = NULL;
+		return -EINVAL;
 	}
 
-	dev->zone_nr_sectors = blk_queue_zone_sectors(q);
-
-	dev->nr_zones = blkdev_nr_zones(dev->bdev->bd_disk);
-
-	dmz->dev = dev;
-
+	if (num == 1) {
+		dev->zone_nr_sectors = dmz->dev[0].zone_nr_sectors;
+		dev->nr_zones = dev->capacity / dev->zone_nr_sectors;
+		if (dev->capacity % dev->nr_zones)
+			dev->nr_zones++;
+	} else {
+		dev->zone_nr_sectors = blk_queue_zone_sectors(q);
+		dev->nr_zones = blkdev_nr_zones(dev->bdev->bd_disk);
+	}
 	return 0;
-err:
-	dm_put_device(ti, dmz->ddev);
-	kfree(dev);
-
-	return ret;
 }
 
 /*
@@ -761,9 +756,12 @@ static void dmz_put_zoned_device(struct dm_target *ti)
 {
 	struct dmz_target *dmz = ti->private;
 
-	dm_put_device(ti, dmz->ddev);
-	kfree(dmz->dev);
-	dmz->dev = NULL;
+	if (dmz->ddev[1]) {
+		dm_put_device(ti, dmz->ddev[1]);
+		dmz->ddev[1] = NULL;
+	}
+	dm_put_device(ti, dmz->ddev[0]);
+	dmz->ddev[0] = NULL;
 }
 
 /*
@@ -772,11 +770,10 @@ static void dmz_put_zoned_device(struct dm_target *ti)
 static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dmz_target *dmz;
-	struct dmz_dev *dev;
 	int ret;
 
 	/* Check arguments */
-	if (argc != 1) {
+	if (argc < 1 || argc > 2) {
 		ti->error = "Invalid argument count";
 		return -EINVAL;
 	}
@@ -787,18 +784,29 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Unable to allocate the zoned target descriptor";
 		return -ENOMEM;
 	}
+	dmz->dev = kcalloc(2, sizeof(struct dmz_dev), GFP_KERNEL);
+	if (!dmz->dev) {
+		ti->error = "Unable to allocate the zoned device descriptors";
+		kfree(dmz);
+		return -ENOMEM;
+	}
 	ti->private = dmz;
 
 	/* Get the target zoned block device */
-	ret = dmz_get_zoned_device(ti, argv[0]);
-	if (ret) {
-		dmz->ddev = NULL;
+	ret = dmz_get_zoned_device(ti, argv[0], &dmz->dev[0], 0);
+	if (ret)
 		goto err;
+
+	if (argc == 2) {
+		ret = dmz_get_zoned_device(ti, argv[1], &dmz->dev[1], 1);
+		if (ret) {
+			dmz_put_zoned_device(ti);
+			goto err;
+		}
 	}
 
 	/* Initialize metadata */
-	dev = dmz->dev;
-	ret = dmz_ctr_metadata(dev, &dmz->metadata,
+	ret = dmz_ctr_metadata(dmz->dev, argc, &dmz->metadata,
 			       dm_table_device_name(ti->table));
 	if (ret) {
 		ti->error = "Metadata initialization failed";
@@ -875,6 +883,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 err_dev:
 	dmz_put_zoned_device(ti);
 err:
+	kfree(dmz->dev);
 	kfree(dmz);
 
 	return ret;
@@ -905,6 +914,7 @@ static void dmz_dtr(struct dm_target *ti)
 
 	mutex_destroy(&dmz->chunk_lock);
 
+	kfree(dmz->dev);
 	kfree(dmz);
 }
 
@@ -979,10 +989,17 @@ static int dmz_iterate_devices(struct dm_target *ti,
 			       iterate_devices_callout_fn fn, void *data)
 {
 	struct dmz_target *dmz = ti->private;
-	struct dmz_dev *dev = dmz->dev;
-	sector_t capacity = dev->capacity & ~(dmz_zone_nr_sectors(dmz->metadata) - 1);
-
-	return fn(ti, dmz->ddev, 0, capacity, data);
+	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
+	sector_t capacity;
+	int r;
+
+	capacity = dmz->dev[0].capacity & ~(zone_nr_sectors - 1);
+	r = fn(ti, dmz->ddev[0], 0, capacity, data);
+	if (!r && dmz->ddev[1]) {
+		capacity = dmz->dev[1].capacity & ~(zone_nr_sectors - 1);
+		r = fn(ti, dmz->ddev[1], 0, capacity, data);
+	}
+	return r;
 }
 
 static void dmz_status(struct dm_target *ti, status_type_t type,
@@ -992,6 +1009,7 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
 	struct dmz_target *dmz = ti->private;
 	ssize_t sz = 0;
 	char buf[BDEVNAME_SIZE];
+	struct dmz_dev *dev;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1005,8 +1023,14 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
 		       dmz_nr_seq_zones(dmz->metadata));
 		break;
 	case STATUSTYPE_TABLE:
-		format_dev_t(buf, dmz->dev->bdev->bd_dev);
+		dev = &dmz->dev[0];
+		format_dev_t(buf, dev->bdev->bd_dev);
 		DMEMIT("%s ", buf);
+		if (dmz->dev[1].bdev) {
+			dev = &dmz->dev[1];
+			format_dev_t(buf, dev->bdev->bd_dev);
+			DMEMIT("%s ", buf);
+		}
 		break;
 	}
 	return;
@@ -1028,7 +1052,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
 
 static struct target_type dmz_type = {
 	.name		 = "zoned",
-	.version	 = {1, 1, 0},
+	.version	 = {1, 2, 0},
 	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
 	.module		 = THIS_MODULE,
 	.ctr		 = dmz_ctr,
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 808ffbef0da3..6eb37b639f24 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -52,10 +52,12 @@ struct dmz_dev {
 	struct block_device	*bdev;
 
 	char			name[BDEVNAME_SIZE];
+	uuid_t			uuid;
 
 	sector_t		capacity;
 
 	unsigned int		nr_zones;
+	unsigned int		zone_offset;
 
 	unsigned int		flags;
 
@@ -69,6 +71,7 @@ struct dmz_dev {
 /* Device flags. */
 #define DMZ_BDEV_DYING		(1 << 0)
 #define DMZ_CHECK_BDEV		(2 << 0)
+#define DMZ_BDEV_REGULAR	(4 << 0)
 
 /*
  * Zone descriptor.
@@ -163,8 +166,8 @@ struct dmz_reclaim;
 /*
  * Functions defined in dm-zoned-metadata.c
  */
-int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **zmd,
-		     const char *devname);
+int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
+		     struct dmz_metadata **zmd, const char *devname);
 void dmz_dtr_metadata(struct dmz_metadata *zmd);
 int dmz_resume_metadata(struct dmz_metadata *zmd);
 
-- 
2.25.0
