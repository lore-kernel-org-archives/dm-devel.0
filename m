From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 8/8] dm: allocate requests from target when
	stacking on blk-mq devices
Date: Tue, 16 Dec 2014 23:00:04 -0500
Message-ID: <1418788804-1982-9-git-send-email-snitzer@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

From: Keith Busch <keith.busch@intel.com>

For blk-mq request-based DM the responsibility of allocating a cloned
request is transfered from DM core to the target type so that the cloned
request is allocated from the appropriate request_queue's pool and
initialized for the target block device.  The original request's
'special' now points to the dm_rq_target_io because the clone is
allocated later in the block layer rather than in DM core.

Care was taken to preserve compatibility with old-style block request
completion that requires request-based DM _not_ acquire the clone
request's queue lock in the completion path.  As such, there are now 2
different request-based dm_target interfaces:
1) the original .map_rq() interface will continue to be used for
   non-blk-mq devices -- the preallocated clone request is passed in
   from DM core.
2) a new .clone_and_map_rq() and .release_clone_rq() will be used for
   blk-mq devices -- blk_get_request() and blk_put_request() are used
   respectively from these hooks.

dm_table_set_type() was updated to detect if the request-based target is
being stacked on blk-mq devices, if so DM_TYPE_MQ_REQUEST_BASED is set.
DM core disallows switching the DM table's type after it is set.  This
means that there is no mixing of non-blk-mq and blk-mq devices within
the same request-based DM table.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         |  53 ++++++++--
 drivers/md/dm-table.c         |  34 +++++-
 drivers/md/dm-target.c        |  15 ++-
 drivers/md/dm.c               | 233 +++++++++++++++++++++++++-----------------
 drivers/md/dm.h               |   8 +-
 include/linux/device-mapper.h |   7 ++
 6 files changed, 239 insertions(+), 111 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7b6b0f0..df408bc 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -11,6 +11,7 @@
 #include "dm-path-selector.h"
 #include "dm-uevent.h"
 
+#include <linux/blkdev.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/mempool.h>
@@ -378,18 +379,18 @@ static int __must_push_back(struct multipath *m)
 /*
  * Map cloned requests
  */
