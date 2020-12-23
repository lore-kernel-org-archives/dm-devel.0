Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9A9C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 803862068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 803862068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-1-Gq60KUMDm5k4Phh5MBZg-1; Mon, 04 Jan 2021 14:04:17 -0500
X-MC-Unique: 1-Gq60KUMDm5k4Phh5MBZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3463F801B1A;
	Mon,  4 Jan 2021 19:03:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12FCB6A8E6;
	Mon,  4 Jan 2021 19:03:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D43B21809CB9;
	Mon,  4 Jan 2021 19:03:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNMm0Uk014986 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 17:48:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4D05D2166B2F; Wed, 23 Dec 2020 22:48:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45D922166B2B
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 22:47:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6582858280
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 22:47:57 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-133-CWZyzHZyPUW8fTFxbnOFEA-1;
	Wed, 23 Dec 2020 17:47:53 -0500
X-MC-Unique: CWZyzHZyPUW8fTFxbnOFEA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0974C22510;
	Wed, 23 Dec 2020 22:39:10 +0000 (UTC)
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Date: Wed, 23 Dec 2020 23:38:36 +0100
Message-Id: <20201223223841.11311-6-ardb@kernel.org>
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
References: <20201223223841.11311-1-ardb@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:11 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Milan Broz <gmazyland@gmail.com>, Megha Dey <megha.dey@intel.com>
Subject: [dm-devel] [RFC PATCH 05/10] crypto: x86/glue-helper - drop XTS
	helper routines
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The glue helper's XTS routines are no longer used, so drop them.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/glue_helper-asm-avx.S     |  59 --------
 arch/x86/crypto/glue_helper-asm-avx2.S    |  78 ----------
 arch/x86/crypto/glue_helper.c             | 154 --------------------
 arch/x86/include/asm/crypto/glue_helper.h |  12 --
 4 files changed, 303 deletions(-)

diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/glue_helper-asm-avx.S
index d08fc575ef7f..a94511432803 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -79,62 +79,3 @@
 	vpxor (6*16)(src), x6, x6; \
 	vpxor (7*16)(src), x7, x7; \
 	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define gf128mul_x_ble(iv, mask, tmp) \
