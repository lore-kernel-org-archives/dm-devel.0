From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 7/7] dm-mpath: Make the dm-sq requeuing behavior
	consistent with the dm-mq behavior
Date: Wed, 9 Aug 2017 11:32:16 -0700
Message-ID: <20170809183216.526-8-bart.vanassche@wdc.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809183216.526-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

DM_MAPIO_DELAY_REQUEUE causes dm-mq to requeue after a delay but
causes dm-sq to requeue immediately. Make the behavior of dm-sq
consistent with that of dm-mq.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/dm-rq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c6ebc5b1e00e..cbee09054d1e 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -237,14 +237,14 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 /*
  * Requeue the original request of a clone.
  */
-static void dm_old_requeue_request(struct request *rq)
+static void dm_old_requeue_request(struct request *rq, unsigned long delay_ms)
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, rq);
-	blk_run_queue_async(q);
+	blk_delay_queue(q, delay_ms);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -270,6 +270,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 	int rw = rq_data_dir(rq);
+	unsigned long delay_ms = delay_requeue ? 100 : 0;
 
 	rq_end_stats(md, rq);
 	if (tio->clone) {
@@ -278,9 +279,9 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	}
 
 	if (!rq->q->mq_ops)
-		dm_old_requeue_request(rq);
+		dm_old_requeue_request(rq, delay_ms);
 	else
-		dm_mq_delay_requeue_request(rq, delay_requeue ? 100/*ms*/ : 0);
+		dm_mq_delay_requeue_request(rq, delay_ms);
 
 	rq_completed(md, rw, false);
 }
-- 
2.13.3
