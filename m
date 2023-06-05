Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A359DC7EE2C
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 02:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685933207;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RStSP3KxdDHVAxCYhD+Wrt0sa354IZOopZfBYCgHR7w=;
	b=VFmh/V7jilhUAwiIiEViUYVaEJrhpC+OuTggdLw5W35UtmS4SOVaIDPNVFQt4dRPoGFZPd
	NZy/dcI/D7XpsbFsYgl7uazEIuEAI1ZELChSQYDuVmBN4fe6+n8n432JIty+44YO13+qnF
	FS0xxbPVwj5ihx4c+hXfjeg5YR5Hq5Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328--9_AtPrcOZuvHJ1TRSExBw-1; Sun, 04 Jun 2023 22:46:45 -0400
X-MC-Unique: -9_AtPrcOZuvHJ1TRSExBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 164BE8028B2;
	Mon,  5 Jun 2023 02:46:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3BEE02026E03;
	Mon,  5 Jun 2023 02:46:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5586219465A0;
	Mon,  5 Jun 2023 02:46:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AEB991946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 02:46:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BD9849BB98; Mon,  5 Jun 2023 02:46:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8388A400F5F
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 02:46:32 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DD49811E86
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 02:46:32 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-ke15hEnENveMwa6zL5PdCA-1; Sun, 04 Jun 2023 22:46:30 -0400
X-MC-Unique: ke15hEnENveMwa6zL5PdCA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8C392616BE;
 Mon,  5 Jun 2023 02:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE32C433EF;
 Mon,  5 Jun 2023 02:46:27 +0000 (UTC)
Date: Sun, 4 Jun 2023 19:46:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230605024623.GA4653@quark.localdomain>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-11-chang.seok.bae@intel.com>
 <20230604153434.GA1212@quark.localdomain>
 <0925dd9e-3588-38da-8dfb-0ac2ff568655@intel.com>
MIME-Version: 1.0
In-Reply-To: <0925dd9e-3588-38da-8dfb-0ac2ff568655@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v8 10/12] crypto: x86/aesni - Use the proper
 data type in struct aesni_xts_ctx
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
 dave.hansen@linux.intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, charishma1.gairuboyina@intel.com,
 mingo@kernel.org, lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, linux-crypto@vger.kernel.org,
 luto@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com,
 tglx@linutronix.de, nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jun 04, 2023 at 03:02:32PM -0700, Chang S. Bae wrote:
> On 6/4/2023 8:34 AM, Eric Biggers wrote:
> > 
> > To re-iterate what I said on v6, the runtime alignment to a 16-byte boundary
> > should happen when translating the raw crypto_skcipher_ctx() into the pointer to
> > the aes_xts_ctx.  It should not happen when accessing each individual field in
> > the aes_xts_ctx.
> > 
> > Yet, this code is still doing runtime alignment when accessing each individual
> > field, as the second argument to aes_set_key_common() is 'void *raw_ctx' which
> > aes_set_key_common() runtime-aligns to crypto_aes_ctx.
> > 
> > We should keep everything consistent, which means making aes_set_key_common()
> > take a pointer to crypto_aes_ctx and not do the runtime alignment.
> 
> Let me clarify what is the problem this patch tried to solve here. The
> current struct aesni_xts_ctx is ugly. So, the main story is let's fix it
> before using the code for AES-KL.
> 
> Then, the rework part may be applicable for code re-usability. That seems to
> be okay to do here.
> 
> Fixing the runtime alignment entirely seems to be touching other code than
> AES-XTS. Yes, that's ideal cleanup for consistency. But, it seems to be less
> relevant in this series.  I'd be happy to follow up on that improvement
> though.

IMO the issue is that your patch makes the code (including the XTS code)
inconsistent because it makes it use a mix of both approaches: it aligns each
field individually, *and* it aligns the ctx up-front.  I was hoping to switch
fully from the former approach to the latter approach, instead of switching from
the former approach to a mix of the two approaches as you are proposing.

The following on top of this patch is what I am asking for.  I think it would be
appropriate to fold into this patch.

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 589648142c173..ad1ae7a88b59d 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -228,10 +228,10 @@ static inline struct aesni_xts_ctx *aes_xts_ctx(struct crypto_skcipher *tfm)
 	return (struct aesni_xts_ctx *)aes_align_addr(crypto_skcipher_ctx(tfm));
 }
 
-static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
+static int aes_set_key_common(struct crypto_tfm *tfm,
+			      struct crypto_aes_ctx *ctx,
 			      const u8 *in_key, unsigned int key_len)
 {
-	struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
 	int err;
 
 	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
@@ -252,7 +252,8 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		       unsigned int key_len)
 {
-	return aes_set_key_common(tfm, crypto_tfm_ctx(tfm), in_key, key_len);
+	return aes_set_key_common(tfm, aes_ctx(crypto_tfm_ctx(tfm)),
+				  in_key, key_len);
 }
 
 static void aesni_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
@@ -285,7 +286,7 @@ static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			         unsigned int len)
 {
 	return aes_set_key_common(crypto_skcipher_tfm(tfm),
-				  crypto_skcipher_ctx(tfm), key, len);
+				  aes_ctx(crypto_skcipher_ctx(tfm)), key, len);
 }
 
 static int ecb_encrypt(struct skcipher_request *req)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

