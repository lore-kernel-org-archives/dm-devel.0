From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 8/9] rqdm core: move dm_end_request()
Date: Fri, 16 Oct 2009 14:05:10 +0900
Message-ID: <4AD7FF06.2030604@ct.jp.nec.com>
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

This patch moves dm_end_request().  No functional change.

This patch is a preparation for PATCH 9.
In PATCH 9, dm_requeue_unmapped_request() calls dm_end_request().
So this patch moves it before dm_requeue_unmapped_request() to reduce
the patch size of PATCH 9.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   62 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -750,6 +750,37 @@ static void free_rq_clone(struct request
 	free_rq_tio(tio);
 }
 
+/*
+ * Complete the clone and the original request.
+ * Must be called without queue lock.
+ */
+static void dm_end_request(struct request *clone, int error)
+{
+	int rw = rq_data_dir(clone);
+	struct dm_rq_target_io *tio = clone->end_io_data;
+	struct mapped_device *md = tio->md;
+	struct request *rq = tio->orig;
+
+	if (blk_pc_request(rq)) {
+		rq->errors = clone->errors;
+		rq->resid_len = clone->resid_len;
+
+		if (rq->sense)
+			/*
+			 * We are using the sense buffer of the original
+			 * request.
+			 * So setting the length of the sense data is enough.
+			 */
+			rq->sense_len = clone->sense_len;
+	}
+
+	free_rq_clone(clone);
+
+	blk_end_request_all(rq, error);
+
+	rq_completed(md, rw, 1);
+}
+
 static void dm_unprep_request(struct request *rq)
 {
 	struct request *clone = rq->special;
@@ -813,37 +844,6 @@ static void start_queue(struct request_q
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-/*
- * Complete the clone and the original request.
- * Must be called without queue lock.
- */
-static void dm_end_request(struct request *clone, int error)
-{
-	int rw = rq_data_dir(clone);
-	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
-	struct request *rq = tio->orig;
-
-	if (blk_pc_request(rq)) {
-		rq->errors = clone->errors;
-		rq->resid_len = clone->resid_len;
-
-		if (rq->sense)
-			/*
-			 * We are using the sense buffer of the original
-			 * request.
-			 * So setting the length of the sense data is enough.
-			 */
-			rq->sense_len = clone->sense_len;
-	}
-
-	free_rq_clone(clone);
-
-	blk_end_request_all(rq, error);
-
-	rq_completed(md, rw, 1);
-}
-
 static void dm_done(struct request *clone, int error, bool mapped)
 {
 	int r = error;
