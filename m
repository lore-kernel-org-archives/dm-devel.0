From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/8] dm: don't start current request if it
	would've merged with the previous
Date: Tue,  3 Mar 2015 19:47:09 -0500
Message-ID: <1425430031-78140-7-git-send-email-snitzer@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, jmoyer@redhat.com
List-Id: dm-devel.ids

Request-based DM's dm_request_fn() is so fast to pull requests off the
queue that steps need to be taken to promote merging by avoiding request
processing if it makes sense.

If the current request would've merged with previous request let the
current request stay on the queue longer.

Suggested-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c13477a..3242f4c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/kthread.h>
+#include <linux/elevator.h> /* for rq_end_sector() */
 
 #include <trace/events/block.h>
 
@@ -216,6 +217,10 @@ struct mapped_device {
 
 	struct kthread_worker kworker;
 	struct task_struct *kworker_task;
+
+	/* for request-based merge heuristic in dm_request_fn() */
+	sector_t last_rq_pos;
+	int last_rq_rw;
 };
 
 /*
@@ -1927,6 +1932,9 @@ static void dm_start_request(struct mapped_device *md, struct request *orig)
 	blk_start_request(orig);
 	atomic_inc(&md->pending[rq_data_dir(orig)]);
 
+	md->last_rq_pos = rq_end_sector(orig);
+	md->last_rq_rw = rq_data_dir(orig);
+
 	/*
 	 * Hold the md reference here for the in-flight I/O.
 	 * We can't rely on the reference count by device opener,
@@ -1979,6 +1987,10 @@ static void dm_request_fn(struct request_queue *q)
 			continue;
 		}
 
+		if (md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
+		    md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq))
+			goto delay_and_out;
+
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
-- 
1.9.3 (Apple Git-50)
