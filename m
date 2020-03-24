From: Bob Liu <bob.liu@oracle.com>
Subject: [RFC PATCH v2 2/3] dm zoned: introduce regular device to dm-zoned-target
Date: Tue, 24 Mar 2020 19:02:54 +0800
Message-ID: <20200324110255.8385-3-bob.liu@oracle.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200324110255.8385-1-bob.liu@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, Dmitry.Fomichev@wdc.com, hare@suse.de, Bob Liu <bob.liu@oracle.com>
List-Id: dm-devel.ids

Introduce a regular device for storing metadata and buffer write, zoned
device is used by default if no regular device was set by dmsetup.

The corresponding dmsetup cmd is:
echo "0 $size zoned $regular_device $zoned_device" | dmsetup create $dm-zoned-name

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/md/dm-zoned-target.c | 141 +++++++++++++++++++++++++------------------
 drivers/md/dm-zoned.h        |  50 +++++++++++++--
 2 files changed, 127 insertions(+), 64 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 28f4d00..cae4bfe 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -35,38 +35,6 @@ struct dm_chunk_work {
 };
 
 /*
- * Target descriptor.
- */
-struct dmz_target {
-	struct dm_dev		*ddev;
-
-	unsigned long		flags;
-
-	/* Zoned block device information */
-	struct dmz_dev		*zoned_dev;
-
-	/* For metadata handling */
-	struct dmz_metadata     *metadata;
-
-	/* For reclaim */
-	struct dmz_reclaim	*reclaim;
-
-	/* For chunk work */
-	struct radix_tree_root	chunk_rxtree;
-	struct workqueue_struct *chunk_wq;
-	struct mutex		chunk_lock;
-
-	/* For cloned BIOs to zones */
-	struct bio_set		bio_set;
-
-	/* For flush */
-	spinlock_t		flush_lock;
-	struct bio_list		flush_list;
-	struct delayed_work	flush_work;
-	struct workqueue_struct *flush_wq;
-};
-
-/*
  * Flush intervals (seconds).
  */
 #define DMZ_FLUSH_PERIOD	(10 * HZ)
@@ -679,7 +647,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 /*
  * Get zoned device information.
  */
