From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH 5/5] dm-crypt: modify dm-crypt to rely on IV generation templates
Date: Wed, 18 Jul 2018 15:30:55 +0800
Message-ID: <1531899055-29362-6-git-send-email-wangxiongfeng2@huawei.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, broonie@kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids

This patch remove the IV generation algorithms from dm-crypt.c and rely
on the IV generation templates for generating IV. We modify the dm-layer
to send a whole 'bio' (as defined in the block layer) at a time. Each bio
contains an in memory representation of physically contiguous disk
blocks. The dm layer sets up a chained scatterlist of these blocks split
into physically contiguous segments in memory so that DMA can be
performed.

This patch is based on the patchset originally started by
Binoy Jayan <binoy.jayan@linaro.org>
( crypto: Add IV generation algorithms
https://patchwork.kernel.org/patch/9803469/ )

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@linaro.org>
---
 drivers/md/Kconfig    |    1 +
 drivers/md/dm-crypt.c | 1697 ++++++++++---------------------------------------
 2 files changed, 345 insertions(+), 1353 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 8b8c123..51a3451 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -281,6 +281,7 @@ config DM_CRYPT
 	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_CBC
+	select CRYPTO_GENIV
 	---help---
 	  This device-mapper target allows you to create a device that
 	  transparently encrypts the data on it. You'll need to activate
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b61b069..3761a43 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -33,13 +33,20 @@
 #include <crypto/skcipher.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
+#include <crypto/geniv.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
 #include <keys/user-type.h>
-
 #include <linux/device-mapper.h>
+#include <linux/backing-dev.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "crypt"
 
+struct geniv_ctx;
+struct geniv_req_ctx;
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -55,7 +62,6 @@ struct convert_context {
 		struct skcipher_request *req;
 		struct aead_request *req_aead;
 	} r;
-
 };
 
 /*
@@ -79,47 +85,13 @@ struct dm_crypt_io {
 
 struct dm_crypt_request {
 	struct convert_context *ctx;
-	struct scatterlist sg_in[4];
-	struct scatterlist sg_out[4];
+	struct scatterlist *sg_in;
+	struct scatterlist *sg_out;
 	sector_t iv_sector;
 };
 
 struct crypt_config;
 
-struct crypt_iv_operations {
-	int (*ctr)(struct crypt_config *cc, struct dm_target *ti,
-		   const char *opts);
-	void (*dtr)(struct crypt_config *cc);
-	int (*init)(struct crypt_config *cc);
-	int (*wipe)(struct crypt_config *cc);
-	int (*generator)(struct crypt_config *cc, u8 *iv,
-			 struct dm_crypt_request *dmreq);
-	int (*post)(struct crypt_config *cc, u8 *iv,
-		    struct dm_crypt_request *dmreq);
-};
-
-struct iv_essiv_private {
-	struct crypto_ahash *hash_tfm;
-	u8 *salt;
-};
-
-struct iv_benbi_private {
-	int shift;
-};
-
-#define LMK_SEED_SIZE 64 /* hash + 0 */
-struct iv_lmk_private {
-	struct crypto_shash *hash_tfm;
-	u8 *seed;
-};
-
-#define TCW_WHITENING_SIZE 16
-struct iv_tcw_private {
-	struct crypto_shash *crc32_tfm;
-	u8 *iv_seed;
-	u8 *whitening;
-};
-
 /*
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
@@ -127,11 +99,6 @@ struct iv_tcw_private {
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
 	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
 
-enum cipher_flags {
-	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
-	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
-};
-
 /*
  * The fields in here must be read only after initialization.
  */
