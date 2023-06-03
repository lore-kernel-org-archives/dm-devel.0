Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBA0C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685806520;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NAT+nHl9cQd9cc0k9mf5hhgd9kRdqp6nQuCPPAxRU/U=;
	b=ga8fxwULEP9LMn4gc9/g4Hs+P882iF0obOq4UgGH2Rhmfu+l2Pqy43+ZRcB8+c5e4O3tl3
	ADzYV3vlM16RJ51jXoYFawPZH18N51LNxGDFUb3orogNZpqZCbwtBM41V+BTqC6QzkB10w
	7RG3lJQ0TJve03tqLqt0jmFSkijaI2k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-iP5vRjp8MnqCSl49YCk6Rw-1; Sat, 03 Jun 2023 11:35:19 -0400
X-MC-Unique: iP5vRjp8MnqCSl49YCk6Rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 071668039B6;
	Sat,  3 Jun 2023 15:35:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E78CB407DEC0;
	Sat,  3 Jun 2023 15:35:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1E171946F00;
	Sat,  3 Jun 2023 15:35:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E99A91946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CACCB40C6CCC; Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C414540C6EC4
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA74E101A53A
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 15:35:12 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-8VpHfR0fMf6oPGGaS13FYg-4; Sat, 03 Jun 2023 11:35:10 -0400
X-MC-Unique: 8VpHfR0fMf6oPGGaS13FYg-4
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="356097509"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="356097509"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Jun 2023 08:35:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10730"; a="702274278"
X-IronPort-AV: E=Sophos;i="6.00,216,1681196400"; d="scan'208";a="702274278"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga007.jf.intel.com with ESMTP; 03 Jun 2023 08:35:08 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Sat,  3 Jun 2023 08:22:25 -0700
Message-Id: <20230603152227.12335-11-chang.seok.bae@intel.com>
In-Reply-To: <20230603152227.12335-1-chang.seok.bae@intel.com>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v8 10/12] crypto: x86/aesni - Use the proper data
 type in struct aesni_xts_ctx
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: x86@kernel.org, herbert@gondor.apana.org.au,
 "David S. Miller" <davem@davemloft.net>, ardb@kernel.org,
 chang.seok.bae@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, Ingo Molnar <mingo@redhat.com>,
 bp@alien8.de, charishma1.gairuboyina@intel.com, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Every field in struct aesni_xts_ctx is a pointer to a byte array. Each
array has a size of struct crypto_aes_ctx. Then, the field can be
redefined as that struct type instead of the obscure pointer.

Subsequently, the address to struct aesni_xts_ctx should be aligned
right away rather than on every access to the field.

Thus, redefine struct aesni_xts_ctx, and align its address on the
front. This draws a rework by refactoring the common alignment code.

Then, the refactored code itself appears to be useful to simplify
the overall runtime alignment. So, use it for other modes.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v7:
* Massage the helper function to be usable for other alignment code
  such as aesni_rfc4106_gcm_ctx_get() and generic_gcmaes_ctx_get().
  (Eric Biggers)

Changes from v6:
* Add as a new patch. (Eric Biggers)

This fix was considered to be better addressed before the preparatory
AES-NI code rework.
---
 arch/x86/crypto/aesni-intel_glue.c | 51 +++++++++++++++---------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a5b0cb3efeba..589648142c17 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -61,8 +61,8 @@ struct generic_gcmaes_ctx {
 };
 
 struct aesni_xts_ctx {
-	u8 raw_tweak_ctx[sizeof(struct crypto_aes_ctx)] AESNI_ALIGN_ATTR;
-	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx)] AESNI_ALIGN_ATTR;
+	struct crypto_aes_ctx tweak_ctx AESNI_ALIGN_ATTR;
+	struct crypto_aes_ctx crypt_ctx AESNI_ALIGN_ATTR;
 };
 
 #define GCM_BLOCK_LEN 16
@@ -80,6 +80,13 @@ struct gcm_context_data {
 	u8 hash_keys[GCM_BLOCK_LEN * 16];
 };
 
