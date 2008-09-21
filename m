From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] dm: Add support for data integrity to DM
Date: Sat, 20 Sep 2008 20:16:21 -0400
Message-ID: <yq13ajunyju.fsf@sermon.lab.mkp.net>
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
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


If all subdevices support the same protection format the DM device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/dm-table.c         |   35 ++++++++++++++++++++++++++++++++++-
 drivers/md/dm.c               |   26 ++++++++++++++++++++++++--
 drivers/md/dm.h               |    2 +-
 include/linux/device-mapper.h |    1 +
 4 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 61f4414..006a10e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -841,8 +841,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
 	return &t->targets[(KEYS_PER_NODE * n) + k];
 }
 
-void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
+void dm_table_set_restrictions(struct dm_table *t, struct mapped_device *md)
 {
+	struct request_queue *q = dm_queue(md);
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev *prev, *cur;
+
 	/*
 	 * Make sure we obey the optimistic sub devices
 	 * restrictions.
@@ -861,6 +865,35 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	/*
+	 * Run through all devices to ensure they have matching
+	 * integrity profile
+	 */
+	cur = prev = NULL;
+
+	list_for_each_entry(cur, devices, list) {
+
+		if (prev && blk_integrity_compare(prev->bdev, cur->bdev) < 0) {
+			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
+			       __func__, prev->bdev->bd_disk->disk_name,
+			       cur->bdev->bd_disk->disk_name);
+			return;
+		}
+		prev = cur;
+	}
+
+	/* Register dm device as being integrity capable */
+	if (prev && bdev_get_integrity(prev->bdev)) {
+		struct gendisk *disk = dm_disk(md);
+
+		if (blk_integrity_register(dm_disk(md), 
+					   bdev_get_integrity(prev->bdev)))
+			printk(KERN_ERR "%s: %s Could not register integrity!\n",
+			       __func__, disk->disk_name);
+		else
+			printk(KERN_INFO "Enabling data integrity on %s\n",
+			       disk->disk_name);
+	}
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8d40369..e3d14b0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -669,6 +669,12 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_flags |= 1 << BIO_CLONED;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+		bio_integrity_trim(clone, bio_sector_offset(bio, idx, offset), len);
+	}
 
 	return clone;
 }
@@ -691,6 +697,13 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone, bio_sector_offset(bio, idx, 0), len);
+	}
+
 	return clone;
 }
 
@@ -1108,6 +1121,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+	printk(KERN_ERR "DM: Created %s\n", md->disk->disk_name);
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
@@ -1157,6 +1171,7 @@ static void free_dev(struct mapped_device *md)
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
@@ -1200,7 +1215,6 @@ static void __set_size(struct mapped_device *md, sector_t size)
 
 static int __bind(struct mapped_device *md, struct dm_table *t)
 {
-	struct request_queue *q = md->queue;
 	sector_t size;
 
 	size = dm_table_get_size(t);
@@ -1221,7 +1235,7 @@ static int __bind(struct mapped_device *md, struct dm_table *t)
 
 	write_lock(&md->map_lock);
 	md->map = t;
-	dm_table_set_restrictions(t, q);
+	dm_table_set_restrictions(t, md);
 	write_unlock(&md->map_lock);
 
 	return 0;
@@ -1674,9 +1688,17 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
  */
 struct gendisk *dm_disk(struct mapped_device *md)
 {
+	BUG_ON(md == NULL);
+	BUG_ON(md->disk == NULL);
+
 	return md->disk;
 }
 
+struct request_queue *dm_queue(struct mapped_device *md)
+{
+	return md->queue;
+}
+
 int dm_suspended(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 1e59a0b..907795f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -43,7 +43,7 @@ void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
-void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q);
+void dm_table_set_restrictions(struct dm_table *t, struct mapped_device *md);
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a90222e..5cf3a89 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -200,6 +200,7 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist);
 const char *dm_device_name(struct mapped_device *md);
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
+struct request_queue *dm_queue(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 
-- 
1.5.5.1
