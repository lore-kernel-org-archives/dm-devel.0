From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 6] New function blk_req_append_bio
Date: Thu, 16 Aug 2007 21:21:15 +1000
Message-ID: <1070816112115.12215__27416.2831054584$1187272693$gmane$org@suse.de>
References: <20070816211551.11839.patches@notabene>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-Id: <E1ILfrK-0006Yk-Qq@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


ll_back_merge_fn is currently exported to SCSI where is it used,
together with blk_rq_bio_prep, in exactly the same way these
functions are used in __blk_rq_map_user.

So move the common code into a new function (blk_rq_append_bio), and
don't export ll_back_merge_fn any longer.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c       |   38 ++++++++++++++++++++++----------------
 ./drivers/scsi/scsi_lib.c |   11 +----------
 ./include/linux/blkdev.h  |    4 ++--
 3 files changed, 25 insertions(+), 28 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 21:10:01.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 21:10:16.000000000 +1000
@@ -1430,7 +1430,8 @@ static inline int ll_new_hw_segment(stru
 	return 1;
 }
 
-int ll_back_merge_fn(struct request_queue *q, struct request *req, struct bio *bio)
+static int ll_back_merge_fn(struct request_queue *q, struct request *req,
+			    struct bio *bio)
 {
 	unsigned short max_sectors;
 	int len;
@@ -1466,7 +1467,6 @@ int ll_back_merge_fn(struct request_queu
 
 	return ll_new_hw_segment(q, req, bio);
 }
-EXPORT_SYMBOL(ll_back_merge_fn);
 
 static int ll_front_merge_fn(struct request_queue *q, struct request *req, 
 			     struct bio *bio)
@@ -2358,6 +2358,23 @@ static int __blk_rq_unmap_user(struct bi
 	return ret;
 }
 
+int blk_rq_append_bio(struct request_queue *q, struct request *rq,
+		      struct bio *bio)
+{
+	if (!rq->bio)
+		blk_rq_bio_prep(q, rq, bio);
+	else if (!ll_back_merge_fn(q, rq, bio))
+		return -EINVAL;
+	else {
+		rq->biotail->bi_next = bio;
+		rq->biotail = bio;
+
+		rq->data_len += bio->bi_size;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(blk_rq_append_bio);
+
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 			     void __user *ubuf, unsigned int len)
 {
@@ -2389,21 +2406,10 @@ static int __blk_rq_map_user(struct requ
 	 */
 	bio_get(bio);
 
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio)) {
-		ret = -EINVAL;
-		goto unmap_bio;
-	} else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
-
-		rq->data_len += bio->bi_size;
-	}
-
-	return bio->bi_size;
+	ret = blk_rq_append_bio(q, rq, bio);
+	if (!ret)
+		return bio->bi_size;
 
-unmap_bio:
 	/* if it was boucned we must call the end io function */
 	bio_endio(bio, bio->bi_size, 0);
 	__blk_rq_unmap_user(orig_bio);

diff .prev/drivers/scsi/scsi_lib.c ./drivers/scsi/scsi_lib.c
--- .prev/drivers/scsi/scsi_lib.c	2007-08-16 21:10:00.000000000 +1000
+++ ./drivers/scsi/scsi_lib.c	2007-08-16 21:10:16.000000000 +1000
@@ -268,16 +268,7 @@ static int scsi_merge_bio(struct request
 		bio->bi_rw |= (1 << BIO_RW);
 	blk_queue_bounce(q, &bio);
 
-	if (!rq->bio)
-		blk_rq_bio_prep(q, rq, bio);
-	else if (!ll_back_merge_fn(q, rq, bio))
-		return -EINVAL;
-	else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
-	}
-
-	return 0;
+	return blk_rq_append_bio(q, rq, bio);
 }
 
 static int scsi_bi_endio(struct bio *bio, unsigned int bytes_done, int error)

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 21:10:00.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 21:10:16.000000000 +1000
@@ -675,8 +675,8 @@ extern int sg_scsi_ioctl(struct file *, 
 /*
  * Temporary export, until SCSI gets fixed up.
  */
-extern int ll_back_merge_fn(struct request_queue *, struct request *,
-		struct bio *);
+extern int blk_rq_append_bio(struct request_queue *q, struct request *rq,
+			     struct bio *bio);
 
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
