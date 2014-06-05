From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/7] dm: do not clone requests
Date: Thu,  5 Jun 2014 15:11:07 +0200
Message-ID: <1401973867-121561-8-git-send-email-hare@suse.de>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1401973867-121561-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Instead of cloning the request we should pass it down directly.
This saves a memory allocation and avoid the usage of the 'special'
pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 273 ++++++++++++--------------------------------------------
 1 file changed, 55 insertions(+), 218 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4da9941..5b0dc00 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -75,25 +75,13 @@ struct dm_io {
 struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
-	struct request *orig, clone;
+	struct request_queue *q;
+	rq_end_io_fn *end_io;
+	void *end_io_data;
 	int error;
 	union map_info info;
 };
 
-/*
- * For request-based dm - the bio clones we allocate are embedded in these
- * structs.
- *
- * We allocate these with bio_alloc_bioset, using the front_pad parameter when
- * the bioset is created - this means the bio has to come at the end of the
- * struct.
- */
-struct dm_rq_clone_bio_info {
-	struct bio *orig;
-	struct dm_rq_target_io *tio;
-	struct bio clone;
-};
-
 union map_info *dm_get_rq_mapinfo(struct request *rq)
 {
 	if (rq && rq->end_io_data)
@@ -788,57 +776,6 @@ static void clone_endio(struct bio *bio, int error)
 }
 
 /*
- * Partial completion handling for request-based dm
- */
-static void end_clone_bio(struct bio *clone, int error)
-{
-	struct dm_rq_clone_bio_info *info =
-		container_of(clone, struct dm_rq_clone_bio_info, clone);
-	struct dm_rq_target_io *tio = info->tio;
-	struct bio *bio = info->orig;
-	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
-
-	bio_put(clone);
-
-	if (tio->error)
-		/*
-		 * An error has already been detected on the request.
-		 * Once error occurred, just let clone->end_io() handle
-		 * the remainder.
-		 */
-		return;
-	else if (error) {
-		/*
-		 * Don't notice the error to the upper layer yet.
-		 * The error handling decision is made by the target driver,
-		 * when the request is completed.
-		 */
-		tio->error = error;
-		return;
-	}
-
-	/*
-	 * I/O for the bio successfully completed.
-	 * Notice the data completion to the upper layer.
-	 */
-
-	/*
-	 * bios are processed from the head of the list.
-	 * So the completing bio should always be rq->bio.
-	 * If it's not, something wrong is happening.
-	 */
-	if (tio->orig->bio != bio)
-		DMERR("bio completion is going in the middle of the request");
-
-	/*
-	 * Update the original request.
-	 * Do not use blk_end_request() here, because it may complete
-	 * the original request before the clone, and break the ordering.
-	 */
-	blk_update_request(tio->orig, 0, nr_bytes);
-}
-
-/*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
  * Or do dm_get() before calling this function and dm_put() later.
@@ -867,35 +804,6 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 }
 
 /*
- * Complete the clone and the original request.
- * Must be called without queue lock.
- */
-static void dm_end_request(struct request *clone, struct request *rq,
-			   int error)
-{
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		rq->errors = clone->errors;
-		rq->resid_len = clone->resid_len;
-
-		if (rq->sense)
-			/*
-			 * We are using the sense buffer of the original
-			 * request.
-			 * So setting the length of the sense data is enough.
-			 */
-			rq->sense_len = clone->sense_len;
-	}
-
-	blk_end_request_all(rq, error);
-}
-
-static void dm_unprep_request(struct request *rq)
-{
-	rq->special = NULL;
-	rq->cmd_flags &= ~REQ_DONTPREP;
-}
-
-/*
  * Requeue the original request of a clone.
  */
 void dm_requeue_unmapped_request(struct request *rq)
