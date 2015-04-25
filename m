From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] block, dm: don't copy bios for request clones
Date: Sat, 25 Apr 2015 12:23:52 +0200
Message-ID: <1429957432-20672-1-git-send-email-hch@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Currently dm-multipath has to clone the bios for every request sent
to the lower devices, which wastes cpu cycles and ties down memory.

This patch instead adds a new REQ_CLONE flag that instructs req_bio_endio
to not complete bios attached to a request, which we set on clone
requests similar to bios in a flush sequence.  With this change I/O
errors on a path failure only get propagated to dm-multipath, which
can then either resubmit the I/O or complete the bios on the original
request.

I've done some basic testing of this on a Linux target with ALUA support,
and it survives path failures during I/O nicely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          |  94 +++----------------------
 drivers/md/dm-table.c     |  28 +++++---
 drivers/md/dm.c           | 173 +++++++++++-----------------------------------
 drivers/md/dm.h           |   6 +-
 include/linux/blk_types.h |   2 +
 include/linux/blkdev.h    |   6 +-
 6 files changed, 78 insertions(+), 231 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fd154b9..4ef93a8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(blk_rq_init);
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
-	if (error)
+	if (error && !(rq->cmd_flags & REQ_CLONE))
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
@@ -128,7 +128,8 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	bio_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
-	if (bio->bi_iter.bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
+	if (bio->bi_iter.bi_size == 0 &&
+	    !(rq->cmd_flags & (REQ_FLUSH_SEQ|REQ_CLONE)))
 		bio_endio(bio, error);
 }
 
@@ -2901,95 +2902,22 @@ int blk_lld_busy(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_lld_busy);
 
-/**
- * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
- * @rq: the clone request to be cleaned up
- *
- * Description:
- *     Free all bios in @rq for a cloned request.
- */
-void blk_rq_unprep_clone(struct request *rq)
-{
-	struct bio *bio;
-
-	while ((bio = rq->bio) != NULL) {
-		rq->bio = bio->bi_next;
-
-		bio_put(bio);
-	}
-}
-EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
-
-/*
- * Copy attributes of the original request to the clone request.
- * The actual data parts (e.g. ->cmd, ->sense) are not copied.
- */
-static void __blk_rq_prep_clone(struct request *dst, struct request *src)
+void blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
-	dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
+	dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK);
+	dst->cmd_flags |= REQ_NOMERGE | REQ_CLONE;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
 	dst->nr_phys_segments = src->nr_phys_segments;
 	dst->ioprio = src->ioprio;
 	dst->extra_len = src->extra_len;
-}
-
-/**
- * blk_rq_prep_clone - Helper function to setup clone request
- * @rq: the request to be setup
- * @rq_src: original request to be cloned
- * @bs: bio_set that bios for clone are allocated from
- * @gfp_mask: memory allocation mask for bio
- * @bio_ctr: setup function to be called for each clone bio.
- *           Returns %0 for success, non %0 for failure.
- * @data: private data to be passed to @bio_ctr
- *
- * Description:
- *     Clones bios in @rq_src to @rq, and copies attributes of @rq_src to @rq.
- *     The actual data parts of @rq_src (e.g. ->cmd, ->sense)
- *     are not copied, and copying such parts is the caller's responsibility.
- *     Also, pages which the original bios are pointing to are not copied
- *     and the cloned bios just point same pages.
- *     So cloned bios must be completed before original bios, which means
- *     the caller must complete @rq before @rq_src.
- */
-int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
-		      struct bio_set *bs, gfp_t gfp_mask,
-		      int (*bio_ctr)(struct bio *, struct bio *, void *),
-		      void *data)
-{
-	struct bio *bio, *bio_src;
-
-	if (!bs)
-		bs = fs_bio_set;
-
-	__rq_for_each_bio(bio_src, rq_src) {
-		bio = bio_clone_fast(bio_src, gfp_mask, bs);
-		if (!bio)
-			goto free_and_out;
-
-		if (bio_ctr && bio_ctr(bio, bio_src, data))
-			goto free_and_out;
-
-		if (rq->bio) {
-			rq->biotail->bi_next = bio;
-			rq->biotail = bio;
-		} else
-			rq->bio = rq->biotail = bio;
-	}
-
-	__blk_rq_prep_clone(rq, rq_src);
-
-	return 0;
-
-free_and_out:
-	if (bio)
-		bio_put(bio);
-	blk_rq_unprep_clone(rq);
-
-	return -ENOMEM;
+	dst->bio = src->bio;
+	dst->biotail = src->biotail;
+	dst->cmd = src->cmd;
+	dst->cmd_len = src->cmd_len;
+	dst->sense = src->sense;
 }
 EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d9b00b8..1f859cd 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -938,23 +938,31 @@ bool dm_table_mq_request_based(struct dm_table *t)
 
 static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
-	unsigned type = dm_table_get_type(t);
+	int type = dm_table_get_type(t);
 	unsigned per_bio_data_size = 0;
-	struct dm_target *tgt;
 	unsigned i;
 
