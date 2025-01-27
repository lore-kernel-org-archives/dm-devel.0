Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7017134D4;
	Mon, 27 Jan 2025 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016168; cv=none; b=AVSk9Owqmlto96EmBEEPl4vnPuVdGm3Sw6IGyeD+V8nC6myscy+rogFzNssKkqnP9KkQm6K3/p5Zu1v1GQbop7fb7GveApB6uGlSR56sF5Tw0Jb1OU8aRPKVLxs/0pDIe6oy8TuXx88DJU/Uj79CIkbQP+LaDYFpfXN1tkdkeCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016168; c=relaxed/simple;
	bh=K6c1om5w3IYKgGKZqHjx+AgeGT5ms3TVZSTf1hSeH3o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=it0DV7fJd0wZUqLftfO/PxgCh3vP8f6UJIXvFcETlN908GeH6+GxVVCSXkwENWHT2HN6l3BdVDXTixYiwDewDZDzJq1CKnclY4w2cAhK+ZmkG6DNVMYOTxljTixOP9jhed9MMbaF87Z0T/sL6LA2N0vEkOOyNKqE3ZDfYAb6Ab4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbpEj4XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbpEj4XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403F3C4CED2;
	Mon, 27 Jan 2025 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738016168;
	bh=K6c1om5w3IYKgGKZqHjx+AgeGT5ms3TVZSTf1hSeH3o=;
	h=From:To:Cc:Subject:Date:From;
	b=dbpEj4XEs3eUwCR41h26okupNUVvRypuwxdy5wxIra2Ncg2CJ9EWd3h23Xt/5fQQS
	 EuMSjLojebO9hM70FdzITnsLex9QLvM2wCUamzP2HgD55jk1q6R/QaLTSLFAAs4Hnx
	 5wW6suGQCQFMRy3hk5g538xYYxRF1dQ2YBKDY55rKH555sfWy4eKg3MnCX9Gpfzza3
	 rQJ+B3AMCG5Gag3hZoBPo9u0LFDfjSX21VYh1dhjGSbtd7/Q6FfNXd1QAoPsiYBgHz
	 +94E7VbL/oeUs6R23enRwYVKS1OnfJvYiAORqxLOzCnfY3iBHB6kuiDFXemfxWxCYF
	 +yQah0vd3tSKQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dm-crypt: switch to using the crc32 library
Date: Mon, 27 Jan 2025 14:15:33 -0800
Message-ID: <20250127221533.58298-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Now that the crc32() library function takes advantage of
architecture-specific optimizations, it is unnecessary to go through the
crypto API.  Just use crc32().  This is much simpler, and it improves
performance due to eliminating the crypto API overhead.  (However, this
only affects the TCW IV mode of dm-crypt, which is a compatibility mode
that is rarely used compared to other dm-crypt modes.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/Kconfig    |  1 +
 drivers/md/dm-crypt.c | 41 ++++++++++-------------------------------
 2 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0b1870a09e1fd..06f809e70f153 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -265,10 +265,11 @@ config DM_UNSTRIPED
 config DM_CRYPT
 	tristate "Crypt target support"
 	depends on BLK_DEV_DM
 	depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
 	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
+	select CRC32
 	select CRYPTO
 	select CRYPTO_CBC
 	select CRYPTO_ESSIV
 	help
 	  This device-mapper target allows you to create a device that
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1ae2c71bb383b..c726cddd310c8 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -15,10 +15,11 @@
 #include <linux/kernel.h>
 #include <linux/key.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
+#include <linux/crc32.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/crypto.h>
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
@@ -122,11 +123,10 @@ struct iv_lmk_private {
 	u8 *seed;
 };
 
 #define TCW_WHITENING_SIZE 16
 struct iv_tcw_private {
-	struct crypto_shash *crc32_tfm;
 	u8 *iv_seed;
 	u8 *whitening;
 };
 
 #define ELEPHANT_MAX_KEY_SIZE 32
@@ -604,14 +604,10 @@ static void crypt_iv_tcw_dtr(struct crypt_config *cc)
 
 	kfree_sensitive(tcw->iv_seed);
 	tcw->iv_seed = NULL;
 	kfree_sensitive(tcw->whitening);
 	tcw->whitening = NULL;
-
-	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
-		crypto_free_shash(tcw->crc32_tfm);
-	tcw->crc32_tfm = NULL;
 }
 
 static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
 			    const char *opts)
 {
@@ -625,17 +621,10 @@ static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
 	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
 		ti->error = "Wrong key size for TCW";
 		return -EINVAL;
 	}
 