@@ -148,18 +115,10 @@ struct crypt_config {
 	struct task_struct *write_thread;
 	struct rb_root write_tree;
 
-	char *cipher;
 	char *cipher_string;
 	char *cipher_auth;
 	char *key_string;
 
-	const struct crypt_iv_operations *iv_gen_ops;
-	union {
-		struct iv_essiv_private essiv;
-		struct iv_benbi_private benbi;
-		struct iv_lmk_private lmk;
-		struct iv_tcw_private tcw;
-	} iv_gen_private;
 	sector_t iv_offset;
 	unsigned int iv_size;
 	unsigned short int sector_size;
@@ -168,10 +127,10 @@ struct crypt_config {
 	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
 	union {
-		struct crypto_skcipher **tfms;
-		struct crypto_aead **tfms_aead;
+		struct crypto_skcipher *tfm;
+		struct crypto_aead *tfm_aead;
 	} cipher_tfm;
-	unsigned tfms_count;
+	unsigned int tfms_count;
 	unsigned long cipher_flags;
 
 	/*
@@ -213,13 +172,16 @@ struct crypt_config {
 	struct bio_set bs;
 	struct mutex bio_alloc_lock;
 
-	u8 *authenc_key; /* space for keys in authenc() format (if used) */
 	u8 key[0];
 };
 
-#define MIN_IOS		64
-#define MAX_TAG_SIZE	480
-#define POOL_ENTRY_SIZE	512
+#define MAX_SG_LIST     (BIO_MAX_PAGES * 8)
+#define MIN_IOS         64
+#define MAX_TAG_SIZE    480
+#define POOL_ENTRY_SIZE 512
+
+static void clone_init(struct dm_crypt_io *, struct bio *);
+static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 
 static DEFINE_SPINLOCK(dm_crypt_clients_lock);
 static unsigned dm_crypt_clients_n = 0;
@@ -229,677 +191,21 @@ struct crypt_config {
 
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
-static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
-					     struct scatterlist *sg);
 
 /*
  * Use this to access cipher attributes that are independent of the key.
  */
 static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
 {
-	return cc->cipher_tfm.tfms[0];
+	return cc->cipher_tfm.tfm;
 }
 
 static struct crypto_aead *any_tfm_aead(struct crypt_config *cc)
 {
-	return cc->cipher_tfm.tfms_aead[0];
+	return cc->cipher_tfm.tfm_aead;
 }
 
 /*
- * Different IV generation algorithms:
- *
- * plain: the initial vector is the 32-bit little-endian version of the sector
- *        number, padded with zeros if necessary.
- *
- * plain64: the initial vector is the 64-bit little-endian version of the sector
- *        number, padded with zeros if necessary.
- *
- * plain64be: the initial vector is the 64-bit big-endian version of the sector
- *        number, padded with zeros if necessary.
- *
- * essiv: "encrypted sector|salt initial vector", the sector number is
- *        encrypted with the bulk cipher using a salt as key. The salt
- *        should be derived from the bulk cipher's key via hashing.
- *
- * benbi: the 64-bit "big-endian 'narrow block'-count", starting at 1
- *        (needed for LRW-32-AES and possible other narrow block modes)
- *
- * null: the initial vector is always zero.  Provides compatibility with
- *       obsolete loop_fish2 devices.  Do not use for new devices.
- *
- * lmk:  Compatible implementation of the block chaining mode used
- *       by the Loop-AES block device encryption system
- *       designed by Jari Ruusu. See http://loop-aes.sourceforge.net/
- *       It operates on full 512 byte sectors and uses CBC
- *       with an IV derived from the sector number, the data and
- *       optionally extra IV seed.
- *       This means that after decryption the first block
- *       of sector must be tweaked according to decrypted data.
- *       Loop-AES can use three encryption schemes:
- *         version 1: is plain aes-cbc mode
- *         version 2: uses 64 multikey scheme with lmk IV generator
- *         version 3: the same as version 2 with additional IV seed
- *                   (it uses 65 keys, last key is used as IV seed)
- *
- * tcw:  Compatible implementation of the block chaining mode used
- *       by the TrueCrypt device encryption system (prior to version 4.1).
- *       For more info see: https://gitlab.com/cryptsetup/cryptsetup/wikis/TrueCryptOnDiskFormat
- *       It operates on full 512 byte sectors and uses CBC
- *       with an IV derived from initial key and the sector number.
- *       In addition, whitening value is applied on every sector, whitening
- *       is calculated from initial key, sector number and mixed using CRC32.
- *       Note that this encryption scheme is vulnerable to watermarking attacks
- *       and should be used for old compatible containers access only.
- *
- * plumb: unimplemented, see:
- * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
- */
-
-static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-	*(__le32 *)iv = cpu_to_le32(dmreq->iv_sector & 0xffffffff);
-
-	return 0;
-}
-
-static int crypt_iv_plain64_gen(struct crypt_config *cc, u8 *iv,
-				struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
-
-	return 0;
-}
-
-static int crypt_iv_plain64be_gen(struct crypt_config *cc, u8 *iv,
-				  struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-	/* iv_size is at least of size u64; usually it is 16 bytes */
-	*(__be64 *)&iv[cc->iv_size - sizeof(u64)] = cpu_to_be64(dmreq->iv_sector);
-
-	return 0;
-}
-
-/* Initialise ESSIV - compute salt but no local memory allocations */
-static int crypt_iv_essiv_init(struct crypt_config *cc)
-{
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
-	struct scatterlist sg;
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	sg_init_one(&sg, cc->key, cc->key_size);
-	ahash_request_set_tfm(req, essiv->hash_tfm);
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-	ahash_request_set_crypt(req, &sg, essiv->salt, cc->key_size);
-
-	err = crypto_ahash_digest(req);
-	ahash_request_zero(req);
-	if (err)
-		return err;
-
-	essiv_tfm = cc->iv_private;
-
-	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
-			    crypto_ahash_digestsize(essiv->hash_tfm));
-	if (err)
-		return err;
-
-	return 0;
-}
-
-/* Wipe salt and reset key derived from volume key */
-static int crypt_iv_essiv_wipe(struct crypt_config *cc)
-{
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	unsigned salt_size = crypto_ahash_digestsize(essiv->hash_tfm);
-	struct crypto_cipher *essiv_tfm;
-	int r, err = 0;
-
-	memset(essiv->salt, 0, salt_size);
-
-	essiv_tfm = cc->iv_private;
-	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
-	if (r)
-		err = r;
-
-	return err;
-}
-
-/* Allocate the cipher for ESSIV */
-static struct crypto_cipher *alloc_essiv_cipher(struct crypt_config *cc,
-						struct dm_target *ti,
-						const u8 *salt,
-						unsigned int saltsize)
-{
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	/* Setup the essiv_tfm with the given salt */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(essiv_tfm)) {
-		ti->error = "Error allocating crypto tfm for ESSIV";
-		return essiv_tfm;
-	}
-
-	if (crypto_cipher_blocksize(essiv_tfm) != cc->iv_size) {
-		ti->error = "Block size of ESSIV cipher does "
-			    "not match IV size of block cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
-	if (err) {
-		ti->error = "Failed to set key for ESSIV cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(err);
-	}
-
-	return essiv_tfm;
-}
-
-static void crypt_iv_essiv_dtr(struct crypt_config *cc)
-{
-	struct crypto_cipher *essiv_tfm;
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-
-	crypto_free_ahash(essiv->hash_tfm);
-	essiv->hash_tfm = NULL;
-
-	kzfree(essiv->salt);
-	essiv->salt = NULL;
-
-	essiv_tfm = cc->iv_private;
-
-	if (essiv_tfm)
-		crypto_free_cipher(essiv_tfm);
-
-	cc->iv_private = NULL;
-}
-
-static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
-{
-	struct crypto_cipher *essiv_tfm = NULL;
-	struct crypto_ahash *hash_tfm = NULL;
-	u8 *salt = NULL;
-	int err;
-
-	if (!opts) {
-		ti->error = "Digest algorithm missing for ESSIV mode";
-		return -EINVAL;
-	}
-
-	/* Allocate hash algorithm */
-	hash_tfm = crypto_alloc_ahash(opts, 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hash_tfm)) {
-		ti->error = "Error initializing ESSIV hash";
-		err = PTR_ERR(hash_tfm);
-		goto bad;
-	}
-
-	salt = kzalloc(crypto_ahash_digestsize(hash_tfm), GFP_KERNEL);
-	if (!salt) {
-		ti->error = "Error kmallocing salt storage in ESSIV";
-		err = -ENOMEM;
-		goto bad;
-	}
-
-	cc->iv_gen_private.essiv.salt = salt;
-	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
-
-	essiv_tfm = alloc_essiv_cipher(cc, ti, salt,
-				       crypto_ahash_digestsize(hash_tfm));
-	if (IS_ERR(essiv_tfm)) {
-		crypt_iv_essiv_dtr(cc);
-		return PTR_ERR(essiv_tfm);
-	}
-	cc->iv_private = essiv_tfm;
-
-	return 0;
-
-bad:
-	if (hash_tfm && !IS_ERR(hash_tfm))
-		crypto_free_ahash(hash_tfm);
-	kfree(salt);
-	return err;
-}
-
-static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
-{
-	struct crypto_cipher *essiv_tfm = cc->iv_private;
-
-	memset(iv, 0, cc->iv_size);
-	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
-	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
-
-	return 0;
-}
-
-static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
-{
-	unsigned bs = crypto_skcipher_blocksize(any_tfm(cc));
-	int log = ilog2(bs);
-
-	/* we need to calculate how far we must shift the sector count
-	 * to get the cipher block count, we use this shift in _gen */
-
-	if (1 << log != bs) {
-		ti->error = "cypher blocksize is not a power of 2";
-		return -EINVAL;
-	}
-
-	if (log > 9) {
-		ti->error = "cypher blocksize is > 512";
-		return -EINVAL;
-	}
-
-	cc->iv_gen_private.benbi.shift = 9 - log;
-
-	return 0;
-}
-
-static void crypt_iv_benbi_dtr(struct crypt_config *cc)
-{
-}
-
-static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv,
-			      struct dm_crypt_request *dmreq)
-{
-	__be64 val;
-
-	memset(iv, 0, cc->iv_size - sizeof(u64)); /* rest is cleared below */
-
-	val = cpu_to_be64(((u64)dmreq->iv_sector << cc->iv_gen_private.benbi.shift) + 1);
-	put_unaligned(val, (__be64 *)(iv + cc->iv_size - sizeof(u64)));
-
-	return 0;
-}
-
-static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	memset(iv, 0, cc->iv_size);
-
-	return 0;
-}
-
-static void crypt_iv_lmk_dtr(struct crypt_config *cc)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-
-	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
-		crypto_free_shash(lmk->hash_tfm);
-	lmk->hash_tfm = NULL;
-
-	kzfree(lmk->seed);
-	lmk->seed = NULL;
-}
-
-static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-
-	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
-		ti->error = "Unsupported sector size for LMK";
-		return -EINVAL;
-	}
-
-	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
-	if (IS_ERR(lmk->hash_tfm)) {
-		ti->error = "Error initializing LMK hash";
-		return PTR_ERR(lmk->hash_tfm);
-	}
-
-	/* No seed in LMK version 2 */
-	if (cc->key_parts == cc->tfms_count) {
-		lmk->seed = NULL;
-		return 0;
-	}
-
-	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
-	if (!lmk->seed) {
-		crypt_iv_lmk_dtr(cc);
-		ti->error = "Error kmallocing seed storage in LMK";
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int crypt_iv_lmk_init(struct crypt_config *cc)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-	int subkey_size = cc->key_size / cc->key_parts;
-
-	/* LMK seed is on the position of LMK_KEYS + 1 key */
-	if (lmk->seed)
-		memcpy(lmk->seed, cc->key + (cc->tfms_count * subkey_size),
-		       crypto_shash_digestsize(lmk->hash_tfm));
-
-	return 0;
-}
-
-static int crypt_iv_lmk_wipe(struct crypt_config *cc)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-
-	if (lmk->seed)
-		memset(lmk->seed, 0, LMK_SEED_SIZE);
-
-	return 0;
-}
-
-static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq,
-			    u8 *data)
-{
-	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
-	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
-	struct md5_state md5state;
-	__le32 buf[4];
-	int i, r;
-
-	desc->tfm = lmk->hash_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	r = crypto_shash_init(desc);
-	if (r)
-		return r;
-
-	if (lmk->seed) {
-		r = crypto_shash_update(desc, lmk->seed, LMK_SEED_SIZE);
-		if (r)
-			return r;
-	}
-
-	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
-	r = crypto_shash_update(desc, data + 16, 16 * 31);
-	if (r)
-		return r;
-
-	/* Sector is cropped to 56 bits here */
-	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
-	buf[1] = cpu_to_le32((((u64)dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
-	buf[2] = cpu_to_le32(4024);
-	buf[3] = 0;
-	r = crypto_shash_update(desc, (u8 *)buf, sizeof(buf));
-	if (r)
-		return r;
-
-	/* No MD5 padding here */
-	r = crypto_shash_export(desc, &md5state);
-	if (r)
-		return r;
-
-	for (i = 0; i < MD5_HASH_WORDS; i++)
-		__cpu_to_le32s(&md5state.hash[i]);
-	memcpy(iv, &md5state.hash, cc->iv_size);
-
-	return 0;
-}
-
-static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
-{
-	struct scatterlist *sg;
-	u8 *src;
-	int r = 0;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
-		kunmap_atomic(src);
-	} else
-		memset(iv, 0, cc->iv_size);
-
-	return r;
-}
-
-static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	struct scatterlist *sg;
-	u8 *dst;
-	int r;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
-		return 0;
-
-	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
-
-	/* Tweak the first block of plaintext sector */
-	if (!r)
-		crypto_xor(dst + sg->offset, iv, cc->iv_size);
-
-	kunmap_atomic(dst);
-	return r;
-}
-
-static void crypt_iv_tcw_dtr(struct crypt_config *cc)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-
-	kzfree(tcw->iv_seed);
-	tcw->iv_seed = NULL;
-	kzfree(tcw->whitening);
-	tcw->whitening = NULL;
-
-	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
-		crypto_free_shash(tcw->crc32_tfm);
-	tcw->crc32_tfm = NULL;
-}
-
-static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-
-	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
-		ti->error = "Unsupported sector size for TCW";
-		return -EINVAL;
-	}
-
-	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
-		ti->error = "Wrong key size for TCW";
-		return -EINVAL;
-	}
-
-	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
-	if (IS_ERR(tcw->crc32_tfm)) {
-		ti->error = "Error initializing CRC32 in TCW";
-		return PTR_ERR(tcw->crc32_tfm);
-	}
-
-	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
-	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
-	if (!tcw->iv_seed || !tcw->whitening) {
-		crypt_iv_tcw_dtr(cc);
-		ti->error = "Error allocating seed storage in TCW";
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int crypt_iv_tcw_init(struct crypt_config *cc)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	int key_offset = cc->key_size - cc->iv_size - TCW_WHITENING_SIZE;
-
-	memcpy(tcw->iv_seed, &cc->key[key_offset], cc->iv_size);
-	memcpy(tcw->whitening, &cc->key[key_offset + cc->iv_size],
-	       TCW_WHITENING_SIZE);
-
-	return 0;
-}
-
-static int crypt_iv_tcw_wipe(struct crypt_config *cc)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-
-	memset(tcw->iv_seed, 0, cc->iv_size);
-	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
-
-	return 0;
-}
-
-static int crypt_iv_tcw_whitening(struct crypt_config *cc,
-				  struct dm_crypt_request *dmreq,
-				  u8 *data)
-{
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 buf[TCW_WHITENING_SIZE];
-	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
-	int i, r;
-
-	/* xor whitening with sector number */
-	crypto_xor_cpy(buf, tcw->whitening, (u8 *)&sector, 8);
-	crypto_xor_cpy(&buf[8], tcw->whitening + 8, (u8 *)&sector, 8);
-
-	/* calculate crc32 for every 32bit part and xor it */
-	desc->tfm = tcw->crc32_tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-	for (i = 0; i < 4; i++) {
-		r = crypto_shash_init(desc);
-		if (r)
-			goto out;
-		r = crypto_shash_update(desc, &buf[i * 4], 4);
-		if (r)
-			goto out;
-		r = crypto_shash_final(desc, &buf[i * 4]);
-		if (r)
-			goto out;
-	}
-	crypto_xor(&buf[0], &buf[12], 4);
-	crypto_xor(&buf[4], &buf[8], 4);
-
-	/* apply whitening (8 bytes) to whole sector */
-	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
-		crypto_xor(data + i * 8, buf, 8);
-out:
-	memzero_explicit(buf, sizeof(buf));
-	return r;
-}
-
-static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
-			    struct dm_crypt_request *dmreq)
-{
-	struct scatterlist *sg;
-	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 *src;
-	int r = 0;
-
-	/* Remove whitening from ciphertext */
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
-		kunmap_atomic(src);
-	}
-
-	/* Calculate IV */
-	crypto_xor_cpy(iv, tcw->iv_seed, (u8 *)&sector, 8);
-	if (cc->iv_size > 8)
-		crypto_xor_cpy(&iv[8], tcw->iv_seed + 8, (u8 *)&sector,
-			       cc->iv_size - 8);
-
-	return r;
-}
-
-static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
-			     struct dm_crypt_request *dmreq)
-{
-	struct scatterlist *sg;
-	u8 *dst;
-	int r;
-
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
-		return 0;
-
-	/* Apply whitening on ciphertext */
-	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
-	kunmap_atomic(dst);
-
-	return r;
-}
-
-static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
-				struct dm_crypt_request *dmreq)
-{
-	/* Used only for writes, there must be an additional space to store IV */
-	get_random_bytes(iv, cc->iv_size);
-	return 0;
-}
-
-static const struct crypt_iv_operations crypt_iv_plain_ops = {
-	.generator = crypt_iv_plain_gen
-};
-
-static const struct crypt_iv_operations crypt_iv_plain64_ops = {
-	.generator = crypt_iv_plain64_gen
-};
-
-static const struct crypt_iv_operations crypt_iv_plain64be_ops = {
-	.generator = crypt_iv_plain64be_gen
-};
-
-static const struct crypt_iv_operations crypt_iv_essiv_ops = {
-	.ctr       = crypt_iv_essiv_ctr,
-	.dtr       = crypt_iv_essiv_dtr,
-	.init      = crypt_iv_essiv_init,
-	.wipe      = crypt_iv_essiv_wipe,
-	.generator = crypt_iv_essiv_gen
-};
-
-static const struct crypt_iv_operations crypt_iv_benbi_ops = {
-	.ctr	   = crypt_iv_benbi_ctr,
-	.dtr	   = crypt_iv_benbi_dtr,
-	.generator = crypt_iv_benbi_gen
-};
-
-static const struct crypt_iv_operations crypt_iv_null_ops = {
-	.generator = crypt_iv_null_gen
-};
-
-static const struct crypt_iv_operations crypt_iv_lmk_ops = {
-	.ctr	   = crypt_iv_lmk_ctr,
-	.dtr	   = crypt_iv_lmk_dtr,
-	.init	   = crypt_iv_lmk_init,
-	.wipe	   = crypt_iv_lmk_wipe,
-	.generator = crypt_iv_lmk_gen,
-	.post	   = crypt_iv_lmk_post
-};
-
-static const struct crypt_iv_operations crypt_iv_tcw_ops = {
-	.ctr	   = crypt_iv_tcw_ctr,
-	.dtr	   = crypt_iv_tcw_dtr,
-	.init	   = crypt_iv_tcw_init,
-	.wipe	   = crypt_iv_tcw_wipe,
-	.generator = crypt_iv_tcw_gen,
-	.post	   = crypt_iv_tcw_post
-};
-
-static struct crypt_iv_operations crypt_iv_random_ops = {
-	.generator = crypt_iv_random_gen
-};
-
-/*
  * Integrity extensions
  */
 static bool crypt_integrity_aead(struct crypt_config *cc)
