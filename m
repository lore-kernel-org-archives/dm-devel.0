From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 6/9] rqdm core: use md->pending for in_flight I/O
	counting
Date: Fri, 16 Oct 2009 14:02:32 +0900
Message-ID: <4AD7FE68.30508@ct.jp.nec.com>
References: <4AD7FC11.7030009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD7FC11.7030009@ct.jp.nec.com>
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

This patch changes the counter for the number of in_flight I/Os
to md->pending from q->in_flight.  No functional change.

This patch is a preparation for PATCH 9.
Request-based dm used q->in_flight to count the number of in-flight
clones assuming the counter is always incremented for an in-flight
original request and original:clone is 1:1 relationship.
However, it is no longer true for barrier requests.
So use md->pending to count the number of in-flight clones.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -725,23 +725,16 @@ static void end_clone_bio(struct bio *cl
  * the md may be freed in dm_put() at the end of this function.
  * Or do dm_get() before calling this function and dm_put() later.
  */
-static void rq_completed(struct mapped_device *md, int run_queue)
+static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 {
-	int wakeup_waiters = 0;
-	struct request_queue *q = md->queue;
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (!queue_in_flight(q))
-		wakeup_waiters = 1;
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	atomic_dec(&md->pending[rw]);
 
 	/* nudge anyone waiting on suspend queue */
-	if (wakeup_waiters)
+	if (!md_in_flight(md))
 		wake_up(&md->wait);
 
 	if (run_queue)
-		blk_run_queue(q);
+		blk_run_queue(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
@@ -772,6 +765,7 @@ static void dm_unprep_request(struct req
  */
 void dm_requeue_unmapped_request(struct request *clone)
 {
+	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
@@ -786,7 +780,7 @@ void dm_requeue_unmapped_request(struct 
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	rq_completed(md, 0);
+	rq_completed(md, rw, 0);
 }
 EXPORT_SYMBOL_GPL(dm_requeue_unmapped_request);
 
@@ -825,6 +819,7 @@ static void start_queue(struct request_q
  */
 static void dm_end_request(struct request *clone, int error)
 {
+	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
@@ -846,7 +841,7 @@ static void dm_end_request(struct reques
 
 	blk_end_request_all(rq, error);
 
-	rq_completed(md, 1);
+	rq_completed(md, rw, 1);
 }
 
 /*
@@ -1541,12 +1536,12 @@ static void dm_request_fn(struct request
 	struct mapped_device *md = q->queuedata;
 	struct dm_table *map = dm_get_table(md);
 	struct dm_target *ti;
-	struct request *rq;
+	struct request *rq, *clone;
 
 	/*
-	 * For suspend, check blk_queue_stopped() not to increment
-	 * the number of in-flight I/Os after the queue is stopped
-	 * in dm_suspend().
+	 * For suspend, check blk_queue_stopped() and increment ->pending
+	 * within a single queue_lock not to increment the number of
+	 * in-flight I/Os after the queue is stopped in dm_suspend().
 	 */
 	while (!blk_queue_plugged(q) && !blk_queue_stopped(q)) {
 		rq = blk_peek_request(q);
@@ -1558,8 +1553,11 @@ static void dm_request_fn(struct request
 			goto plug_and_out;
 
 		blk_start_request(rq);
+		clone = rq->special;
+		atomic_inc(&md->pending[rq_data_dir(clone)]);
+
 		spin_unlock(q->queue_lock);
-		map_request(ti, rq->special, md);
+		map_request(ti, clone, md);
 		spin_lock_irq(q->queue_lock);
 	}
 
@@ -2071,8 +2069,6 @@ static int dm_wait_for_completion(struct
 {
 	int r = 0;
 	DECLARE_WAITQUEUE(wait, current);
-	struct request_queue *q = md->queue;
-	unsigned long flags;
 
 	dm_unplug_all(md->queue);
 
@@ -2082,14 +2078,7 @@ static int dm_wait_for_completion(struct
 		set_current_state(interruptible);
 
 		smp_mb();
-		if (dm_request_based(md)) {
-			spin_lock_irqsave(q->queue_lock, flags);
-			if (!queue_in_flight(q)) {
-				spin_unlock_irqrestore(q->queue_lock, flags);
-				break;
-			}
-			spin_unlock_irqrestore(q->queue_lock, flags);
-		} else if (!md_in_flight(md))
+		if (!md_in_flight(md))
 			break;
 
 		if (interruptible == TASK_INTERRUPTIBLE &&
