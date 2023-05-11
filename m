Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36AA6C77B7C
	for <dm-devel@archiver.kernel.org>; Thu, 11 May 2023 21:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683841226;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xdPgCKFXAqjsJdDlsVOyt/eKBb17Cmk2UcnAD3URaPA=;
	b=GIaPVEDlzDJskpDkyU8rLzLdwcAg/5Wj0ihlQNdy72aT5U9036nJfn5tJGIjVmnygdrU2Z
	eHGyUUyPHgcj/i7jcw3Xdim1/fe3B50fn0jfRo5QG3XMAtYbDKbLo2Az/DDRtu7j5VzpPC
	/qwgNBboPiBbKojGtQgqL+cDLMxaaSw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-sUvtp3FAOdK8LrwPPGhq3g-1; Thu, 11 May 2023 17:40:22 -0400
X-MC-Unique: sUvtp3FAOdK8LrwPPGhq3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A4748533DF;
	Thu, 11 May 2023 21:40:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0D552026D16;
	Thu, 11 May 2023 21:40:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6654219451E4;
	Thu, 11 May 2023 21:40:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1B2BF19451E3
 for <dm-devel@listman.corp.redhat.com>; Thu, 11 May 2023 21:40:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A879EC16024; Thu, 11 May 2023 21:39:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A16D6C15BA0
 for <dm-devel@redhat.com>; Thu, 11 May 2023 21:39:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8437F101A552
 for <dm-devel@redhat.com>; Thu, 11 May 2023 21:39:55 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-F5LKguIlO0mtLJ9JP1kpdQ-1; Thu, 11 May 2023 17:39:51 -0400
X-MC-Unique: F5LKguIlO0mtLJ9JP1kpdQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EE0FD6520B;
 Thu, 11 May 2023 21:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE355C433EF;
 Thu, 11 May 2023 21:39:49 +0000 (UTC)
Date: Thu, 11 May 2023 14:39:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230511213948.GA838@quark.localdomain>
References: <08da7a0a-6b66-2c0e-eb56-96b5ee8faa30@intel.com>
 <20230511190517.10149-1-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230511190517.10149-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, linux-crypto@vger.kernel.org,
 luto@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com,
 tglx@linutronix.de, gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 11, 2023 at 12:05:17PM -0700, Chang S. Bae wrote:
> +
> +struct aes_xts_ctx {
> +	struct crypto_aes_ctx tweak_ctx AES_ALIGN_ATTR;
> +	struct crypto_aes_ctx crypt_ctx AES_ALIGN_ATTR;
> +};
> +
> +static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
> +{
> +	unsigned long addr = (unsigned long)raw_ctx;
> +	unsigned long align = AES_ALIGN;
> +
> +	if (align <= crypto_tfm_ctx_alignment())
> +		align = 1;
> +
> +	return (struct crypto_aes_ctx *)ALIGN(addr, align);
> +}

It seems you took my suggestion to fix the definition of struct aes_xts_ctx, but
you didn't make the corresponding change to the runtime alignment code.  There
should be a helper function aes_xts_ctx() that is used like:

    struct aes_xts_ctx *ctx = aes_xts_ctx(tfm);

It would do the runtime alignment.  Then, aes_ctx() should be removed.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

