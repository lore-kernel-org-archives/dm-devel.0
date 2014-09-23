From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH] dm-mpath: Work with blk multi-queue drivers
Date: Tue, 23 Sep 2014 11:03:22 -0600
Message-ID: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

I'm working with multipathing nvme devices using the blk-mq version of
the nvme driver, but dm-mpath only works with the older request based
drivers. This patch proposes to enable dm-mpath to work with both types
of request queues and is succesfull with my dual ported nvme drives.

I think there may still be fix ups to do around submission side error
handling, but I think it's at a decent stopping point to solicit feedback
before I pursue taking it further. I hear there may be some resistance
to add blk-mq support to dm-mpath anyway, but it seems too easy to add
support to not at least try. :)

To work, this has dm allocate requests from the request_queue for
the device-mapper type rather than allocate one on its own, so the
cloned request is properly allocated and initialized for the device's
request_queue. The original request's 'special' now points to the
dm_rq_target_io rather than at the cloned request because the clone
is allocated later by the block layer rather than by dm, and then all
the other back referencing to the original seems to work out. The block
layer then inserts the cloned reqest using the appropriate function for
the request_queue type rather than just calling q->request_fn().

Compile tested on 3.17-rc6; runtime teseted on Matias Bjorling's
linux-collab nvmemq_review using 3.16.

Signed-off-by: Keith Busch <keith.busch@intel.com> Cc: Alasdair Kergon
<agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c              |    7 ++-
 block/blk-mq.c                |    1 +
 drivers/md/dm-mpath.c         |   15 ++++---
 drivers/md/dm-target.c        |    4 +-
 drivers/md/dm.c               |   96 ++++++++++++++++++-----------------------
 include/linux/device-mapper.h |    4 +-
 6 files changed, 62 insertions(+), 65 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf930f4..4c5952b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2031,6 +2031,11 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
 		return -EIO;
 
+	if (q->mq_ops) {
+		blk_mq_insert_request(rq, false, true, true);
+		return 0;
+	}
+
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (unlikely(blk_queue_dying(q))) {
 		spin_unlock_irqrestore(q->queue_lock, flags);
@@ -2928,8 +2933,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	if (!bs)
 		bs = fs_bio_set;
 
-	blk_rq_init(NULL, rq);
-
 	__rq_for_each_bio(bio_src, rq_src) {
 		bio = bio_clone_bioset(bio_src, gfp_mask, bs);
 		if (!bio)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383ea0c..eb53d1c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -172,6 +172,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	rq->nr_integrity_segments = 0;
 #endif
+	rq->bio = NULL;
 	rq->special = NULL;
 	/* tag was already set */
 	rq->errors = 0;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 833d7e7..efdc06b 100644
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
@@ -410,9 +411,11 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 		goto out_unlock;
 
 	bdev = pgpath->path.dev->bdev;
-	clone->q = bdev_get_queue(bdev);
-	clone->rq_disk = bdev->bd_disk;
-	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
+	*clone = blk_get_request(bdev_get_queue(bdev), rq_data_dir(rq),
+							GFP_KERNEL);
+	if (!(*clone))
+		goto out_unlock;
+	(*clone)->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	mpio = map_context->ptr;
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 242e3ce..2bcbf6e 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -131,8 +131,8 @@ static int io_err_map(struct dm_target *tt, struct bio *bio)
 	return -EIO;
 }
 
-static int io_err_map_rq(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
+static int io_err_map_rq(struct dm_target *ti, struct request *rq,
+			struct request **clone,  union map_info *map_context)
 {
 	return -EIO;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..4e49bd2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -77,7 +77,7 @@ struct dm_io {
 struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
-	struct request *orig, clone;
+	struct request *orig, *clone;
 	int error;
 	union map_info info;
 };
@@ -889,11 +889,13 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	dm_put(md);
 }
 
-static void free_rq_clone(struct request *clone)
+static void free_rq_clone(struct request *rq)
 {
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct dm_rq_target_io *tio = rq->special;
+	struct request *clone = tio->clone;
 
 	blk_rq_unprep_clone(clone);
+	blk_put_request(clone);
 	free_rq_tio(tio);
 }
 
@@ -921,14 +923,15 @@ static void dm_end_request(struct request *clone, int error)
 			rq->sense_len = clone->sense_len;
 	}
 
-	free_rq_clone(clone);
+	free_rq_clone(rq);
 	blk_end_request_all(rq, error);
 	rq_completed(md, rw, true);
 }
 
 static void dm_unprep_request(struct request *rq)
 {
-	struct request *clone = rq->special;
+	struct dm_rq_target_io *tio = rq->special;
+	struct request *clone = tio->clone;
 
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
@@ -1038,13 +1041,12 @@ static void dm_softirq_done(struct request *rq)
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
+	rq->completion_data = tio->clone;
 	blk_complete_request(rq);
 }
 
