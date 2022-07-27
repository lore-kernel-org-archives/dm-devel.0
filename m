Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92509C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658938795;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8Gmgi5hLd49mspAGwwZrHOqpYP7QvVW4+zg7X6Ql5mI=;
	b=TjhnP1G6Z79Gs/eJSh8xtTDiCl/+5CkR7UrxQd1KCYPG9wheA6dKWUgLdo64aE9aM38LsA
	8TcqG1za02lrjcJhLTkeLNY+S7idefjlzZ4fUZni5cqDkyUFT1taIRME2q+buSBY1+2usY
	oiG3q1hU46xYZEcYfeUj8/rCuVvqJ4Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-Hi9IVztLNOidelMoIziHjA-1; Wed, 27 Jul 2022 12:19:51 -0400
X-MC-Unique: Hi9IVztLNOidelMoIziHjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAB22381A08F;
	Wed, 27 Jul 2022 16:19:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BEA618ECC;
	Wed, 27 Jul 2022 16:19:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 50FF51945DA7;
	Wed, 27 Jul 2022 16:19:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01F5E1945DA2
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 15:48:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E19061121319; Wed, 27 Jul 2022 15:48:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE3991121314
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 15:48:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B664C3C0ED4E
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 15:48:02 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-GQb6D1OrOSSnCQItaHnR4w-1; Wed, 27 Jul 2022 11:48:01 -0400
X-MC-Unique: GQb6D1OrOSSnCQItaHnR4w-1
Received: by mail-qt1-f198.google.com with SMTP id
 f1-20020ac84641000000b0031ecb35e4d1so9318023qto.2
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 08:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=312r3bKftltdOO53Z05rlBas1JOosjw813dDHw76/VM=;
 b=0MxANtCZsaHqgdrUL31rczXdNcZMjmPlXhqE3+Q5LimTVXgbXvo3+2ot7NF3CliJwx
 y1uPy+sg/ETVVRkaHYKwf5XUVfqGoAT1AhtvjMGvQNV4B1k/5EKEFOZNJkStYiBLgLxh
 H5RmvtBiUoQkOYLy2xfcVrmOFZnfjLUo5jE/xAYbZkfVcVAZFpF3CQg4vUxjSn52h25t
 luR8Z4pwfBe/xRQGet3BovOZ4Dzim1OGL/TxEC0LXk/aGyFiHxw6qCj9Sfw73YayJDnV
 qHG/dTxDC1Hnw6/kz2XLZ3xJUKFmHMVxoSWHniV4XhrNnCi0wcf8H2z0Qi6pgWqJ2Bth
 XrWQ==
X-Gm-Message-State: AJIora/bM8F4Z8Iol3EGK8Uthmxg7DkdQhtDcaplDbKZRg+kLrL5MfMT
 MmclRH/KgWxCTIpWLyC9bQoTxuWi4sJvk6ZI9n8noOo4fMgjiJvvmtUifMXsa7fjNK2wItAlIju
 BYtwCc0q7DEs+bg==
X-Received: by 2002:ac8:5a42:0:b0:31f:1ce3:d726 with SMTP id
 o2-20020ac85a42000000b0031f1ce3d726mr19152489qta.12.1658936881067; 
 Wed, 27 Jul 2022 08:48:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uaMc1fFTuFYIWzmnOweQyKaAECflze2go7Fc/p0uVqT8VvA56yGxlF5AtYIOCHCmpZ1Tbohg==
X-Received: by 2002:ac8:5a42:0:b0:31f:1ce3:d726 with SMTP id
 o2-20020ac85a42000000b0031f1ce3d726mr19152462qta.12.1658936880765; 
 Wed, 27 Jul 2022 08:48:00 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 bs10-20020a05620a470a00b006b5f0e8d1b9sm14185261qkb.81.2022.07.27.08.47.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 27 Jul 2022 08:48:00 -0700 (PDT)
Date: Wed, 27 Jul 2022 11:47:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YuFeL6J1gtFV63dW@redhat.com>
References: <20220726160959.89247-1-snitzer@kernel.org>
 <20220726160959.89247-3-snitzer@kernel.org>
 <alpine.LRH.2.02.2207271055510.28280@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2207271055510.28280@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 2/6] dm bufio: Add
 DM_BUFIO_CLIENT_NO_SLEEP flag
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 27 2022 at 11:25P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I'd like to ask - why not use dm_bufio_trylock from an interrupt context?
> 
> I would just add a new function "dm_bufio_get_trylock" that is equivalent 
> to "dm_bufio_get", except that it uses dm_bufio_trylock - and if it fails, 
> fallback to process context.
> 
> I think using dm_bufio_trylock would be less hacky than introducing a 
> new dm_bufio flag that changes mutex to spinlock.