@@ -907,21 +213,6 @@ static bool crypt_integrity_aead(struct crypt_config *cc)
 	return test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags);
 }
 
-static bool crypt_integrity_hmac(struct crypt_config *cc)
-{
-	return crypt_integrity_aead(cc) && cc->key_mac_size;
-}
-
-/* Get sg containing data */
-static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
-					     struct scatterlist *sg)
-{
-	if (unlikely(crypt_integrity_aead(cc)))
-		return &sg[2];
-
-	return sg;
-}
-
 static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
 {
 	struct bio_integrity_payload *bip;
@@ -971,283 +262,66 @@ static int crypt_integrity_ctr(struct crypt_config *cc, struct dm_target *ti)
 
 	if (crypt_integrity_aead(cc)) {
 		cc->integrity_tag_size = cc->on_disk_tag_size - cc->integrity_iv_size;
-		DMINFO("Integrity AEAD, tag size %u, IV size %u.",
-		       cc->integrity_tag_size, cc->integrity_iv_size);
-
-		if (crypto_aead_setauthsize(any_tfm_aead(cc), cc->integrity_tag_size)) {
-			ti->error = "Integrity AEAD auth tag size is not supported.";
-			return -EINVAL;
-		}
-	} else if (cc->integrity_iv_size)
-		DMINFO("Additional per-sector space %u bytes for IV.",
-		       cc->integrity_iv_size);
-
-	if ((cc->integrity_tag_size + cc->integrity_iv_size) != bi->tag_size) {
-		ti->error = "Not enough space for integrity tag in the profile.";
-		return -EINVAL;
-	}
-
-	return 0;
-#else
-	ti->error = "Integrity profile not supported.";
-	return -EINVAL;
-#endif
-}
-
-static void crypt_convert_init(struct crypt_config *cc,
-			       struct convert_context *ctx,
-			       struct bio *bio_out, struct bio *bio_in,
-			       sector_t sector)
-{
-	ctx->bio_in = bio_in;
-	ctx->bio_out = bio_out;
-	if (bio_in)
-		ctx->iter_in = bio_in->bi_iter;
-	if (bio_out)
-		ctx->iter_out = bio_out->bi_iter;
-	ctx->cc_sector = sector + cc->iv_offset;
-	init_completion(&ctx->restart);
-}
-
-static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
-					     void *req)
-{
-	return (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
-}
-
-static void *req_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq)
-{
-	return (void *)((char *)dmreq - cc->dmreq_start);
-}
-
-static u8 *iv_of_dmreq(struct crypt_config *cc,
-		       struct dm_crypt_request *dmreq)
-{
-	if (crypt_integrity_aead(cc))
-		return (u8 *)ALIGN((unsigned long)(dmreq + 1),
-			crypto_aead_alignmask(any_tfm_aead(cc)) + 1);
-	else
-		return (u8 *)ALIGN((unsigned long)(dmreq + 1),
-			crypto_skcipher_alignmask(any_tfm(cc)) + 1);
-}
-
-static u8 *org_iv_of_dmreq(struct crypt_config *cc,
-		       struct dm_crypt_request *dmreq)
-{
-	return iv_of_dmreq(cc, dmreq) + cc->iv_size;
-}
-
-static uint64_t *org_sector_of_dmreq(struct crypt_config *cc,
-		       struct dm_crypt_request *dmreq)
-{
-	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size + cc->iv_size;
-	return (uint64_t*) ptr;
-}
-
-static unsigned int *org_tag_of_dmreq(struct crypt_config *cc,
-		       struct dm_crypt_request *dmreq)
-{
-	u8 *ptr = iv_of_dmreq(cc, dmreq) + cc->iv_size +
-		  cc->iv_size + sizeof(uint64_t);
-	return (unsigned int*)ptr;
-}
-
-static void *tag_from_dmreq(struct crypt_config *cc,
-				struct dm_crypt_request *dmreq)
-{
-	struct convert_context *ctx = dmreq->ctx;
-	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
-
-	return &io->integrity_metadata[*org_tag_of_dmreq(cc, dmreq) *
-		cc->on_disk_tag_size];
-}
-
-static void *iv_tag_from_dmreq(struct crypt_config *cc,
-			       struct dm_crypt_request *dmreq)
-{
-	return tag_from_dmreq(cc, dmreq) + cc->integrity_tag_size;
-}
-
-static int crypt_convert_block_aead(struct crypt_config *cc,
-				     struct convert_context *ctx,
-				     struct aead_request *req,
-				     unsigned int tag_offset)
-{
-	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
-	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
-	struct dm_crypt_request *dmreq;
-	u8 *iv, *org_iv, *tag_iv, *tag;
-	uint64_t *sector;
-	int r = 0;
-
-	BUG_ON(cc->integrity_iv_size && cc->integrity_iv_size != cc->iv_size);
-
-	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
-		return -EIO;
-
-	dmreq = dmreq_of_req(cc, req);
-	dmreq->iv_sector = ctx->cc_sector;
-	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
-		dmreq->iv_sector >>= cc->sector_shift;
-	dmreq->ctx = ctx;
-
-	*org_tag_of_dmreq(cc, dmreq) = tag_offset;
-
-	sector = org_sector_of_dmreq(cc, dmreq);
-	*sector = cpu_to_le64(ctx->cc_sector - cc->iv_offset);
-
-	iv = iv_of_dmreq(cc, dmreq);
-	org_iv = org_iv_of_dmreq(cc, dmreq);
-	tag = tag_from_dmreq(cc, dmreq);
-	tag_iv = iv_tag_from_dmreq(cc, dmreq);
-
-	/* AEAD request:
-	 *  |----- AAD -------|------ DATA -------|-- AUTH TAG --|
-	 *  | (authenticated) | (auth+encryption) |              |
-	 *  | sector_LE |  IV |  sector in/out    |  tag in/out  |
-	 */
-	sg_init_table(dmreq->sg_in, 4);
-	sg_set_buf(&dmreq->sg_in[0], sector, sizeof(uint64_t));
-	sg_set_buf(&dmreq->sg_in[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_in[2], bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
-	sg_set_buf(&dmreq->sg_in[3], tag, cc->integrity_tag_size);
-
-	sg_init_table(dmreq->sg_out, 4);
-	sg_set_buf(&dmreq->sg_out[0], sector, sizeof(uint64_t));
-	sg_set_buf(&dmreq->sg_out[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_out[2], bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
-	sg_set_buf(&dmreq->sg_out[3], tag, cc->integrity_tag_size);
-
-	if (cc->iv_gen_ops) {
-		/* For READs use IV stored in integrity metadata */
-		if (cc->integrity_iv_size && bio_data_dir(ctx->bio_in) != WRITE) {
-			memcpy(org_iv, tag_iv, cc->iv_size);
-		} else {
-			r = cc->iv_gen_ops->generator(cc, org_iv, dmreq);
-			if (r < 0)
-				return r;
-			/* Store generated IV in integrity metadata */
-			if (cc->integrity_iv_size)
-				memcpy(tag_iv, org_iv, cc->iv_size);
-		}
-		/* Working copy of IV, to be modified in crypto API */
-		memcpy(iv, org_iv, cc->iv_size);
-	}
-
-	aead_request_set_ad(req, sizeof(uint64_t) + cc->iv_size);
-	if (bio_data_dir(ctx->bio_in) == WRITE) {
-		aead_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
-				       cc->sector_size, iv);
-		r = crypto_aead_encrypt(req);
-		if (cc->integrity_tag_size + cc->integrity_iv_size != cc->on_disk_tag_size)
-			memset(tag + cc->integrity_tag_size + cc->integrity_iv_size, 0,
-			       cc->on_disk_tag_size - (cc->integrity_tag_size + cc->integrity_iv_size));
-	} else {
-		aead_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
-				       cc->sector_size + cc->integrity_tag_size, iv);
-		r = crypto_aead_decrypt(req);
-	}
-
-	if (r == -EBADMSG)
-		DMERR_LIMIT("INTEGRITY AEAD ERROR, sector %llu",
-			    (unsigned long long)le64_to_cpu(*sector));
-
-	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
-
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
-
-	return r;
-}
-
-static int crypt_convert_block_skcipher(struct crypt_config *cc,
-					struct convert_context *ctx,
-					struct skcipher_request *req,
-					unsigned int tag_offset)
-{
-	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
-	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
-	struct scatterlist *sg_in, *sg_out;
-	struct dm_crypt_request *dmreq;
-	u8 *iv, *org_iv, *tag_iv;
-	uint64_t *sector;
-	int r = 0;
-
-	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
-		return -EIO;
-
-	dmreq = dmreq_of_req(cc, req);
-	dmreq->iv_sector = ctx->cc_sector;
-	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
-		dmreq->iv_sector >>= cc->sector_shift;
-	dmreq->ctx = ctx;
-
-	*org_tag_of_dmreq(cc, dmreq) = tag_offset;
-
-	iv = iv_of_dmreq(cc, dmreq);
-	org_iv = org_iv_of_dmreq(cc, dmreq);
-	tag_iv = iv_tag_from_dmreq(cc, dmreq);
-
-	sector = org_sector_of_dmreq(cc, dmreq);
-	*sector = cpu_to_le64(ctx->cc_sector - cc->iv_offset);
-
-	/* For skcipher we use only the first sg item */
-	sg_in  = &dmreq->sg_in[0];
-	sg_out = &dmreq->sg_out[0];
-
-	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
-
-	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+		DMINFO("Integrity AEAD, tag size %u, IV size %u.",
+		       cc->integrity_tag_size, cc->integrity_iv_size);
 
-	if (cc->iv_gen_ops) {
-		/* For READs use IV stored in integrity metadata */
-		if (cc->integrity_iv_size && bio_data_dir(ctx->bio_in) != WRITE) {
-			memcpy(org_iv, tag_iv, cc->integrity_iv_size);
-		} else {
-			r = cc->iv_gen_ops->generator(cc, org_iv, dmreq);
-			if (r < 0)
-				return r;
-			/* Store generated IV in integrity metadata */
-			if (cc->integrity_iv_size)
-				memcpy(tag_iv, org_iv, cc->integrity_iv_size);
+		if (crypto_aead_setauthsize(any_tfm_aead(cc), cc->integrity_tag_size)) {
+			ti->error = "Integrity AEAD auth tag size is not supported.";
+			return -EINVAL;
 		}
-		/* Working copy of IV, to be modified in crypto API */
-		memcpy(iv, org_iv, cc->iv_size);
-	}
+	} else if (cc->integrity_iv_size)
+		DMINFO("Additional per-sector space %u bytes for IV.",
+		       cc->integrity_iv_size);
 
-	skcipher_request_set_crypt(req, sg_in, sg_out, cc->sector_size, iv);
+	if ((cc->integrity_tag_size + cc->integrity_iv_size) != bi->tag_size) {
+		ti->error = "Not enough space for integrity tag in the profile.";
+		return -EINVAL;
+	}
 
-	if (bio_data_dir(ctx->bio_in) == WRITE)
-		r = crypto_skcipher_encrypt(req);
-	else
-		r = crypto_skcipher_decrypt(req);
+	return 0;
+#else
+	ti->error = "Integrity profile not supported.";
+	return -EINVAL;
+#endif
+}
 
-	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
+static void crypt_convert_init(struct crypt_config *cc,
+			       struct convert_context *ctx,
+			       struct bio *bio_out, struct bio *bio_in,
+			       sector_t sector)
+{
+	ctx->bio_in = bio_in;
+	ctx->bio_out = bio_out;
+	if (bio_in)
+		ctx->iter_in = bio_in->bi_iter;
+	if (bio_out)
+		ctx->iter_out = bio_out->bi_iter;
+	ctx->cc_sector = sector + cc->iv_offset;
+	init_completion(&ctx->restart);
+}
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
+static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
+					     void *req)
+{
+	return (struct dm_crypt_request *)((char *)req + cc->dmreq_start);
+}
 
-	return r;
+static void *req_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq)
+{
+	return (void *)((char *)dmreq - cc->dmreq_start);
 }
 
