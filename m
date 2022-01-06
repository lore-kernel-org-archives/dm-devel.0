Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6740BC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641482465;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yWIYADzXOlZgJCVy1oMKXyhhvB4PNDKivT3qpGjYdTA=;
	b=aRYlFlI1QBzmdMYu8mjiF6apR0LuTi8palxX53m2Vifd0deutG+BDS0X9mlW3tradWeCkw
	DHK2yRk693sJ7a659zcUEwvxZq30T93eV0hnB0V99QmLrwcj1CBmjN17inG94kIynU/WtN
	BPPPNrcTsXP694g73VW2efgeYY5e5Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-FrPD06naOVmZQ1UuWOSuUQ-1; Thu, 06 Jan 2022 10:21:01 -0500
X-MC-Unique: FrPD06naOVmZQ1UuWOSuUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 110BC801ADB;
	Thu,  6 Jan 2022 15:20:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C424A75741;
	Thu,  6 Jan 2022 15:20:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45CBB4BB7C;
	Thu,  6 Jan 2022 15:20:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206FKt7Q031508 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 10:20:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1D9246D1F5; Thu,  6 Jan 2022 15:20:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE49B46D1F4
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 15:20:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1B1A801E95
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 15:20:54 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-561-EQxgmov8NCymEzdK7khehQ-1; Thu, 06 Jan 2022 10:20:53 -0500
X-MC-Unique: EQxgmov8NCymEzdK7khehQ-1
Received: by mail-qk1-f197.google.com with SMTP id
	v13-20020a05620a440d00b00468380f4407so1940090qkp.17
	for <dm-devel@redhat.com>; Thu, 06 Jan 2022 07:20:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=2YqsIWQ53eG2PDcqAucmDLmwn9f5p0XCph507eireqE=;
	b=30oF4ji6RoDhCviHhyfet9J42nBsAgj4x8PFpr+tjsnXhYwmq0dYWg81rz/wavgARb
	tgQIKS7nP28bdYPOATvdFd+V/o9boXtLCDZewHBk8GlZdp8sIngIJGHNOG0T000JgX/w
	XMlARa8dq5xEtBrYf6jr9qYodkIs6skoxW/fY3mM5Me5h3lEea9akASHCxkZbBxZoCbn
	Lzfsioz3egqRMgA5eOHbavD3c4+Hw6Sr9rGj9X4V4hRQBb+7ImhDcnec5ayDFVuXcYIw
	cP8irje5+l1+uwDTxhgTEhPDe/6uPFzwvMF8rHNilDyKvga9ZWtWIz+lvCCsCtFnUl/G
	Sxeg==
X-Gm-Message-State: AOAM532TF1Jts6hZ6nW2ikCSCxCjlX9Cwfk+ZGhVjxyWyaXww4BrZ1Mk
	2QDWeu1DFtIs5R8wM0MJOJLS7MA5D8blJkVSJVRlONOtB+gPDfX3kAwwjM0NSKiFZZEnYPr27Kb
	zrslAc8Udxm/kgQ==
X-Received: by 2002:a37:a8c3:: with SMTP id r186mr41125581qke.17.1641482453029;
	Thu, 06 Jan 2022 07:20:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFM593HrigTWcxavtgf6tlraL5xApzNd6Y/8YuQALyJTC0/s7sqWNFOjYapn01OHOTMHltcQ==
X-Received: by 2002:a37:a8c3:: with SMTP id r186mr41125573qke.17.1641482452828;
	Thu, 06 Jan 2022 07:20:52 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id r8sm1561658qkk.91.2022.01.06.07.20.52
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 06 Jan 2022 07:20:52 -0800 (PST)
Date: Thu, 6 Jan 2022 10:20:51 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <YdcI02dcV2aj1x/L@redhat.com>
References: <20220106100231.3278554-1-gregkh@linuxfoundation.org>
	<Ydb7xzmOC8VN8miQ@redhat.com> <YdcE+9ppXYnPzijZ@kroah.com>
MIME-Version: 1.0
In-Reply-To: <YdcE+9ppXYnPzijZ@kroah.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm sysfs: use default_groups in kobj_type
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 06 2022 at 10:04P -0500,
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Jan 06, 2022 at 09:25:11AM -0500, Mike Snitzer wrote:
> > On Thu, Jan 06 2022 at  5:02P -0500,
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > There are currently 2 ways to create a set of sysfs files for a
> > > kobj_type, through the default_attrs field, and the default_groups
> > > field.  Move the dm sysfs code to use default_groups field which has
> > > been the preferred way since aa30f47cf666 ("kobject: Add support for
> > > default attribute groups to kobj_type") so that we can soon get rid of
> > > the obsolete default_attrs field.
> > > 
> > > Cc: Alasdair Kergon <agk@redhat.com>
> > > Cc: Mike Snitzer <snitzer@redhat.com>
> > > Cc: dm-devel@redhat.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  drivers/md/dm-sysfs.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
> > > index a05fcd50e1b9..e28c92478536 100644
> > > --- a/drivers/md/dm-sysfs.c
> > > +++ b/drivers/md/dm-sysfs.c
> > > @@ -112,6 +112,7 @@ static struct attribute *dm_attrs[] = {
> > >  	&dm_attr_rq_based_seq_io_merge_deadline.attr,
> > >  	NULL,
> > >  };
> > > +ATTRIBUTE_GROUPS(dm);
> > 
> > Bit strange to pass "dm" but then have ATTRIBUTE_GROUPS assume dm_attrs defined.
> > Feels like it'll invite janitors sending patches, that they never
> > compile, to remove dm_attrs.
> 
> 0-day would instantly catch that :)
> 
> That's the way the ATTRIBUTE_GROUPS() macro works.  It's tricky, yes,
> and I don't like it all that much, but couldn't come up with a better
> way at the time.  It saves lots and lots of boiler-plate code from
> having to be typed all the time.

OK, thanks for the insight.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

