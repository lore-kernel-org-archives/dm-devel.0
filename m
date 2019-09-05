From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v5 2/7] block: Change elevator_init_mq() to
	always succeed
Date: Thu,  5 Sep 2019 18:51:30 +0900
Message-ID: <20190905095135.26026-3-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

If the default elevator chosen is mq-deadline, elevator_init_mq() may
return an error if mq-deadline initialization fails, leading to
blk_mq_init_allocated_queue() returning an error, which in turn will
cause the block device initialization to fail and the device not being
exposed.

Instead of taking such extreme measure, handle mq-deadline
initialization failures in the same manner as when mq-deadline is not
available (no module to load), that is, default to the "none" scheduler.
With this change, elevator_init_mq() return type can be changed to void.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c   |  8 +-------
 block/blk.h      |  2 +-
 block/elevator.c | 23 ++++++++++++-----------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 13923630e00a..ee4caf0c0807 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2842,8 +2842,6 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q)
 {
-	int ret = -ENOMEM;
-
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -2904,14 +2902,10 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	ret = elevator_init_mq(q);
-	if (ret)
-		goto err_tag_set;
+	elevator_init_mq(q);
 
 	return q;
 
-err_tag_set:
-	blk_mq_del_queue_tag_set(q);
 err_hctxs:
 	kfree(q->queue_hw_ctx);
 	q->nr_hw_queues = 0;
diff --git a/block/blk.h b/block/blk.h
index e4619fc5c99a..ed347f7a97b1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -184,7 +184,7 @@ void blk_account_io_done(struct request *req, u64 now);
 
 void blk_insert_flush(struct request *rq);
 
-int elevator_init_mq(struct request_queue *q);
+void elevator_init_mq(struct request_queue *q);
 int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e);
 void __elevator_exit(struct request_queue *, struct elevator_queue *);
diff --git a/block/elevator.c b/block/elevator.c
index 4721834815bb..2944c129760c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -628,34 +628,35 @@ static inline bool elv_support_iosched(struct request_queue *q)
 
 /*
  * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
- * if available, for single queue devices. If deadline isn't available OR we
- * have multiple queues, default to "none".
+ * if available, for single queue devices. If deadline isn't available OR
+ * deadline initialization fails OR we have multiple queues, default to "none".
  */
-int elevator_init_mq(struct request_queue *q)
+void elevator_init_mq(struct request_queue *q)
 {
 	struct elevator_type *e;
-	int err = 0;
+	int err;
 
 	if (!elv_support_iosched(q))
-		return 0;
+		return;
 
 	if (q->nr_hw_queues != 1)
-		return 0;
+		return;
 
 	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
 
 	if (unlikely(q->elevator))
-		goto out;
+		return;
 
 	e = elevator_get(q, "mq-deadline", false);
 	if (!e)
-		goto out;
+		return;
 
 	err = blk_mq_init_sched(q, e);
-	if (err)
+	if (err) {
+		pr_warn("\"%s\" elevator initialization failed, "
+			"falling back to \"none\"\n", e->elevator_name);
 		elevator_put(e);
-out:
-	return err;
+	}
 }
 
 
-- 
2.21.0
