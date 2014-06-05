From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/7] dm: move rq_completed() out of enclosing
	functions
Date: Thu,  5 Jun 2014 15:11:03 +0200
Message-ID: <1401973867-121561-4-git-send-email-hare@suse.de>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1401973867-121561-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0fa0884..f55ca0c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -880,9 +880,7 @@ static void free_rq_clone(struct request *clone)
  */
 static void dm_end_request(struct request *clone, int error)
 {
-	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
@@ -900,7 +898,6 @@ static void dm_end_request(struct request *clone, int error)
 
 	free_rq_clone(clone);
 	blk_end_request_all(rq, error);
-	rq_completed(md, rw, true);
 }
 
 static void dm_unprep_request(struct request *rq)
@@ -916,12 +913,8 @@ static void dm_unprep_request(struct request *rq)
 /*
  * Requeue the original request of a clone.
  */
-void dm_requeue_unmapped_request(struct request *clone)
+void dm_requeue_unmapped_request(struct request *rq)
 {
-	int rw = rq_data_dir(clone);
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
-	struct request *rq = tio->orig;
 	struct request_queue *q = rq->q;
 	unsigned long flags;
 
@@ -930,8 +923,6 @@ void dm_requeue_unmapped_request(struct request *clone)
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	rq_completed(md, rw, 0);
 }
 EXPORT_SYMBOL_GPL(dm_requeue_unmapped_request);
 
@@ -969,6 +960,9 @@ static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
 {
 	int r = tio->error;
 	dm_request_endio_fn rq_end_io = NULL;
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
+	int rw = rq_data_dir(clone);
 
 	if (tio->ti) {
 		rq_end_io = tio->ti->type->rq_end_io;
@@ -977,13 +971,15 @@ static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
 			r = rq_end_io(tio->ti, clone, tio->error, &tio->info);
 	}
 
-	if (r <= 0)
+	if (r <= 0) {
 		/* The target wants to complete the I/O */
 		dm_end_request(clone, r);
-	else if (r == DM_ENDIO_REQUEUE)
+		rq_completed(md, rw, true);
+	} else if (r == DM_ENDIO_REQUEUE) {
 		/* The target wants to requeue the I/O */
-		dm_requeue_unmapped_request(clone);
-	else {
+		dm_requeue_unmapped_request(rq);
+		rq_completed(md, rw, false);
+	} else {
 		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
 	}
@@ -1607,6 +1603,8 @@ static int map_request(struct dm_target *ti, struct request *clone,
 {
 	int r, requeued = 0;
 	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct request *rq = tio->orig;
+	int rw = rq_data_dir(clone);
 
 	tio->ti = ti;
 	r = ti->type->map_rq(ti, clone, &tio->info);
@@ -1617,12 +1615,13 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	case DM_MAPIO_REMAPPED:
 		/* The target has remapped the I/O so dispatch it */
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
-				     blk_rq_pos(tio->orig));
+				     blk_rq_pos(rq));
 		dm_dispatch_request(clone);
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
-		dm_requeue_unmapped_request(clone);
+		dm_requeue_unmapped_request(rq);
+		rq_completed(md, rw, false);
 		requeued = 1;
 		break;
 	default:
-- 
1.7.12.4
