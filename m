From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/8] dm: remove request-based DM queue's
	lld_busy_fn hook
Date: Tue,  3 Mar 2015 19:47:05 -0500
Message-ID: <1425430031-78140-3-git-send-email-snitzer@redhat.com>
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

DM multipath is the only caller of blk_lld_busy() -- which calls a
queue's lld_busy_fn hook.  Request-based DM doesn't support stacking
multipath devices so there is no reason to register the lld_busy_fn hook
on a multipath device's queue using blk_queue_lld_busy().

As such, remove functions dm_lld_busy and dm_table_any_busy_target.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 14 --------------
 drivers/md/dm.c       | 17 -----------------
 drivers/md/dm.h       |  1 -
 3 files changed, 32 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6554d91..0573120 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1677,20 +1677,6 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 	return r;
 }
 
-int dm_table_any_busy_target(struct dm_table *t)
-{
-	unsigned i;
-	struct dm_target *ti;
-
-	for (i = 0; i < t->num_targets; i++) {
-		ti = t->targets + i;
-		if (ti->type->busy && ti->type->busy(ti))
-			return 1;
-	}
-
-	return 0;
-}
-
 struct mapped_device *dm_table_get_md(struct dm_table *t)
 {
 	return t->md;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e57a2f9..fcc3203 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2003,22 +2003,6 @@ out:
 	dm_put_live_table(md, srcu_idx);
 }
 
-static int dm_lld_busy(struct request_queue *q)
-{
-	int r;
-	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table_fast(md);
-
-	if (!map || test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))
-		r = 1;
-	else
-		r = dm_table_any_busy_target(map);
-
-	dm_put_live_table_fast(md);
-
-	return r;
-}
-
 static int dm_any_congested(void *congested_data, int bdi_bits)
 {
 	int r = bdi_bits;
@@ -2540,7 +2524,6 @@ static int dm_init_request_based_queue(struct mapped_device *md)
 	dm_init_md_queue(md);
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 	blk_queue_prep_rq(md->queue, dm_prep_fn);
-	blk_queue_lld_busy(md->queue, dm_lld_busy);
 
 	/* Also initialize the request-based DM worker thread */
 	init_kthread_worker(&md->kworker);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 59f53e7..db49586 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -70,7 +70,6 @@ void dm_table_presuspend_undo_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
-int dm_table_any_busy_target(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
-- 
1.9.3 (Apple Git-50)
