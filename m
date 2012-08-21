From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 16/20] dm-crypt: small changes
Date: Tue, 21 Aug 2012 11:09:27 +0200
Message-ID: <3dcf87b3f1d330782edcb02856d834b92d337fdb.1345477953.git.mbroz@redhat.com>
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

Small changes:
- bio_in and base_bio are always the same, so we can remove bio_in.
- simplify arguments of crypt_convert_init
- remove parameter from kcryptd_io_read because it is always GFP_NOIO
- remove "cc" parameter from crypt_alloc_req because the value can be obtained
  from io->cc
- the rest of the patch just moves functions around without changing any logic

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |  181 +++++++++++++++++++++----------------------------
 1 file changed, 76 insertions(+), 105 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9740774..097171b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -44,7 +44,6 @@ struct dm_crypt_io {
 	struct bio *base_bio;
 	struct work_struct work;
 
-	struct bio *bio_in;
 	struct bio *bio_out;
 	unsigned int offset_in;
 	unsigned int offset_out;
@@ -561,7 +560,7 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 	u8 *src;
 	int r = 0;
 
-	if (bio_data_dir(dmreq->io->bio_in) == WRITE) {
+	if (bio_data_dir(dmreq->io->base_bio) == WRITE) {
 		src = kmap_atomic(sg_page(&dmreq->sg_in));
 		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
 		kunmap_atomic(src);
@@ -577,7 +576,7 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 	u8 *dst;
 	int r;
 
-	if (bio_data_dir(dmreq->io->bio_in) == WRITE)
+	if (bio_data_dir(dmreq->io->base_bio) == WRITE)
 		return 0;
 
 	dst = kmap_atomic(sg_page(&dmreq->sg_out));
@@ -626,18 +625,15 @@ static struct crypt_iv_operations crypt_iv_lmk_ops = {
 	.post	   = crypt_iv_lmk_post
 };
 
-static void crypt_convert_init(struct crypt_config *cc,
-			       struct dm_crypt_io *io,
-			       struct bio *bio_out, struct bio *bio_in,
-			       sector_t sector)
+static void crypt_convert_init(struct dm_crypt_io *io, struct bio *bio_out)
 {
-	io->bio_in = bio_in;
+	struct crypt_config *cc = io->cc;
 	io->bio_out = bio_out;
 	io->offset_in = 0;
 	io->offset_out = 0;
-	io->idx_in = bio_in ? bio_in->bi_idx : 0;
-	io->idx_out = bio_out ? bio_out->bi_idx : 0;
-	io->cc_sector = sector + cc->iv_offset;
+	io->idx_in = io->base_bio->bi_idx;
+	io->idx_out = bio_out->bi_idx;
+	io->cc_sector = io->sector + cc->iv_offset;
 }
 
 static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
@@ -716,7 +712,7 @@ pop_from_list:
 			int r;
 			DECLARE_COMPLETION(busy_wait);
 			dmreq->busy_wait = &busy_wait;
-			if (bio_data_dir(dmreq->io->bio_in) == WRITE)
+			if (bio_data_dir(dmreq->io->base_bio) == WRITE)
 				r = crypto_ablkcipher_encrypt(req);
 			else
 				r = crypto_ablkcipher_decrypt(req);
@@ -732,12 +728,53 @@ pop_from_list:
 	return 0;
 }
 
-static int crypt_convert_block(struct crypt_config *cc,
-			       struct dm_crypt_io *io,
+static struct ablkcipher_request *crypt_alloc_req(struct dm_crypt_io *io,
+						  gfp_t gfp_mask)
+{
+	struct crypt_config *cc = io->cc;
+	unsigned key_index = io->cc_sector & (cc->tfms_count - 1);
+	struct ablkcipher_request *req = mempool_alloc(cc->req_pool, gfp_mask);
+	if (!req)
+		return NULL;
+
+	ablkcipher_request_set_tfm(req, cc->tfms[key_index]);
+	ablkcipher_request_set_callback(req,
+	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+	    kcryptd_async_done, dmreq_of_req(cc, req));
+
+	return req;
+}
+
+static void crypt_flush_batch(struct crypt_config *cc, struct list_head *batch)
+{
+	spin_lock_irq(&cc->crypt_thread_wait.lock);
+	list_splice_tail(batch, &cc->crypt_thread_list);
+	wake_up_locked(&cc->crypt_thread_wait);
+	spin_unlock_irq(&cc->crypt_thread_wait.lock);
+	INIT_LIST_HEAD(batch);
+
+}
+
+static void crypt_end_io(struct dm_crypt_io *io);
+static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io);
+
+static void crypt_dec_cc_pending(struct dm_crypt_io *io)
+{
+	if (!atomic_dec_and_test(&io->cc_pending))
+		return;
+
+	if (bio_data_dir(io->base_bio) == READ)
+		crypt_end_io(io);
+	else
+		kcryptd_crypt_write_io_submit(io);
+}
+
+static int crypt_convert_block(struct dm_crypt_io *io,
 			       struct ablkcipher_request *req,
 			       struct list_head *batch)
 {
-	struct bio_vec *bv_in = bio_iovec_idx(io->bio_in, io->idx_in);
+	struct crypt_config *cc = io->cc;
+	struct bio_vec *bv_in = bio_iovec_idx(io->base_bio, io->idx_in);
 	struct bio_vec *bv_out = bio_iovec_idx(io->bio_out, io->idx_out);
 	struct dm_crypt_request *dmreq;
 	u8 *iv;
@@ -782,51 +819,12 @@ static int crypt_convert_block(struct crypt_config *cc,
 	return 0;
 }
 
-static struct ablkcipher_request *crypt_alloc_req(struct crypt_config *cc,
-			    struct dm_crypt_io *io, gfp_t gfp_mask)
-{
-	unsigned key_index = io->cc_sector & (cc->tfms_count - 1);
-	struct ablkcipher_request *req = mempool_alloc(cc->req_pool, gfp_mask);
-	if (!req)
-		return NULL;
-
-	ablkcipher_request_set_tfm(req, cc->tfms[key_index]);
-	ablkcipher_request_set_callback(req,
-	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-	    kcryptd_async_done, dmreq_of_req(cc, req));
-
-	return req;
-}
-
-static void crypt_flush_batch(struct crypt_config *cc, struct list_head *batch)
-{
-	spin_lock_irq(&cc->crypt_thread_wait.lock);
-	list_splice_tail(batch, &cc->crypt_thread_list);
-	wake_up_locked(&cc->crypt_thread_wait);
-	spin_unlock_irq(&cc->crypt_thread_wait.lock);
-	INIT_LIST_HEAD(batch);
-}
-
-static void crypt_end_io(struct dm_crypt_io *io);
-static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async);
-
-static void crypt_dec_cc_pending(struct dm_crypt_io *io)
-{
-	if (!atomic_dec_and_test(&io->cc_pending))
-		return;
-
-	if (bio_data_dir(io->base_bio) == READ)
-		crypt_end_io(io);
-	else
-		kcryptd_crypt_write_io_submit(io, 1);
-}
-
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
-static void crypt_convert(struct crypt_config *cc,
-			  struct dm_crypt_io *io)
+static void crypt_convert(struct dm_crypt_io *io)
 {
+	struct crypt_config *cc = io->cc;
 	LIST_HEAD(batch);
 	unsigned batch_count = 0;
 
@@ -834,7 +832,7 @@ static void crypt_convert(struct crypt_config *cc,
 
 	while (1) {
 		int r;
-		struct ablkcipher_request *req = crypt_alloc_req(cc, io, GFP_NOWAIT);
+		struct ablkcipher_request *req = crypt_alloc_req(io, GFP_NOWAIT);
 		if (!req) {
 			/*
 			 * We must flush our request queue before we attempt
@@ -842,10 +840,10 @@ static void crypt_convert(struct crypt_config *cc,
 			 */
 			batch_count = 0;
 			crypt_flush_batch(cc, &batch);
-			req = crypt_alloc_req(cc, io, GFP_NOIO);
+			req = crypt_alloc_req(io, GFP_NOIO);
 		}
 
-		r = crypt_convert_block(cc, io, req, &batch);
+		r = crypt_convert_block(io, req, &batch);
 		if (unlikely(r < 0)) {
 			crypt_flush_batch(cc, &batch);
 			io->error = -EIO;
@@ -855,7 +853,7 @@ static void crypt_convert(struct crypt_config *cc,
 
 		io->sector++;
 
-		if (io->idx_in < io->bio_in->bi_vcnt &&
+		if (io->idx_in < io->base_bio->bi_vcnt &&
 		    io->idx_out < io->bio_out->bi_vcnt) {
 			atomic_inc(&io->cc_pending);
 			if (unlikely(++batch_count >= DMREQ_PUSH_BATCH)) {
@@ -1042,7 +1040,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
-static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
+static int kcryptd_io_read(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
@@ -1053,7 +1051,7 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	 * copy the required bvecs because we need the original
 	 * one in order to decrypt the whole bio data *afterwards*.
 	 */
-	clone = bio_alloc_bioset(gfp, bio_segments(base_bio), cc->bs);
+	clone = bio_alloc_bioset(GFP_NOIO, bio_segments(base_bio), cc->bs);
 	if (!clone)
 		return 1;
 
@@ -1069,31 +1067,11 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	return 0;
 }
 
-static void kcryptd_io_write(struct dm_crypt_io *io)
-{
-	struct bio *clone = io->bio_out;
-	generic_make_request(clone);
-}
-
-static void kcryptd_io(struct work_struct *work)
+static void kcryptd_io_write(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
-
-	kcryptd_io_write(io);
-}
-
-static void kcryptd_queue_io(struct dm_crypt_io *io)
-{
 	struct crypt_config *cc = io->cc;
-
-	INIT_WORK(&io->work, kcryptd_io);
-	queue_work(cc->io_queue, &io->work);
-}
-
-static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
-{
 	struct bio *clone = io->bio_out;
-	struct crypt_config *cc = io->cc;
 
 	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
@@ -1107,45 +1085,38 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 
 	clone->bi_sector = cc->start + io->sector;
 
-	if (async)
-		kcryptd_queue_io(io);
-	else
-		generic_make_request(clone);
+	generic_make_request(clone);
 }
 
-static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
+static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
-	struct bio *clone;
-	unsigned remaining = io->base_bio->bi_size;
-	sector_t sector = io->sector;
 
-	crypt_convert_init(cc, io, NULL, io->base_bio, sector);
+	INIT_WORK(&io->work, kcryptd_io_write);
+	queue_work(cc->io_queue, &io->work);
+}
+
+static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
+{
+	struct bio *clone;
 
-	clone = crypt_alloc_buffer(io, remaining);
+	clone = crypt_alloc_buffer(io, io->base_bio->bi_size);
 	if (unlikely(!clone)) {
 		io->error = -ENOMEM;
 		crypt_end_io(io);
 		return;
 	}
 
-	io->bio_out = clone;
-	io->idx_out = 0;
+	crypt_convert_init(io, clone);
 
-	remaining -= clone->bi_size;
-	sector += bio_sectors(clone);
-
-	crypt_convert(cc, io);
+	crypt_convert(io);
 }
 
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
-	struct crypt_config *cc = io->cc;
-
-	crypt_convert_init(cc, io, io->base_bio, io->base_bio,
-			   io->sector);
+	crypt_convert_init(io, io->base_bio);
 
-	crypt_convert(cc, io);
+	crypt_convert(io);
 }
 
 static void kcryptd_async_done(struct crypto_async_request *async_req,
@@ -1734,7 +1705,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ) {
-		kcryptd_io_read(io, GFP_NOIO);
+		kcryptd_io_read(io);
 	} else {
 		kcryptd_crypt_write_convert(io);
 	}
-- 
1.7.10.4
