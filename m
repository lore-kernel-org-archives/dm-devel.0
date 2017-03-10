From: NeilBrown <neilb@suse.com>
Subject: [PATCH 2/5] blk: remove bio_set arg from blk_queue_split()
Date: Fri, 10 Mar 2017 17:00:47 +1100
Message-ID: <148912564707.4002.12906052637563319103.stgit@noble>
References: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148912539296.4002.219258660543808741.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

blk_queue_split() is always called with the last arg being q->bio_split,
where 'q' is the first arg.

Also blk_queue_split() sometimes uses the passed-in 'bs' and sometimes uses
q->bio_split.

This is inconsistent and unnecessary.  Remove the last arg and always use
q->bio_split inside blk_queue_split()

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/blk-core.c              |    2 +-
 block/blk-merge.c             |    7 +++----
 block/blk-mq.c                |    4 ++--
 drivers/block/drbd/drbd_req.c |    2 +-
 drivers/block/pktcdvd.c       |    2 +-
 drivers/block/ps3vram.c       |    2 +-
 drivers/block/rsxx/dev.c      |    2 +-
 drivers/block/umem.c          |    2 +-
 drivers/block/zram/zram_drv.c |    2 +-
 drivers/lightnvm/rrpc.c       |    2 +-
 drivers/md/md.c               |    2 +-
 drivers/s390/block/dcssblk.c  |    2 +-
 drivers/s390/block/xpram.c    |    2 +-
 include/linux/blkdev.h        |    3 +--
 14 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d772c221cc17..fae7966e1f98 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1635,7 +1635,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 */
 	blk_queue_bounce(q, &bio);
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
 		bio->bi_error = -EIO;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2afa262425d1..ce8838aff7f7 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -188,8 +188,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	return do_split ? new : NULL;
 }
 
-void blk_queue_split(struct request_queue *q, struct bio **bio,
-		     struct bio_set *bs)
+void blk_queue_split(struct request_queue *q, struct bio **bio)
 {
 	struct bio *split, *res;
 	unsigned nsegs;
@@ -197,14 +196,14 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 	switch (bio_op(*bio)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
-		split = blk_bio_discard_split(q, *bio, bs, &nsegs);
+		split = blk_bio_discard_split(q, *bio, q->bio_split, &nsegs);
 		break;
 	case REQ_OP_WRITE_ZEROES:
 		split = NULL;
 		nsegs = (*bio)->bi_phys_segments;
 		break;
 	case REQ_OP_WRITE_SAME:
-		split = blk_bio_write_same_split(q, *bio, bs, &nsegs);
+		split = blk_bio_write_same_split(q, *bio, q->bio_split, &nsegs);
 		break;
 	default:
 		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 159187a28d66..e582d7f7511e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1502,7 +1502,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	if (!is_flush_fua && !blk_queue_nomerges(q) &&
 	    blk_attempt_plug_merge(q, bio, &request_count, &same_queue_rq))
@@ -1624,7 +1624,7 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	if (!is_flush_fua && !blk_queue_nomerges(q)) {
 		if (blk_attempt_plug_merge(q, bio, &request_count, NULL))
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 652114ae1a8a..f6ed6f7f5ab2 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1554,7 +1554,7 @@ blk_qc_t drbd_make_request(struct request_queue *q, struct bio *bio)
 	struct drbd_device *device = (struct drbd_device *) q->queuedata;
 	unsigned long start_jif;
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	start_jif = jiffies;
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 66d846ba85a9..98394d034c29 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2414,7 +2414,7 @@ static blk_qc_t pkt_make_request(struct request_queue *q, struct bio *bio)
 
 	blk_queue_bounce(q, &bio);
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	pd = q->queuedata;
 	if (!pd) {
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 456b4fe21559..48072c0c1010 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -606,7 +606,7 @@ static blk_qc_t ps3vram_make_request(struct request_queue *q, struct bio *bio)
 
 	dev_dbg(&dev->core, "%s\n", __func__);
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	spin_lock_irq(&priv->lock);
 	busy = !bio_list_empty(&priv->list);
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index f81d70b39d10..8c8024f616ae 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -151,7 +151,7 @@ static blk_qc_t rsxx_make_request(struct request_queue *q, struct bio *bio)
 	struct rsxx_bio_meta *bio_meta;
 	int st = -EINVAL;
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	might_sleep();
 
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index c141cc3be22b..c8d8a2f16f8e 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -529,7 +529,7 @@ static blk_qc_t mm_make_request(struct request_queue *q, struct bio *bio)
 		 (unsigned long long)bio->bi_iter.bi_sector,
 		 bio->bi_iter.bi_size);
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	spin_lock_irq(&card->lock);
 	*card->biotail = bio;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dceb5edd1e54..49d8bf37c4ef 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -880,7 +880,7 @@ static blk_qc_t zram_make_request(struct request_queue *queue, struct bio *bio)
 {
 	struct zram *zram = queue->queuedata;
 
-	blk_queue_split(queue, &bio, queue->bio_split);
+	blk_queue_split(queue, &bio);
 
 	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
 					bio->bi_iter.bi_size)) {
diff --git a/drivers/lightnvm/rrpc.c b/drivers/lightnvm/rrpc.c
index e00b1d7b976f..701fa2fafbb2 100644
--- a/drivers/lightnvm/rrpc.c
+++ b/drivers/lightnvm/rrpc.c
@@ -999,7 +999,7 @@ static blk_qc_t rrpc_make_rq(struct request_queue *q, struct bio *bio)
 	struct nvm_rq *rqd;
 	int err;
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	if (bio_op(bio) == REQ_OP_DISCARD) {
 		rrpc_discard(rrpc, bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 548d1b8014f8..d7d2bb51a58d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -253,7 +253,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	unsigned int sectors;
 	int cpu;
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	if (mddev == NULL || mddev->pers == NULL) {
 		bio_io_error(bio);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 415d10a67b7a..10ece6f3c7eb 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -829,7 +829,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long source_addr;
 	unsigned long bytes_done;
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index b9d7e755c8a3..a48f0d40c1d2 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -190,7 +190,7 @@ static blk_qc_t xpram_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long page_addr;
 	unsigned long bytes;
 
-	blk_queue_split(q, &bio, q->bio_split);
+	blk_queue_split(q, &bio);
 
 	if ((bio->bi_iter.bi_sector & 7) != 0 ||
 	    (bio->bi_iter.bi_size & 4095) != 0)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a7da607ca04..8f98b4e2b9e6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -933,8 +933,7 @@ extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern int blk_rq_append_bio(struct request *rq, struct bio *bio);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
-extern void blk_queue_split(struct request_queue *, struct bio **,
-			    struct bio_set *);
+extern void blk_queue_split(struct request_queue *, struct bio **);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
