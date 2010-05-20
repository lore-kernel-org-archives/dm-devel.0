From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v7] dm: only initialize full request_queue for
 request-based device
Date: Thu, 20 May 2010 18:50:46 -0400
Message-ID: <20100520225046.GA26202@redhat.com>
References: <1273861781-3280-1-git-send-email-snitzer@redhat.com>
	<20100517182449.GB32278@redhat.com>
	<20100518140324.GB27582@redhat.com>
	<20100519214411.GA31354@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100519214411.GA31354@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Nikanth Karthikesan <knikanth@suse.de>, Alasdair Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Vivek Goyal <vgoyal@redhat.com>
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

Introduce 'queue_lock' in mapped_device structure and use it to protect
md->queue during table_load() and do_resume().

Adjust elv_iosched_show() to return "none" if !blk_queue_stackable.
This allows the block layer to take bio-based DM into consideration.

NOTE: It is still possible, albeit unlikely, for a bio-based device to
have a full request_queue.  But in this case the unused elevator will
not be registered with sysfs.  A table switch from request-based to 
bio-based would be required, e.g.:

   # dmsetup create --notable bio-based
   # echo "0 100 multipath ..." | dmsetup load bio-based
   # echo "0 100 linear ..."    | dmsetup load bio-based
   # dmsetup resume bio-based

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/elevator.c      |    2 
 drivers/md/dm-ioctl.c |   34 +++++++++++++-
 drivers/md/dm-table.c |   27 +++++++++++
 drivers/md/dm.c       |  121 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/dm.h       |    8 +++
 5 files changed, 164 insertions(+), 28 deletions(-)

v7: fix locking to properly protect md->queue during do_resume(), don't
    change queue if device already has a live table
v6: use dm_{lock,unlock}_md_queue to protect md->queue during table_load(),
    move conflicting table type check from resume to table load.
v5: revert v4's synchronization, localize table load queue manipulation
    to _hash_lock protected critical section in dm-ioctl.c:table_load()
v4: add synchronization to dm_{init,clear}_request_based_queue
v3: consolidate to 1 patch, introduce dm_init_md_queue

