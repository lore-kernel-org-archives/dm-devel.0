From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 3/3] dm crypt: add Loop-AES IV generator
Date: Thu,  6 Jan 2011 21:04:02 +0100
Message-ID: <b0147f0d20377484509a3c075401b065d8f05c64.1294344057.git.mbroz@redhat.com>
References: <cover.1294344057.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1294344057.git.mbroz@redhat.com>
In-Reply-To: <cover.1294344057.git.mbroz@redhat.com>
References: <cover.1294344057.git.mbroz@redhat.com>
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
Cc: Max Vozeler <max@hinterhof.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

This patch adds a compatible implementation of the block
chaining mode used by the Loop-AES block device encryption
system (http://loop-aes.sourceforge.net/) designed
by Jari Ruusu.

It operates on full 512 byte sectors and uses CBC
with an IV derived from the sector number, the data and
optionally extra IV seed.

This means that after CBC decryption the first block of sector
must be tweaked according to decrypted data.

Loop-AES can use three encryption schemes:
 version 1: is plain aes-cbc mode (already compatible)
 version 2: uses 64 multikey scheme with own IV generator
 version 3: the same as version 2 with additional IV seed
            (it uses 65 keys, last key is used as IV seed)

The IV generator is here named lmk (Loop-AES multikey)
and for the cipher specification looks like: aes:64-cbc-lmk

Version 2 and 3 is recognised according to length
of provided multi-key string (which is just hexa encoded
"raw key" used in original Loop-AES ioctl).

Configuration of the device and decoding key string will
be done in userspace (cryptsetup).
(Loop-AES stores keys in gpg encrypted file, raw keys are
output of simple hashing of lines in this file).

Code is inspired by Max Vozeler cryptoAPI implementation
(which was not accepted some time ago.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
CC: Max Vozeler <max@hinterhof.net>
---
 drivers/md/dm-crypt.c |  180 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 179 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index eba9b43..8419be8 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -23,6 +23,9 @@
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/md5.h>
+#include <crypto/algapi.h>
 
 #include <linux/device-mapper.h>
 
@@ -90,6 +93,12 @@ struct iv_benbi_private {
 	int shift;
 };
 
+#define LMK_SEED_SIZE 64 /* hash + 0 */
+struct iv_lmk_private {
+	struct crypto_shash *hash_tfm;
+	u8 *seed;
+};
+
 /*
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
@@ -133,6 +142,7 @@ struct crypt_config {
 	union {
 		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
+		struct iv_lmk_private lmk;
 	} iv_gen_private;
 	sector_t iv_offset;
 	unsigned int iv_size;
@@ -207,6 +217,10 @@ static struct crypto_ablkcipher *this_tfm(struct crypt_config *cc)
  * null: the initial vector is always zero.  Provides compatibility with
  *       obsolete loop_fish2 devices.  Do not use for new devices.
  *
+ * lmk:  Compatible implementation of the block chaining mode used
+ *       by the Loop-AES block device encryption system
+ *       designed by Jari Ruusu. See http://loop-aes.sourceforge.net/
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -446,6 +460,156 @@ static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
 	return 0;
 }
 
+static void crypt_iv_lmk_dtr(struct crypt_config *cc)
+{
+	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+
+	if (lmk->hash_tfm && !IS_ERR(lmk->hash_tfm))
+		crypto_free_shash(lmk->hash_tfm);
+	lmk->hash_tfm = NULL;
+
+	kzfree(lmk->seed);
+	lmk->seed = NULL;
+}
+
+static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
+			    const char *opts)
+{
+	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+
+	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
+	if (IS_ERR(lmk->hash_tfm)) {
+		ti->error = "Error initializing LMK hash";
+		return PTR_ERR(lmk->hash_tfm);
+	}
+
+	/* No seed in LMK version 2 */
+	if (cc->key_parts == cc->tfms_count) {
+		lmk->seed = NULL;
+		return 0;
+	}
+
+	lmk->seed = kzalloc(LMK_SEED_SIZE, GFP_KERNEL);
+	if (!lmk->seed) {
+		crypt_iv_lmk_dtr(cc);
+		ti->error = "Error kmallocing seed storage in LMK";
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_iv_lmk_init(struct crypt_config *cc)
+{
+	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+	int subkey_size = cc->key_size / cc->key_parts;
+
+	/* LMK seed is on the position of LMK_KEYS + 1 key */
+	if (lmk->seed)
+		memcpy(lmk->seed, cc->key + (cc->tfms_count * subkey_size),
+		       crypto_shash_digestsize(lmk->hash_tfm));
+
+	return 0;
+}
+
+static int crypt_iv_lmk_wipe(struct crypt_config *cc)
+{
+	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+
+	if (lmk->seed)
+		memset(lmk->seed, 0, LMK_SEED_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
+			    struct dm_crypt_request *dmreq,
+			    u8 *data)
+{
+	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
+	} sdesc;
+	struct md5_state md5state;
+	u32 buf[4];
+	int i, r;
+
+	sdesc.desc.tfm = lmk->hash_tfm;
+	sdesc.desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	r = crypto_shash_init(&sdesc.desc);
+	if (r)
+		return r;
+
+	if (lmk->seed) {
+		r = crypto_shash_update(&sdesc.desc, lmk->seed, LMK_SEED_SIZE);
+		if (r)
+			return r;
+	}
+
+	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
+	r = crypto_shash_update(&sdesc.desc, data + 16, 16 * 31);
+	if (r)
+		return r;
+
+	/* Sector is cropped to 56 bits here */
+	buf[0] = cpu_to_le32(dmreq->iv_sector & 0xFFFFFFFF);
+	buf[1] = cpu_to_le32(((dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000);
+	buf[2] = cpu_to_le32(4024);
+	buf[3] = 0;
+	r = crypto_shash_update(&sdesc.desc, (u8 *)buf, sizeof(buf));
+	if (r)
+		return r;
+
+	/* No MD5 padding here */
+	r = crypto_shash_export(&sdesc.desc, &md5state);
+	if (r)
+		return r;
+
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		__cpu_to_le32s(&md5state.hash[i]);
+	memcpy(iv, &md5state.hash, cc->iv_size);
+
+	return 0;
+}
+
+static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
+			    struct dm_crypt_request *dmreq)
+{
+	u8 *src;
+	int r = 0;
+
+	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
+		src = kmap_atomic(sg_page(&dmreq->sg_in), KM_USER0);
+		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
+		kunmap_atomic(src, KM_USER0);
+	} else
+		memset(iv, 0, cc->iv_size);
+
+	return r;
+}
+
+static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
+			     struct dm_crypt_request *dmreq)
+{
+	u8 *dst;
+	int r;
+
+	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+		return 0;
+
+	dst = kmap_atomic(sg_page(&dmreq->sg_out), KM_USER0);
+	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
+
+	/* Tweak the first block of plaintext sector */
+	if (!r)
+		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
+
+	kunmap_atomic(dst, KM_USER0);
+	return r;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -472,6 +636,15 @@ static struct crypt_iv_operations crypt_iv_null_ops = {
 	.generator = crypt_iv_null_gen
 };
 
+static struct crypt_iv_operations crypt_iv_lmk_ops = {
+	.ctr	   = crypt_iv_lmk_ctr,
+	.dtr	   = crypt_iv_lmk_dtr,
+	.init	   = crypt_iv_lmk_init,
+	.wipe	   = crypt_iv_lmk_wipe,
+	.generator = crypt_iv_lmk_gen,
+	.post	   = crypt_iv_lmk_post
+};
+
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -1343,7 +1516,12 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
 	else if (strcmp(ivmode, "null") == 0)
 		cc->iv_gen_ops = &crypt_iv_null_ops;
-	else {
+	else if (strcmp(ivmode, "lmk") == 0) {
+		cc->iv_gen_ops = &crypt_iv_lmk_ops;
+		/* Loop-AES multikey version 3 - last key used for IV seed */
+		if (cc->key_size % cc->key_parts)
+			cc->key_parts++;
+	} else {
 		ret = -EINVAL;
 		ti->error = "Invalid IV mode";
 		goto bad;
-- 
1.7.2.3
