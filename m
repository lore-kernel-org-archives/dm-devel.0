From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v4 3/4] block: allow gendisk's request_queue registration to be deferred
Date: Thu, 11 Jan 2018 15:14:16 -0500
Message-ID: <20180111201417.2042-4-snitzer@redhat.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111201417.2042-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Since I can remember DM has forced the block layer to allow the
allocation and initialization of the request_queue to be distinct
operations.  Reason for this is block/genhd.c:add_disk() has requires
that the request_queue (and associated bdi) be tied to the gendisk
before add_disk() is called -- because add_disk() also deals with
exposing the request_queue via blk_register_queue().

DM's dynamic creation of arbitrary device types (and associated
request_queue types) requires the DM device's gendisk be available so
that DM table loads can establish a master/slave relationship with
subordinate devices that are referenced by loaded DM tables -- using
bd_link_disk_holder().  But until these DM tables, and their associated
subordinate devices, are known DM cannot know what type of request_queue
it needs -- nor what its queue_limits should be.

This chicken and egg scenario has created all manner of problems for DM
and, at times, the block layer.

Summary of changes:

- Add blk_add_disk_no_queue_reg() and add_disk_no_queue_reg() variant
  that drivers may use to add a disk without also calling
  blk_register_queue().  Driver must call blk_register_queue() once its
  request_queue is fully initialized.

- Return early from blk_unregister_queue() if QUEUE_FLAG_REGISTERED
  is not set.  It won't be set if driver used add_disk_no_queue_reg()
  but driver encounters an error and must del_gendisk() before calling
  blk_register_queue().

- Export blk_register_queue().

These changes allow DM to use add_disk_no_queue_reg() to anchor its
gendisk as the "master" for master/slave relationships DM must establish
with subordinate devices referenced in DM tables that get loaded.  Once
all "slave" devices for a DM device are known its request_queue can be
properly initialized and then advertised via sysfs -- important
improvement being that no request_queue resource initialization
performed by blk_register_queue() is missed for DM devices anymore.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-sysfs.c     |  8 ++++++--
 block/genhd.c         | 20 +++++++++++++++++---
 include/linux/genhd.h |  5 +++++
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 52f57539f1c7..90de6337cc4d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -921,6 +921,7 @@ int blk_register_queue(struct gendisk *disk)
 	mutex_unlock(&q->sysfs_lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_register_queue);
 
 void blk_unregister_queue(struct gendisk *disk)
 {
@@ -930,12 +931,15 @@ void blk_unregister_queue(struct gendisk *disk)
 		return;
 
 	spin_lock_irq(q->queue_lock);
-	queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
+	if (!queue_flag_test_and_clear(QUEUE_FLAG_REGISTERED, q)) {
+		/* Return early if disk->queue was never registered. */
+		spin_unlock_irq(q->queue_lock);
+		return;
+	}
 	spin_unlock_irq(q->queue_lock);
 
 	wbt_exit(q);
 
-
 	if (q->mq_ops)
 		blk_mq_unregister_dev(disk_to_dev(disk), q);
 
diff --git a/block/genhd.c b/block/genhd.c
index 00620e01e043..d4aaf0cae9ad 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -629,7 +629,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
 }
 
 /**
- * device_add_disk - add partitioning information to kernel list
+ * device_add_disk_no_queue_reg - add partitioning information to kernel list
  * @parent: parent device for the disk
  * @disk: per-device partitioning information
  *
@@ -638,7 +638,7 @@ static void register_disk(struct device *parent, struct gendisk *disk)
  *
  * FIXME: error handling
  */
-void device_add_disk(struct device *parent, struct gendisk *disk)
+void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk)
 {
 	dev_t devt;
 	int retval;
@@ -682,7 +682,6 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 				    exact_match, exact_lock, disk);
 	}
 	register_disk(parent, disk);
-	blk_register_queue(disk);
 
 	/*
 	 * Take an extra ref on queue which will be put on disk_release()
@@ -693,6 +692,21 @@ void device_add_disk(struct device *parent, struct gendisk *disk)
 	disk_add_events(disk);
 	blk_integrity_add(disk);
 }
+EXPORT_SYMBOL(device_add_disk_no_queue_reg);
+
+/**
+ * device_add_disk - add disk information to kernel list
+ * @parent: parent device for the disk
+ * @disk: per-device disk information
+ *
+ * Adds partitioning information and also registers the
+ * associated request_queue to @disk.
+ */
+void device_add_disk(struct device *parent, struct gendisk *disk)
+{
+	device_add_disk_no_queue_reg(parent, disk);
+	blk_register_queue(disk);
+}
 EXPORT_SYMBOL(device_add_disk);
 
 void del_gendisk(struct gendisk *disk)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5144ebe046c9..5e3531027b51 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -395,6 +395,11 @@ static inline void add_disk(struct gendisk *disk)
 {
 	device_add_disk(NULL, disk);
 }
+extern void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk);
+static inline void add_disk_no_queue_reg(struct gendisk *disk)
+{
+	device_add_disk_no_queue_reg(NULL, disk);
+}
 
 extern void del_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
-- 
2.15.0
