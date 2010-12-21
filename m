From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 5/7] dm crypt: redefine IV generator function and
	add post IV call
Date: Tue, 21 Dec 2010 16:28:17 +0100
Message-ID: <3f1f72e99321e472c29d3b8bb47f03b5a5468358.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

IV (initialisation vector) can in principle depend not only
on sector but also on plaintext data (or other attributes).

Change IV generator interface to work directly with dmreq
structure to allow such dependence in generator.

Also add post() function which is called after the crypto
operation.

This allows tricky modification of decrypted data or IV
internals. (If not suitable directly in crypto API.)

In asynchronous mode the post() can be called after
ctx->sector count was increased so it is needed
to add iv_sector copy directly to dmreq structure.
(N.B. dmreq always include only one sector in scatterlists)

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   48 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 863e412..451a743 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -64,6 +64,7 @@ struct dm_crypt_request {
 	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
+	sector_t iv_sector;
 };
 
 struct crypt_config;
@@ -74,7 +75,10 @@ struct crypt_iv_operations {
 	void (*dtr)(struct crypt_config *cc);
 	int (*init)(struct crypt_config *cc);
 	int (*wipe)(struct crypt_config *cc);
-	int (*generator)(struct crypt_config *cc, u8 *iv, sector_t sector);
+	int (*generator)(struct crypt_config *cc, u8 *iv,
+			 struct dm_crypt_request *dmreq);
+	int (*post)(struct crypt_config *cc, u8 *iv,
+		    struct dm_crypt_request *dmreq);
 };
 
 struct iv_essiv_private {
@@ -166,6 +170,7 @@ static struct kmem_cache *_crypt_io_pool;
 
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
+static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
 
 static struct crypt_cpu *crypt_me(struct crypt_config *cc)
 {
@@ -204,19 +209,20 @@ static struct crypto_ablkcipher *any_tfm(struct crypt_config *cc)
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
 
-static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
+			      struct dm_crypt_request *dmreq)
 {
 	memset(iv, 0, cc->iv_size);
-	*(u32 *)iv = cpu_to_le32(sector & 0xffffffff);
+	*(u32 *)iv = cpu_to_le32(dmreq->iv_sector & 0xffffffff);
 
 	return 0;
 }
 
 static int crypt_iv_plain64_gen(struct crypt_config *cc, u8 *iv,
-				sector_t sector)
+				struct dm_crypt_request *dmreq)
 {
 	memset(iv, 0, cc->iv_size);
-	*(u64 *)iv = cpu_to_le64(sector);
+	*(u64 *)iv = cpu_to_le64(dmreq->iv_sector);
 
 	return 0;
 }
@@ -379,12 +385,13 @@ bad:
 	return err;
 }
 
-static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
+			      struct dm_crypt_request *dmreq)
 {
 	struct crypto_cipher *essiv_tfm = crypt_me(cc)->iv_private;
 
 	memset(iv, 0, cc->iv_size);
-	*(u64 *)iv = cpu_to_le64(sector);
+	*(u64 *)iv = cpu_to_le64(dmreq->iv_sector);
 	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
 	return 0;
 }
@@ -417,19 +424,21 @@ static void crypt_iv_benbi_dtr(struct crypt_config *cc)
 {
 }
 
-static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv,
+			      struct dm_crypt_request *dmreq)
 {
 	__be64 val;
 
 	memset(iv, 0, cc->iv_size - sizeof(u64)); /* rest is cleared below */
 
-	val = cpu_to_be64(((u64)sector << cc->iv_gen_private.benbi.shift) + 1);
+	val = cpu_to_be64(((u64)dmreq->iv_sector << cc->iv_gen_private.benbi.shift) + 1);
 	put_unaligned(val, (__be64 *)(iv + cc->iv_size - sizeof(u64)));
 
 	return 0;
 }
 
-static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
+			     struct dm_crypt_request *dmreq)
 {
 	memset(iv, 0, cc->iv_size);
 
@@ -489,6 +498,13 @@ static struct ablkcipher_request *req_of_dmreq(struct crypt_config *cc,
 	return (struct ablkcipher_request *)((char *)dmreq - cc->dmreq_start);
 }
 
+static u8 *iv_of_dmreq(struct crypt_config *cc,
+		       struct dm_crypt_request *dmreq)
+{
+	return (u8 *)ALIGN((unsigned long)(dmreq + 1),
+		crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct ablkcipher_request *req)
@@ -500,9 +516,9 @@ static int crypt_convert_block(struct crypt_config *cc,
 	int r = 0;
 
 	dmreq = dmreq_of_req(cc, req);
-	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
-			 crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
+	iv = iv_of_dmreq(cc, dmreq);
 
+	dmreq->iv_sector = ctx->sector;
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
 	sg_set_page(&dmreq->sg_in, bv_in->bv_page, 1 << SECTOR_SHIFT,
@@ -525,7 +541,7 @@ static int crypt_convert_block(struct crypt_config *cc,
 	}
 
 	if (cc->iv_gen_ops) {
-		r = cc->iv_gen_ops->generator(cc, iv, ctx->sector);
+		r = cc->iv_gen_ops->generator(cc, iv, dmreq);
 		if (r < 0)
 			return r;
 	}
@@ -538,6 +554,9 @@ static int crypt_convert_block(struct crypt_config *cc,
 	else
 		r = crypto_ablkcipher_decrypt(req);
 
+	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
+		r = cc->iv_gen_ops->post(cc, iv, dmreq);
+
 	return r;
 }
 
@@ -1003,6 +1022,9 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		return;
 	}
 
+	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
+		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
+
 	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
-- 
1.7.2.3