+
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
 
 static void crypt_alloc_req_skcipher(struct crypt_config *cc,
 				     struct convert_context *ctx)
 {
-	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
-
 	if (!ctx->r.req)
 		ctx->r.req = mempool_alloc(&cc->req_pool, GFP_NOIO);
 
-	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
+	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfm);
 
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
@@ -1264,7 +338,7 @@ static void crypt_alloc_req_aead(struct crypt_config *cc,
 	if (!ctx->r.req_aead)
 		ctx->r.req_aead = mempool_alloc(&cc->req_pool, GFP_NOIO);
 
-	aead_request_set_tfm(ctx->r.req_aead, cc->cipher_tfm.tfms_aead[0]);
+	aead_request_set_tfm(ctx->r.req_aead, cc->cipher_tfm.tfm_aead);
 
 	/*
 	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
@@ -1313,67 +387,124 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
-static blk_status_t crypt_convert(struct crypt_config *cc,
-			 struct convert_context *ctx)
+static blk_status_t crypt_convert_bio(struct crypt_config *cc,
+					struct convert_context *ctx)
 {
-	unsigned int tag_offset = 0;
-	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
+	unsigned int cryptlen, n1, n2, nents, i = 0, bytes = 0;
+	struct skcipher_request *req = NULL;
+	struct aead_request *req_aead = NULL;
+	struct dm_crypt_request *dmreq;
+	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
+	struct geniv_req_info rinfo;
+	struct bio_vec bv_in, bv_out;
 	int r;
 
 	atomic_set(&ctx->cc_pending, 1);
+	crypt_alloc_req(cc, ctx);
 
-	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
+	if (crypt_integrity_aead(cc)) {
+		req_aead = ctx->r.req_aead;
+		dmreq = dmreq_of_req(cc, req_aead);
+	} else {
+		req = ctx->r.req;
+		dmreq = dmreq_of_req(cc, req);
+	}
 
-		crypt_alloc_req(cc, ctx);
-		atomic_inc(&ctx->cc_pending);
+	n1 = bio_segments(ctx->bio_in);
+	n2 = bio_segments(ctx->bio_out);
+	nents = n1 > n2 ? n1 : n2;
+	nents = nents > MAX_SG_LIST ? MAX_SG_LIST : nents;
+	cryptlen = ctx->iter_in.bi_size;
 
-		if (crypt_integrity_aead(cc))
-			r = crypt_convert_block_aead(cc, ctx, ctx->r.req_aead, tag_offset);
-		else
-			r = crypt_convert_block_skcipher(cc, ctx, ctx->r.req, tag_offset);
+	DMDEBUG("dm-crypt:%s: segments:[in=%u, out=%u] bi_size=%u\n",
+		bio_data_dir(ctx->bio_in) == WRITE ? "write" : "read",
+		n1, n2, cryptlen);
 
-		switch (r) {
-		/*
-		 * The request was queued by a crypto driver
-		 * but the driver request queue is full, let's wait.
-		 */
-		case -EBUSY:
-			wait_for_completion(&ctx->restart);
-			reinit_completion(&ctx->restart);
-			/* fall through */
-		/*
-		 * The request is queued and processed asynchronously,
-		 * completion function kcryptd_async_done() will be called.
-		 */
-		case -EINPROGRESS:
-			ctx->r.req = NULL;
-			ctx->cc_sector += sector_step;
-			tag_offset++;
-			continue;
-		/*
-		 * The request was already processed (synchronously).
-		 */
-		case 0:
-			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector += sector_step;
-			tag_offset++;
-			cond_resched();
-			continue;
-		/*
-		 * There was a data integrity error.
-		 */
-		case -EBADMSG:
-			atomic_dec(&ctx->cc_pending);
-			return BLK_STS_PROTECTION;
-		/*
-		 * There was an error while processing the request.
-		 */
-		default:
-			atomic_dec(&ctx->cc_pending);
-			return BLK_STS_IOERR;
-		}
+	dmreq->sg_in = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
+	dmreq->sg_out = kcalloc(nents, sizeof(struct scatterlist), GFP_KERNEL);
+	if (!dmreq->sg_in || !dmreq->sg_out) {
+		DMERR("dm-crypt: Failed to allocate scatterlist\n");
+		r = -ENOMEM;
+		goto end;
+	}
+	dmreq->ctx = ctx;
+
+	sg_init_table(dmreq->sg_in, nents);
+	sg_init_table(dmreq->sg_out, nents);
+
+	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size && i < nents) {
+		bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
+		bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
+
+		sg_set_page(&dmreq->sg_in[i], bv_in.bv_page, bv_in.bv_len,
+				bv_in.bv_offset);
+		sg_set_page(&dmreq->sg_out[i], bv_out.bv_page, bv_out.bv_len,
+				bv_out.bv_offset);
+
+		bio_advance_iter(ctx->bio_in, &ctx->iter_in, bv_in.bv_len);
+		bio_advance_iter(ctx->bio_out, &ctx->iter_out, bv_out.bv_len);
+
+		bytes += bv_in.bv_len;
+		i++;
+	}
+
+	DMDEBUG("dm-crypt: Processed %u of %u bytes\n", bytes, cryptlen);
+
+	rinfo.cc_sector = ctx->cc_sector;
+	rinfo.nents = nents;
+	rinfo.integrity_metadata = io->integrity_metadata;
+
+	atomic_inc(&ctx->cc_pending);
+	if (crypt_integrity_aead(cc)) {
+		aead_request_set_crypt(req_aead, dmreq->sg_in, dmreq->sg_out,
+					bytes, (u8 *)&rinfo);
+		if (bio_data_dir(ctx->bio_in) == WRITE)
+			r = crypto_aead_encrypt(req_aead);
+		else
+			r = crypto_aead_decrypt(req_aead);
+	} else {
+		skcipher_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
+					bytes, (u8 *)&rinfo);
+		if (bio_data_dir(ctx->bio_in) == WRITE)
+			r = crypto_skcipher_encrypt(req);
+		else
+			r = crypto_skcipher_decrypt(req);
 	}
 
