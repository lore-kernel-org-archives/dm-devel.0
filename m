Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023ABC4338F
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 22:53:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A737A60F9C
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 22:53:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A737A60F9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627426390;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AuX82IMoXIVGwu+w90p1+PTumzJmNrW4/pUKXZmF3No=;
	b=B/MX0jLvt/7jIy6zGGzOIG7mgFE8PcEabqj/1xx5Nko24BhQWrzSWrvwc3BW7RHyfFMHK+
	BdUvLsLXgnOndH1FVMfkrbknidEHSlsgyvVbj3x0wYynr4mXu82uoKnL+KCICBkwEJNSUL
	UCHokTVXxb6ALGocO0hol8IkrutCJUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-BvjEHcQuPH2S6PXMGHWQtA-1; Tue, 27 Jul 2021 18:53:09 -0400
X-MC-Unique: BvjEHcQuPH2S6PXMGHWQtA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 799ABC73A0;
	Tue, 27 Jul 2021 22:53:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83AB219D7C;
	Tue, 27 Jul 2021 22:53:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EDA274BB7C;
	Tue, 27 Jul 2021 22:53:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16RMr0lp025160 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 18:53:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 677CDD93D4; Tue, 27 Jul 2021 22:53:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61AD430BBC
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 22:52:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5952858286
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 22:52:57 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
	[209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-598-1VC8cuM4PMSeskKrcIxjzA-1; Tue, 27 Jul 2021 18:52:56 -0400
X-MC-Unique: 1VC8cuM4PMSeskKrcIxjzA-1
Received: by mail-qv1-f71.google.com with SMTP id
	kl8-20020a0562145188b02902e01fc8ee77so758132qvb.21
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 15:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=7stv5u1stx7EtQfdU5hPoXwvmtwChIwUztGz5KP4CR0=;
	b=FH8N1pYilmMJ4RvshqMHu5XoSkmcgPdGTC9tPQ/ijEvoTcal54bGRbxpswQ+LHOJ8n
	mphbGM9VnCjDinSPqlGAXzEisi46KGZ4Ba/hmX7QxjE/eBk4iVoCJDUdykg6NrWpXpzB
	Z37z+lK7GoecTQX2EnLvWWkXhgdVxOhpizgoJdKXuENGJf2qMR7HYdK4uTYfsBd/uqrq
	ElO9TL2397fOf7YmLIL5Daea3dw+qL/hGM8VtSkFMshzWKyTTYcsh9sKXW4NWtgX9XRX
	o4UCp1shG3sIXGTaQuZAIlmVFm/WX7OJAdLqpruzo7v9NvtRKapuDGkr1oV8DMLDRGvG
	d5Ew==
X-Gm-Message-State: AOAM532P7AGHk1vub9DibBwxXlS3mI0akjsLZvhA1F0mqwU4gkzB24ny
	2VR8biDdjav27Tgbkd5pUNelDynIsA1JtXH/X5+SdoIpoBWjo90DmwsGWGov1ADCpuc8Onnd9h3
	E0uAoqVt6Yj6ngg==
X-Received: by 2002:ac8:5508:: with SMTP id j8mr21740854qtq.56.1627426375960; 
	Tue, 27 Jul 2021 15:52:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzk+mrtnxazRJZvhMSqIaKNemzV0sRD5t5okETA1xc/6rn87do3W+YESqL8IACFSOGwAZ82Ag==
X-Received: by 2002:ac8:5508:: with SMTP id j8mr21740847qtq.56.1627426375766; 
	Tue, 27 Jul 2021 15:52:55 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	f12sm2438087qke.37.2021.07.27.15.52.55
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 27 Jul 2021 15:52:55 -0700 (PDT)
Date: Tue, 27 Jul 2021 18:52:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQCORvuQJ2AGR2Ks@redhat.com>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YQAxyjrGJpl7UkNG@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 27 2021 at 12:18P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Jul 27 2021 at 12:02P -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Tue, Jul 27, 2021 at 11:58:46AM -0400, Mike Snitzer wrote:
> > > > This did not make a different to my testing
> > > > using dmsetup and the lvm2 tools.
> > > 
> > > I'll try these changes running through the lvm2 testsuite.
> > 
> > Btw, is ther documentation on how to run it somewhere?  I noticed
> > tests, old-tests and unit-tests directories, but no obvious way
> > to run them.
> 
> I haven't tracked how it has changed in a while, but I always run:
> make check_local
> 
> (but to do that you first need to ./configure how your distro does
> it... so that all targets are enabled, etc. Then: make).
> 
> Will revisit this shortly and let you know if my process needed to
> change at all due to lvm2 changes.

Yeap, same process as I described above.

Same 6 tests fail in the lvm2 testsuite with or without your changes,
so nothing to do with your changes.

I'll review your patches closer tomorrow (first pass it all looked
pretty good).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

