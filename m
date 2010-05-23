From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/6 "v8"] dm: only initialize full request_queue
	for request-based device
Date: Sun, 23 May 2010 17:44:59 -0400
Message-ID: <1274651101-9784-5-git-send-email-snitzer@redhat.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Allocate a minimalist request_queue structure initially (needed for both
bio and request-based DM).  A bio-based DM device no longer defaults to
having a fully initialized request_queue (request_fn, elevator, etc).
So bio-based DM devices no longer register elevator sysfs attributes
('iosched/' tree or 'scheduler' other than "none").

Initialization of a full request_queue (request_fn, elevator, etc) is
deferred until it is known that the DM device is request-based -- at the
end of the table load sequence.

Factor DM device's request_queue initialization:
- common to both request-based and bio-based into dm_init_md_queue().
- specific to request-based into dm_init_request_based_queue().

md->type_lock is also used to protect md->queue during table_load().
md->queue is setup without concern for:
- another table_load() racing to setup conflicting queue state.
- do_resume() making a conflicting table live.

NOTE: It is still possible, albeit unlikely, for a bio-based device to
have a full request_queue.  But in this case the unused elevator will
not be registered with sysfs.  A table switch from request-based to
bio-based would be required, e.g.:

   # dmsetup create --notable bio-based
   # echo "0 100 multipath ..." | dmsetup load bio-based
   # dmsetup clear bio-based
   # echo "0 100 linear ..."    | dmsetup load bio-based
   # dmsetup resume bio-based

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |   17 ++++++
 drivers/md/dm.c       |  125 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/dm.h       |    2 
 3 files changed, 116 insertions(+), 28 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1185,14 +1185,16 @@ static int table_load(struct dm_ioctl *p
 	}
 
 	/*
-	 * Protect md->type against concurrent table loads.
+	 * Protect md->type and md->queue against concurrent table loads.
 	 * Locking strategy:
 	 * + Leverage fact that md's type cannot change after initial table load.
 	 *   - Only protect type in table_load() -- not in do_resume().
 	 *
-	 * + Protect type while working to stage an inactive table:
+	 * + Protect type and queue while working to stage an inactive table:
 	 *   - check if table's type conflicts with md->type
 	 *     (holding: md->type_lock)
+	 *   - setup md->queue based on md->type
+	 *     (holding: md->type_lock)
 	 *   - stage inactive table (hc->new_map)
 	 *     (holding: md->type_lock + _hash_lock)
 	 */
@@ -1211,6 +1213,17 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	/* setup md->queue to reflect md's and table's type (may block) */
+	r = dm_setup_md_queue(md);
+	if (r) {
+		DMWARN("unable to setup device queue for this table.");
+		dm_table_destroy(t);
+		if (initial_table_load)
+			dm_clear_md_type(md);
+		dm_unlock_md_type(md);
+		goto out;
+	}
+
 	/* stage inactive table */
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -140,7 +140,7 @@ struct mapped_device {
 	struct request_queue *queue;
 	enum mapped_device_type type;
 	/*
-	 * Protect type from concurrent access.
+	 * Protect queue and type from concurrent access.
 	 */
 	struct mutex type_lock;
 
@@ -1870,6 +1870,28 @@ static const struct block_device_operati
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
@@ -1910,34 +1932,11 @@ static struct mapped_device *alloc_dev(i
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
@@ -2214,6 +2213,80 @@ bool dm_md_type_matches_table(struct map
 	return 0;
 }
 
+/*
+ * Functions to manage md->queue.
+ * All are required to hold md->type_lock.
+ */
+static bool dm_bio_based_md_queue(struct mapped_device *md)
+{
+	return (md->queue->request_fn) ? 0 : 1;
+}
+
+/*
+ * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
+ */
+static int dm_init_request_based_queue(struct mapped_device *md)
+{
+	struct request_queue *q = NULL;
+
+	/* Avoid re-initializing the queue if already fully initialized */
+	if (!md->queue->elevator) {
+		/* Fully initialize the queue */
+		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+		if (!q)
+			return 0;
+		md->queue = q;
+		md->saved_make_request_fn = md->queue->make_request_fn;
+		dm_init_md_queue(md);
+		blk_queue_softirq_done(md->queue, dm_softirq_done);
+		blk_queue_prep_rq(md->queue, dm_prep_fn);
+		blk_queue_lld_busy(md->queue, dm_lld_busy);
+		blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+				  dm_rq_prepare_flush);
+	} else if (dm_bio_based_md_queue(md)) {
+		/*
+		 * Queue was fully initialized on behalf of a previous
+		 * request-based table load.  Table is now switching from
+		 * bio-based back to request-based, e.g.: rq -> bio -> rq
+		 */
+		md->queue->request_fn = dm_request_fn;
+	} else
+		return 1; /* queue already request-based */
+
+	elv_register_queue(md->queue);
+
+	return 1;
+}
+
+static void dm_clear_request_based_queue(struct mapped_device *md)
+{
+	if (dm_bio_based_md_queue(md))
+		return; /* queue already bio-based */
+
+	/* Unregister elevator from sysfs and clear ->request_fn */
+	elv_unregister_queue(md->queue);
+	md->queue->request_fn = NULL;
+}
+
+/*
+ * Setup the DM device's queue based on md's type
+ */
+int dm_setup_md_queue(struct mapped_device *md)
+{
+	BUG_ON(!mutex_is_locked(&md->type_lock));
+	BUG_ON(dm_unknown_md_type(md));
+
+	if (dm_request_based_md_type(md)) {
+		if (!dm_init_request_based_queue(md)) {
+			DMWARN("Cannot initialize queue for Request-based dm");
+			return -EINVAL;
+		}
+	} else if (dm_bio_based_md_type(md))
+		dm_clear_request_based_queue(md);
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
@@ -73,6 +73,8 @@ void dm_clear_md_type(struct mapped_devi
 bool dm_unknown_md_type(struct mapped_device *md);
 bool dm_md_type_matches_table(struct mapped_device *md, struct dm_table* t);
 
+int dm_setup_md_queue(struct mapped_device *md);
+
 void dm_lock_resume(struct mapped_device *md);
 void dm_unlock_resume(struct mapped_device *md);
 
