From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/6] dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY
Date: Tue, 30 Jun 2020 21:52:17 -0700
Message-ID: <20200701045217.121126-7-ebiggers@kernel.org>
References: <20200701045217.121126-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Don't use crypto drivers that have the flag CRYPTO_ALG_ALLOCATES_MEMORY
set. These drivers allocate memory and thus they are unsuitable for block
I/O processing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 000ddfab5ba0..7268faacbdf3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -421,7 +421,8 @@ static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
+	lmk->hash_tfm = crypto_alloc_shash("md5", 0,
+					   CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(lmk->hash_tfm)) {
 		ti->error = "Error initializing LMK hash";
 		return PTR_ERR(lmk->hash_tfm);
@@ -583,7 +584,8 @@ static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
+	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0,
+					    CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(tcw->crc32_tfm)) {
 		ti->error = "Error initializing CRC32 in TCW";
 		return PTR_ERR(tcw->crc32_tfm);
@@ -770,7 +772,8 @@ static int crypt_iv_elephant_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 	int r;
 
-	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0,
+					      CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(elephant->tfm)) {
 		r = PTR_ERR(elephant->tfm);
 		elephant->tfm = NULL;
@@ -2090,7 +2093,8 @@ static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
 		return -ENOMEM;
 
 	for (i = 0; i < cc->tfms_count; i++) {
-		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
+		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0,
+						CRYPTO_ALG_ALLOCATES_MEMORY);
 		if (IS_ERR(cc->cipher_tfm.tfms[i])) {
 			err = PTR_ERR(cc->cipher_tfm.tfms[i]);
 			crypt_free_tfms(cc);
@@ -2116,7 +2120,8 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
 	if (!cc->cipher_tfm.tfms)
 		return -ENOMEM;
 
-	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0, 0);
+	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0,
+						CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
 		err = PTR_ERR(cc->cipher_tfm.tfms_aead[0]);
 		crypt_free_tfms(cc);
@@ -2603,7 +2608,7 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 		return -ENOMEM;
 	strncpy(mac_alg, start, end - start);
 
-	mac = crypto_alloc_ahash(mac_alg, 0, 0);
+	mac = crypto_alloc_ahash(mac_alg, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	kfree(mac_alg);
 
 	if (IS_ERR(mac))
-- 
2.27.0
