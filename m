From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/7] dm-crypt: Move IV constructor to separate
	function.
Date: Thu, 16 Mar 2017 15:39:39 +0100
Message-ID: <20170316143944.19843-3-gmazyland@gmail.com>
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

No functional change in this patch, just preparation for next patches.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 130 +++++++++++++++++++++++++++-----------------------
 1 file changed, 69 insertions(+), 61 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9ec6d50603f6..faec408dcf50 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2196,6 +2196,73 @@ static void crypt_dtr(struct dm_target *ti)
 	kzfree(cc);
 }
 
+static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
+{
+	struct crypt_config *cc = ti->private;
+
+	if (crypt_integrity_mode(cc))
+		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
+	else
+		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+
+	if (crypt_integrity_hmac(cc)) {
+		cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
+		if (!cc->authenc_key) {
+			ti->error = "Error allocating authenc key space";
+			return -ENOMEM;
+		}
+	}
+
+	if (cc->iv_size)
+		/* at least a 64 bit sector number should fit in our buffer */
+		cc->iv_size = max(cc->iv_size,
+				  (unsigned int)(sizeof(u64) / sizeof(u8)));
+	else if (ivmode) {
+		DMWARN("Selected cipher does not support IVs");
+		ivmode = NULL;
+	}
+
+	/* Choose ivmode, see comments at iv code. */
+	if (ivmode == NULL)
+		cc->iv_gen_ops = NULL;
+	else if (strcmp(ivmode, "plain") == 0)
+		cc->iv_gen_ops = &crypt_iv_plain_ops;
+	else if (strcmp(ivmode, "plain64") == 0)
+		cc->iv_gen_ops = &crypt_iv_plain64_ops;
+	else if (strcmp(ivmode, "essiv") == 0)
+		cc->iv_gen_ops = &crypt_iv_essiv_ops;
+	else if (strcmp(ivmode, "benbi") == 0)
+		cc->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ivmode, "null") == 0)
+		cc->iv_gen_ops = &crypt_iv_null_ops;
+	else if (strcmp(ivmode, "lmk") == 0) {
+		cc->iv_gen_ops = &crypt_iv_lmk_ops;
+		/*
+		 * Version 2 and 3 is recognised according
+		 * to length of provided multi-key string.
+		 * If present (version 3), last key is used as IV seed.
+		 * All keys (including IV seed) are always the same size.
+		 */
+		if (cc->key_size % cc->key_parts) {
+			cc->key_parts++;
+			cc->key_extra_size = cc->key_size / cc->key_parts;
+		}
+	} else if (strcmp(ivmode, "tcw") == 0) {
+		cc->iv_gen_ops = &crypt_iv_tcw_ops;
+		cc->key_parts += 2; /* IV + whitening */
+		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
+	} else if (strcmp(ivmode, "random") == 0) {
+		cc->iv_gen_ops = &crypt_iv_random_ops;
+		/* Need storage space in integrity fields. */
+		cc->integrity_iv_size = cc->iv_size;
+	} else {
+		ti->error = "Invalid IV mode";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int crypt_ctr_cipher(struct dm_target *ti,
 			    char *cipher_in, char *key)
 {
@@ -2205,7 +2272,6 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	int ret = -EINVAL;
 	char dummy;
 
-	/* Convert to crypto api definition? */
 	if (strchr(cipher_in, '(')) {
 		ti->error = "Bad cipher specification";
 		return -EINVAL;
@@ -2276,67 +2342,9 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	}
 
 	/* Initialize IV */
-	if (crypt_integrity_mode(cc))
-		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
-	else
-		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
-
-	if (crypt_integrity_hmac(cc)) {
-		cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
-		if (!cc->authenc_key) {
-			ret = -ENOMEM;
-			ti->error = "Error allocating authenc key space";
-			goto bad;
-		}
-	}
-
-	if (cc->iv_size)
-		/* at least a 64 bit sector number should fit in our buffer */
-		cc->iv_size = max(cc->iv_size,
-				  (unsigned int)(sizeof(u64) / sizeof(u8)));
-	else if (ivmode) {
-		DMWARN("Selected cipher does not support IVs");
-		ivmode = NULL;
-	}
-
-	/* Choose ivmode, see comments at iv code. */
-	if (ivmode == NULL)
-		cc->iv_gen_ops = NULL;
-	else if (strcmp(ivmode, "plain") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain_ops;
-	else if (strcmp(ivmode, "plain64") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain64_ops;
-	else if (strcmp(ivmode, "essiv") == 0)
-		cc->iv_gen_ops = &crypt_iv_essiv_ops;
-	else if (strcmp(ivmode, "benbi") == 0)
-		cc->iv_gen_ops = &crypt_iv_benbi_ops;
-	else if (strcmp(ivmode, "null") == 0)
-		cc->iv_gen_ops = &crypt_iv_null_ops;
-	else if (strcmp(ivmode, "lmk") == 0) {
-		cc->iv_gen_ops = &crypt_iv_lmk_ops;
-		/*
-		 * Version 2 and 3 is recognised according
-		 * to length of provided multi-key string.
-		 * If present (version 3), last key is used as IV seed.
-		 * All keys (including IV seed) are always the same size.
-		 */
-		if (cc->key_size % cc->key_parts) {
-			cc->key_parts++;
-			cc->key_extra_size = cc->key_size / cc->key_parts;
-		}
-	} else if (strcmp(ivmode, "tcw") == 0) {
-		cc->iv_gen_ops = &crypt_iv_tcw_ops;
-		cc->key_parts += 2; /* IV + whitening */
-		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
-	} else if (strcmp(ivmode, "random") == 0) {
-		cc->iv_gen_ops = &crypt_iv_random_ops;
-		/* Need storage space in integrity fields. */
-		cc->integrity_iv_size = cc->iv_size;
-	} else {
-		ret = -EINVAL;
-		ti->error = "Invalid IV mode";
+	ret = crypt_ctr_ivmode(ti, ivmode);
+	if (ret < 0)
 		goto bad;
-	}
 
 	/* Initialize and set key */
 	ret = crypt_set_key(cc, key);
-- 
2.11.0
