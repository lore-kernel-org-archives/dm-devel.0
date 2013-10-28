From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/2] dm-crypt: Add TCW IV mode for old CBC TCRYPT
	containers.
Date: Mon, 28 Oct 2013 23:21:04 +0100
Message-ID: <1382998864-10380-2-git-send-email-gmazyland@gmail.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382998864-10380-1-git-send-email-gmazyland@gmail.com>
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

The dmcrypt already can activate TCRYPT (TrueCrypt compatible)
containers in LRW or XTS block encryption mode.

TCRYPT containers prior to version 4.1 used CBC mode with some
additional tweaks.

This patch adds support for these containers.

The mode is implemented using special IV generator named TCW
(TrueCrypt IV with whitening).

TCW IV supports only containers encrypted with one cipher
(Tested with AES, Twofish, Serpent, CAST5 and TripleDES).

While this mode is legacy and is known to be vulnerable
to some watermarking attacks (e.g. revealing of hidden disk
existence) it can be still useful to mount old containers
without using 3rd party software or for independent forensic
analysis of such containers.

(Both userspace and kernel code is independent implementation
based on format documentation and completely avoids use of original
source code.)

The TCW IV generator uses two additional keys, Kw (whitening
seed, size is always 16 bytes - TCW_WHITENING_SIZE) and
Kiv (IV seed, size is always of the IV size of selected cipher).
These keys are concatenated to main encryption key in mapping table.

While whitening is completely independent from IV, it is
implemented inside IV generator for simplification.

Whitening value is always 16 bytes long and is calculated
per sector from provided Kw as initial seed, xored with
sector number and mixed with CRC32 algorithm.
Resulting value is xored with ciphertext sector content.

IV is calculated from provided Kiv as initial seed and
xored with sector number.

Detailed calculation is in Truecrypt documentation for version < 4.1
and will be also described on dmcrypt site
http://code.google.com/p/cryptsetup/wiki/DMCrypt

The experimental support for activation of these containers
is already present in git devel brach of cryptsetup.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/device-mapper/dm-crypt.txt |  11 +-
 drivers/md/dm-crypt.c                    | 178 ++++++++++++++++++++++++++++++-
 2 files changed, 186 insertions(+), 3 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 2c656ae..89cbf3e 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -4,12 +4,15 @@ dm-crypt
 Device-Mapper's "crypt" target provides transparent encryption of block devices
 using the kernel crypto API.
 
