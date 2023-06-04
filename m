Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22A1C7EE23
	for <dm-devel@archiver.kernel.org>; Sun,  4 Jun 2023 15:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685892895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N7zqQZ5nHPB8o/aJNREWW1XqQvMC786JGADkL+Qj1zk=;
	b=bs4LO10pEr9Nag/g7loPbW4klnj8lokZ2EOl/3VIf+Qm+z4/yZhTpH+QCDzIicHzY66XVa
	zV9AtC5lZ6lsZyMFyE7+vXtnRHldu5Ss8R6nJePBGBTUAk+t16ay7VbgXx61c0udIHjD/K
	vQYEBiIyu1Cy42exmuD46jiR1NQOFRU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-nb2YYgiQOi2oG6eLIc5srg-1; Sun, 04 Jun 2023 11:34:52 -0400
X-MC-Unique: nb2YYgiQOi2oG6eLIc5srg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61FA98007D9;
	Sun,  4 Jun 2023 15:34:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D08D40C6EC4;
	Sun,  4 Jun 2023 15:34:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F1BA19465A0;
	Sun,  4 Jun 2023 15:34:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BE7D71946595
 for <dm-devel@listman.corp.redhat.com>; Sun,  4 Jun 2023 15:34:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5263740CFD47; Sun,  4 Jun 2023 15:34:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AA9440CFD46
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 15:34:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DCCC3C01DFB
 for <dm-devel@redhat.com>; Sun,  4 Jun 2023 15:34:42 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-f6tbh0UBOS6rN9hpOW9RtQ-1; Sun, 04 Jun 2023 11:34:40 -0400
X-MC-Unique: f6tbh0UBOS6rN9hpOW9RtQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 91F8D60B2F;
 Sun,  4 Jun 2023 15:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76917C433D2;
 Sun,  4 Jun 2023 15:34:37 +0000 (UTC)
Date: Sun, 4 Jun 2023 08:34:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230604153434.GA1212@quark.localdomain>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-11-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230603152227.12335-11-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jun 03, 2023 at 08:22:25AM -0700, Chang S. Bae wrote:
> Every field in struct aesni_xts_ctx is a pointer to a byte array.

A byte array.  Not a pointer to a byte array.

> Then, the field can be redefined as that struct type instead of the obscure
> pointer.

There's no pointer.

>  static inline struct
>  aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
>  {
> -	unsigned long align = AESNI_ALIGN;
> -
> -	if (align <= crypto_tfm_ctx_alignment())
> -		align = 1;
> -	return PTR_ALIGN(crypto_aead_ctx(tfm), align);
> +	return (struct aesni_rfc4106_gcm_ctx *)aes_align_addr(crypto_aead_ctx(tfm));
>  }

Explicit casts from 'void *' are unnecessary.

>  static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  			    unsigned int keylen)
>  {
> -	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
>  	int err;
>  
>  	err = xts_verify_key(tfm, key, keylen);
> @@ -893,20 +892,20 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  	keylen /= 2;
>  
>  	/* first half of xts-key is for crypt */
> -	err = aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx,
> +	err = aes_set_key_common(crypto_skcipher_tfm(tfm), &ctx->crypt_ctx,
>  				 key, keylen);
>  	if (err)
>  		return err;
>  
>  	/* second half of xts-key is for tweak */
> -	return aes_set_key_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx,
> +	return aes_set_key_common(crypto_skcipher_tfm(tfm), &ctx->tweak_ctx,
>  				  key + keylen, keylen);
>  }

To re-iterate what I said on v6, the runtime alignment to a 16-byte boundary
should happen when translating the raw crypto_skcipher_ctx() into the pointer to
the aes_xts_ctx.  It should not happen when accessing each individual field in
the aes_xts_ctx.

Yet, this code is still doing runtime alignment when accessing each individual
field, as the second argument to aes_set_key_common() is 'void *raw_ctx' which
aes_set_key_common() runtime-aligns to crypto_aes_ctx.

We should keep everything consistent, which means making aes_set_key_common()
take a pointer to crypto_aes_ctx and not do the runtime alignment.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

