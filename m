Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AB9C433FE
	for <dm-devel@archiver.kernel.org>; Sat,  5 Nov 2022 22:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667687664;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qH2gxoP3aRiDMGaZ7hEj7rHrGj3vTZkSBaaanswFHHY=;
	b=RBqKEaku70sUfa3yGHNKO6csP2S/t15WayyXeO6seur9pjK1CylDIu8/jgyeDSKCEkXmBk
	zWL3tYDGvqDHGpQQ3LFfqiwk4kbbl/ptC+X3NoT1iV7eqm0q5uUAYf2y7+gKKZ0jFN/r3q
	3Pd633FkTr95SC8BWhCl2HV0K1yPBZA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-kQxBLZ9DMb6zRrkqA_Yabg-1; Sat, 05 Nov 2022 18:34:20 -0400
X-MC-Unique: kQxBLZ9DMb6zRrkqA_Yabg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC8C3811E75;
	Sat,  5 Nov 2022 22:34:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79951492B04;
	Sat,  5 Nov 2022 22:34:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F4721946587;
	Sat,  5 Nov 2022 22:34:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C2B081946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  5 Nov 2022 22:34:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6E0F40C94D2; Sat,  5 Nov 2022 22:34:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFA9540C94D1
 for <dm-devel@redhat.com>; Sat,  5 Nov 2022 22:34:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 944D1101A528
 for <dm-devel@redhat.com>; Sat,  5 Nov 2022 22:34:16 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-401-zXj4S3GQO4OkO3Z8R_g-Fw-1; Sat,
 05 Nov 2022 18:34:14 -0400
X-MC-Unique: zXj4S3GQO4OkO3Z8R_g-Fw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 7B8FF1F37C;
 Sat,  5 Nov 2022 22:34:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 71D6413AD7;
 Sat,  5 Nov 2022 22:34:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id PTeoCuLkZmNUdAAAMHmgww
 (envelope-from <neilb@suse.de>); Sat, 05 Nov 2022 22:34:10 +0000
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Mikulas Patocka" <mpatocka@redhat.com>
In-reply-to: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211040941112=2E19553=40fi?=
 =?utf-8?q?le01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
References: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fil?=
 =?utf-8?q?e01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E=2C?=
 <166753684502.19313.12105294223332649758@noble.neil.brown.name>, 
 =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211040941112=2E19553=40file01=2Eintra?=
 =?utf-8?q?net=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
Date: Sun, 06 Nov 2022 09:34:04 +1100
Message-id: <166768764482.19313.4863003667431957512@noble.neil.brown.name>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 05 Nov 2022, Mikulas Patocka wrote:
> 
> On Fri, 4 Nov 2022, NeilBrown wrote:
> 
> > > ---
> > >  drivers/md/md.c |    6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/md/md.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/md/md.c	2022-11-03 15:29:02.000000000 +0100
> > > +++ linux-2.6/drivers/md/md.c	2022-11-03 15:33:17.000000000 +0100
> > > @@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio
> > >  	struct md_rdev *rdev = bio->bi_private;
> > >  	struct mddev *mddev = rdev->mddev;
> > >  
> > > +	bio_put(bio);
> > > +
> > >  	rdev_dec_pending(rdev, mddev);
> > >  
> > >  	if (atomic_dec_and_test(&mddev->flush_pending)) {
> > >  		/* The pre-request flush has finished */
> > >  		queue_work(md_wq, &mddev->flush_work);
> > >  	}
> > > -	bio_put(bio);
> > >  }
> > >  
> > >  static void md_submit_flush_data(struct work_struct *ws);
> > > @@ -913,10 +914,11 @@ static void super_written(struct bio *bi
> > >  	} else
> > >  		clear_bit(LastDev, &rdev->flags);
> > >  
> > > +	bio_put(bio);
> > > +
> > >  	if (atomic_dec_and_test(&mddev->pending_writes))
> > >  		wake_up(&mddev->sb_wait);
> > >  	rdev_dec_pending(rdev, mddev);
> > > -	bio_put(bio);
> > >  }
> > 
> > Thanks. I think this is a clear improvement.
> > I think it would be a little better if the rdev_dec_pending were also
> > move up.
> > Then both code fragments would be:
> >   bio_put ; rdev_dec_pending ; atomic_dec_and_test
> > 
> > Thanks,
> > NeilBrown
> 
> Yes, I'll send a second patch that moves rdev_dec_pending up too.
> 
> BTW. even this is theoretically incorrect:
> 
> > >     if (atomic_dec_and_test(&mddev->pending_writes))
> > >             wake_up(&mddev->sb_wait);
> 
> Suppose that you execute atomic_dec_and_test and then there's a context 
> switch to a process that destroys the md device and then there's a context 
> switch back and you call "wake_up(&mddev->sb_wait)" on freed memory.
> 
> I think that we should use wait_var_event/wake_up_var instead of sb_wait. 
> That will use preallocated hashed wait queues.
> 

I agree there is a potential problem.  Using wait_var_event is an
approach that could work.
An alternate would be to change that code to

  if (atomic_dec_and_lock(&mddev->pending_writes, &mddev->lock)) {
           wake_up(&mddev->sb_wait);
           spin_unlock(&mddev->lock);
  }

As __md_stop() takes mddev->lock, it would not be able to get to the
'free' until after the lock was dropped.

Thanks,
NeilBrown

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

