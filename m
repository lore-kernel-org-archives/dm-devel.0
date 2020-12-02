Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD13DC6369E
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:36:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E9490221F7
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9490221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-T6-4_6GHPCe2FhR1SWY7Sg-1; Wed, 02 Dec 2020 17:36:04 -0500
X-MC-Unique: T6-4_6GHPCe2FhR1SWY7Sg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6089C1937FC1;
	Wed,  2 Dec 2020 22:36:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8558A19C44;
	Wed,  2 Dec 2020 22:35:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 617A3180954D;
	Wed,  2 Dec 2020 22:35:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2MZuiu015048 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 17:35:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 912212026D13; Wed,  2 Dec 2020 22:35:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BFC02026D47
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:35:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4342F185A794
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:35:53 +0000 (UTC)
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com
	[209.85.222.182]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-102-BIJG2HidPR2bi0krGgWafg-1; Wed, 02 Dec 2020 17:35:51 -0500
X-MC-Unique: BIJG2HidPR2bi0krGgWafg-1
Received: by mail-qk1-f182.google.com with SMTP id 1so406269qka.0
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 14:35:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=fDRCmKzmG6EnsCDvgSnP9O6h60abQiEIqQj5Un1xVQs=;
	b=XQwHk+84Nundc2MgWY556oJoTYtbE9maYOswvbd1fabEF90dzcDaCSZagZboqIOZGS
	LJ30cufaQQk67ZGuvX6mVJ8NoqhEASDlautEFoMERdjSbIZYCWcISnPXIAp5JRKUdfx9
	gdIakoYRCOqZbGAoYKB577VDfBbUyvwsij7wGuwb37jRxCJo8F1Rr8vfrtmD8l49UAlw
	Wu6o0+BjpTpV37rAzcfLOjRvd0RaOZMAZTh8u3n1yC/N4gQ+8qcfas1gj8vWdbFlM+wP
	SQyIso1KrKyWjTafxiffyc+QhQ6AQmzyWQUvFoMCi7BowCO6jTPqiveLTAs6MHSVaCV8
	PJjg==
X-Gm-Message-State: AOAM5338iNMbGynQe+duRPEv/EZONzoZ3LNDb/xSyMSk6OcIUZGHGV8N
	gBaPuTeSBlQqHVhuDF2+w/I=
X-Google-Smtp-Source: ABdhPJyMGutGFjHzf5aJ0KpE53xmkUwgzzDYFiQltazRaUqs1lE+hnd/Glbacs9CB2txXmoV49DhhA==
X-Received: by 2002:a37:6712:: with SMTP id b18mr5498qkc.340.1606948550514;
	Wed, 02 Dec 2020 14:35:50 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id l79sm59809qke.1.2020.12.02.14.35.49
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 14:35:49 -0800 (PST)
Date: Wed, 2 Dec 2020 17:35:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gWqZ6li+CvgF4i@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-1-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] store a pointer to the block_device in struct bio
	(again)
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01, 2020 at 05:54:15PM +0100, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series switches back from storing the gendisk + partno to storing
> a block_device pointer in struct bio.  The reason is two fold:  for one
> the new struct block_device actually is always available, removing the
> need to avoid originally.  Second the merge struct block_device is much
> more useful than the old one, as storing it avoids the need for looking
> up what used to be hd_struct during partition remapping and I/O
> accounting.
> 
> Note that this series depends on the posted but not merged
> "block tracepoint cleanups" series.

I'm late but everything looks good to me. So much better than the mess we
had before. Thank you.

The only thing I noticed is that blkdev_get_no_open() can now use
kobject_get() instead of kobject_get_unless_zero() as bdev lookup is
synchronously disabled before device_del().

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

