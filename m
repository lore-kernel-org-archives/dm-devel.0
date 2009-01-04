From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] DM Block integrity support
Date: Sun, 04 Jan 2009 03:01:24 -0500
Message-ID: <yq1aba75wkr.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, jens.axboe@oracle.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


This patch provides support for data integrity passthrough in the device
mapper.

 - If one or more component devices support integrity an integrity
   profile is preallocated for the DM device.

 - If all component devices have compatible profiles the DM device is
   flagged as capable.

 - Handle integrity metadata when splitting and cloning bios.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1048,6 +1048,19 @@ static int populate_table(struct dm_tabl
 	return dm_table_complete(table);
 }
 
+static int table_prealloc_integrity(struct dm_table *t, struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *ddi;
+
+	list_for_each_entry(ddi, devices, list) {
+		if (bdev_get_integrity(ddi->dm_dev.bdev))
+			return blk_integrity_register(dm_disk(md), NULL);
+	}
+
+	return 0;
+}
+
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1065,6 +1078,14 @@ static int table_load(struct dm_ioctl *p
 
 	r = populate_table(t, param, param_size);
 	if (r) {
+		dm_table_put(t);
+		goto out;
+	}
+
+	r = table_prealloc_integrity(t, md);
+	if (r) {
+		DMERR("could not register integrity profile for %s.",
+		      dm_disk(md)->disk_name);
 		dm_table_put(t);
 		goto out;
 	}
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -865,7 +865,43 @@ void dm_table_set_restrictions(struct dm
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
+}
 
+void dm_table_set_integrity(struct dm_table *t, struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *prev, *cur;
+
+	/*
+	 * Run through all devices to ensure they have matching
+	 * integrity profile
+	 */
+	cur = prev = NULL;
+
+	list_for_each_entry(cur, devices, list) {
+
+		if (prev &&
+		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
+					  cur->dm_dev.bdev->bd_disk) < 0) {
+			printk(KERN_ERR "%s: %s %s integrity mismatch!\n",
+			       __func__, prev->dm_dev.bdev->bd_disk->disk_name,
+			       cur->dm_dev.bdev->bd_disk->disk_name);
+			return;
+		}
+		prev = cur;
+	}
+
+	if (!prev || !bdev_get_integrity(prev->dm_dev.bdev))
+		return;
+
+	/* Register dm device as being integrity capable */
+	if (blk_integrity_register(dm_disk(md),
+				   bdev_get_integrity(prev->dm_dev.bdev)))
+		printk(KERN_ERR "%s: %s Could not register integrity!\n",
+		       __func__, dm_disk(md)->disk_name);
+	else
+		printk(KERN_INFO "Enabling data integrity on %s\n",
+		       dm_disk(md)->disk_name);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -661,6 +661,12 @@ static struct bio *split_bvec(struct bio
 	clone->bi_io_vec->bv_len = clone->bi_size;
 	clone->bi_flags |= 1 << BIO_CLONED;
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_trim(clone,
+				   bio_sector_offset(bio, idx, offset), len);
+	}
+
 	return clone;
 }
 
@@ -681,6 +687,14 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_vcnt = idx + bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone,
+					   bio_sector_offset(bio, idx, 0), len);
+	}
 
 	return clone;
 }
@@ -1160,6 +1174,7 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
@@ -1225,6 +1240,7 @@ static int __bind(struct mapped_device *
 	write_lock(&md->map_lock);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
+	dm_table_set_integrity(t, md);
 	write_unlock(&md->map_lock);
 
 	return 0;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -41,6 +41,7 @@ struct dm_target *dm_table_get_target(st
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q);
+void dm_table_set_integrity(struct dm_table *t, struct mapped_device *md);
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
