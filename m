Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBE3C48BE8
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 20:57:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2DAB660E09
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 20:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DAB660E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624049829;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GHJsCgt5Xsc9OrQSWhwmLYgJzVA8gwOUB94+dzoK/p0=;
	b=QH6hQpsl/AWkMTq9Jm+m2GAaYJ1JTRyEOe3CHh7thD5OOkcL98EOf7jFnIqZWOzj7mrkCv
	YULxx+Op8MylCABELk3vzXQi+HAbzUItHTxTfRSXw2xsl0P2segqxIjI7D5N+rII2jgEdW
	oQnkTfEEmfBEjTq0WKhCWGua//Zh/2g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-JQc0RIv_NJeLKnMj28P5dg-1; Fri, 18 Jun 2021 16:57:07 -0400
X-MC-Unique: JQc0RIv_NJeLKnMj28P5dg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBE298018A5;
	Fri, 18 Jun 2021 20:57:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 001DF5D703;
	Fri, 18 Jun 2021 20:57:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED3171809C99;
	Fri, 18 Jun 2021 20:56:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15IKutuW011123 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Jun 2021 16:56:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EE15F2144B23; Fri, 18 Jun 2021 20:56:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E94432144B20
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 20:56:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A161089C7DC
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 20:56:52 +0000 (UTC)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com
	[209.85.222.180]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-150-KK3WFdaiOUWCIEvbH5YUBQ-1; Fri, 18 Jun 2021 16:56:48 -0400
X-MC-Unique: KK3WFdaiOUWCIEvbH5YUBQ-1
Received: by mail-qk1-f180.google.com with SMTP id c138so14161295qkg.5;
	Fri, 18 Jun 2021 13:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=kafwSGNGUNJzWw049Gf0fFDZI9AdwIy0x2E8V1SSzSg=;
	b=Tgs9/cSBu+2zYYvxjv/ux6XorZWCXpRrPgh78ENx7wwPrqBms3iV/TXo1mnha2DAWa
	y9a2MFt9BkAoGdGFrJyWmEFMnXZj9bn1AvFWwmyTfAqym9/50PW6W1QWrBetqC++L5Qq
	KSw9y4N76mHrQkWaf2jiUzFBuvzJeaHU0wrVS8iUlCn9144x2V3Fa0P081rFwx07EYJH
	9Lh7gJlyJ5joFZH0PHYFoI9Hkz1wIt0y6jBvLKjGsrTyecTqBSyVDo8g/dB2Vk2s+B5u
	x+jNLQWifaoHK0gVm/JVwLPNFZyYSFvJ2tgFag7GMeQvhuSqp1GxzdzhTa48BcvLmEVQ
	y1Xw==
X-Gm-Message-State: AOAM532R52J1Z8bXC5qWIWnp7OopADrFcm+ZnR1yoA0ES74vwtjX1RyX
	N30eqmTY0K+f041N/x0ANdCqY7LUi5n8rQ==
X-Google-Smtp-Source: ABdhPJz5u3wnGPOBys1eXTEQos/nlQMji1EwryUFhzRGn93HlM34P59USWOlnV9eLt69PtNIrzdAxA==
X-Received: by 2002:a37:4392:: with SMTP id q140mr11578739qka.49.1624049807645;
	Fri, 18 Jun 2021 13:56:47 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	b132sm4909092qkg.116.2021.06.18.13.56.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 18 Jun 2021 13:56:46 -0700 (PDT)
Date: Fri, 18 Jun 2021 16:56:45 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>, JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YM0IjWVuPya1SV0V@redhat.com>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
	<5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
	<YMywCX6nLqLiHXyy@T590>
MIME-Version: 1.0
In-Reply-To: <YMywCX6nLqLiHXyy@T590>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 3/3] dm: support bio polling
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

[you really should've changed the subject of this email to
"[RFC PATCH V3 3/3] dm: support bio polling"]

