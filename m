Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33BFC77B7C
	for <dm-devel@archiver.kernel.org>; Fri,  5 May 2023 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683328209;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LwF49Ye2ACx0rSatJ1riGu7+vrcbA4wuAe6piBFPUro=;
	b=CdegkxMrEd5g3SUlh0pnRq2fsZpL+W6a1Lnv4l/EQER/LyV2BwGywdRrQXM61voE8SUqV8
	HXBAGgMEqtizi0YhFl2mFLXeYHoi1pAnAZPvV0rxplyr82S4CNgm5iMyvKbpT3SQ1VsZi8
	c6dLK4AVE9kvi8ulCoL1V/LDUe9rSVc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-gqezBpzFP8a8VOMVsna6fQ-1; Fri, 05 May 2023 19:10:06 -0400
X-MC-Unique: gqezBpzFP8a8VOMVsna6fQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38FA6100F652;
	Fri,  5 May 2023 23:10:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 166C51121331;
	Fri,  5 May 2023 23:10:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC05B1946A48;
	Fri,  5 May 2023 23:10:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A573D1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 May 2023 23:10:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85C09492C3F; Fri,  5 May 2023 23:10:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E6CF492C13
 for <dm-devel@redhat.com>; Fri,  5 May 2023 23:10:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6295D80080E
 for <dm-devel@redhat.com>; Fri,  5 May 2023 23:10:00 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-artSZlTRP3WZAOpWBDDsQA-1; Fri, 05 May 2023 19:09:56 -0400
X-MC-Unique: artSZlTRP3WZAOpWBDDsQA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0124F60AC4;
 Fri,  5 May 2023 23:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E06EC433D2;
 Fri,  5 May 2023 23:09:55 +0000 (UTC)
Date: Fri, 5 May 2023 23:09:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <ZFWMwQc4NKg7ueqG@gmail.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-9-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230410225936.8940-9-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 08/12] x86/PM/keylocker: Restore internal
 wrapping key on resume from ACPI S3/4
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
 "Rafael J. Wysocki" <rafael@kernel.org>, ardb@kernel.org,
 linux-pm@vger.kernel.org, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 linux-crypto@vger.kernel.org, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 bp@suse.de, gmazyland@gmail.com, charishma1.gairuboyina@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 10, 2023 at 03:59:32PM -0700, Chang S. Bae wrote:
> +/*
> + * This flag is set with IWKey load. When the key restore fails, it is
> + * reset. This restore state is exported to the crypto library, then AES-KL
> + * will not be used there. So, the feature is soft-disabled with this flag.
> + */
> +static bool valid_kl;
> +
> +bool valid_keylocker(void)
> +{
> +	return valid_kl;
> +}
> +EXPORT_SYMBOL_GPL(valid_keylocker);

It would be simpler to export this bool directly.

> +	if (status & BIT(0))
> +		return 0;
> +	else
> +		return -EBUSY;
[...]
> +		pr_info("x86/keylocker: Enabled.\n");
> +		return;
> +	} else {
> +		int rc;

The kernel coding style usually doesn't use 'else' after a return.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