-	if (unlikely(type == DM_TYPE_NONE)) {
+	switch (type) {
+	case DM_TYPE_BIO_BASED:
+		for (i = 0; i < t->num_targets; i++) {
+			struct dm_target *tgt = t->targets + i;
+
+			per_bio_data_size = max(per_bio_data_size,
+						tgt->per_bio_data_size);
+		}
+
+		t->mempools = dm_alloc_bio_mempools(t->integrity_supported,
+				per_bio_data_size);
+		break;
+	case DM_TYPE_REQUEST_BASED:
+	case DM_TYPE_MQ_REQUEST_BASED:
+		t->mempools = dm_alloc_rq_mempools(md, type);
+		break;
+	default:
 		DMWARN("no table type is set, can't allocate mempools");
 		return -EINVAL;
 	}
 
-	if (type == DM_TYPE_BIO_BASED)
-		for (i = 0; i < t->num_targets; i++) {
-			tgt = t->targets + i;
-			per_bio_data_size = max(per_bio_data_size, tgt->per_bio_data_size);
-		}
-
-	t->mempools = dm_alloc_md_mempools(md, type, t->integrity_supported, per_bio_data_size);
 	if (!t->mempools)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f8c7ca3..6ea18dc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -990,57 +990,6 @@ static void clone_endio(struct bio *bio, int error)
 	dec_pending(io, error);
 }
 
-/*
- * Partial completion handling for request-based dm
- */
-static void end_clone_bio(struct bio *clone, int error)
-{
-	struct dm_rq_clone_bio_info *info =
-		container_of(clone, struct dm_rq_clone_bio_info, clone);
-	struct dm_rq_target_io *tio = info->tio;
-	struct bio *bio = info->orig;
-	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
-
-	bio_put(clone);
-
-	if (tio->error)
-		/*
-		 * An error has already been detected on the request.
-		 * Once error occurred, just let clone->end_io() handle
-		 * the remainder.
-		 */
-		return;
-	else if (error) {
-		/*
-		 * Don't notice the error to the upper layer yet.
-		 * The error handling decision is made by the target driver,
-		 * when the request is completed.
-		 */
-		tio->error = error;
-		return;
-	}
-
-	/*
-	 * I/O for the bio successfully completed.
-	 * Notice the data completion to the upper layer.
-	 */
-
-	/*
-	 * bios are processed from the head of the list.
-	 * So the completing bio should always be rq->bio.
-	 * If it's not, something wrong is happening.
-	 */
-	if (tio->orig->bio != bio)
-		DMERR("bio completion is going in the middle of the request");
-
-	/*
-	 * Update the original request.
-	 * Do not use blk_end_request() here, because it may complete
-	 * the original request before the clone, and break the ordering.
-	 */
-	blk_update_request(tio->orig, 0, nr_bytes);
-}
-
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
 {
 	return (rq->q->mq_ops ? blk_mq_rq_to_pdu(rq) : rq->special);
@@ -1087,8 +1036,6 @@ static void free_rq_clone(struct request *clone)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 	struct mapped_device *md = tio->md;
 
-	blk_rq_unprep_clone(clone);
-
 	if (clone->q->mq_ops)
 		tio->ti->type->release_clone_rq(clone);
 	else if (!md->queue->mq_ops)
@@ -1813,39 +1760,13 @@ static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 		dm_complete_request(rq, r);
 }
 
-static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
-				 void *data)
-{
-	struct dm_rq_target_io *tio = data;
-	struct dm_rq_clone_bio_info *info =
-		container_of(bio, struct dm_rq_clone_bio_info, clone);
-
-	info->orig = bio_orig;
-	info->tio = tio;
-	bio->bi_end_io = end_clone_bio;
-
-	return 0;
-}
-
-static int setup_clone(struct request *clone, struct request *rq,
-		       struct dm_rq_target_io *tio, gfp_t gfp_mask)
+static void setup_clone(struct request *clone, struct request *rq,
+		        struct dm_rq_target_io *tio)
 {
-	int r;
-
-	r = blk_rq_prep_clone(clone, rq, tio->md->bs, gfp_mask,
-			      dm_rq_bio_constructor, tio);
-	if (r)
-		return r;
-
-	clone->cmd = rq->cmd;
-	clone->cmd_len = rq->cmd_len;
-	clone->sense = rq->sense;
+	blk_rq_prep_clone(clone, rq);
 	clone->end_io = end_clone_request;
 	clone->end_io_data = tio;
-
 	tio->clone = clone;
-
-	return 0;
 }
 
 static struct request *clone_rq(struct request *rq, struct mapped_device *md,
@@ -1866,13 +1787,7 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 		clone = tio->clone;
 
 	blk_rq_init(NULL, clone);
-	if (setup_clone(clone, rq, tio, gfp_mask)) {
-		/* -ENOMEM */
-		if (alloc_clone)
-			free_clone_request(md, clone);
-		return NULL;
-	}
-
+	setup_clone(clone, rq, tio);
 	return clone;
 }
 
@@ -1965,11 +1880,7 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
 		}
 		if (IS_ERR(clone))
 			return DM_MAPIO_REQUEUE;
