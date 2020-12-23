Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3DCC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DC352068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DC352068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-A0UAWc98P9mQm-qEtrc1UQ-1; Mon, 04 Jan 2021 14:03:33 -0500
X-MC-Unique: A0UAWc98P9mQm-qEtrc1UQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79CB9107ACF6;
	Mon,  4 Jan 2021 19:03:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C0CA6F924;
	Mon,  4 Jan 2021 19:03:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 297181809CA1;
	Mon,  4 Jan 2021 19:03:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BNMlwpZ014939 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 17:47:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 39AF71134CD1; Wed, 23 Dec 2020 22:47:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33E121134CC8
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 22:47:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6F38811E84
	for <dm-devel@redhat.com>; Wed, 23 Dec 2020 22:47:57 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-158-VPwwyay_MnmVZ2uGDwx_6g-1;
	Wed, 23 Dec 2020 17:47:55 -0500
X-MC-Unique: VPwwyay_MnmVZ2uGDwx_6g-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 453E92253A;
	Wed, 23 Dec 2020 22:39:20 +0000 (UTC)
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Date: Wed, 23 Dec 2020 23:38:40 +0100
Message-Id: <20201223223841.11311-10-ardb@kernel.org>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:11 -0500
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
	Milan Broz <gmazyland@gmail.com>, Megha Dey <megha.dey@intel.com>
Subject: [dm-devel] [RFC PATCH 09/10] crypto: x86/twofish - drop CTR mode
	implementation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Twofish in CTR mode is never used by the kernel directly, and is highly
unlikely to be relied upon by dm-crypt or algif_skcipher. So let's drop
the accelerated CTR mode implementation, and instead, rely on the CTR
template and the bare cipher.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S | 27 --------
 arch/x86/crypto/twofish_avx_glue.c          | 38 -----------
 arch/x86/crypto/twofish_glue_3way.c         | 72 --------------------
 arch/x86/include/asm/crypto/twofish.h       |  4 --
 4 files changed, 141 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index 84e61ef03638..37e63b3c664e 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -374,30 +374,3 @@ SYM_FUNC_START(twofish_cbc_dec_8way)
 	FRAME_END
 	ret;
 SYM_FUNC_END(twofish_cbc_dec_8way)
-
-SYM_FUNC_START(twofish_ctr_8way)
-	/* input:
-	 *	%rdi: ctx, CTX
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (little endian, 128bit)
-	 */
-	FRAME_BEGIN
-
-	pushq %r12;
-
-	movq %rsi, %r11;
-	movq %rdx, %r12;
-
-	load_ctr_8way(%rcx, .Lbswap128_mask, RA1, RB1, RC1, RD1, RA2, RB2, RC2,
-		      RD2, RX0, RX1, RY0);
-
-	call __twofish_enc_blk8;
-
-	store_ctr_8way(%r12, %r11, RC1, RD1, RA1, RB1, RC2, RD2, RA2, RB2);
-
-	popq %r12;
-
-	FRAME_END
-	ret;
-SYM_FUNC_END(twofish_ctr_8way)
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 7b539bbb108f..13f810b61034 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -25,8 +25,6 @@ asmlinkage void twofish_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void twofish_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void twofish_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
-asmlinkage void twofish_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
-				 le128 *iv);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -55,22 +53,6 @@ static const struct common_glue_ctx twofish_enc = {
 	} }
 };
 
-static const struct common_glue_ctx twofish_ctr = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = twofish_ctr_8way }
-	}, {
-		.num_blocks = 3,
-		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = twofish_enc_blk_ctr }
-	} }
-};
-
 static const struct common_glue_ctx twofish_dec = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
