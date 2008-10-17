From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] DM data integrity support
Date: Fri, 17 Oct 2008 10:47:00 -0400
Message-ID: <yq1k5c7mg7v.fsf@sermon.lab.mkp.net>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Add support for data integrity to DM.

If all subdevices support the same protection format the DM device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -874,7 +874,43 @@ void dm_table_set_restrictions(struct dm
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
@@ -669,6 +669,13 @@ static struct bio *split_bvec(struct bio
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_flags |= 1 << BIO_CLONED;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_trim(clone,
+				   bio_sector_offset(bio, idx, offset), len);
+	}
 
 	return clone;
 }
@@ -690,6 +697,14 @@ static struct bio *clone_bio(struct bio 
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
@@ -1161,6 +1176,7 @@ static void free_dev(struct mapped_devic
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
@@ -1226,6 +1242,7 @@ static int __bind(struct mapped_device *
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