+	switch (r) {
+	/* The request was queued so wait. */
+	case -EBUSY:
+		wait_for_completion(&ctx->restart);
+		reinit_completion(&ctx->restart);
+		/* fall through */
+	/*
+	 * The request is queued and processed asynchronously,
+	 * completion function kcryptd_async_done() is called.
+	 */
+	case -EINPROGRESS:
+		ctx->r.req = NULL;
+		cond_resched();
+		break;
+	/*
+	 * The requeest was already processed (synchronously).
+	 */
+	case 0:
+		atomic_dec(&ctx->cc_pending);
+		break;
+	/*
+	 * There was a data integrity error.
+	 */
+	case -EBADMSG:
+		atomic_dec(&ctx->cc_pending);
+		return BLK_STS_PROTECTION;
+	/*
+	 * There was an error while processing the request.
+	 */
+	default:
+		atomic_dec(&ctx->cc_pending);
+		return BLK_STS_IOERR;
+	}
+end:
 	return 0;
 }
 
@@ -1483,14 +614,24 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
+	struct dm_crypt_request *dmreq;
 	blk_status_t error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
-	if (io->ctx.r.req)
+	if (io->ctx.r.req) {
 		crypt_free_req(cc, io->ctx.r.req, base_bio);
 
+		if (crypt_integrity_aead(cc))
+			dmreq = dmreq_of_req(cc, io->ctx.r.req_aead);
+		else
+			dmreq = dmreq_of_req(cc, io->ctx.r.req);
+		DMDEBUG("dm-crypt: Freeing scatterlists [sync]\n");
+		kfree(dmreq->sg_in);
+		kfree(dmreq->sg_out);
+	}
+
 	if (unlikely(io->integrity_metadata_from_pool))
 		mempool_free(io->integrity_metadata, &io->cc->tag_pool);
 	else
