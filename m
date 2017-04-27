From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 05/13] dm-mpath: Make it easier to analyze
	requeuing behavior
Date: Thu, 27 Apr 2017 10:11:18 -0700
Message-ID: <20170427171126.26814-6-bart.vanassche@sandisk.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170427171126.26814-1-bart.vanassche@sandisk.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

When debugging the dm-mpath driver it is important to know what
decisions have been taken with regard to requeuing. Hence this
patch that adds pr_debug() statements that report what decisions
have been taken.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 21 ++++++++++++++++++---
 drivers/md/dm-rq.c    |  5 ++++-
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d739688246a0..fc3e7f028110 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -501,8 +501,10 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 		pgpath = choose_pgpath(m, nr_bytes);
 
 	if (!pgpath) {
-		if (must_push_back_rq(m))
+		if (must_push_back_rq(m)) {
+			pr_debug("no path - requeueing\n");
 			return DM_MAPIO_DELAY_REQUEUE;
+		}
 		return -EIO;	/* Failed */
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
@@ -1425,17 +1427,23 @@ static void pg_init_done(void *data, int errors)
 		/* Activations of other paths are still on going */
 		goto out;
 
+	pr_debug("pg_init_in_progress = %d\n",
+		 atomic_read(&m->pg_init_in_progress));
+
 	if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		if (delay_retry)
 			set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
 		else
 			clear_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
 
-		if (__pg_init_all_paths(m))
+		if (__pg_init_all_paths(m)) {
+			pr_debug("__pg_init_all_paths() reported that initialization is ongoing\n");
 			goto out;
+		}
 	}
 	clear_bit(MPATHF_QUEUE_IO, &m->flags);
 
+	pr_debug("Processing queued I/O list\n");
 	process_queued_io_list(m);
 
 	/*
@@ -1932,8 +1940,11 @@ static int multipath_busy(struct dm_target *ti)
 	struct pgpath *pgpath;
 
 	/* pg_init in progress */
-	if (atomic_read(&m->pg_init_in_progress))
+	if (atomic_read(&m->pg_init_in_progress)) {
+		pr_debug("pg_init_in_progress = %d\n",
+			 atomic_read(&m->pg_init_in_progress));
 		return true;
+	}
 
 	/* no paths available, for blk-mq: rely on IO mapping to delay requeue */
 	if (!atomic_read(&m->nr_valid_paths) && test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
@@ -1980,6 +1991,10 @@ static int multipath_busy(struct dm_target *ti)
 		busy = false;
 	}
 
+
+	if (busy)
+		pr_debug("all active paths are busy\n");
+
 	return busy;
 }
 
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c53debdcd7dc..ba5694be55a4 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -737,8 +737,10 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		dm_put_live_table(md, srcu_idx);
 	}
 
-	if (ti->type->busy && ti->type->busy(ti))
+	if (ti->type->busy && ti->type->busy(ti)) {
+		pr_debug("ti->type->busy()\n");
 		return BLK_MQ_RQ_QUEUE_BUSY;
+	}
 
 	dm_start_request(md, rq);
 
@@ -756,6 +758,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
 		blk_mq_delay_run_hw_queue(hctx, 500/*ms*/);
+		pr_debug("DM_MAPIO_REQUEUE\n");
 		return BLK_MQ_RQ_QUEUE_BUSY;
 	}
 
-- 
2.12.2
