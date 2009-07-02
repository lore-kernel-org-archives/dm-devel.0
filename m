From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 05/25] io-controller: Charge for time slice based
	on average disk rate
Date: Thu,  2 Jul 2009 16:01:37 -0400
Message-ID: <1246564917-19603-6-git-send-email-vgoyal@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google
Cc: peterz@infradead.org, akpm@linux-foundation.org, snitzer@redhat.com, agk@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

o There are situations where a queue gets expired very soon and it looks
  as if time slice used by that queue is zero. For example, If an async
  queue dispatches a bunch of requests and queue is expired before first
  request completes. Another example is where a queue is expired as soon
  as first request completes and queue has no more requests (sync queues
  on SSD).

o Currently we just charge 25% of slice length in such cases. This patch tries
  to improve on that approximation by keeping a track of average disk rate
  and charging for time by nr_sectors/disk_rate.

o This is still experimental, not very sure if it gives measurable improvement
  or not. May be a better scheme is to use something more granular than jiffies
  for time keeping for io queues.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++----
 block/elevator-fq.h |   11 ++++++
 2 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 6f23d7e..67c02b9 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -23,6 +23,9 @@ const int elv_slice_async_rq = 2;
 int elv_slice_idle = HZ / 125;
 static struct kmem_cache *elv_ioq_pool;
 
+/* Maximum Window length for updating average disk rate */
+static int elv_rate_sampling_window = HZ / 10;
+
 #define ELV_SLICE_SCALE		(5)
 #define ELV_HW_QUEUE_MIN	(5)
 
@@ -941,6 +944,47 @@ static void elv_ioq_update_io_thinktime(struct io_queue *ioq)
 	ioq->ttime_mean = (ioq->ttime_total + 128) / ioq->ttime_samples;
 }
 