@@ -1737,7 +878,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert_bio(cc, &io->ctx);
 	if (r)
 		io->error = r;
 	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
@@ -1767,7 +908,7 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, &io->ctx);
+	r = crypt_convert_bio(cc, &io->ctx);
 	if (r)
 		io->error = r;
 
@@ -1795,16 +936,16 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		return;
 	}
 
-	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		error = cc->iv_gen_ops->post(cc, org_iv_of_dmreq(cc, dmreq), dmreq);
-
 	if (error == -EBADMSG) {
-		DMERR_LIMIT("INTEGRITY AEAD ERROR, sector %llu",
-			    (unsigned long long)le64_to_cpu(*org_sector_of_dmreq(cc, dmreq)));
+		DMERR("INTEGRITY AEAD ERROR\n");
 		io->error = BLK_STS_PROTECTION;
 	} else if (error < 0)
 		io->error = BLK_STS_IOERR;
 
+	DMDEBUG("dm-crypt: Freeing scatterlists and request struct [async]\n");
+	kfree(dmreq->sg_in);
+	kfree(dmreq->sg_out);
+
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
 	if (!atomic_dec_and_test(&ctx->cc_pending))
@@ -1834,163 +975,78 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 	queue_work(cc->crypt_queue, &io->work);
 }
 
-static void crypt_free_tfms_aead(struct crypt_config *cc)
+static void crypt_free_tfm(struct crypt_config *cc)
 {
-	if (!cc->cipher_tfm.tfms_aead)
-		return;
-
-	if (cc->cipher_tfm.tfms_aead[0] && !IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
-		crypto_free_aead(cc->cipher_tfm.tfms_aead[0]);
-		cc->cipher_tfm.tfms_aead[0] = NULL;
-	}
-
-	kfree(cc->cipher_tfm.tfms_aead);
-	cc->cipher_tfm.tfms_aead = NULL;
-}
-
-static void crypt_free_tfms_skcipher(struct crypt_config *cc)
-{
-	unsigned i;
-
-	if (!cc->cipher_tfm.tfms)
-		return;
-
-	for (i = 0; i < cc->tfms_count; i++)
-		if (cc->cipher_tfm.tfms[i] && !IS_ERR(cc->cipher_tfm.tfms[i])) {
-			crypto_free_skcipher(cc->cipher_tfm.tfms[i]);
-			cc->cipher_tfm.tfms[i] = NULL;
+	if (crypt_integrity_aead(cc)) {
+		if (!cc->cipher_tfm.tfm_aead)
+			return;
+		if (cc->cipher_tfm.tfm_aead && !IS_ERR(cc->cipher_tfm.tfm_aead)) {
+			crypto_free_aead(cc->cipher_tfm.tfm_aead);
+			cc->cipher_tfm.tfm_aead = NULL;
 		}
-
-	kfree(cc->cipher_tfm.tfms);
-	cc->cipher_tfm.tfms = NULL;
-}
-
-static void crypt_free_tfms(struct crypt_config *cc)
-{
-	if (crypt_integrity_aead(cc))
-		crypt_free_tfms_aead(cc);
-	else
-		crypt_free_tfms_skcipher(cc);
-}
-
-static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
-{
-	unsigned i;
-	int err;
-
-	cc->cipher_tfm.tfms = kcalloc(cc->tfms_count,
-				      sizeof(struct crypto_skcipher *),
-				      GFP_KERNEL);
-	if (!cc->cipher_tfm.tfms)
-		return -ENOMEM;
-
-	for (i = 0; i < cc->tfms_count; i++) {
-		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
-		if (IS_ERR(cc->cipher_tfm.tfms[i])) {
-			err = PTR_ERR(cc->cipher_tfm.tfms[i]);
-			crypt_free_tfms(cc);
-			return err;
+	} else {
+		if (!cc->cipher_tfm.tfm)
+			return;
+		if (cc->cipher_tfm.tfm && !IS_ERR(cc->cipher_tfm.tfm)) {
+			crypto_free_skcipher(cc->cipher_tfm.tfm);
+			cc->cipher_tfm.tfm = NULL;
 		}
 	}
-
-	return 0;
 }
 
-static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
+static int crypt_alloc_tfm(struct crypt_config *cc, char *ciphermode)
 {
 	int err;
 
-	cc->cipher_tfm.tfms = kmalloc(sizeof(struct crypto_aead *), GFP_KERNEL);
-	if (!cc->cipher_tfm.tfms)
-		return -ENOMEM;
-
-	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0, 0);
-	if (IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
-		err = PTR_ERR(cc->cipher_tfm.tfms_aead[0]);
-		crypt_free_tfms(cc);
-		return err;
+	if (crypt_integrity_aead(cc)) {
+		cc->cipher_tfm.tfm_aead = crypto_alloc_aead(ciphermode, 0, 0);
+		if (IS_ERR(cc->cipher_tfm.tfm_aead)) {
+			err = PTR_ERR(cc->cipher_tfm.tfm_aead);
+			crypt_free_tfm(cc);
+			return err;
+		}
+	} else {
+		cc->cipher_tfm.tfm = crypto_alloc_skcipher(ciphermode, 0, 0);
+		if (IS_ERR(cc->cipher_tfm.tfm)) {
+			err = PTR_ERR(cc->cipher_tfm.tfm);
+			crypt_free_tfm(cc);
+			return err;
+		}
 	}
 
 	return 0;
 }
 
-static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
-{
-	if (crypt_integrity_aead(cc))
-		return crypt_alloc_tfms_aead(cc, ciphermode);
-	else
-		return crypt_alloc_tfms_skcipher(cc, ciphermode);
-}
-
-static unsigned crypt_subkey_size(struct crypt_config *cc)
-{
-	return (cc->key_size - cc->key_extra_size) >> ilog2(cc->tfms_count);
-}
-
-static unsigned crypt_authenckey_size(struct crypt_config *cc)
-{
-	return crypt_subkey_size(cc) + RTA_SPACE(sizeof(struct crypto_authenc_key_param));
-}
-
-/*
- * If AEAD is composed like authenc(hmac(sha256),xts(aes)),
- * the key must be for some reason in special format.
- * This funcion converts cc->key to this special format.
- */
-static void crypt_copy_authenckey(char *p, const void *key,
-				  unsigned enckeylen, unsigned authkeylen)
+static void init_key_info(struct crypt_config *cc, enum setkey_op keyop,
+			char *ivopts, struct geniv_key_info *kinfo)
 {
-	struct crypto_authenc_key_param *param;
-	struct rtattr *rta;
-
-	rta = (struct rtattr *)p;
-	param = RTA_DATA(rta);
-	param->enckeylen = cpu_to_be32(enckeylen);
-	rta->rta_len = RTA_LENGTH(sizeof(*param));
-	rta->rta_type = CRYPTO_AUTHENC_KEYA_PARAM;
-	p += RTA_SPACE(sizeof(*param));
-	memcpy(p, key + enckeylen, authkeylen);
-	p += authkeylen;
-	memcpy(p, key, enckeylen);
+	kinfo->keyop = keyop;
+	kinfo->tfms_count = cc->tfms_count;
+	kinfo->key = cc->key;
+	kinfo->cipher_flags = cc->cipher_flags;
+	kinfo->ivopts = ivopts;
+	kinfo->iv_offset = cc->iv_offset;
+	kinfo->sector_size = cc->sector_size;
+	kinfo->key_size = cc->key_size;
+	kinfo->key_parts = cc->key_parts;
+	kinfo->key_mac_size = cc->key_mac_size;
+	kinfo->on_disk_tag_size = cc->on_disk_tag_size;
 }
 
-static int crypt_setkey(struct crypt_config *cc)
+static int crypt_setkey(struct crypt_config *cc, enum setkey_op keyop,
+			char *ivopts)
 {
-	unsigned subkey_size;
-	int err = 0, i, r;
-
-	/* Ignore extra keys (which are used for IV etc) */
-	subkey_size = crypt_subkey_size(cc);
-
-	if (crypt_integrity_hmac(cc)) {
-		if (subkey_size < cc->key_mac_size)
-			return -EINVAL;
-
-		crypt_copy_authenckey(cc->authenc_key, cc->key,
-				      subkey_size - cc->key_mac_size,
-				      cc->key_mac_size);
-	}
+	int r = 0;
+	struct geniv_key_info kinfo;
 
-	for (i = 0; i < cc->tfms_count; i++) {
-		if (crypt_integrity_hmac(cc))
-			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
-				cc->authenc_key, crypt_authenckey_size(cc));
-		else if (crypt_integrity_aead(cc))
-			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
-					       cc->key + (i * subkey_size),
-					       subkey_size);
-		else
-			r = crypto_skcipher_setkey(cc->cipher_tfm.tfms[i],
-						   cc->key + (i * subkey_size),
-						   subkey_size);
-		if (r)
-			err = r;
-	}
+	init_key_info(cc, keyop, ivopts, &kinfo);
 
-	if (crypt_integrity_hmac(cc))
-		memzero_explicit(cc->authenc_key, crypt_authenckey_size(cc));
+	if (crypt_integrity_aead(cc))
+		r = crypto_aead_setkey(cc->cipher_tfm.tfm_aead, (u8 *)&kinfo, sizeof(kinfo));
+	else
+		r = crypto_skcipher_setkey(cc->cipher_tfm.tfm, (u8 *)&kinfo, sizeof(kinfo));
 
-	return err;
+	return r;
 }
 
 #ifdef CONFIG_KEYS
@@ -2003,7 +1059,9 @@ static bool contains_whitespace(const char *str)
 	return false;
 }
 
