From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 3/4] dm core: remove 'md' argument from
	free_rq_tio()
Date: Fri, 19 Jun 2009 16:50:40 +0900
Message-ID: <4A3B4350.10209@ct.jp.nec.com>
References: <4A3B40D4.1040905@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A3B40D4.1040905@ct.jp.nec.com>
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

This patch removes the unneeded argument 'md' from free_rq_tio().
'md' can be gotten by tio->md in free_rq_tio(), so removed it
from argument.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: 2.6.31-rc/drivers/md/dm.c
===================================================================
--- 2.6.31-rc.orig/drivers/md/dm.c
+++ 2.6.31-rc/drivers/md/dm.c
@@ -434,9 +434,9 @@ static struct dm_rq_target_io *alloc_rq_
 	return mempool_alloc(md->tio_pool, GFP_ATOMIC);
 }
 
-static void free_rq_tio(struct mapped_device *md, struct dm_rq_target_io *tio)
+static void free_rq_tio(struct dm_rq_target_io *tio)
 {
-	mempool_free(tio, md->tio_pool);
+	mempool_free(tio, tio->md->tio_pool);
 }
 
 static struct dm_rq_clone_bio_info *alloc_bio_info(struct mapped_device *md)
@@ -444,10 +444,9 @@ static struct dm_rq_clone_bio_info *allo
 	return mempool_alloc(md->io_pool, GFP_ATOMIC);
 }
 
-static void free_bio_info(struct mapped_device *md,
-			  struct dm_rq_clone_bio_info *info)
+static void free_bio_info(struct dm_rq_clone_bio_info *info)
 {
-	mempool_free(info, md->io_pool);
+	mempool_free(info, info->tio->md->io_pool);
 }
 
 static void start_io_acct(struct dm_io *io)
@@ -759,7 +758,7 @@ static void dm_unprep_request(struct req
 	rq->cmd_flags &= ~REQ_DONTPREP;
 
 	free_bio_clone(clone);
-	free_rq_tio(tio->md, tio);
+	free_rq_tio(tio);
 }
 
 /*
@@ -838,7 +837,7 @@ static void dm_end_request(struct reques
 	}
 
 	BUG_ON(clone->bio);
-	free_rq_tio(md, tio);
+	free_rq_tio(tio);
 
 	blk_end_request_all(rq, error);
 
@@ -1393,7 +1392,7 @@ static void dm_rq_bio_destructor(struct 
 	struct dm_rq_clone_bio_info *info = bio->bi_private;
 	struct mapped_device *md = info->tio->md;
 
-	free_bio_info(md, info);
+	free_bio_info(info);
 	bio_free(bio, md->bs);
 }
 
@@ -1426,10 +1425,13 @@ static int clone_request_bios(struct req
 		if (!info)
 			goto free_and_out;
 
+		info->tio = tio;
+		info->orig = bio;
+
 		clone_bio = bio_alloc_bioset(GFP_ATOMIC, bio->bi_max_vecs,
 					     md->bs);
 		if (!clone_bio) {
-			free_bio_info(md, info);
+			free_bio_info(info);
 			goto free_and_out;
 		}
 
@@ -1438,14 +1440,12 @@ static int clone_request_bios(struct req
 		if (bio_integrity(bio) &&
 		    !bio_integrity_clone(clone_bio, bio, GFP_ATOMIC)) {
 			bio_free(clone_bio, md->bs);
-			free_bio_info(md, info);
+			free_bio_info(info);
 			goto free_and_out;
 		}
 
 		clone_bio->bi_destructor = dm_rq_bio_destructor;
 		clone_bio->bi_end_io = end_clone_bio;
-		info->tio = tio;
-		info->orig = bio;
 		clone_bio->bi_private = info;
 
 		if (clone->bio) {
@@ -1522,7 +1522,7 @@ static int dm_prep_fn(struct request_que
 	clone = &tio->clone;
 	if (setup_clone(clone, rq, tio)) {
 		/* -ENOMEM */
-		free_rq_tio(md, tio);
+		free_rq_tio(tio);
 		return BLKPREP_DEFER;
 	}
 
