From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/4] dm core: use generic clone setup interface
Date: Fri, 19 Jun 2009 16:51:21 +0900
Message-ID: <4A3B4379.1010104@ct.jp.nec.com>
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

This patch changes to use the block-layer's clone setup interface
instead of setting clone up internally in request-based dm.

As a result, some internal functions aren't needed anymore,
so removed them.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   94 ++++++++++----------------------------------------------
 1 file changed, 18 insertions(+), 76 deletions(-)

Index: 2.6.31-rc/drivers/md/dm.c
===================================================================
--- 2.6.31-rc.orig/drivers/md/dm.c
+++ 2.6.31-rc/drivers/md/dm.c
@@ -709,17 +709,6 @@ static void end_clone_bio(struct bio *cl
 	blk_update_request(tio->orig, 0, nr_bytes);
 }
 
-static void free_bio_clone(struct request *clone)
-{
-	struct bio *bio;
-
-	while ((bio = clone->bio) != NULL) {
-		clone->bio = bio->bi_next;
-
-		bio_put(bio);
-	}
-}
-
 /*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
@@ -757,7 +746,7 @@ static void dm_unprep_request(struct req
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
 
-	free_bio_clone(clone);
+	blk_rq_unprep_clone(clone);
 	free_rq_tio(tio);
 }
 
@@ -1396,85 +1385,38 @@ static void dm_rq_bio_destructor(struct 
 	bio_free(bio, md->bs);
 }
 
-static void copy_request_info(struct request *clone, struct request *rq)
-{
-	clone->cpu = rq->cpu;
-	clone->cmd_flags = (rq_data_dir(rq) | REQ_NOMERGE);
-	clone->cmd_type = rq->cmd_type;
-	clone->__sector = blk_rq_pos(rq);
-	clone->__data_len = blk_rq_bytes(rq);
-	clone->nr_phys_segments = rq->nr_phys_segments;
-	clone->ioprio = rq->ioprio;
-	clone->buffer = rq->buffer;
-	clone->cmd_len = rq->cmd_len;
-	if (rq->cmd_len)
-		clone->cmd = rq->cmd;
-	clone->extra_len = rq->extra_len;
-	clone->sense = rq->sense;
-}
-
-static int clone_request_bios(struct request *clone, struct request *rq,
-			      struct dm_rq_target_io *tio)
+static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
+				 void *data)
 {
+	struct dm_rq_target_io *tio = data;
 	struct mapped_device *md = tio->md;
-	struct bio *bio, *clone_bio;
-	struct dm_rq_clone_bio_info *info;
+	struct dm_rq_clone_bio_info *info = alloc_bio_info(md);
 
-	for (bio = rq->bio; bio; bio = bio->bi_next) {
-		info = alloc_bio_info(md);
-		if (!info)
-			goto free_and_out;
-
-		info->tio = tio;
-		info->orig = bio;
-
-		clone_bio = bio_alloc_bioset(GFP_ATOMIC, bio->bi_max_vecs,
-					     md->bs);
-		if (!clone_bio) {
-			free_bio_info(info);
-			goto free_and_out;
-		}
-
-		__bio_clone(clone_bio, bio);
-
-		if (bio_integrity(bio) &&
-		    !bio_integrity_clone(clone_bio, bio, GFP_ATOMIC)) {
-			bio_free(clone_bio, md->bs);
-			free_bio_info(info);
-			goto free_and_out;
-		}
+	if (!info)
+		return -ENOMEM;
 
-		clone_bio->bi_destructor = dm_rq_bio_destructor;
-		clone_bio->bi_end_io = end_clone_bio;
-		clone_bio->bi_private = info;
-
-		if (clone->bio) {
-			clone->biotail->bi_next = clone_bio;
-			clone->biotail = clone_bio;
-		} else
-			clone->bio = clone->biotail = clone_bio;
-	}
+	info->orig = bio_orig;
+	info->tio = tio;
+	bio->bi_end_io = end_clone_bio;
+	bio->bi_private = info;
+	bio->bi_destructor = dm_rq_bio_destructor;
 
 	return 0;
-
-free_and_out:
-	free_bio_clone(clone);
-
-	return -ENOMEM;
 }
 
 static int setup_clone(struct request *clone, struct request *rq,
 		       struct dm_rq_target_io *tio)
 {
-	int r;
-
-	blk_rq_init(NULL, clone);
+	int r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
+				  dm_rq_bio_constructor, tio);
 
-	r = clone_request_bios(clone, rq, tio);
 	if (r)
 		return r;
 
-	copy_request_info(clone, rq);
+	clone->cmd = rq->cmd;
+	clone->cmd_len = rq->cmd_len;
+	clone->sense = rq->sense;
+	clone->buffer = rq->buffer;
 	clone->end_io = end_clone_request;
 	clone->end_io_data = tio;
 
