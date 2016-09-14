From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 4/6] dm rq: introduce dm_mq_kick_requeue_list()
Date: Wed, 14 Sep 2016 12:29:34 -0400
Message-ID: <1473870576-54331-5-git-send-email-snitzer@redhat.com>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

Make it possible for a request-based target to kick the DM device's
blk-mq request_queue's requeue_list.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 17 +++++++++++++----
 drivers/md/dm-rq.h |  2 ++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index bdbfe05..726cb3b 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -336,19 +336,28 @@ static void dm_old_requeue_request(struct request *rq)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
+static void __dm_mq_kick_requeue_list(struct request_queue *q, unsigned long msecs)
 {
-	struct request_queue *q = rq->q;
 	unsigned long flags;
 
-	blk_mq_requeue_request(rq);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (!blk_queue_stopped(q))
 		blk_mq_delay_kick_requeue_list(q, msecs_to_jiffies(msecs));
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
+void dm_mq_kick_requeue_list(struct mapped_device *md)
+{
+	__dm_mq_kick_requeue_list(dm_get_md_queue(md), 0);
+}
+EXPORT_SYMBOL(dm_mq_kick_requeue_list);
+
+static void dm_mq_delay_requeue_request(struct request *rq, unsigned long msecs)
+{
+	blk_mq_requeue_request(rq);
+	__dm_mq_kick_requeue_list(rq->q, msecs);
+}
+
 static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_requeue)
 {
 	struct mapped_device *md = tio->md;
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 9e6f0a3..4da06ca 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -55,6 +55,8 @@ void dm_mq_cleanup_mapped_device(struct mapped_device *md);
 void dm_start_queue(struct request_queue *q);
 void dm_stop_queue(struct request_queue *q);
 
+void dm_mq_kick_requeue_list(struct mapped_device *md);
+
 unsigned dm_get_reserved_rq_based_ios(void);
 
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, char *buf);
-- 
2.7.4 (Apple Git-66)

