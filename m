Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B2DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 28 Dec 2021 21:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640727030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jmLzw/Qdy8HfTl5GE1bszuYEjdZOvOiRoH6zunE56oc=;
	b=HxhsLu4hA5MJnapf+n58wdWGl6gVkaaRfAafV2XR0c2FTKMYYLPvsZu6MPKqBTdrydldx+
	ZK08a7iOu6VAM49Uzc6XF8rGegfo+NAh8YBoO5VRpIjKTekZ3Tc9X/DQQiFbmEPIeexsx3
	sanPyPyOJO03GisLB63yCBhEOn8O2Zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639--TnSFttDN6qdrj-KcgUQ9A-1; Tue, 28 Dec 2021 16:30:26 -0500
X-MC-Unique: -TnSFttDN6qdrj-KcgUQ9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B041E189DF5C;
	Tue, 28 Dec 2021 21:30:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4000273140;
	Tue, 28 Dec 2021 21:30:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 117F51809CB8;
	Tue, 28 Dec 2021 21:30:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BSLUCal032068 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 28 Dec 2021 16:30:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 291B74010E98; Tue, 28 Dec 2021 21:30:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23F394047552
	for <dm-devel@redhat.com>; Tue, 28 Dec 2021 21:30:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 093A185A5A8
	for <dm-devel@redhat.com>; Tue, 28 Dec 2021 21:30:12 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-361-ut1beLfhOJy52B8NrtJZNw-1; Tue, 28 Dec 2021 16:30:10 -0500
X-MC-Unique: ut1beLfhOJy52B8NrtJZNw-1
Received: by mail-qv1-f72.google.com with SMTP id
	gv14-20020a056214262e00b0041192fab00dso12155361qvb.23
	for <dm-devel@redhat.com>; Tue, 28 Dec 2021 13:30:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=A/YdqQbiYan/8puYBvi5XsqHp47yRlJpMdsMFPVf0MI=;
	b=FU2glbwVu/1oeNmi/ORV8GGLHMVAOZLJPAMB8kvFKcMF5AmMdYWnNJAU3nn05ldPa/
	6Ht3iYbNwqlRtI53VgWEWvnkHBGizQekIGv4L38Uobi/NZgLMW+WqIzdM8xJGpH7aIKo
	k++mVdprP2VnzOzhohKQ2dWi79XelpyzsjqmHMqsBM8ZqacpX5kw29dZJeIsk1oSTyHd
	mVPO+ZbEMmL1bd7bEm8jE2hotOFbOdf/O6ytMq5tEO1JpF8hByroFqKL0bIaeTvuofWv
	7LISivusWMZD8Ft4MKe0ymxTEyfzz1QguCeS0yJ5zxbI/ssMeVFk4+KMhRTYe1GGqO3O
	t5Tw==
X-Gm-Message-State: AOAM533NX88Q5kUOBLJ01KZFCYXYfj33ntwyovfizbLhN3TFIgxbIfZE
	eXCCxB7/xjsACDIYrO4wax+ccO7VI828MyZ5MJRCJzwtMlG8pgJ9K/voEzDZ7GCPRARWEQnG1DA
	f8BiNsyiUTYyu6w==
X-Received: by 2002:a05:6214:21ae:: with SMTP id
	t14mr20997603qvc.36.1640727010237; 
	Tue, 28 Dec 2021 13:30:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfEjMfPqR60C5of2U4nOV8i5dTSbhNYRsXcPJ5AM9RUqI3+1pyKKK7TeYmr4kflXNZSC7gQg==
X-Received: by 2002:a05:6214:21ae:: with SMTP id
	t14mr20997592qvc.36.1640727010045; 
	Tue, 28 Dec 2021 13:30:10 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	u6sm16668245qki.129.2021.12.28.13.30.09
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 28 Dec 2021 13:30:09 -0800 (PST)
Date: Tue, 28 Dec 2021 16:30:08 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YcuB4K8P2d9WFb83@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org> <YcP4FMG9an5ReIiV@T590>
MIME-Version: 1.0
In-Reply-To: <YcP4FMG9an5ReIiV@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING
	for dm-rq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 22 2021 at 11:16P -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Tue, Dec 21, 2021 at 08:21:39AM -0800, Christoph Hellwig wrote:
> > On Tue, Dec 21, 2021 at 10:14:56PM +0800, Ming Lei wrote:
> > > Hello,
> > > 
> > > dm-rq may be built on blk-mq device which marks BLK_MQ_F_BLOCKING, so
> > > dm_mq_queue_rq() may become to sleep current context.
> > > 
> > > Fixes the issue by allowing dm-rq to set BLK_MQ_F_BLOCKING in case that
> > > any underlying queue is marked as BLK_MQ_F_BLOCKING.
> > > 
> > > DM request queue is allocated before allocating tagset, this way is a
> > > bit special, so we need to pre-allocate srcu payload, then use the queue
> > > flag of QUEUE_FLAG_BLOCKING for locking dispatch.
> > 
> > What is the benefit over just forcing bio-based dm-mpath for these
> > devices?
> 
> At least IO scheduler can't be used for bio based dm-mpath, also there should
> be other drawbacks for bio based mpath and request mpath is often the default
> option, maybe Mike has more input about bio vs request dm-mpath.

Yeah, people use request-based for IO scheduling and more capable path
selectors. Imposing bio-based would be a pretty jarring workaround for 
BLK_MQ_F_BLOCKING. request-based DM should properly support it.

I'm on vacation for the next week but will have a look at this
patchset once I'm back.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

