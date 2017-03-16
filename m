From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 6/7] dm-crypt: Remove obsolete integrity_mode
	function.
Date: Thu, 16 Mar 2017 15:39:43 +0100
Message-ID: <20170316143944.19843-7-gmazyland@gmail.com>
References: <20170316143944.19843-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170316143944.19843-1-gmazyland@gmail.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

The HMAC composed mode is not processed the same as the normal AEAD
mode, so this patch removes no longer needed flag and "hmac"
specification for the table integrity argument.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3a4bf5791a3b..270adba14717 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -129,7 +129,6 @@ enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
 
 enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
-	CRYPT_MODE_INTEGRITY_HMAC,	/* Compose authenticated mode from normal mode and HMAC */
 };
 
 /*
@@ -876,16 +875,11 @@ static bool crypt_integrity_hmac(struct crypt_config *cc)
 	return crypt_integrity_aead(cc) && cc->key_mac_size;
 }
 
-static bool crypt_integrity_mode(struct crypt_config *cc)
-{
-	return crypt_integrity_aead(cc);
-}
-
 /* Get sg containing data */
 static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
 					     struct scatterlist *sg)
 {
-	if (unlikely(crypt_integrity_mode(cc)))
+	if (unlikely(crypt_integrity_aead(cc)))
 		return &sg[2];
 
 	return sg;
@@ -936,7 +930,7 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 		return -EINVAL;
 	}
 
-	if (crypt_integrity_mode(cc)) {
+	if (crypt_integrity_aead(cc)) {
 		cc->integrity_tag_size = cc->on_disk_tag_size - cc->integrity_iv_size;
 		DMINFO("Integrity AEAD, tag size %u, IV size %u.",
 		       cc->integrity_tag_size, cc->integrity_iv_size);
@@ -990,7 +984,7 @@ static void *req_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmre
 static u8 *iv_of_dmreq(struct crypt_config *cc,
 		       struct dm_crypt_request *dmreq)
 {
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		return (u8 *)ALIGN((unsigned long)(dmreq + 1),
 			crypto_aead_alignmask(any_tfm_aead(cc)) + 1);
 	else
@@ -1235,7 +1229,7 @@ static void crypt_alloc_req_aead(struct crypt_config *cc,
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		crypt_alloc_req_aead(cc, ctx);
 	else
 		crypt_alloc_req_skcipher(cc, ctx);
@@ -1261,7 +1255,7 @@ static void crypt_free_req_aead(struct crypt_config *cc,
 
 static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_bio)
 {
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		crypt_free_req_aead(cc, req, base_bio);
 	else
 		crypt_free_req_skcipher(cc, req, base_bio);
@@ -1284,7 +1278,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
-		if (crypt_integrity_mode(cc))
+		if (crypt_integrity_aead(cc))
 			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
 		else
 			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, tag_offset);
@@ -1849,7 +1843,7 @@ static void crypt_free_tfms_skcipher(struct crypt_config *cc)
 
 static void crypt_free_tfms(struct crypt_config *cc)
 {
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		crypt_free_tfms_aead(cc);
 	else
 		crypt_free_tfms_skcipher(cc);
@@ -1897,7 +1891,7 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 
 static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 {
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		return crypt_alloc_tfms_aead(cc, ciphermode);
 	else
 		return crypt_alloc_tfms_skcipher(cc, ciphermode);
@@ -2184,7 +2178,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 {
 	struct crypt_config *cc = ti->private;
 
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
 	else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
@@ -2376,7 +2370,7 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 	int ret = -EINVAL;
 	char dummy;
 
-	if (strchr(cipher_in, '(')) {
+	if (strchr(cipher_in, '(') || crypt_integrity_aead(cc)) {
 		ti->error = "Bad cipher specification";
 		return -EINVAL;
 	}
@@ -2543,15 +2537,6 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 			}
 			if (!strcasecmp(sval, "aead")) {
 				set_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags);
-			} else  if (!strncasecmp(sval, "hmac(", strlen("hmac("))) {
-				struct crypto_ahash *hmac_tfm = crypto_alloc_ahash(sval, 0, 0);
-				if (IS_ERR(hmac_tfm)) {
-					ti->error = "Error initializing HMAC integrity hash.";
-					return PTR_ERR(hmac_tfm);
-				}
-				cc->key_mac_size = crypto_ahash_digestsize(hmac_tfm);
-				crypto_free_ahash(hmac_tfm);
-				set_bit(CRYPT_MODE_INTEGRITY_HMAC, &cc->cipher_flags);
 			} else  if (strcasecmp(sval, "none")) {
 				ti->error = "Unknown integrity profile";
 				return -EINVAL;
@@ -2614,7 +2599,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (ret < 0)
 		goto bad;
 
-	if (crypt_integrity_mode(cc)) {
+	if (crypt_integrity_aead(cc)) {
 		cc->dmreq_start = sizeof(struct aead_request);
 		cc->dmreq_start += crypto_aead_reqsize(any_tfm_aead(cc));
 		align_mask = crypto_aead_alignmask(any_tfm_aead(cc));
@@ -2691,7 +2676,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->start = tmpll;
 
-	if (crypt_integrity_mode(cc) || cc->integrity_iv_size) {
+	if (crypt_integrity_aead(cc) || cc->integrity_iv_size) {
 		ret = crypt_integrity_ctr(cc, ti);
 		if (ret)
 			goto bad;
@@ -2789,7 +2774,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 		}
 	}
 
-	if (crypt_integrity_mode(cc))
+	if (crypt_integrity_aead(cc))
 		io->ctx.r.req_aead = (struct aead_request *)(io + 1);
 	else
 		io->ctx.r.req = (struct skcipher_request *)(io + 1);
-- 
2.11.0
