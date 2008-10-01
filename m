From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6/7] dm: Add support for data integrity to DM
Date: Wed,  1 Oct 2008 03:38:42 -0400
Message-ID: <1222846723-18213-7-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

If all subdevices support the same protection format the DM device is
flagged as capable.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/dm-table.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |   17 +++++++++++++++++
 drivers/md/dm.h       |    1 +
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 61f4414..f089404 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -860,7 +860,43 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
+}
+
+void dm_table_set_integrity(struct dm_table *t, struct mapped_device *md)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev *prev, *cur;
+
+	/*
+	 * Run through all devices to ensure they have matching
+	 * integrity profile
+	 */
+	cur = prev = NULL;
+
+	list_for_each_entry(cur, devices, list) {
+
+		if (prev && blk_integrity_compare(prev->bdev->bd_disk,
+						  cur->bdev->bd_disk) < 0) {
+			printk(KERN_ERR "%s: %s %s Integrity mismatch!\n",
+			       __func__, prev->bdev->bd_disk->disk_name,
+			       cur->bdev->bd_disk->disk_name);
+			return;
+		}
+		prev = cur;
+	}
 
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
index 8d40369..4f65342 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -669,6 +669,13 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
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
@@ -691,6 +698,14 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
+	if (bio_integrity(bio)) {
+		bio_integrity_clone(clone, bio, bs);
+
+		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
+			bio_integrity_trim(clone,
+					   bio_sector_offset(bio, idx, 0), len);
+	}
+
 	return clone;
 }
 
@@ -1157,6 +1172,7 @@ static void free_dev(struct mapped_device *md)
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	bioset_free(md->bs);
+	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
@@ -1222,6 +1238,7 @@ static int __bind(struct mapped_device *md, struct dm_table *t)
 	write_lock(&md->map_lock);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
+	dm_table_set_integrity(t, md);
 	write_unlock(&md->map_lock);
 
 	return 0;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 1e59a0b..cf34b99 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -44,6 +44,7 @@ void dm_table_event_callback(struct dm_table *t,
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q);
+void dm_table_set_integrity(struct dm_table *t, struct mapped_device *md);
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
-- 
1.6.0.2
