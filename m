Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB3CC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641842608;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=M8E6mJe5cAvdr5pLcldMGV3aLc8jdDJebdZqY1V9J0Y=;
	b=LfMnigd3qnG2wU2NAe5Qg9Mk8IDtxjAkNf8TVP33nJGzTo2uEDTMaP37bpE3GcxWISWHnL
	MX49InGlzUuih27S8odtvc+9Ld0jLF2LPWWAFZ+JDkdlDmmSv7HnS7FvAQZ9liBAt6miKI
	9Kw54GfJaL8iW56GNS1JtwAi9zfEymo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-AEsT6AqrPNS0PMeS4_pBBg-1; Mon, 10 Jan 2022 14:23:25 -0500
X-MC-Unique: AEsT6AqrPNS0PMeS4_pBBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39C972ED7;
	Mon, 10 Jan 2022 19:23:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFBE95F70B;
	Mon, 10 Jan 2022 19:23:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EE894BB7C;
	Mon, 10 Jan 2022 19:23:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20AJNIme002645 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 14:23:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 395D040CFD02; Mon, 10 Jan 2022 19:23:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 341AE40CFD01
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 19:23:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1535685A5AA
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 19:23:18 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-12-F_UuwiOOMRGw9vbe0As0CA-1; Mon, 10 Jan 2022 14:23:16 -0500
X-MC-Unique: F_UuwiOOMRGw9vbe0As0CA-1
Received: by mail-qt1-f199.google.com with SMTP id
	y1-20020ac87041000000b002c3db9c25f8so11605461qtm.5
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 11:23:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=t9P+7rjkuZ80brejaJnx3ZF5lwbs5E/u0HcwjDODCEs=;
	b=haqSDyjwrdd/I5cdlMArEcgAYZEJel+FbUwe4Yz4L+C3Cg6iKTaDytiqsY8t5f99/A
	hLDtXAi6XaTV9EM1ERWd12rf0dj+T+agWJUghAsJuZF9iUBWCO+fsEj2gbLRlR2IGLPu
	tgZ9dfQU7fO4xt0nLahfOhGWzakKyDr+iItOEZKCSOoEV7KkMWlVlJRXpX40whs4h9gV
	ZD66kNt62hWU60RlbBX42mtKGzuA1aioR6+dwl/CrsfgXe21wHX5ZsrdeZIPEcKigJCW
	VvpPLkNSgW0tSAdsncUEik7nQjN4kL0+aVbWaVHHcMohqqjl+l56hTCnPpXJ4I+48nfe
	mSQg==
X-Gm-Message-State: AOAM5329DhvPzDGt2uElvZ2HSgZ2XxLEXORe18D47wYJYBdiaEo6DYmU
	7Pp6Xt/08EaeVuAnXn+XhRl1F8nHgFvXYifvGr/GseUndrfj0iYTquAww9+iN5hujkXETsIwuZN
	Wn8bIizpVfHjUDA==
X-Received: by 2002:a05:620a:319a:: with SMTP id
	bi26mr883211qkb.279.1641842596316; 
	Mon, 10 Jan 2022 11:23:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJRtGjimqhjfAxjf0NKmMBPu/c2EDjyLyQ4TkmAvUQknoX8nvzYlzIQcEOBUiQjok9utiIWg==
X-Received: by 2002:a05:620a:319a:: with SMTP id
	bi26mr883194qkb.279.1641842596048; 
	Mon, 10 Jan 2022 11:23:16 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id a3sm5336559qtx.66.2022.01.10.11.23.15
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 10 Jan 2022 11:23:15 -0800 (PST)
Date: Mon, 10 Jan 2022 14:23:14 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YdyHoo+B7J7egE1q@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<20211221141459.1368176-4-ming.lei@redhat.com>
	<YdcNgw14kSg+ENVL@redhat.com> <YdcP/fnF5xrBnq+Y@T590>
MIME-Version: 1.0
In-Reply-To: <YdcP/fnF5xrBnq+Y@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/3] dm: mark dm queue as blocking if any
 underlying is blocking
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

