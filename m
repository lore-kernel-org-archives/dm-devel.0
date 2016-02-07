From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 05/15] dm: optimize dm_mq_queue_rq()
Date: Sun,  7 Feb 2016 10:53:27 -0500
Message-ID: <1454860417-3203-6-git-send-email-snitzer@redhat.com>
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

DM multipath is the only dm-mq target.  But that aside, request-based DM
only supports tables with a single target that is immutable.  Leverage
this fact in dm_mq_queue_rq() by using the 'immutable_target' stored in
the mapped_device when the table was made active.  This saves the need
to even take the read-side of the SRCU via dm_{get,put}_live_table.

If the active DM table does not have an immutable target (e.g. "error"
target was swapped in) then fallback to the slow-path where the target
is looked up from the live table.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |  3 ++-
 drivers/md/dm-table.c | 10 ++++++++++
 drivers/md/dm.c       | 40 ++++++++++++++++++----------------------
 drivers/md/dm.h       |  1 +
 4 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index cfa29f5..3ddaa11 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1684,7 +1684,8 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 10, 0},
+	.version = {1, 11, 0},
+	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a49e62b..89180fd 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -920,6 +920,16 @@ struct target_type *dm_table_get_immutable_target_type(struct dm_table *t)
 	return t->immutable_target_type;
 }
 
+struct dm_target *dm_table_get_immutable_target(struct dm_table *t)
+{
+	/* Immutable target is implicitly a singleton */
+	if (t->num_targets > 1 ||
+	    !dm_target_is_immutable(t->targets[0].type))
+		return NULL;
+
+	return t->targets;
+}
+
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t)
 {
 	struct dm_target *uninitialized_var(ti);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c92e356..312cc77 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -154,6 +154,7 @@ struct mapped_device {
 	/* Protect queue and type against concurrent access. */
 	struct mutex type_lock;
 
+	struct dm_target *immutable_target;
 	struct target_type *immutable_target_type;
 
 	struct gendisk *disk;
@@ -2490,8 +2491,15 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	 * This must be done before setting the queue restrictions,
 	 * because request-based dm may be run just after the setting.
 	 */
-	if (dm_table_request_based(t))
+	if (dm_table_request_based(t)) {
 		stop_queue(q);
+		/*
+		 * Leverage the fact that request-based DM targets are
+		 * immutable singletons and establish md->immutable_target
+		 * - used to optimize both dm_request_fn and dm_mq_queue_rq
+		 */
+		md->immutable_target = dm_table_get_immutable_target(t);
+	}
 
 	__bind_mempools(md, t);
 
@@ -2562,7 +2570,6 @@ void dm_set_md_type(struct mapped_device *md, unsigned type)
 
 unsigned dm_get_md_type(struct mapped_device *md)
 {
-	BUG_ON(!mutex_is_locked(&md->type_lock));
 	return md->type;
 }
 
@@ -2639,28 +2646,15 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct request *rq = bd->rq;
 	struct dm_rq_target_io *tio = blk_mq_rq_to_pdu(rq);
 	struct mapped_device *md = tio->md;
-	int srcu_idx;
-	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
-	struct dm_target *ti;
-	sector_t pos;
+	struct dm_target *ti = md->immutable_target;
 
-	/* always use block 0 to find the target for flushes for now */
-	pos = 0;
-	if (!(rq->cmd_flags & REQ_FLUSH))
-		pos = blk_rq_pos(rq);
+	if (unlikely(!ti)) {
+		int srcu_idx;
+		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
 
-	ti = dm_table_find_target(map, pos);
-	if (!dm_target_is_valid(ti)) {
+		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
-		DMERR_LIMIT("request attempted access beyond the end of device");
-		/*
-		 * Must perform setup, that rq_completed() requires,
-		 * before returning BLK_MQ_RQ_QUEUE_ERROR
-		 */
-		dm_start_request(md, rq);
-		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
-	dm_put_live_table(md, srcu_idx);
 
 	if (ti->type->busy && ti->type->busy(ti))
 		return BLK_MQ_RQ_QUEUE_BUSY;
@@ -2676,8 +2670,10 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 */
 	tio->ti = ti;
 
-	/* Clone the request if underlying devices aren't blk-mq */
-	if (dm_table_get_type(map) == DM_TYPE_REQUEST_BASED) {
+	/*
+	 * Both the table and md type cannot change after initial table load
+	 */
+	if (dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) {
 		/* clone request is allocated at the end of the pdu */
 		tio->clone = (void *)blk_mq_rq_to_pdu(rq) + sizeof(struct dm_rq_target_io);
 		(void) clone_rq(rq, md, tio, GFP_ATOMIC);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 53df258..4305a51 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -73,6 +73,7 @@ int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 unsigned dm_table_get_type(struct dm_table *t);
 struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
+struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
 struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 bool dm_table_mq_request_based(struct dm_table *t);
-- 
2.5.4 (Apple Git-61)
