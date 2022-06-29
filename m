Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEADCCA47B
	for <dm-devel@archiver.kernel.org>; Thu, 30 Jun 2022 07:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656574291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0JQ+hAHeUVQJw6/Xzqcff4n1yisTkydbnz7cdf45yqA=;
	b=fUGSdD4XcW9PmQIGVgSp7Xj/14fb45XLXSy/z07yBfbeDunSdxwevcfpsJ5sFm+uBQ0N6O
	eAQ0dOdY7zodC7yTJPijdqHv/OtCURVR4aGez7bS25qHEFWsua6ZW1uVEh6Q3DjVG+kMcC
	IoKNk4ix3vMsftB1XChJYSDoTGmyzqI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-RkBuLcTXP4i8eJpz2U_mnw-1; Thu, 30 Jun 2022 03:31:28 -0400
X-MC-Unique: RkBuLcTXP4i8eJpz2U_mnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B82E100AF8B;
	Thu, 30 Jun 2022 07:31:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88683141510C;
	Thu, 30 Jun 2022 07:31:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0B691947B99;
	Thu, 30 Jun 2022 07:31:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA6251947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 19:50:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7547240D0166; Wed, 29 Jun 2022 19:50:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70A0940D0160
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:50:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 591BE811E90
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 19:50:32 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-7Tz8W5QwM5G7SqNTKn8YZg-1; Wed, 29 Jun 2022 15:50:27 -0400
X-MC-Unique: 7Tz8W5QwM5G7SqNTKn8YZg-1
Received: by mail-qv1-f42.google.com with SMTP id i17so26383297qvo.13;
 Wed, 29 Jun 2022 12:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NcdUTjmMiq15qzZoGka90GPHW1G+61I7lzpRQwsVmx8=;
 b=Kq6tYdX997pd27qGZM98GRhH6fCz9+OTvC2TLISK8WLwOfgEQLSSvREsUyTXP6lNBy
 Onq3p80wI9HEVSFSUsBgD7tQFTM9shJJJdnTuBi1bppMAHkuerbmwEn59KW/V9L5KXMR
 oGhA1OZFo2xb6qaEpGmBh7tsreXxkLP/dwrhJdSaQ6U+0o2aUedoEMnL+jxXxm0ak7Qv
 wo1EMS34/XQ829TUbCfU7Wh7QZ6smXfFY+QDF3FRw2ZsBGPRL+KeCP/GvSc2hPKNeauT
 l8Gt1afzRM8EQZOMlPLqkVuV6tZlof7ITenfO+JggmB0Z/GKtygbxcedplYXEffnKy01
 9Y9Q==
X-Gm-Message-State: AJIora/B2roInCwueWGzADEE1JcksRkrltfk3DUjqhiby2BLxOAIYrq5
 VfSklNKL+oZBNWky17z8nw==
X-Google-Smtp-Source: AGRyM1v/EeCDMtPB2OY0rjuSz2sM6wW1C1DrePeXrTyAVsNXCHoOEl9CLBSNhd/wgxef86eeQ0iz6w==
X-Received: by 2002:ac8:7d52:0:b0:319:51f0:e418 with SMTP id
 h18-20020ac87d52000000b0031951f0e418mr4149475qtb.481.1656532226717; 
 Wed, 29 Jun 2022 12:50:26 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
 by smtp.gmail.com with ESMTPSA id
 bm9-20020a05620a198900b006a73ad95d40sm13568984qkb.55.2022.06.29.12.50.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 29 Jun 2022 12:50:26 -0700 (PDT)
Date: Wed, 29 Jun 2022 15:50:25 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20220629195025.zqggtojkgt7bqvky@moria.home.lan>
References: <20220626201458.ytn4mrix2pobm2mb@moria.home.lan>
 <Yrld9rLPY6L3MhlZ@T590>
 <20220628042016.wd65amvhbjuduqou@moria.home.lan>
 <3ad782c3-4425-9ae6-e61b-9f62f76ce9f4@kernel.dk>
 <20220628183247.bcaqvmnav34kp5zd@moria.home.lan>
 <6f8db146-d4b3-d17b-4e58-08adc0010cba@kernel.dk>
 <20220629184001.b66bt4jnppjquzia@moria.home.lan>
 <486ec9e2-d34d-abd5-8667-f58a07f5efad@acm.org>
 <20220629190540.fwspv66a4byzqxmg@moria.home.lan>
 <75aa2055-0f50-47ce-b9cc-8f79eba77807@acm.org>
MIME-Version: 1.0
In-Reply-To: <75aa2055-0f50-47ce-b9cc-8f79eba77807@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 30 Jun 2022 07:31:23 +0000
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 29, 2022 at 12:37:59PM -0700, Bart Van Assche wrote:
> On 6/29/22 12:05, Kent Overstreet wrote:
> > On Wed, Jun 29, 2022 at 11:51:27AM -0700, Bart Van Assche wrote:
> > > On 6/29/22 11:40, Kent Overstreet wrote:
> > > > But Jens, to be blunt - I know we have different priorities in the way we write code.
> > > 
> > > Please stay professional in your communication and focus on the technical
> > > issues instead of on the people involved.
> > > 
> > > BTW, I remember that some time ago I bisected a kernel bug to one of your
> > > commits and that you refused to fix the bug introduced by that commit. I had
> > > to spend my time on root-causing it and sending a fix upstream.
> > 
> > I'd be genuinely appreciative if you'd refresh my memory on what it was. Because
> > yeah, if I did that that was my fuckup and I want to learn from my mistakes.
> 
> I was referring to the following two conversations from May 2018:
> * [PATCH] Revert "block: Add warning for bi_next not NULL in bio_endio()" (https://lore.kernel.org/linux-block/20180522235505.20937-1-bart.vanassche@wdc.com/)
> * [PATCH v2] Revert "block: Add warning for bi_next not NULL in bio_endio()" (https://lore.kernel.org/linux-block/20180619172640.15246-1-bart.vanassche@wdc.com/)

Oh yeah, that.

So, we had - still have - a situation where we have a struct bio field, bi_next,
that's used in different ways by different chunks of code, and where that field
being left in an indeterminate state when bios are being handed off across
module boundaries was likely to be a source of bugs. And having debugged one of
those I decided to introduce a check, and then when that broke device mapper (an
unfortunate sitation I agree) you decided to just... revert the check I added.

Like I said, I would have been happy to fix the device mapper code if I'd been
able to get your tests working (did we ever get this added to blk-tests?) - but
I wasn't MIA on the list and I would've been happy to work with you on this.

Was there something you thought I should've done differently?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

