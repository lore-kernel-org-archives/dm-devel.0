From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 2/2] md: dm-crypt: Introduce the request handling for dm-crypt
Date: Wed, 11 Nov 2015 17:31:45 +0800
Message-ID: <671c84bd9267aba8c9aed4d60ef87054688aa23a.1447233227.git.baolin.wang@linaro.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1447233227.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1447233227.git.baolin.wang@linaro.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com
Cc: jack@suse.cz, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, broonie@kernel.org, arnd@arndb.de, dineshg@quicinc.com, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

Some hardware can support big block data encrytion, the original dm-crypt
only implemented the 'based-bio' things that will limit the efficiency
(only handle one bio at one time) for the big block data encryption.

This patch introduces the 'based-request' method to handle the big block,
which it can contain more than one bio at one time for dm-drypt. Now we use
a config macro to enable the 'based-request' method and to ensure the original
code can be run successfully.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/md/Kconfig    |    6 +
 drivers/md/dm-crypt.c |  831 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 835 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index d5415ee..aea1db0 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -266,6 +266,12 @@ config DM_CRYPT
 
 	  If unsure, say N.
 
+config DM_REQ_CRYPT
+	bool "Crypt target support with request"
+	depends on BLK_DEV_DM
+	select CRYPTO
+	select CRYPTO_CBC
+
 config DM_SNAPSHOT
        tristate "Snapshot target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d60c88d..e21a1ed15 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -28,10 +28,13 @@
 #include <crypto/hash.h>
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
+#include <linux/buffer_head.h>
 
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "crypt"
+#define DM_MAX_SG_LIST	(1024)
+#define BIO_INLINE_VECS	(4)
 
 /*
  * context holding the current state of a multi-part conversion
@@ -64,10 +67,27 @@ struct dm_crypt_io {
 	struct rb_node rb_node;
 } CRYPTO_MINALIGN_ATTR;
 
+struct dm_req_crypt_io {
+	struct crypt_config *cc;
+	struct work_struct work;
+	struct request *cloned_request;
+	struct convert_context ctx;
+
+	int error;
+	atomic_t pending;
+	sector_t sector;
+	struct rb_node rb_node;
+
+	bool should_encrypt;
+	bool should_decrypt;
+};
+
 struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
+	struct sg_table req_sgt_in;
+	struct sg_table req_sgt_out;
 	sector_t iv_sector;
 };
 
@@ -127,6 +147,10 @@ struct crypt_config {
 	 */
 	mempool_t *req_pool;
 	mempool_t *page_pool;
+
+	struct kmem_cache *req_crypt_io_pool;
+	mempool_t *req_io_pool;
+
 	struct bio_set *bs;
 	struct mutex bio_alloc_lock;
 