-		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
-			/* -ENOMEM */
-			ti->type->release_clone_rq(clone);
-			return DM_MAPIO_REQUEUE;
-		}
+		setup_clone(clone, rq, tio);
 	}
 
 	switch (r) {
@@ -2423,8 +2334,6 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 		goto out;
 	}
 
-	BUG_ON(!p || md->io_pool || md->rq_pool || md->bs);
-
 	md->io_pool = p->io_pool;
 	p->io_pool = NULL;
 	md->rq_pool = p->rq_pool;
@@ -3531,48 +3440,24 @@ int dm_noflush_suspending(struct dm_target *ti)
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
-					    unsigned integrity, unsigned per_bio_data_size)
+struct dm_md_mempools *dm_alloc_bio_mempools(unsigned integrity,
+		unsigned per_bio_data_size)
 {
-	struct dm_md_mempools *pools = kzalloc(sizeof(*pools), GFP_KERNEL);
-	struct kmem_cache *cachep = NULL;
-	unsigned int pool_size = 0;
+	struct dm_md_mempools *pools;
+	unsigned int pool_size = dm_get_reserved_bio_based_ios();
 	unsigned int front_pad;
 
+	pools = kzalloc(sizeof(*pools), GFP_KERNEL);
 	if (!pools)
 		return NULL;
 
-	type = filter_md_type(type, md);
+	front_pad = roundup(per_bio_data_size,
+			    __alignof__(struct dm_target_io)) +
+				offsetof(struct dm_target_io, clone);
 
-	switch (type) {
-	case DM_TYPE_BIO_BASED:
-		cachep = _io_cache;
-		pool_size = dm_get_reserved_bio_based_ios();
-		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
-		break;
-	case DM_TYPE_REQUEST_BASED:
-		cachep = _rq_tio_cache;
-		pool_size = dm_get_reserved_rq_based_ios();
-		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
-		if (!pools->rq_pool)
-			goto out;
-		/* fall through to setup remaining rq-based pools */
-	case DM_TYPE_MQ_REQUEST_BASED:
-		if (!pool_size)
-			pool_size = dm_get_reserved_rq_based_ios();
-		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
-		/* per_bio_data_size is not used. See __bind_mempools(). */
-		WARN_ON(per_bio_data_size != 0);
-		break;
-	default:
-		BUG();
-	}
-
-	if (cachep) {
-		pools->io_pool = mempool_create_slab_pool(pool_size, cachep);
-		if (!pools->io_pool)
-			goto out;
-	}
+	pools->io_pool = mempool_create_slab_pool(pool_size, _io_cache);
+	if (!pools->io_pool)
+		goto out;
 
 	pools->bs = bioset_create_nobvec(pool_size, front_pad);
 	if (!pools->bs)
@@ -3585,7 +3470,33 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 
 out:
 	dm_free_md_mempools(pools);
+	return NULL;
+}
+
+struct dm_md_mempools *dm_alloc_rq_mempools(struct mapped_device *md,
+		unsigned type)
+{
+	unsigned int pool_size = dm_get_reserved_rq_based_ios();
+	struct dm_md_mempools *pools;
 
+	pools = kzalloc(sizeof(*pools), GFP_KERNEL);
+	if (!pools)
+		return NULL;
+
+	if (filter_md_type(type, md) == DM_TYPE_REQUEST_BASED) {
+		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
+		if (!pools->rq_pool)
+			goto out;
+	}
+
+	pools->io_pool = mempool_create_slab_pool(pool_size, _rq_tio_cache);
+	if (!pools->io_pool)
+		goto out;
+
+	return pools;
+
+out:
+	dm_free_md_mempools(pools);
 	return NULL;
 }
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 6123c2b..0222d56 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -222,8 +222,10 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
-					    unsigned integrity, unsigned per_bio_data_size);
+struct dm_md_mempools *dm_alloc_bio_mempools(unsigned integrity,
+		unsigned per_bio_data_size);
+struct dm_md_mempools *dm_alloc_rq_mempools(struct mapped_device *md,
+		unsigned type);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 /*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a1b25e3..3b0f8f4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -193,6 +193,7 @@ enum rq_flag_bits {
 	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_MQ_INFLIGHT,	/* track inflight for MQ */
 	__REQ_NO_TIMEOUT,	/* requests may never expire */
+	__REQ_CLONE,		/* cloned bios */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -247,5 +248,6 @@ enum rq_flag_bits {
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
 #define REQ_NO_TIMEOUT		(1ULL << __REQ_NO_TIMEOUT)
+#define REQ_CLONE		(1ULL << __REQ_CLONE)
 
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516..9cb8174 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -804,11 +804,7 @@ extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
-extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
-			     struct bio_set *bs, gfp_t gfp_mask,
-			     int (*bio_ctr)(struct bio *, struct bio *, void *),
-			     void *data);
-extern void blk_rq_unprep_clone(struct request *rq);
+extern void blk_rq_prep_clone(struct request *rq, struct request *rq_src);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
-- 
1.9.1
