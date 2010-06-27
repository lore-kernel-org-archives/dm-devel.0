From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2 v2] block: defer the use of inline biovecs for discard
 requests
Date: Sun, 27 Jun 2010 10:55:15 -0400
Message-ID: <20100627145515.GE3970@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1277582211-10725-2-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, akpm@linux-foundation.org
List-Id: dm-devel.ids

Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
means bio_has_data() will not be true until the SCSI layer adds the
payload to the discard request via blk_add_request_payload.

This patch avoids the need for the following VM accounting fix for
discards: http://lkml.org/lkml/2010/6/23/361
NOTE: Jens, you said you applied Tao Ma's fix but I cannot see it in
your linux-2.6-block's for-next or for-2.6.36... as such I didn't revert
it in this patch.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c    |    2 ++
 block/blk-lib.c     |    2 +-
 fs/bio.c            |   25 +++++++++++++++++++++++--
 include/linux/bio.h |    3 +++
 4 files changed, 29 insertions(+), 3 deletions(-)

Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -1153,6 +1153,7 @@ void blk_add_request_payload(struct requ
 {
 	struct bio *bio = rq->bio;
 
+	bio_enable_inline_vecs(bio);
 	bio->bi_io_vec->bv_page = page;
 	bio->bi_io_vec->bv_offset = 0;
 	bio->bi_io_vec->bv_len = len;
@@ -1187,6 +1188,7 @@ void blk_clear_request_payload(struct re
 
 	bio->bi_io_vec->bv_page = NULL;
 	bio->bi_io_vec->bv_len = 0;
+	bio_disable_inline_vecs(bio);
 }
 EXPORT_SYMBOL_GPL(blk_clear_request_payload);
 
Index: linux-2.6-block/block/blk-lib.c
===================================================================
--- linux-2.6-block.orig/block/blk-lib.c
+++ linux-2.6-block/block/blk-lib.c
@@ -54,7 +54,7 @@ int blkdev_issue_discard(struct block_de
 		unsigned int max_discard_sectors =
 			min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
-		bio = bio_alloc(gfp_mask, 1);
+		bio = bio_alloc(gfp_mask, 0);
 		if (!bio) {
 			ret = -ENOMEM;
 			break;
Index: linux-2.6-block/fs/bio.c
===================================================================
--- linux-2.6-block.orig/fs/bio.c
+++ linux-2.6-block/fs/bio.c
@@ -261,6 +261,27 @@ void bio_init(struct bio *bio)
 EXPORT_SYMBOL(bio_init);
 
 /**
+ * bio_enable_inline_vecs - enable use of bio's inline iovecs
+ * @bio:   bio that will use its inline iovecs
+ */
+void bio_enable_inline_vecs(struct bio *bio)
+{
+	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
+	bio->bi_max_vecs = BIO_INLINE_VECS;
+	bio->bi_io_vec = bio->bi_inline_vecs;;
+}
+
+/**
+ * bio_disable_inline_vecs - disable use of bio's inline iovecs
+ * @bio:   bio that will no longer use its inline iovecs
+ */
+void bio_disable_inline_vecs(struct bio *bio)
+{
+	bio->bi_max_vecs = 0;
+	bio->bi_io_vec = NULL;
+}
+
+/**
  * bio_alloc_bioset - allocate a bio for I/O
  * @gfp_mask:   the GFP_ mask given to the slab allocator
  * @nr_iovecs:	number of iovecs to pre-allocate
@@ -293,8 +314,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_m
 		goto out_set;
 
 	if (nr_iovecs <= BIO_INLINE_VECS) {
-		bvl = bio->bi_inline_vecs;
-		nr_iovecs = BIO_INLINE_VECS;
+		bio_enable_inline_vecs(bio);
+		return bio;
 	} else {
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
Index: linux-2.6-block/include/linux/bio.h
===================================================================
--- linux-2.6-block.orig/include/linux/bio.h
+++ linux-2.6-block/include/linux/bio.h
@@ -403,6 +403,9 @@ extern struct bio *bio_clone(struct bio 
 
 extern void bio_init(struct bio *);
 
+extern void bio_enable_inline_vecs(struct bio *);
+extern void bio_disable_inline_vecs(struct bio *);
+
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
