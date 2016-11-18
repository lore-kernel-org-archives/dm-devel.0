From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 03/14] dm: Fix a race condition in rq_completed()
Date: Fri, 18 Nov 2016 14:27:08 -0800
Message-ID: <719b58ac-3e7e-80fb-d5ca-313559a399fe@sandisk.com>
References: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <32edbd52-5b1a-b093-0195-2ec6fa73cd6f@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

It is required to hold the queue lock when calling blk_run_queue_async()
to avoid that a race between blk_run_queue_async() and
blk_cleanup_queue() is triggered.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-rq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f9f37ad..7df7948 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -210,6 +210,9 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
  */
 static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 {
+	struct request_queue *q = md->queue;
+	unsigned long flags;
+
 	atomic_dec(&md->pending[rw]);
 
 	/* nudge anyone waiting on suspend queue */
@@ -222,8 +225,11 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	 * back into ->request_fn() could deadlock attempting to grab the
 	 * queue lock again.
 	 */
-	if (!md->queue->mq_ops && run_queue)
-		blk_run_queue_async(md->queue);
+	if (!q->mq_ops && run_queue) {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_run_queue_async(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
2.10.1