On Fri, Jun 18 2021 at 10:39P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> From 47e523b9ee988317369eaadb96826323cd86819e Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@redhat.com>
> Date: Wed, 16 Jun 2021 16:13:46 +0800
> Subject: [RFC PATCH V3 3/3] dm: support bio polling
> 
> Support bio(REQ_POLLED) polling in the following approach:
> 
> 1) only support io polling on normal READ/WRITE, and other abnormal IOs
> still fallback on IRQ mode, so the target io is exactly inside the dm
> io.
> 
> 2) hold one refcnt on io->io_count after submitting this dm bio with
> REQ_POLLED
> 
> 3) support dm native bio splitting, any dm io instance associated with
> current bio will be added into one list which head is bio->bi_end_io
> which will be recovered before ending this bio
> 
> 4) implement .poll_bio() callback, call bio_poll() on the single target
> bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
> dec_pending() after the target io is done in .poll_bio()
> 
> 4) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
> which is based on Jeffle's previous patch.

^ nit: two "4)", last should be 5.

> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V3:
> 	- covers all comments from Jeffle

Would really appreciate it if Jeffle could test these changes like he
did previous dm IO polling patchsets he implemented.  Jeffle?

> 	- fix corner cases when polling on abnormal ios
> 
>  drivers/md/dm-table.c |  24 ++++++++
>  drivers/md/dm.c       | 127 ++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 147 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index ee47a332b462..b14b379442d2 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1491,6 +1491,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
>  	return &t->targets[(KEYS_PER_NODE * n) + k];
>  }
>  
> +static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
> +				   sector_t start, sector_t len, void *data)
> +{
> +	return !blk_queue_poll(bdev_get_queue(dev->bdev));
> +}
> +
>  /*
>   * type->iterate_devices() should be called when the sanity check needs to
>   * iterate and check all underlying data devices. iterate_devices() will
> @@ -1541,6 +1547,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
>  	return 0;
>  }
>  
> +static int dm_table_supports_poll(struct dm_table *t)
> +{
> +	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
> +}
> +
>  /*
>   * Check whether a table has no data devices attached using each
>   * target's iterate_devices method.
> @@ -2078,6 +2089,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  
>  	dm_update_keyslot_manager(q, t);
>  	blk_queue_update_readahead(q);
> +
> +	/*
> +	 * Check for request-based device is remained to
> +	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> +	 * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> +	 * devices supporting polling.
> +	 */
> +	if (__table_type_bio_based(t->type)) {
> +		if (dm_table_supports_poll(t))
> +			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> +		else
> +			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> +	}
>  }
>  
>  unsigned int dm_table_get_num_targets(struct dm_table *t)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 363f12a285ce..df4a6a999014 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -39,6 +39,8 @@
>  #define DM_COOKIE_ENV_VAR_NAME "DM_COOKIE"
>  #define DM_COOKIE_LENGTH 24
>  
> +#define REQ_SAVED_END_IO             REQ_DRV
> +
>  static const char *_name = DM_NAME;
>  
>  static unsigned int major = 0;
> @@ -72,6 +74,7 @@ struct clone_info {
>  	struct dm_io *io;
>  	sector_t sector;
>  	unsigned sector_count;
> +	bool	submit_as_polled;
>  };
>  
>  /*
> @@ -99,6 +102,8 @@ struct dm_io {
>  	blk_status_t status;
>  	atomic_t io_count;
>  	struct bio *orig_bio;
> +	void	*saved_bio_end_io;
> +	struct hlist_node  node;
>  	unsigned long start_time;
>  	spinlock_t endio_lock;
>  	struct dm_stats_aux stats_aux;

I'd need to check these changes with pahole, but have you looked
closely at whether these new members would be better placed (e.g. is
there an existing hole? does the new 'struct hlist_node' span a
cacheline? etc).

Also, a zoned dm-5.14 change moved this struct out to
drivers/md/dm-core.h, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.14&id=e2118b3c3d94289852417f70ec128c25f4833aad

So seems no matter what we'll have a merge conflict.  But that's OK,
I'll just let Linus know when I send the linux-dm.git pull request for
the 5.14 merge window (assuming hch's bio polling changes land in time
with Jens).

> @@ -687,6 +692,8 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
>  	tio->ti = ti;
>  	tio->target_bio_nr = target_bio_nr;
>  
> +	WARN_ON_ONCE(ci->submit_as_polled && !tio->inside_dm_io);
> +
>  	return tio;
>  }
>  
> @@ -938,8 +945,14 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>  		end_io_acct(io);
>  		free_io(md, io);
>  
> -		if (io_error == BLK_STS_DM_REQUEUE)
> +		if (io_error == BLK_STS_DM_REQUEUE) {
> +			/*
> +			 * Upper layer won't help us poll split bio, so
> +			 * clear REQ_POLLED in case of requeue
> +			 */

