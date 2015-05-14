From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 06/14] dm: rename methods that requeue
	requests
Date: Thu, 14 May 2015 17:05:04 -0400
Message-ID: <1431637512-64245-7-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

More often than not a request that is requeued _is_ mapped (meaning the
clone request is allocated and clone->q is initialized).  Rename
dm_requeue_unmapped_original_request() and dm_requeue_unmapped_request()
to avoid potential confusion due to function names containing "unmapped".

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8502da7..c894d13 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1114,8 +1114,8 @@ static void old_requeue_request(struct request *rq)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_requeue_unmapped_original_request(struct mapped_device *md,
-						 struct request *rq)
+static void dm_requeue_original_request(struct mapped_device *md,
+					struct request *rq)
 {
 	int rw = rq_data_dir(rq);
 
@@ -1131,11 +1131,11 @@ static void dm_requeue_unmapped_original_request(struct mapped_device *md,
 	rq_completed(md, rw, false);
 }
 
-static void dm_requeue_unmapped_request(struct request *clone)
+static void dm_requeue_request(struct request *clone)
 {
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
-	dm_requeue_unmapped_original_request(tio->md, tio->orig);
+	dm_requeue_original_request(tio->md, tio->orig);
 }
 
 static void old_stop_queue(struct request_queue *q)
@@ -1201,7 +1201,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 		return;
 	else if (r == DM_ENDIO_REQUEUE)
 		/* The target wants to requeue the I/O */
-		dm_requeue_unmapped_request(clone);
+		dm_requeue_request(clone);
 	else {
 		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
@@ -1904,7 +1904,7 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
-		dm_requeue_unmapped_request(clone);
+		dm_requeue_request(clone);
 		break;
 	default:
 		if (r > 0) {
@@ -1927,7 +1927,7 @@ static void map_tio_request(struct kthread_work *work)
 	struct mapped_device *md = tio->md;
 
 	if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE)
-		dm_requeue_unmapped_original_request(md, rq);
+		dm_requeue_original_request(md, rq);
 }
 
 static void dm_start_request(struct mapped_device *md, struct request *orig)
@@ -2682,7 +2682,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	} else {
 		/* Direct call is fine since .queue_rq allows allocations */
 		if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE)
-			dm_requeue_unmapped_original_request(md, rq);
+			dm_requeue_original_request(md, rq);
 	}
 
 	return BLK_MQ_RQ_QUEUE_OK;
-- 
2.3.2 (Apple Git-55)