-static int multipath_map(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
+static int __multipath_map(struct dm_target *ti, struct request *clone,
+			   union map_info *map_context,
+			   struct request *rq, struct request **__clone)
 {
 	struct multipath *m = (struct multipath *) ti->private;
 	int r = DM_MAPIO_REQUEUE;
-	size_t nr_bytes = blk_rq_bytes(clone);
-	unsigned long flags;
+	size_t nr_bytes = clone ? blk_rq_bytes(clone) : blk_rq_bytes(rq);
 	struct pgpath *pgpath;
 	struct block_device *bdev;
 	struct dm_mpath_io *mpio;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock(&m->lock);
 
 	/* Do we need to select a new pgpath? */
 	if (!m->current_pgpath ||
@@ -412,9 +413,21 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 		goto out_unlock;
 
 	bdev = pgpath->path.dev->bdev;
-	clone->q = bdev_get_queue(bdev);
-	clone->rq_disk = bdev->bd_disk;
-	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+
+	if (clone) {
+		/* Old request-based interface: allocated clone is passed in */
+		clone->q = bdev_get_queue(bdev);
+		clone->rq_disk = bdev->bd_disk;
+		clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	} else {
+		/* blk-mq request-based interface */
+		*__clone = blk_get_request(bdev_get_queue(bdev),
+					   rq_data_dir(rq), GFP_KERNEL);
+		if (IS_ERR(*__clone))
+			goto out_unlock;
+		(*__clone)->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	}
+
 	mpio = map_context->ptr;
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
@@ -425,11 +438,29 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 	r = DM_MAPIO_REMAPPED;
 
 out_unlock:
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock(&m->lock);
 
 	return r;
 }
 
+static int multipath_map(struct dm_target *ti, struct request *clone,
+			 union map_info *map_context)
+{
+	return __multipath_map(ti, clone, map_context, NULL, NULL);
+}
+
+static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
+				   union map_info *map_context,
+				   struct request **clone)
+{
+	return __multipath_map(ti, NULL, map_context, rq, clone);
+}
+
+static void multipath_release_clone(struct request *clone)
+{
+	blk_put_request(clone);
+}
+
 /*
  * If we run out of usable paths, should we queue I/O or error it?
  */
@@ -1666,11 +1697,13 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 7, 0},
+	.version = {1, 8, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
 	.map_rq = multipath_map,
+	.clone_and_map_rq = multipath_clone_and_map,
+	.release_clone_rq = multipath_release_clone,
 	.rq_end_io = multipath_end_io,
 	.presuspend = multipath_presuspend,
 	.postsuspend = multipath_postsuspend,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3afae9e..2d7e373 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -827,6 +827,7 @@ static int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based = 0, request_based = 0, hybrid = 0;
+	bool use_blk_mq = false;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices;
@@ -872,11 +873,26 @@ static int dm_table_set_type(struct dm_table *t)
 	/* Non-request-stackable devices can't be used for request-based dm */
 	devices = dm_table_get_devices(t);
 	list_for_each_entry(dd, devices, list) {
-		if (!blk_queue_stackable(bdev_get_queue(dd->dm_dev->bdev))) {
-			DMWARN("table load rejected: including"
-			       " non-request-stackable devices");
+		struct request_queue *q = bdev_get_queue(dd->dm_dev->bdev);
+
+		if (!blk_queue_stackable(q)) {
+			DMERR("table load rejected: including"
+			      " non-request-stackable devices");
 			return -EINVAL;
 		}
+
+		if (q->mq_ops)
+			use_blk_mq = true;
+	}
+
+	if (use_blk_mq) {
+		/* verify _all_ devices in the table are blk-mq devices */
+		list_for_each_entry(dd, devices, list)
+			if (!bdev_get_queue(dd->dm_dev->bdev)->mq_ops) {
+				DMERR("table load rejected: not all devices"
+				      " are blk-mq request-stackable");
+				return -EINVAL;
+			}
 	}
 
 	/*
@@ -890,7 +906,7 @@ static int dm_table_set_type(struct dm_table *t)
 		return -EINVAL;
 	}
 
-	t->type = DM_TYPE_REQUEST_BASED;
+	t->type = !use_blk_mq ? DM_TYPE_REQUEST_BASED : DM_TYPE_MQ_REQUEST_BASED;
 
 	return 0;
 }
@@ -907,7 +923,15 @@ struct target_type *dm_table_get_immutable_target_type(struct dm_table *t)
 
 bool dm_table_request_based(struct dm_table *t)
 {
-	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
+	unsigned table_type = dm_table_get_type(t);
+
+	return (table_type == DM_TYPE_REQUEST_BASED ||
+		table_type == DM_TYPE_MQ_REQUEST_BASED);
+}
+
+bool dm_table_mq_request_based(struct dm_table *t)
+{
+	return dm_table_get_type(t) == DM_TYPE_MQ_REQUEST_BASED;
 }
 
 static int dm_table_alloc_md_mempools(struct dm_table *t)
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 242e3ce..925ec1b 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -137,13 +137,26 @@ static int io_err_map_rq(struct dm_target *ti, struct request *clone,
 	return -EIO;
 }
 
+static int io_err_clone_and_map_rq(struct dm_target *ti, struct request *rq,
+				   union map_info *map_context,
+				   struct request **clone)
+{
+	return -EIO;
+}
+
+static void io_err_release_clone_rq(struct request *clone)
+{
+}
+
 static struct target_type error_target = {
 	.name = "error",
-	.version = {1, 2, 0},
+	.version = {1, 3, 0},
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
 	.map_rq = io_err_map_rq,
+	.clone_and_map_rq = io_err_clone_and_map_rq,
+	.release_clone_rq = io_err_release_clone_rq,
 };
 
 int __init dm_target_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 00c9986..1955710 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1016,7 +1016,7 @@ static void end_clone_bio(struct bio *clone, int error)
  * the md may be freed in dm_put() at the end of this function.
  * Or do dm_get() before calling this function and dm_put() later.
  */
-static void rq_completed(struct mapped_device *md, int rw, int run_queue)
+static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 {
 	atomic_dec(&md->pending[rw]);
 
@@ -1044,13 +1044,17 @@ static void free_rq_clone(struct request *clone)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	blk_rq_unprep_clone(clone);
-	free_clone_request(tio->md, clone);
+	if (clone->q->mq_ops)
+		tio->ti->type->release_clone_rq(clone);
+	else
+		free_clone_request(tio->md, clone);
 	free_rq_tio(tio);
 }
 
 /*
  * Complete the clone and the original request.
- * Must be called without queue lock.
+ * Must be called without clone's queue lock held,
+ * see end_clone_request() for more details.
  */
 static void dm_end_request(struct request *clone, int error)
 {
@@ -1079,23 +1083,23 @@ static void dm_end_request(struct request *clone, int error)
 
 static void dm_unprep_request(struct request *rq)
 {
-	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = rq->special;
+	struct request *clone = tio->clone;
 
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
 
-	free_rq_clone(clone);
+	if (clone)
+		free_rq_clone(clone);
 }
 
 /*
  * Requeue the original request of a clone.
  */
-static void dm_requeue_unmapped_request(struct request *clone)
+static void dm_requeue_unmapped_original_request(struct mapped_device *md,
+						 struct request *rq)
 {
-	int rw = rq_data_dir(clone);
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
-	struct request *rq = tio->orig;
+	int rw = rq_data_dir(rq);
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
@@ -1105,7 +1109,14 @@ static void dm_requeue_unmapped_request(struct request *clone)
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	rq_completed(md, rw, 0);
+	rq_completed(md, rw, false);
+}
+
+static void dm_requeue_unmapped_request(struct request *clone)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	dm_requeue_unmapped_original_request(tio->md, tio->orig);
 }
 
 static void __stop_queue(struct request_queue *q)
@@ -1175,8 +1186,15 @@ static void dm_done(struct request *clone, int error, bool mapped)
 static void dm_softirq_done(struct request *rq)
 {
 	bool mapped = true;
-	struct request *clone = rq->completion_data;
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct dm_rq_target_io *tio = rq->special;
+	struct request *clone = tio->clone;
+
+	if (!clone) {
+		blk_end_request_all(rq, tio->error);
+		rq_completed(tio->md, rq_data_dir(rq), false);
+		free_rq_tio(tio);
+		return;
+	}
 
 	if (rq->cmd_flags & REQ_FAILED)
 		mapped = false;
@@ -1188,13 +1206,11 @@ static void dm_softirq_done(struct request *rq)
  * Complete the clone and the original request with the error status
  * through softirq context.
  */
-static void dm_complete_request(struct request *clone, int error)
+static void dm_complete_request(struct request *rq, int error)
 {
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
+	struct dm_rq_target_io *tio = rq->special;
 
 	tio->error = error;
-	rq->completion_data = clone;
 	blk_complete_request(rq);
 }
 
@@ -1202,39 +1218,40 @@ static void dm_complete_request(struct request *clone, int error)
  * Complete the not-mapped clone and the original request with the error status
  * through softirq context.
  * Target's rq_end_io() function isn't called.
- * This may be used when the target's map_rq() function fails.
+ * This may be used when the target's map_rq() or clone_and_map_rq() functions fail.
  */
-static void dm_kill_unmapped_request(struct request *clone, int error)
+static void dm_kill_unmapped_request(struct request *rq, int error)
 {
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
-
 	rq->cmd_flags |= REQ_FAILED;
-	dm_complete_request(clone, error);
+	dm_complete_request(rq, error);
 }
 
 /*
- * Called with the queue lock held
+ * Called with the clone's queue lock held
  */
 static void end_clone_request(struct request *clone, int error)
 {
-	/*
-	 * For just cleaning up the information of the queue in which
-	 * the clone was dispatched.
-	 * The clone is *NOT* freed actually here because it is alloced from
-	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
-	 */
-	__blk_put_request(clone->q, clone);
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	if (!clone->q->mq_ops) {
+		/*
+		 * For just cleaning up the information of the queue in which
+		 * the clone was dispatched.
+		 * The clone is *NOT* freed actually here because it is alloced
+		 * from dm own mempool (REQ_ALLOCED isn't set).
+		 */
+		__blk_put_request(clone->q, clone);
+	}
 
 	/*
 	 * Actual request completion is done in a softirq context which doesn't
-	 * hold the queue lock.  Otherwise, deadlock could occur because:
+	 * hold the clone's queue lock.  Otherwise, deadlock could occur because:
 	 *     - another request may be submitted by the upper level driver
 	 *       of the stacking during the completion
 	 *     - the submission which requires queue lock may be done
-	 *       against this queue
+	 *       against this clone's queue
 	 */
-	dm_complete_request(clone, error);
+	dm_complete_request(tio->orig, error);
 }
 
 /*
@@ -1712,16 +1729,17 @@ static void dm_request(struct request_queue *q, struct bio *bio)
 		_dm_request(q, bio);
 }
 
-static void dm_dispatch_request(struct request *rq)
+static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 {
 	int r;
 
-	if (blk_queue_io_stat(rq->q))
-		rq->cmd_flags |= REQ_IO_STAT;
+	if (blk_queue_io_stat(clone->q))
+		clone->cmd_flags |= REQ_IO_STAT;
 
-	rq->start_time = jiffies;
-	r = blk_insert_cloned_request(rq->q, rq);
+	clone->start_time = jiffies;
+	r = blk_insert_cloned_request(clone->q, clone);
 	if (r)
+		/* must complete clone in terms of original request */
 		dm_complete_request(rq, r);
 }
 
@@ -1760,8 +1778,8 @@ static int setup_clone(struct request *clone, struct request *rq,
 	return 0;
 }
 
-static struct request *__clone_rq(struct request *rq, struct mapped_device *md,
-				  struct dm_rq_target_io *tio, gfp_t gfp_mask)
+static struct request *clone_rq(struct request *rq, struct mapped_device *md,
+				struct dm_rq_target_io *tio, gfp_t gfp_mask)
 {
 	struct request *clone = alloc_clone_request(md, gfp_mask);
 
@@ -1780,11 +1798,12 @@ static struct request *__clone_rq(struct request *rq, struct mapped_device *md,
 
 static void map_tio_request(struct kthread_work *work);
 
-static struct request *clone_rq(struct request *rq, struct mapped_device *md,
-				gfp_t gfp_mask)
+static struct dm_rq_target_io *prep_tio(struct request *rq,
+					struct mapped_device *md, gfp_t gfp_mask)
 {
-	struct request *clone;
 	struct dm_rq_target_io *tio;
+	int srcu_idx;
+	struct dm_table *table;
 
 	tio = alloc_rq_tio(md, gfp_mask);
 	if (!tio)
@@ -1798,13 +1817,17 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 	memset(&tio->info, 0, sizeof(tio->info));
 	init_kthread_work(&tio->work, map_tio_request);
 
-	clone = __clone_rq(rq, md, tio, GFP_ATOMIC);
-	if (!clone) {
-		free_rq_tio(tio);
-		return NULL;
+	table = dm_get_live_table(md, &srcu_idx);
+	if (!dm_table_mq_request_based(table)) {
+		if (!clone_rq(rq, md, tio, GFP_ATOMIC)) {
+			dm_put_live_table(md, srcu_idx);
+			free_rq_tio(tio);
+			return NULL;
+		}
 	}
+	dm_put_live_table(md, srcu_idx);
 
-	return clone;
+	return tio;
 }
 
 /*
@@ -1813,18 +1836,18 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 static int dm_prep_fn(struct request_queue *q, struct request *rq)
 {
 	struct mapped_device *md = q->queuedata;
-	struct request *clone;
+	struct dm_rq_target_io *tio;
 
 	if (unlikely(rq->special)) {
 		DMWARN("Already has something in rq->special.");
 		return BLKPREP_KILL;
 	}
 
-	clone = clone_rq(rq, md, GFP_ATOMIC);
-	if (!clone)
+	tio = prep_tio(rq, md, GFP_ATOMIC);
+	if (!tio)
 		return BLKPREP_DEFER;
 
-	rq->special = clone;
+	rq->special = tio;
 	rq->cmd_flags |= REQ_DONTPREP;
 
 	return BLKPREP_OK;
@@ -1832,17 +1855,31 @@ static int dm_prep_fn(struct request_queue *q, struct request *rq)
 
 /*
  * Returns:
- * 0  : the request has been processed (not requeued)
- * !0 : the request has been requeued
+ * 0   : the request has been processed (not requeued)
+ * 1   : the request has been requeued
+ * < 0 : the original request needs to be requeued
  */
-static int map_request(struct dm_target *ti, struct request *clone,
+static int map_request(struct dm_target *ti, struct request *rq,
 		       struct mapped_device *md)
 {
-	int r, requeued = 0;
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *clone = NULL;
+	int r, r2, requeued = 0;
+	struct dm_rq_target_io *tio = rq->special;
+
+	if (tio->clone) {
+		clone = tio->clone;
+		r = ti->type->map_rq(ti, clone, &tio->info);
+	} else {
+		r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
+		if (IS_ERR(clone))
+			return PTR_ERR(clone);
+		r2 = setup_clone(clone, rq, tio, GFP_KERNEL);
+		if (r2) {
+			ti->type->release_clone_rq(clone);
+			return r2;
+		}
+	}
 
-	tio->ti = ti;
-	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
@@ -1850,8 +1887,8 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
-				     blk_rq_pos(tio->orig));
-		dm_dispatch_request(clone);
+				     blk_rq_pos(rq));
+		dm_dispatch_clone_request(clone, rq);
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
@@ -1865,7 +1902,7 @@ static int map_request(struct dm_target *ti, struct request *clone,
 		}
 
 		/* The target wants to complete the I/O */
-		dm_kill_unmapped_request(clone, r);
+		dm_kill_unmapped_request(rq, r);
 		break;
 	}
 
@@ -1875,17 +1912,17 @@ static int map_request(struct dm_target *ti, struct request *clone,
 static void map_tio_request(struct kthread_work *work)
 {
 	struct dm_rq_target_io *tio = container_of(work, struct dm_rq_target_io, work);
+	struct request *rq = tio->orig;
+	struct mapped_device *md = tio->md;
 
-	map_request(tio->ti, tio->clone, tio->md);
+	if (map_request(tio->ti, rq, md) < 0)
+		dm_requeue_unmapped_original_request(md, rq);
 }
 
-static struct request *dm_start_request(struct mapped_device *md, struct request *orig)
+static void dm_start_request(struct mapped_device *md, struct request *orig)
 {
-	struct request *clone;
-
 	blk_start_request(orig);
-	clone = orig->special;
-	atomic_inc(&md->pending[rq_data_dir(clone)]);
+	atomic_inc(&md->pending[rq_data_dir(orig)]);
 
 	/*
 	 * Hold the md reference here for the in-flight I/O.
@@ -1895,8 +1932,6 @@ static struct request *dm_start_request(struct mapped_device *md, struct request
 	 * See the comment in rq_completed() too.
 	 */
 	dm_get(md);
-
-	return clone;
 }
 
 /*
@@ -1909,7 +1944,7 @@ static void dm_request_fn(struct request_queue *q)
 	int srcu_idx;
 	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
-	struct request *rq, *clone;
+	struct request *rq;
 	struct dm_rq_target_io *tio;
 	sector_t pos;
 
@@ -1932,19 +1967,19 @@ static void dm_request_fn(struct request_queue *q)
 		ti = dm_table_find_target(map, pos);
 		if (!dm_target_is_valid(ti)) {
 			/*
-			 * Must perform setup, that dm_done() requires,
+			 * Must perform setup, that rq_completed() requires,
 			 * before calling dm_kill_unmapped_request
 			 */
 			DMERR_LIMIT("request attempted access beyond the end of device");
-			clone = dm_start_request(md, rq);
-			dm_kill_unmapped_request(clone, -EIO);
+			dm_start_request(md, rq);
+			dm_kill_unmapped_request(rq, -EIO);
 			continue;
 		}
 
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
-		clone = dm_start_request(md, rq);
+		dm_start_request(md, rq);
 
 		tio = rq->special;
 		/* Establish tio->ti before queuing work (map_tio_request) */
@@ -2241,16 +2276,15 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 			bioset_free(md->bs);
 			md->bs = p->bs;
 			p->bs = NULL;
-		} else if (dm_table_get_type(t) == DM_TYPE_REQUEST_BASED) {
-			/*
-			 * There's no need to reload with request-based dm
-			 * because the size of front_pad doesn't change.
-			 * Note for future: If you are to reload bioset,
-			 * prep-ed requests in the queue may refer
-			 * to bio from the old bioset, so you must walk
-			 * through the queue to unprep.
-			 */
 		}
+		/*
+		 * There's no need to reload with request-based dm
+		 * because the size of front_pad doesn't change.
+		 * Note for future: If you are to reload bioset,
+		 * prep-ed requests in the queue may refer
+		 * to bio from the old bioset, so you must walk
+		 * through the queue to unprep.
+		 */
 		goto out;
 	}
 
@@ -2462,6 +2496,14 @@ unsigned dm_get_md_type(struct mapped_device *md)
 	return md->type;
 }
 
+static bool dm_md_type_request_based(struct mapped_device *md)
+{
+	unsigned table_type = dm_get_md_type(md);
+
+	return (table_type == DM_TYPE_REQUEST_BASED ||
+		table_type == DM_TYPE_MQ_REQUEST_BASED);
+}
+
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md)
 {
 	return md->immutable_target_type;
@@ -2514,8 +2556,7 @@ static int dm_init_request_based_queue(struct mapped_device *md)
  */
 int dm_setup_md_queue(struct mapped_device *md)
 {
-	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
-	    !dm_init_request_based_queue(md)) {
+	if (dm_md_type_request_based(md) && !dm_init_request_based_queue(md)) {
 		DMWARN("Cannot initialize queue for request-based mapped device");
 		return -EINVAL;
 	}
@@ -3187,27 +3228,35 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 {
 	struct dm_md_mempools *pools = kzalloc(sizeof(*pools), GFP_KERNEL);
 	struct kmem_cache *cachep;
-	unsigned int pool_size;
+	unsigned int pool_size = 0;
 	unsigned int front_pad;
 
 	if (!pools)
 		return NULL;
 
-	if (type == DM_TYPE_BIO_BASED) {
+	switch (type) {
+	case DM_TYPE_BIO_BASED:
 		cachep = _io_cache;
 		pool_size = dm_get_reserved_bio_based_ios();
 		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
-	} else if (type == DM_TYPE_REQUEST_BASED) {
-		cachep = _rq_tio_cache;
+		break;
+	case DM_TYPE_REQUEST_BASED:
 		pool_size = dm_get_reserved_rq_based_ios();
 		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
 		if (!pools->rq_pool)
 			goto out;
+		/* fall through to setup remaining rq-based pools */
+	case DM_TYPE_MQ_REQUEST_BASED:
+		cachep = _rq_tio_cache;
+		if (!pool_size)
+			pool_size = dm_get_reserved_rq_based_ios();
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
 		/* per_bio_data_size is not used. See __bind_mempools(). */
 		WARN_ON(per_bio_data_size != 0);
-	} else
+		break;
+	default:
 		goto out;
+	}
 
 	pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
 	if (!pools->io_pool)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 84b0f9e4..84d7978 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -34,9 +34,10 @@
 /*
  * Type of table and mapped_device's mempool
  */
-#define DM_TYPE_NONE		0
-#define DM_TYPE_BIO_BASED	1
-#define DM_TYPE_REQUEST_BASED	2
+#define DM_TYPE_NONE			0
+#define DM_TYPE_BIO_BASED		1
+#define DM_TYPE_REQUEST_BASED		2
+#define DM_TYPE_MQ_REQUEST_BASED	3
 
 /*
  * List of devices that a metadevice uses and should open/close.
@@ -73,6 +74,7 @@ int dm_table_any_busy_target(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
+bool dm_table_mq_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 19296fb..2646aed 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -48,6 +48,11 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio);
 typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
 				  union map_info *map_context);
+typedef int (*dm_clone_and_map_request_fn) (struct dm_target *ti,
+					    struct request *rq,
+					    union map_info *map_context,
+					    struct request **clone);
+typedef void (*dm_release_clone_request_fn) (struct request *clone);
 
 /*
  * Returns:
@@ -143,6 +148,8 @@ struct target_type {
 	dm_dtr_fn dtr;
 	dm_map_fn map;
 	dm_map_request_fn map_rq;
+	dm_clone_and_map_request_fn clone_and_map_rq;
+	dm_release_clone_request_fn release_clone_rq;
 	dm_endio_fn end_io;
 	dm_request_endio_fn rq_end_io;
 	dm_presuspend_fn presuspend;
-- 
1.9.3
