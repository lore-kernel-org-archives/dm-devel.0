From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/4] dm core: clean up completion handling of
	clone bio
Date: Fri, 19 Jun 2009 16:50:00 +0900
Message-ID: <4A3B4328.6010609@ct.jp.nec.com>
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

This patch cleans up completion handling of clone bio.
struct bio has ->bi_destructor to complete itself, so use it for
request-based dm, too.

Since the destructor can be called before the request is fully
cloned, the 'struct request *rq' of struct dm_rq_clone_bio_info
has been replaced with 'struct dm_rq_target_io *tio' so that
the destructor can find 'tio' safely (i.e. not via rq->end_io_data).

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

Index: 2.6.31-rc/drivers/md/dm.c
===================================================================
--- 2.6.31-rc.orig/drivers/md/dm.c
+++ 2.6.31-rc/drivers/md/dm.c
@@ -78,7 +78,7 @@ struct dm_rq_target_io {
  */
 struct dm_rq_clone_bio_info {
 	struct bio *orig;
-	struct request *rq;
+	struct dm_rq_target_io *tio;
 };
 
 union map_info *dm_get_mapinfo(struct bio *bio)
@@ -666,12 +666,10 @@ static void clone_endio(struct bio *bio,
 static void end_clone_bio(struct bio *clone, int error)
 {
 	struct dm_rq_clone_bio_info *info = clone->bi_private;
-	struct dm_rq_target_io *tio = info->rq->end_io_data;
+	struct dm_rq_target_io *tio = info->tio;
 	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_size;
 
-	free_bio_info(tio->md, info);
-	clone->bi_private = tio->md->bs;
 	bio_put(clone);
 
 	if (tio->error)
@@ -712,18 +710,13 @@ static void end_clone_bio(struct bio *cl
 	blk_update_request(tio->orig, 0, nr_bytes);
 }
 
-static void free_bio_clone(struct mapped_device *md, struct request *clone)
+static void free_bio_clone(struct request *clone)
 {
 	struct bio *bio;
-	struct dm_rq_clone_bio_info *info;
 
 	while ((bio = clone->bio) != NULL) {
 		clone->bio = bio->bi_next;
 
-		info = bio->bi_private;
-		free_bio_info(md, info);
-
-		bio->bi_private = md->bs;
 		bio_put(bio);
 	}
 }
@@ -761,13 +754,12 @@ static void dm_unprep_request(struct req
 {
 	struct request *clone = rq->special;
 	struct dm_rq_target_io *tio = clone->end_io_data;
-	struct mapped_device *md = tio->md;
 
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
 
-	free_bio_clone(md, clone);
-	free_rq_tio(md, tio);
+	free_bio_clone(clone);
+	free_rq_tio(tio->md, tio);
 }
 
 /*
@@ -1396,6 +1388,15 @@ void dm_dispatch_request(struct request 
 }
 EXPORT_SYMBOL_GPL(dm_dispatch_request);
 
+static void dm_rq_bio_destructor(struct bio *bio)
+{
+	struct dm_rq_clone_bio_info *info = bio->bi_private;
+	struct mapped_device *md = info->tio->md;
+
+	free_bio_info(md, info);
+	bio_free(bio, md->bs);
+}
+
 static void copy_request_info(struct request *clone, struct request *rq)
 {
 	clone->cpu = rq->cpu;
@@ -1414,8 +1415,9 @@ static void copy_request_info(struct req
 }
 
 static int clone_request_bios(struct request *clone, struct request *rq,
-			      struct mapped_device *md)
+			      struct dm_rq_target_io *tio)
 {
+	struct mapped_device *md = tio->md;
 	struct bio *bio, *clone_bio;
 	struct dm_rq_clone_bio_info *info;
 
@@ -1440,9 +1442,9 @@ static int clone_request_bios(struct req
 			goto free_and_out;
 		}
 
-		clone_bio->bi_destructor = dm_bio_destructor;
+		clone_bio->bi_destructor = dm_rq_bio_destructor;
 		clone_bio->bi_end_io = end_clone_bio;
-		info->rq = clone;
+		info->tio = tio;
 		info->orig = bio;
 		clone_bio->bi_private = info;
 
@@ -1456,7 +1458,7 @@ static int clone_request_bios(struct req
 	return 0;
 
 free_and_out:
-	free_bio_clone(md, clone);
+	free_bio_clone(clone);
 
 	return -ENOMEM;
 }
@@ -1468,7 +1470,7 @@ static int setup_clone(struct request *c
 
 	blk_rq_init(NULL, clone);
 
-	r = clone_request_bios(clone, rq, tio->md);
+	r = clone_request_bios(clone, rq, tio);
 	if (r)
 		return r;
 
