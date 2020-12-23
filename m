Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADE4C433E9
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7D03C2068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D03C2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-y7Rzb9jCO-eDgZZbHf12TA-1; Mon, 04 Jan 2021 14:04:06 -0500
X-MC-Unique: y7Rzb9jCO-eDgZZbHf12TA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 319DB9CC22;
	Mon,  4 Jan 2021 19:03:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11BDA27C47;
	Mon,  4 Jan 2021 19:03:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DE6135003F;
	Mon,  4 Jan 2021 19:03:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNMm0wt014972 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 17:48:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F0247A34FB; Wed, 23 Dec 2020 22:47:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E99CF9D51
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 22:47:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E538185A794
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 22:47:57 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-128-3VEnpJhfO8OtdErdLCcFGQ-1;
	Wed, 23 Dec 2020 17:47:55 -0500
X-MC-Unique: 3VEnpJhfO8OtdErdLCcFGQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8543C2255F;
	Wed, 23 Dec 2020 22:39:23 +0000 (UTC)
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Date: Wed, 23 Dec 2020 23:38:41 +0100
Message-Id: <20201223223841.11311-11-ardb@kernel.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:11 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Milan Broz <gmazyland@gmail.com>, Megha Dey <megha.dey@intel.com>
Subject: [dm-devel] [RFC PATCH 10/10] crypto: x86/glue-helper - drop CTR
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The glue helper's CTR routines are no longer used, so drop them.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/glue_helper-asm-avx.S     | 45 ------------
 arch/x86/crypto/glue_helper-asm-avx2.S    | 58 ----------------
 arch/x86/crypto/glue_helper.c             | 72 --------------------
 arch/x86/include/asm/crypto/glue_helper.h | 32 ---------
 4 files changed, 207 deletions(-)

diff --git a/arch/x86/crypto/glue_helper-asm-avx.S b/arch/x86/crypto/glue_helper-asm-avx.S
index a94511432803..3da385271227 100644
--- a/arch/x86/crypto/glue_helper-asm-avx.S
+++ b/arch/x86/crypto/glue_helper-asm-avx.S
@@ -34,48 +34,3 @@
 	vpxor (5*16)(src), x6, x6; \
 	vpxor (6*16)(src), x7, x7; \
 	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define inc_le128(x, minus_one, tmp) \
-	vpcmpeqq minus_one, x, tmp; \
-	vpsubq minus_one, x, x; \
-	vpslldq $8, tmp, tmp; \
-	vpsubq tmp, x, x;
-
-#define load_ctr_8way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t1, t2) \
-	vpcmpeqd t0, t0, t0; \
-	vpsrldq $8, t0, t0; /* low: -1, high: 0 */ \
-	vmovdqa bswap, t1; \
-	\
-	/* load IV and byteswap */ \
-	vmovdqu (iv), x7; \
-	vpshufb t1, x7, x0; \
-	\
-	/* construct IVs */ \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x1; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x2; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x3; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x4; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x5; \
-	inc_le128(x7, t0, t2); \
-	vpshufb t1, x7, x6; \
-	inc_le128(x7, t0, t2); \
-	vmovdqa x7, t2; \
-	vpshufb t1, x7, x7; \
-	inc_le128(t2, t0, t1); \
-	vmovdqu t2, (iv);
-
-#define store_ctr_8way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*16)(src), x0, x0; \
-	vpxor (1*16)(src), x1, x1; \
-	vpxor (2*16)(src), x2, x2; \
-	vpxor (3*16)(src), x3, x3; \
-	vpxor (4*16)(src), x4, x4; \
-	vpxor (5*16)(src), x5, x5; \
-	vpxor (6*16)(src), x6, x6; \
-	vpxor (7*16)(src), x7, x7; \
-	store_8way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper-asm-avx2.S b/arch/x86/crypto/glue_helper-asm-avx2.S
index 456bface1e5d..c77e9049431f 100644
--- a/arch/x86/crypto/glue_helper-asm-avx2.S
+++ b/arch/x86/crypto/glue_helper-asm-avx2.S
@@ -37,61 +37,3 @@
 	vpxor (5*32+16)(src), x6, x6; \
 	vpxor (6*32+16)(src), x7, x7; \
 	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
