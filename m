From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Tue, 10 Mar 2009 17:17:34 +0900
Message-ID: <49B6221E.1030203@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>	<20090128154019.GB23158@agk.fab.redhat.com>	<49815863.8040806@ct.jp.nec.com>	<20090129104147.GB9870@pentland.suse.de>	<4982B4C6.8050904@ct.jp.nec.com>
	<49B60444.2090008@ct.jp.nec.com> <49B613FE.3060501@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49B613FE.3060501@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 03/10/2009 04:17 PM +0900, Hannes Reinecke wrote:
> Hi Kiyoshi,
> 
> Kiyoshi Ueda wrote:
>> Hi Hannes,
>>
>> On 2009/01/30 17:05 +0900, Kiyoshi Ueda wrote:
>>>>>   o kernel panic occurs by frequent table swapping during heavy I/Os.
>>>>>  
>>>> That's probably fixed by this patch:
>>>>
>>>> --- linux-2.6.27/drivers/md/dm.c.orig   2009-01-23
>>>> 15:59:22.741461315 +0100
>>>> +++ linux-2.6.27/drivers/md/dm.c        2009-01-26
>>>> 09:03:02.787605723 +0100
>>>> @@ -714,13 +714,14 @@ static void free_bio_clone(struct reques
>>>>         struct dm_rq_target_io *tio = clone->end_io_data;
>>>>         struct mapped_device *md = tio->md;
>>>>         struct bio *bio;
>>>> -       struct dm_clone_bio_info *info;
>>>>  
>>>>         while ((bio = clone->bio) != NULL) {
>>>>                 clone->bio = bio->bi_next;
>>>>  
>>>> -               info = bio->bi_private;
>>>> -               free_bio_info(md, info);
>>>> +               if (bio->bi_private) {
>>>> +                       struct dm_clone_bio_info *info =
>>>> bio->bi_private;
>>>> +                       free_bio_info(md, info);
>>>> +               }
>>>>  
>>>>                 bio->bi_private = md->bs;
>>>>                 bio_put(bio);
>>>>
>>>> The info field is not necessarily filled here, so we have to check
>>>> for it
>>>> explicitly.
>>>>
>>>> With these two patches request-based multipathing have survived all
>>>> stress-tests
>>>> so far. Except on mainframe (zfcp), but that's more a driver-related
>>>> thing.
>>
>> My problem was different from that one, and I have fixed my problem.
>>
> What was this? Was is something specific to your setup or some within the
> request-based multipathing code?
> If the latter, I'd be _very_ much interested in seeing the patch.
> Naturally.

Suspend was broken.
dm_suspend() recognized that suspend completed while some requests
were still in flight.  So we could swap/free the in-use table while
there was in_flight request.
The patch is like the attached one, although it is not finalized and
I'm testing now.
I'll post an updated patch-set including the attached patch
this week or next week.


>> Do you hit some problem without the patch above?
>> If so, that should be a programming bug and we need to fix it. 
>> Otherwise,
>> we should be leaking a memory (since all cloned bio should always have
>> the dm_clone_bio_info structure in ->bi_private).
>>
> Yes, I've found that one later on.
> The real problem was in clone_setup_bios(), which might end up calling an
> invalid end_io_data pointer. Patch is attached.

Thank you for the patch.
I'll see it soon.

Thanks,
Kiyoshi Ueda


---
 drivers/md/dm.c |  236 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 144 insertions(+), 92 deletions(-)

Index: 2.6.29-rc2/drivers/md/dm.c
===================================================================
--- 2.6.29-rc2.orig/drivers/md/dm.c
+++ 2.6.29-rc2/drivers/md/dm.c
@@ -701,11 +701,17 @@ static void free_bio_clone(struct reques
 	}
 }
 
-static void dec_rq_pending(struct dm_rq_target_io *tio)
+/*
+ * XXX: Not taking queue lock for efficiency.
+ *      For correctness, waiters will check that again with queue lock held.
+ *      No false negative because this function will be called everytime
+ *      in_flight is decremented.
+ */
+static void rq_completed(struct mapped_device *md)
 {
-	if (!atomic_dec_return(&tio->md->pending))
+	if (!md->queue->in_flight)
 		/* nudge anyone waiting on suspend queue */
-		wake_up(&tio->md->wait);
+		wake_up(&md->wait);
 }
 
 static void dm_unprep_request(struct request *rq)
@@ -717,7 +723,6 @@ static void dm_unprep_request(struct req
 	rq->cmd_flags &= ~REQ_DONTPREP;
 
 	free_bio_clone(clone);
-	dec_rq_pending(tio);
 	free_rq_tio(tio->md, tio);
 }
 
@@ -727,6 +732,7 @@ static void dm_unprep_request(struct req
 void dm_requeue_request(struct request *clone)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 	struct request_queue *q = rq->q;
 	unsigned long flags;
@@ -738,6 +744,8 @@ void dm_requeue_request(struct request *
 		blk_plug_device(q);
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	rq_completed(md);
 }
 EXPORT_SYMBOL_GPL(dm_requeue_request);
 
@@ -776,6 +784,7 @@ static void start_queue(struct request_q
 static void dm_end_request(struct request *clone, int error)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 	struct request_queue *q = rq->q;
 	unsigned int nr_bytes = blk_rq_bytes(rq);
@@ -794,12 +803,12 @@ static void dm_end_request(struct reques
 	}
 
 	free_bio_clone(clone);
-	dec_rq_pending(tio);
 	free_rq_tio(tio->md, tio);
 
 	if (unlikely(blk_end_request(rq, error, nr_bytes)))
 		BUG();
 
+	rq_completed(md);
 	blk_run_queue(q);
 }
 
@@ -1397,7 +1406,7 @@ static int setup_clone(struct request *c
 	return 0;
 }
 
-static inline int dm_flush_suspending(struct mapped_device *md)
+static inline int dm_rq_flush_suspending(struct mapped_device *md)
 {
 	return !md->suspend_rq.data;
 }
@@ -1411,23 +1420,11 @@ static int dm_prep_fn(struct request_que
 	struct dm_rq_target_io *tio;
 	struct request *clone;
 
-	if (unlikely(rq == &md->suspend_rq)) { /* Flush suspend marker */
-		if (dm_flush_suspending(md)) {
-			if (q->in_flight)
-				return BLKPREP_DEFER;
-			else {
-				/* This device should be quiet now */
-				__stop_queue(q);
-				smp_mb();
-				BUG_ON(atomic_read(&md->pending));
-				wake_up(&md->wait);
-				return BLKPREP_KILL;
-			}
-		} else
-			/*
-			 * The suspend process was interrupted.
-			 * So no need to suspend now.
-			 */
+	if (unlikely(rq == &md->suspend_rq)) {
+		if (dm_rq_flush_suspending(md))
+			return BLKPREP_OK;
+		else
+			/* The flush suspend was interrupted */
 			return BLKPREP_KILL;
 	}
 
@@ -1436,11 +1433,6 @@ static int dm_prep_fn(struct request_que
 		return BLKPREP_KILL;
 	}
 
-	if (unlikely(!dm_request_based(md))) {
-		DMWARN("Request was queued into bio-based device");
-		return BLKPREP_KILL;
-	}
-
 	tio = alloc_rq_tio(md); /* Only one for each original request */
 	if (!tio)
 		/* -ENOMEM */
@@ -1473,7 +1465,6 @@ static void map_request(struct dm_target
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	tio->ti = ti;
-	atomic_inc(&md->pending);
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
@@ -1511,19 +1502,35 @@ static void dm_request_fn(struct request
 	struct request *rq;
 
 	/*
-	 * The check for blk_queue_stopped() needs here, because:
-	 *     - device suspend uses blk_stop_queue() and expects that
-	 *       no I/O will be dispatched any more after the queue stop
-	 *     - generic_unplug_device() doesn't call q->request_fn()
-	 *       when the queue is stopped, so no problem
-	 *     - but underlying device drivers may call q->request_fn()
-	 *       without the check through blk_run_queue()
+	 * The check of blk_queue_stopped() needs here, because we want to
+	 * complete noflush suspend quickly:
+	 *     - noflush suspend stops the queue in dm_suspend() and expects
+	 *       that no I/O will be dispatched any more after the queue stop
+	 *     - but if the queue stop is done while the loop below and
+	 *       there is no check for the queue stop, I/O dispatching
+	 *       may not stop until all remaining I/Os in the queue are
+	 *       dispatched.  For noflush suspend, we shouldn't want
+	 *       this behavior.
 	 */
 	while (!blk_queue_plugged(q) && !blk_queue_stopped(q)) {
 		rq = elv_next_request(q);
 		if (!rq)
 			goto plug_and_out;
 
+		if (unlikely(rq == &md->suspend_rq)) { /* Flush suspend maker */
+			if (q->in_flight)
+				/* Not quiet yet.  Wait more */
+				goto plug_and_out;
+
+			/* This device should be quiet now */
+			__stop_queue(q);
+			blkdev_dequeue_request(rq);
+			if (unlikely(__blk_end_request(rq, 0, 0)))
+				BUG();
+			wake_up(&md->wait);
+			goto out;
+		}
+
 		ti = dm_table_find_target(map, rq->sector);
 		if (ti->type->busy && ti->type->busy(ti))
 			goto plug_and_out;
@@ -1996,15 +2003,20 @@ EXPORT_SYMBOL_GPL(dm_put);
 static int dm_wait_for_completion(struct mapped_device *md)
 {
 	int r = 0;
+	struct request_queue *q = md->queue;
+	unsigned long flags;
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		smp_mb();
 		if (dm_request_based(md)) {
-			if (!atomic_read(&md->pending) &&
-			    blk_queue_stopped(md->queue))
+			spin_lock_irqsave(q->queue_lock, flags);
+			if (!q->in_flight && blk_queue_stopped(q)) {
+				spin_unlock_irqrestore(q->queue_lock, flags);
 				break;
+			}
+			spin_unlock_irqrestore(q->queue_lock, flags);
 		} else if (!atomic_read(&md->pending))
 			break;
 
@@ -2107,86 +2119,75 @@ out:
 	return r;
 }
 
-static inline void dm_invalidate_flush_suspend(struct mapped_device *md)
+static inline void dm_rq_invalidate_suspend_marker(struct mapped_device *md)
 {
 	md->suspend_rq.data = (void *)0x1;
 }
 
-static void dm_abort_suspend(struct mapped_device *md, int noflush)
+/*
+ * For noflush suspend, starting the queue is enough because noflush suspend
+ * only stops the queue.
+ *
+ * For flush suspend, we also need to take care of the marker.
+ * We could remove the marker from the queue forcibly using list_del_init(),
+ * but it would break the block-layer.  To follow the block-layer manner,
+ * we just put an invalidated mark on the marker here and wait for it to be
+ * completed by the normal way.
+ */
+static void dm_rq_abort_suspend(struct mapped_device *md, int noflush)
 {
 	struct request_queue *q = md->queue;
 	unsigned long flags;
 
-	/*
-	 * For flush suspend, invalidation and queue restart must be protected
-	 * by a single queue lock to prevent a race with dm_prep_fn().
-	 */
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (!noflush)
-		dm_invalidate_flush_suspend(md);
+		dm_rq_invalidate_suspend_marker(md);
 	__start_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-/*
- * Additional suspend work for request-based dm.
- *
- * In request-based dm, stopping request_queue prevents mapping.
- * Even after stopping the request_queue, submitted requests from upper-layer
- * can be inserted to the request_queue.  So original (unmapped) requests are
- * kept in the request_queue during suspension.
- */
-static void dm_start_suspend(struct mapped_device *md, int noflush)
+static void dm_rq_start_suspend(struct mapped_device *md, int noflush)
 {
 	struct request *rq = &md->suspend_rq;
 	struct request_queue *q = md->queue;
-	unsigned long flags;
 
-	if (noflush) {
+	if (noflush)
 		stop_queue(q);
-		return;
+	else {
+		blk_rq_init(q, rq);
+		blk_insert_request(q, rq, 0, NULL);
 	}
+}
 
-	/*
-	 * For flush suspend, we need a marker to indicate the border line
-	 * between flush needed I/Os and deferred I/Os, since all I/Os are
-	 * queued in the request_queue during suspension.
-	 *
-	 * This marker must be inserted after setting DMF_BLOCK_IO,
-	 * because dm_prep_fn() considers no DMF_BLOCK_IO to be
-	 * a suspend interruption.
-	 */
+static int dm_rq_suspend_unavailable(struct mapped_device *md, int noflush)
+{
+	int r = 0;
+	struct request *rq = &md->suspend_rq;
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
+	if (noflush)
+		return 0;
+
+	/* The marker must be protected by queue lock if it is in use */
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (unlikely(rq->ref_count)) {
 		/*
-		 * This can happen when the previous suspend was interrupted,
-		 * the inserted suspend_rq for the previous suspend has still
-		 * been in the queue and this suspend has been invoked.
-		 *
-		 * We could re-insert the suspend_rq by deleting it from
-		 * the queue forcibly using list_del_init(&rq->queuelist).
-		 * But it would break the block-layer easily.
-		 * So we don't re-insert the suspend_rq again in such a case.
-		 * The suspend_rq should be already invalidated during
-		 * the previous suspend interruption, so just wait for it
-		 * to be completed.
-		 *
-		 * This suspend will never complete, so warn the user to
-		 * interrupt this suspend and retry later.
+		 * This can happen, when the previous flush suspend was
+		 * interrupted, the marker is still in the queue and
+		 * this flush suspend has been invoked, because we don't
+		 * remove the marker at the time of suspend interruption.
+		 * We have only one marker per mapped_device, so we can't
+		 * start another flush suspend while it is in use.
 		 */
-		BUG_ON(!rq->data);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-
-		DMWARN("Invalidating the previous suspend is still in"
-		       " progress.  This suspend will be never done."
-		       " Please interrupt this suspend and retry later.");
-		return;
+		BUG_ON(!rq->data); /* The marker should be invalidated */
+		DMWARN("Invalidating the previous flush suspend is still in"
+		       " progress.  Please retry later.");
+		r = 1;
 	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	/* Now no user of the suspend_rq */
-	blk_rq_init(q, rq);
-	blk_insert_request(q, rq, 0, NULL);
+	return r;
 }
 
 /*
@@ -2231,6 +2232,52 @@ static void unlock_fs(struct mapped_devi
  * dm_bind_table, dm_suspend must be called to flush any in
  * flight bios and ensure that any further io gets deferred.
  */
+/*
+ * Suspend mechanism in request-based dm.
+ *
+ * After the suspend starts, (remaining requests in the request_queue are
+ * flushed if it is flush suspend, and) further incoming requests are kept
+ * in the request_queue and deferred.
+ * The suspend completes when the following conditions have been satisfied,
+ * so wait for it:
+ *    1. q->in_flight is 0 (which means no in_flight request)
+ *    2. queue has been stopped (which means no request dispatching)
+ *
+ *
+ * Noflush suspend
+ * ---------------
+ * Noflush suspend doesn't need to dispatch remaining requests.
+ * So stop the queue immediately.  Then, wait for all in_flight requests
+ * to be completed or requeued.
+ *
+ * To abort noflush suspend, start the queue.
+ *
+ *
+ * Flush suspend
+ * -------------
+ * Flush suspend needs to dispatch remaining requests.  So stop the queue
+ * after the remaining requests are completed. (Requeued request must be also
+ * re-dispatched and completed.  Until then, we can't stop the queue.)
+ *
+ * During flushing the remaining requests, further incoming requests are also
+ * inserted to the same queue.  To distinguish which requests are needed to be
+ * flushed, we insert a marker request to the queue at the time of starting
+ * flush suspend, like a barrier.
+ * The dispatching is blocked when the marker is found on the top of the queue.
+ * And the queue is stopped when all in_flight requests are completed, since
+ * that means the remaining requests are completely flushed.
+ * Then, the marker is removed from the queue.
+ *
+ * To abort flush suspend, we also need to take care of the marker, not only
+ * starting the queue.
+ * We could remove the marker forcibly from the queue, but it would break
+ * the block-layer.  Instead, we put a invalidated mark on the marker.
+ * When the invalidated marker is found on the top of the queue, it is
+ * immediately removed from the queue, so it doesn't block dispatching.
+ * Because we have only one marker per mapped_device, we can't start another
+ * flush suspend until the invalidated marker is removed from the queue.
+ * So fail and return with -EBUSY in such a case.
+ */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
@@ -2246,6 +2293,11 @@ int dm_suspend(struct mapped_device *md,
 		goto out_unlock;
 	}
 
+	if (dm_request_based(md) && dm_rq_suspend_unavailable(md, noflush)) {
+		r = -EBUSY;
+		goto out_unlock;
+	}
+
 	map = dm_get_table(md);
 
 	/*
@@ -2288,7 +2340,7 @@ int dm_suspend(struct mapped_device *md,
 	up_write(&md->io_lock);
 
 	if (dm_request_based(md))
-		dm_start_suspend(md, noflush);
+		dm_rq_start_suspend(md, noflush);
 
 	/* unplug */
 	if (map)
@@ -2316,7 +2368,7 @@ int dm_suspend(struct mapped_device *md,
 		dm_queue_flush(md, DM_WQ_FLUSH_DEFERRED, NULL);
 
 		if (dm_request_based(md))
-			dm_abort_suspend(md, noflush);
+			dm_rq_abort_suspend(md, noflush);
 
 		unlock_fs(md);
 		goto out; /* pushback list is already flushed, so skip flush */