@@ -123,11 +105,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&twofish_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&twofish_ctr, req);
-}
-
 static struct skcipher_alg twofish_algs[] = {
 	{
 		.base.cra_name		= "__ecb(twofish)",
@@ -156,21 +133,6 @@ static struct skcipher_alg twofish_algs[] = {
 		.setkey			= twofish_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "__ctr(twofish)",
-		.base.cra_driver_name	= "__ctr-twofish-avx",
-		.base.cra_priority	= 400,
-		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= TF_MIN_KEY_SIZE,
-		.max_keysize		= TF_MAX_KEY_SIZE,
-		.ivsize			= TF_BLOCK_SIZE,
-		.chunksize		= TF_BLOCK_SIZE,
-		.setkey			= twofish_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 768af6075479..b70f757403a3 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -52,46 +52,6 @@ void twofish_dec_blk_cbc_3way(const void *ctx, u8 *d, const u8 *s)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblk;
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	if (dst != src)
-		*dst = *src;
-
-	le128_to_be128(&ctrblk, iv);
-	le128_inc(iv);
-
-	twofish_enc_blk(ctx, (u8 *)&ctrblk, (u8 *)&ctrblk);
-	u128_xor(dst, dst, (u128 *)&ctrblk);
-}
-EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
-
-void twofish_enc_blk_ctr_3way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
-{
-	be128 ctrblks[3];
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	if (dst != src) {
-		dst[0] = src[0];
-		dst[1] = src[1];
-		dst[2] = src[2];
-	}
-
-	le128_to_be128(&ctrblks[0], iv);
-	le128_inc(iv);
-	le128_to_be128(&ctrblks[1], iv);
-	le128_inc(iv);
-	le128_to_be128(&ctrblks[2], iv);
-	le128_inc(iv);
-
-	twofish_enc_blk_xor_3way(ctx, (u8 *)dst, (u8 *)ctrblks);
-}
-EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr_3way);
-
 static const struct common_glue_ctx twofish_enc = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = -1,
@@ -105,19 +65,6 @@ static const struct common_glue_ctx twofish_enc = {
 	} }
 };
 
-static const struct common_glue_ctx twofish_ctr = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 3,
-		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ctr = twofish_enc_blk_ctr }
-	} }
-};
-
 static const struct common_glue_ctx twofish_dec = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = -1,
@@ -164,11 +111,6 @@ static int cbc_decrypt(struct skcipher_request *req)
 	return glue_cbc_decrypt_req_128bit(&twofish_dec_cbc, req);
 }
 
-static int ctr_crypt(struct skcipher_request *req)
-{
-	return glue_ctr_req_128bit(&twofish_ctr, req);
-}
-
 static struct skcipher_alg tf_skciphers[] = {
 	{
 		.base.cra_name		= "ecb(twofish)",
@@ -195,20 +137,6 @@ static struct skcipher_alg tf_skciphers[] = {
 		.setkey			= twofish_setkey_skcipher,
 		.encrypt		= cbc_encrypt,
 		.decrypt		= cbc_decrypt,
-	}, {
-		.base.cra_name		= "ctr(twofish)",
-		.base.cra_driver_name	= "ctr-twofish-3way",
-		.base.cra_priority	= 300,
-		.base.cra_blocksize	= 1,
-		.base.cra_ctxsize	= sizeof(struct twofish_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= TF_MIN_KEY_SIZE,
-		.max_keysize		= TF_MAX_KEY_SIZE,
-		.ivsize			= TF_BLOCK_SIZE,
-		.chunksize		= TF_BLOCK_SIZE,
-		.setkey			= twofish_setkey_skcipher,
-		.encrypt		= ctr_crypt,
-		.decrypt		= ctr_crypt,
 	},
 };
 
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index 2c377a8042e1..12df400e6d53 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -17,9 +17,5 @@ asmlinkage void twofish_dec_blk_3way(const void *ctx, u8 *dst, const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src);
-extern void twofish_enc_blk_ctr(const void *ctx, u8 *dst, const u8 *src,
-				le128 *iv);
-extern void twofish_enc_blk_ctr_3way(const void *ctx, u8 *dst, const u8 *src,
-				     le128 *iv);
 
 #endif /* ASM_X86_TWOFISH_H */
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

