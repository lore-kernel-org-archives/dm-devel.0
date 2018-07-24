From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] block: unexport bio_clone_bioset
Date: Tue, 24 Jul 2018 09:52:34 +0200
Message-ID: <20180724075234.26861-6-hch@lst.de>
References: <20180724075234.26861-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180724075234.26861-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Now only used by the bounce code, so move it there and mark the function
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 77 ---------------------------------------------
 block/bounce.c      | 69 +++++++++++++++++++++++++++++++++++++++-
 include/linux/bio.h |  1 -
 3 files changed, 68 insertions(+), 79 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8ecc95615941..d1313d73009d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -646,83 +646,6 @@ struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
 }
 EXPORT_SYMBOL(bio_clone_fast);
 
-/**
- * 	bio_clone_bioset - clone a bio
- * 	@bio_src: bio to clone
- *	@gfp_mask: allocation priority
- *	@bs: bio_set to allocate from
- *
- *	Clone bio. Caller will own the returned bio, but not the actual data it
- *	points to. Reference count of returned bio will be one.
- */
-struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
-			     struct bio_set *bs)
-{
-	struct bvec_iter iter;
-	struct bio_vec bv;
-	struct bio *bio;
-
-	/*
-	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
-	 * bio_src->bi_io_vec to bio->bi_io_vec.
-	 *
-	 * We can't do that anymore, because:
-	 *
-	 *  - The point of cloning the biovec is to produce a bio with a biovec
-	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
-	 *
-	 *  - The original bio could've had more than BIO_MAX_PAGES biovecs; if
-	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
-	 *    But the clone should succeed as long as the number of biovecs we
-	 *    actually need to allocate is fewer than BIO_MAX_PAGES.
-	 *
-	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
-	 *    that does not own the bio - reason being drivers don't use it for
-	 *    iterating over the biovec anymore, so expecting it to be kept up
-	 *    to date (i.e. for clones that share the parent biovec) is just
-	 *    asking for trouble and would force extra work on
-	 *    __bio_clone_fast() anyways.
-	 */
-
-	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
-	if (!bio)
-		return NULL;
-	bio->bi_disk		= bio_src->bi_disk;
-	bio->bi_opf		= bio_src->bi_opf;
-	bio->bi_write_hint	= bio_src->bi_write_hint;
-	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
-	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
-
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		break;
-	case REQ_OP_WRITE_SAME:
-		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
-		break;
-	default:
-		bio_for_each_segment(bv, bio_src, iter)
-			bio->bi_io_vec[bio->bi_vcnt++] = bv;
-		break;
-	}
-
-	if (bio_integrity(bio_src)) {
-		int ret;
-
-		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
-		if (ret < 0) {
-			bio_put(bio);
-			return NULL;
-		}
-	}
-
-	bio_clone_blkcg_association(bio, bio_src);
-
-	return bio;
-}
-EXPORT_SYMBOL(bio_clone_bioset);
-
 /**
  *	bio_add_pc_page	-	attempt to add page to bio
  *	@q: the target queue
diff --git a/block/bounce.c b/block/bounce.c
index fd31347b7836..bc63b3a2d18c 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -195,6 +195,73 @@ static void bounce_end_io_read_isa(struct bio *bio)
 	__bounce_end_io_read(bio, &isa_page_pool);
 }
 
+static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
+		struct bio_set *bs)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	struct bio *bio;
+
+	/*
+	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
+	 * bio_src->bi_io_vec to bio->bi_io_vec.
+	 *
+	 * We can't do that anymore, because:
+	 *
+	 *  - The point of cloning the biovec is to produce a bio with a biovec
+	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
+	 *
+	 *  - The original bio could've had more than BIO_MAX_PAGES biovecs; if
+	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
+	 *    But the clone should succeed as long as the number of biovecs we
+	 *    actually need to allocate is fewer than BIO_MAX_PAGES.
+	 *
+	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
+	 *    that does not own the bio - reason being drivers don't use it for
+	 *    iterating over the biovec anymore, so expecting it to be kept up
+	 *    to date (i.e. for clones that share the parent biovec) is just
+	 *    asking for trouble and would force extra work on
+	 *    __bio_clone_fast() anyways.
+	 */
+
+	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
+	if (!bio)
+		return NULL;
+	bio->bi_disk		= bio_src->bi_disk;
+	bio->bi_opf		= bio_src->bi_opf;
+	bio->bi_write_hint	= bio_src->bi_write_hint;
+	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
+	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_ZEROES:
+		break;
+	case REQ_OP_WRITE_SAME:
+		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
+		break;
+	default:
+		bio_for_each_segment(bv, bio_src, iter)
+			bio->bi_io_vec[bio->bi_vcnt++] = bv;
+		break;
+	}
+
+	if (bio_integrity(bio_src)) {
+		int ret;
+
+		ret = bio_integrity_clone(bio, bio_src, gfp_mask);
+		if (ret < 0) {
+			bio_put(bio);
+			return NULL;
+		}
+	}
+
+	bio_clone_blkcg_association(bio, bio_src);
+
+	return bio;
+}
+
 static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 			       mempool_t *pool)
 {
@@ -222,7 +289,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		generic_make_request(*bio_orig);
 		*bio_orig = bio;
 	}
-	bio = bio_clone_bioset(*bio_orig, GFP_NOIO, passthrough ? NULL :
+	bio = bounce_clone_bio(*bio_orig, GFP_NOIO, passthrough ? NULL :
 			&bounce_bio_set);
 
 	bio_for_each_segment_all(to, bio, i) {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b861baa59454..51371740d2a8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -429,7 +429,6 @@ extern void bio_put(struct bio *);
 
 extern void __bio_clone_fast(struct bio *, struct bio *);
 extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
-extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
 
 extern struct bio_set fs_bio_set;
 
-- 
2.18.0