-
-#define inc_le128(x, minus_one, tmp) \
-	vpcmpeqq minus_one, x, tmp; \
-	vpsubq minus_one, x, x; \
-	vpslldq $8, tmp, tmp; \
-	vpsubq tmp, x, x;
-
-#define add2_le128(x, minus_one, minus_two, tmp1, tmp2) \
-	vpcmpeqq minus_one, x, tmp1; \
-	vpcmpeqq minus_two, x, tmp2; \
-	vpsubq minus_two, x, x; \
-	vpor tmp2, tmp1, tmp1; \
-	vpslldq $8, tmp1, tmp1; \
-	vpsubq tmp1, x, x;
-
-#define load_ctr_16way(iv, bswap, x0, x1, x2, x3, x4, x5, x6, x7, t0, t0x, t1, \
-		       t1x, t2, t2x, t3, t3x, t4, t5) \
-	vpcmpeqd t0, t0, t0; \
-	vpsrldq $8, t0, t0; /* ab: -1:0 ; cd: -1:0 */ \
-	vpaddq t0, t0, t4; /* ab: -2:0 ; cd: -2:0 */\
-	\
-	/* load IV and byteswap */ \
-	vmovdqu (iv), t2x; \
-	vmovdqa t2x, t3x; \
-	inc_le128(t2x, t0x, t1x); \
-	vbroadcasti128 bswap, t1; \
-	vinserti128 $1, t2x, t3, t2; /* ab: le0 ; cd: le1 */ \
-	vpshufb t1, t2, x0; \
-	\
-	/* construct IVs */ \
-	add2_le128(t2, t0, t4, t3, t5); /* ab: le2 ; cd: le3 */ \
-	vpshufb t1, t2, x1; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x2; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x3; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x4; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x5; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x6; \
-	add2_le128(t2, t0, t4, t3, t5); \
-	vpshufb t1, t2, x7; \
-	vextracti128 $1, t2, t2x; \
-	inc_le128(t2x, t0x, t3x); \
-	vmovdqu t2x, (iv);
-
-#define store_ctr_16way(src, dst, x0, x1, x2, x3, x4, x5, x6, x7) \
-	vpxor (0*32)(src), x0, x0; \
-	vpxor (1*32)(src), x1, x1; \
-	vpxor (2*32)(src), x2, x2; \
-	vpxor (3*32)(src), x3, x3; \
-	vpxor (4*32)(src), x4, x4; \
-	vpxor (5*32)(src), x5, x5; \
-	vpxor (6*32)(src), x6, x6; \
-	vpxor (7*32)(src), x7, x7; \
-	store_16way(dst, x0, x1, x2, x3, x4, x5, x6, x7);
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 786ffda1caf4..895d34150c3f 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -6,8 +6,6 @@
  *
  * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
  *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- * CTR part based on code (crypto/ctr.c) by:
- *   (C) Copyright IBM Corp. 2007 - Joy Latten <latten@us.ibm.com>
  */
 
 #include <linux/module.h>
@@ -154,74 +152,4 @@ int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_cbc_decrypt_req_128bit);
 
-int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
-			struct skcipher_request *req)
-{
-	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_walk walk;
-	bool fpu_enabled = false;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes) >= bsize) {
-		const u128 *src = walk.src.virt.addr;
-		u128 *dst = walk.dst.virt.addr;
-		unsigned int func_bytes, num_blocks;
-		unsigned int i;
-		le128 ctrblk;
-
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     &walk, fpu_enabled, nbytes);
-
-		be128_to_le128(&ctrblk, (be128 *)walk.iv);
-
-		for (i = 0; i < gctx->num_funcs; i++) {
-			num_blocks = gctx->funcs[i].num_blocks;
-			func_bytes = bsize * num_blocks;
-
-			if (nbytes < func_bytes)
-				continue;
-
-			/* Process multi-block batch */
-			do {
-				gctx->funcs[i].fn_u.ctr(ctx, (u8 *)dst,
-							(const u8 *)src,
-							&ctrblk);
-				src += num_blocks;
-				dst += num_blocks;
-				nbytes -= func_bytes;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				break;
-		}
-
-		le128_to_be128((be128 *)walk.iv, &ctrblk);
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-
-	if (nbytes) {
-		le128 ctrblk;
-		u128 tmp;
-
-		be128_to_le128(&ctrblk, (be128 *)walk.iv);
-		memcpy(&tmp, walk.src.virt.addr, nbytes);
-		gctx->funcs[gctx->num_funcs - 1].fn_u.ctr(ctx, (u8 *)&tmp,
-							  (const u8 *)&tmp,
-							  &ctrblk);
-		memcpy(walk.dst.virt.addr, &tmp, nbytes);
-		le128_to_be128((be128 *)walk.iv, &ctrblk);
-
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_ctr_req_128bit);
-
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 62680775d189..23e09efd2aa6 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -9,19 +9,15 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <asm/fpu/api.h>
-#include <crypto/b128ops.h>
 
 typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
 typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
-				       le128 *iv);
 
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
 		common_glue_func_t ecb;
 		common_glue_cbc_func_t cbc;
-		common_glue_ctr_func_t ctr;
 	} fn_u;
 };
 
@@ -66,31 +62,6 @@ static inline void glue_fpu_end(bool fpu_enabled)
 		kernel_fpu_end();
 }
 
-static inline void le128_to_be128(be128 *dst, const le128 *src)
-{
-	dst->a = cpu_to_be64(le64_to_cpu(src->a));
-	dst->b = cpu_to_be64(le64_to_cpu(src->b));
-}
-
-static inline void be128_to_le128(le128 *dst, const be128 *src)
-{
-	dst->a = cpu_to_le64(be64_to_cpu(src->a));
-	dst->b = cpu_to_le64(be64_to_cpu(src->b));
-}
-
-static inline void le128_inc(le128 *i)
-{
-	u64 a = le64_to_cpu(i->a);
-	u64 b = le64_to_cpu(i->b);
-
-	b++;
-	if (!b)
-		a++;
-
-	i->a = cpu_to_le64(a);
-	i->b = cpu_to_le64(b);
-}
-
 extern int glue_ecb_req_128bit(const struct common_glue_ctx *gctx,
 			       struct skcipher_request *req);
 
@@ -100,7 +71,4 @@ extern int glue_cbc_encrypt_req_128bit(const common_glue_func_t fn,
 extern int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 				       struct skcipher_request *req);
 
-extern int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
-			       struct skcipher_request *req);
-
 #endif /* _CRYPTO_GLUE_HELPER_H */
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

