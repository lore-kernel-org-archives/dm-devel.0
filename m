Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26378C4332F
	for <dm-devel@archiver.kernel.org>; Fri,  4 Nov 2022 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667569954;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pgnDlgTCgBDRyYK6PWnmGNhuKSoYwyfCFJ1NadYKX3g=;
	b=XJPufZ/cfQV9cQ1CAO10GBwzmVa6PBUt7O+Av0ecvD0FflKCb8DS1dIN+0MqTGIYpEVwHL
	oQIfLuedbugjm3Tp3orbqx4J7B7bhXJyDZp0Y7oqCxAYs0/YNw6Yl2hlDBct6OvEQSD+nZ
	hwdOFX8k4dSAVZI7n4uxyCFH9dbhKzY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-hR76vMGfPs-sOs4P0DUNrA-1; Fri, 04 Nov 2022 09:52:31 -0400
X-MC-Unique: hR76vMGfPs-sOs4P0DUNrA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 867DD833A0E;
	Fri,  4 Nov 2022 13:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CEE01402BFF;
	Fri,  4 Nov 2022 13:52:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EABD61946587;
	Fri,  4 Nov 2022 13:52:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7709C1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  4 Nov 2022 13:52:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6667F2166B49; Fri,  4 Nov 2022 13:52:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 51E532166B26;
 Fri,  4 Nov 2022 13:52:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 2A4DqR6n003344; Fri, 4 Nov 2022 09:52:27 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 2A4DqRk3003340; Fri, 4 Nov 2022 09:52:27 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Fri, 4 Nov 2022 09:52:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: NeilBrown <neilb@suse.de>
In-Reply-To: <166753684502.19313.12105294223332649758@noble.neil.brown.name>
Message-ID: <alpine.LRH.2.21.2211040941112.19553@file01.intranet.prod.int.rdu2.redhat.com>
References: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fil?=
 =?utf-8?q?e01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
 <166753684502.19313.12105294223332649758@noble.neil.brown.name>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] md: fix a crash in mempool_free
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
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Guoqing Jiang <guoqing.jiang@linux.dev>, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 4 Nov 2022, NeilBrown wrote:

> > ---
> >  drivers/md/md.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/md.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/md.c	2022-11-03 15:29:02.000000000 +0100
> > +++ linux-2.6/drivers/md/md.c	2022-11-03 15:33:17.000000000 +0100
> > @@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio
> >  	struct md_rdev *rdev = bio->bi_private;
> >  	struct mddev *mddev = rdev->mddev;
> >  
> > +	bio_put(bio);
> > +
> >  	rdev_dec_pending(rdev, mddev);
> >  
> >  	if (atomic_dec_and_test(&mddev->flush_pending)) {
> >  		/* The pre-request flush has finished */
> >  		queue_work(md_wq, &mddev->flush_work);
> >  	}
> > -	bio_put(bio);
> >  }
> >  
> >  static void md_submit_flush_data(struct work_struct *ws);
> > @@ -913,10 +914,11 @@ static void super_written(struct bio *bi
> >  	} else
> >  		clear_bit(LastDev, &rdev->flags);
> >  
> > +	bio_put(bio);
> > +
> >  	if (atomic_dec_and_test(&mddev->pending_writes))
> >  		wake_up(&mddev->sb_wait);
> >  	rdev_dec_pending(rdev, mddev);
> > -	bio_put(bio);
> >  }
> 
> Thanks. I think this is a clear improvement.
> I think it would be a little better if the rdev_dec_pending were also
> move up.
> Then both code fragments would be:
>   bio_put ; rdev_dec_pending ; atomic_dec_and_test
> 
> Thanks,
> NeilBrown

Yes, I'll send a second patch that moves rdev_dec_pending up too.

BTW. even this is theoretically incorrect:

> >     if (atomic_dec_and_test(&mddev->pending_writes))
> >             wake_up(&mddev->sb_wait);

Suppose that you execute atomic_dec_and_test and then there's a context 
switch to a process that destroys the md device and then there's a context 
switch back and you call "wake_up(&mddev->sb_wait)" on freed memory.

I think that we should use wait_var_event/wake_up_var instead of sb_wait. 
That will use preallocated hashed wait queues.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