+static inline void *aes_align_addr(void *addr)
+{
+	if (crypto_tfm_ctx_alignment() >= AESNI_ALIGN)
+		return addr;
+	return PTR_ALIGN(addr, AESNI_ALIGN);
+}
+
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
 asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
@@ -201,32 +208,24 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(gcm_use_avx2);
 static inline struct
 aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
 {
-	unsigned long align = AESNI_ALIGN;
-
-	if (align <= crypto_tfm_ctx_alignment())
-		align = 1;
-	return PTR_ALIGN(crypto_aead_ctx(tfm), align);
+	return (struct aesni_rfc4106_gcm_ctx *)aes_align_addr(crypto_aead_ctx(tfm));
 }
 
 static inline struct
 generic_gcmaes_ctx *generic_gcmaes_ctx_get(struct crypto_aead *tfm)
 {
-	unsigned long align = AESNI_ALIGN;
-
-	if (align <= crypto_tfm_ctx_alignment())
-		align = 1;
-	return PTR_ALIGN(crypto_aead_ctx(tfm), align);
+	return (struct generic_gcmaes_ctx *)aes_align_addr(crypto_aead_ctx(tfm));
 }
 #endif
 
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
-	unsigned long addr = (unsigned long)raw_ctx;
-	unsigned long align = AESNI_ALIGN;
+	return (struct crypto_aes_ctx *)aes_align_addr(raw_ctx);
+}
 
-	if (align <= crypto_tfm_ctx_alignment())
-		align = 1;
-	return (struct crypto_aes_ctx *)ALIGN(addr, align);
+static inline struct aesni_xts_ctx *aes_xts_ctx(struct crypto_skcipher *tfm)
+{
+	return (struct aesni_xts_ctx *)aes_align_addr(crypto_skcipher_ctx(tfm));
 }
 
 static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
@@ -883,7 +882,7 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
-	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
 	int err;
 
 	err = xts_verify_key(tfm, key, keylen);
@@ -893,20 +892,20 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	keylen /= 2;
 
 	/* first half of xts-key is for crypt */
-	err = aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx,
+	err = aes_set_key_common(crypto_skcipher_tfm(tfm), &ctx->crypt_ctx,
 				 key, keylen);
 	if (err)
 		return err;
 
 	/* second half of xts-key is for tweak */
-	return aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx,
+	return aes_set_key_common(crypto_skcipher_tfm(tfm), &ctx->tweak_ctx,
 				  key + keylen, keylen);
 }
 
 static int xts_crypt(struct skcipher_request *req, bool encrypt)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
 	int tail = req->cryptlen % AES_BLOCK_SIZE;
 	struct skcipher_request subreq;
 	struct skcipher_walk walk;
@@ -942,7 +941,7 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 	kernel_fpu_begin();
 
 	/* calculate first value of T */
-	aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
+	aesni_enc(&ctx->tweak_ctx, walk.iv, walk.iv);
 
 	while (walk.nbytes > 0) {
 		int nbytes = walk.nbytes;
@@ -951,11 +950,11 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 			nbytes &= ~(AES_BLOCK_SIZE - 1);
 
 		if (encrypt)
-			aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
+			aesni_xts_encrypt(&ctx->crypt_ctx,
 					  walk.dst.virt.addr, walk.src.virt.addr,
 					  nbytes, walk.iv);
 		else
-			aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
+			aesni_xts_decrypt(&ctx->crypt_ctx,
 					  walk.dst.virt.addr, walk.src.virt.addr,
 					  nbytes, walk.iv);
 		kernel_fpu_end();
@@ -983,11 +982,11 @@ static int xts_crypt(struct skcipher_request *req, bool encrypt)
 
 		kernel_fpu_begin();
 		if (encrypt)
-			aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
+			aesni_xts_encrypt(&ctx->crypt_ctx,
 					  walk.dst.virt.addr, walk.src.virt.addr,
 					  walk.nbytes, walk.iv);
 		else
-			aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
+			aesni_xts_decrypt(&ctx->crypt_ctx,
 					  walk.dst.virt.addr, walk.src.virt.addr,
 					  walk.nbytes, walk.iv);
 		kernel_fpu_end();
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