-static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
+static int crypt_set_keyring_key(struct crypt_config *cc,
+				const char *key_string,
+				enum setkey_op keyop, char *ivopts)
 {
 	char *new_key_string, *key_desc;
 	int ret;
@@ -2064,7 +1122,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 	/* clear the flag since following operations may invalidate previously valid key */
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	ret = crypt_setkey(cc);
+	ret = crypt_setkey(cc, keyop, ivopts);
 
 	if (!ret) {
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
@@ -2101,7 +1159,9 @@ static int get_key_size(char **key_string)
 
 #else
 
-static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
+static int crypt_set_keyring_key(struct crypt_config *cc,
+				const char *key_string,
+				enum setkey_op keyop, char *ivopts)
 {
 	return -EINVAL;
 }
@@ -2113,7 +1173,8 @@ static int get_key_size(char **key_string)
 
 #endif
 
-static int crypt_set_key(struct crypt_config *cc, char *key)
+static int crypt_set_key(struct crypt_config *cc, enum setkey_op keyop,
+			char *key, char *ivopts)
 {
 	int r = -EINVAL;
 	int key_string_len = strlen(key);
@@ -2124,7 +1185,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
 	if (key[0] == ':') {
-		r = crypt_set_keyring_key(cc, key + 1);
+		r = crypt_set_keyring_key(cc, key + 1, keyop, ivopts);
 		goto out;
 	}
 
@@ -2139,7 +1200,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
 		goto out;
 
-	r = crypt_setkey(cc);
+	r = crypt_setkey(cc, keyop, ivopts);
 	if (!r)
 		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
@@ -2150,6 +1211,17 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	return r;
 }
 
+static int crypt_init_key(struct dm_target *ti, char *key, char *ivopts)
+{
+	struct crypt_config *cc = ti->private;
+	int ret;
+
+	ret = crypt_set_key(cc, SETKEY_OP_INIT, key, ivopts);
+	if (ret < 0)
+		ti->error = "Error decoding and setting key";
+	return ret;
+}
+
 static int crypt_wipe_key(struct crypt_config *cc)
 {
 	int r;
@@ -2158,7 +1230,7 @@ static int crypt_wipe_key(struct crypt_config *cc)
 	get_random_bytes(&cc->key, cc->key_size);
 	kzfree(cc->key_string);
 	cc->key_string = NULL;
-	r = crypt_setkey(cc);
+	r = crypt_setkey(cc, SETKEY_OP_WIPE, NULL);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
 
 	return r;
@@ -2218,7 +1290,7 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
-	crypt_free_tfms(cc);
+	crypt_free_tfm(cc);
 
 	bioset_exit(&cc->bs);
 
@@ -2229,17 +1301,12 @@ static void crypt_dtr(struct dm_target *ti)
 	WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0);
 	percpu_counter_destroy(&cc->n_allocated_pages);
 
-	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
-		cc->iv_gen_ops->dtr(cc);
-
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
 	kzfree(cc->key_string);
 	kzfree(cc->cipher_auth);
-	kzfree(cc->authenc_key);
 
 	mutex_destroy(&cc->bio_alloc_lock);
 
@@ -2253,6 +1320,32 @@ static void crypt_dtr(struct dm_target *ti)
 	spin_unlock(&dm_crypt_clients_lock);
 }
 
+static int get_iv_size_by_name(struct crypt_config *cc, char *alg_name)
+{
+	unsigned int iv_size;
+	struct crypto_aead *tfm_aead;
+	struct crypto_skcipher *tfm;
+
+	if (crypt_integrity_aead(cc)) {
+		tfm_aead = crypto_alloc_aead(alg_name, 0, 0);
+		if (IS_ERR(tfm_aead))
+			return -ENOMEM;
+
+		iv_size = crypto_aead_ivsize(tfm_aead);
+		crypto_free_aead(tfm_aead);
+	} else {
+		tfm = crypto_alloc_skcipher(alg_name, 0, 0);
+		if (IS_ERR(tfm))
+			return -ENOMEM;
+
+		iv_size = crypto_skcipher_ivsize(tfm);
+		crypto_free_skcipher(tfm);
+	}
+
+	return iv_size;
+
+}
+
 static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 {
 	struct crypt_config *cc = ti->private;
@@ -2266,97 +1359,12 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
 				  (unsigned int)(sizeof(u64) / sizeof(u8)));
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
-	else if (strcmp(ivmode, "plain64be") == 0)
-		cc->iv_gen_ops = &crypt_iv_plain64be_ops;
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
+
+	if (strcmp(ivmode, "random") == 0) {
 		/* Need storage space in integrity fields. */
 		cc->integrity_iv_size = cc->iv_size;
-	} else {
-		ti->error = "Invalid IV mode";
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/*
- * Workaround to parse cipher algorithm from crypto API spec.
- * The cc->cipher is currently used only in ESSIV.
- * This should be probably done by crypto-api calls (once available...)
- */
-static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
-{
-	const char *alg_name = NULL;
-	char *start, *end;
-
-	if (crypt_integrity_aead(cc)) {
-		alg_name = crypto_tfm_alg_name(crypto_aead_tfm(any_tfm_aead(cc)));
-		if (!alg_name)
-			return -EINVAL;
-		if (crypt_integrity_hmac(cc)) {
-			alg_name = strchr(alg_name, ',');
-			if (!alg_name)
-				return -EINVAL;
-		}
-		alg_name++;
-	} else {
-		alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)));
-		if (!alg_name)
-			return -EINVAL;
 	}
 
