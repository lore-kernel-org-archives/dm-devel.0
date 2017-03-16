From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 5/7] dm-crypt: Parse cipher specification
	according to AEAD flag.
Date: Thu, 16 Mar 2017 15:39:42 +0100
Message-ID: <20170316143944.19843-6-gmazyland@gmail.com>
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

This patch siplifies allocation of HMAC composed mode by parsing
the new cipher format directly.

For native AEAD mode (like GCM), we can use crypto_tfm_alg_name() API
to get the cipher specification, for HMAC composed mode we need
to parse crypto API string to get cipher mode nested in specification.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 49 +++++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 48e8dfe91c53..3a4bf5791a3b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -873,12 +873,12 @@ static bool crypt_integrity_aead(struct crypt_config *cc)
 
 static bool crypt_integrity_hmac(struct crypt_config *cc)
 {
-	return test_bit(CRYPT_MODE_INTEGRITY_HMAC, &cc->cipher_flags);
+	return crypt_integrity_aead(cc) && cc->key_mac_size;
 }
 
 static bool crypt_integrity_mode(struct crypt_config *cc)
 {
-	return crypt_integrity_aead(cc) || crypt_integrity_hmac(cc);
+	return crypt_integrity_aead(cc);
 }
 
 /* Get sg containing data */
@@ -1879,27 +1879,12 @@ static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
 
 static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 {
-	char *authenc = NULL;
 	int err;
 
 	cc->cipher_tfm.tfms = kmalloc(sizeof(struct crypto_aead *), GFP_KERNEL);
 	if (!cc->cipher_tfm.tfms)
 		return -ENOMEM;
 
-	/* Compose AEAD cipher with autenc(authenticator,cipher) structure */
-	if (crypt_integrity_hmac(cc)) {
-		authenc = kmalloc(CRYPTO_MAX_ALG_NAME, GFP_KERNEL);
-		if (!authenc)
-			return -ENOMEM;
-		err = snprintf(authenc, CRYPTO_MAX_ALG_NAME,
-		       "authenc(%s,%s)", cc->cipher_auth, ciphermode);
-		if (err < 0) {
-			kzfree(authenc);
-			return err;
-		}
-		ciphermode = authenc;
-	}
-
 	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0, 0);
 	if (IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
 		err = PTR_ERR(cc->cipher_tfm.tfms_aead[0]);
@@ -1907,7 +1892,6 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 		return err;
 	}
 
-	kzfree(authenc);
 	return 0;
 }
 
@@ -1964,13 +1948,13 @@ static int crypt_setkey(struct crypt_config *cc)
 				      subkey_size - cc->key_mac_size,
 				      cc->key_mac_size);
 	for (i = 0; i < cc->tfms_count; i++) {
-		if (crypt_integrity_aead(cc))
-			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
-						   cc->key + (i * subkey_size),
-						   subkey_size);
-		else if (crypt_integrity_hmac(cc))
+		if (crypt_integrity_hmac(cc))
 			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
 				cc->authenc_key, crypt_authenckey_size(cc));
+		else if (crypt_integrity_aead(cc))
+			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
+						cc->key + (i * subkey_size),
+						subkey_size);
 		else
 			r = crypto_skcipher_setkey(cc->cipher_tfm.tfms[i],
 						   cc->key + (i * subkey_size),
@@ -2205,14 +2189,6 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 	else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
-	if (crypt_integrity_hmac(cc)) {
-		cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
-		if (!cc->authenc_key) {
-			ti->error = "Error allocating authenc key space";
-			return -ENOMEM;
-		}
-	}
-
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
@@ -2270,9 +2246,18 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
  */
 static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
 {
-	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)));
+	const char *alg_name = NULL;
 	char *start, *end;
 
+	if (crypt_integrity_aead(cc)) {
+		if (!(alg_name = crypto_tfm_alg_name(crypto_aead_tfm(any_tfm_aead(cc)))))
+			return -EINVAL;
+		if (crypt_integrity_hmac(cc) && !(alg_name = strchr(alg_name, ',')))
+			return -EINVAL;
+		alg_name++;
+	} else if (!(alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)))))
+		return -EINVAL;
+
 	start = strchr(alg_name, '(');
 	end = strchr(alg_name, ')');
 
-- 
2.11.0
