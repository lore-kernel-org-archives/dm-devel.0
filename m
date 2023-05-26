Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB816C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 07:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685085797;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/SrU/xx7ZgMR6NdD7hKsWvnmyf5KTaqQrP1xuF06FIA=;
	b=G9tBoo6FSpH8EHJN8HA9dJALTiZFv2xew0ncMzV2OCxvAW4b/ATuDERVMIOK4RzF3ilQCt
	Ln37SRSR1EEdjIFwRA656JPdOwW8xDCZ2AbL7eJMrejnBNMTs+M0LU6x6Oqg+Nzy7wu9WN
	HRELKKhoCWowUJgDYFuDRecP3dcwnuo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-tuhxEFfYMBu4YSv4coDJVA-1; Fri, 26 May 2023 03:23:14 -0400
X-MC-Unique: tuhxEFfYMBu4YSv4coDJVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 413561C01E93;
	Fri, 26 May 2023 07:23:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E09CC1121314;
	Fri, 26 May 2023 07:23:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7B4D19465A4;
	Fri, 26 May 2023 07:23:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4889019465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 07:23:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64AF440102D; Fri, 26 May 2023 07:23:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CC0A492B00
 for <dm-devel@redhat.com>; Fri, 26 May 2023 07:23:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41124800B2A
 for <dm-devel@redhat.com>; Fri, 26 May 2023 07:23:09 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-9CHbr5ScOb-v4EykyuGibw-1; Fri, 26 May 2023 03:23:05 -0400
X-MC-Unique: 9CHbr5ScOb-v4EykyuGibw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E20B964ACA;
 Fri, 26 May 2023 07:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D370C433D2;
 Fri, 26 May 2023 07:23:03 +0000 (UTC)
Date: Fri, 26 May 2023 00:23:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230526072301.GC875@sol.localdomain>
References: <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230524165717.14062-13-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230524165717.14062-13-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 12/12] crypto: x86/aes-kl - Implement the
 AES-XTS algorithm
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 24, 2023 at 09:57:17AM -0700, Chang S. Bae wrote:
> == API Limitation ==
> 
> The setkey() function transforms an AES key into a handle. But, an
> extended key is a usual outcome of setkey() in other AES cipher
> implementations. For this reason, a setkey() failure does not fall
> back to the other. So, expose AES-KL methods via synchronous
> interfaces only.

I don't understand what this paragraph is trying to say.

> +/*
> + * The below wrappers for the encryption/decryption functions
> + * incorporate the feature availability check:
> + *
> + * In the rare event of hardware failure, the wrapping key can be lost
> + * after wake-up from a deep sleep state. Then, this check helps to
> + * avoid any subsequent misuse with populating a proper error code.
> + */
> +
> +static inline int aeskl_enc(const void *ctx, u8 *out, const u8 *in)
> +{
> +	if (!valid_keylocker())
> +		return -ENODEV;
> +
> +	return __aeskl_enc(ctx, out, in);
> +}

Is it not sufficient for the valid_keylocker() check to occur at the top level
(in xts_encrypt() and xts_decrypt()), which would seem to be a better place to
do it?  Is this because valid_keylocker() needs to be checked in every
kernel_fpu_begin() section separately, to avoid a race condition?  If that's
indeed the reason, can you explain that in the comment?

> +static inline int xts_keylen(struct skcipher_request *req, u32 *keylen)
> +{
> +	struct aes_xts_ctx *ctx = aes_xts_ctx(crypto_skcipher_reqtfm(req));
> +
> +	if (ctx->crypt_ctx.key_length != ctx->tweak_ctx.key_length)
> +		return -EINVAL;
> +
> +	*keylen = ctx->crypt_ctx.key_length;
> +	return 0;
> +}

This is odd.  Why would the key lengths be different here?

> +	err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
> +					     aeskl_simd_skciphers);
> +	if (err)
> +		return err;
> +
> +	return 0;

This can be simplified to:

	return simd_register_skciphers_compat(aeskl_skciphers,
					      ARRAY_SIZE(aeskl_skciphers),
					      aeskl_simd_skciphers);

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