-	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0,
-					    CRYPTO_ALG_ALLOCATES_MEMORY);
-	if (IS_ERR(tcw->crc32_tfm)) {
-		ti->error = "Error initializing CRC32 in TCW";
-		return PTR_ERR(tcw->crc32_tfm);
-	}
-
 	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
 	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
 	if (!tcw->iv_seed || !tcw->whitening) {
 		crypt_iv_tcw_dtr(cc);
 		ti->error = "Error allocating seed storage in TCW";
@@ -665,85 +654,75 @@ static int crypt_iv_tcw_wipe(struct crypt_config *cc)
 	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
 
 	return 0;
 }
 
-static int crypt_iv_tcw_whitening(struct crypt_config *cc,
-				  struct dm_crypt_request *dmreq,
-				  u8 *data)
+static void crypt_iv_tcw_whitening(struct crypt_config *cc,
+				   struct dm_crypt_request *dmreq, u8 *data)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 	__le64 sector = cpu_to_le64(dmreq->iv_sector);
 	u8 buf[TCW_WHITENING_SIZE];
-	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
-	int i, r;
+	int i;
 
 	/* xor whitening with sector number */
 	crypto_xor_cpy(buf, tcw->whitening, (u8 *)&sector, 8);
 	crypto_xor_cpy(&buf[8], tcw->whitening + 8, (u8 *)&sector, 8);
 
 	/* calculate crc32 for every 32bit part and xor it */
-	desc->tfm = tcw->crc32_tfm;
-	for (i = 0; i < 4; i++) {
-		r = crypto_shash_digest(desc, &buf[i * 4], 4, &buf[i * 4]);
-		if (r)
-			goto out;
-	}
+	for (i = 0; i < 4; i++)
+		put_unaligned_le32(crc32(0, &buf[i * 4], 4), &buf[i * 4]);
 	crypto_xor(&buf[0], &buf[12], 4);
 	crypto_xor(&buf[4], &buf[8], 4);
 
 	/* apply whitening (8 bytes) to whole sector */
 	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
 		crypto_xor(data + i * 8, buf, 8);
-out:
 	memzero_explicit(buf, sizeof(buf));
-	return r;
 }
 
 static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
 	struct scatterlist *sg;
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 	__le64 sector = cpu_to_le64(dmreq->iv_sector);
 	u8 *src;
-	int r = 0;
 
 	/* Remove whitening from ciphertext */
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
 		sg = crypt_get_sg_data(cc, dmreq->sg_in);
 		src = kmap_local_page(sg_page(sg));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
+		crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
 		kunmap_local(src);
 	}
 
 	/* Calculate IV */
 	crypto_xor_cpy(iv, tcw->iv_seed, (u8 *)&sector, 8);
 	if (cc->iv_size > 8)
 		crypto_xor_cpy(&iv[8], tcw->iv_seed + 8, (u8 *)&sector,
 			       cc->iv_size - 8);
 
-	return r;
+	return 0;
 }
 
 static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 			     struct dm_crypt_request *dmreq)
 {
 	struct scatterlist *sg;
 	u8 *dst;
-	int r;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
 		return 0;
 
 	/* Apply whitening on ciphertext */
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
 	dst = kmap_local_page(sg_page(sg));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
+	crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
 	kunmap_local(dst);
 
-	return r;
+	return 0;
 }
 
 static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
 				struct dm_crypt_request *dmreq)
 {

base-commit: 805ba04cb7ccfc7d72e834ebd796e043142156ba
-- 
2.48.1

