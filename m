From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 2/4] dm: Submit stacked requests in irq enabled
	context
Date: Fri, 17 Oct 2014 17:46:36 -0600
Message-ID: <1413589598-17631-3-git-send-email-keith.busch@intel.com>
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

This has dm enqueue all prep'ed requests into work processed by another
thread. This will allow dm to invoke block APIs that assume interrupt
enabled context. This patch is to prepare for adding blk-mq support.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/md/dm.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 809f83f..88a73be 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,6 +19,7 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/delay.h>
+#include <linux/kthread.h>
 
 #include <trace/events/block.h>
 
@@ -56,6 +57,8 @@ static DECLARE_WORK(deferred_remove_work, do_deferred_remove);
 
 static struct workqueue_struct *deferred_remove_workqueue;
 
+static void map_tio_request(struct kthread_work *work);
+
 /*
  * For bio-based dm.
  * One of these is allocated per bio.
@@ -78,6 +81,7 @@ struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
 	struct request *orig, clone;
+	struct kthread_work work;
 	int error;
 	union map_info info;
 };
@@ -202,6 +206,9 @@ struct mapped_device {
 	struct bio flush_bio;
 
 	struct dm_stats stats;
+
+	struct kthread_worker kworker;
+	struct task_struct *kworker_task;
 };
 
 /*
@@ -1635,6 +1642,7 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 	tio->orig = rq;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
+	init_kthread_work(&tio->work, map_tio_request);
 
 	clone = &tio->clone;
 	if (setup_clone(clone, rq, tio)) {
@@ -1731,6 +1739,13 @@ static struct request *dm_start_request(struct mapped_device *md, struct request
 	return clone;
 }
 
+static void map_tio_request(struct kthread_work *work)
+{
+	struct dm_rq_target_io *tio = container_of(work, struct dm_rq_target_io,
+									work);
+	map_request(tio->ti, &tio->clone, tio->md);
+}
+
 /*
  * q->request_fn for request-based dm.
  * Called with the queue lock held.
@@ -1742,6 +1757,7 @@ static void dm_request_fn(struct request_queue *q)
 	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 	struct dm_target *ti;
 	struct request *rq, *clone;
+	struct dm_rq_target_io *tio;
 	sector_t pos;
 
 	/*
@@ -1777,20 +1793,14 @@ static void dm_request_fn(struct request_queue *q)
 
 		clone = dm_start_request(md, rq);
 
-		spin_unlock(q->queue_lock);
-		if (map_request(ti, clone, md))
-			goto requeued;
-
+		tio = rq->special;
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
@@ -1981,6 +1991,11 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+
+	init_kthread_worker(&md->kworker);
+	md->kworker_task = kthread_run(kthread_worker_fn, &md->kworker, "dm-%s",
+					dev_name(disk_to_dev(md->disk)));
+
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
@@ -2034,6 +2049,10 @@ static void free_dev(struct mapped_device *md)
 	unlock_fs(md);
 	bdput(md->bdev);
 	destroy_workqueue(md->wq);
+
+	flush_kthread_worker(&md->kworker);
+	kthread_stop(md->kworker_task);
+
 	if (md->io_pool)
 		mempool_destroy(md->io_pool);
 	if (md->bs)
-- 
1.7.10.4
