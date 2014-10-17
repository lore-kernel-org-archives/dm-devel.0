From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 3/4] dm: Move request allocation to dm_target
	type
Date: Fri, 17 Oct 2014 17:46:37 -0600
Message-ID: <1413589598-17631-4-git-send-email-keith.busch@intel.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This moves the responsibility of allocating a cloned request from dm
to the target type so that the cloned request is allocated from the
appropriate request_queue's pool and initialized for the target block
device. The original request's 'special' now points to the dm_rq_target_io
because the clone is allocated later in the block layer rather than in
dm. All the back references to the original will then work much as before.

Since the previous patch move the mapping into an interrupt safe context,
any allocations can be safely done in GFP_KERNEL context.

Since the responsibility for allocating the request is moved to the
target's map_rq function, it has to take responisbility for releasing
the request when completed by dm, so this adds a new unmap_rq function
for target types to implement.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/md/dm-mpath.c         |   22 ++++++--
 drivers/md/dm-target.c        |    9 ++-
 drivers/md/dm.c               |  125 ++++++++++++++++++-----------------------
 include/linux/device-mapper.h |    7 ++-
 4 files changed, 82 insertions(+), 81 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 833d7e7..10fd340 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -11,6 +11,7 @@
 #include "dm-path-selector.h"
 #include "dm-uevent.h"
 
+#include <linux/blkdev.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/mempool.h>
@@ -376,12 +377,12 @@ static int __must_push_back(struct multipath *m)
 /*
  * Map cloned requests
  */
-static int multipath_map(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
+static int multipath_map(struct dm_target *ti, struct request *rq,
+		struct request **clone, union map_info *map_context)
 {
 	struct multipath *m = (struct multipath *) ti->private;
 	int r = DM_MAPIO_REQUEUE;
-	size_t nr_bytes = blk_rq_bytes(clone);
+	size_t nr_bytes = blk_rq_bytes(rq);
 	unsigned long flags;
 	struct pgpath *pgpath;
 	struct block_device *bdev;
@@ -410,9 +411,12 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 		goto out_unlock;
 
 	bdev = pgpath->path.dev->bdev;
-	clone->q = bdev_get_queue(bdev);
-	clone->rq_disk = bdev->bd_disk;
-	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	*clone = blk_get_request(bdev_get_queue(bdev), rq_data_dir(rq),
+							GFP_KERNEL);
+	if (!*clone)
+		goto out_unlock;
+	(*clone)->bio = NULL;
+	(*clone)->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	mpio = map_context->ptr;
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
@@ -428,6 +432,11 @@ out_unlock:
 	return r;
 }
 
+static void multipath_unmap(struct request *clone)
+{
+	blk_put_request(clone);
+}
+
 /*
  * If we run out of usable paths, should we queue I/O or error it?
  */
@@ -1669,6 +1678,7 @@ static struct target_type multipath_target = {
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
 	.map_rq = multipath_map,
+	.unmap_rq = multipath_unmap,
 	.rq_end_io = multipath_end_io,
 	.presuspend = multipath_presuspend,
 	.postsuspend = multipath_postsuspend,
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 242e3ce..32fa435 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -131,12 +131,16 @@ static int io_err_map(struct dm_target *tt, struct bio *bio)
 	return -EIO;
 }
 
-static int io_err_map_rq(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
+static int io_err_map_rq(struct dm_target *ti, struct request *rq,
+			 struct request **clone, union map_info *map_context)
 {
 	return -EIO;
 }
 
+static void io_err_unmap_rq(struct request *clone)
+{
+}
+
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 2, 0},
@@ -144,6 +148,7 @@ static struct target_type error_target = {
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
 	.map_rq = io_err_map_rq,
+	.unmap_rq = io_err_unmap_rq,
 };
 
 int __init dm_target_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 88a73be..944b133 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -80,7 +80,7 @@ struct dm_io {
 struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
-	struct request *orig, clone;
+	struct request *orig, *clone;
 	struct kthread_work work;
 	int error;
 	union map_info info;
@@ -901,6 +901,7 @@ static void free_rq_clone(struct request *clone)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	blk_rq_unprep_clone(clone);
+	tio->ti->type->unmap_rq(clone);
 	free_rq_tio(tio);
 }
 
@@ -935,7 +936,8 @@ static void dm_end_request(struct request *clone, int error)
 
 static void dm_unprep_request(struct request *rq)
 {
-	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = rq->special;
+	struct request *clone = tio->clone;
 
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
@@ -1032,8 +1034,14 @@ static void dm_done(struct request *clone, int error, bool mapped)
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
+		free_rq_tio(tio);
+		return;
+	}
 
 	if (rq->cmd_flags & REQ_FAILED)
 		mapped = false;
@@ -1045,44 +1053,21 @@ static void dm_softirq_done(struct request *rq)
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
 
 /*
- * Complete the not-mapped clone and the original request with the error status
- * through softirq context.
- * Target's rq_end_io() function isn't called.
- * This may be used when the target's map_rq() function fails.
- */
-void dm_kill_unmapped_request(struct request *clone, int error)
-{
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
-
-	rq->cmd_flags |= REQ_FAILED;
-	dm_complete_request(clone, error);
-}
-EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
-
-/*
  * Called with the queue lock held
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
+	struct request *rq = tio->orig;
 
 	/*
 	 * Actual request completion is done in a softirq context which doesn't
@@ -1092,7 +1077,7 @@ static void end_clone_request(struct request *clone, int error)
 	 *     - the submission which requires queue lock may be done
 	 *       against this queue
 	 */
-	dm_complete_request(clone, error);
+	dm_complete_request(rq, error);
 }
 
 /*
@@ -1612,8 +1597,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
-	blk_rq_init(NULL, rq);
-	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
+	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_KERNEL,
 			      dm_rq_bio_constructor, tio);
 	if (r)
 		return r;
@@ -1627,10 +1611,9 @@ static int setup_clone(struct request *clone, struct request *rq,
 	return 0;
 }
 
-static struct request *clone_rq(struct request *rq, struct mapped_device *md,
-				gfp_t gfp_mask)
+static struct dm_rq_target_io *prep_tio(struct request *rq,
+			struct mapped_device *md, gfp_t gfp_mask)
 {
-	struct request *clone;
 	struct dm_rq_target_io *tio;
 
 	tio = alloc_rq_tio(md, gfp_mask);
@@ -1639,19 +1622,13 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 
 	tio->md = md;
 	tio->ti = NULL;
+	tio->clone = NULL;
 	tio->orig = rq;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
 	init_kthread_work(&tio->work, map_tio_request);
 
-	clone = &tio->clone;
-	if (setup_clone(clone, rq, tio)) {
-		/* -ENOMEM */
-		free_rq_tio(tio);
-		return NULL;
-	}
-
-	return clone;
+	return tio;
 }
 
 /*
@@ -1660,18 +1637,18 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
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
@@ -1682,14 +1659,23 @@ static int dm_prep_fn(struct request_queue *q, struct request *rq)
  * 0  : the request has been processed (not requeued)
  * !0 : the request has been requeued
  */
