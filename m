From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 06/15] dm: optimize dm_request_fn()
Date: Sun,  7 Feb 2016 10:53:28 -0500
Message-ID: <1454860417-3203-7-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

DM multipath is the only request-based DM target -- which only supports
tables with a single target that is immutable.  Leverage this fact in
dm_request_fn().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 47 +++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 312cc77..3dfcb5a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2069,12 +2069,18 @@ static bool dm_request_peeked_before_merge_deadline(struct mapped_device *md)
 static void dm_request_fn(struct request_queue *q)
 {
 	struct mapped_device *md = q->queuedata;
-	int srcu_idx;
-	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
-	struct dm_target *ti;
+	struct dm_target *ti = md->immutable_target;
 	struct request *rq;
 	struct dm_rq_target_io *tio;
-	sector_t pos;
+	sector_t pos = 0;
+
+	if (unlikely(!ti)) {
+		int srcu_idx;
+		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
+
+		ti = dm_table_find_target(map, pos);
+		dm_put_live_table(md, srcu_idx);
+	}
 
 	/*
 	 * For suspend, check blk_queue_stopped() and increment
@@ -2085,33 +2091,21 @@ static void dm_request_fn(struct request_queue *q)
 	while (!blk_queue_stopped(q)) {
 		rq = blk_peek_request(q);
 		if (!rq)
-			goto out;
+			return;
 
 		/* always use block 0 to find the target for flushes for now */
 		pos = 0;
 		if (!(rq->cmd_flags & REQ_FLUSH))
 			pos = blk_rq_pos(rq);
 
-		ti = dm_table_find_target(map, pos);
-		if (!dm_target_is_valid(ti)) {
-			/*
-			 * Must perform setup, that rq_completed() requires,
-			 * before calling dm_kill_unmapped_request
-			 */
-			DMERR_LIMIT("request attempted access beyond the end of device");
-			dm_start_request(md, rq);
-			dm_kill_unmapped_request(rq, -EIO);
-			continue;
+		if ((dm_request_peeked_before_merge_deadline(md) &&
+		     md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
+		     md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq)) ||
+		    (ti->type->busy && ti->type->busy(ti))) {
+			blk_delay_queue(q, HZ / 100);
+			return;
 		}
 
-		if (dm_request_peeked_before_merge_deadline(md) &&
-		    md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
-		    md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq))
-			goto delay_and_out;
-
-		if (ti->type->busy && ti->type->busy(ti))
-			goto delay_and_out;
-
 		dm_start_request(md, rq);
 
 		tio = tio_from_request(rq);
@@ -2120,13 +2114,6 @@ static void dm_request_fn(struct request_queue *q)
 		queue_kthread_work(&md->kworker, &tio->work);
 		BUG_ON(!irqs_disabled());
 	}
-
-	goto out;
-
-delay_and_out:
-	blk_delay_queue(q, HZ / 100);
-out:
-	dm_put_live_table(md, srcu_idx);
 }
 
 static int dm_any_congested(void *congested_data, int bdi_bits)
-- 
2.5.4 (Apple Git-61)
