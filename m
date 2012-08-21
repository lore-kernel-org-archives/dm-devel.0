From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 17/20] dm-crypt: move temporary values to stack
Date: Tue, 21 Aug 2012 11:09:28 +0200
Message-ID: <b9f602d5471f59ac660956e68e6c20d5a4b7d8c7.1345477953.git.mbroz@redhat.com>
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

Structure dm_crypt_io contains some values that are used only temporarily.
Move these values to a structure dm_crypt_position that is allocated on stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   89 +++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 097171b..9316630 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -45,11 +45,6 @@ struct dm_crypt_io {
 	struct work_struct work;
 
 	struct bio *bio_out;
-	unsigned int offset_in;
-	unsigned int offset_out;
-	unsigned int idx_in;
-	unsigned int idx_out;
-	sector_t cc_sector;
 	atomic_t cc_pending;
 
 	int error;
@@ -625,17 +620,6 @@ static struct crypt_iv_operations crypt_iv_lmk_ops = {
 	.post	   = crypt_iv_lmk_post
 };
 
-static void crypt_convert_init(struct dm_crypt_io *io, struct bio *bio_out)
-{
-	struct crypt_config *cc = io->cc;
-	io->bio_out = bio_out;
-	io->offset_in = 0;
-	io->offset_out = 0;
-	io->idx_in = io->base_bio->bi_idx;
-	io->idx_out = bio_out->bi_idx;
-	io->cc_sector = io->sector + cc->iv_offset;
-}
-
 static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
 					     struct ablkcipher_request *req)
 {
@@ -728,11 +712,20 @@ pop_from_list:
 	return 0;
 }
 
+struct dm_crypt_position {
+	unsigned int offset_in;
+	unsigned int offset_out;
+	unsigned int idx_in;
+	unsigned int idx_out;
+	sector_t cc_sector;
+};
+
 static struct ablkcipher_request *crypt_alloc_req(struct dm_crypt_io *io,
+						  struct dm_crypt_position *pos,
 						  gfp_t gfp_mask)
 {
 	struct crypt_config *cc = io->cc;
-	unsigned key_index = io->cc_sector & (cc->tfms_count - 1);
+	unsigned key_index = pos->cc_sector & (cc->tfms_count - 1);
 	struct ablkcipher_request *req = mempool_alloc(cc->req_pool, gfp_mask);
 	if (!req)
 		return NULL;
@@ -771,11 +764,12 @@ static void crypt_dec_cc_pending(struct dm_crypt_io *io)
 
 static int crypt_convert_block(struct dm_crypt_io *io,
 			       struct ablkcipher_request *req,
+			       struct dm_crypt_position *pos,
 			       struct list_head *batch)
 {
 	struct crypt_config *cc = io->cc;
-	struct bio_vec *bv_in = bio_iovec_idx(io->base_bio, io->idx_in);
-	struct bio_vec *bv_out = bio_iovec_idx(io->bio_out, io->idx_out);
+	struct bio_vec *bv_in = bio_iovec_idx(io->base_bio, pos->idx_in);
+	struct bio_vec *bv_out = bio_iovec_idx(io->bio_out, pos->idx_out);
 	struct dm_crypt_request *dmreq;
 	u8 *iv;
 	int r;
@@ -783,26 +777,26 @@ static int crypt_convert_block(struct dm_crypt_io *io,
 	dmreq = dmreq_of_req(cc, req);
 	iv = iv_of_dmreq(cc, dmreq);
 
-	dmreq->iv_sector = io->cc_sector;
+	dmreq->iv_sector = pos->cc_sector;
 	dmreq->io = io;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
-		    bv_in->bv_offset + io->offset_in);
+		    bv_in->bv_offset + pos->offset_in);
 
 	sg_init_table(&dmreq->sg_out, 1);
 	sg_set_page(&dmreq->sg_out, bv_out->bv_page, 1 << SECTOR_SHIFT,
-		    bv_out->bv_offset + io->offset_out);
+		    bv_out->bv_offset + pos->offset_out);
 