@@ -903,8 +811,6 @@ void dm_requeue_unmapped_request(struct request *rq)
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	dm_unprep_request(rq);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -940,32 +846,29 @@ static void start_queue(struct request_queue *q)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
+static void dm_done(struct request *rq, struct dm_rq_target_io *tio,
 		    bool mapped)
 {
 	int r = tio->error;
 	dm_request_endio_fn rq_end_io = NULL;
 	struct mapped_device *md = tio->md;
-	struct request *rq = tio->orig;
-	int rw = rq_data_dir(clone);
+	int rw = rq_data_dir(rq);
 
 	if (tio->ti) {
 		rq_end_io = tio->ti->type->rq_end_io;
 
 		if (mapped && rq_end_io)
-			r = rq_end_io(tio->ti, clone, tio->error, &tio->info);
+			r = rq_end_io(tio->ti, rq, tio->error, &tio->info);
 	}
 
 	free_rq_tio(tio);
 	if (r <= 0) {
 		/* The target wants to complete the I/O */
-		dm_end_request(clone, rq, r);
-		blk_rq_unprep_clone(clone);
+		blk_end_request_all(rq, r);
 		rq_completed(md, rw, true);
 	} else if (r == DM_ENDIO_REQUEUE) {
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(rq);
-		blk_rq_unprep_clone(clone);
 		rq_completed(md, rw, false);
 	} else {
 		DMWARN("unimplemented target endio return value: %d", r);
@@ -979,54 +882,38 @@ static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
 static void dm_softirq_done(struct request *rq)
 {
 	bool mapped = true;
-	struct request *clone = rq->completion_data;
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct dm_rq_target_io *tio = rq->completion_data;
 
-	if (rq->cmd_flags & REQ_FAILED)
+	if (rq->cmd_flags & REQ_FAILED) {
 		mapped = false;
+		rq->cmd_flags &= ~REQ_FAILED;
+	}
 
-	dm_done(clone, tio, mapped);
+	dm_done(rq, tio, mapped);
 }
 
 /*
- * Complete the clone and the original request with the error status
+ * Complete the remapped request with the error status
  * through softirq context.
+ *
+ * Called with the queue lock held
  */
-static void dm_complete_request(struct request *clone, int error)
+static void dm_complete_request(struct request *rq, int error)
 {
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
+	struct dm_rq_target_io *tio = rq->end_io_data;
 
 	tio->error = error;
-	rq->completion_data = clone;
+	rq->completion_data = tio;
+	rq->end_io = tio->end_io;
+	rq->end_io_data = tio->end_io_data;
+	rq->q = tio->q;
+	tio->end_io = NULL;
+	tio->end_io_data = NULL;
+	tio->q = NULL;
 	blk_complete_request(rq);
 }
 
 /*
- * Called with the queue lock held
- */
-static void end_clone_request(struct request *clone, int error)
-{
-	/*
-	 * For just cleaning up the information of the queue in which
-	 * the clone was dispatched.
-	 * The clone is *NOT* freed actually here because it is alloced from
-	 * dm own mempool and REQ_ALLOCED isn't set in clone->cmd_flags.
-	 */
-	__blk_put_request(clone->q, clone);
-
-	/*
-	 * Actual request completion is done in a softirq context which doesn't
-	 * hold the queue lock.  Otherwise, deadlock could occur because:
-	 *     - another request may be submitted by the upper level driver
-	 *       of the stacking during the completion
-	 *     - the submission which requires queue lock may be done
-	 *       against this queue
-	 */
-	dm_complete_request(clone, error);
-}
-
-/*
  * Return maximum size of I/O possible at the supplied sector up to the current
  * target boundary.
  */
@@ -1482,64 +1369,27 @@ void dm_dispatch_request(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
-static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
-				 void *data)
+static int setup_rq(struct request *rq, struct mapped_device *md,
+		    gfp_t gfp_mask)
 {
-	struct dm_rq_target_io *tio = data;
-	struct dm_rq_clone_bio_info *info =
-		container_of(bio, struct dm_rq_clone_bio_info, clone);
-
-	info->orig = bio_orig;
-	info->tio = tio;
-	bio->bi_end_io = end_clone_bio;
-
-	return 0;
-}
-
-static int setup_clone(struct request *clone, struct request *rq,
-		       struct dm_rq_target_io *tio)
-{
-	int r;
-
-	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
-			      dm_rq_bio_constructor, tio);
-	if (r)
-		return r;
-
-	clone->cmd = rq->cmd;
-	clone->cmd_len = rq->cmd_len;
-	clone->sense = rq->sense;
-	clone->buffer = rq->buffer;
-	clone->end_io = end_clone_request;
-	clone->end_io_data = tio;
-
-	return 0;
-}
-
-static struct request *clone_rq(struct request *rq, struct mapped_device *md,
-				gfp_t gfp_mask)
-{
-	struct request *clone;
 	struct dm_rq_target_io *tio;
 
 	tio = alloc_rq_tio(md, gfp_mask);
 	if (!tio)
-		return NULL;
+		return -ENOMEM;
 
 	tio->md = md;
 	tio->ti = NULL;
-	tio->orig = rq;
+	tio->q = rq->q;
+	tio->end_io = rq->end_io;
+	tio->end_io_data = rq->end_io_data;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
 
-	clone = &tio->clone;
-	if (setup_clone(clone, rq, tio)) {
-		/* -ENOMEM */
-		free_rq_tio(tio);
-		return NULL;
-	}
+	rq->end_io = dm_complete_request;
+	rq->end_io_data = tio;
 
-	return clone;
+	return 0;
 }
 
 /*
@@ -1548,18 +1398,10 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 static int dm_prep_fn(struct request_queue *q, struct request *rq)
 {
 	struct mapped_device *md = q->queuedata;
-	struct request *clone;
 
-	if (unlikely(rq->special)) {
-		DMWARN("Already has something in rq->special.");
-		return BLKPREP_KILL;
-	}
-
-	clone = clone_rq(rq, md, GFP_ATOMIC);
-	if (!clone)
+	if (setup_rq(rq, md, GFP_ATOMIC) < 0)
 		return BLKPREP_DEFER;
 
-	rq->special = clone;
 	rq->cmd_flags |= REQ_DONTPREP;
 
 	return BLKPREP_OK;
@@ -1570,30 +1412,28 @@ static int dm_prep_fn(struct request_queue *q, struct request *rq)
  * 0  : the request has been processed (not requeued)
  * !0 : the request has been requeued
  */
-static int map_request(struct dm_target *ti, struct request *clone,
+static int map_request(struct dm_target *ti, struct request *rq,
 		       struct mapped_device *md)
 {
 	int r, requeued = 0;
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
-	int rw = rq_data_dir(clone);
+	struct dm_rq_target_io *tio = rq->end_io_data;
+	int rw = rq_data_dir(rq);
 
 	tio->ti = ti;
-	r = ti->type->map_rq(ti, clone, &tio->info);
+	r = ti->type->map_rq(ti, rq, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
 		/* The target has taken the I/O to submit by itself later */
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
-		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
+		trace_block_rq_remap(rq->q, rq, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
-		dm_dispatch_request(clone);
+		dm_dispatch_request(rq);
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
 		free_rq_tio(tio);
-		blk_rq_unprep_clone(clone);
 		dm_requeue_unmapped_request(rq);
 		rq_completed(md, rw, false);
 		requeued = 1;
@@ -1606,20 +1446,17 @@ static int map_request(struct dm_target *ti, struct request *clone,
 
 		/* The target wants to complete the I/O */
 		rq->cmd_flags |= REQ_FAILED;
-		dm_complete_request(clone, r);
+		dm_complete_request(rq, r);
 		break;
 	}
 
 	return requeued;
 }
 
-static struct request *dm_start_request(struct mapped_device *md, struct request *orig)
+static void dm_start_request(struct mapped_device *md, struct request *rq)
 {
-	struct request *clone;
-
-	blk_start_request(orig);
-	clone = orig->special;
-	atomic_inc(&md->pending[rq_data_dir(clone)]);
+	blk_start_request(rq);
+	atomic_inc(&md->pending[rq_data_dir(rq)]);
 
 	/*
 	 * Hold the md reference here for the in-flight I/O.
@@ -1629,8 +1466,6 @@ static struct request *dm_start_request(struct mapped_device *md, struct request
 	 * See the comment in rq_completed() too.
 	 */
 	dm_get(md);
-
-	return clone;
 }
 
 /*
@@ -1643,7 +1478,7 @@ static void dm_request_fn(struct request_queue *q)
 	int srcu_idx;
 	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
-	struct request *rq, *clone;
+	struct request *rq;
 	sector_t pos;
 
 	/*
@@ -1669,19 +1504,19 @@ static void dm_request_fn(struct request_queue *q)
 			 * before calling dm_complete_request
 			 */
 			DMERR_LIMIT("request attempted access beyond the end of device");
-			clone = dm_start_request(md, rq);
+			dm_start_request(md, rq);
 			rq->cmd_flags |= REQ_FAILED;
-			dm_complete_request(clone, -EIO);
+			dm_complete_request(rq, -EIO);
 			continue;
 		}
 
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
-		clone = dm_start_request(md, rq);
+		dm_start_request(md, rq);
 
 		spin_unlock(q->queue_lock);
-		if (map_request(ti, clone, md))
+		if (map_request(ti, rq, md))
 			goto requeued;
 
 		BUG_ON(!irqs_disabled());
@@ -2794,7 +2629,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 	} else if (type == DM_TYPE_REQUEST_BASED) {
 		cachep = _rq_tio_cache;
 		pool_size = dm_get_reserved_rq_based_ios();
-		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
+		front_pad = 0;
 		/* per_bio_data_size is not used. See __bind_mempools(). */
 		WARN_ON(per_bio_data_size != 0);
 	} else
@@ -2804,9 +2639,11 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 	if (!pools->io_pool)
 		goto out;
 
-	pools->bs = bioset_create(pool_size, front_pad);
-	if (!pools->bs)
-		goto out;
+	if (front_pad) {
+		pools->bs = bioset_create(pool_size, front_pad);
+		if (!pools->bs)
+			goto out;
+	}
 
 	if (integrity && bioset_integrity_create(pools->bs, pool_size))
 		goto out;
-- 
1.7.12.4
