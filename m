Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3246C55ABD
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3770920857
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 08:02:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3770920857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-rTHopm2iMGObIWeA9OreWw-1; Fri, 13 Nov 2020 03:02:42 -0500
X-MC-Unique: rTHopm2iMGObIWeA9OreWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B7E1188C122;
	Fri, 13 Nov 2020 08:02:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AC295B4BF;
	Fri, 13 Nov 2020 08:02:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0BA0D181A06D;
	Fri, 13 Nov 2020 08:02:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ACI2Ypp012943 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Nov 2020 13:02:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 620D0F6419; Thu, 12 Nov 2020 18:02:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59CCBF6429
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 18:02:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13B3F185A794
	for <dm-devel@redhat.com>; Thu, 12 Nov 2020 18:02:32 +0000 (UTC)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
	[209.85.222.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-153-hbnY3a1ANoe5V9bcqU-rtQ-1; Thu, 12 Nov 2020 13:02:28 -0500
X-MC-Unique: hbnY3a1ANoe5V9bcqU-rtQ-1
Received: by mail-qk1-f193.google.com with SMTP id u4so6110700qkk.10;
	Thu, 12 Nov 2020 10:02:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=cwRfKaiAyvcKH2C/Ff9JVLU4RFzNHu2s5Gzo1tJCQz0=;
	b=ETkx3EIbyQb3DXespyofan0XnFiFI5n5JzAYluZCUf/UB1zkeLcEMk9ad/wzL9977f
	vt/cHoazACosPQJeoyX5LlYpRk7ypW65UQTy92ppBxoUjvgTtcPOT+CdfAom10okevwk
	K0F241LEGBkT+h5PBEog4Sbfx8ZGlzF3ri0DIvuc5MZNm1z8UTg7U9Id6mKiNZ7DgVKM
	jew+CPXcUp/xV0jGIrEILHCkWKhQO3B5B2Ksup0X/nU2vMm7k21L42Dfdbns66XdRclN
	DHhw49PHFcmE3hZZZyZcGVQxVAB6338phaHQIbS6bRqSxwA/MVQTFJJgkgbI5gbcGYbc
	955Q==
X-Gm-Message-State: AOAM531zKVuJxvo6lwNua9YlRpctM3RBSOqYXiqY/ibFBDpEx0FUD3++
	m+Dl6d5IAZZnBZyOBorxeog=
X-Google-Smtp-Source: ABdhPJxQcjdx9LvQKhfxBG5f0jiXNsTvjR+RCQFpMPtzAzYmPdt5hBUSTQcUeKymRwR3RGYaZIMG2A==
X-Received: by 2002:a37:a943:: with SMTP id s64mr959191qke.15.1605204147414;
	Thu, 12 Nov 2020 10:02:27 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
	by smtp.gmail.com with ESMTPSA id r19sm4973529qtm.4.2020.11.12.10.02.26
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 12 Nov 2020 10:02:26 -0800 (PST)
Date: Thu, 12 Nov 2020 11:02:25 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Message-ID: <20201112180225.GC934688@ubuntu-m3-large-x86>
References: <20201111024140.1483879-1-ndesaulniers@google.com>
MIME-Version: 1.0
In-Reply-To: <20201111024140.1483879-1-ndesaulniers@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 13 Nov 2020 03:02:15 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	clang-built-linux@googlegroups.com, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, Rob Herring <robherring2@gmail.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] Revert "dm cache: fix arm link errors with
	inline"
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 10, 2020 at 06:41:40PM -0800, 'Nick Desaulniers' via Clang Built Linux wrote:
> This reverts commit 43aeaa29573924df76f44eda2bbd94ca36e407b5.
> 
> Since
> commit 0bddd227f3dc ("Documentation: update for gcc 4.9 requirement")
> the minimum supported version of GCC is gcc-4.9. It's now safe to remove
> this code.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/427
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  drivers/md/dm-cache-target.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 9644424591da..4bc453f5bbaa 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -712,10 +712,6 @@ static bool block_size_is_power_of_two(struct cache *cache)
>  	return cache->sectors_per_block_shift >= 0;
>  }
>  
> -/* gcc on ARM generates spurious references to __udivdi3 and __umoddi3 */
> -#if defined(CONFIG_ARM) && __GNUC__ == 4 && __GNUC_MINOR__ <= 6
> -__always_inline
> -#endif
>  static dm_block_t block_div(dm_block_t b, uint32_t n)
>  {
>  	do_div(b, n);
> -- 
> 2.29.2.222.g5d2a92d10f8-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