+For more detailed description of parameters see also DMCrypt page
+http://code.google.com/p/cryptsetup/wiki/DMCrypt
+
 Parameters: <cipher> <key> <iv_offset> <device path> \
 	      <offset> [<#opt_params> <opt_params>]
 
 <cipher>
     Encryption cipher and an optional IV generation mode.
-    (In format cipher[:keycount]-chainmode-ivopts:ivmode).
+    (In format cipher[:keycount]-chainmode-ivmode[:ivopts]).
     Examples:
        des
        aes-cbc-essiv:sha256
@@ -19,7 +22,11 @@ Parameters: <cipher> <key> <iv_offset> <device path> \
 
 <key>
     Key used for encryption. It is encoded as a hexadecimal number.
-    You can only use key sizes that are valid for the selected cipher.
+    You can only use key sizes that are valid for the selected cipher
+    in combination with selected iv mode.
+    Note that for some iv modes the key string can contain additional
+    keys (for example IV seed) so the key contains more parts contatenated
+    to one string.
 
 <keycount>
     Multi-key compatibility mode. You can define <keycount> keys and
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 878bda7..0b3923d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2,6 +2,7 @@
  * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
  * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
  * Copyright (C) 2006-2009 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2013 Milan Broz <gmazyland@gmail.com>
  *
  * This file is released under the GPL.
  */
@@ -98,6 +99,13 @@ struct iv_lmk_private {
 	u8 *seed;
 };
 
+#define TCW_WHITENING_SIZE 16
+struct iv_tcw_private {
+	struct crypto_shash *crc32_tfm;
+	u8 *iv_seed;
+	u8 *whitening;
+};
+
 /*
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
@@ -139,6 +147,7 @@ struct crypt_config {
 		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
 		struct iv_lmk_private lmk;
+		struct iv_tcw_private tcw;
 	} iv_gen_private;
 	sector_t iv_offset;
 	unsigned int iv_size;
@@ -231,6 +240,16 @@ static struct crypto_ablkcipher *any_tfm(struct crypt_config *cc)
  *         version 3: the same as version 2 with additional IV seed
  *                   (it uses 65 keys, last key is used as IV seed)
  *
+ * tcw:  Compatible implementation of the block chaining mode used
+ *       by the TrueCrypt device encryption system (prior to version 4.1).
+ *       For more info see http://www.truecrypt.org.
+ *       It operates on full 512 byte sectors and uses CBC
+ *       with an IV derived from initial key and the sector number.
+ *       In addition, whitening value is applied on every sector, whitening
+ *       is calculated from initial key, sector number and mixed using CRC32.
+ *       Note that this encryption scheme is vulnerable to watermarking attacks
+ *       and should be used for old compatible containers access only.
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -609,6 +628,150 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 	return r;
 }
 
+static void crypt_iv_tcw_dtr(struct crypt_config *cc)
+{
+	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+
+	kzfree(tcw->iv_seed);
+	tcw->iv_seed = NULL;
+	kzfree(tcw->whitening);
+	tcw->whitening = NULL;
+
+	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
+		crypto_free_shash(tcw->crc32_tfm);
+	tcw->crc32_tfm = NULL;
+}
+
+static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
+			    const char *opts)
+{
+	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+
+	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
+		ti->error = "Wrong key size for TCW";
+		return -EINVAL;
+	}
+
+	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
+	if (IS_ERR(tcw->crc32_tfm)) {
+		ti->error = "Error initializing CRC32 in TCW";
+		return PTR_ERR(tcw->crc32_tfm);
+	}
+
+	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
+	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
+	if (!tcw->iv_seed || !tcw->whitening) {
+		crypt_iv_tcw_dtr(cc);
+		ti->error = "Error kmallocing seed storage in TCW";
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_iv_tcw_init(struct crypt_config *cc)
+{
+	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+	int key_offset = cc->key_size - cc->iv_size - TCW_WHITENING_SIZE;
+
+	memcpy(tcw->iv_seed, &cc->key[key_offset], cc->iv_size);
+	memcpy(tcw->whitening, &cc->key[key_offset + cc->iv_size],
+	       TCW_WHITENING_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_tcw_wipe(struct crypt_config *cc)
+{
+	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+
+	memset(tcw->iv_seed, 0, cc->iv_size);
+	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
+
+	return 0;
+}
+
+static int crypt_iv_tcw_whitening(struct crypt_config *cc,
+				  struct dm_crypt_request *dmreq,
+				  u8 *data)
+{
+	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+	u64 sector = cpu_to_le64((u64)dmreq->iv_sector);
+	u8 buf[TCW_WHITENING_SIZE];
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tcw->crc32_tfm)];
+	} sdesc;
+	int i, r;
+
+	/* xor whitening with sector number */
+	memcpy(buf, tcw->whitening, TCW_WHITENING_SIZE);
+	crypto_xor(buf, (u8*)&sector, 8);
+	crypto_xor(&buf[8], (u8*)&sector, 8);
+
+	/* calculate crc32 for every 32bit part and xor it */
+	sdesc.desc.tfm = tcw->crc32_tfm;
+	sdesc.desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	for (i = 0; i < 4; i++) {
+		if ((r = crypto_shash_init(&sdesc.desc)))
+			goto out;
+		if ((r = crypto_shash_update(&sdesc.desc, &buf[i * 4], 4)))
+			goto out;
+		if ((r = crypto_shash_final(&sdesc.desc, &buf[i * 4])))
+			goto out;
+	}
+	crypto_xor(&buf[0], &buf[12], 4);
+	crypto_xor(&buf[4], &buf[8], 4);
+
+	/* apply whitening (8 bytes) to whole sector */
+	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
+		crypto_xor(data + i * 8, buf, 8);
+out:
+	memset(buf, 0, sizeof(buf));
+	return r;
+}
+
+static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
+			    struct dm_crypt_request *dmreq)
+{
+	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
+	u64 sector = cpu_to_le64((u64)dmreq->iv_sector);
+	u8 *src;
+	int r = 0;
+
+	/* Remove whitening from ciphertext */
+	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
+		src = kmap_atomic(sg_page(&dmreq->sg_in));
+		r = crypt_iv_tcw_whitening(cc, dmreq, src + dmreq->sg_in.offset);
+		kunmap_atomic(src);
+	}
+
+	/* Calculate IV */
+	memcpy(iv, tcw->iv_seed, cc->iv_size);
+	crypto_xor(iv, (u8*)&sector, 8);
+	if (cc->iv_size > 8)
+		crypto_xor(&iv[8], (u8*)&sector, cc->iv_size - 8);
+
+	return r;
+}
+
+static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
+			     struct dm_crypt_request *dmreq)
+{
+	u8 *dst;
+	int r;
+
+	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
+		return 0;
+
+	/* Apply whitening on ciphertext */
+	dst = kmap_atomic(sg_page(&dmreq->sg_out));
+	r = crypt_iv_tcw_whitening(cc, dmreq, dst + dmreq->sg_out.offset);
+	kunmap_atomic(dst);
+
+	return r;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -644,6 +807,15 @@ static struct crypt_iv_operations crypt_iv_lmk_ops = {
 	.post	   = crypt_iv_lmk_post
 };
 
+static struct crypt_iv_operations crypt_iv_tcw_ops = {
+	.ctr	   = crypt_iv_tcw_ctr,
+	.dtr	   = crypt_iv_tcw_dtr,
+	.init	   = crypt_iv_tcw_init,
+	.wipe	   = crypt_iv_tcw_wipe,
+	.generator = crypt_iv_tcw_gen,
+	.post	   = crypt_iv_tcw_post
+};
+
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -1499,6 +1671,10 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 			cc->key_parts++;
 			cc->key_extra_size = cc->key_size / cc->key_parts;
 		}
+	} else if (strcmp(ivmode, "tcw") == 0) {
+		cc->iv_gen_ops = &crypt_iv_tcw_ops;
+		cc->key_parts += 2; /* IV + whitening */
+		cc->key_extra_size = cc->iv_size + TCW_WHITENING_SIZE;
 	} else {
 		ret = -EINVAL;
 		ti->error = "Invalid IV mode";
@@ -1824,7 +2000,7 @@ static int crypt_iterate_devices(struct dm_target *ti,
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 12, 1},
+	.version = {1, 13, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
1.8.4.rc3