@@ -1054,13 +1056,10 @@ static void dm_complete_request(struct request *clone, int error)
  * Target's rq_end_io() function isn't called.
  * This may be used when the target's map_rq() function fails.
  */
-void dm_kill_unmapped_request(struct request *clone, int error)
+void dm_kill_unmapped_request(struct request *rq, int error)
 {
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
-
 	rq->cmd_flags |= REQ_FAILED;
-	dm_complete_request(clone, error);
+	dm_complete_request(rq, error);
 }
 EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
 
@@ -1069,13 +1068,8 @@ EXPORT_SYMBOL_GPL(dm_kill_unmapped_request);
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
@@ -1085,7 +1079,7 @@ static void end_clone_request(struct request *clone, int error)
 	 *     - the submission which requires queue lock may be done
 	 *       against this queue
 	 */
-	dm_complete_request(clone, error);
+	dm_complete_request(rq, error);
 }
 
 /*
@@ -1619,10 +1613,9 @@ static int setup_clone(struct request *clone, struct request *rq,
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
@@ -1635,14 +1628,7 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
 
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
@@ -1651,18 +1637,18 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
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
@@ -1673,14 +1659,24 @@ static int dm_prep_fn(struct request_queue *q, struct request *rq)
  * 0  : the request has been processed (not requeued)
  * !0 : the request has been requeued
  */
-static int map_request(struct dm_target *ti, struct request *clone,
-		       struct mapped_device *md)
+static int map_request(struct dm_target *ti, struct mapped_device *md,
+						struct request *rq)
 {
+	struct request *clone = NULL;
 	int r, requeued = 0;
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct dm_rq_target_io *tio = rq->special;
 
 	tio->ti = ti;
-	r = ti->type->map_rq(ti, clone, &tio->info);
+	r = ti->type->map_rq(ti, rq, &clone, &tio->info);
+	if (!clone)
+		return -ENOMEM;
+	if (setup_clone(clone, rq, tio)) {
+		blk_put_request(clone);
+		return -ENOMEM;
+	}
+	tio->clone = clone;
+	atomic_inc(&md->pending[rq_data_dir(clone)]);
+
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
@@ -1710,13 +1706,9 @@ static int map_request(struct dm_target *ti, struct request *clone,
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
@@ -1726,8 +1718,6 @@ static struct request *dm_start_request(struct mapped_device *md, struct request
 	 * See the comment in rq_completed() too.
 	 */
 	dm_get(md);
-
-	return clone;
 }
 
 /*
@@ -1740,7 +1730,7 @@ static void dm_request_fn(struct request_queue *q)
 	int srcu_idx;
 	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
-	struct request *rq, *clone;
+	struct request *rq;
 	sector_t pos;
 
 	/*
@@ -1766,18 +1756,18 @@ static void dm_request_fn(struct request_queue *q)
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
 
 		spin_unlock(q->queue_lock);
-		if (map_request(ti, clone, md))
+		if (map_request(ti, md, rq))
 			goto requeued;
 
 		BUG_ON(!irqs_disabled());
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e1707de..d9ac281 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -46,8 +46,8 @@ typedef void (*dm_dtr_fn) (struct dm_target *ti);
  * = 2: The target wants to push back the io
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio);
-typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
-				  union map_info *map_context);
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *rq,
+			struct request **clone, union map_info *map_context);
 
 /*
  * Returns:
-- 
1.7.10.4
