From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue of blk-mq requests
Date: Tue, 13 Sep 2016 12:01:34 -0400
Message-ID: <1473782495-44128-3-git-send-email-snitzer@redhat.com>
References: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

Otherwise blk-mq will immediately dispatch requests that are requeued
via a BLK_MQ_RQ_QUEUE_BUSY return from blk_mq_ops .queue_rq.

Delayed requeue is implemented using blk_mq_delay_kick_requeue_list()
with a delay of 5 secs.  In the context of DM multipath (all paths down)
it doesn't make any sense to requeue more quickly.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c            | 35 ++++++++++++++++++++---------------
 include/linux/device-mapper.h |  1 +
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 0d301d5..1722220 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -336,21 +336,23 @@ static void dm_old_requeue_request(struct request *rq)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_mq_requeue_request(struct request *rq)
+static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
 	blk_mq_requeue_request(rq);
+
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (!blk_queue_stopped(q))
-		blk_mq_kick_requeue_list(q);
+		blk_mq_delay_kick_requeue_list(q, msecs);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_requeue_original_request(struct mapped_device *md,
-					struct request *rq)
+static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_requeue)
 {
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
 	int rw = rq_data_dir(rq);
 
 	rq_end_stats(md, rq);
@@ -359,7 +361,7 @@ static void dm_requeue_original_request(struct mapped_device *md,
 	if (!rq->q->mq_ops)
 		dm_old_requeue_request(rq);
 	else
-		dm_mq_requeue_request(rq);
+		dm_mq_delay_requeue_request(rq, delay_requeue ? 5000 : 0);
 
 	rq_completed(md, rw, false);
 }
@@ -389,7 +391,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 		return;
 	else if (r == DM_ENDIO_REQUEUE)
 		/* The target wants to requeue the I/O */
-		dm_requeue_original_request(tio->md, tio->orig);
+		dm_requeue_original_request(tio, false);
 	else {
 		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
@@ -629,8 +631,8 @@ static int dm_old_prep_fn(struct request_queue *q, struct request *rq)
 
 /*
  * Returns:
- * 0                : the request has been processed
- * DM_MAPIO_REQUEUE : the original request needs to be requeued
+ * DM_MAPIO_*       : the request has been processed as indicated
+ * DM_MAPIO_REQUEUE : the original request needs to be immediately requeued
  * < 0              : the request was completed due to failure
  */
 static int map_request(struct dm_rq_target_io *tio, struct request *rq,
@@ -643,6 +645,8 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 	if (tio->clone) {
 		clone = tio->clone;
 		r = ti->type->map_rq(ti, clone, &tio->info);
+		if (r == DM_MAPIO_DELAY_REQUEUE)
+			return DM_MAPIO_REQUEUE; /* .request_fn requeue is always immediate */
 	} else {
 		r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
 		if (r < 0) {
@@ -650,9 +654,8 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 			dm_kill_unmapped_request(rq, r);
 			return r;
 		}
-		if (r != DM_MAPIO_REMAPPED)
-			return r;
-		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
+		if (r == DM_MAPIO_REMAPPED &&
+		    setup_clone(clone, rq, tio, GFP_ATOMIC)) {
 			/* -ENOMEM */
 			ti->type->release_clone_rq(clone);
 			return DM_MAPIO_REQUEUE;
@@ -671,7 +674,10 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
-		dm_requeue_original_request(md, tio->orig);
+		break;
+	case DM_MAPIO_DELAY_REQUEUE:
+		/* The target wants to requeue the I/O after a delay */
+		dm_requeue_original_request(tio, true);
 		break;
 	default:
 		if (r > 0) {
@@ -681,10 +687,9 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 
 		/* The target wants to complete the I/O */
 		dm_kill_unmapped_request(rq, r);
-		return r;
 	}
 
-	return 0;
+	return r;
 }
 
 static void dm_start_request(struct mapped_device *md, struct request *orig)
@@ -727,7 +732,7 @@ static void map_tio_request(struct kthread_work *work)
 	struct mapped_device *md = tio->md;
 
 	if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE)
-		dm_requeue_original_request(md, rq);
+		dm_requeue_original_request(tio, false);
 }
 
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, char *buf)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 91acfce..ef7962e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -590,6 +590,7 @@ extern struct ratelimit_state dm_ratelimit_state;
 #define DM_MAPIO_SUBMITTED	0
 #define DM_MAPIO_REMAPPED	1
 #define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
+#define DM_MAPIO_DELAY_REQUEUE	3
 
 #define dm_sector_div64(x, y)( \
 { \
-- 
2.7.4 (Apple Git-66)

