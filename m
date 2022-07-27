Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DD1C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 19:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658951707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JQBbQQCJWddR28+kF1HfIoNVQXcPSQ9XHEpBlZrdtiM=;
	b=F2NCS4BHXHqKRq9CH57vY77R94TBXjnQtrelafbUqv7NGxCKZ+QyHDTx9vaAR8r8lXnO+x
	jDf5my4fjd8LRJG5kq9AdwjFd13I3h8GXjw/j8Zc+RiW6IUHv819uKveHvq+0p3vM3exjK
	+5jNx0586pvI3t6jpX8L2KmMy33k4Vg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-vYxRLXlKP4ywRJg_xj54Bw-1; Wed, 27 Jul 2022 15:55:01 -0400
X-MC-Unique: vYxRLXlKP4ywRJg_xj54Bw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF62E108C0DE;
	Wed, 27 Jul 2022 19:54:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0166F18EB7;
	Wed, 27 Jul 2022 19:54:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B57351945DAB;
	Wed, 27 Jul 2022 19:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFC691945DA7
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 19:54:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B69C7141511F; Wed, 27 Jul 2022 19:54:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2A471415118
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 19:54:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 602A5960073
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 19:54:35 +0000 (UTC)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com
 [209.85.167.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-6huTwfPzOk2xg3qR45BvUQ-1; Wed, 27 Jul 2022 15:54:30 -0400
X-MC-Unique: 6huTwfPzOk2xg3qR45BvUQ-1
Received: by mail-lf1-f47.google.com with SMTP id b16so16057848lfb.7
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 12:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=UxYpTdCM2D1y50QjcBg8PEIIgim01Q40P1Y4bK+s4SM=;
 b=wnk6GkCc4x4jTsN16//iYfV/4rK6o/tZ7DdEyGd0Ztspz5FrwoP/X5xWuyPB7+qJrV
 yUmfz9LPVgq8ZnomKMmWyPP4xqSRco15hkjDwWkJ8GOr3I+UOM4K7F9HVheJkD038j9u
 U6uHE/T3R84n7nsSifzdhlV6NwNk3AxemsggpSGenMKvNHCk5wWCmLIUeblA3N2JNSRH
 HsHJC+Ssbe8xa5rhYxKegsRut5YJPnNRC1ephvKb+2SHVVFYrC8e1yym4+QN0Whlx/lb
 ue/kozTxnLhPLIvZ0K1nSxfAdpmp9toByhEn9Ox801jJvDcn8tmEK/JV++89PK942Lv7
 62KA==
X-Gm-Message-State: AJIora/iepPR/hoWOkbuKJaOdzRM5d11oaFajdzv5O4wLeLDOM2KqzAU
 wTznOjF5J7g+ZantHqRSXPM0h6Vda8ozHuh+7kv+wiO4NJg=
X-Google-Smtp-Source: AGRyM1upBSh9GQaoo3Vhj1AysmQ447YGqeBfXqgvyE6AJJR949xBoYC3Rdt1IjlRRDpJ6rE/ta+H5GPLUJSm1tuXjVQ=
X-Received: by 2002:ac2:4205:0:b0:48a:95e6:395c with SMTP id
 y5-20020ac24205000000b0048a95e6395cmr5491254lfh.238.1658951668102; Wed, 27
 Jul 2022 12:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220726160959.89247-1-snitzer@kernel.org>
 <20220726160959.89247-3-snitzer@kernel.org>
 <alpine.LRH.2.02.2207271055510.28280@file01.intranet.prod.int.rdu2.redhat.com>
 <YuFeL6J1gtFV63dW@redhat.com>
In-Reply-To: <YuFeL6J1gtFV63dW@redhat.com>
From: Nathan Huckleberry <nhuck@google.com>
Date: Wed, 27 Jul 2022 12:53:00 -0700
Message-ID: <CAJkfWY7_W-o68=xvKga7=eTkDa4ygod2CV9MFdZbGw7xwE_U0w@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
Cc: Eric Biggers <ebiggers@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 27, 2022 at 8:48 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Wed, Jul 27 2022 at 11:25P -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> > Hi
> >
> > I'd like to ask - why not use dm_bufio_trylock from an interrupt context?
> >
> > I would just add a new function "dm_bufio_get_trylock" that is equivalent
> > to "dm_bufio_get", except that it uses dm_bufio_trylock - and if it fails,
> > fallback to process context.
> >
> > I think using dm_bufio_trylock would be less hacky than introducing a
> > new dm_bufio flag that changes mutex to spinlock.
>
> OK, I can drop the bufio hacks (patches 1 and 2) and replace with a
> dm_bufio_get_trylock and see if that resolves the cryptsetup testing
> issues Milan is reporting.  But on the flip side I feel like trylock
> is far more prone to fail for at least one of a series of cached
> buffers needed (via _get). And so it'll punt to workqueue more often
> and _not_ provide the desired performance improvement.  BUT.. we shall
> see.
>
> All said, I'm now dropping this patchset from the upcoming 5.20 merge.
> This all clearly needs more development time.
>
> Huck: I'll run with Mikulas's suggestion and try to get the cryptsetup
> tests passing. But I'll leave performance testing to you.
>

Sounds like a reasonable fix. I expect that dm_bufio_get_trylock with
WQ_HIGHPRI will give similar performance gains.

Thanks,
Huck

> Thanks,
> Mike
>
>
>
> > On Tue, 26 Jul 2022, Mike Snitzer wrote:
> >
> > > From: Nathan Huckleberry <nhuck@google.com>
> > >
> > > Add an optional flag that ensures dm_bufio_client does not sleep
> > > (primary focus is to service dm_bufio_get without sleeping). This
> > > allows the dm-bufio cache to be queried from interrupt context.
> > >
> > > To ensure that dm-bufio does not sleep, dm-bufio must use a spinlock
> > > instead of a mutex. Additionally, to avoid deadlocks, special care
> > > must be taken so that dm-bufio does not sleep while holding the
> > > spinlock.
> > >
> > > But again: the scope of this no_sleep is initially confined to
> > > dm_bufio_get, so __alloc_buffer_wait_no_callback is _not_ changed to
> > > avoid sleeping because __bufio_new avoids allocation for NF_GET.
> > >
> > > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > > Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> > > ---
> > >  drivers/md/dm-bufio.c    | 22 +++++++++++++++++++---
> > >  include/linux/dm-bufio.h |  5 +++++
> > >  2 files changed, 24 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > > index ad5603eb12e3..486179d1831c 100644
> > > --- a/drivers/md/dm-bufio.c
> > > +++ b/drivers/md/dm-bufio.c
> > > @@ -81,6 +81,8 @@
> > >   */
> > >  struct dm_bufio_client {
> > >     struct mutex lock;
> > > +   spinlock_t spinlock;
> > > +   unsigned long spinlock_flags;
> > >
> > >     struct list_head lru[LIST_SIZE];
> > >     unsigned long n_buffers[LIST_SIZE];
> > > @@ -90,6 +92,7 @@ struct dm_bufio_client {
> > >     s8 sectors_per_block_bits;
> > >     void (*alloc_callback)(struct dm_buffer *);
> > >     void (*write_callback)(struct dm_buffer *);
> > > +   bool no_sleep;
> > >
> > >     struct kmem_cache *slab_buffer;
> > >     struct kmem_cache *slab_cache;
> > > @@ -167,17 +170,26 @@ struct dm_buffer {
> > >
> > >  static void dm_bufio_lock(struct dm_bufio_client *c)
> > >  {
> > > -   mutex_lock_nested(&c->lock, dm_bufio_in_request());
> > > +   if (c->no_sleep)
> > > +           spin_lock_irqsave_nested(&c->spinlock, c->spinlock_flags, dm_bufio_in_request());
> > > +   else
> > > +           mutex_lock_nested(&c->lock, dm_bufio_in_request());
> > >  }
> > >
> > >  static int dm_bufio_trylock(struct dm_bufio_client *c)
> > >  {
> > > -   return mutex_trylock(&c->lock);
> > > +   if (c->no_sleep)
> > > +           return spin_trylock_irqsave(&c->spinlock, c->spinlock_flags);
> > > +   else
> > > +           return mutex_trylock(&c->lock);
> > >  }
> > >
> > >  static void dm_bufio_unlock(struct dm_bufio_client *c)
> > >  {
> > > -   mutex_unlock(&c->lock);
> > > +   if (c->no_sleep)
> > > +           spin_unlock_irqrestore(&c->spinlock, c->spinlock_flags);
> > > +   else
> > > +           mutex_unlock(&c->lock);
> > >  }
> > >
> > >  /*----------------------------------------------------------------*/
> > > @@ -1748,12 +1760,16 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
> > >     c->alloc_callback = alloc_callback;
> > >     c->write_callback = write_callback;
> > >
> > > +   if (flags & DM_BUFIO_CLIENT_NO_SLEEP)
> > > +           c->no_sleep = true;
> > > +
> > >     for (i = 0; i < LIST_SIZE; i++) {
> > >             INIT_LIST_HEAD(&c->lru[i]);
> > >             c->n_buffers[i] = 0;
> > >     }
> > >
> > >     mutex_init(&c->lock);
> > > +   spin_lock_init(&c->spinlock);
> > >     INIT_LIST_HEAD(&c->reserved_buffers);
> > >     c->need_reserved_buffers = reserved_buffers;
> > >
> > > diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
> > > index e21480715255..15d9e15ca830 100644
> > > --- a/include/linux/dm-bufio.h
> > > +++ b/include/linux/dm-bufio.h
> > > @@ -17,6 +17,11 @@
> > >  struct dm_bufio_client;
> > >  struct dm_buffer;
> > >
> > > +/*
> > > + * Flags for dm_bufio_client_create
> > > + */
> > > +#define DM_BUFIO_CLIENT_NO_SLEEP 0x1
> > > +
> > >  /*
> > >   * Create a buffered IO cache on a given device
> > >   */
> > > --
> > > 2.32.1 (Apple Git-133)
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://listman.redhat.com/mailman/listinfo/dm-devel
> > >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://listman.redhat.com/mailman/listinfo/dm-devel
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