@@ -184,6 +208,7 @@ struct crypt_config {
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
+static int req_crypt_write_work(void *data);
 
 /*
  * Use this to access cipher attributes that are the same for each CPU.
@@ -1547,6 +1572,8 @@ static void crypt_dtr(struct dm_target *ti)
 		mempool_destroy(cc->page_pool);
 	if (cc->req_pool)
 		mempool_destroy(cc->req_pool);
+	if (cc->req_io_pool)
+		mempool_destroy(cc->req_io_pool);
 
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
@@ -1556,6 +1583,7 @@ static void crypt_dtr(struct dm_target *ti)
 
 	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
+	kmem_cache_destroy(cc->req_crypt_io_pool);
 
 	/* Must zero key material before freeing */
 	kzfree(cc);
@@ -1796,7 +1824,19 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	cc->bs = bioset_create(MIN_IOS, 0);
+	cc->req_crypt_io_pool = KMEM_CACHE(dm_req_crypt_io, 0);
+	if (!cc->req_crypt_io_pool) {
+		ti->error = "Cannot allocate req_crypt_io_pool";
+		goto bad;
+	}
+
+	cc->req_io_pool = mempool_create_slab_pool(MIN_IOS, cc->req_crypt_io_pool);
+	if (!cc->req_io_pool) {
+		ti->error = "Cannot allocate request io mempool";
+		goto bad;
+	}
+
+	cc->bs = bioset_create(BIO_MAX_PAGES, 0);
 	if (!cc->bs) {
 		ti->error = "Cannot allocate crypt bioset";
 		goto bad;
@@ -1880,7 +1920,12 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	init_waitqueue_head(&cc->write_thread_wait);
 	cc->write_tree = RB_ROOT;
 
+#ifndef CONFIG_DM_REQ_CRYPT
 	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
+#else
+	cc->write_thread = kthread_create(req_crypt_write_work,
+					  cc, "req_dmcrypt_write");
+#endif
 	if (IS_ERR(cc->write_thread)) {
 		ret = PTR_ERR(cc->write_thread);
 		cc->write_thread = NULL;
@@ -2045,14 +2090,796 @@ static int crypt_iterate_devices(struct dm_target *ti,
 	return fn(ti, cc->dev, cc->start, ti->len, data);
 }
 
+/*
+ * If bio->bi_dev is a partition, remap the location
+ */
+static inline void req_crypt_blk_partition_remap(struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+
+	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
+		struct hd_struct *p = bdev->bd_part;
+		/* Check for integer overflow, should never happen. */
+		if (p->start_sect > (UINT_MAX - bio->bi_iter.bi_sector))
+			return;
+
+		bio->bi_iter.bi_sector += p->start_sect;
+		bio->bi_bdev = bdev->bd_contains;
+	}
+}
+
+static void req_crypt_dispatch_io(struct dm_req_crypt_io *io)
+{
+	struct request *clone = io->cloned_request;
+	struct request *rq = dm_get_orig_rq(clone);
+
+	dm_dispatch_clone_request(clone, rq);
+}
+
+static void req_crypt_free_resource(struct dm_req_crypt_io *io)
+{
+	struct crypt_config *cc = io->cc;
+	struct ablkcipher_request *req = io->ctx.req;
+	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
+
+	if (dmreq->req_sgt_out.orig_nents > 0)
+		sg_free_table(&dmreq->req_sgt_out);
+
+	if (dmreq->req_sgt_in.orig_nents > 0)
+		sg_free_table(&dmreq->req_sgt_in);
+
+	mempool_free(req, cc->req_pool);
+	mempool_free(io, cc->req_io_pool);
+}
+
+static void req_crypt_inc_pending(struct dm_req_crypt_io *io)
+{
+	atomic_inc(&io->pending);
+}
+
+static void req_crypt_dec_pending_encrypt(struct dm_req_crypt_io *io)
+{
+	struct request *clone = io->cloned_request;
+	int error = io->error;
+
+	atomic_dec(&io->pending);
+
+	if (error < 0) {
+		dm_kill_unmapped_request(clone, error);
+		req_crypt_free_resource(io);
+	}
+}
+
+static void req_crypt_dec_pending_decrypt(struct dm_req_crypt_io *io)
+{
+	struct request *clone = io->cloned_request;
+	int error = io->error;
+
+	atomic_dec(&io->pending);
+
+	dm_end_request(clone, error);
+	req_crypt_free_resource(io);
+}
+
+/*
+ * This callback is called by the worker queue to perform non-decrypt writes
+ * and use the dm function to complete the bios and requests.
+ */
+static void req_crypt_write_plain(struct dm_req_crypt_io *io)
+{
+	io->error = 0;
+	req_crypt_dispatch_io(io);
+}
+
+/*
+ * This callback is called by the worker queue to perform non-decrypt reads
+ * and use the dm function to complete the bios and requests.
+ */
+static void req_crypt_read_plain(struct dm_req_crypt_io *io)
+{
+	struct crypt_config *cc = io->cc;
+	struct request *clone = io->cloned_request;
+
+	dm_end_request(clone, 0);
+	mempool_free(io, cc->req_io_pool);
+}
+
+#define req_crypt_io_from_node(node) rb_entry((node), struct dm_req_crypt_io, rb_node)
+static int req_crypt_write_work(void *data)
+{
+	struct crypt_config *cc = data;
+	struct dm_req_crypt_io *io;
+
+	while (1) {
+		struct rb_root write_tree;
+		struct blk_plug plug;
+		DECLARE_WAITQUEUE(wait, current);
+
+		spin_lock_irq(&cc->write_thread_wait.lock);
+
+continue_locked:
+		if (!RB_EMPTY_ROOT(&cc->write_tree))
+			goto pop_from_list;
+
+		__set_current_state(TASK_INTERRUPTIBLE);
+		__add_wait_queue(&cc->write_thread_wait, &wait);
+
+		spin_unlock_irq(&cc->write_thread_wait.lock);
+
+		if (unlikely(kthread_should_stop())) {
+			set_task_state(current, TASK_RUNNING);
+			remove_wait_queue(&cc->write_thread_wait, &wait);
+			break;
+		}
+
+		schedule();
+
+		set_task_state(current, TASK_RUNNING);
+		spin_lock_irq(&cc->write_thread_wait.lock);
+		__remove_wait_queue(&cc->write_thread_wait, &wait);
+		goto continue_locked;
+
+pop_from_list:
+		write_tree = cc->write_tree;
+		cc->write_tree = RB_ROOT;
+		spin_unlock_irq(&cc->write_thread_wait.lock);
+
+		BUG_ON(rb_parent(write_tree.rb_node));
+
+		blk_start_plug(&plug);
+		do {
+			io = req_crypt_io_from_node(rb_first(&write_tree));
+			rb_erase(&io->rb_node, &write_tree);
+			req_crypt_dispatch_io(io);
+		} while (!RB_EMPTY_ROOT(&write_tree));
+		blk_finish_plug(&plug);
+	}
+
+	return 0;
+}
+
+static void req_crypt_write_io_submit(struct dm_req_crypt_io *io, int async)
+{
+	struct crypt_config *cc = io->cc;
+	unsigned long flags;
+	sector_t sector;
+	struct rb_node **rbp, *parent;
+
+	if (io->error < 0)
+		return;
+
+	if (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) {
+		req_crypt_dispatch_io(io);
+		return;
+	}
+
+	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
+	rbp = &cc->write_tree.rb_node;
+	parent = NULL;
+	sector = io->sector;
+
+	while (*rbp) {
+		parent = *rbp;
+		if (sector < req_crypt_io_from_node(parent)->sector)
+			rbp = &(*rbp)->rb_left;
+		else
+			rbp = &(*rbp)->rb_right;
+	}
+
+	rb_link_node(&io->rb_node, parent, rbp);
+	rb_insert_color(&io->rb_node, &cc->write_tree);
+
+	wake_up_locked(&cc->write_thread_wait);
+	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
+}
+
+/*
+ * Cipher complete callback, this is triggered by the linux crypto api once
+ * the operation is done. This signals the waiting thread that the crypto
+ * operation is complete.
+ */
+static void req_crypt_cipher_complete(struct crypto_async_request *req, int err)
+{
+	struct dm_crypt_request *dmreq = req->data;
+	struct convert_context *ctx = dmreq->ctx;
+	struct dm_req_crypt_io *io =
+		container_of(ctx, struct dm_req_crypt_io, ctx);
+	struct crypt_config *cc = io->cc;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	io->error = err;
+	atomic_dec(&io->ctx.cc_pending);
+	complete(&io->ctx.restart);
+
+	if (!err && cc->iv_gen_ops && cc->iv_gen_ops->post)
+		err = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
+}
+
+static int req_crypt_alloc_req(struct crypt_config *cc,
+				struct convert_context *ctx)
+{
+	/* TODO: need to reconsider and modify here */
+	unsigned int key_index = ctx->cc_sector & (cc->tfms_count - 1);
+	struct dm_crypt_request *dmreq;
+
+	ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
+	if (!ctx->req)
+		return -ENOMEM;
+
+	dmreq = dmreq_of_req(cc, ctx->req);
+	dmreq->req_sgt_in.orig_nents = 0;
+	dmreq->req_sgt_out.orig_nents = 0;
+
+	crypto_ablkcipher_clear_flags(cc->tfms[key_index], ~0);
+	ablkcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
+
+	/*
+	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
+	 * requests if driver request queue is full.
+	 */
+	ablkcipher_request_set_callback(ctx->req,
+	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+	    req_crypt_cipher_complete, dmreq_of_req(cc, ctx->req));
+
+	return 0;
+}
+
+/*
+ * Free the pages that used to allacation for write operation, also it
+ * will free the bvec if there are.
+ */
+static void req_crypt_free_pages(struct crypt_config *cc, struct request *clone)
+{
+	struct req_iterator iter;
+	struct bio_vec bvec;
+	struct bio *bio_t;
+	int nr_iovecs = 0;
+
+	rq_for_each_segment(bvec, clone, iter) {
+		if (bvec.bv_offset == 0 && bvec.bv_page)
+			mempool_free(bvec.bv_page, cc->page_pool);
+		bvec.bv_page = NULL;
+	}
+
+	__rq_for_each_bio(bio_t, clone) {
+		nr_iovecs = bio_t->bi_max_vecs;
+		if (nr_iovecs > BIO_INLINE_VECS) {
+			BIO_BUG_ON(BIO_POOL_IDX(bio_t) >= BIOVEC_NR_POOLS);
+			bvec_free(cc->bs->bvec_pool, bio_t->bi_io_vec,
+				  BIO_POOL_IDX(bio_t));
+		}
+	}
+}
+
+/*
+ * Allocate the pages for write operation.
+ */
+static int req_crypt_alloc_pages(struct crypt_config *cc, struct request *clone)
+{
+	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
+	struct page *page = NULL;
+	struct bio_vec *bvl = NULL;
+	struct bio_vec *bv = NULL;
+	struct bio *bio_t = NULL;
+	unsigned long idx = BIO_POOL_NONE;
+	struct bio_vec bvec;
+	struct bvec_iter biter;
+	int nr_iovecs = 0, i = 0, remaining_size = 0;
+
+	/*
+	 * When clone the request, it will not copy the bi_vcnt and
+	 * bi_max_vecs of one bio, so we should set it here.
+	 */
+	__rq_for_each_bio(bio_t, clone) {
+		nr_iovecs = 0;
+		bio_for_each_segment(bvec, bio_t, biter)
+			nr_iovecs++;
+		bio_t->bi_vcnt = bio_t->bi_max_vecs = nr_iovecs;
+	}
+
+	/*
+	 * When clone the original request, it will also clone the bios of
+	 * the original request. But it will not copy the pages which the
+	 * original bios are pointing to and the cloned bios just point
+	 * same page. So here we need to allocate some new pages for the
+	 * clone bios to encrypto system.
+	 */
+	__rq_for_each_bio(bio_t, clone) {
+		nr_iovecs = bio_t->bi_max_vecs;
+		if (nr_iovecs > BIO_INLINE_VECS)
+			bvl = bvec_alloc(GFP_NOIO, nr_iovecs,
+					 &idx, cc->bs->bvec_pool);
+		else if (nr_iovecs)
+			bvl = bio_t->bi_inline_vecs;
+
+		if (!bvl)
+			return -ENOMEM;
+
+		memcpy(bvl, bio_t->bi_io_vec,
+		       nr_iovecs * sizeof(struct bio_vec));
+		bio_t->bi_max_vecs = nr_iovecs;
+		bio_t->bi_io_vec = bvl;
+		if (idx < BIO_POOL_NONE) {
+			bio_t->bi_flags &= ~(BIO_POOL_NONE << BIO_POOL_OFFSET);
+			bio_t->bi_flags |= idx << BIO_POOL_OFFSET;
+		}
+	}
+
+	__rq_for_each_bio(bio_t, clone) {
+		bio_for_each_segment_all(bv, bio_t, i) {
+			if (bv->bv_len > remaining_size) {
+				page = NULL;
+				while (page == NULL) {
+					page = mempool_alloc(cc->page_pool,
+							     gfp_mask);
+					if (!page) {
+						DMERR("%s page alloc failed",
+						      __func__);
+						congestion_wait(BLK_RW_ASYNC,
+								HZ/100);
+					}
+				}
+
+				bv->bv_page = page;
+				bv->bv_offset = 0;
+				remaining_size = PAGE_SIZE - bv->bv_len;
+				if (remaining_size < 0)
+					BUG();
+			} else {
+				bv->bv_page = page;
+				bv->bv_offset = PAGE_SIZE - remaining_size;
+				remaining_size = remaining_size - bv->bv_len;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Check how many sg entry numbers are needed when map one request
+ * with scatterlist in advance.
+ */
+static unsigned int req_crypt_clone_sg_entry(struct request *clone)
+{
+	struct request_queue *q = clone->q;
+	struct bio_vec bvec, bvprv = { NULL };
+	struct bio *bio_t = NULL;
+	struct bvec_iter biter;
+	unsigned int nbytes, sg_length, sg_cnt = 0;
+
+	__rq_for_each_bio(bio_t, clone) {
+		sg_length = 0;
+		bio_for_each_segment(bvec, bio_t, biter) {
+			nbytes = bvec.bv_len;
+			if (sg_length + nbytes > queue_max_segment_size(q)) {
+				sg_length = 0;
+				sg_cnt++;
+				goto next;
+			}
+
+			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec)) {
+				sg_length = 0;
+				sg_cnt++;
+				goto next;
+			}
+
+			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bvec)) {
+				sg_length = 0;
+				sg_cnt++;
+				goto next;
+			}
+
+			sg_length += nbytes;
+next:
+			memcpy(&bvprv, &bvec, sizeof(struct bio_vec));
+		}
+	}
+
+	return sg_cnt;
+}
+
+static int req_crypt_convert_block(struct crypt_config *cc,
+				   struct request *clone,
+				   struct convert_context *ctx)
+{
+	struct ablkcipher_request *req = ctx->req;
+	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
+	u8 *iv = iv_of_dmreq(cc, dmreq);
+	struct scatterlist *req_sg_in = NULL;
+	struct scatterlist *req_sg_out = NULL;
+	unsigned int total_sg_len_req_in = 0;
+	unsigned int total_sg_len_req_out = 0;
+	unsigned int total_bytes_in_req = 0;
+	unsigned int sg_in_max = 0, sg_out_max = 0;
+	int ret;
+
+	dmreq->iv_sector = ctx->cc_sector;
+	dmreq->ctx = ctx;
+	atomic_set(&ctx->cc_pending, 1);
+
+	/*
+	 * Need to calculate how many sg entry need to be used
+	 * for this clone.
+	 */
+	sg_in_max = req_crypt_clone_sg_entry(clone) + 1;
+	if (sg_in_max > DM_MAX_SG_LIST || sg_in_max <= 0) {
+		DMERR("%s sg entry too large or none %d\n",
+		      __func__, sg_in_max);
+		return -EINVAL;
+	} else if (sg_in_max == 2) {
+		req_sg_in = &dmreq->sg_in;
+	}
+
+	if (!req_sg_in) {
+		ret = sg_alloc_table(&dmreq->req_sgt_in,
+				     sg_in_max, GFP_KERNEL);
+		if (ret) {
+			DMERR("%s sg in allocation failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		req_sg_in = dmreq->req_sgt_in.sgl;
+	}
+
+	total_sg_len_req_in = blk_rq_map_sg(clone->q, clone, req_sg_in);
+	if ((total_sg_len_req_in <= 0)
+	    || (total_sg_len_req_in > sg_in_max)) {
+		DMERR("%s in sg map error %d\n", __func__, total_sg_len_req_in);
+		return -EINVAL;
+	}
+
+	total_bytes_in_req = clone->__data_len;
+
+	if (rq_data_dir(clone) == READ)
+		goto set_crypt;
+
+	ret = req_crypt_alloc_pages(cc, clone);
+	if (ret < 0) {
+		DMERR("%s alloc request pages failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	sg_out_max = req_crypt_clone_sg_entry(clone) + 1;
+	if (sg_out_max > DM_MAX_SG_LIST || sg_out_max <= 0) {
+		DMERR("%s sg entry too large or none %d\n",
+		      __func__, sg_out_max);
+		return -EINVAL;
+	} else if (sg_out_max == 2) {
+		req_sg_out = &dmreq->sg_out;
+	}
+
+	if (!req_sg_out) {
+		ret = sg_alloc_table(&dmreq->req_sgt_out,
+				     sg_out_max, GFP_KERNEL);
+		if (ret) {
+			DMERR("%s sg out allocation failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		req_sg_out = dmreq->req_sgt_out.sgl;
+	}
+
+	total_sg_len_req_out = blk_rq_map_sg(clone->q, clone, req_sg_out);
+	if ((total_sg_len_req_out <= 0) ||
+	    (total_sg_len_req_out > sg_out_max)) {
+		DMERR("%s out sg map error %d\n",
+		      __func__, total_sg_len_req_out);
+		return -EINVAL;
+	}
+
+set_crypt:
+	if (cc->iv_gen_ops) {
+		ret = cc->iv_gen_ops->generator(cc, iv, dmreq);
+		if (ret < 0) {
+			DMERR("%s generator iv error %d\n", __func__, ret);
+			return ret;
+		}
+	}
+
+	atomic_inc(&ctx->cc_pending);
+
+	if (rq_data_dir(clone) == WRITE) {
+		ablkcipher_request_set_crypt(req, req_sg_in,
+			req_sg_out, total_bytes_in_req, iv);
+
+		ret = crypto_ablkcipher_encrypt(req);
+	} else {
+		ablkcipher_request_set_crypt(req, req_sg_in,
+			req_sg_in, total_bytes_in_req, iv);
+
+		ret = crypto_ablkcipher_decrypt(req);
+	}
+
+	if (!ret && cc->iv_gen_ops && cc->iv_gen_ops->post)
+		ret = cc->iv_gen_ops->post(cc, iv, dmreq);
+
+	return ret;
+}
+
+static void req_crypt_write_convert(struct dm_req_crypt_io *io)
+{
+	struct request *clone = io->cloned_request;
+	struct bio *bio_src = NULL;
+	struct crypt_config *cc = io->cc;
+	int crypt_finished;
+	int ret = 0, err = 0;
+
+	req_crypt_inc_pending(io);
+
+	crypt_convert_init(cc, &io->ctx, NULL, NULL, io->sector);
+	req_crypt_alloc_req(cc, &io->ctx);
+
+	ret = req_crypt_convert_block(cc, clone, &io->ctx);
+	switch (ret) {
+	case 0:
+		atomic_dec(&io->ctx.cc_pending);
+		break;
+	case -EBUSY:
+		/*
+		 * Lets make this synchronous request by waiting on
+		 * in progress as well
+		 */
+	case -EINPROGRESS:
+		wait_for_completion_io(&io->ctx.restart);
+		if (io->error) {
+			err = -EIO;
+			goto crypt_error;
+		}
+		break;
+	default:
+		err = -EIO;
+		atomic_dec(&io->ctx.cc_pending);
+		break;
+	}
+
+	__rq_for_each_bio(bio_src, clone)
+		blk_queue_bounce(clone->q, &bio_src);
+
+crypt_error:
+	if (err == -EIO)
+		req_crypt_free_pages(cc, clone);
+
+	if (io)
+		io->error = err;
+
+	/* Encryption was already finished, submit io now */
+	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
+	if (crypt_finished)
+		req_crypt_write_io_submit(io, 0);
+	else
+		io->error = -EIO;
+
+	req_crypt_dec_pending_encrypt(io);
+}
+
+static void req_crypt_read_convert(struct dm_req_crypt_io *io)
+{
+	struct crypt_config *cc = io->cc;
+	struct request *clone = io->cloned_request;
+	int ret = 0, err = 0;
+
+	req_crypt_inc_pending(io);
+
+	/* io->sector need to be initilized */
+	crypt_convert_init(cc, &io->ctx, NULL, NULL, io->sector);
+	req_crypt_alloc_req(cc, &io->ctx);
+
+	ret = req_crypt_convert_block(cc, clone, &io->ctx);
+	switch (ret) {
+	case 0:
+		atomic_dec(&io->ctx.cc_pending);
+		break;
+	case -EBUSY:
+		/*
+		 * Lets make this synchronous request by waiting on
+		 * in progress as well
+		 */
+	case -EINPROGRESS:
+		wait_for_completion_io(&io->ctx.restart);
+		if (io->error)
+			err = -EIO;
+		break;
+	default:
+		err = -EIO;
+		atomic_dec(&io->ctx.cc_pending);
+		break;
+	}
+
+	if (io)
+		io->error = err;
+
+	if (!atomic_dec_and_test(&io->ctx.cc_pending))
+		DMWARN("%s decryption was not finished\n", __func__);
+
+	req_crypt_dec_pending_decrypt(io);
+}
+
+/* Queue callback function that will get triggered */
+static void req_crypt_work(struct work_struct *work)
+{
+	struct dm_req_crypt_io *io =
+			container_of(work, struct dm_req_crypt_io, work);
+
+	if (rq_data_dir(io->cloned_request) == WRITE) {
+		if (io->should_encrypt)
+			req_crypt_write_convert(io);
+		else
+			req_crypt_write_plain(io);
+	} else if (rq_data_dir(io->cloned_request) == READ) {
+		if (io->should_decrypt)
+			req_crypt_read_convert(io);
+		else
+			req_crypt_read_plain(io);
+	} else {
+		DMERR("%s received non-write request for clone 0x%p\n",
+		      __func__, io->cloned_request);
+	}
+}
+
+static void req_crypt_queue(struct dm_req_crypt_io *io)
+{
+	struct crypt_config *cc = io->cc;
+
+	INIT_WORK(&io->work, req_crypt_work);
+	queue_work(cc->crypt_queue, &io->work);
+}
+
+static bool req_crypt_should_encrypt(struct dm_req_crypt_io *req)
+{
+	if (!req || !req->cloned_request || !req->cloned_request->bio)
+		return false;
+
+	/* Maybe there are some others to be considerated */
+	return true;
+}
+
+static bool req_crypt_should_deccrypt(struct dm_req_crypt_io *req)
+{
+	if (!req || !req->cloned_request || !req->cloned_request->bio)
+		return false;
+
+	/* Maybe there are some others to be considerated */
+	return true;
+}
+
+static void crypt_req_io_init(struct dm_req_crypt_io *io,
+			      struct crypt_config *cc,
+			      struct request *clone,
+			      sector_t sector)
+{
+	io->cc = cc;
+	io->sector = sector;
+	io->cloned_request = clone;
+	io->error = 0;
+	io->ctx.req = NULL;
+	atomic_set(&io->pending, 0);
+
+	if (rq_data_dir(clone) == WRITE)
+		io->should_encrypt = req_crypt_should_encrypt(io);
+	else if (rq_data_dir(clone) == READ)
+		io->should_decrypt = req_crypt_should_deccrypt(io);
+	else
+		io->should_decrypt = 0;
+}
+
+/*
+ * This function is called with interrupts disabled
+ * The function remaps the clone for the underlying device.
+ * If it is a write request, it calls into the worker queue to
+ * encrypt the data
+ * and submit the request directly using the elevator
+ * For a read request no pre-processing is required the request
+ * is returned to dm once mapping is done
+ */
+static int req_crypt_map(struct dm_target *ti, struct request *clone,
+			 union map_info *map_context)
+{
+	struct crypt_config *cc = ti->private;
+	int copy_bio_sector_to_req = 0;
+	struct dm_req_crypt_io *req_io;
+	struct bio *bio_src;
+
+	if ((rq_data_dir(clone) != READ) && (rq_data_dir(clone) != WRITE)) {
+		DMERR("%s unknown request.\n", __func__);
+		return -EINVAL;
+	}
+
+	req_io = mempool_alloc(cc->req_io_pool, GFP_NOWAIT);
+	if (!req_io) {
+		DMERR("%s req io allocation failed.\n", __func__);
+		return -ENOMEM;
+	}
+
+	map_context->ptr = req_io;
+
+	/* Get the queue of the underlying original device */
+	clone->q = bdev_get_queue(cc->dev->bdev);
+	clone->rq_disk = cc->dev->bdev->bd_disk;
+
+	__rq_for_each_bio(bio_src, clone) {
+		bio_src->bi_bdev = cc->dev->bdev;
+		/*
+		 * If request is REQ_FLUSH or REQ_DISCARD, just bypass crypt
+		 * queues. It will free the bios of the request in block layer
+		 * when completing the bypass if the request is REQ_FLUSH or
+		 * REQ_DISCARD.
+		 */
+		if (clone->cmd_flags & REQ_DISCARD
+		    || clone->cmd_flags & REQ_FLUSH)
+			continue;
+
+		bio_set_flag(bio_src, BIO_ENDIO_FREE);
+
+		/*
+		 * If this device has partitions, remap block n
+		 * of partition p to block n+start(p) of the disk.
+		 */
+		req_crypt_blk_partition_remap(bio_src);
+		if (copy_bio_sector_to_req == 0) {
+			clone->__sector = bio_src->bi_iter.bi_sector;
+			copy_bio_sector_to_req++;
+		}
+		blk_queue_bounce(clone->q, &bio_src);
+	}
+
+	crypt_req_io_init(req_io, cc, clone,
+			  dm_target_offset(ti, clone->__sector));
+
+	if (rq_data_dir(clone) == READ) {
+		return DM_MAPIO_REMAPPED;
+	} else if (rq_data_dir(clone) == WRITE) {
+		req_crypt_queue(req_io);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	return -EINVAL;
+}
+
+/*
+ * The endio function is called from ksoftirqd context (atomic).
+ * For write operations the new pages created form the mempool
+ * is freed and returned.  * For read operations, decryption is
+ * required, since this is called in a atomic  * context, the
+ * request is sent to a worker queue to complete decryption and
+ * free the request once done.
+ */
+static int req_crypt_endio(struct dm_target *ti, struct request *clone,
+			   int error, union map_info *map_context)
+{
+	struct dm_req_crypt_io *req_io = map_context->ptr;
+	struct crypt_config *cc = ti->private;
+	int ret = 0;
+
+	/* If it is a write request, do nothing just return. */
+	if (rq_data_dir(clone) == WRITE) {
+		if (req_io->should_encrypt)
+			req_crypt_free_pages(cc, clone);
+		req_crypt_free_resource(req_io);
+	} else if (rq_data_dir(clone) == READ) {
+		req_io->error = error;
+		req_crypt_queue(req_io);
+		ret = DM_ENDIO_INCOMPLETE;
+	}
+
+	return ret;
+}
+
 static struct target_type crypt_target = {
 	.name   = "crypt",
 	.version = {1, 14, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-	.map    = crypt_map,
 	.status = crypt_status,
+#ifndef CONFIG_DM_REQ_CRYPT
+	.map    = crypt_map,
+#else
+	.map_rq = req_crypt_map,
+	.rq_end_io = req_crypt_endio,
+#endif
 	.postsuspend = crypt_postsuspend,
 	.preresume = crypt_preresume,
 	.resume = crypt_resume,
-- 
1.7.9.5