+static void elv_update_io_rate(struct elv_fq_data *efqd, struct request *rq)
+{
+	long elapsed = jiffies - efqd->rate_sampling_start;
+	unsigned long total;
+
+	/* sampling window is off */
+	if (!efqd->rate_sampling_start)
+		return;
+
+	efqd->rate_sectors_current += blk_rq_sectors(rq);
+
+	if (efqd->rq_in_driver && (elapsed < elv_rate_sampling_window))
+		return;
+
+	efqd->rate_sectors = (7*efqd->rate_sectors +
+				256*efqd->rate_sectors_current) / 8;
+
+	if (!elapsed) {
+		/*
+		 * updating rate before a jiffy could complete. Could be a
+		 * problem with fast queuing/non-queuing hardware. Should we
+		 * look at higher resolution time source?
+		 *
+		 * In case of non-queuing hardware we will probably not try to
+		 * dispatch from multiple queues and will be able to account
+		 * for disk time used and will not need this approximation
+		 * anyway?
+		 */
+		elapsed = 1;
+	}
+
+	efqd->rate_time = (7*efqd->rate_time + 256*elapsed) / 8;
+	total = efqd->rate_sectors + (efqd->rate_time/2);
+	efqd->mean_rate = total/efqd->rate_time;
+
+	elv_log(efqd, "mean_rate=%d, t=%d s=%d", efqd->mean_rate,
+			elapsed, efqd->rate_sectors_current);
+	efqd->rate_sampling_start = 0;
+	efqd->rate_sectors_current = 0;
+}
+
 /*
  * Disable idle window if the process thinks too long.
  * This idle flag can also be updated by io scheduler.
@@ -1231,6 +1275,34 @@ static void elv_del_ioq_busy(struct elevator_queue *e, struct io_queue *ioq,
 }
 
 /*
+ * Calculate the effective disk time used by the queue based on how many
+ * sectors queue has dispatched and what is the average disk rate
+ * Returns disk time in ms.
+ */
+static inline unsigned long elv_disk_time_used(struct request_queue *q,
+					struct io_queue *ioq)
+{
+	struct elv_fq_data *efqd = &q->elevator->efqd;
+	struct io_entity *entity = &ioq->entity;
+	unsigned long jiffies_used = 0;
+
+	if (!efqd->mean_rate)
+		return entity->budget/4;
+
+	/* Charge the queue based on average disk rate */
+	jiffies_used = ioq->nr_sectors/efqd->mean_rate;
+
+	if (!jiffies_used)
+		jiffies_used = 1;
+
+	elv_log_ioq(efqd, ioq, "disk time=%ldms sect=%lu rate=%ld",
+				jiffies_to_msecs(jiffies_used),
+				ioq->nr_sectors, efqd->mean_rate);
+
+	return jiffies_used;
+}
+
+/*
  * Do the accounting. Determine how much service (in terms of time slices)
  * current queue used and adjust the start, finish time of queue and vtime
  * of the tree accordingly.
@@ -1248,8 +1320,10 @@ static void elv_del_ioq_busy(struct elevator_queue *e, struct io_queue *ioq,
  * from next queue.
  *
  * Not sure how to determine the time consumed by queue in such scenarios.
- * Currently as a crude approximation, we are charging 25% of time slice
- * for such cases. A better mechanism is needed for accurate accounting.
+ * Currently as a crude approximation, try to keep track of average disk rate
+ * and charge the queue based on number of sectors transferred. If suffcient
+ * disk rate data is not available then we are charging 25% of time slice
+ * for such cases. A better mechanism, is needed for accurate accounting.
  */
 void __elv_ioq_slice_expired(struct request_queue *q, struct io_queue *ioq)
 {
@@ -1270,9 +1344,9 @@ void __elv_ioq_slice_expired(struct request_queue *q, struct io_queue *ioq)
 	 * reuqest from the queue got completed. Of course we are not planning
 	 * to idle on the queue otherwise we would not have expired it.
 	 *
-	 * Charge for the 25% slice in such cases. This is not the best thing
-	 * to do but at the same time not very sure what's the next best
-	 * thing to do.
+	 * Charge the queue based on average disk rate or the 25% slice if
+	 * mean rate is 0. This is not the best thing to do but at the same
+	 * time not very sure what's the next best thing to do.
 	 *
 	 * This arises from that fact that we don't have the notion of
 	 * one queue being operational at one time. io scheduler can dispatch
@@ -1282,7 +1356,7 @@ void __elv_ioq_slice_expired(struct request_queue *q, struct io_queue *ioq)
 	 * the requests to finish. But this will reduce throughput.
 	 */
 	if (!ioq->slice_end)
-		slice_used = entity->budget/4;
+		slice_used = elv_disk_time_used(q, ioq);
 	else {
 		if (time_after(ioq->slice_end, jiffies)) {
 			slice_unused = ioq->slice_end - jiffies;
@@ -1292,7 +1366,7 @@ void __elv_ioq_slice_expired(struct request_queue *q, struct io_queue *ioq)
 				 * completing first request. Charge 25% of
 				 * slice.
 				 */
-				slice_used = entity->budget/4;
+				slice_used = elv_disk_time_used(q, ioq);
 			} else
 				slice_used = entity->budget - slice_unused;
 		} else {
@@ -1310,6 +1384,8 @@ void __elv_ioq_slice_expired(struct request_queue *q, struct io_queue *ioq)
 	BUG_ON(ioq != efqd->active_queue);
 	elv_reset_active_ioq(efqd);
 
+	/* Queue is being expired. Reset number of secotrs dispatched */
+	ioq->nr_sectors = 0;
 	if (!ioq->nr_queued)
 		elv_del_ioq_busy(q->elevator, ioq, 1);
 	else
@@ -1671,6 +1747,7 @@ void elv_fq_dispatched_request(struct elevator_queue *e, struct request *rq)
 
 	BUG_ON(!ioq);
 	elv_ioq_request_dispatched(ioq);
+	ioq->nr_sectors += blk_rq_sectors(rq);
 	elv_ioq_request_removed(e, rq);
 	elv_clear_ioq_must_dispatch(ioq);
 }
@@ -1683,6 +1760,10 @@ void elv_fq_activate_rq(struct request_queue *q, struct request *rq)
 		return;
 
 	efqd->rq_in_driver++;
+
+	if (!efqd->rate_sampling_start)
+		efqd->rate_sampling_start = jiffies;
+
 	elv_log_ioq(efqd, rq->ioq, "activate rq, drv=%d",
 						efqd->rq_in_driver);
 }
@@ -1746,6 +1827,8 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 	efqd->rq_in_driver--;
 	ioq->dispatched--;
 
+	elv_update_io_rate(efqd, rq);
+
 	if (sync)
 		ioq->last_end_request = jiffies;
 
diff --git a/block/elevator-fq.h b/block/elevator-fq.h
index a7cbc0f..4b69239 100644
--- a/block/elevator-fq.h
+++ b/block/elevator-fq.h
@@ -165,6 +165,9 @@ struct io_queue {
 	/* Requests dispatched from this queue */
 	int dispatched;
 
+	/* Number of sectors dispatched in current dispatch round */
+	unsigned long nr_sectors;
+
 	/* Keep a track of think time of processes in this queue */
 	unsigned long last_end_request;
 	unsigned long ttime_total;
@@ -228,6 +231,14 @@ struct elv_fq_data {
 
 	/* Base slice length for sync and async queues */
 	unsigned int elv_slice[2];
+
+	/* Fields for keeping track of average disk rate */
+	unsigned long rate_sectors; /* number of sectors finished */
+	unsigned long rate_time;   /* jiffies elapsed */
+	unsigned long mean_rate; /* sectors per jiffy */
+	unsigned long long rate_sampling_start; /*sampling window start jifies*/
+	/* number of sectors finished io during current sampling window */
+	unsigned long rate_sectors_current;
 };
 
 /* Logging facilities. */
-- 
1.6.0.6