-	vpsrad $31, iv, tmp; \
-	vpaddq iv, iv, iv; \
-	vpshufd $0x13, tmp, tmp; \
-	vpand mask, tmp, tmp; \
-	vpxor tmp, iv, iv;
-
-#define load_xts_8way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, tiv, t0, \
-		      t1, xts_gf128mul_and_shl1_mask) \
-	vmovdqa xts_gf128mul_and_shl1_mask, t0; \
-	\
-	/* load IV */ \
-	vmovdqu (iv), tiv; \
-	vpxor (0*16)(src), tiv, x0; \
-	vmovdqu tiv, (0*16)(dst); \
-	\
-	/* construct and store IVs, also xor with source */ \
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (1*16)(src), tiv, x1; \
-	vmovdqu tiv, (1*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (2*16)(src), tiv, x2; \
-	vmovdqu tiv, (2*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (3*16)(src), tiv, x3; \
-	vmovdqu tiv, (3*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (4*16)(src), tiv, x4; \
-	vmovdqu tiv, (4*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (5*16)(src), tiv, x5; \
-	vmovdqu tiv, (5*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (6*16)(src), tiv, x6; \
-	vmovdqu tiv, (6*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vpxor (7*16)(src), tiv, x7; \
-	vmovdqu tiv, (7*16)(dst); \
-	\
-	gf128mul_x_ble(tiv, t0, t1); \
-	vmovdqu tiv, (iv);
-
-#define store_xts_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*16)(dst), x0, x0; \
-	vpxor (1*16)(dst), x1, x1; \
-	vpxor (2*16)(dst), x2, x2; \
-	vpxor (3*16)(dst), x3, x3; \
-	vpxor (4*16)(dst), x4, x4; \
-	vpxor (5*16)(dst), x5, x5; \
-	vpxor (6*16)(dst), x6, x6; \
-	vpxor (7*16)(dst), x7, x7; \
-	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper-asm-avx2.S b/arch/x86/crypto/glue_helper-asm-avx2.S
index d84508c85c13..456bface1e5d 100644
--- a/arch/x86/crypto/glue_helper-asm-avx2.S
+++ b/arch/x86/crypto/glue_helper-asm-avx2.S
@@ -95,81 +95,3 @@
 	vpxor (6*32)(src), x6, x6; \
 	vpxor (7*32)(src), x7, x7; \
 	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define gf128mul_x_ble(iv, mask, tmp) \
-	vpsrad $31, iv, tmp; \
-	vpaddq iv, iv, iv; \
-	vpshufd $0x13, tmp, tmp; \
-	vpand mask, tmp, tmp; \
-	vpxor tmp, iv, iv;
-
-#define gf128mul_x2_ble(iv, mask1, mask2, tmp0, tmp1) \
-	vpsrad $31, iv, tmp0; \
-	vpaddq iv, iv, tmp1; \
-	vpsllq $2, iv, iv; \
-	vpshufd $0x13, tmp0, tmp0; \
-	vpsrad $31, tmp1, tmp1; \
-	vpand mask2, tmp0, tmp0; \
-	vpshufd $0x13, tmp1, tmp1; \
-	vpxor tmp0, iv, iv; \
-	vpand mask1, tmp1, tmp1; \
-	vpxor tmp1, iv, iv;
-
-#define load_xts_16way(iv, src, dst, x0, x1, x2, x3, x4, x5, x6, x7, tiv, \
-		       tivx, t0, t0x, t1, t1x, t2, t2x, t3, \
-		       xts_gf128mul_and_shl1_mask_0, \
-		       xts_gf128mul_and_shl1_mask_1) \
-	vbroadcasti128 xts_gf128mul_and_shl1_mask_0, t1; \
-	\
-	/* load IV and construct second IV */ \
-	vmovdqu (iv), tivx; \
-	vmovdqa tivx, t0x; \
-	gf128mul_x_ble(tivx, t1x, t2x); \
-	vbroadcasti128 xts_gf128mul_and_shl1_mask_1, t2; \
-	vinserti128 $1, tivx, t0, tiv; \
-	vpxor (0*32)(src), tiv, x0; \
-	vmovdqu tiv, (0*32)(dst); \
-	\
-	/* construct and store IVs, also xor with source */ \
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (1*32)(src), tiv, x1; \
-	vmovdqu tiv, (1*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (2*32)(src), tiv, x2; \
-	vmovdqu tiv, (2*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (3*32)(src), tiv, x3; \
-	vmovdqu tiv, (3*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (4*32)(src), tiv, x4; \
-	vmovdqu tiv, (4*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (5*32)(src), tiv, x5; \
-	vmovdqu tiv, (5*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (6*32)(src), tiv, x6; \
-	vmovdqu tiv, (6*32)(dst); \
-	\
-	gf128mul_x2_ble(tiv, t1, t2, t0, t3); \
-	vpxor (7*32)(src), tiv, x7; \
-	vmovdqu tiv, (7*32)(dst); \
-	\
-	vextracti128 $1, tiv, tivx; \
-	gf128mul_x_ble(tivx, t1x, t2x); \
-	vmovdqu tivx, (iv);
-
-#define store_xts_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*32)(dst), x0, x0; \
-	vpxor (1*32)(dst), x1, x1; \
-	vpxor (2*32)(dst), x2, x2; \
-	vpxor (3*32)(dst), x3, x3; \
-	vpxor (4*32)(dst), x4, x4; \
-	vpxor (5*32)(dst), x5, x5; \
-	vpxor (6*32)(dst), x6, x6; \
-	vpxor (7*32)(dst), x7, x7; \
-	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index d3d91a0abf88..786ffda1caf4 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -12,10 +12,8 @@
 
 #include <linux/module.h>
 #include <crypto/b128ops.h>
-#include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 
 int glue_ecb_req_128bit(const struct common_glue_ctx *gctx,
@@ -226,156 +224,4 @@ int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_ctr_req_128bit);
 
-static unsigned int __glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-					  void *ctx,
-					  struct skcipher_walk *walk)
-{
-	const unsigned int bsize = 128 / 8;
-	unsigned int nbytes = walk->nbytes;
-	u128 *src = walk->src.virt.addr;
-	u128 *dst = walk->dst.virt.addr;
-	unsigned int num_blocks, func_bytes;
-	unsigned int i;
-
-	/* Process multi-block batch */
-	for (i = 0; i < gctx->num_funcs; i++) {
-		num_blocks = gctx->funcs[i].num_blocks;
-		func_bytes = bsize * num_blocks;
-
-		if (nbytes >= func_bytes) {
-			do {
-				gctx->funcs[i].fn_u.xts(ctx, (u8 *)dst,
-							(const u8 *)src,
-							walk->iv);
-
-				src += num_blocks;
-				dst += num_blocks;
-				nbytes -= func_bytes;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				goto done;
-		}
-	}
-
-done:
-	return nbytes;
-}
-
-int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-			struct skcipher_request *req,
-			common_glue_func_t tweak_fn, void *tweak_ctx,
-			void *crypt_ctx, bool decrypt)
-{
-	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_request subreq;
-	struct skcipher_walk walk;
-	bool fpu_enabled = false;
-	unsigned int nbytes, tail;
-	int err;
-
-	if (req->cryptlen < XTS_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (unlikely(cts)) {
-		struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-
-		tail = req->cryptlen % XTS_BLOCK_SIZE + XTS_BLOCK_SIZE;
-
-		skcipher_request_set_tfm(&subreq, tfm);
-		skcipher_request_set_callback(&subreq,
-					      crypto_skcipher_get_flags(tfm),
-					      NULL, NULL);
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   req->cryptlen - tail, req->iv);
-		req = &subreq;
-	}
-
-	err = skcipher_walk_virt(&walk, req, false);
-	nbytes = walk.nbytes;
-	if (err)
-		return err;
-
-	/* set minimum length to bsize, for tweak_fn */
-	fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-				     &walk, fpu_enabled,
-				     nbytes < bsize ? bsize : nbytes);
-
-	/* calculate first value of T */
-	tweak_fn(tweak_ctx, walk.iv, walk.iv);
-
-	while (nbytes) {
-		nbytes = __glue_xts_req_128bit(gctx, crypt_ctx, &walk);
-
-		err = skcipher_walk_done(&walk, nbytes);
-		nbytes = walk.nbytes;
-	}
-
-	if (unlikely(cts)) {
-		u8 *next_tweak, *final_tweak = req->iv;
-		struct scatterlist *src, *dst;
-		struct scatterlist s[2], d[2];
-		le128 b[2];
-
-		dst = src = scatterwalk_ffwd(s, req->src, req->cryptlen);
-		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(d, req->dst, req->cryptlen);
-
-		if (decrypt) {
-			next_tweak = memcpy(b, req->iv, XTS_BLOCK_SIZE);
-			gf128mul_x_ble(b, b);
-		} else {
-			next_tweak = req->iv;
-		}
-
-		skcipher_request_set_crypt(&subreq, src, dst, XTS_BLOCK_SIZE,
-					   next_tweak);
-
-		err = skcipher_walk_virt(&walk, req, false) ?:
-		      skcipher_walk_done(&walk,
-				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
-		if (err)
-			goto out;
-
-		scatterwalk_map_and_copy(b, dst, 0, XTS_BLOCK_SIZE, 0);
-		memcpy(b + 1, b, tail - XTS_BLOCK_SIZE);
-		scatterwalk_map_and_copy(b, src, XTS_BLOCK_SIZE,
-					 tail - XTS_BLOCK_SIZE, 0);
-		scatterwalk_map_and_copy(b, dst, 0, tail, 1);
-
-		skcipher_request_set_crypt(&subreq, dst, dst, XTS_BLOCK_SIZE,
-					   final_tweak);
-
-		err = skcipher_walk_virt(&walk, req, false) ?:
-		      skcipher_walk_done(&walk,
-				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
-	}
-
-out:
-	glue_fpu_end(fpu_enabled);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_xts_req_128bit);
-
-void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst, const u8 *src,
-			       le128 *iv, common_glue_func_t fn)
-{
-	le128 ivblk = *iv;
-
-	/* generate next IV */
-	gf128mul_x_ble(iv, &ivblk);
-
-	/* CC <- T xor C */
-	u128_xor((u128 *)dst, (const u128 *)src, (u128 *)&ivblk);
-
-	/* PP <- D(Key2,CC) */
-	fn(ctx, dst, dst);
-
-	/* P <- T xor PP */
-	u128_xor((u128 *)dst, (u128 *)dst, (u128 *)&ivblk);
-}
-EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit_one);
-
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 777c0f63418c..62680775d189 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -15,8 +15,6 @@ typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-typedef void (*common_glue_xts_func_t)(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
 
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
@@ -24,7 +22,6 @@ struct common_glue_func_entry {
 		common_glue_func_t ecb;
 		common_glue_cbc_func_t cbc;
 		common_glue_ctr_func_t ctr;
-		common_glue_xts_func_t xts;
 	} fn_u;
 };
 
@@ -106,13 +103,4 @@ extern int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 extern int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 			       struct skcipher_request *req);
 
-extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-			       struct skcipher_request *req,
-			       common_glue_func_t tweak_fn, void *tweak_ctx,
-			       void *crypt_ctx, bool decrypt);
-
-extern void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst,
-				      const u8 *src, le128 *iv,
-				      common_glue_func_t fn);
-
 #endif /* _CRYPTO_GLUE_HELPER_H */
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

