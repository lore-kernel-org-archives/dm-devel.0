From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm: barrier support for request-based dm
Date: Thu, 17 Sep 2009 10:05:45 +0900
Message-ID: <4AB18B69.6030409@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

(Resending since the patchwork mis-catched this patch.)

This patch adds barrier support for request-based dm.
The patch depends on 2.6.31 + the 2 patches below:
  - http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=a9327cac440be4d8333bba975cbbf76045096275
    (Seperate read and write statistics of in_flight requests)
  - http://patchwork.kernel.org/patch/40809/
    (Simplify suspend code of request-based dm)

I know this patch introduces some code duplications between
normal I/O and barrier I/O:
  - In-flight I/O counting
  - Clone (target_io) allocation
  - Clone completion code
I believe cleaning them up won't include ABI/API change.
So it should be safe to take this patch in for 2.6.32 now.
To get the barrier feature in 2.6.32, please consider to push this
(and the suspend patch above) to 2.6.32.
I'll follow up with clean-up patches based on this patch.

See below for the patch description.

CORE DESIGN

The design is basically same as bio-based dm, which emulates barrier
by mapping empty barrier bios before/after a barrier I/O.
But request-based dm has been using struct request_queue for I/O
queueing, so the block-layer's barrier mechanism can be used.

o Summary of the block-layer's behavior (which is depended by dm-core)
  Request-based dm uses QUEUE_ORDERED_DRAIN_FLUSH ordered mode for
  I/O barrier.  It means that when an I/O requiring barrier is found
  in the request_queue, the block-layer makes pre-flush request and
  post-flush request just before and just after the I/O respectively.

  After the ordered sequence starts, the block-layer waits for all
  in-flight I/Os to complete, then gives drivers the pre-flush request,
  the barrier I/O and the post-flush request one by one.
  It means that the request_queue is stopped automatically by
  the block-layer until drivers complete each sequence.

o dm-core
  For the barrier I/O, treats it as a normal I/O, so no code is needed.

  For the pre/post-flush request, flushes caches by the followings:
    1. Make the number of empty barrier requests required by target's
       num_flush_requests, and map them (dm_rq_barrier()).
       (Use md->pending for accounting those dm-internal empty barriers.)
    2. Waits for the mapped barriers to complete (dm_rq_barrier()).
       If error has occurred, save the error value to md->barrier_error
       (barrier_completed()).
       (*) Basically, the first reported error is taken.
           But -EOPNOTSUPP supersedes any error and DM_ENDIO_REQUEUE
           follows.
    3. Requeue the pre/post-flush request if the error value is
       DM_ENDIO_REQUEUE.  Otherwise, completes with the error value
       (dm_rq_barrier_work()).
  The pre/post-flush work above is done in the kernel thread (kdmflush)
  context, since memory allocation which might sleep is needed in
  dm_rq_barrier() but sleep is not allowed in dm_request_fn(), which is
  an irq-disabled context.

  For suspend, the workqueue of kdmflush needs to be flushed after
  the request_queue has been stopped.  Otherwise, the next flush work
  can be kicked even after the suspend completes.


TARGET INTERFACE

No new interface is added.
Just use the existing num_flush_requests in struct target_type
as same as bio-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |  304 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 263 insertions(+), 41 deletions(-)

