From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 7/9] rqdm core: refactor completion functions
Date: Fri, 16 Oct 2009 14:03:42 +0900
Message-ID: <4AD7FEAE.5050603@ct.jp.nec.com>
References: <4AD7FC11.7030009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AD7FC11.7030009@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch factors out the clone completion code, dm_done(),
from dm_softirq_done().  No functional change.

This patch is a preparation for PATCH 9.
dm_done() will be used in barrier completion, which can't use and
doesn't need softirq.
The softirq_done callback needs to get a clone from given original
request but it can't in the case of barrier, where an original
request is shared by multiple clones.
On the other hand, the completion of barrier clones doesn't involve
re-submitting requests, which was the primary reason of the need for
softirq.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -844,35 +844,46 @@ static void dm_end_request(struct reques
 	rq_completed(md, rw, 1);
 }
 
-/*
- * Request completion handler for request-based dm
- */
-static void dm_softirq_done(struct request *rq)
+static void dm_done(struct request *clone, int error, bool mapped)
 {
-	struct request *clone = rq->completion_data;
+	int r = error;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
-	int error = tio->error;
 
-	if (!(rq->cmd_flags & REQ_FAILED) && rq_end_io)
-		error = rq_end_io(tio->ti, clone, error, &tio->info);
+	if (mapped && rq_end_io)
+		r = rq_end_io(tio->ti, clone, error, &tio->info);
 
-	if (error <= 0)
+	if (r <= 0)
 		/* The target wants to complete the I/O */
-		dm_end_request(clone, error);
-	else if (error == DM_ENDIO_INCOMPLETE)
+		dm_end_request(clone, r);
+	else if (r == DM_ENDIO_INCOMPLETE)
 		/* The target will handle the I/O */
 		return;
-	else if (error == DM_ENDIO_REQUEUE)
+	else if (r == DM_ENDIO_REQUEUE)
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(clone);
 	else {
-		DMWARN("unimplemented target endio return value: %d", error);
+		DMWARN("unimplemented target endio return value: %d", r);
 		BUG();
 	}
 }
 
 /*
+ * Request completion handler for request-based dm
+ */
+static void dm_softirq_done(struct request *rq)
+{
+	bool mapped = true;
+	struct request *clone = rq->completion_data;
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	if (rq->cmd_flags & REQ_FAILED)
+		mapped = false;
+
+	dm_done(clone, tio->error, mapped);
+}
+
+/*
  * Complete the clone and the original request with the error status
  * through softirq context.
  */
