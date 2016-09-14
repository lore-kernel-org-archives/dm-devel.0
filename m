From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 3/6] dm rq: reduce arguments passed to map_request() and dm_requeue_original_request()
Date: Wed, 14 Sep 2016 12:29:33 -0400
Message-ID: <1473870576-54331-4-git-send-email-snitzer@redhat.com>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9eebc8d..bdbfe05 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -349,9 +349,10 @@ static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_requeue_original_request(struct mapped_device *md,
-					struct request *rq, bool delay_requeue)
+static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_requeue)
 {
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
 	int rw = rq_data_dir(rq);
 
 	rq_end_stats(md, rq);
@@ -390,7 +391,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 		return;
 	else if (r == DM_ENDIO_REQUEUE)
 		/* The target wants to requeue the I/O */
-		dm_requeue_original_request(tio->md, tio->orig, false);
+		dm_requeue_original_request(tio, false);
 	else {
 		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
@@ -634,11 +635,12 @@ static int dm_old_prep_fn(struct request_queue *q, struct request *rq)
  * DM_MAPIO_REQUEUE : the original request needs to be immediately requeued
  * < 0              : the request was completed due to failure
  */
-static int map_request(struct dm_rq_target_io *tio, struct request *rq,
-		       struct mapped_device *md)
+static int map_request(struct dm_rq_target_io *tio)
 {
 	int r;
 	struct dm_target *ti = tio->ti;
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
 	struct request *clone = NULL;
 
 	if (tio->clone) {
@@ -676,7 +678,7 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 		break;
 	case DM_MAPIO_DELAY_REQUEUE:
 		/* The target wants to requeue the I/O after a delay */
-		dm_requeue_original_request(md, tio->orig, true);
+		dm_requeue_original_request(tio, true);
 		break;
 	default:
 		if (r > 0) {
@@ -727,11 +729,9 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 static void map_tio_request(struct kthread_work *work)
 {
 	struct dm_rq_target_io *tio = container_of(work, struct dm_rq_target_io, work);
-	struct request *rq = tio->orig;
-	struct mapped_device *md = tio->md;
 
-	if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE)
-		dm_requeue_original_request(md, rq, false);
+	if (map_request(tio) == DM_MAPIO_REQUEUE)
+		dm_requeue_original_request(tio, false);
 }
 
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, char *buf)
@@ -917,7 +917,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	tio->ti = ti;
 
 	/* Direct call is fine since .queue_rq allows allocations */
-	if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE) {
+	if (map_request(tio) == DM_MAPIO_REQUEUE) {
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
-- 
2.7.4 (Apple Git-66)

