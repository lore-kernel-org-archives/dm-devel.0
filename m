From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Wed, 7 Jan 2015 12:18:58 -0500
Message-ID: <20150107171857.GA21062@redhat.com>
References: <54A6DB1D.4030201@acm.org> <20150105213557.GA5030@redhat.com>
	<54ABAB80.70006@acm.org> <20150106160553.GB10224@redhat.com>
	<54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<54AD517E.40002@kernel.dk> <20150107161504.GA16911@redhat.com>
	<20150107162203.GB16911@redhat.com> <54AD5DAC.7020303@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54AD5DAC.7020303@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Wed, Jan 07 2015 at 11:24am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 01/07/2015 09:22 AM, Mike Snitzer wrote:
> >On Wed, Jan 07 2015 at 11:15am -0500,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >>On Wed, Jan 07 2015 at 10:32am -0500,
> >>Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >>>You forgot dm-1, that's what mkfs is sleeping on. But given that
> >>>sdc/sdd look idle, it still looks like a case of dm-1 not
> >>>appropriately running the queues after insertion.
> >>
> >>DM never directly runs the queues of the underlying SCSI devices
> >>(e.g. sdc, sdd).
> >>
> >>request-based DM runs the DM device's queue on completion of a clone
> >>request:
> >>
> >>dm_end_request -> rq_completed -> blk_run_queue_async
> >>
> >>Which ultimately does seem to be the wrong way around (like you say:
> >>queue should run after insertion).
> >
> >Hmm, for q->mq_ops blk_insert_cloned_request() should already be running
> >the queue.
> >
> >blk_insert_cloned_request is calling blk_mq_insert_request(rq, false, true, true);
> >
> >Third arg being @run_queue which results in blk_mq_run_hw_queue() being
> >called.
> 
> OK, that should be fine then. In that case, it's probably a missing
> queue run in some other condition... Which does make more sense,
> since "most" of the runs Bart did looked fine, it's just a slow one
> every now and then.

The one case that looks suspect (missing queue run) is if/when the
multipath target's mapping function returns DM_MAPIO_REQUEUE.  It only
returns this if memory allocation failed (e.g. blk_get_request returns
ENOMEM).  Not seeing why DM core wouldn't want to re-run the DM device's
queue in this case given it just called blk_requeue_request().  But that
seems like something I need to revisit and not the ultimate problem.

Looking closer, why not have blk_run_queue() (and blk_run_queue_async)
call blk_mq_start_stopped_hw_queues() if q->mq_ops?  As is
scsi_run_queue() open-codes it.

Actually, that is likely the ultimate problem: blk_run_queue* aren't
trained for q->mq_ops.  As such DM would need to open code a call to
blk_mq_start_stopped_hw_queues.

I think DM needs something like the following _untested_ patch, pretty
glaring oversight on my part (I thought the appropriate old block
methods would do the right thing for q->mq_ops):

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 549b815..d70a665 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -14,6 +14,7 @@
 #include <linux/moduleparam.h>
 #include <linux/blkpg.h>
 #include <linux/bio.h>
+#include <linux/blk-mq.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
@@ -1012,6 +1013,46 @@ static void end_clone_bio(struct bio *clone, int error)
 }
 
 /*
+ * request-based DM queue management functions.
+ */
+static void dm_stop_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	if (q->mq_ops) {
+		blk_mq_stop_hw_queues(q);
+		return;
+	}
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	blk_stop_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void dm_start_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	if (q->mq_ops) {
+		blk_mq_start_stopped_hw_queues(q, true);
+		return;
+	}
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (blk_queue_stopped(q))
+		blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void dm_run_queue(struct request_queue *q)
+{
+	if (q->mq_ops)
+		blk_mq_start_stopped_hw_queues(q, true);
+	else
+		blk_run_queue_async(q);
+}
+
+/*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
  * Or do dm_get() before calling this function and dm_put() later.
@@ -1031,7 +1072,7 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	 * queue lock again.
 	 */
 	if (run_queue)
-		blk_run_queue_async(md->queue);
+		dm_run_queue(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
@@ -1119,35 +1160,6 @@ static void dm_requeue_unmapped_request(struct request *clone)
 	dm_requeue_unmapped_original_request(tio->md, tio->orig);
 }
 
-static void __stop_queue(struct request_queue *q)
-{
-	blk_stop_queue(q);
-}
-
-static void stop_queue(struct request_queue *q)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__stop_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-
-static void __start_queue(struct request_queue *q)
-{
-	if (blk_queue_stopped(q))
-		blk_start_queue(q);
-}
-
-static void start_queue(struct request_queue *q)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	__start_queue(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-
 static void dm_done(struct request *clone, int error, bool mapped)
 {
 	int r = error;
@@ -2419,7 +2431,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	 * because request-based dm may be run just after the setting.
 	 */
 	if (dm_table_request_based(t) && !blk_queue_stopped(q))
-		stop_queue(q);
+		dm_stop_queue(q);
 
 	__bind_mempools(md, t);
 
@@ -2886,7 +2898,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	 * dm defers requests to md->wq from md->queue.
 	 */
 	if (dm_request_based(md)) {
-		stop_queue(md->queue);
+		dm_stop_queue(md->queue);
 		flush_kthread_worker(&md->kworker);
 	}
 
@@ -2909,7 +2921,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 		dm_queue_flush(md);
 
 		if (dm_request_based(md))
-			start_queue(md->queue);
+			dm_start_queue(md->queue);
 
 		unlock_fs(md);
 		dm_table_presuspend_undo_targets(map);
@@ -2988,7 +3000,7 @@ static int __dm_resume(struct mapped_device *md, struct dm_table *map)
 	 * Request-based dm is queueing the deferred I/Os in its request_queue.
 	 */
 	if (dm_request_based(md))
-		start_queue(md->queue);
+		dm_start_queue(md->queue);
 
 	unlock_fs(md);
 