-	io->offset_in += 1 << SECTOR_SHIFT;
-	if (io->offset_in >= bv_in->bv_len) {
-		io->offset_in = 0;
-		io->idx_in++;
+	pos->offset_in += 1 << SECTOR_SHIFT;
+	if (pos->offset_in >= bv_in->bv_len) {
+		pos->offset_in = 0;
+		pos->idx_in++;
 	}
 
-	io->offset_out += 1 << SECTOR_SHIFT;
-	if (io->offset_out >= bv_out->bv_len) {
-		io->offset_out = 0;
-		io->idx_out++;
+	pos->offset_out += 1 << SECTOR_SHIFT;
+	if (pos->offset_out >= bv_out->bv_len) {
+		pos->offset_out = 0;
+		pos->idx_out++;
 	}
 
 	if (cc->iv_gen_ops) {
@@ -822,17 +816,25 @@ static int crypt_convert_block(struct dm_crypt_io *io,
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
-static void crypt_convert(struct dm_crypt_io *io)
+static void crypt_convert(struct dm_crypt_io *io, struct bio *bio_out)
 {
 	struct crypt_config *cc = io->cc;
 	LIST_HEAD(batch);
 	unsigned batch_count = 0;
+	struct dm_crypt_position pos;
+
+	io->bio_out = bio_out;
+	pos.offset_in = 0;
+	pos.offset_out = 0;
+	pos.idx_in = io->base_bio->bi_idx;
+	pos.idx_out = bio_out->bi_idx;
+	pos.cc_sector = io->sector + cc->iv_offset;
 
 	atomic_set(&io->cc_pending, 1);
 
 	while (1) {
 		int r;
-		struct ablkcipher_request *req = crypt_alloc_req(io, GFP_NOWAIT);
+		struct ablkcipher_request *req = crypt_alloc_req(io, &pos, GFP_NOWAIT);
 		if (!req) {
 			/*
 			 * We must flush our request queue before we attempt
@@ -840,10 +842,10 @@ static void crypt_convert(struct dm_crypt_io *io)
 			 */
 			batch_count = 0;
 			crypt_flush_batch(cc, &batch);
-			req = crypt_alloc_req(io, GFP_NOIO);
+			req = crypt_alloc_req(io, &pos, GFP_NOIO);
 		}
 
-		r = crypt_convert_block(io, req, &batch);
+		r = crypt_convert_block(io, req, &pos, &batch);
 		if (unlikely(r < 0)) {
 			crypt_flush_batch(cc, &batch);
 			io->error = -EIO;
@@ -851,10 +853,10 @@ static void crypt_convert(struct dm_crypt_io *io)
 			return;
 		}
 
-		io->sector++;
-
-		if (io->idx_in < io->base_bio->bi_vcnt &&
-		    io->idx_out < io->bio_out->bi_vcnt) {
+		pos.cc_sector++;
+ 
+		if (pos.idx_in < io->base_bio->bi_vcnt &&
+		    pos.idx_out < io->bio_out->bi_vcnt) {
 			atomic_inc(&io->cc_pending);
 			if (unlikely(++batch_count >= DMREQ_PUSH_BATCH)) {
 				batch_count = 0;
@@ -1080,9 +1082,6 @@ static void kcryptd_io_write(struct work_struct *work)
 		return;
 	}
 
-	/* crypt_convert should have filled the clone bio */
-	BUG_ON(io->idx_out < clone->bi_vcnt);
-
 	clone->bi_sector = cc->start + io->sector;
 
 	generic_make_request(clone);
@@ -1107,16 +1106,12 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		return;
 	}
 
-	crypt_convert_init(io, clone);
-
-	crypt_convert(io);
+	crypt_convert(io, clone);
 }
 
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
-	crypt_convert_init(io, io->base_bio);
-
-	crypt_convert(io);
+	crypt_convert(io, io->base_bio);
 }
 
 static void kcryptd_async_done(struct crypto_async_request *async_req,
-- 
1.7.10.4
