From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v2 2/2] md: dm-crypt: Introduce the bulk IV mode for bulk crypto
Date: Wed, 16 Dec 2015 11:18:36 +0800
Message-ID: <ea41af985b482f2b1ea670b9c250faf8757b1371.1450233399.git.baolin.wang@linaro.org>
References: <cover.1450233399.git.baolin.wang@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450233399.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1450233399.git.baolin.wang@linaro.org>
References: <cover.1450233399.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

In now dm-crypt code, it is ineffective to map one segment (always one
sector) of one bio with just only one scatterlist at one time for hardware
crypto engine. Especially for some encryption mode (like ecb or xts mode)
cooperating with the crypto engine, they just need one initial IV or null
IV instead of different IV for each sector. In this situation We can consider
to use multiple scatterlists to map the whole bio and send all scatterlists
of one bio to crypto engine to encrypt or decrypt, which can improve the
hardware engine's efficiency.

With this optimization, On my test setup (beaglebone black board) using 64KB
I/Os on an eMMC storage device I saw about 60% improvement in throughput for
encrypted writes, and about 100% improvement for encrypted reads. But this
is not fit for other modes which need different IV for each sector.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/md/dm-crypt.c |  333 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 327 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 917d47e..dc2e5e6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -32,6 +32,7 @@
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "crypt"
+#define DM_MAX_SG_LIST	1024
 
 /*
  * context holding the current state of a multi-part conversion
@@ -68,6 +69,8 @@ struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
+	struct sg_table sgt_in;
+	struct sg_table sgt_out;
 	sector_t iv_sector;
 };
 
@@ -140,6 +143,7 @@ struct crypt_config {
 	char *cipher;
 	char *cipher_string;
 
+	int bulk_crypto;
 	struct crypt_iv_operations *iv_gen_ops;
 	union {
 		struct iv_essiv_private essiv;
@@ -238,6 +242,9 @@ static struct crypto_ablkcipher *any_tfm(struct crypt_config *cc)
  *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
+ *
+ * bulk: the initial vector is the 64-bit little-endian version of the sector
+ *	 number, which is used as just one initial IV for one bulk data.
  */
 
 static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
@@ -755,6 +762,15 @@ static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 	return r;
 }
 