-static int map_request(struct dm_target *ti, struct request *clone,
+static int map_request(struct dm_target *ti, struct request *rq,
 		       struct mapped_device *md)
 {
+	struct request *clone = NULL;
 	int r, requeued = 0;
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct dm_rq_target_io *tio = rq->special;
+
+	r = ti->type->map_rq(ti, rq, &clone, &tio->info);
+	if (!clone)
+		return -ENOMEM;
+	if (setup_clone(clone, rq, tio)) {
+		tio->ti->type->unmap_rq(clone);
+		return -ENOMEM;
+	}
+	tio->clone = clone;
+	atomic_inc(&md->pending[rq_data_dir(clone)]);
 
-	tio->ti = ti;
-	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
@@ -1712,20 +1698,17 @@ static int map_request(struct dm_target *ti, struct request *clone,
 		}
 
 		/* The target wants to complete the I/O */
-		dm_kill_unmapped_request(clone, r);
+		rq->cmd_flags |= REQ_FAILED;
+		dm_complete_request(rq, r);
 		break;
 	}
 
 	return requeued;
 }
 
-static struct request *dm_start_request(struct mapped_device *md, struct request *orig)
+static void dm_start_request(struct mapped_device *md, struct request *orig)
 {
-	struct request *clone;
-
 	blk_start_request(orig);
-	clone = orig->special;
-	atomic_inc(&md->pending[rq_data_dir(clone)]);
 
 	/*
 	 * Hold the md reference here for the in-flight I/O.
@@ -1735,15 +1718,20 @@ static struct request *dm_start_request(struct mapped_device *md, struct request
 	 * See the comment in rq_completed() too.
 	 */
 	dm_get(md);
-
-	return clone;
 }
 
 static void map_tio_request(struct kthread_work *work)
 {
 	struct dm_rq_target_io *tio = container_of(work, struct dm_rq_target_io,
 									work);
-	map_request(tio->ti, &tio->clone, tio->md);
+	struct request *rq = tio->orig;
+
+	if (map_request(tio->ti, rq, tio->md) < 0) {
+		/* requeue prepped request */
+		spin_lock_irq(rq->q->queue_lock);
+		blk_requeue_request(rq->q, rq);
+		spin_unlock_irq(rq->q->queue_lock);
+	}
 }
 
 /*
@@ -1756,7 +1744,7 @@ static void dm_request_fn(struct request_queue *q)
 	int srcu_idx;
 	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
-	struct request *rq, *clone;
+	struct request *rq;
 	struct dm_rq_target_io *tio;
 	sector_t pos;
 
@@ -1776,24 +1764,19 @@ static void dm_request_fn(struct request_queue *q)
 		if (!(rq->cmd_flags & REQ_FLUSH))
 			pos = blk_rq_pos(rq);
 
+		tio = rq->special;
 		ti = dm_table_find_target(map, pos);
 		if (!dm_target_is_valid(ti)) {
-			/*
-			 * Must perform setup, that dm_done() requires,
-			 * before calling dm_kill_unmapped_request
-			 */
 			DMERR_LIMIT("request attempted access beyond the end of device");
-			clone = dm_start_request(md, rq);
-			dm_kill_unmapped_request(clone, -EIO);
+			dm_complete_request(rq, -EIO);
 			continue;
 		}
 
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
-		clone = dm_start_request(md, rq);
+		dm_start_request(md, rq);
 
-		tio = rq->special;
 		tio->ti = ti;
 		queue_kthread_work(&md->kworker, &tio->work);
 		BUG_ON(!irqs_disabled());
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e1707de..90a4774 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -46,8 +46,10 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
  * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio);
-typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
-				  union map_info *map_context);
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *rq,
+			struct request **clone, union map_info *map_context);
+
+typedef void (*dm_unmap_request_fn) (struct request *clone);
 
 /*
  * Returns:
@@ -142,6 +144,7 @@ struct target_type {
 	dm_dtr_fn dtr;
 	dm_map_fn map;
 	dm_map_request_fn map_rq;
+	dm_unmap_request_fn unmap_rq;
 	dm_endio_fn end_io;
 	dm_request_endio_fn rq_end_io;
 	dm_presuspend_fn presuspend;
-- 
1.7.10.4
