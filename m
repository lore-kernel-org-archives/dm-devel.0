From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] dm: Data integrity support
Date: Mon, 09 Mar 2009 23:46:05 -0400
Message-ID: <yq1sklm9h1e.fsf@sermon.lab.mkp.net>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, jens.axboe@oracle.com
Cc: device-mapper development <dm-devel@redhat.com>
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

This patch requires a change in Jens' for-linus branch that adds a GFP
mask to bio_integrity_clone() and obsoletes the bio_set argument.


diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1046,6 +1046,19 @@ static int populate_table(struct dm_tabl
 	return dm_table_complete(table);
 }
 
+static int table_prealloc_integrity(struct dm_table *t,
+				    struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *dd;
+
+	list_for_each_entry(dd, devices, list)
+		if (bdev_get_integrity(dd->dm_dev.bdev))
+			return blk_integrity_register(dm_disk(md), NULL);
+
+	return 0;
+}
+
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
@@ -1067,6 +1080,14 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	r = table_prealloc_integrity(t, md);
+	if (r) {
+		DMERR("%s: could not register integrity profile.",
+		      dm_device_name(md));
+		dm_table_destroy(t);
+		goto out;
+	}
+
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -877,6 +877,45 @@ struct dm_target *dm_table_find_target(s
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
+/*
+ * Set the integrity profile for this device if all devices used have
+ * matching profiles.
+ */
+static void dm_table_set_integrity(struct dm_table *t)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *prev = NULL, *dd = NULL;
+
+	if (!blk_get_integrity(dm_disk(t->md)))
+		return;
+
+	list_for_each_entry(dd, devices, list) {
+		if (prev &&
+		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
+					  dd->dm_dev.bdev->bd_disk) < 0) {
+			DMWARN("%s: integrity not set: %s and %s mismatch",
+			       dm_device_name(t->md),
+			       prev->dm_dev.bdev->bd_disk->disk_name,
+			       dd->dm_dev.bdev->bd_disk->disk_name);
+			goto no_integrity;
+		}
+		prev = dd;
+	}
+
+	if (!prev || !bdev_get_integrity(prev->dm_dev.bdev))
+		goto no_integrity;
+
+	blk_integrity_register(dm_disk(t->md),
+			       bdev_get_integrity(prev->dm_dev.bdev));
+
+	return;
+
+no_integrity:
+	blk_integrity_register(dm_disk(t->md), NULL);
+
+	return;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
@@ -897,6 +936,7 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	dm_table_set_integrity(t);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -703,6 +703,12 @@ static struct bio *split_bvec(struct bio
 	clone->bi_io_vec->bv_len = clone->bi_size;
 	clone->bi_flags |= 1 << BIO_CLONED;
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, GFP_NOIO);
+		bio_integrity_trim(clone,
+				   bio_sector_offset(bio, idx, offset), len);
+	}
+
 	return clone;
 }
 
@@ -724,6 +730,14 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, GFP_NOIO);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone,
+					   bio_sector_offset(bio, idx, 0), len);
+	}
+
 	return clone;
 }
 
@@ -1191,6 +1205,7 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
