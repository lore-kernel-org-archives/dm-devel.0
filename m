Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2121C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 06:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685084095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xtjazO1qrbaxRfEFijWHZ6E01OgjjiSbvrdGXt9Mohw=;
	b=Z2BFqAenK4FkUUrljG5/1AweuF4aCG2Cx6pMJMtWkUHS1Zv3U1t/oYL6ZvRifIc7qF9FM+
	iNRQxMFHWX2minzYyNv0ubA376dxOJHmTQX2N1yp2c5u97+zUx+Bokh6LUxUzl1Gn+sEsN
	ZjgtKqai8swdsc+LYVvSrDS64a9GdY0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-XK0EEH6ENSK-ZCy7_Jf92Q-1; Fri, 26 May 2023 02:54:52 -0400
X-MC-Unique: XK0EEH6ENSK-ZCy7_Jf92Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EA15811E92;
	Fri, 26 May 2023 06:54:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 202941121314;
	Fri, 26 May 2023 06:54:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB37919465A4;
	Fri, 26 May 2023 06:54:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1381B19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 06:54:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18FA51121315; Fri, 26 May 2023 06:54:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11F0F1121314
 for <dm-devel@redhat.com>; Fri, 26 May 2023 06:54:20 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E990D38117EE
 for <dm-devel@redhat.com>; Fri, 26 May 2023 06:54:19 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-6CcN5jL8NQSlMc-oEWPWCA-1; Fri, 26 May 2023 02:54:17 -0400
X-MC-Unique: 6CcN5jL8NQSlMc-oEWPWCA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EF81661543;
 Fri, 26 May 2023 06:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9849C433D2;
 Fri, 26 May 2023 06:54:15 +0000 (UTC)
Date: Thu, 25 May 2023 23:54:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230526065414.GB875@sol.localdomain>
References: <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230524165717.14062-11-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230524165717.14062-11-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v7 10/12] crypto: x86/aesni - Use the proper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 24, 2023 at 09:57:15AM -0700, Chang S. Bae wrote:
> +static inline unsigned long aes_align_addr(unsigned long addr)
> +{
> +	return (crypto_tfm_ctx_alignment() >= AESNI_ALIGN) ?
> +	       ALIGN(addr, 1) : ALIGN(addr, AESNI_ALIGN);
> +}

Wouldn't it be simpler to make this take and return 'void *'?  Then the callers
wouldn't need to cast to/from 'unsigned long'.

Also, aligning to a 1-byte boundary is a no-op.

So, please consider the following:

static inline void *aes_align_addr(void *addr)
{
	if (crypto_tfm_ctx_alignment() >= AES_ALIGN)
		return addr;
	return PTR_ALIGN(addr, AES_ALIGN);
}

Also, aesni_rfc4106_gcm_ctx_get() and generic_gcmaes_ctx_get() should call this
too, rather than duplicating similar code.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

