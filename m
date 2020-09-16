From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/3] block: make blk_crypto_rq_bio_prep() able to fail
Date: Tue, 15 Sep 2020 20:53:14 -0700
Message-ID: <20200916035315.34046-3-ebiggers@kernel.org>
References: <20200916035315.34046-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200916035315.34046-1-ebiggers@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, Satya Tangirala <satyat@google.com>, Miaohe Lin <linmiaohe@huawei.com>
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

blk_crypto_rq_bio_prep() assumes its gfp_mask argument always includes
__GFP_DIRECT_RECLAIM, so that the mempool_alloc() will always succeed.

However, blk_crypto_rq_bio_prep() might be called with GFP_ATOMIC via
setup_clone() in drivers/md/dm-rq.c.

This case isn't currently reachable with a bio that actually has an
encryption context.  However, it's fragile to rely on this.  Just make
blk_crypto_rq_bio_prep() able to fail.

Cc: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-core.c            |  8 +++++---
 block/blk-crypto-internal.h | 21 ++++++++++++++++-----
 block/blk-crypto.c          | 18 +++++++-----------
 block/blk-mq.c              |  7 ++++++-
 4 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ca3f0f00c9435..fbeaa49f6fe2c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1620,8 +1620,10 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		if (rq->bio) {
 			rq->biotail->bi_next = bio;
 			rq->biotail = bio;
-		} else
+		} else {
 			rq->bio = rq->biotail = bio;
+		}
+		bio = NULL;
 	}
 
 	/* Copy attributes of the original request to the clone request. */
@@ -1634,8 +1636,8 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
 	rq->ioprio = rq_src->ioprio;
 
-	if (rq->bio)
-		blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask);
+	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
+		goto free_and_out;
 
 	return 0;
 
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index d2b0f565d83cb..0d36aae538d7b 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -142,13 +142,24 @@ static inline void blk_crypto_free_request(struct request *rq)
 		__blk_crypto_free_request(rq);
 }
 
-void __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
-			      gfp_t gfp_mask);
-static inline void blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
-					  gfp_t gfp_mask)
+int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
+			     gfp_t gfp_mask);
+/**
+ * blk_crypto_rq_bio_prep - Prepare a request's crypt_ctx when its first bio
+ *			    is inserted
+ * @rq: The request to prepare
+ * @bio: The first bio being inserted into the request
+ * @gfp_mask: Memory allocation flags
+ *
+ * Return: 0 on success, -ENOMEM if out of memory.  -ENOMEM is only possible if
+ *	   @gfp_mask doesn't include %__GFP_DIRECT_RECLAIM.
+ */
+static inline int blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
+					 gfp_t gfp_mask)
 {
 	if (bio_has_crypt_ctx(bio))
-		__blk_crypto_rq_bio_prep(rq, bio, gfp_mask);
+		return __blk_crypto_rq_bio_prep(rq, bio, gfp_mask);
+	return 0;
 }
 
 /**
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index a3f27a19067c9..bbe7974fd74f0 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -283,20 +283,16 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 	return false;
 }
 
-/**
- * __blk_crypto_rq_bio_prep - Prepare a request's crypt_ctx when its first bio
- *			      is inserted
- *
- * @rq: The request to prepare
- * @bio: The first bio being inserted into the request
- * @gfp_mask: gfp mask
- */
-void __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
-			      gfp_t gfp_mask)
+int __blk_crypto_rq_bio_prep(struct request *rq, struct bio *bio,
+			     gfp_t gfp_mask)
 {
-	if (!rq->crypt_ctx)
+	if (!rq->crypt_ctx) {
 		rq->crypt_ctx = mempool_alloc(bio_crypt_ctx_pool, gfp_mask);
+		if (!rq->crypt_ctx)
+			return -ENOMEM;
+	}
 	*rq->crypt_ctx = *bio->bi_crypt_context;
+	return 0;
 }
 
 /**
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e04b759add758..9ec0e7149ae69 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1940,13 +1940,18 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 		unsigned int nr_segs)
 {
+	int err;
+
 	if (bio->bi_opf & REQ_RAHEAD)
 		rq->cmd_flags |= REQ_FAILFAST_MASK;
 
 	rq->__sector = bio->bi_iter.bi_sector;
 	rq->write_hint = bio->bi_write_hint;
 	blk_rq_bio_prep(rq, bio, nr_segs);
-	blk_crypto_rq_bio_prep(rq, bio, GFP_NOIO);
+
+	/* This can't fail, since GFP_NOIO includes __GFP_DIRECT_RECLAIM. */
+	err = blk_crypto_rq_bio_prep(rq, bio, GFP_NOIO);
+	WARN_ON_ONCE(err);
 
 	blk_account_io_start(rq);
 }
-- 
2.28.0
