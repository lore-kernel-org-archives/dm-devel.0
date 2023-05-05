Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F231C77B7D
	for <dm-devel@archiver.kernel.org>; Fri,  5 May 2023 23:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683328382;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c06emDgg4i96XBsF52sBbyhFcbm/Fm/hrXwxerVvgW0=;
	b=XGij16AaMvFfKoZsNwiPYKLEfdS1WgVDhXzsvPzPc548s3LuayAvo5qkpE4hsrpRehnoFf
	/PSy4yTV7ZpKA6gqH0NaYy14iAgT5ukg9Y7VcAN9k1IjiLCmPWMH6VZ+QmWBRgNCrZlant
	d+MACuParzqTl3nAsdC40LaSLzoIsx0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-kSkDGJWeM3-BGWrkF3Oxkw-1; Fri, 05 May 2023 19:13:00 -0400
X-MC-Unique: kSkDGJWeM3-BGWrkF3Oxkw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B45E9857DD7;
	Fri,  5 May 2023 23:12:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9ED122026D16;
	Fri,  5 May 2023 23:12:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 61FF21946A48;
	Fri,  5 May 2023 23:12:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D14E1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 May 2023 23:12:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A49A492B01; Fri,  5 May 2023 23:12:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62361492B00
 for <dm-devel@redhat.com>; Fri,  5 May 2023 23:12:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 477A11C068E4
 for <dm-devel@redhat.com>; Fri,  5 May 2023 23:12:57 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-MVp0dDqMPc64LXEGLBbodQ-1; Fri, 05 May 2023 19:12:56 -0400
X-MC-Unique: MVp0dDqMPc64LXEGLBbodQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 6BEE263FB5;
 Fri,  5 May 2023 23:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE07C433D2;
 Fri,  5 May 2023 23:05:05 +0000 (UTC)
Date: Fri, 5 May 2023 23:05:04 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <ZFWLoOZZTnBrid+7@gmail.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-8-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230410225936.8940-8-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v6 07/12] x86/cpu/keylocker: Load an internal
 wrapping key at boot-time
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, ardb@kernel.org,
 dave.hansen@linux.intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-crypto@vger.kernel.org, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 bp@suse.de, gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 10, 2023 at 03:59:31PM -0700, Chang S. Bae wrote:
> diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
> index e85dfb6c1524..820ac29c06d9 100644
> --- a/arch/x86/include/asm/keylocker.h
> +++ b/arch/x86/include/asm/keylocker.h
> @@ -5,6 +5,7 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <asm/processor.h>
>  #include <linux/bits.h>
>  #include <asm/fpu/types.h>
>  
> @@ -28,5 +29,13 @@ struct iwkey {
>  #define KEYLOCKER_CPUID_EBX_WIDE	BIT(2)
>  #define KEYLOCKER_CPUID_EBX_BACKUP	BIT(4)
>  
> +#ifdef CONFIG_X86_KEYLOCKER
> +void setup_keylocker(struct cpuinfo_x86 *c);
> +void destroy_keylocker_data(void);
> +#else
> +#define setup_keylocker(c) do { } while (0)
> +#define destroy_keylocker_data() do { } while (0)
> +#endif

Shouldn't the !CONFIG_X86_KEYLOCKER stubs be static inline functions instead of
macros, so that type checking works?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