This comment isn't very clear. Meaning block core cannot handle
preserving old bio (which is poll cookie) across requeue?

> +			bio->bi_opf &= ~REQ_POLLED;
>  			return;
> +		}
>  
>  		if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
>  			/*
> @@ -1574,6 +1587,32 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
>  	return true;
>  }
>  
> +static void dm_setup_polled_io(struct clone_info *ci)
> +{
> +	struct bio *bio = ci->bio;
> +
> +	/*
> +	 * Only support bio polling for normal IO, and the target io is
> +	 * exactly inside the dm io instance
> +	 */

This comment should be clearer with:

> +	/*
> +	 * Only support bio polling for normal IO that also
> +	 * hasn't been split or cloned further.
> +	 */

That way DM's use of 'inside_dm_io' flag isn't a factor.
(it just so happens 'inside_dm_io' reflects IO is first DM clone bio).

But wouldn't early return if !ci->io->tio.inside_dm_io also make sense
here?  That way you could get rid of the WARN_ON_ONCE in dm_poll_dm_io?

> +	ci->submit_as_polled = !!(bio->bi_opf & REQ_POLLED);
> +	if (!ci->submit_as_polled)
> +		return;
> +
> +	INIT_HLIST_NODE(&ci->io->node);
> +	/*
> +	 * Save .bi_end_io into dm_io, so that we can reuse .bi_end_io
> +	 * for storing dm_io list
> +	 */
> +	if (bio->bi_opf & REQ_SAVED_END_IO) {
> +		ci->io->saved_bio_end_io = NULL;
> +	} else {
> +		ci->io->saved_bio_end_io = bio->bi_end_io;
> +		INIT_HLIST_HEAD((struct hlist_head *)&bio->bi_end_io);
> +		bio->bi_opf |= REQ_SAVED_END_IO;
> +	}
> +}
> +
>  /*
>   * Select the correct strategy for processing a non-flush bio.
>   */
> @@ -1590,6 +1629,8 @@ static int __split_and_process_non_flush(struct clone_info *ci)
>  	if (__process_abnormal_io(ci, ti, &r))
>  		return r;
>  
> +	dm_setup_polled_io(ci);
> +
>  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
>  
>  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
> @@ -1666,8 +1707,18 @@ static void __split_and_process_bio(struct mapped_device *md,
>  		}
>  	}
>  
> -	/* drop the extra reference count */
> -	dec_pending(ci.io, errno_to_blk_status(error));
> +	/*
> +	 * Drop the extra reference count for non-POLLED bio, and hold one
> +	 * reference for POLLED bio, which will be released in dm_poll_bio
> +	 *
> +	 * Add every dm_io instance into the hlist_head which is stored in
> +	 * bio->bi_end_io, so that dm_poll_bio can poll them all.
> +	 */
> +	if (!ci.submit_as_polled)
> +		dec_pending(ci.io, errno_to_blk_status(error));
> +	else
> +		hlist_add_head(&ci.io->node,
> +				(struct hlist_head *)&bio->bi_end_io);
>  }
>  
>  static void dm_submit_bio(struct bio *bio)
> @@ -1690,8 +1741,11 @@ static void dm_submit_bio(struct bio *bio)
>  			bio_wouldblock_error(bio);
>  		else if (bio->bi_opf & REQ_RAHEAD)
>  			bio_io_error(bio);
> -		else
> +		else {
> +			/* Not ready for poll */
> +			bio->bi_opf &= ~REQ_POLLED;
>  			queue_io(md, bio);
> +		}

