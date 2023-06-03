Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40055C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685810664;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DtCKY38Ti3gZCaRuFiSUIbVgOwV5SJhMyYPM5hD1KAM=;
	b=fOyzwsRgsC+09Lg10gTAhqjOrlyDyN7CPwjgkvOlvKXrSRN+O6D/P8dzTp6qqFaszDPCgu
	U1aFx/CWRYddAxtUGGr8SQQmaWqGeqWMh0yyR3nFuzJqhKzcOFHEvKzp91uXIynxzcSq5o
	uPXvpV0qNOlQGPk4Mw17kZ4Rv0X1GyI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-kuRBUrj0O2inf_eA8SJEew-1; Sat, 03 Jun 2023 12:44:20 -0400
X-MC-Unique: kuRBUrj0O2inf_eA8SJEew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1412329A9D41;
	Sat,  3 Jun 2023 16:44:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 975251401C4E;
	Sat,  3 Jun 2023 16:44:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 260A319465A0;
	Sat,  3 Jun 2023 16:44:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28F571946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 16:44:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B6017AE4; Sat,  3 Jun 2023 16:44:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53F069E63
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 16:44:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35BEB3804061
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 16:44:15 +0000 (UTC)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-9i4K_NW7Mvm9nuaLwXGkUQ-1; Sat, 03 Jun 2023 12:44:13 -0400
X-MC-Unique: 9i4K_NW7Mvm9nuaLwXGkUQ-1
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 61F651EC082E;
 Sat,  3 Jun 2023 18:37:56 +0200 (CEST)
Date: Sat, 3 Jun 2023 18:37:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230603163751.GBZHtsXwW5UUnsSbKX@fat_crate.local>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-10-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230603152227.12335-10-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v8 09/12] x86/cpu: Add a configuration and
 command line option for Key Locker
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
Cc: linux-doc@vger.kernel.org, dave.hansen@linux.intel.com,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 "H. Peter Anvin" <hpa@zytor.com>, nhuck@google.com, ardb@kernel.org,
 herbert@gondor.apana.org.au, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org,
 mingo@kernel.org, ebiggers@kernel.org, Ingo Molnar <mingo@redhat.com>,
 gmazyland@gmail.com, elliott@hpe.com, luto@kernel.org,
 dan.j.williams@intel.com, charishma1.gairuboyina@intel.com,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, linux-crypto@vger.kernel.org,
 bernie.keany@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: alien8.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jun 03, 2023 at 08:22:24AM -0700, Chang S. Bae wrote:
> +static __init int x86_nokeylocker_setup(char *arg)
> +{
> +	/* Expect an exact match without trailing characters. */
> +	if (strlen(arg))
> +		return 0;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_KEYLOCKER))
> +		return 1;
> +
> +	setup_clear_cpu_cap(X86_FEATURE_KEYLOCKER);
> +	pr_info("x86/keylocker: Disabled by kernel command line.\n");
> +	return 1;
> +}
> +__setup("nokeylocker", x86_nokeylocker_setup);

Can we stop adding those just to remove them at some point later but
simply do:

clearcpuid=keylocker

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