-	start = strchr(alg_name, '(');
-	end = strchr(alg_name, ')');
-
-	if (!start && !end) {
-		cc->cipher = kstrdup(alg_name, GFP_KERNEL);
-		return cc->cipher ? 0 : -ENOMEM;
-	}
-
-	if (!start || !end || ++start >= end)
-		return -EINVAL;
-
-	cc->cipher = kzalloc(end - start + 1, GFP_KERNEL);
-	if (!cc->cipher)
-		return -ENOMEM;
-
-	strncpy(cc->cipher, start, end - start);
-
 	return 0;
 }
 
@@ -2392,10 +1400,6 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 	cc->key_mac_size = crypto_ahash_digestsize(mac);
 	crypto_free_ahash(mac);
 
-	cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
-	if (!cc->authenc_key)
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -2404,6 +1408,7 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 {
 	struct crypt_config *cc = ti->private;
 	char *tmp, *cipher_api;
+	char cipher_name[CRYPTO_MAX_ALG_NAME];
 	int ret = -EINVAL;
 
 	cc->tfms_count = 1;
@@ -2422,8 +1427,29 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 
 	cc->key_parts = cc->tfms_count;
 
+	if (!*ivmode)
+		*ivmode = "null";
+
+	/*
+	 * For those ciphers which do not support IVs, but input ivmode is not
+	 * NULL, use "null" as ivmode compulsively.
+	 */
+	cc->iv_size = get_iv_size_by_name(cc, cipher_api);
+	if (cc->iv_size < 0)
+		return -ENOMEM;
+	if (!cc->iv_size && ivmode) {
+		DMWARN("Selected cipher does not support IVs");
+		*ivmode = "null";
+	}
+
 	/* Allocate cipher */
-	ret = crypt_alloc_tfms(cc, cipher_api);
+	ret = snprintf(cipher_name, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+			*ivmode, cipher_api);
+	if (ret < 0) {
+		ti->error = "Cannot allocate cipher strings";
+		return -ENOMEM;
+	}
+	ret = crypt_alloc_tfm(cc, cipher_name);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
 		return ret;
@@ -2440,12 +1466,6 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	} else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
-	ret = crypt_ctr_blkdev_cipher(cc);
-	if (ret < 0) {
-		ti->error = "Cannot allocate cipher string";
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
@@ -2480,10 +1500,6 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 	}
 	cc->key_parts = cc->tfms_count;
 
-	cc->cipher = kstrdup(cipher, GFP_KERNEL);
-	if (!cc->cipher)
-		goto bad_mem;
-
 	chainmode = strsep(&tmp, "-");
 	*ivopts = strsep(&tmp, "-");
 	*ivmode = strsep(&*ivopts, ":");
@@ -2509,15 +1525,35 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 	if (!cipher_api)
 		goto bad_mem;
 
+	/* For those ciphers which do not support IVs,
+	 * use the 'null' template cipher
+	 */
+	if (!*ivmode)
+		*ivmode = "null";
+
+	/*
+	 * For those ciphers which do not support IVs, but input ivmode is not
+	 * NULL, use "null" as ivmode compulsively.
+	 */
 	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
 		       "%s(%s)", chainmode, cipher);
+	cc->iv_size = get_iv_size_by_name(cc, cipher_api);
+	if (cc->iv_size < 0)
+		return -ENOMEM;
+	if (!cc->iv_size && ivmode) {
+		DMWARN("Selected cipher does not support IVs");
+		*ivmode = "null";
+	}
+
+	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
+		       "%s(%s(%s))", *ivmode, chainmode, cipher);
 	if (ret < 0) {
 		kfree(cipher_api);
 		goto bad_mem;
 	}
 
 	/* Allocate cipher */
-	ret = crypt_alloc_tfms(cc, cipher_api);
+	ret = crypt_alloc_tfm(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
 		kfree(cipher_api);
@@ -2556,30 +1592,12 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 		return ret;
 
 	/* Initialize and set key */
-	ret = crypt_set_key(cc, key);
+	ret = crypt_init_key(ti, key, ivopts);
 	if (ret < 0) {
 		ti->error = "Error decoding and setting key";
 		return ret;
 	}
 
-	/* Allocate IV */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->ctr) {
-		ret = cc->iv_gen_ops->ctr(cc, ti, ivopts);
-		if (ret < 0) {
-			ti->error = "Error creating IV";
-			return ret;
-		}
-	}
-
-	/* Initialize IV (set keys for ESSIV etc) */
-	if (cc->iv_gen_ops && cc->iv_gen_ops->init) {
-		ret = cc->iv_gen_ops->init(cc);
-		if (ret < 0) {
-			ti->error = "Error initialising IV";
-			return ret;
-		}
-	}
-
 	/* wipe the kernel key payload copy */
 	if (cc->key_string)
 		memset(cc->key, 0, cc->key_size * sizeof(u8));
@@ -2673,7 +1691,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	unsigned int align_mask;
 	unsigned long long tmpll;
 	int ret;
-	size_t iv_size_padding, additional_req_size;
+	size_t additional_req_size;
 	char dummy;
 
 	if (argc < 5) {
@@ -2729,25 +1747,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->dmreq_start = ALIGN(cc->dmreq_start, __alignof__(struct dm_crypt_request));
 
-	if (align_mask < CRYPTO_MINALIGN) {
-		/* Allocate the padding exactly */
-		iv_size_padding = -(cc->dmreq_start + sizeof(struct dm_crypt_request))
-				& align_mask;
-	} else {
-		/*
-		 * If the cipher requires greater alignment than kmalloc
-		 * alignment, we don't know the exact position of the
-		 * initialization vector. We must assume worst case.
-		 */
-		iv_size_padding = align_mask;
-	}
-
-	/*  ...| IV + padding | original IV | original sec. number | bio tag offset | */
-	additional_req_size = sizeof(struct dm_crypt_request) +
-		iv_size_padding + cc->iv_size +
-		cc->iv_size +
-		sizeof(uint64_t) +
-		sizeof(unsigned int);
+	additional_req_size = sizeof(struct dm_crypt_request);
 
 	ret = mempool_init_kmalloc_pool(&cc->req_pool, MIN_IOS, cc->dmreq_start + additional_req_size);
 	if (ret) {
@@ -3024,22 +2024,13 @@ static int crypt_message(struct dm_target *ti, unsigned argc, char **argv,
 				return -EINVAL;
 			}
 
-			ret = crypt_set_key(cc, argv[2]);
-			if (ret)
-				return ret;
-			if (cc->iv_gen_ops && cc->iv_gen_ops->init)
-				ret = cc->iv_gen_ops->init(cc);
+			ret = crypt_set_key(cc, SETKEY_OP_SET, argv[2], NULL);
 			/* wipe the kernel key payload copy */
 			if (cc->key_string)
 				memset(cc->key, 0, cc->key_size * sizeof(u8));
 			return ret;
 		}
 		if (argc == 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret = cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
 			return crypt_wipe_key(cc);
 		}
 	}
@@ -3078,7 +2069,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 18, 1},
+	.version = {1, 19, 1},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
@@ -3103,7 +2094,7 @@ static int __init dm_crypt_init(void)
 	return r;
 }
 
-static void __exit dm_crypt_exit(void)
+void __exit dm_crypt_exit(void)
 {
 	dm_unregister_target(&crypt_target);
 }
-- 
1.7.12.4
