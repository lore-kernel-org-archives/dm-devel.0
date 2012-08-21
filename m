From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 01/20] dm-crypt: remove per-cpu structure
Date: Tue, 21 Aug 2012 11:09:12 +0200
Message-ID: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
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

Remove per-cpu structure and make it per-convert_context instead.
This allows moving requests between different cpus.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   61 ++++++++++---------------------------------------
 1 file changed, 12 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 664743d..7a3e8eb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -18,7 +18,6 @@
 #include <linux/crypto.h>
 #include <linux/workqueue.h>
 #include <linux/backing-dev.h>
-#include <linux/percpu.h>
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
@@ -44,6 +43,7 @@ struct convert_context {
 	unsigned int idx_out;
 	sector_t cc_sector;
 	atomic_t cc_pending;
+	struct ablkcipher_request *req;
 };
 
 /*
@@ -105,15 +105,7 @@ struct iv_lmk_private {
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
 
 /*
- * Duplicated per-CPU state for cipher.
- */
-struct crypt_cpu {
-	struct ablkcipher_request *req;
-};
-
-/*
- * The fields in here must be read only after initialization,
- * changing state should be in crypt_cpu.
+ * The fields in here must be read only after initialization.
  */
 struct crypt_config {
 	struct dm_dev *dev;
@@ -143,12 +135,6 @@ struct crypt_config {
 	sector_t iv_offset;
 	unsigned int iv_size;
 
-	/*
-	 * Duplicated per cpu state. Access through
-	 * per_cpu_ptr() only.
-	 */
-	struct crypt_cpu __percpu *cpu;
-
 	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
 	struct crypto_ablkcipher **tfms;
@@ -184,11 +170,6 @@ static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
 
-static struct crypt_cpu *this_crypt_config(struct crypt_config *cc)
-{
-	return this_cpu_ptr(cc->cpu);
-}
-
 /*
  * Use this to access cipher attributes that are the same for each CPU.
  */
@@ -738,16 +719,15 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
-	struct crypt_cpu *this_cc = this_crypt_config(cc);
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
 
-	if (!this_cc->req)
-		this_cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
+	if (!ctx->req)
+		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
-	ablkcipher_request_set_tfm(this_cc->req, cc->tfms[key_index]);
-	ablkcipher_request_set_callback(this_cc->req,
+	ablkcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
+	ablkcipher_request_set_callback(ctx->req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-	    kcryptd_async_done, dmreq_of_req(cc, this_cc->req));
+	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
 }
 
 /*
@@ -756,7 +736,6 @@ static void crypt_alloc_req(struct crypt_config *cc,
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
-	struct crypt_cpu *this_cc = this_crypt_config(cc);
 	int r;
 
 	atomic_set(&ctx->cc_pending, 1);
@@ -768,7 +747,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
-		r = crypt_convert_block(cc, ctx, this_cc->req);
+		r = crypt_convert_block(cc, ctx, ctx->req);
 
 		switch (r) {
 		/* async */
@@ -777,7 +756,7 @@ static int crypt_convert(struct crypt_config *cc,
 			INIT_COMPLETION(ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
-			this_cc->req = NULL;
+			ctx->req = NULL;
 			ctx->cc_sector++;
 			continue;
 
@@ -885,6 +864,7 @@ static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
 	io->sector = sector;
 	io->error = 0;
 	io->base_io = NULL;
+	io->ctx.req = NULL;
 	atomic_set(&io->io_pending, 0);
 
 	return io;
@@ -910,6 +890,8 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
+	if (io->ctx.req)
+		mempool_free(io->ctx.req, cc->req_pool);
 	mempool_free(io, cc->io_pool);
 
 	if (likely(!base_io))
@@ -1355,8 +1337,6 @@ static int crypt_wipe_key(struct crypt_config *cc)
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = ti->private;
-	struct crypt_cpu *cpu_cc;
-	int cpu;
 
 	ti->private = NULL;
 
@@ -1368,13 +1348,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
-	if (cc->cpu)
-		for_each_possible_cpu(cpu) {
-			cpu_cc = per_cpu_ptr(cc->cpu, cpu);
-			if (cpu_cc->req)
-				mempool_free(cpu_cc->req, cc->req_pool);
-		}
-
 	crypt_free_tfms(cc);
 
 	if (cc->bs)
@@ -1393,9 +1366,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	if (cc->cpu)
-		free_percpu(cc->cpu);
-
 	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
 
@@ -1450,13 +1420,6 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (tmp)
 		DMWARN("Ignoring unexpected additional cipher options");
 
-	cc->cpu = __alloc_percpu(sizeof(*(cc->cpu)),
-				 __alignof__(struct crypt_cpu));
-	if (!cc->cpu) {
-		ti->error = "Cannot allocate per cpu state";
-		goto bad_mem;
-	}
-
 	/*
 	 * For compatibility with the original dm-crypt mapping format, if
 	 * only the cipher name is supplied, use cbc-plain.
-- 
1.7.10.4
