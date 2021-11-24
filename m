Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB65C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 23:44:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-4lhJ4PB1PzaIVPenVe0GeQ-1; Wed, 24 Nov 2021 18:44:46 -0500
X-MC-Unique: 4lhJ4PB1PzaIVPenVe0GeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1C40101F7A1;
	Wed, 24 Nov 2021 23:44:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79BC260C05;
	Wed, 24 Nov 2021 23:44:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 596F34BB7C;
	Wed, 24 Nov 2021 23:44:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AONiTVs000356 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 18:44:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D97432166B2D; Wed, 24 Nov 2021 23:44:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3D662166B25
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 23:44:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2A4D811E78
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 23:44:26 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
	[209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-470-UlKFOKdcMdq0gzWXTWHO3A-1; Wed, 24 Nov 2021 18:44:25 -0500
X-MC-Unique: UlKFOKdcMdq0gzWXTWHO3A-1
Received: by mail-qk1-f172.google.com with SMTP id i9so6229853qki.3
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 15:44:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=lr273htXDtbwYopWf5/LQMys1bL4Z3qWGmoztSPhOGk=;
	b=Tuykm/C5KujUlVWUXAlFWUP8lQOLHjBLVM+pgBG4BMrk8E6TViqZw4b2gO0XjZvcXb
	KYAN1ms/xRWjZoV6B+3K8TTNYUaiXwabSeYJp6WOxfXhqqRyLxXG30XViWd90xkWxd3C
	hWr+1hm+EC+fz3Vfyp6HW7/lVC040c5MTjPbH5cbNYEVfimVYJvyHRSJxQU8EiPvIt+K
	IFBEnSsDku051xj5vjq1zS9d58URuwNQ/LHr/Yh36QdUgX7QkfBdZW6uKZNQFV0OpMrv
	XmNpIrzUgimC6wc1SnrT7vN2PTeU/h6faokfmiPG8FLl/qyUNDsTH686VG+J6CvU7U5t
	sAcQ==
X-Gm-Message-State: AOAM531x5EOg+57UwvWYSPeDXc+tK+qJDTAlWCpl/P2tNhWamtHW0Ety
	V1QI8mW4qYYTzOFAyCFB06ovEVxcCrayRakc0gcLmA==
X-Google-Smtp-Source: ABdhPJylQDpFpwwqmWYCvMCsS3uYjn68vWzkLW3mnhgy1aqJsuzMuHvqOmB8fNIV5puwXfCby7FtbWc00uiU9ZWuiYg=
X-Received: by 2002:a25:1888:: with SMTP id 130mr1119136yby.301.1637797464639; 
	Wed, 24 Nov 2021 15:44:24 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDJX8tVtGbuxo_Xqo=7GNd66W_FoVk=i6Kssp-6zP5cmmA@mail.gmail.com>
	<20211123231518.GA63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CA+FmFJBs9ocSbXHxdEncdGRRByamziXc+h9DMNH=r6qWPk3nzQ@mail.gmail.com>
	<alpine.LRH.2.02.2111240819520.1631@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2111240819520.1631@file01.intranet.prod.int.rdu2.redhat.com>
From: Akilesh Kailash <akailash@google.com>
Date: Wed, 24 Nov 2021 15:44:13 -0800
Message-ID: <CABSDvD+_mfAJ6SAmkTAve=i8w_xpvPPg1VyC7a3+KO6YAnGRiw@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Tianjie Xu <xunchang@google.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Kelvin Zhang <zhangkelvin@google.com>, dm-devel@redhat.com,
	David Anderson <dvander@google.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 24, 2021 at 8:10 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Tue, 23 Nov 2021, David Anderson wrote:
>
> > In our ecosystem, the OTA generation and on-device application process
> > has evolved continually, in every release, for over 10 years now. So
> > we think it's unlikely that we'll stop making improvements to it. Our
> > current roadmap has other changes in the pipeline too. It's not just
> > us trying to eek out diminishing returns. Other parts of the system
> > change around us, and the OTA system needs to adapt.
> >
> > The performance penalty is something we've been working on, and have
> > improved a lot since our first iteration. We're currently
> > experimenting with io_uring as well.
> >
> > Best,
> >
> > -David
>
> Hi
>
> I understand that an update format developed over 10 years will have
> better compression ratio than my format developed in 2 months.
>
> I'd be interested in extending dm-update to handle your your update format
> and possibly add some abstraction, so that it can work with multiple
> formats.
>
> You say that you have "COPY" and "XOR" operations.
>
> How do you search for blocks that are similar, so that the "XOR" method is
> benefical for them? How do you make sure that you don't perform the "XOR"
> operation twice, if there's system crash when performing it?

CC: Kelvin and Tianjie who are familiar with the  OTA generation.

> Could it be possible for you to give us two Android images and a program
> that calculates difference between them? So that we could see how well we
> are performing compared to the existing solution.
>
> Mikulas
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