Index: linux-2.6/block/elevator.c
===================================================================
--- linux-2.6.orig/block/elevator.c
+++ linux-2.6/block/elevator.c
@@ -1086,7 +1086,7 @@ ssize_t elv_iosched_show(struct request_
 	struct elevator_type *__e;
 	int len = 0;
 
-	if (!q->elevator)
+	if (!q->elevator || !blk_queue_stackable(q))
 		return sprintf(name, "none\n");
 
 	elv = e->elevator_type;
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -862,7 +862,6 @@ static int do_resume(struct dm_ioctl *pa
 	struct dm_table *new_map, *old_map = NULL;
 
 	down_write(&_hash_lock);
-
 	hc = __find_device_hash_cell(param);
 	if (!hc) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
@@ -871,11 +870,27 @@ static int do_resume(struct dm_ioctl *pa
 	}
 
 	md = hc->md;
+	up_write(&_hash_lock);
+
+	/*
+	 * Protect against md->queue changing via competing table_load
+	 * until the device is known to have a live table.
+	 */
+	dm_lock_md_queue(md);
+
+	down_write(&_hash_lock);
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		DMWARN("device has been removed from the dev hash table.");
+		up_write(&_hash_lock);
+		dm_unlock_md_queue(md);
+		dm_put(md);
+		return -ENXIO;
+	}
 
 	new_map = hc->new_map;
 	hc->new_map = NULL;
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-
 	up_write(&_hash_lock);
 
 	/* Do we need to load a new map ? */
@@ -891,6 +906,7 @@ static int do_resume(struct dm_ioctl *pa
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
 			dm_table_destroy(new_map);
+			dm_unlock_md_queue(md);
 			dm_put(md);
 			return PTR_ERR(old_map);
 		}
@@ -901,6 +917,9 @@ static int do_resume(struct dm_ioctl *pa
 			set_disk_ro(dm_disk(md), 1);
 	}
 
+	/* The device has a live table at this point. */
+	dm_unlock_md_queue(md);
+
 	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
 		if (!r && !dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
@@ -1170,12 +1189,22 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	dm_lock_md_queue(md);
+	r = dm_table_setup_md_queue(t);
+	if (r) {
+		DMWARN("unable to setup device queue for this table");
+		dm_table_destroy(t);
+		dm_unlock_md_queue(md);
+		goto out;
+	}
+
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
 		dm_table_destroy(t);
 		up_write(&_hash_lock);
+		dm_unlock_md_queue(md);
 		r = -ENXIO;
 		goto out;
 	}
@@ -1184,6 +1213,7 @@ static int table_load(struct dm_ioctl *p
 		dm_table_destroy(hc->new_map);
 	hc->new_map = t;
 	up_write(&_hash_lock);
+	dm_unlock_md_queue(md);
 
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
 	r = __dev_status(md, param);
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -866,6 +866,33 @@ bool dm_table_request_based(struct dm_ta
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
 }
 
+/*
+ * Setup the DM device's queue based on table's type.
+ */
+int dm_table_setup_md_queue(struct dm_table *t)
+{
+	struct dm_table *live_table = NULL;
+
+	BUG_ON(!dm_md_queue_is_locked(t->md));
+
+	/* don't change queue if device already has a live table */
+	live_table = dm_get_live_table(t->md);
+	if (live_table) {
+		dm_table_put(live_table);
+		return 0;
+	}
+
+	if (dm_table_request_based(t)) {
+		if (!dm_init_request_based_queue(t->md)) {
+			DMWARN("Cannot initialize queue for Request-based dm");
+			return -EINVAL;
+		}
+	} else
+		dm_clear_request_based_queue(t->md);
+
+	return 0;
+}
+
 int dm_table_alloc_md_mempools(struct dm_table *t)
 {
 	unsigned type = dm_table_get_type(t);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -123,6 +123,11 @@ struct mapped_device {
 	unsigned long flags;
 
 	struct request_queue *queue;
+	/*
+	 * Protect queue from concurrent access during
+	 * table load(s) and resume.
+	 */
+	struct mutex queue_lock;
 	struct gendisk *disk;
 	char name[16];
 
@@ -1445,6 +1450,11 @@ static int dm_request_based(struct mappe
 	return blk_queue_stackable(md->queue);
 }
 
+static int dm_bio_based_md(struct mapped_device *md)
+{
+	return (md->queue->request_fn) ? 0 : 1;
+}
+
 static int dm_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
@@ -1849,6 +1859,28 @@ static const struct block_device_operati
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
@@ -1876,6 +1908,7 @@ static struct mapped_device *alloc_dev(i
 
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
+	mutex_init(&md->queue_lock);
 	spin_lock_init(&md->deferred_lock);
 	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
@@ -1886,34 +1919,11 @@ static struct mapped_device *alloc_dev(i
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
@@ -1968,6 +1978,67 @@ bad_module_get:
 	return NULL;
 }
 
+void dm_lock_md_queue(struct mapped_device *md)
+{
+	mutex_lock(&md->queue_lock);
+}
+
+void dm_unlock_md_queue(struct mapped_device *md)
+{
+	mutex_unlock(&md->queue_lock);
+}
+
+int dm_md_queue_is_locked(struct mapped_device *md)
+{
+	return mutex_is_locked(&md->queue_lock);
+}
+
+/*
+ * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
+ */
+int dm_init_request_based_queue(struct mapped_device *md)
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
+	} else if (dm_bio_based_md(md)) {
+		/*
+		 * Queue was fully initialized on behalf of a previous
+		 * request-based table load.  Table is now switching from
+		 * bio-based back to request-based, e.g.: rq -> bio -> rq
+		 */
+		md->queue->request_fn = dm_request_fn;
+	} else
+		return 1; /* already request-based */
+
+	elv_register_queue(md->queue);
+
+	return 1;
+}
+
+void dm_clear_request_based_queue(struct mapped_device *md)
+{
+	if (dm_bio_based_md(md))
+		return; /* already bio-based */
+
+	/* Unregister elevator from sysfs and clear ->request_fn */
+	elv_unregister_queue(md->queue);
+	md->queue->request_fn = NULL;
+}
+
 static void unlock_fs(struct mapped_device *md);
 
 static void free_dev(struct mapped_device *md)
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -66,6 +66,14 @@ bool dm_table_request_based(struct dm_ta
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+int dm_table_setup_md_queue(struct dm_table *t);
+
+int dm_init_request_based_queue(struct mapped_device *md);
+void dm_clear_request_based_queue(struct mapped_device *md);
+
+void dm_lock_md_queue(struct mapped_device *md);
+void dm_unlock_md_queue(struct mapped_device *md);
+int dm_md_queue_is_locked(struct mapped_device *md);
 
 /*
  * To check the return value from dm_table_find_target().
