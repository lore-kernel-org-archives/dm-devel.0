From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] dm core: simplify suspend code of request-based
	dm
Date: Wed, 12 Aug 2009 17:04:18 +0900
Message-ID: <4A827782.9030808@ct.jp.nec.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

This patch simplifies suspend code of request-based dm.

In case of suspend with "--nolockfs" but without "--noflush",
the semantics for bio-based dm has been changed in 2.6.30 as below:
  before 2.6.30:   I/Os submitted before the suspend invocation
                   are flushed
  2.6.30 or later: I/Os submitted even before the suspend invocation
                   may not be flushed

  (*) We had no idea whether the semantics change hurt someone.
      (For details, see http://marc.info/?t=123994433400003&r=1&w=2)
      But it seems no hurt since there is no complaint against 2.6.30.

Since the semantics of request-based dm committed in 2.6.31-rc1
is still old one, change it to new one by this patch.

The semantics change makes the suspend code simple:
  o Suspend is implemented as stopping request_queue
    in request-based dm, and all I/Os are queued in the request_queue
    even after suspend is invoked.
  o To keep the old semantics, we need to distinguish which I/Os were
    queued before/after the suspend invocation.
    So a special barrier-like request called 'suspend marker' was
    introduced.
  o On the new semantics, we don't need to flush any I/O.
    So we can remove the marker and the codes related to the marker
    handling and I/O flushing.

After removing such codes, the suspend sequence is now below:
  1. Flush all I/Os by lock_fs() if needed.
  2. Stop dispatching any I/O by stopping the request_queue.
  3. Wait for all in-flight I/Os to be completed or requeued.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |  158 ++++----------------------------------------------------
 1 file changed, 14 insertions(+), 144 deletions(-)

Index: 2.6.31-rc5/drivers/md/dm.c
===================================================================
--- 2.6.31-rc5.orig/drivers/md/dm.c
+++ 2.6.31-rc5/drivers/md/dm.c
@@ -177,9 +177,6 @@ struct mapped_device {
 	/* forced geometry settings */
 	struct hd_geometry geometry;
 
-	/* marker of flush suspend for request-based dm */
-	struct request suspend_rq;
-
 	/* For saving the address of __make_request for request based dm */
 	make_request_fn *saved_make_request_fn;
 
@@ -1428,11 +1425,6 @@ static int setup_clone(struct request *c
 	return 0;
 }
 
-static int dm_rq_flush_suspending(struct mapped_device *md)
-{
-	return !md->suspend_rq.special;
-}
-
 /*
  * Called with the queue lock held.
  */
@@ -1442,14 +1434,6 @@ static int dm_prep_fn(struct request_que
 	struct dm_rq_target_io *tio;
 	struct request *clone;
 
-	if (unlikely(rq == &md->suspend_rq)) {
-		if (dm_rq_flush_suspending(md))
-			return BLKPREP_OK;
-		else
-			/* The flush suspend was interrupted */
-			return BLKPREP_KILL;
-	}
-
 	if (unlikely(rq->special)) {
 		DMWARN("Already has something in rq->special.");
 		return BLKPREP_KILL;
@@ -1533,27 +1517,15 @@ static void dm_request_fn(struct request
 	struct request *rq;
 
 	/*
-	 * For noflush suspend, check blk_queue_stopped() to immediately
-	 * quit I/O dispatching.
+	 * For suspend, check blk_queue_stopped() not to increment
+	 * the number of in-flight I/Os after the queue is stopped
+	 * in dm_suspend().
 	 */
 	while (!blk_queue_plugged(q) && !blk_queue_stopped(q)) {
 		rq = blk_peek_request(q);
 		if (!rq)
 			goto plug_and_out;
 
-		if (unlikely(rq == &md->suspend_rq)) { /* Flush suspend maker */
-			if (queue_in_flight(q))
-				/* Not quiet yet.  Wait more */
-				goto plug_and_out;
-
-			/* This device should be quiet now */
-			__stop_queue(q);
-			blk_start_request(rq);
-			__blk_end_request_all(rq, 0);
-			wake_up(&md->wait);
-			goto out;
-		}
-
 		ti = dm_table_find_target(map, blk_rq_pos(rq));
 		if (ti->type->busy && ti->type->busy(ti))
 			goto plug_and_out;
@@ -2083,7 +2055,7 @@ static int dm_wait_for_completion(struct
 		smp_mb();
 		if (dm_request_based(md)) {
 			spin_lock_irqsave(q->queue_lock, flags);
-			if (!queue_in_flight(q) && blk_queue_stopped(q)) {
+			if (!queue_in_flight(q)) {
 				spin_unlock_irqrestore(q->queue_lock, flags);
 				break;
 			}
@@ -2216,67 +2188,6 @@ out:
 	return r;
 }
 
-static void dm_rq_invalidate_suspend_marker(struct mapped_device *md)
-{
-	md->suspend_rq.special = (void *)0x1;
-}
-
-static void dm_rq_abort_suspend(struct mapped_device *md, int noflush)
-{
-	struct request_queue *q = md->queue;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (!noflush)
-		dm_rq_invalidate_suspend_marker(md);
-	__start_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-
-static void dm_rq_start_suspend(struct mapped_device *md, int noflush)
-{
-	struct request *rq = &md->suspend_rq;
-	struct request_queue *q = md->queue;
-
-	if (noflush)
-		stop_queue(q);
-	else {
-		blk_rq_init(q, rq);
-		blk_insert_request(q, rq, 0, NULL);
-	}
-}
-
-static int dm_rq_suspend_available(struct mapped_device *md, int noflush)
-{
-	int r = 1;
-	struct request *rq = &md->suspend_rq;
-	struct request_queue *q = md->queue;
-	unsigned long flags;
-
-	if (noflush)
-		return r;
-
-	/* The marker must be protected by queue lock if it is in use */
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (unlikely(rq->ref_count)) {
-		/*
-		 * This can happen, when the previous flush suspend was
-		 * interrupted, the marker is still in the queue and
-		 * this flush suspend has been invoked, because we don't
-		 * remove the marker at the time of suspend interruption.
-		 * We have only one marker per mapped_device, so we can't
-		 * start another flush suspend while it is in use.
-		 */
-		BUG_ON(!rq->special); /* The marker should be invalidated */
-		DMWARN("Invalidating the previous flush suspend is still in"
-		       " progress.  Please retry later.");
-		r = 0;
-	}
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	return r;
-}
-
 /*
  * Functions to lock and unlock any filesystem running on the
  * device.
@@ -2319,49 +2230,11 @@ static void unlock_fs(struct mapped_devi
 /*
  * Suspend mechanism in request-based dm.
  *
- * After the suspend starts, further incoming requests are kept in
- * the request_queue and deferred.
- * Remaining requests in the request_queue at the start of suspend are flushed
- * if it is flush suspend.
- * The suspend completes when the following conditions have been satisfied,
- * so wait for it:
- *    1. q->in_flight is 0 (which means no in_flight request)
- *    2. queue has been stopped (which means no request dispatching)
- *
- *
- * Noflush suspend
- * ---------------
- * Noflush suspend doesn't need to dispatch remaining requests.
- * So stop the queue immediately.  Then, wait for all in_flight requests
- * to be completed or requeued.
- *
- * To abort noflush suspend, start the queue.
+ * 1. Flush all I/Os by lock_fs() if needed.
+ * 2. Stop dispatching any I/O by stopping the request_queue.
+ * 3. Wait for all in-flight I/Os to be completed or requeued.
  *
- *
- * Flush suspend
- * -------------
- * Flush suspend needs to dispatch remaining requests.  So stop the queue
- * after the remaining requests are completed. (Requeued request must be also
- * re-dispatched and completed.  Until then, we can't stop the queue.)
- *
- * During flushing the remaining requests, further incoming requests are also
- * inserted to the same queue.  To distinguish which requests are to be
- * flushed, we insert a marker request to the queue at the time of starting
- * flush suspend, like a barrier.
- * The dispatching is blocked when the marker is found on the top of the queue.
- * And the queue is stopped when all in_flight requests are completed, since
- * that means the remaining requests are completely flushed.
- * Then, the marker is removed from the queue.
- *
- * To abort flush suspend, we also need to take care of the marker, not only
- * starting the queue.
- * We don't remove the marker forcibly from the queue since it's against
- * the block-layer manner.  Instead, we put a invalidated mark on the marker.
- * When the invalidated marker is found on the top of the queue, it is
- * immediately removed from the queue, so it doesn't block dispatching.
- * Because we have only one marker per mapped_device, we can't start another
- * flush suspend until the invalidated marker is removed from the queue.
- * So fail and return with -EBUSY in such a case.
+ * To abort suspend, start the request_queue.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
@@ -2377,11 +2250,6 @@ int dm_suspend(struct mapped_device *md,
 		goto out_unlock;
 	}
 
-	if (dm_request_based(md) && !dm_rq_suspend_available(md, noflush)) {
-		r = -EBUSY;
-		goto out_unlock;
-	}
-
 	map = dm_get_table(md);
 
 	/*
@@ -2395,8 +2263,10 @@ int dm_suspend(struct mapped_device *md,
 	dm_table_presuspend_targets(map);
 
 	/*
-	 * Flush I/O to the device. noflush supersedes do_lockfs,
-	 * because lock_fs() needs to flush I/Os.
+	 * Flush I/O to the device.
+	 * Any I/O submitted after lock_fs() may not be flushed.
+	 * noflush supersedes do_lockfs, because lock_fs() needs to flush I/Os
+	 * and wait for the flushed I/Os to complete.
 	 */
 	if (!noflush && do_lockfs) {
 		r = lock_fs(md);
@@ -2428,7 +2298,7 @@ int dm_suspend(struct mapped_device *md,
 	flush_workqueue(md->wq);
 
 	if (dm_request_based(md))
-		dm_rq_start_suspend(md, noflush);
+		stop_queue(md->queue);
 
 	/*
 	 * At this point no more requests are entering target request routines.
@@ -2447,7 +2317,7 @@ int dm_suspend(struct mapped_device *md,
 		dm_queue_flush(md);
 
 		if (dm_request_based(md))
-			dm_rq_abort_suspend(md, noflush);
+			start_queue(md->queue);
 
 		unlock_fs(md);
 		goto out; /* pushback list is already flushed, so skip flush */
