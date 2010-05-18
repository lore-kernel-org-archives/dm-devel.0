From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5] dm: only initialize full request_queue for
 request-based device
Date: Tue, 18 May 2010 10:03:25 -0400
Message-ID: <20100518140324.GB27582@redhat.com>
References: <1273861781-3280-1-git-send-email-snitzer@redhat.com>
	<20100517182449.GB32278@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100517182449.GB32278@redhat.com>
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
 drivers/md/dm-ioctl.c |    8 ++++
 drivers/md/dm-table.c |   17 ++++++++
 drivers/md/dm.c       |  101 +++++++++++++++++++++++++++++++++++++------------
 drivers/md/dm.h       |    4 ++
 5 files changed, 106 insertions(+), 26 deletions(-)

v5: revert v4's synchronization, localize table load queue manipulation
    to _hash_lock protected critical section in dm-ioctl.c:table_load()
v4: add synchronization to dm_{init,clear}_request_based_queue
v3: consolidate to 1 patch, introduce dm_init_md_queue

diff --git a/block/elevator.c b/block/elevator.c
index 76e3702..e986e4c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -1086,7 +1086,7 @@ ssize_t elv_iosched_show(struct request_queue *q, char *name)
 	struct elevator_type *__e;
 	int len = 0;
 
-	if (!q->elevator)
+	if (!q->elevator || !blk_queue_stackable(q))
 		return sprintf(name, "none\n");
 
 	elv = e->elevator_type;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..bfb283c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1180,6 +1180,14 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
+	r = dm_table_setup_md_queue(t);
+	if (r) {
+		DMWARN("unable to setup device queue for this table");
+		dm_table_destroy(t);
+		up_write(&_hash_lock);
+		goto out;
+	}
+
 	if (hc->new_map)
 		dm_table_destroy(hc->new_map);
 	hc->new_map = t;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9924ea2..990cf17 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -844,6 +844,23 @@ bool dm_table_request_based(struct dm_table *t)
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
index d21e128..76b61ca 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1445,6 +1445,11 @@ static int dm_request_based(struct mapped_device *md)
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
@@ -1849,6 +1854,28 @@ static const struct block_device_operations dm_blk_dops;
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
@@ -1886,34 +1913,11 @@ static struct mapped_device *alloc_dev(int minor)
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
@@ -1968,6 +1972,53 @@ bad_module_get:
 	return NULL;
 }
 
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
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..b4ebb11 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -65,6 +65,7 @@ bool dm_table_request_based(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+int dm_table_setup_md_queue(struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
@@ -113,6 +114,9 @@ void dm_sysfs_exit(struct mapped_device *md);
 struct kobject *dm_kobject(struct mapped_device *md);
 struct mapped_device *dm_get_from_kobject(struct kobject *kobj);
 
+int dm_init_request_based_queue(struct mapped_device *md);
+void dm_clear_request_based_queue(struct mapped_device *md);
+
 /*
  * Targets for linear and striped mappings
  */
