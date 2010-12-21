From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 7/7] [RFC]dm crypt: add loop-aes LMK IV generator
Date: Tue, 21 Dec 2010 16:28:19 +0100
Message-ID: <835cd3199623a472a627f143ce6573b064d0c5a8.1292944625.git.mbroz@redhat.com>
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
Cc: Max Vozeler <max@hinterhof.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

This IV is designed by Jari Ruusu and is used
in loop-aes package.

This patch just adds compatibility mode to dmcrypt
for this IV scheme.

(N.B it is not meant as loop-aes replacement which
here provides better perfomance but just to provide
compatible mappings for people which are unable to patch
kernel and userspace to access loop-aes devices.)

loop-aes can use three encryption schemes:
 version 1: is plain aes-cbc mode (already compatible)
 version 2: uses 64 multikey scheme with LMK IV
 version 3: the same as version 2 with additional IV seed
 (so v3 uses 65 keys, last key is used as IV seed)

For v2/3 the cipher specification looks like: aes:64-cbc-lmk

In fact, LMK is not only IV generator but also slight
modification to CBC encryption mode - the first block
of CBC mode depends not only on sector and optional
IV seed, but also on plainext data of this sector.

This means that after decryption the first block of sector
must be tweaked according to decrypted data.

The format of key is just hexa encoded "raw key"
used in loop-aes ioctl.

There is needed small userspace utility which gpg decrypts
the file with key and performs simple hash operation to generate
raw keys.
(It will be added to cryptsetup once if this patch is accepted.)

Code is inspired by Max Vozeler cryptoAPI implementation
(which was not accepted some time ago.)

Signed-off-by: Milan Broz <mbroz@redhat.com>
CC: Max Vozeler <max@hinterhof.net>
---
 drivers/md/dm-crypt.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 183 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3b9d3a0..c36b977 100644
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
@@ -131,6 +140,7 @@ struct crypt_config {
 	union {
 		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
+		struct iv_lmk_private lmk;
 	} iv_gen_private;
 	sector_t iv_offset;
 	unsigned int iv_size;
@@ -446,6 +456,164 @@ static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv,
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
+static inline void cpu_to_le32_array(u32 *buf, unsigned int words)
+{
+	while (words--) {
+		__cpu_to_le32s(buf);
+		buf++;
+	}
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
+	int r;
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
+	buf[0] = dmreq->iv_sector & 0xFFFFFFFF;
+	buf[1] = ((dmreq->iv_sector >> 32) & 0x00FFFFFF) | 0x80000000;
+	buf[2] = 4024;
+	buf[3] = 0;
+	cpu_to_le32_array(buf, 4);
+
+	r = crypto_shash_update(&sdesc.desc, (u8 *)buf, sizeof(buf));
+	if (r)
+		return r;
+
+	/* No MD5 padding here */
+	r = crypto_shash_export(&sdesc.desc, &md5state);
+	if (r)
+		return r;
+
+	cpu_to_le32_array(md5state.hash, 4);
+	memcpy(iv, &md5state.hash, cc->iv_size);
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
+	/* Code must fix the first block of plaintext sector */
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
@@ -472,6 +640,15 @@ static struct crypt_iv_operations crypt_iv_null_ops = {
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
@@ -1349,7 +1526,12 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
 	else if (strcmp(ivmode, "null") == 0)
 		cc->iv_gen_ops = &crypt_iv_null_ops;
-	else {
+	else if (strcmp(ivmode, "lmk") == 0) {
+		cc->iv_gen_ops = &crypt_iv_lmk_ops;
+		/* loop-aes multikey version 3 - last key used for IV seed */
+		if (cc->key_size % cc->key_parts)
+			cc->key_parts++;
+	} else {
 		ret = -EINVAL;
 		ti->error = "Invalid IV mode";
 		goto bad;
-- 
1.7.2.3