On Thu, Jan 06 2022 at 10:51P -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Thu, Jan 06, 2022 at 10:40:51AM -0500, Mike Snitzer wrote:
> > On Tue, Dec 21 2021 at  9:14P -0500,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > dm request based driver doesn't set BLK_MQ_F_BLOCKING, so dm_queue_rq()
> > > is supposed to not sleep.
> > > 
> > > However, blk_insert_cloned_request() is used by dm_queue_rq() for
> > > queuing underlying request, but the underlying queue may be marked as
> > > BLK_MQ_F_BLOCKING, so blk_insert_cloned_request() may become to block
> > > current context, then rcu warning is triggered.
> > > 
> > > Fixes the issue by marking dm request based queue as BLK_MQ_F_BLOCKING
> > > if any underlying queue is marked as BLK_MQ_F_BLOCKING, meantime we
> > > need to allocate srcu beforehand.
> > > 
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  drivers/md/dm-rq.c    |  5 ++++-
> > >  drivers/md/dm-rq.h    |  3 ++-
> > >  drivers/md/dm-table.c | 14 ++++++++++++++
> > >  drivers/md/dm.c       |  5 +++--
> > >  drivers/md/dm.h       |  1 +
> > >  5 files changed, 24 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > > index 579ab6183d4d..2297d37c62a9 100644
> > > --- a/drivers/md/dm-rq.c
> > > +++ b/drivers/md/dm-rq.c
> > > @@ -535,7 +535,8 @@ static const struct blk_mq_ops dm_mq_ops = {
> > >  	.init_request = dm_mq_init_request,
> > >  };
> > >  
> > > -int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
> > > +int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t,
> > > +			     bool blocking)
> > >  {
> > >  	struct dm_target *immutable_tgt;
> > >  	int err;
> > > @@ -550,6 +551,8 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
> > >  	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_STACKING;
> > >  	md->tag_set->nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
> > >  	md->tag_set->driver_data = md;
> > > +	if (blocking)
> > > +		md->tag_set->flags |= BLK_MQ_F_BLOCKING;
> > >  
> > >  	md->tag_set->cmd_size = sizeof(struct dm_rq_target_io);
> > >  	immutable_tgt = dm_table_get_immutable_target(t);
> > 
> > As you can see, dm_table_get_immutable_target(t) is called here ^
> > 
> > Rather than pass 'blocking' in, please just call dm_table_has_blocking_dev(t);
> > 
> > But not a big deal, I can clean that up once this gets committed...
> > 
> > > diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
> > > index 1eea0da641db..5f3729f277d7 100644
> > > --- a/drivers/md/dm-rq.h
> > > +++ b/drivers/md/dm-rq.h
> > > @@ -30,7 +30,8 @@ struct dm_rq_clone_bio_info {
> > >  	struct bio clone;
> > >  };
> > >  
> > > -int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t);
> > > +int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t,
> > > +			     bool blocking);
> > >  void dm_mq_cleanup_mapped_device(struct mapped_device *md);
> > >  
> > >  void dm_start_queue(struct request_queue *q);
> > > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > > index aa173f5bdc3d..e4bdd4f757a3 100644
> > > --- a/drivers/md/dm-table.c
> > > +++ b/drivers/md/dm-table.c
> > > @@ -1875,6 +1875,20 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
> > >  	return true;
> > >  }
> > >  
> > > +/* If the device can block inside ->queue_rq */
> > > +static int device_is_io_blocking(struct dm_target *ti, struct dm_dev *dev,
> > > +			      sector_t start, sector_t len, void *data)
> > > +{
> > > +	struct request_queue *q = bdev_get_queue(dev->bdev);
> > > +
> > > +	return blk_queue_blocking(q);
> > > +}
> > > +
> > > +bool dm_table_has_blocking_dev(struct dm_table *t)
> > > +{
> > > +	return dm_table_any_dev_attr(t, device_is_io_blocking, NULL);
> > > +}
> > > +
> > >  static int device_not_nowait_capable(struct dm_target *ti, struct dm_dev *dev,
> > >  				     sector_t start, sector_t len, void *data)
> > >  {
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index 280918cdcabd..2f72877752dd 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -1761,7 +1761,7 @@ static struct mapped_device *alloc_dev(int minor)
> > >  	 * established. If request-based table is loaded: blk-mq will
> > >  	 * override accordingly.
> > >  	 */
> > > -	md->disk = blk_alloc_disk(md->numa_node_id);
> > > +	md->disk = blk_alloc_disk_srcu(md->numa_node_id);
> > >  	if (!md->disk)
> > >  		goto bad;
> > >  	md->queue = md->disk->queue;
> > > @@ -2046,7 +2046,8 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
> > >  	switch (type) {
> > >  	case DM_TYPE_REQUEST_BASED:
> > >  		md->disk->fops = &dm_rq_blk_dops;
> > > -		r = dm_mq_init_request_queue(md, t);
> > > +		r = dm_mq_init_request_queue(md, t,
> > > +				dm_table_has_blocking_dev(t));
> > >  		if (r) {
> > >  			DMERR("Cannot initialize queue for request-based dm mapped device");
> > >  			return r;
> > > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > > index 742d9c80efe1..f7f92b272cce 100644
> > > --- a/drivers/md/dm.h
> > > +++ b/drivers/md/dm.h
> > > @@ -60,6 +60,7 @@ int dm_calculate_queue_limits(struct dm_table *table,
> > >  			      struct queue_limits *limits);
> > >  int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> > >  			      struct queue_limits *limits);
> > > +bool dm_table_has_blocking_dev(struct dm_table *t);
> > >  struct list_head *dm_table_get_devices(struct dm_table *t);
> > >  void dm_table_presuspend_targets(struct dm_table *t);
> > >  void dm_table_presuspend_undo_targets(struct dm_table *t);
> > > -- 
> > > 2.31.1
> > > 
> > 
> > Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> 
> Thanks!
> 
> > 
> > Late, given holidays we know why, but this patchset is needed for 5.17
> > (maybe with added: 'Fixes: 704b914f15fb7 "blk-mq: move srcu from
> > blk_mq_hw_ctx to request_queue"' to this 3rd patch?)
> 
> It is one long-term issue, not related with commit 704b914f15fb7. The
> problem is that rcu read lock is held by blk-mq when running dm_queue_rq()
> which calls underlying blocking queue's ->queue_rq() which may sleep
> somewhere.

OK, really don't _need_ a Fixes since it isn't getting marked for stable@ anyway.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

