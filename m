From: Minfei Huang <mnghuan@gmail.com>
Subject: [PATCH] dm: Check kthread_run's return value
Date: Wed, 22 Jun 2016 10:32:35 +0800
Message-ID: <1466562755-95336-1-git-send-email-mnghuan@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, shli@kernel.org
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, minfei.hmf@alibaba-inc.com, Minfei Huang <mnghuan@gmail.com>
List-Id: dm-devel.ids

kthread function is used to process kthread_work. And there is no return
value checking during create this thread. Add this checking to fix this
issue.

Signed-off-by: Minfei Huang <mnghuan@gmail.com>
Signed-off-by: Minfei Huang <minfei.hmf@alibaba-inc.com>
---
 drivers/md/dm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b2f962..d68b9d2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2654,12 +2654,15 @@ struct queue_limits *dm_get_queue_limits(struct mapped_device *md)
 }
 EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 
-static void dm_old_init_rq_based_worker_thread(struct mapped_device *md)
+static int dm_old_init_rq_based_worker_thread(struct mapped_device *md)
 {
 	/* Initialize the request-based DM worker thread */
 	init_kthread_worker(&md->kworker);
 	md->kworker_task = kthread_run(kthread_worker_fn, &md->kworker,
 				       "kdmwork-%s", dm_device_name(md));
+	if (IS_ERR(md->kworker_task))
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -2667,6 +2670,8 @@ static void dm_old_init_rq_based_worker_thread(struct mapped_device *md)
  */
 static int dm_old_init_request_queue(struct mapped_device *md)
 {
+	int ret;
+
 	/* Fully initialize the queue */
 	if (!blk_init_allocated_queue(md->queue, dm_request_fn, NULL))
 		return -EINVAL;
@@ -2678,7 +2683,9 @@ static int dm_old_init_request_queue(struct mapped_device *md)
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_old_prep_fn);
 
-	dm_old_init_rq_based_worker_thread(md);
+	ret = dm_old_init_rq_based_worker_thread(md);
+	if (ret < 0)
+		return ret;
 
 	elv_register_queue(md->queue);
 
-- 
2.7.4 (Apple Git-66)