Index: 2.6.31/drivers/md/dm.c
===================================================================
--- 2.6.31.orig/drivers/md/dm.c
+++ 2.6.31/drivers/md/dm.c
@@ -142,9 +142,19 @@ struct mapped_device {
 	int barrier_error;
 
 	/*
+	 * Protect barrier_error from concurrent endio processing
+	 * in request-based dm.
+	 */
+	spinlock_t barrier_error_lock;
+
+	/*
 	 * Processing queue (flush/barriers)
 	 */
 	struct workqueue_struct *wq;
+	struct work_struct barrier_work;
+
+	/* A pointer to the currently processing pre/post flush request */
+	struct request *flush_request;
 
 	/*
 	 * The current mapping.
@@ -431,6 +441,11 @@ static struct dm_rq_target_io *alloc_rq_
 	return mempool_alloc(md->tio_pool, GFP_ATOMIC);
 }
 
+static struct dm_rq_target_io *alloc_rq_tio_wait(struct mapped_device *md)
+{
+	return mempool_alloc(md->tio_pool, GFP_NOIO);
+}
+
 static void free_rq_tio(struct dm_rq_target_io *tio)
 {
 	mempool_free(tio, tio->md->tio_pool);
@@ -709,6 +724,42 @@ static void end_clone_bio(struct bio *cl
 }
 
 /*
+ * In request-based dm, original and clone have 1:1 relationship in general.
+ * However, barrier is a special case where the relationship is 1:n.
+ * Hence it needs to handle clones' error codes and in-flight accounting
+ * differently.
+ * barrier_completed() takes care of such a special case handling.
+ */
+static void barrier_completed(struct mapped_device *md, int error, int rw)
+{
+	unsigned long flags;
+
+	if (error) {
+		spin_lock_irqsave(&md->barrier_error_lock, flags);
+		/*
+		 * Basically, the first error is taken, but:
+		 *   -EOPNOTSUPP supersedes any I/O error.
+		 *   Requeue request supersedes any I/O error but -EOPNOTSUPP.
+		 */
+		if (!md->barrier_error || error == -EOPNOTSUPP ||
+		    (md->barrier_error != -EOPNOTSUPP &&
+		     error == DM_ENDIO_REQUEUE))
+			md->barrier_error = error;
+		spin_unlock_irqrestore(&md->barrier_error_lock, flags);
+	}
+
+	/*
+	 * Nudge anyone waiting for flushes of all underlying devices
+	 * to complete.
+	 */
+	if (!atomic_dec_return(&md->pending[rw]) &&
+	    !atomic_read(&md->pending[rw^0x1]))
+		wake_up(&md->wait);
+
+	dm_put(md);
+}
+
+/*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
  * Or do dm_get() before calling this function and dm_put() later.
@@ -745,6 +796,41 @@ static void free_rq_clone(struct request
 	free_rq_tio(tio);
 }
 
+/*
+ * Complete the clone and the original request.
+ * Must be called without queue lock.
+ */
+static void dm_end_request(struct request *clone, int error)
+{
+	int rw = rq_data_dir(clone);
+	bool is_barrier = blk_barrier_rq(clone);
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
+
+	if (blk_pc_request(rq) && !is_barrier) {
+		rq->errors = clone->errors;
+		rq->resid_len = clone->resid_len;
+
+		if (rq->sense)
+			/*
+			 * We are using the sense buffer of the original
+			 * request.
+			 * So setting the length of the sense data is enough.
+			 */
+			rq->sense_len = clone->sense_len;
+	}
+
+	free_rq_clone(clone);
+
+	if (unlikely(is_barrier))
+		barrier_completed(md, error, rw);
+	else {
+		blk_end_request_all(rq, error);
+		rq_completed(md, 1);
+	}
+}
+
 static void dm_unprep_request(struct request *rq)
 {
 	struct request *clone = rq->special;
@@ -766,6 +852,16 @@ void dm_requeue_unmapped_request(struct 
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
+	if (unlikely(blk_barrier_rq(clone))) {
+		/*
+		 * Barrier clones share a original request.
+		 * Leave it to dm_end_request(), which handles this special
+		 * case.
+		 */
+		dm_end_request(clone, DM_ENDIO_REQUEUE);
+		return;
+	}
+
 	dm_unprep_request(rq);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -808,36 +904,6 @@ static void start_queue(struct request_q
 }
 
 /*
- * Complete the clone and the original request.
- * Must be called without queue lock.
- */
-static void dm_end_request(struct request *clone, int error)
-{
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
-	struct request *rq = tio->orig;
-
-	if (blk_pc_request(rq)) {
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
-	free_rq_clone(clone);
-
-	blk_end_request_all(rq, error);
-
-	rq_completed(md, 1);
-}
-
-/*
  * Request completion handler for request-based dm
  */
 static void dm_softirq_done(struct request *rq)
@@ -890,6 +956,17 @@ void dm_kill_unmapped_request(struct req
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct request *rq = tio->orig;
 
+	if (unlikely(blk_barrier_rq(clone))) {
+		/*
+		 * Barrier clones share a original request.
+		 * Leave it to dm_end_request(), which handles this special
+		 * case.
+		 */
+		BUG_ON(error > 0);
+		dm_end_request(clone, error);
+		return;
+	}
+
 	rq->cmd_flags |= REQ_FAILED;
 	dm_complete_request(clone, error);
 }
@@ -1343,11 +1420,6 @@ static int dm_make_request(struct reques
 {
 	struct mapped_device *md = q->queuedata;
 
-	if (unlikely(bio_barrier(bio))) {
-		bio_endio(bio, -EOPNOTSUPP);
-		return 0;
-	}
-
 	return md->saved_make_request_fn(q, bio); /* call __make_request() */
 }
 
@@ -1366,6 +1438,25 @@ static int dm_request(struct request_que
 	return _dm_request(q, bio);
 }
 
+/*
+ * Mark this request as flush request, so that dm_request_fn() can
+ * recognize.
+ */
+static void dm_rq_prepare_flush(struct request_queue *q, struct request *rq)
+{
+	rq->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	rq->cmd[0] = REQ_LB_OP_FLUSH;
+}
+
+static bool dm_rq_is_flush_request(struct request *rq)
+{
+	if (rq->cmd_type == REQ_TYPE_LINUX_BLOCK &&
+	    rq->cmd[0] == REQ_LB_OP_FLUSH)
+		return true;
+	else
+		return false;
+}
+
 void dm_dispatch_request(struct request *rq)
 {
 	int r;
@@ -1436,6 +1527,9 @@ static int dm_prep_fn(struct request_que
 	struct dm_rq_target_io *tio;
 	struct request *clone;
 
+	if (unlikely(dm_rq_is_flush_request(rq)))
+		return BLKPREP_OK;
+
 	if (unlikely(rq->special)) {
 		DMWARN("Already has something in rq->special.");
 		return BLKPREP_KILL;
@@ -1465,11 +1559,10 @@ static int dm_prep_fn(struct request_que
 	return BLKPREP_OK;
 }
 
-static void map_request(struct dm_target *ti, struct request *rq,
+static void map_request(struct dm_target *ti, struct request *clone,
 			struct mapped_device *md)
 {
 	int r;
-	struct request *clone = rq->special;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	/*
@@ -1528,13 +1621,21 @@ static void dm_request_fn(struct request
 		if (!rq)
 			goto plug_and_out;
 
+		if (unlikely(dm_rq_is_flush_request(rq))) {
+			BUG_ON(md->flush_request);
+			md->flush_request = rq;
+			blk_start_request(rq);
+			queue_work(md->wq, &md->barrier_work);
+			goto out;
+		}
+
 		ti = dm_table_find_target(map, blk_rq_pos(rq));
 		if (ti->type->busy && ti->type->busy(ti))
 			goto plug_and_out;
 
 		blk_start_request(rq);
 		spin_unlock(q->queue_lock);
-		map_request(ti, rq, md);
+		map_request(ti, rq->special, md);
 		spin_lock_irq(q->queue_lock);
 	}
 
@@ -1691,6 +1792,7 @@ out:
 static struct block_device_operations dm_blk_dops;
 
 static void dm_wq_work(struct work_struct *work);
+static void dm_rq_barrier_work(struct work_struct *work);
 
 /*
  * Allocate and initialise a blank device with a given minor.
@@ -1720,6 +1822,7 @@ static struct mapped_device *alloc_dev(i
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
 	spin_lock_init(&md->deferred_lock);
+	spin_lock_init(&md->barrier_error_lock);
 	rwlock_init(&md->map_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
@@ -1754,6 +1857,8 @@ static struct mapped_device *alloc_dev(i
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
+	blk_queue_ordered(md->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+			  dm_rq_prepare_flush);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -1763,6 +1868,7 @@ static struct mapped_device *alloc_dev(i
 	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
+	INIT_WORK(&md->barrier_work, dm_rq_barrier_work);
 	init_waitqueue_head(&md->eventq);
 
 	md->disk->major = _major;
@@ -2058,7 +2164,9 @@ static int dm_wait_for_completion(struct
 		smp_mb();
 		if (dm_request_based(md)) {
 			spin_lock_irqsave(q->queue_lock, flags);
-			if (!queue_in_flight(q)) {
+			if (!queue_in_flight(q) &&
+			    !atomic_read(&md->pending[0]) &&
+			    !atomic_read(&md->pending[1])) {
 				spin_unlock_irqrestore(q->queue_lock, flags);
 				break;
 			}
@@ -2160,6 +2268,115 @@ static void dm_queue_flush(struct mapped
 }
 
 /*
+ * Special end_io handler for barrier clones.
+ * They share a original request and can't use dm_complete_request().
+ */
+static void end_barrier_request(struct request *clone, int error)
+{
+	int r = error;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
+
+	/* The clone is *NOT* freed here as same as end_clone_request(). */
+	__blk_put_request(clone->q, clone);
+
+	if (rq_end_io)
+		r = rq_end_io(tio->ti, clone, error, &tio->info);
+
+	if (r <= 0 || r == DM_ENDIO_REQUEUE)
+		dm_end_request(clone, r);
+	else if (r == DM_ENDIO_INCOMPLETE)
+		return;
+	else {
+		DMWARN("unimplemented target endio return value: %d", r);
+		BUG();
+	}
+}
+
+static struct request *alloc_barrier_clone(struct mapped_device *md,
+					   unsigned flush_nr)
+{
+	struct dm_rq_target_io *tio;
+	struct request *clone;
+
+	tio = alloc_rq_tio_wait(md);
+	tio->md = md;
+	tio->ti = NULL;
+	tio->orig = md->flush_request;
+	tio->error = 0;
+	memset(&tio->info, 0, sizeof(tio->info));
+	tio->info.flush_request = flush_nr;
+
+	clone = &tio->clone;
+	blk_rq_init(NULL, clone);
+	clone->cmd_type = REQ_TYPE_FS;
+	clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
+	clone->end_io = end_barrier_request;
+	clone->end_io_data = tio;
+
+	return clone;
+}
+
+/* Issue barrier requests to targets and wait for their completion. */
+static int dm_rq_barrier(struct mapped_device *md)
+{
+	int i, j;
+	struct dm_table *map = dm_get_table(md);
+	unsigned num_targets = dm_table_get_num_targets(map);
+	struct dm_target *ti;
+	struct request *clone;
+
+	md->barrier_error = 0;
+
+	for (i = 0; i < num_targets; i++) {
+		ti = dm_table_get_target(map, i);
+		for (j = 0; j < ti->num_flush_requests; j++) {
+			clone = alloc_barrier_clone(md, j);
+			atomic_inc(&md->pending[rq_data_dir(clone)]);
+			map_request(ti, clone, md);
+		}
+	}
+
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+	dm_table_put(map);
+
+	return md->barrier_error;
+}
+
+static void dm_rq_barrier_work(struct work_struct *work)
+{
+	int error;
+	struct mapped_device *md = container_of(work, struct mapped_device,
+						barrier_work);
+	struct request_queue *q = md->queue;
+	struct request *rq;
+	unsigned long flags;
+
+	/*
+	 * Hold the md reference here and leave it at the last part so that
+	 * the md can't be deleted by device opener when the barrier request
+	 * completes.
+	 */
+	dm_get(md);
+
+	error = dm_rq_barrier(md);
+
+	rq = md->flush_request;
+	md->flush_request = NULL;
+
+	if (error == DM_ENDIO_REQUEUE) {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_requeue_request(q, rq);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	} else
+		blk_end_request_all(rq, error);
+
+	blk_run_queue(q);
+
+	dm_put(md);
+}
+
+/*
  * Swap in a new table (destroying old one).
  */
 int dm_swap_table(struct mapped_device *md, struct dm_table *table)
@@ -2299,11 +2516,16 @@ int dm_suspend(struct mapped_device *md,
 	set_bit(DMF_QUEUE_IO_TO_THREAD, &md->flags);
 	up_write(&md->io_lock);
 
-	flush_workqueue(md->wq);
-
+	/*
+	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
+	 * can be kicked until md->queue is stopped.  So stop md->queue before
+	 * flushing md->wq.
+	 */
 	if (dm_request_based(md))
 		stop_queue(md->queue);
 
+	flush_workqueue(md->wq);
+
 	/*
 	 * At this point no more requests are entering target request routines.
 	 * We call dm_wait_for_completion to wait for all existing requests
