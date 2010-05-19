From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v6] dm: only initialize full request_queue for
 request-based device
Date: Wed, 19 May 2010 17:44:11 -0400
Message-ID: <20100519214411.GA31354@redhat.com>
References: <1273861781-3280-1-git-send-email-snitzer@redhat.com>
	<20100517182449.GB32278@redhat.com>
	<20100518140324.GB27582@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100518140324.GB27582@redhat.com>
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

Future work, in conjunction with userspace changes, could allow DM to
fix this by knowing which type of request_queue to initialize a priori
(instead of waiting until the end of the table load sequence).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/elevator.c      |    2 +-
 drivers/md/dm-ioctl.c |   11 ++++
 drivers/md/dm-table.c |   32 ++++++++++++-
 drivers/md/dm.c       |  124 ++++++++++++++++++++++++++++++++++++-------------
 drivers/md/dm.h       |    6 ++
 5 files changed, 141 insertions(+), 34 deletions(-)

v6: use dm_{lock,unlock}_md_queue to protect md->queue during table_load(),
    move conflicting table type check from resume to table load.
v5: revert v4's synchronization, localize table load queue manipulation
    to _hash_lock protected critical section in dm-ioctl.c:table_load()
v4: add synchronization to dm_{init,clear}_request_based_queue
v3: consolidate to 1 patch, introduce dm_init_md_queue

diff --git a/block/elevator.c b/block/elevator.c
index 6ec9137..168112e 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1088,7 +1088,7 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
 	struct elevator_type *__e;
 	int len = 0;
 
-	if (!q->elevator)
+	if (!q->elevator || !blk_queue_stackable(q))
 		return sprintf(name, "none\n");
 
 	elv = e->elevator_type;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..0e80945 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1170,12 +1170,22 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
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
@@ -1184,6 +1194,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		dm_table_destroy(hc->new_map);
 	hc->new_map = t;
 	up_write(&_hash_lock);
+	dm_unlock_md_queue(md);
 
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
 	r = __dev_status(md, param);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..62ebd94 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -782,6 +782,7 @@ int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0;
+	struct dm_table *live_table = NULL;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices;
@@ -803,7 +804,7 @@ int dm_table_set_type(struct dm_table *t)
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type = DM_TYPE_BIO_BASED;
-		return 0;
+		goto finish;
 	}
 
 	BUG_ON(!request_based); /* No targets in this table */
@@ -831,6 +832,18 @@ int dm_table_set_type(struct dm_table *t)
 
 	t->type = DM_TYPE_REQUEST_BASED;
 
+finish:
+	/* cannot change the device type, once a table is bound */
+	live_table = dm_get_live_table(t->md);
+	if (live_table) {
+		if (dm_table_get_type(live_table) != dm_table_get_type(t)) {
+			DMWARN("can't change the device type after a table is bound");
+			dm_table_put(live_table);
+			return -EINVAL;
+		}
+		dm_table_put(live_table);
+	}
+
 	return 0;
 }
 
@@ -844,6 +857,23 @@ bool dm_table_request_based(struct dm_table *t)
 	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
 }
 
+/*
+ * Setup the DM device's queue based on table's type.
+ * Caller must serialize access to table's md.
+ */
+int dm_table_setup_md_queue(struct dm_table *t)
+{
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
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d21e128..923b662 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -123,6 +123,11 @@ struct mapped_device {
 	unsigned long flags;
 
 	struct request_queue *queue;
+	/*
+	 * Protect queue from concurrent initialization during
+	 * table load
+	 */
+	struct mutex queue_lock;
 	struct gendisk *disk;
 	char name[16];
 
@@ -1445,6 +1450,11 @@ static int dm_request_based(struct mapped_device *md)
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
@@ -1849,6 +1859,28 @@ static const struct block_device_operations dm_blk_dops;
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
@@ -1876,6 +1908,7 @@ static struct mapped_device *alloc_dev(int minor)
 
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
+	mutex_init(&md->queue_lock);
 	spin_lock_init(&md->deferred_lock);
 	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
@@ -1886,34 +1919,11 @@ static struct mapped_device *alloc_dev(int minor)
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
@@ -1968,6 +1978,63 @@ bad_module_get:
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
+	blk_queue_softirq_done(md->queue, dm_softirq_done);
+	blk_queue_prep_rq(md->queue, dm_prep_fn);
+	blk_queue_lld_busy(md->queue, dm_lld_busy);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+			  dm_rq_prepare_flush);
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
@@ -2403,13 +2470,6 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
-	/* cannot change the device type, once a table is bound */
-	if (md->map &&
-	    (dm_table_get_type(md->map) != dm_table_get_type(table))) {
-		DMWARN("can't change the device type after a table is bound");
-		goto out;
-	}
-
 	map = __bind(md, table, &limits);
 
 out:
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..2b6102f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -65,6 +65,12 @@ bool dm_table_request_based(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+int dm_table_setup_md_queue(struct dm_table *t);
+
+void dm_lock_md_queue(struct mapped_device *md);
+void dm_unlock_md_queue(struct mapped_device *md);
+int dm_init_request_based_queue(struct mapped_device *md);
+void dm_clear_request_based_queue(struct mapped_device *md);
 
 /*
  * To check the return value from dm_table_find_target().
