From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 13/20] dm-crypt merge convert_context and
	dm_crypt_io
Date: Tue, 21 Aug 2012 11:09:24 +0200
Message-ID: <39aab22fb74eb0a09cfae9fe3a11f52c9c4c7e52.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

There is one-to-one relationship between convert_context and dm_crypt_io,
so we can merge these structures into one and simplify the code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |  120 +++++++++++++++++++++++--------------------------
 1 file changed, 56 insertions(+), 64 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 36c9087..bb11a95 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -37,9 +37,13 @@
 #define DM_CRYPT_DEFAULT_CPUS			3
 
 /*
- * context holding the current state of a multi-part conversion
+ * per bio private data
  */
-struct convert_context {
+struct dm_crypt_io {
+	struct crypt_config *cc;
+	struct bio *base_bio;
+	struct work_struct work;
+
 	struct bio *bio_in;
 	struct bio *bio_out;
 	unsigned int offset_in;
@@ -48,17 +52,6 @@ struct convert_context {
 	unsigned int idx_out;
 	sector_t cc_sector;
 	atomic_t cc_pending;
-};
-
-/*
- * per bio private data
- */
-struct dm_crypt_io {
-	struct crypt_config *cc;
-	struct bio *base_bio;
-	struct work_struct work;
-
-	struct convert_context ctx;
 
 	atomic_t io_pending;
 	int error;
@@ -67,7 +60,7 @@ struct dm_crypt_io {
 
 struct dm_crypt_request {
 	struct list_head list;
-	struct convert_context *ctx;
+	struct dm_crypt_io *io;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 	sector_t iv_sector;
@@ -569,7 +562,7 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 	u8 *src;
 	int r = 0;
 
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
+	if (bio_data_dir(dmreq->io->bio_in) == WRITE) {
 		src = kmap_atomic(sg_page(&dmreq->sg_in));
 		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
 		kunmap_atomic(src);
@@ -585,7 +578,7 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 	u8 *dst;
 	int r;
 
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+	if (bio_data_dir(dmreq->io->bio_in) == WRITE)
 		return 0;
 
 	dst = kmap_atomic(sg_page(&dmreq->sg_out));
@@ -635,17 +628,17 @@ static struct crypt_iv_operations crypt_iv_lmk_ops = {
 };
 
 static void crypt_convert_init(struct crypt_config *cc,
-			       struct convert_context *ctx,
+			       struct dm_crypt_io *io,
 			       struct bio *bio_out, struct bio *bio_in,
 			       sector_t sector)
 {
-	ctx->bio_in = bio_in;
-	ctx->bio_out = bio_out;
-	ctx->offset_in = 0;
-	ctx->offset_out = 0;
-	ctx->idx_in = bio_in ? bio_in->bi_idx : 0;
-	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
-	ctx->cc_sector = sector + cc->iv_offset;
+	io->bio_in = bio_in;
+	io->bio_out = bio_out;
+	io->offset_in = 0;
+	io->offset_out = 0;
+	io->idx_in = bio_in ? bio_in->bi_idx : 0;
+	io->idx_out = bio_out ? bio_out->bi_idx : 0;
+	io->cc_sector = sector + cc->iv_offset;
 }
 
 static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
@@ -724,7 +717,7 @@ pop_from_list:
 			int r;
 			DECLARE_COMPLETION(busy_wait);
 			dmreq->busy_wait = &busy_wait;
-			if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+			if (bio_data_dir(dmreq->io->bio_in) == WRITE)
 				r = crypto_ablkcipher_encrypt(req);
 			else
 				r = crypto_ablkcipher_decrypt(req);
@@ -741,12 +734,12 @@ pop_from_list:
 }
 
 static int crypt_convert_block(struct crypt_config *cc,
-			       struct convert_context *ctx,
+			       struct dm_crypt_io *io,
 			       struct ablkcipher_request *req,
 			       struct list_head *batch)
 {
-	struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
-	struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
+	struct bio_vec *bv_in = bio_iovec_idx(io->bio_in, io->idx_in);
+	struct bio_vec *bv_out = bio_iovec_idx(io->bio_out, io->idx_out);
 	struct dm_crypt_request *dmreq;
 	u8 *iv;
 	int r;
@@ -754,26 +747,26 @@ static int crypt_convert_block(struct crypt_config *cc,
 	dmreq = dmreq_of_req(cc, req);
 	iv = iv_of_dmreq(cc, dmreq);
 
-	dmreq->iv_sector = ctx->cc_sector;
-	dmreq->ctx = ctx;
+	dmreq->iv_sector = io->cc_sector;
+	dmreq->io = io;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
-		    bv_in->bv_offset + ctx->offset_in);
+		    bv_in->bv_offset + io->offset_in);
 
 	sg_init_table(&dmreq->sg_out, 1);
 	sg_set_page(&dmreq->sg_out, bv_out->bv_page, 1 << SECTOR_SHIFT,
-		    bv_out->bv_offset + ctx->offset_out);
+		    bv_out->bv_offset + io->offset_out);
 
-	ctx->offset_in += 1 << SECTOR_SHIFT;
-	if (ctx->offset_in >= bv_in->bv_len) {
-		ctx->offset_in = 0;
-		ctx->idx_in++;
+	io->offset_in += 1 << SECTOR_SHIFT;
+	if (io->offset_in >= bv_in->bv_len) {
+		io->offset_in = 0;
+		io->idx_in++;
 	}
 
-	ctx->offset_out += 1 << SECTOR_SHIFT;
-	if (ctx->offset_out >= bv_out->bv_len) {
-		ctx->offset_out = 0;
-		ctx->idx_out++;
+	io->offset_out += 1 << SECTOR_SHIFT;
+	if (io->offset_out >= bv_out->bv_len) {
+		io->offset_out = 0;
+		io->idx_out++;
 	}
 
 	if (cc->iv_gen_ops) {
@@ -791,9 +784,9 @@ static int crypt_convert_block(struct crypt_config *cc,
 }
 
 static struct ablkcipher_request *crypt_alloc_req(struct crypt_config *cc,
-			    struct convert_context *ctx, gfp_t gfp_mask)
+			    struct dm_crypt_io *io, gfp_t gfp_mask)
 {
-	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
+	unsigned key_index = io->cc_sector & (cc->tfms_count - 1);
 	struct ablkcipher_request *req = mempool_alloc(cc->req_pool, gfp_mask);
 	if (!req)
 		return NULL;
@@ -820,7 +813,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async);
 
 static void crypt_dec_cc_pending(struct dm_crypt_io *io)
 {
-	if (!atomic_dec_and_test(&io->ctx.cc_pending))
+	if (!atomic_dec_and_test(&io->cc_pending))
 		return;
 
 	if (bio_data_dir(io->base_bio) == READ)
@@ -833,16 +826,16 @@ static void crypt_dec_cc_pending(struct dm_crypt_io *io)
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
 static int crypt_convert(struct crypt_config *cc,
-			 struct convert_context *ctx)
+			 struct dm_crypt_io *io)
 {
 	int r;
 	LIST_HEAD(batch);
 	unsigned batch_count = 0;
 
-	atomic_set(&ctx->cc_pending, 1);
+	atomic_set(&io->cc_pending, 1);
 
 	while (1) {
-		struct ablkcipher_request *req = crypt_alloc_req(cc, ctx, GFP_NOWAIT);
+		struct ablkcipher_request *req = crypt_alloc_req(cc, io, GFP_NOWAIT);
 		if (!req) {
 			/*
 			 * We must flush our request queue before we attempt
@@ -850,21 +843,21 @@ static int crypt_convert(struct crypt_config *cc,
 			 */
 			batch_count = 0;
 			crypt_flush_batch(cc, &batch);
-			req = crypt_alloc_req(cc, ctx, GFP_NOIO);
+			req = crypt_alloc_req(cc, io, GFP_NOIO);
 		}
 
-		r = crypt_convert_block(cc, ctx, req, &batch);
+		r = crypt_convert_block(cc, io, req, &batch);
 		if (unlikely(r < 0)) {
 			crypt_flush_batch(cc, &batch);
-			crypt_dec_cc_pending(container_of(ctx, struct dm_crypt_io, ctx));
+			crypt_dec_cc_pending(io);
 			goto ret;
 		}
 
-		ctx->sector++;
+		io->sector++;
 
-		if (ctx->idx_in < ctx->bio_in->bi_vcnt &&
-		    ctx->idx_out < ctx->bio_out->bi_vcnt) {
-			atomic_inc(&ctx->cc_pending);
+		if (io->idx_in < io->bio_in->bi_vcnt &&
+		    io->idx_out < io->bio_out->bi_vcnt) {
+			atomic_inc(&io->cc_pending);
 			if (unlikely(++batch_count >= DMREQ_PUSH_BATCH)) {
 				batch_count = 0;
 				crypt_flush_batch(cc, &batch);
@@ -1093,7 +1086,7 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 
 static void kcryptd_io_write(struct dm_crypt_io *io)
 {
-	struct bio *clone = io->ctx.bio_out;
+	struct bio *clone = io->bio_out;
 	generic_make_request(clone);
 }
 
@@ -1114,7 +1107,7 @@ static void kcryptd_queue_io(struct dm_crypt_io *io)
 
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 {
-	struct bio *clone = io->ctx.bio_out;
+	struct bio *clone = io->bio_out;
 	struct crypt_config *cc = io->cc;
 
 	if (unlikely(io->error < 0)) {
@@ -1125,7 +1118,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	}
 
 	/* crypt_convert should have filled the clone bio */
-	BUG_ON(io->ctx.idx_out < clone->bi_vcnt);
+	BUG_ON(io->idx_out < clone->bi_vcnt);
 
 	clone->bi_sector = cc->start + io->sector;
 
@@ -1147,7 +1140,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	 * Prevent io from disappearing until this function completes.
 	 */
 	crypt_inc_pending(io);
-	crypt_convert_init(cc, &io->ctx, NULL, io->base_bio, sector);
+	crypt_convert_init(cc, io, NULL, io->base_bio, sector);
 
 	clone = crypt_alloc_buffer(io, remaining);
 	if (unlikely(!clone)) {
@@ -1155,14 +1148,14 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		goto dec;
 	}
 
-	io->ctx.bio_out = clone;
-	io->ctx.idx_out = 0;
+	io->bio_out = clone;
+	io->idx_out = 0;
 
 	remaining -= clone->bi_size;
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert(cc, io);
 	if (r)
 		io->error = -EIO;
 dec:
@@ -1176,10 +1169,10 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 
 	crypt_inc_pending(io);
 
-	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
+	crypt_convert_init(cc, io, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert(cc, io);
 	if (r < 0)
 		io->error = -EIO;
 
@@ -1190,8 +1183,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error)
 {
 	struct dm_crypt_request *dmreq = async_req->data;
-	struct convert_context *ctx = dmreq->ctx;
-	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
+	struct dm_crypt_io *io = dmreq->io;
 	struct crypt_config *cc = io->cc;
 
 	if (error == -EINPROGRESS) {
-- 
1.7.10.4