OK, I can drop the bufio hacks (patches 1 and 2) and replace with a
dm_bufio_get_trylock and see if that resolves the cryptsetup testing
issues Milan is reporting.  But on the flip side I feel like trylock
is far more prone to fail for at least one of a series of cached
buffers needed (via _get). And so it'll punt to workqueue more often
and _not_ provide the desired performance improvement.  BUT.. we shall
see.

All said, I'm now dropping this patchset from the upcoming 5.20 merge.
This all clearly needs more development time.

Huck: I'll run with Mikulas's suggestion and try to get the cryptsetup
tests passing. But I'll leave performance testing to you.

Thanks,
Mike



> On Tue, 26 Jul 2022, Mike Snitzer wrote:
> 
> > From: Nathan Huckleberry <nhuck@google.com>
> > 
> > Add an optional flag that ensures dm_bufio_client does not sleep
> > (primary focus is to service dm_bufio_get without sleeping). This
> > allows the dm-bufio cache to be queried from interrupt context.
> > 
> > To ensure that dm-bufio does not sleep, dm-bufio must use a spinlock
> > instead of a mutex. Additionally, to avoid deadlocks, special care
> > must be taken so that dm-bufio does not sleep while holding the
> > spinlock.
> > 
> > But again: the scope of this no_sleep is initially confined to
> > dm_bufio_get, so __alloc_buffer_wait_no_callback is _not_ changed to
> > avoid sleeping because __bufio_new avoids allocation for NF_GET.
> > 
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > ---
> >  drivers/md/dm-bufio.c    | 22 +++++++++++++++++++---
> >  include/linux/dm-bufio.h |  5 +++++
> >  2 files changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > index ad5603eb12e3..486179d1831c 100644
> > --- a/drivers/md/dm-bufio.c
> > +++ b/drivers/md/dm-bufio.c
> > @@ -81,6 +81,8 @@
> >   */
> >  struct dm_bufio_client {
> >  	struct mutex lock;
> > +	spinlock_t spinlock;
> > +	unsigned long spinlock_flags;
> >  
> >  	struct list_head lru[LIST_SIZE];
> >  	unsigned long n_buffers[LIST_SIZE];
> > @@ -90,6 +92,7 @@ struct dm_bufio_client {
> >  	s8 sectors_per_block_bits;
> >  	void (*alloc_callback)(struct dm_buffer *);
> >  	void (*write_callback)(struct dm_buffer *);
> > +	bool no_sleep;
> >  
> >  	struct kmem_cache *slab_buffer;
> >  	struct kmem_cache *slab_cache;
> > @@ -167,17 +170,26 @@ struct dm_buffer {
> >  
> >  static void dm_bufio_lock(struct dm_bufio_client *c)
> >  {
> > -	mutex_lock_nested(&c->lock, dm_bufio_in_request());
> > +	if (c->no_sleep)
> > +		spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
> > +	else
> > +		mutex_lock_nested(&c->lock, dm_bufio_in_request());
> >  }
> >  
> >  static int dm_bufio_trylock(struct dm_bufio_client *c)
> >  {
> > -	return mutex_trylock(&c->lock);
> > +	if (c->no_sleep)
> > +		return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
> > +	else
> > +		return mutex_trylock(&c->lock);
> >  }
> >  
> >  static void dm_bufio_unlock(struct dm_bufio_client *c)
> >  {
> > -	mutex_unlock(&c->lock);
> > +	if (c->no_sleep)
> > +		spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
> > +	else
> > +		mutex_unlock(&c->lock);
> >  }
> >  
> >  /*----------------------------------------------------------------*/
> > @@ -1748,12 +1760,16 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
> >  	c->alloc_callback = alloc_callback;
> >  	c->write_callback = write_callback;
> >  
> > +	if (flags & DM_BUFIO_CLIENT_NO_SLEEP)
> > +		c->no_sleep = true;
> > +
> >  	for (i = 0; i < LIST_SIZE; i++) {
> >  		INIT_LIST_HEAD(&c->lru[i]);
> >  		c->n_buffers[i] = 0;
> >  	}
> >  
> >  	mutex_init(&c->lock);
> > +	spin_lock_init(&c->spinlock);
> >  	INIT_LIST_HEAD(&c->reserved_buffers);
> >  	c->need_reserved_buffers = reserved_buffers;
> >  
> > diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
> > index e21480715255..15d9e15ca830 100644
> > --- a/include/linux/dm-bufio.h
> > +++ b/include/linux/dm-bufio.h
> > @@ -17,6 +17,11 @@
> >  struct dm_bufio_client;
> >  struct dm_buffer;
> >  
> > +/*
> > + * Flags for dm_bufio_client_create
> > + */
> > +#define DM_BUFIO_CLIENT_NO_SLEEP 0x1
> > +
> >  /*
> >   * Create a buffered IO cache on a given device
> >   */
> > -- 
> > 2.32.1 (Apple Git-133)
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
> > 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