-static int dmz_get_zoned_device(struct dm_target *ti, char *path)
+static int dmz_get_device(struct dm_target *ti, char *path, bool zoned)
 {
 	struct dmz_target *dmz = ti->private;
 	struct request_queue *q;
@@ -688,11 +656,22 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
 	int ret;
 
 	/* Get the target device */
-	ret = dm_get_device(ti, path, dm_table_get_mode(ti->table), &dmz->ddev);
-	if (ret) {
-		ti->error = "Get target device failed";
-		dmz->ddev = NULL;
-		return ret;
+	if (zoned) {
+		ret = dm_get_device(ti, path, dm_table_get_mode(ti->table),
+				&dmz->ddev);
+		if (ret) {
+			ti->error = "Get target device failed";
+			dmz->ddev = NULL;
+			return ret;
+		}
+	} else {
+		ret = dm_get_device(ti, path, dm_table_get_mode(ti->table),
+				&dmz->regu_dm_dev);
+		if (ret) {
+			ti->error = "Get target device failed";
+			dmz->regu_dm_dev = NULL;
+			return ret;
+		}
 	}
 
 	dev = kzalloc(sizeof(struct dmz_dev), GFP_KERNEL);
@@ -701,39 +680,61 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
 		goto err;
 	}
 
-	dev->bdev = dmz->ddev->bdev;
-	(void)bdevname(dev->bdev, dev->name);
-
-	if (bdev_zoned_model(dev->bdev) == BLK_ZONED_NONE) {
-		ti->error = "Not a zoned block device";
-		ret = -EINVAL;
-		goto err;
+	if (zoned) {
+		dev->bdev = dmz->ddev->bdev;
+		if (bdev_zoned_model(dev->bdev) == BLK_ZONED_NONE) {
+			ti->error = "Not a zoned block device";
+			ret = -EINVAL;
+			goto err;
+		}
 	}
+	else
+		dev->bdev = dmz->regu_dm_dev->bdev;
+
+	(void)bdevname(dev->bdev, dev->name);
+	dev->target = dmz;
 
 	q = bdev_get_queue(dev->bdev);
 	dev->capacity = i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;
 	aligned_capacity = dev->capacity &
 				~((sector_t)blk_queue_zone_sectors(q) - 1);
-	if (ti->begin ||
-	    ((ti->len != dev->capacity) && (ti->len != aligned_capacity))) {
-		ti->error = "Partial mapping not supported";
-		ret = -EINVAL;
-		goto err;
-	}
 
-	dev->zone_nr_sectors = blk_queue_zone_sectors(q);
-	dev->zone_nr_sectors_shift = ilog2(dev->zone_nr_sectors);
+	if (zoned) {
+		if (ti->begin || ((ti->len != dev->capacity) &&
+					(ti->len != aligned_capacity))) {
+			ti->error = "Partial mapping not supported";
+			ret = -EINVAL;
+			goto err;
+		}
+		dev->zone_nr_sectors = blk_queue_zone_sectors(q);
+		dev->zone_nr_sectors_shift = ilog2(dev->zone_nr_sectors);
+
+		dev->zone_nr_blocks = dmz_sect2blk(dev->zone_nr_sectors);
+		dev->zone_nr_blocks_shift = ilog2(dev->zone_nr_blocks);
 
-	dev->zone_nr_blocks = dmz_sect2blk(dev->zone_nr_sectors);
-	dev->zone_nr_blocks_shift = ilog2(dev->zone_nr_blocks);
+		dev->nr_zones = blkdev_nr_zones(dev->bdev->bd_disk);
 
-	dev->nr_zones = blkdev_nr_zones(dev->bdev->bd_disk);
+		dmz->zoned_dev = dev;
+	} else {
+		/* Emulate regular device zone info by using the same zone size.*/
+		dev->zone_nr_sectors = dmz->zoned_dev->zone_nr_sectors;
+		dev->zone_nr_sectors_shift = ilog2(dev->zone_nr_sectors);
 
-	dmz->zoned_dev = dev;
+		dev->zone_nr_blocks = dmz_sect2blk(dev->zone_nr_sectors);
+		dev->zone_nr_blocks_shift = ilog2(dev->zone_nr_blocks);
+
+		dev->nr_zones = (get_capacity(dev->bdev->bd_disk) >>
+				ilog2(dev->zone_nr_sectors));
+
+		dmz->regu_dmz_dev = dev;
+	}
 
 	return 0;
 err:
-	dm_put_device(ti, dmz->ddev);
+	if (zoned)
+		dm_put_device(ti, dmz->ddev);
+	else
+		dm_put_device(ti, dmz->regu_dm_dev);
 	kfree(dev);
 
 	return ret;
@@ -746,6 +747,12 @@ static void dmz_put_zoned_device(struct dm_target *ti)
 {
 	struct dmz_target *dmz = ti->private;
 
+	if (dmz->regu_dm_dev)
+		dm_put_device(ti, dmz->regu_dm_dev);
+	if (dmz->regu_dmz_dev) {
+		kfree(dmz->regu_dmz_dev);
+		dmz->regu_dmz_dev = NULL;
+	}
 	dm_put_device(ti, dmz->ddev);
 	kfree(dmz->zoned_dev);
 	dmz->zoned_dev = NULL;
@@ -761,7 +768,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int ret;
 
 	/* Check arguments */
-	if (argc != 1) {
+	if ((argc != 1) && (argc != 2)) {
 		ti->error = "Invalid argument count";
 		return -EINVAL;
 	}
@@ -775,12 +782,25 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->private = dmz;
 
 	/* Get the target zoned block device */
-	ret = dmz_get_zoned_device(ti, argv[0]);
+	ret = dmz_get_device(ti, argv[0], 1);
 	if (ret) {
 		dmz->ddev = NULL;
 		goto err;
 	}
 
+	snprintf(dmz->name, BDEVNAME_SIZE, "%s", dmz->zoned_dev->name);
+	dmz->nr_zones = dmz->zoned_dev->nr_zones;
+	if (argc == 2) {
+		ret = dmz_get_device(ti, argv[1], 0);
+		if (ret) {
+			dmz->regu_dm_dev = NULL;
+			goto err;
+		}
+		snprintf(dmz->name, BDEVNAME_SIZE * 2, "%s:%s",
+				dmz->zoned_dev->name, dmz->regu_dmz_dev->name);
+		dmz->nr_zones += dmz->regu_dmz_dev->nr_zones;
+	}
+
 	/* Initialize metadata */
 	dev = dmz->zoned_dev;
 	ret = dmz_ctr_metadata(dev, &dmz->metadata);
@@ -962,6 +982,7 @@ static int dmz_iterate_devices(struct dm_target *ti,
 	struct dmz_dev *dev = dmz->zoned_dev;
 	sector_t capacity = dev->capacity & ~(dev->zone_nr_sectors - 1);
 
+	/* Todo: fn(dmz->regu_dm_dev) */
 	return fn(ti, dmz->ddev, 0, capacity, data);
 }
 
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 5b5e493..a3535bc 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -46,9 +46,51 @@
 #define dmz_bio_blocks(bio)	dmz_sect2blk(bio_sectors(bio))
 
 /*
+ * Target descriptor.
+ */
+struct dmz_target {
+	struct dm_dev		*ddev;
+	/*
+	 * Regular device for store metdata and buffer write, use zoned device
+	 * by default if no regular device was set.
+	 */
+	struct dm_dev           *regu_dm_dev;
+	struct dmz_dev          *regu_dmz_dev;
+	/* Total nr_zones. */
+	unsigned int            nr_zones;
+	char                    name[BDEVNAME_SIZE * 2];
+
+	unsigned long		flags;
+
+	/* Zoned block device information */
+	struct dmz_dev		*zoned_dev;
+
+	/* For metadata handling */
+	struct dmz_metadata     *metadata;
+
+	/* For reclaim */
+	struct dmz_reclaim	*reclaim;
+
+	/* For chunk work */
+	struct radix_tree_root	chunk_rxtree;
+	struct workqueue_struct *chunk_wq;
+	struct mutex		chunk_lock;
+
+	/* For cloned BIOs to zones */
+	struct bio_set		bio_set;
+
+	/* For flush */
+	spinlock_t		flush_lock;
+	struct bio_list		flush_list;
+	struct delayed_work	flush_work;
+	struct workqueue_struct *flush_wq;
+};
+
+/*
  * Zoned block device information.
  */
 struct dmz_dev {
+	struct dmz_target       *target;
 	struct block_device	*bdev;
 
 	char			name[BDEVNAME_SIZE];
@@ -147,16 +189,16 @@ enum {
  * Message functions.
  */
 #define dmz_dev_info(dev, format, args...)	\
-	DMINFO("(%s): " format, (dev)->name, ## args)
+	DMINFO("(%s): " format, (dev)->target->name, ## args)
 
 #define dmz_dev_err(dev, format, args...)	\
-	DMERR("(%s): " format, (dev)->name, ## args)
+	DMERR("(%s): " format, (dev)->target->name, ## args)
 
 #define dmz_dev_warn(dev, format, args...)	\
-	DMWARN("(%s): " format, (dev)->name, ## args)
+	DMWARN("(%s): " format, (dev)->target->name, ## args)
 
 #define dmz_dev_debug(dev, format, args...)	\
-	DMDEBUG("(%s): " format, (dev)->name, ## args)
+	DMDEBUG("(%s): " format, (dev)->target->name, ## args)
 
 struct dmz_metadata;
 struct dmz_reclaim;
-- 
2.9.5
