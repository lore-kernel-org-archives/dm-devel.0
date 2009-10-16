From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/9] rqdm core: clean up request cloning
Date: Fri, 16 Oct 2009 13:59:53 +0900
Message-ID: <4AD7FDC9.3020805@ct.jp.nec.com>
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

This patch factors out the request cloning code in dm_prep_fn()
as clone_rq().  No functional change.

This patch is a preparation for PATCH 9, which needs to make clones
from an original barrier request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

Index: 2.6.32-rc4/drivers/md/dm.c
===================================================================
--- 2.6.32-rc4.orig/drivers/md/dm.c
+++ 2.6.32-rc4/drivers/md/dm.c
@@ -1443,6 +1443,32 @@ static int setup_clone(struct request *c
 	return 0;
 }
 
+static struct request *clone_rq(struct request *rq, struct mapped_device *md,
+				gfp_t gfp_mask)
+{
+	struct request *clone;
+	struct dm_rq_target_io *tio;
+
+	tio = alloc_rq_tio(md, gfp_mask);
+	if (!tio)
+		return NULL;
+
+	tio->md = md;
+	tio->ti = NULL;
+	tio->orig = rq;
+	tio->error = 0;
+	memset(&tio->info, 0, sizeof(tio->info));
+
+	clone = &tio->clone;
+	if (setup_clone(clone, rq, tio)) {
+		/* -ENOMEM */
+		free_rq_tio(tio);
+		return NULL;
+	}
+
+	return clone;
+}
+
 static int dm_rq_flush_suspending(struct mapped_device *md)
 {
 	return !md->suspend_rq.special;
@@ -1454,7 +1480,6 @@ static int dm_rq_flush_suspending(struct
 static int dm_prep_fn(struct request_queue *q, struct request *rq)
 {
 	struct mapped_device *md = q->queuedata;
-	struct dm_rq_target_io *tio;
 	struct request *clone;
 
 	if (unlikely(rq == &md->suspend_rq)) {
@@ -1470,24 +1495,10 @@ static int dm_prep_fn(struct request_que
 		return BLKPREP_KILL;
 	}
 
-	tio = alloc_rq_tio(md, GFP_ATOMIC);
-	if (!tio)
-		/* -ENOMEM */
+	clone = clone_rq(rq, md, GFP_ATOMIC);
+	if (!clone)
 		return BLKPREP_DEFER;
 
-	tio->md = md;
-	tio->ti = NULL;
-	tio->orig = rq;
-	tio->error = 0;
-	memset(&tio->info, 0, sizeof(tio->info));
-
-	clone = &tio->clone;
-	if (setup_clone(clone, rq, tio)) {
-		/* -ENOMEM */
-		free_rq_tio(tio);
-		return BLKPREP_DEFER;
-	}
-
 	rq->special = clone;
 	rq->cmd_flags |= REQ_DONTPREP;
 
