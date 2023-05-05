Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29FEC77B7D
	for <dm-devel@archiver.kernel.org>; Fri,  5 May 2023 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683329263;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XYCGgKKhrdkheZrts1ykR1DdxnQ2pXv6bX6ZrM3umIY=;
	b=bbZlB59dnPh8eB0+NwTGo5VWsxRE7pXUWnso/zu5nE8W8YVizskd5TzXqXC+09T3cT3T//
	eHilRuTJcPyV4QOkO3+12xcWpIBhAZ9pMllJuTNUTJebl0wO4fISFz85GS8Cnu750hHyr6
	wJvNJt/JHFRW1zSLFVrFN+ymwLTh7og=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-KFfQ7DxxMQmL8wLd80mY7A-1; Fri, 05 May 2023 19:27:40 -0400
X-MC-Unique: KFfQ7DxxMQmL8wLd80mY7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E237A84AF31;
	Fri,  5 May 2023 23:27:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E843C15BA0;
	Fri,  5 May 2023 23:27:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 431131946A48;
	Fri,  5 May 2023 23:27:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B86AF1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 May 2023 23:27:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ACDF063F5B; Fri,  5 May 2023 23:27:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5CFF63F3D
 for <dm-devel@redhat.com>; Fri,  5 May 2023 23:27:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8727288B76E
 for <dm-devel@redhat.com>; Fri,  5 May 2023 23:27:37 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-3yRQcYM2MWa5kQBKxOiSGA-1; Fri, 05 May 2023 19:27:33 -0400
X-MC-Unique: 3yRQcYM2MWa5kQBKxOiSGA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 08A8B611EE;
 Fri,  5 May 2023 23:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157CFC433D2;
 Fri,  5 May 2023 23:27:32 +0000 (UTC)
Date: Fri, 5 May 2023 23:27:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <ZFWQ4sZEVu/LHq+Q@gmail.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-11-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230410225936.8940-11-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v6 10/12] crypto: x86/aes - Prepare for a new
 AES implementation
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
 linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-crypto@vger.kernel.org, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 bp@suse.de, gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 10, 2023 at 03:59:34PM -0700, Chang S. Bae wrote:
> Refactor the common C code to avoid code duplication. The AES-NI code uses
> it with a function pointer argument to call back the AES-NI assembly code.
> So will the AES-KL code.

Actually, the AES-NI XTS glue code currently makes direct calls to the assembly
code.  This patch changes it to make indirect calls.  Indirect calls are very
expensive these days, partly due to all the speculative execution mitigations.
So this patch likely causes a performance regression.  How about making
xts_crypt_common() and xts_setkey_common() be inline functions?

Another issue with having the above be exported symbols is that their names are
too generic, so they could easily collide with another symbols in the kernel.
To be exported symbols, they would need something x86-specific in their names.

>  arch/x86/crypto/Makefile           |   2 +-
>  arch/x86/crypto/aes-intel_asm.S    |  26 ++++
>  arch/x86/crypto/aes-intel_glue.c   | 127 ++++++++++++++++
>  arch/x86/crypto/aes-intel_glue.h   |  44 ++++++
>  arch/x86/crypto/aesni-intel_asm.S  |  58 +++----
>  arch/x86/crypto/aesni-intel_glue.c | 235 +++++++++--------------------
>  arch/x86/crypto/aesni-intel_glue.h |  17 +++

It's confusing having aes-intel, aesni-intel, *and* aeskl-intel.  Maybe call the
first one "aes-helpers" or "aes-common" instead?

> +struct aes_xts_ctx {
> +	u8 raw_tweak_ctx[sizeof(struct crypto_aes_ctx)] AES_ALIGN_ATTR;
> +	u8 raw_crypt_ctx[sizeof(struct crypto_aes_ctx)] AES_ALIGN_ATTR;
> +};

This struct does not make sense.  It should look like:

    struct aes_xts_ctx {
            struct crypto_aes_ctx tweak_ctx AES_ALIGN_ATTR;
            struct crypto_aes_ctx crypt_ctx AES_ALIGN_ATTR;
    };

The runtime alignment to a 16-byte boundary should happen when translating the
raw crypto_skcipher_ctx() into the pointer to the aes_xts_ctx.  It should not
happen when accessing each individual field in the aes_xts_ctx.

>  /*
> - * int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
> - *                   unsigned int key_len)
> + * int _aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
> + *                    unsigned int key_len)
>   */

It's conventional to use two leading underscores, not one.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

