From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 7/8] dm: submit stacked requests in irq
	enabled context
Date: Tue, 16 Dec 2014 23:00:03 -0500
Message-ID: <1418788804-1982-8-git-send-email-snitzer@redhat.com>
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

Switch to having request-based DM enqueue all prep'ed requests into work
processed by another thread.  This allows request-based DM to invoke
block APIs that assume interrupt enabled context (e.g. blk_get_request)
and is a prerequisite for adding blk-mq support to request-based DM.

The new kernel thread is only initialized for request-based DM devices.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca5eed2..00c9986 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -20,6 +20,7 @@
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
+#include <linux/kthread.h>
 
 #include <trace/events/block.h>
 
@@ -79,6 +80,7 @@ struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
 	struct request *orig, *clone;
+	struct kthread_work work;
 	int error;
 	union map_info info;
 };
@@ -208,6 +210,9 @@ struct mapped_device {
 	struct bio flush_bio;
 
 	struct dm_stats stats;
+
+	struct kthread_worker kworker;
+	struct task_struct *kworker_task;
 };
 
 /*
@@ -1773,6 +1778,8 @@ static struct request *__clone_rq(struct request *rq, struct mapped_device *md,
 	return clone;
 }
 
+static void map_tio_request(struct kthread_work *work);
+
 static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 				gfp_t gfp_mask)
 {
@@ -1789,6 +1796,7 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 	tio->orig = rq;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
+	init_kthread_work(&tio->work, map_tio_request);
 
 	clone = __clone_rq(rq, md, tio, GFP_ATOMIC);
 	if (!clone) {
@@ -1864,6 +1872,13 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	return requeued;
 }
 
+static void map_tio_request(struct kthread_work *work)
+{
+	struct dm_rq_target_io *tio = container_of(work, struct dm_rq_target_io, work);
+
+	map_request(tio->ti, tio->clone, tio->md);
+}
+
 static struct request *dm_start_request(struct mapped_device *md, struct request *orig)
 {
 	struct request *clone;
@@ -1895,6 +1910,7 @@ static void dm_request_fn(struct request_queue *q)
 	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
 	struct request *rq, *clone;
+	struct dm_rq_target_io *tio;
 	sector_t pos;
 
 	/*
@@ -1930,20 +1946,15 @@ static void dm_request_fn(struct request_queue *q)
 
 		clone = dm_start_request(md, rq);
 
-		spin_unlock(q->queue_lock);
-		if (map_request(ti, clone, md))
-			goto requeued;
-
+		tio = rq->special;
+		/* Establish tio->ti before queuing work (map_tio_request) */
+		tio->ti = ti;
+		queue_kthread_work(&md->kworker, &tio->work);
 		BUG_ON(!irqs_disabled());
-		spin_lock(q->queue_lock);
 	}
 
 	goto out;
 
-requeued:
-	BUG_ON(!irqs_disabled());
-	spin_lock(q->queue_lock);
-
 delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
@@ -2129,6 +2140,7 @@ static struct mapped_device *alloc_dev(int minor)
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
 	init_completion(&md->kobj_holder.completion);
+	md->kworker_task = NULL;
 
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
@@ -2189,6 +2201,9 @@ static void free_dev(struct mapped_device *md)
 	unlock_fs(md);
 	bdput(md->bdev);
 	destroy_workqueue(md->wq);
+
+	if (md->kworker_task)
+		kthread_stop(md->kworker_task);
 	if (md->io_pool)
 		mempool_destroy(md->io_pool);
 	if (md->rq_pool)
@@ -2484,6 +2499,11 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
 	blk_queue_lld_busy(md->queue, dm_lld_busy);
 
+	/* Also initialize the request-based DM worker thread */
+	init_kthread_worker(&md->kworker);
+	md->kworker_task = kthread_run(kthread_worker_fn, &md->kworker,
+				       "kdmwork-%s", dm_device_name(md));
+
 	elv_register_queue(md->queue);
 
 	return 1;
@@ -2574,6 +2594,9 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
+	if (dm_request_based(md))
+		flush_kthread_worker(&md->kworker);
+
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
 		dm_table_postsuspend_targets(map);
@@ -2817,8 +2840,10 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	 * Stop md->queue before flushing md->wq in case request-based
 	 * dm defers requests to md->wq from md->queue.
 	 */
-	if (dm_request_based(md))
+	if (dm_request_based(md)) {
 		stop_queue(md->queue);
+		flush_kthread_worker(&md->kworker);
+	}
 
 	flush_workqueue(md->wq);
 
-- 
1.9.3
