From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 1/5] dm: avoid indirect call in __dm_make_request
Date: Tue, 06 Nov 2018 22:34:59 +0100
Message-ID: <20181106213853.335317680@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-avoid-indirect-call.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Indirect calls are inefficient because of retpolines that are used for
spectre workaround. This patch replaces an indirect call with a condition
(that can be predicted by the branch predictor).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2018-10-16 23:19:49.900000000 +0200
+++ linux-2.6/drivers/md/dm.c	2018-10-16 23:19:51.000000000 +0200
@@ -1687,8 +1687,7 @@ out:
 
 typedef blk_qc_t (process_bio_fn)(struct mapped_device *, struct dm_table *, struct bio *);
 
-static blk_qc_t __dm_make_request(struct request_queue *q, struct bio *bio,
-				  process_bio_fn process_bio)
+static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
 	blk_qc_t ret = BLK_QC_T_NONE;
@@ -1708,26 +1707,15 @@ static blk_qc_t __dm_make_request(struct
 		return ret;
 	}
 
-	ret = process_bio(md, map, bio);
+	if (dm_get_md_type(md) == DM_TYPE_NVME_BIO_BASED)
+		ret = __process_bio(md, map, bio);
+	else
+		ret = __split_and_process_bio(md, map, bio);
 
 	dm_put_live_table(md, srcu_idx);
 	return ret;
 }
 
-/*
- * The request function that remaps the bio to one target and
- * splits off any remainder.
- */
-static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
-{
-	return __dm_make_request(q, bio, __split_and_process_bio);
-}
-
-static blk_qc_t dm_make_request_nvme(struct request_queue *q, struct bio *bio)
-{
-	return __dm_make_request(q, bio, __process_bio);
-}
-
 static int dm_any_congested(void *congested_data, int bdi_bits)
 {
 	int r = bdi_bits;
@@ -2235,12 +2223,9 @@ int dm_setup_md_queue(struct mapped_devi
 		break;
 	case DM_TYPE_BIO_BASED:
 	case DM_TYPE_DAX_BIO_BASED:
-		dm_init_normal_md_queue(md);
-		blk_queue_make_request(md->queue, dm_make_request);
-		break;
 	case DM_TYPE_NVME_BIO_BASED:
 		dm_init_normal_md_queue(md);
-		blk_queue_make_request(md->queue, dm_make_request_nvme);
+		blk_queue_make_request(md->queue, dm_make_request);
 		break;
 	case DM_TYPE_NONE:
 		WARN_ON_ONCE(true);
