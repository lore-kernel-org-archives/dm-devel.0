From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] dm-rq: don't call blk_mq_queue_stopped in dm_stop_queue()
Date: Fri, 19 Jun 2020 16:42:14 +0800
Message-ID: <20200619084214.337449-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

dm-rq won't stop queue, meantime blk-mq won't stop one queue too, so
remove the check.

dm_stop_queue() actually tries to quiesce hw queues via blk_mq_quiesce_queue(),
we can't check via blk_queue_quiesced for avoiding unnecessary queue
quiesce because the flag is set before synchronize_rcu() and dm_stop_queue
may be called when synchronize_rcu from another blk_mq_quiesce_queue is
in-progress.

Cc: linux-block@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f60c02512121..ed4d5ea66ccc 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -70,9 +70,6 @@ void dm_start_queue(struct request_queue *q)
 
 void dm_stop_queue(struct request_queue *q)
 {
-	if (blk_mq_queue_stopped(q))
-		return;
-
 	blk_mq_quiesce_queue(q);
 }
 
-- 
2.25.2
