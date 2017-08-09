From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] block: Make blk_mq_delay_kick_requeue_list() rerun the queue at a quiet time
Date: Wed, 9 Aug 2017 11:28:06 -0700
Message-ID: <20170809182806.32741-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@wdc.com>, Mike Snitzer <snitzer@redhat.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

The blk_mq_delay_kick_requeue_list() function is used by the device
mapper and only by the device mapper to rerun the queue and requeue
list after a delay. This function is called once per request that
gets requeued. Modify this function such that the queue is run once
per path change event instead of once per request that is requeued.

Fixes: commit 2849450ad39d ("blk-mq: introduce blk_mq_delay_kick_requeue_list()")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
---
 block/blk-mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 041f7b7fa0d6..8bfea36e92f9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -679,8 +679,8 @@ EXPORT_SYMBOL(blk_mq_kick_requeue_list);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q,
 				    unsigned long msecs)
 {
-	kblockd_schedule_delayed_work(&q->requeue_work,
-				      msecs_to_jiffies(msecs));
+	kblockd_mod_delayed_work_on(WORK_CPU_UNBOUND, &q->requeue_work,
+				    msecs_to_jiffies(msecs));
 }
 EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
 
-- 
2.13.3
