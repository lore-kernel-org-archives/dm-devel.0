From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] dm: open-code free_rq_clone()
Date: Thu,  5 Jun 2014 15:11:06 +0200
Message-ID: <1401973867-121561-7-git-send-email-hare@suse.de>
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
 drivers/md/dm.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b2240f7..4da9941 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -866,23 +866,13 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	dm_put(md);
 }
 
-static void free_rq_clone(struct request *clone)
-{
-	struct dm_rq_target_io *tio = clone->end_io_data;
-
-	blk_rq_unprep_clone(clone);
-	free_rq_tio(tio);
-}
-
 /*
  * Complete the clone and the original request.
  * Must be called without queue lock.
  */
-static void dm_end_request(struct request *clone, int error)
+static void dm_end_request(struct request *clone, struct request *rq,
+			   int error)
 {
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct request *rq = tio->orig;
-
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		rq->errors = clone->errors;
 		rq->resid_len = clone->resid_len;
@@ -896,7 +886,6 @@ static void dm_end_request(struct request *clone, int error)
 			rq->sense_len = clone->sense_len;
 	}
 
-	free_rq_clone(clone);
 	blk_end_request_all(rq, error);
 }
 
@@ -967,14 +956,16 @@ static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
 			r = rq_end_io(tio->ti, clone, tio->error, &tio->info);
 	}
 
+	free_rq_tio(tio);
 	if (r <= 0) {
 		/* The target wants to complete the I/O */
-		dm_end_request(clone, r);
+		dm_end_request(clone, rq, r);
+		blk_rq_unprep_clone(clone);
 		rq_completed(md, rw, true);
 	} else if (r == DM_ENDIO_REQUEUE) {
 		/* The target wants to requeue the I/O */
-		free_rq_clone(clone);
 		dm_requeue_unmapped_request(rq);
+		blk_rq_unprep_clone(clone);
 		rq_completed(md, rw, false);
 	} else {
 		DMWARN("unimplemented target endio return value: %d", r);
@@ -1601,7 +1592,8 @@ static int map_request(struct dm_target *ti, struct request *clone,
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
-		free_rq_clone(clone);
+		free_rq_tio(tio);
+		blk_rq_unprep_clone(clone);
 		dm_requeue_unmapped_request(rq);
 		rq_completed(md, rw, false);
 		requeued = 1;
-- 
1.7.12.4