+static int crypt_iv_bulk_gen(struct crypt_config *cc, u8 *iv,
+			     struct dm_crypt_request *dmreq)
+{
+	memset(iv, 0, cc->iv_size);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
+
+	return 0;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -799,6 +815,10 @@ static struct crypt_iv_operations crypt_iv_tcw_ops = {
 	.post	   = crypt_iv_tcw_post
 };
 
+static struct crypt_iv_operations crypt_iv_bulk_ops = {
+	.generator = crypt_iv_bulk_gen
+};
+
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -833,6 +853,11 @@ static u8 *iv_of_dmreq(struct crypt_config *cc,
 		crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
 }
 
+static int crypt_is_bulk_mode(struct crypt_config *cc)
+{
+	return cc->bulk_crypto;
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
@@ -881,24 +906,40 @@ static int crypt_convert_block(struct crypt_config *cc,
 
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
+static void kcryptd_async_all_done(struct crypto_async_request *async_req,
+				   int error);
 
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
+	struct dm_crypt_request *dmreq;
 
 	if (!ctx->req)
 		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
+	dmreq = dmreq_of_req(cc, ctx->req);
+	dmreq->sgt_in.orig_nents = 0;
+	dmreq->sgt_out.orig_nents = 0;
+
 	ablkcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
 
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
 	 * requests if driver request queue is full.
 	 */
-	ablkcipher_request_set_callback(ctx->req,
-	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
+	if (crypt_is_bulk_mode(cc))
+		ablkcipher_request_set_callback(ctx->req,
+						CRYPTO_TFM_REQ_MAY_BACKLOG
+						| CRYPTO_TFM_REQ_MAY_SLEEP,
+						kcryptd_async_all_done,
+						dmreq_of_req(cc, ctx->req));
+	else
+		ablkcipher_request_set_callback(ctx->req,
+						CRYPTO_TFM_REQ_MAY_BACKLOG
+						| CRYPTO_TFM_REQ_MAY_SLEEP,
+						kcryptd_async_done,
+						dmreq_of_req(cc, ctx->req));
 }
 
 static void crypt_free_req(struct crypt_config *cc,
@@ -911,6 +952,221 @@ static void crypt_free_req(struct crypt_config *cc,
 }
 
 /*
+ * Check how many sg entry numbers are needed when map one bio
+ * with scatterlist in advance.
+ */
+static unsigned int crypt_sg_entry(struct bio *bio_t)
+{
+	struct request_queue *q = bdev_get_queue(bio_t->bi_bdev);
+	int cluster = blk_queue_cluster(q);
+	struct bio_vec bvec, bvprv = { NULL };
+	struct bvec_iter biter;
+	unsigned long nbytes = 0, sg_length = 0;
+	unsigned int sg_cnt = 0;
+
+	if (bio_t->bi_rw & REQ_DISCARD) {
+		if (bio_t->bi_vcnt)
+			return 1;
+		return 0;
+	}
+
+	if (bio_t->bi_rw & REQ_WRITE_SAME)
+		return 1;
+
+	bio_for_each_segment(bvec, bio_t, biter) {
+		nbytes = bvec.bv_len;
+
+		if (!cluster) {
+			sg_cnt++;
+			continue;
+		}
+
+		if (sg_length + nbytes > queue_max_segment_size(q)) {
+			sg_length = nbytes;
+			sg_cnt++;
+			goto next;
+		}
+
+		if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec)) {
+			sg_length = nbytes;
+			sg_cnt++;
+			goto next;
+		}
+
+		if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bvec)) {
+			sg_length = nbytes;
+			sg_cnt++;
+			goto next;
+		}
+
+		sg_length += nbytes;
+next:
+		memcpy(&bvprv, &bvec, sizeof(struct bio_vec));
+	}
+
+	return sg_cnt;
+}
+
+static int crypt_convert_all_blocks(struct crypt_config *cc,
+				   struct convert_context *ctx,
+				   struct ablkcipher_request *req)
+{
+	struct dm_crypt_io *io =
+		container_of(ctx, struct dm_crypt_io, ctx);
+	struct dm_crypt_request *dmreq = dmreq_of_req(cc, req);
+	u8 *iv = iv_of_dmreq(cc, dmreq);
+	struct bio *orig_bio = io->base_bio;
+	struct bio *bio_in = ctx->bio_in;
+	struct bio *bio_out = ctx->bio_out;
+	unsigned int total_bytes = orig_bio->bi_iter.bi_size;
+	struct scatterlist *sg_in = NULL;
+	struct scatterlist *sg_out = NULL;
+	struct scatterlist *sg = NULL;
+	unsigned int total_sg_len_in = 0;
+	unsigned int total_sg_len_out = 0;
+	unsigned int sg_in_max = 0, sg_out_max = 0;
+	int ret;
+
+	dmreq->iv_sector = ctx->cc_sector;
+	dmreq->ctx = ctx;
+
+	/*
+	 * Need to calculate how many sg entry need to be used
+	 * for this bio.
+	 */
+	sg_in_max = crypt_sg_entry(bio_in) + 1;
+	if (sg_in_max > DM_MAX_SG_LIST || sg_in_max <= 0) {
+		DMERR("%s sg entry too large or none %d\n",
+		      __func__, sg_in_max);
+		return -EINVAL;
+	} else if (sg_in_max == 2) {
+		sg_in = &dmreq->sg_in;
+	}
+
+	if (!sg_in) {
+		ret = sg_alloc_table(&dmreq->sgt_in, sg_in_max, GFP_KERNEL);
+		if (ret) {
+			DMERR("%s sg in allocation failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		sg_in = dmreq->sgt_in.sgl;
+	}
+
+	total_sg_len_in = __blk_bios_map_sg(bdev_get_queue(bio_in->bi_bdev),
+					    bio_in, sg_in, &sg);
+	if ((total_sg_len_in <= 0)
+	    || (total_sg_len_in > sg_in_max)) {
+		DMERR("%s in sg map error %d, sg_in_max[%d]\n",
+		      __func__, total_sg_len_in, sg_in_max);
+		return -EINVAL;
+	}
+
+	if (sg)
+		sg_mark_end(sg);
+
+	ctx->iter_in.bi_size -= total_bytes;
+
+	if (bio_data_dir(orig_bio) == READ)
+		goto set_crypt;
+
+	sg_out_max = crypt_sg_entry(bio_out) + 1;
+	if (sg_out_max > DM_MAX_SG_LIST || sg_out_max <= 0) {
+		DMERR("%s sg entry too large or none %d\n",
+		      __func__, sg_out_max);
+		return -EINVAL;
+	} else if (sg_out_max == 2) {
+		sg_out = &dmreq->sg_out;
+	}
+
+	if (!sg_out) {
+		ret = sg_alloc_table(&dmreq->sgt_out, sg_out_max, GFP_KERNEL);
+		if (ret) {
+			DMERR("%s sg out allocation failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		sg_out = dmreq->sgt_out.sgl;
+	}
+
+	sg = NULL;
+	total_sg_len_out = __blk_bios_map_sg(bdev_get_queue(bio_out->bi_bdev),
+					     bio_out, sg_out, &sg);
+	if ((total_sg_len_out <= 0) ||
+	    (total_sg_len_out > sg_out_max)) {
+		DMERR("%s out sg map error %d, sg_out_max[%d]\n",
+		      __func__, total_sg_len_out, sg_out_max);
+		return -EINVAL;
+	}
+
+	if (sg)
+		sg_mark_end(sg);
+
+	ctx->iter_out.bi_size -= total_bytes;
+set_crypt:
+	if (cc->iv_gen_ops) {
+		ret = cc->iv_gen_ops->generator(cc, iv, dmreq);
+		if (ret < 0) {
+			DMERR("%s generator iv error %d\n", __func__, ret);
+			return ret;
+		}
+	}
+
+	if (bio_data_dir(orig_bio) == WRITE) {
+		ablkcipher_request_set_crypt(req, sg_in,
+					     sg_out, total_bytes, iv);
+
+		ret = crypto_ablkcipher_encrypt(req);
+	} else {
+		ablkcipher_request_set_crypt(req, sg_in,
+					     sg_in, total_bytes, iv);
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
+/*
+ * Encrypt / decrypt data from one whole bio at one time.
+ */
+static int crypt_convert_io(struct crypt_config *cc,
+			    struct convert_context *ctx)
+{
+	int r;
+
+	atomic_set(&ctx->cc_pending, 1);
+	crypt_alloc_req(cc, ctx);
+	atomic_inc(&ctx->cc_pending);
+
+	r = crypt_convert_all_blocks(cc, ctx, ctx->req);
+	switch (r) {
+	case -EBUSY:
+		/*
+		 * Lets make this synchronous bio by waiting on
+		 * in progress as well.
+		 */
+	case -EINPROGRESS:
+		wait_for_completion(&ctx->restart);
+		ctx->req = NULL;
+		break;
+	case 0:
+		atomic_dec(&ctx->cc_pending);
+		cond_resched();
+		break;
+	/* There was an error while processing the request. */
+	default:
+		atomic_dec(&ctx->cc_pending);
+		return r;
+	}
+
+	return 0;
+}
+
+/*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
 static int crypt_convert(struct crypt_config *cc,
@@ -1070,12 +1326,18 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
 	int error = io->error;
+	struct dm_crypt_request *dmreq;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
-	if (io->ctx.req)
+	if (io->ctx.req) {
+		dmreq = dmreq_of_req(cc, io->ctx.req);
+		sg_free_table(&dmreq->sgt_out);
+		sg_free_table(&dmreq->sgt_in);
+
 		crypt_free_req(cc, io->ctx.req, base_bio);
+	}
 
 	base_bio->bi_error = error;
 	bio_endio(base_bio);
@@ -1312,7 +1574,11 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, &io->ctx);
+	if (crypt_is_bulk_mode(cc))
+		r = crypt_convert_io(cc, &io->ctx);
+	else
+		r = crypt_convert(cc, &io->ctx);
+
 	if (r)
 		io->error = -EIO;
 	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
@@ -1342,7 +1608,11 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, &io->ctx);
+	if (crypt_is_bulk_mode(cc))
+		r = crypt_convert_io(cc, &io->ctx);
+	else
+		r = crypt_convert(cc, &io->ctx);
+
 	if (r < 0)
 		io->error = -EIO;
 
@@ -1387,6 +1657,40 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		kcryptd_crypt_write_io_submit(io, 1);
 }
 
+static void kcryptd_async_all_done(struct crypto_async_request *async_req,
+			       int error)
+{
+	struct dm_crypt_request *dmreq = async_req->data;
+	struct convert_context *ctx = dmreq->ctx;
+	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
+	struct crypt_config *cc = io->cc;
+
+	if (error == -EINPROGRESS)
+		return;
+
+	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
+		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
+
+	if (error < 0)
+		io->error = error;
+
+	sg_free_table(&dmreq->sgt_out);
+	sg_free_table(&dmreq->sgt_in);
+
+	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
+
+	if (!atomic_dec_and_test(&ctx->cc_pending)) {
+		complete(&io->ctx.restart);
+		return;
+	}
+
+	complete(&io->ctx.restart);
+	if (bio_data_dir(io->base_bio) == READ)
+		kcryptd_crypt_read_done(io);
+	else
+		kcryptd_crypt_write_io_submit(io, 1);
+}
+
 static void kcryptd_crypt(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
@@ -1633,6 +1937,21 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		goto bad_mem;
 	}
 
+	/*
+	 * Here we need to check if it can be encrypted or decrypted with
+	 * bulk block, which means these encryption modes don't need IV or
+	 * just need one initial IV. For bulk mode, we can expand the
+	 * scatterlist entries to map the bio, then send all the scatterlists
+	 * to the hardware engine at one time to improve the crypto engine
+	 * efficiency. But it does not fit for other IV modes, it has to do
+	 * encryption and decryption sector by sector because every sector
+	 * has different IV.
+	 */
+	if (!ivmode || !strcmp(ivmode, "bulk") || !strcmp(ivmode, "null"))
+		cc->bulk_crypto = 1;
+	else
+		cc->bulk_crypto = 0;
+
 	/* Allocate cipher */
 	ret = crypt_alloc_tfms(cc, cipher_api);
 	if (ret < 0) {
@@ -1680,6 +1999,8 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		cc->iv_gen_ops = &crypt_iv_tcw_ops;
 		cc->key_parts += 2; /* IV + whitening */
 		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
+	} else if (strcmp(ivmode, "bulk") == 0) {
+		cc->iv_gen_ops = &crypt_iv_bulk_ops;
 	} else {
 		ret = -EINVAL;
 		ti->error = "Invalid IV mode";
-- 
1.7.9.5
