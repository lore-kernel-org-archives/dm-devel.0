From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 12/20] dm-crypt: simplify cc_pending
Date: Tue, 21 Aug 2012 11:09:23 +0200
Message-ID: <b74d12e390333de8f33b67d983af0fda09c7a001.1345477953.git.mbroz@redhat.com>
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

This patch removes one extra cc_pending reference from crypt_convert.
Now, cc_pending represents real number of pending operations.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   61 +++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 36bc19c..36c9087 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -815,6 +815,20 @@ static void crypt_flush_batch(struct crypt_config *cc, struct list_head *batch)
 	INIT_LIST_HEAD(batch);
 }
 
+static void crypt_dec_pending(struct dm_crypt_io *io);
+static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async);
+
+static void crypt_dec_cc_pending(struct dm_crypt_io *io)
+{
+	if (!atomic_dec_and_test(&io->ctx.cc_pending))
+		return;
+
+	if (bio_data_dir(io->base_bio) == READ)
+		crypt_dec_pending(io);
+	else
+		kcryptd_crypt_write_io_submit(io, 1);
+}
+
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
@@ -827,9 +841,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 	atomic_set(&ctx->cc_pending, 1);
 
-	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
-	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
-
+	while (1) {
 		struct ablkcipher_request *req = crypt_alloc_req(cc, ctx, GFP_NOWAIT);
 		if (!req) {
 			/*
@@ -841,25 +853,30 @@ static int crypt_convert(struct crypt_config *cc,
 			req = crypt_alloc_req(cc, ctx, GFP_NOIO);
 		}
 
-		atomic_inc(&ctx->cc_pending);
-
 		r = crypt_convert_block(cc, ctx, req, &batch);
 		if (unlikely(r < 0)) {
-			atomic_dec(&ctx->cc_pending);
-			goto flush_ret;
+			crypt_flush_batch(cc, &batch);
+			crypt_dec_cc_pending(container_of(ctx, struct dm_crypt_io, ctx));
+			goto ret;
 		}
 
 		ctx->sector++;
 
-		if (unlikely(++batch_count >= DMREQ_PUSH_BATCH)) {
-			batch_count = 0;
-			crypt_flush_batch(cc, &batch);
+		if (ctx->idx_in < ctx->bio_in->bi_vcnt &&
+		    ctx->idx_out < ctx->bio_out->bi_vcnt) {
+			atomic_inc(&ctx->cc_pending);
+			if (unlikely(++batch_count >= DMREQ_PUSH_BATCH)) {
+				batch_count = 0;
+				crypt_flush_batch(cc, &batch);
+			}
+			continue;
 		}
+		break;
 	}
 	r = 0;
 
-flush_ret:
 	crypt_flush_batch(cc, &batch);
+ret:
 
 	return r;
 }
@@ -1122,7 +1139,6 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
-	int crypt_finished;
 	unsigned remaining = io->base_bio->bi_size;
 	sector_t sector = io->sector;
 	int r;
@@ -1149,20 +1165,10 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	r = crypt_convert(cc, &io->ctx);
 	if (r)
 		io->error = -EIO;
-	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
-
-	/* Encryption was already finished, submit io now */
-	if (crypt_finished)
-		kcryptd_crypt_write_io_submit(io, 0);
 dec:
 	crypt_dec_pending(io);
 }
 
-static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
-{
-	crypt_dec_pending(io);
-}
-
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -1177,9 +1183,6 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	if (r < 0)
 		io->error = -EIO;
 
-	if (atomic_dec_and_test(&io->ctx.cc_pending))
-		kcryptd_crypt_read_done(io);
-
 	crypt_dec_pending(io);
 }
 
@@ -1204,13 +1207,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 
 	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
-	if (!atomic_dec_and_test(&ctx->cc_pending))
-		return;
-
-	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_crypt_read_done(io);
-	else
-		kcryptd_crypt_write_io_submit(io, 1);
+	crypt_dec_cc_pending(io);
 }
 
 static void kcryptd_crypt(struct work_struct *work)
-- 
1.7.10.4
