From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/2] md/dm-crypt - switch to AES library for
	EBOIV
Date: Tue,  6 Aug 2019 11:02:34 +0300
Message-ID: <20190806080234.27998-3-ard.biesheuvel@linaro.org>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, snitzer@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, ebiggers@kernel.org, dm-devel@redhat.com, gmazyland@gmail.com, agk@redhat.com
List-Id: dm-devel.ids

The EBOIV IV mode reuses the same AES encryption key that is used for
encrypting the data, and uses it to perform a single block encryption
of the byte offset to produce the IV.

Since table-based AES is known to be susceptible to known-plaintext
attacks on the key, and given that the same key is used to encrypt
the byte offset (which is known to an attacker), we should be
careful not to permit arbitrary instantiations where the allocated
AES cipher is provided by aes-generic or other table-based drivers
that are known to be time variant and thus susceptible to this kind
of attack.

Instead, let's switch to the new AES library, which has a D-cache
footprint that is only 1/32th of the generic AES driver, and which
contains some mitigations to reduce the timing variance even further.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 33 ++++++--------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a5e8d5bc1581..4650ab4b9415 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
+#include <crypto/aes.h>
 #include <crypto/hash.h>
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
@@ -121,7 +122,7 @@ struct iv_tcw_private {
 };
 
 struct iv_eboiv_private {
-	struct crypto_cipher *tfm;
+	struct crypto_aes_ctx aes_ctx;
 };
 
 /*
@@ -851,16 +852,12 @@ static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
 {
 	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
 
-	crypto_free_cipher(eboiv->tfm);
-	eboiv->tfm = NULL;
+	memset(eboiv, 0, sizeof(*eboiv));
 }
 
 static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			    const char *opts)
 {
-	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
-	struct crypto_cipher *tfm;
-
 	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags) ||
 	    strcmp("cbc(aes)",
 	           crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc))))) {
@@ -868,20 +865,6 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
-	if (IS_ERR(tfm)) {
-		ti->error = "Error allocating crypto tfm for EBOIV";
-		return PTR_ERR(tfm);
-	}
-
-	if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
-		ti->error = "Block size of EBOIV cipher does "
-			    "not match IV size of block cipher";
-		crypto_free_cipher(tfm);
-		return -EINVAL;
-	}
-
-	eboiv->tfm = tfm;
 	return 0;
 }
 
@@ -890,7 +873,7 @@ static int crypt_iv_eboiv_init(struct crypt_config *cc)
 	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
 	int err;
 
-	err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
+	err = aes_expandkey(&eboiv->aes_ctx, cc->key, cc->key_size);
 	if (err)
 		return err;
 
@@ -899,8 +882,10 @@ static int crypt_iv_eboiv_init(struct crypt_config *cc)
 
 static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
 {
-	/* Called after cc->key is set to random key in crypt_wipe() */
-	return crypt_iv_eboiv_init(cc);
+	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
+
+	memset(eboiv, 0, sizeof(*eboiv));
+	return 0;
 }
 
 static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
@@ -910,7 +895,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 
 	memset(iv, 0, cc->iv_size);
 	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
-	crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
+	aes_encrypt(&eboiv->aes_ctx, iv, iv);
 
 	return 0;
 }
-- 
2.17.1