"Not ready for poll" isn't really a useful comment.  Maybe?:
/* Cannot support polling once IO is queued */

But should you just bio_wouldblock_error() the IO if REQ_POLLED set?
Same as done for REQ_NOWAIT?

(thought I've seen a comparable response to REQ_POLLED before but not
finding one now that I look, maybe it was in Jeffle's earlier patchset?).

But all said, I'm missing why this particular instance of queue_io()
is a problem relative to polling.  The bio will just block waiting to
be processed, if blocking is a problem then it really does seem like
bio_wouldblock_error() is appropriate.

And what about dm_io_dec_pending() should its use of queue_io() also
clear REQ_POLLED (so push clearing REQ_POLLED into queue_io?)?
Or is flush-with-data (via REQ_PREFLUSH) and REQ_POLLING mutually
exclussive?

>  		goto out;
>  	}
>  
> @@ -1707,6 +1761,70 @@ static void dm_submit_bio(struct bio *bio)
>  	dm_put_live_table(md, srcu_idx);
>  }
>  
> +static bool dm_poll_dm_io(struct dm_io *io, unsigned int flags)
> +{
> +	WARN_ON_ONCE(!io->tio.inside_dm_io);
> +
> +	bio_poll(&io->tio.clone, flags);
> +
> +	/* bio_poll holds the last reference */
> +	return atomic_read(&io->io_count) == 1;
> +}
> +
> +static int dm_poll_bio(struct bio *bio, unsigned int flags)
> +{
> +	struct dm_io *io;
> +	void *saved_bi_end_io = NULL;
> +	struct hlist_head tmp = HLIST_HEAD_INIT;
> +	struct hlist_head *head = (struct hlist_head *)&bio->bi_end_io;
> +	struct hlist_node *next;
> +
> +	/*
> +	 * This bio can be submitted from FS as POLLED so that FS may keep
> +	 * polling even though the flag is cleared by bio splitting or
> +	 * requeue, so return immediately.
> +	 */
> +	if (!(bio->bi_opf & REQ_POLLED))
> +		return 0;
> +
> +	/* We only poll normal bio which was marked as REQ_SAVED_END_IO */
> +	if (!(bio->bi_opf & REQ_SAVED_END_IO))
> +		return 0;
> +
> +	WARN_ON_ONCE(hlist_empty(head));
> +
> +	hlist_move_list(head, &tmp);
> +
> +	hlist_for_each_entry(io, &tmp, node) {
> +		if (io->saved_bio_end_io) {
> +			saved_bi_end_io = io->saved_bio_end_io;
> +			break;
> +		}
> +	}
> +
> +	/* restore .bi_end_io before completing dm io */
> +	WARN_ON_ONCE(!saved_bi_end_io);
> +	bio->bi_opf &= ~REQ_SAVED_END_IO;
> +	bio->bi_end_io = saved_bi_end_io;
> +
> +	hlist_for_each_entry_safe(io, next, &tmp, node) {
> +		if (dm_poll_dm_io(io, flags)) {
> +			hlist_del_init(&io->node);
> +			dec_pending(io, 0);
> +		}
> +	}
> +
> +	/* Not done, make sure at least one dm_io stores the .bi_end_io*/
> +	if (!hlist_empty(&tmp)) {
> +		io = hlist_entry(tmp.first, struct dm_io, node);
> +		io->saved_bio_end_io = saved_bi_end_io;
> +		bio->bi_opf |= REQ_SAVED_END_IO;
> +		hlist_move_list(&tmp, head);
> +		return 0;
> +	}
> +	return 1;
> +}
> +
>  /*-----------------------------------------------------------------
>   * An IDR is used to keep track of allocated minor numbers.
>   *---------------------------------------------------------------*/
> @@ -3121,6 +3239,7 @@ static const struct pr_ops dm_pr_ops = {
>  
>  static const struct block_device_operations dm_blk_dops = {
>  	.submit_bio = dm_submit_bio,
> +	.poll_bio = dm_poll_bio,
>  	.open = dm_blk_open,
>  	.release = dm_blk_close,
>  	.ioctl = dm_blk_ioctl,
> -- 
> 2.31.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

