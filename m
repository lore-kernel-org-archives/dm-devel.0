From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] fold direct_make_requst into generic_make_request
Date: Mon, 26 Feb 2018 17:56:22 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1802261524090.5096@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <msnitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, =?ISO-8859-15?Q?Javier_Gonz=C3=A1lez?= <javier@cnexlabs.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, dm-devel@redhat.com
List-Id: dm-devel.ids

The block layer provides a function direct_make_request - but it doesn't
provide any test whether this function may be used or not.

Device mapper currently uses a dirty trick - it compares the result of
bdevname against the string "nvme" to test if direct_make_request can be
used.

The information whether the driver will or won't recurse can be easily
obtained in generic_make_request (by comparing make_request_fn - or
alternatively, we could introduce a queue flag for this), so my suggestion
is to just delete direct_make_request and fold this "norecurse"
optimization directly into generic_make_request This will allow us to
simplify device mapper paths and get rid of device name matching.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c              |   60 ++++++++++++++----------------------------
 block/blk-mq.c                |    2 -
 drivers/md/dm.c               |    5 ---
 drivers/nvme/host/multipath.c |    2 -
 include/linux/blkdev.h        |    1 
 5 files changed, 24 insertions(+), 46 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2018-02-26 20:37:19.088499000 +0100
+++ linux-2.6/block/blk-core.c	2018-02-26 20:43:57.839999000 +0100
@@ -2265,6 +2265,8 @@ end_io:
 	return false;
 }
 
+blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio);
+
 /**
  * generic_make_request - hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -2300,10 +2302,14 @@ blk_qc_t generic_make_request(struct bio
 	 */
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
+	bool may_recurse;
 
 	if (!generic_make_request_checks(bio))
 		goto out;
 
+	may_recurse = bio->bi_disk->queue->make_request_fn != blk_queue_bio &&
+		      bio->bi_disk->queue->make_request_fn != blk_mq_make_request;
+
 	/*
 	 * We only want one ->make_request_fn to be active at a time, else
 	 * stack usage with stacked devices could be a problem.  So use
@@ -2314,7 +2320,7 @@ blk_qc_t generic_make_request(struct bio
 	 * it is non-NULL, then a make_request is active, and new requests
 	 * should be added at the tail
 	 */
-	if (current->bio_list) {
+	if (may_recurse && current->bio_list) {
 		bio_list_add(&current->bio_list[0], bio);
 		goto out;
 	}
@@ -2334,8 +2340,10 @@ blk_qc_t generic_make_request(struct bio
 	 * bio_list, and call into ->make_request() again.
 	 */
 	BUG_ON(bio->bi_next);
-	bio_list_init(&bio_list_on_stack[0]);
-	current->bio_list = bio_list_on_stack;
+	if (may_recurse) {
+		bio_list_init(&bio_list_on_stack[0]);
+		current->bio_list = bio_list_on_stack;
+	}
 	do {
 		struct request_queue *q = bio->bi_disk->queue;
 		blk_mq_req_flags_t flags = bio->bi_opf & REQ_NOWAIT ?
@@ -2345,12 +2353,17 @@ blk_qc_t generic_make_request(struct bio
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
-			bio_list_on_stack[1] = bio_list_on_stack[0];
-			bio_list_init(&bio_list_on_stack[0]);
+			if (may_recurse) {
+				bio_list_on_stack[1] = bio_list_on_stack[0];
+				bio_list_init(&bio_list_on_stack[0]);
+			}
 			ret = q->make_request_fn(q, bio);
 
 			blk_queue_exit(q);
 
+			if (!may_recurse)
+				goto out;
+
 			/* sort new bios into those for a lower level
 			 * and those for the same level
 			 */
@@ -2371,6 +2384,9 @@ blk_qc_t generic_make_request(struct bio
 				bio_wouldblock_error(bio);
 			else
 				bio_io_error(bio);
+
+			if (!may_recurse)
+				goto out;
 		}
 		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
@@ -2382,40 +2398,6 @@ out:
 EXPORT_SYMBOL(generic_make_request);
 
 /**
- * direct_make_request - hand a buffer directly to its device driver for I/O
- * @bio:  The bio describing the location in memory and on the device.
- *
- * This function behaves like generic_make_request(), but does not protect
- * against recursion.  Must only be used if the called driver is known
- * to not call generic_make_request (or direct_make_request) again from
- * its make_request function.  (Calling direct_make_request again from
- * a workqueue is perfectly fine as that doesn't recurse).
- */
-blk_qc_t direct_make_request(struct bio *bio)
-{
-	struct request_queue *q = bio->bi_disk->queue;
-	bool nowait = bio->bi_opf & REQ_NOWAIT;
-	blk_qc_t ret;
-
-	if (!generic_make_request_checks(bio))
-		return BLK_QC_T_NONE;
-
-	if (unlikely(blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0))) {
-		if (nowait && !blk_queue_dying(q))
-			bio->bi_status = BLK_STS_AGAIN;
-		else
-			bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
-		return BLK_QC_T_NONE;
-	}
-
-	ret = q->make_request_fn(q, bio);
-	blk_queue_exit(q);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(direct_make_request);
-
-/**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
  *
Index: linux-2.6/block/blk-mq.c
===================================================================
--- linux-2.6.orig/block/blk-mq.c	2018-02-26 20:37:19.088499000 +0100
+++ linux-2.6/block/blk-mq.c	2018-02-26 20:37:19.078499000 +0100
@@ -1861,7 +1861,7 @@ blk_status_t blk_mq_request_issue_direct
 	return ret;
 }
 
-static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
+blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2018-02-26 20:37:19.088499000 +0100
+++ linux-2.6/drivers/md/dm.c	2018-02-26 20:37:19.088499000 +0100
@@ -1237,10 +1237,7 @@ static blk_qc_t __map_bio(struct dm_targ
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone->bi_disk->queue, clone,
 				      bio_dev(io->orig_bio), sector);
-		if (md->type == DM_TYPE_NVME_BIO_BASED)
-			ret = direct_make_request(clone);
-		else
-			ret = generic_make_request(clone);
+		ret = generic_make_request(clone);
 		break;
 	case DM_MAPIO_KILL:
 		free_tio(tio);
Index: linux-2.6/drivers/nvme/host/multipath.c
===================================================================
--- linux-2.6.orig/drivers/nvme/host/multipath.c	2018-02-26 20:37:19.088499000 +0100
+++ linux-2.6/drivers/nvme/host/multipath.c	2018-02-26 20:37:19.088499000 +0100
@@ -89,7 +89,7 @@ static blk_qc_t nvme_ns_head_make_reques
 	if (likely(ns)) {
 		bio->bi_disk = ns->disk;
 		bio->bi_opf |= REQ_NVME_MPATH;
-		ret = direct_make_request(bio);
+		ret = generic_make_request(bio);
 	} else if (!list_empty_careful(&head->list)) {
 		dev_warn_ratelimited(dev, "no path available - requeuing I/O\n");
 
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2018-02-26 20:37:19.088499000 +0100
+++ linux-2.6/include/linux/blkdev.h	2018-02-26 20:37:19.088499000 +0100
@@ -1014,7 +1014,6 @@ static inline void rq_flush_dcache_pages
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern blk_qc_t generic_make_request(struct bio *bio);
-extern blk_qc_t direct_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_init_request_from_bio(struct request *req, struct bio *bio);
 extern void blk_put_request(struct request *);
