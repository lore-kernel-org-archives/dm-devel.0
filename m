Return-Path: <SRS0=c4z+=NH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A258FC4338F
	for <dm-devel@archiver.kernel.org>; Mon, 16 Aug 2021 14:24:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B1F46108D
	for <dm-devel@archiver.kernel.org>; Mon, 16 Aug 2021 14:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B1F46108D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-K9gb_xrYPb-UekkWASIHUw-1; Mon, 16 Aug 2021 10:24:17 -0400
X-MC-Unique: K9gb_xrYPb-UekkWASIHUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8455D1082929;
	Mon, 16 Aug 2021 14:24:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A04D75C1D5;
	Mon, 16 Aug 2021 14:24:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C99221800B9B;
	Mon, 16 Aug 2021 14:24:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17GEHOLD013531 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 10:17:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F44A20239F7; Mon, 16 Aug 2021 14:17:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89BB72029F90
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 14:17:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 500AF185A7A4
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 14:17:09 +0000 (UTC)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com
	[209.85.210.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-429-yEXocw6sPxqdC8Elooji0A-1; Mon, 16 Aug 2021 10:17:04 -0400
X-MC-Unique: yEXocw6sPxqdC8Elooji0A-1
Received: by mail-ot1-f46.google.com with SMTP id
	h63-20020a9d14450000b02904ce97efee36so21092114oth.7; 
	Mon, 16 Aug 2021 07:17:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=xqBgEkGNywTvhBrskowD08mnqrtLbd1U3IqXducmNiM=;
	b=NC+JzVegfPrIEYcSJ5IeJRZg3LSow6kntzBBY7n3PnOfMyjXdQL9qiU3MuAOXOPMmT
	YcnwArk3PT7Sjqa9SaxTdkqxL/7/8Ylk+fNur9hmdFLS5/ZPNMuNYnuImC7xufJxW+s5
	LzI2cWohPLPtUpjzvyaFYfRm9Vqb4Cp23fv8dtqUMMLdRVDNpfcgvSGQuMJU8m4O4T/0
	8/TErTyVHkZKXrRqxnxwm69sYE6wNh03hMFGy+yiFnW8J6imI8zgB5oHrhl+ByGDClKs
	t0HbEhhpr3lfxb5Hq6tGY/3HLbCS/sj2pRst6abQyTfMpfB5UF6UHrZlXPBzpvNq1rjT
	tvYw==
X-Gm-Message-State: AOAM5310EkqdSrzu8dOtQKOpVr0nNkZEgNzcJ+kauUWJwJzAfDC8vtZq
	t33OpiMO0YmQGgT+++F6ltM=
X-Google-Smtp-Source: ABdhPJwk9RHSoGUJTOU9tmS9JZvmAHg37gvCbM3/T8FG2iyjhZiOE2JVE2I1qIxtU73Rp6CqWPD8tw==
X-Received: by 2002:a05:6830:2695:: with SMTP id
	l21mr13300180otu.138.1629123424016; 
	Mon, 16 Aug 2021 07:17:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
	by smtp.gmail.com with ESMTPSA id
	h6sm2219953otu.16.2021.08.16.07.17.03
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 16 Aug 2021 07:17:03 -0700 (PDT)
Date: Mon, 16 Aug 2021 07:17:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210816141702.GA3449320@roeck-us.net>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
	<20210814211309.GA616511@roeck-us.net>
	<20210815070724.GA23276@lst.de>
	<a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
	<20210816072158.GA27147@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210816072158.GA27147@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
	registration
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 16, 2021 at 09:21:58AM +0200, Christoph Hellwig wrote:
> On Sun, Aug 15, 2021 at 07:27:37AM -0700, Guenter Roeck wrote:
> > [   14.467748][    T1]  Possible unsafe locking scenario:
> > [   14.467748][    T1]
> > [   14.467928][    T1]        CPU0                    CPU1
> > [   14.468058][    T1]        ----                    ----
> > [   14.468187][    T1]   lock(&disk->open_mutex);
> > [   14.468317][    T1]                                lock(mtd_table_mutex);
> > [   14.468493][    T1]                                lock(&disk->open_mutex);
> > [   14.468671][    T1]   lock(mtd_table_mutex);
> 
> Oh, that ooks like a really old one, fixed by
> b7abb0516822 ("mtd: fix lock hierarchy in deregister_mtd_blktrans")
> in linux-next.

I have seen the problem in next-20210813 and that patch is there,
so that is somewhat unlikely.

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

