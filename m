From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/10] blk-map: call blk_queue_bounce from blk_rq_append_bio
Date: Mon, 19 Jun 2017 09:26:20 +0200
Message-ID: <20170619072628.12894-3-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This makes moves the knowledge about bouncing out of the callers into the
block core (just like we do for the normal I/O path), and allows to unexport
blk_queue_bounce.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c                  | 7 +++----
 block/bounce.c                   | 2 --
 drivers/scsi/osd/osd_initiator.c | 5 +----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 3b5cb863318f..2547016aa7aa 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -16,6 +16,8 @@
  */
 int blk_rq_append_bio(struct request *rq, struct bio *bio)
 {
+	blk_queue_bounce(rq->q, &bio);
+
 	if (!rq->bio) {
 		blk_rq_bio_prep(rq->q, rq, bio);
 	} else {
@@ -72,15 +74,13 @@ static int __blk_rq_map_user_iov(struct request *rq,
 		map_data->offset += bio->bi_iter.bi_size;
 
 	orig_bio = bio;
-	blk_queue_bounce(q, &bio);
 
 	/*
 	 * We link the bounce buffer in and could have to traverse it
 	 * later so we have to get a ref to prevent it from being freed
 	 */
-	bio_get(bio);
-
 	ret = blk_rq_append_bio(rq, bio);
+	bio_get(bio);
 	if (ret) {
 		bio_endio(bio);
 		__blk_rq_unmap_user(orig_bio);
@@ -249,7 +249,6 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		return ret;
 	}
 
-	blk_queue_bounce(q, &rq->bio);
 	return 0;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
diff --git a/block/bounce.c b/block/bounce.c
index 17d77613c471..b7e44bd59d7c 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -284,5 +284,3 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	 */
 	__blk_queue_bounce(q, bio_orig, pool);
 }
-
-EXPORT_SYMBOL(blk_queue_bounce);
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 1e69a43b279d..3754888dc7dd 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1577,10 +1577,7 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
 	scsi_req_init(req);
 
 	for_each_bio(bio) {
-		struct bio *bounce_bio = bio;
-
-		blk_queue_bounce(req->q, &bounce_bio);
-		ret = blk_rq_append_bio(req, bounce_bio);
+		ret = blk_rq_append_bio(req, bio);
 		if (ret)
 			return ERR_PTR(ret);
 	}
-- 
2.11.0
