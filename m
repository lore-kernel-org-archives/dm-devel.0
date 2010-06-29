From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 2/2 "v12"] dm: only initialize full
	request_queue for request-based device
Date: Tue, 29 Jun 2010 13:40:23 -0400
Message-ID: <1277833223-4618-2-git-send-email-snitzer@redhat.com>
References: <1277833223-4618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1277833223-4618-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

A bio-based DM device no longer defaults to having a fully initialized
request_queue (request_fn, elevator, etc).  This means bio-based DM
devices no longer register elevator sysfs attributes ('iosched/' tree
or 'scheduler' other than "none").

In contrast, a request-based DM device will always have a full
request_queue and will register elevator sysfs attributes.  Therefore
a user can determine a DM device's type by checking if elevator sysfs
attributes exist.

First allocate a minimalist request_queue structure for a DM device
(needed for both bio and request-based DM).

Initialization of a full request_queue is deferred until it is known
that the DM device is request-based -- at the end of the table load
sequence.

Factor DM device's request_queue initialization:
- common to both request-based and bio-based into dm_init_md_queue().
- specific to request-based into dm_init_request_based_queue().

The md->type_lock mutex is used to protect md->queue, in addition to
md->type, during table_load().

A DM device's first table_load will establish the immutable md->type.
But md->queue initialization, based on md->type, may fail at that time
(because blk_init_allocated_queue cannot allocate memory).  Therefore
any subsequent table_load must (re)try dm_setup_md_queue independent of
establishing md->type.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
v5: revised patch header, no code changes

 drivers/md/dm-ioctl.c |   11 +++++
 drivers/md/dm.c       |   94 ++++++++++++++++++++++++++++++++++++--------------
 drivers/md/dm.h       |    2 +
 3 files changed, 80 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1176,7 +1176,7 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
-	/* Protect md->type against concurrent table loads. */
+	/* Protect md->type and md->queue against concurrent table loads. */
 	dm_lock_md_type(md);
 	if (dm_get_md_type(md) == DM_TYPE_NONE) {
 		/* initial table load, set md's type based on table's type */
@@ -1188,6 +1188,15 @@ static int table_load(struct dm_ioctl *p
 		r = -EINVAL;
 		goto out;
 	}
+
+	/* setup md->queue to reflect md's type (may block) */
+	r = dm_setup_md_queue(md);
+	if (r) {
+		DMWARN("unable to setup device queue for this table.");
+		dm_table_destroy(t);
+		dm_unlock_md_type(md);
+		goto out;
+	}
 	dm_unlock_md_type(md);
 
 	/* stage inactive table */
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -124,7 +124,7 @@ struct mapped_device {
 
 	struct request_queue *queue;
 	unsigned type;
-	/* Protect type against concurrent access. */
+	/* Protect queue and type against concurrent access. */
 	struct mutex type_lock;
 
 	struct gendisk *disk;
@@ -1853,6 +1853,28 @@ static const struct block_device_operati
 static void dm_wq_work(struct work_struct *work);
 static void dm_rq_barrier_work(struct work_struct *work);
 
+static void dm_init_md_queue(struct mapped_device *md)
+{
+	/*
+	 * Request-based dm devices cannot be stacked on top of bio-based dm
+	 * devices.  The type of this dm device has not been decided yet.
+	 * The type is decided at the first table loading time.
+	 * To prevent problematic device stacking, clear the queue flag
+	 * for request stacking support until then.
+	 *
+	 * This queue is new, so no concurrency on the queue_flags.
+	 */
+	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+
+	md->queue->queuedata = md;
+	md->queue->backing_dev_info.congested_fn = dm_any_congested;
+	md->queue->backing_dev_info.congested_data = md;
+	blk_queue_make_request(md->queue, dm_request);
+	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
+	md->queue->unplug_fn = dm_unplug_all;
+	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
+}
+
 /*
  * Allocate and initialise a blank device with a given minor.
  */
@@ -1892,34 +1914,11 @@ static struct mapped_device *alloc_dev(i
 	INIT_LIST_HEAD(&md->uevent_list);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_init_queue(dm_request_fn, NULL);
+	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
 		goto bad_queue;
 
-	/*
-	 * Request-based dm devices cannot be stacked on top of bio-based dm
-	 * devices.  The type of this dm device has not been decided yet,
-	 * although we initialized the queue using blk_init_queue().
-	 * The type is decided at the first table loading time.
-	 * To prevent problematic device stacking, clear the queue flag
-	 * for request stacking support until then.
-	 *
-	 * This queue is new, so no concurrency on the queue_flags.
-	 */
-	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
-	md->saved_make_request_fn = md->queue->make_request_fn;
-	md->queue->queuedata = md;
-	md->queue->backing_dev_info.congested_fn = dm_any_congested;
-	md->queue->backing_dev_info.congested_data = md;
-	blk_queue_make_request(md->queue, dm_request);
-	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	md->queue->unplug_fn = dm_unplug_all;
-	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-	blk_queue_softirq_done(md->queue, dm_softirq_done);
-	blk_queue_prep_rq(md->queue, dm_prep_fn);
-	blk_queue_lld_busy(md->queue, dm_lld_busy);
-	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
-			  dm_rq_prepare_flush);
+	dm_init_md_queue(md);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -2158,6 +2157,49 @@ unsigned dm_get_md_type(struct mapped_de
 	return md->type;
 }
 
+/*
+ * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
+ */
+static int dm_init_request_based_queue(struct mapped_device *md)
+{
+	struct request_queue *q = NULL;
+
+	if (md->queue->elevator)
+		return 1;
+
+	/* Fully initialize the queue */
+	q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+	if (!q)
+		return 0;
+
+	md->queue = q;
+	md->saved_make_request_fn = md->queue->make_request_fn;
+	dm_init_md_queue(md);
+	blk_queue_softirq_done(md->queue, dm_softirq_done);
+	blk_queue_prep_rq(md->queue, dm_prep_fn);
+	blk_queue_lld_busy(md->queue, dm_lld_busy);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+			  dm_rq_prepare_flush);
+
+	elv_register_queue(md->queue);
+
+	return 1;
+}
+
+/*
+ * Setup the DM device's queue based on md's type
+ */
+int dm_setup_md_queue(struct mapped_device *md)
+{
+	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
+	    !dm_init_request_based_queue(md)) {
+		DMWARN("Cannot initialize queue for Request-based dm");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct mapped_device *dm_find_md(dev_t dev)
 {
 	struct mapped_device *md;
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -71,6 +71,8 @@ void dm_unlock_md_type(struct mapped_dev
 void dm_set_md_type(struct mapped_device *md, unsigned type);
 unsigned dm_get_md_type(struct mapped_device *md);
 
+int dm_setup_md_queue(struct mapped_device *md);
+
 /*
  * To check the return value from dm_table_find_target().
  */
