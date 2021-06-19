Return-Path: <SRS0=NMpy=LN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87208C48BE8
	for <dm-devel@archiver.kernel.org>; Sat, 19 Jun 2021 00:27:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0E61661284
	for <dm-devel@archiver.kernel.org>; Sat, 19 Jun 2021 00:27:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E61661284
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624062453;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=h0623BvGnnJduiuWag3rNesPQKtseCpJshm0ZeGQOA8=;
	b=ARscwl4D+wp0ufx9hJ9QNcyHEWpSxMuDCeB/kQINSJiYedkFWuez5j0SluE2MIdx1uwsVS
	d8h7876VgygJIl/8VWW3b3SfvpBEesgX4CvPPf4nFIdV0FTW/IYmV7h7GQgSgcUP2rJfav
	vpso5xW6JVvYkHNcna51MHTBY7mj0Xc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-d0JYE5CDPeCB2RJOwFGrhw-1; Fri, 18 Jun 2021 20:27:31 -0400
X-MC-Unique: d0JYE5CDPeCB2RJOwFGrhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75F55800C78;
	Sat, 19 Jun 2021 00:27:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBA105D6CF;
	Sat, 19 Jun 2021 00:27:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B1C671809C9A;
	Sat, 19 Jun 2021 00:27:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15J0RKwL029181 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Jun 2021 20:27:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D94F75DA2D; Sat, 19 Jun 2021 00:27:20 +0000 (UTC)
Received: from T590 (ovpn-12-38.pek2.redhat.com [10.72.12.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 355175DD86;
	Sat, 19 Jun 2021 00:27:06 +0000 (UTC)
Date: Sat, 19 Jun 2021 08:27:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YM051cUoPjnymwR7@T590>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
	<5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
	<YMywCX6nLqLiHXyy@T590> <YM0IjWVuPya1SV0V@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YM0IjWVuPya1SV0V@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: JeffleXu <jefflexu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
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

On Fri, Jun 18, 2021 at 04:56:45PM -0400, Mike Snitzer wrote:
> [you really should've changed the subject of this email to
> "[RFC PATCH V3 3/3] dm: support bio polling"]
> 
> On Fri, Jun 18 2021 at 10:39P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > From 47e523b9ee988317369eaadb96826323cd86819e Mon Sep 17 00:00:00 2001
> > From: Ming Lei <ming.lei@redhat.com>
> > Date: Wed, 16 Jun 2021 16:13:46 +0800
> > Subject: [RFC PATCH V3 3/3] dm: support bio polling
> > 
> > Support bio(REQ_POLLED) polling in the following approach:
> > 
> > 1) only support io polling on normal READ/WRITE, and other abnormal IOs
> > still fallback on IRQ mode, so the target io is exactly inside the dm
> > io.
> > 
> > 2) hold one refcnt on io->io_count after submitting this dm bio with
> > REQ_POLLED
> > 
> > 3) support dm native bio splitting, any dm io instance associated with
> > current bio will be added into one list which head is bio->bi_end_io
> > which will be recovered before ending this bio
> > 
> > 4) implement .poll_bio() callback, call bio_poll() on the single target
> > bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
> > dec_pending() after the target io is done in .poll_bio()
> > 
> > 4) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
> > which is based on Jeffle's previous patch.
> 
> ^ nit: two "4)", last should be 5.
> 
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> > V3:
> > 	- covers all comments from Jeffle
> 
> Would really appreciate it if Jeffle could test these changes like he
> did previous dm IO polling patchsets he implemented.  Jeffle?

Yeah, I am looking forward to Jeffle's test too, :-)

> 
> > 	- fix corner cases when polling on abnormal ios
> > 
> >  drivers/md/dm-table.c |  24 ++++++++
> >  drivers/md/dm.c       | 127 ++++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 147 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index ee47a332b462..b14b379442d2 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1491,6 +1491,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
> >  	return &t->targets[(KEYS_PER_NODE * n) + k];
> >  }
> >  
> > +static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
> > +				   sector_t start, sector_t len, void *data)
> > +{
> > +	return !blk_queue_poll(bdev_get_queue(dev->bdev));
> > +}
> > +
> >  /*
> >   * type->iterate_devices() should be called when the sanity check needs to
> >   * iterate and check all underlying data devices. iterate_devices() will
> > @@ -1541,6 +1547,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
> >  	return 0;
> >  }
> >  
> > +static int dm_table_supports_poll(struct dm_table *t)
> > +{
> > +	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
> > +}
> > +
> >  /*
> >   * Check whether a table has no data devices attached using each
> >   * target's iterate_devices method.
> > @@ -2078,6 +2089,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  
> >  	dm_update_keyslot_manager(q, t);
> >  	blk_queue_update_readahead(q);
> > +
> > +	/*
> > +	 * Check for request-based device is remained to
> > +	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> > +	 * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> > +	 * devices supporting polling.
> > +	 */
> > +	if (__table_type_bio_based(t->type)) {
> > +		if (dm_table_supports_poll(t))
> > +			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> > +		else
> > +			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> > +	}
> >  }
> >  
> >  unsigned int dm_table_get_num_targets(struct dm_table *t)
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 363f12a285ce..df4a6a999014 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -39,6 +39,8 @@
> >  #define DM_COOKIE_ENV_VAR_NAME "DM_COOKIE"
> >  #define DM_COOKIE_LENGTH 24
> >  
> > +#define REQ_SAVED_END_IO             REQ_DRV
> > +
> >  static const char *_name = DM_NAME;
> >  
> >  static unsigned int major = 0;
> > @@ -72,6 +74,7 @@ struct clone_info {
> >  	struct dm_io *io;
> >  	sector_t sector;
> >  	unsigned sector_count;
> > +	bool	submit_as_polled;
> >  };
> >  
> >  /*
> > @@ -99,6 +102,8 @@ struct dm_io {
> >  	blk_status_t status;
> >  	atomic_t io_count;
> >  	struct bio *orig_bio;
> > +	void	*saved_bio_end_io;
> > +	struct hlist_node  node;
> >  	unsigned long start_time;
> >  	spinlock_t endio_lock;
> >  	struct dm_stats_aux stats_aux;
> 
> I'd need to check these changes with pahole, but have you looked
> closely at whether these new members would be better placed (e.g. is
> there an existing hole? does the new 'struct hlist_node' span a
> cacheline? etc).

'hlist_node' won't span a cacheline, and there isn't hole in 'dm_io'
available for the new two fields too.

But looks we have to add one extra cacheline for holding the two new
fields. Originally all fields except for the last one(dm_target_io)
can be held in single cacheline.

> 
> Also, a zoned dm-5.14 change moved this struct out to
> drivers/md/dm-core.h, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.14&id=e2118b3c3d94289852417f70ec128c25f4833aad
> 
> So seems no matter what we'll have a merge conflict.  But that's OK,
> I'll just let Linus know when I send the linux-dm.git pull request for
> the 5.14 merge window (assuming hch's bio polling changes land in time
> with Jens).
> 
> > @@ -687,6 +692,8 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
> >  	tio->ti = ti;
> >  	tio->target_bio_nr = target_bio_nr;
> >  
> > +	WARN_ON_ONCE(ci->submit_as_polled && !tio->inside_dm_io);
> > +
> >  	return tio;
> >  }
> >  
> > @@ -938,8 +945,14 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
> >  		end_io_acct(io);
> >  		free_io(md, io);
> >  
> > -		if (io_error == BLK_STS_DM_REQUEUE)
> > +		if (io_error == BLK_STS_DM_REQUEUE) {
> > +			/*
> > +			 * Upper layer won't help us poll split bio, so
> > +			 * clear REQ_POLLED in case of requeue
> > +			 */
> 
> This comment isn't very clear. Meaning block core cannot handle
> preserving old bio (which is poll cookie) across requeue?

bio->bi_cookie isn't used by dm queue yet, and we simply clear
POLLED if it isn't submitted directly or needs requeue. So in future,
bio->bi_cookie can be reused for other purpose.

The upper layer(FS) can only call bio_poll() on the bio which is submitted
via submit_bio() from upper layer code. And bio_poll() won't be called on
split bio originated from block layer or dm driver.

The above commit means that this bio may be split bio from bio_split()
in __split_and_process_bio(). And if it is requeued, we will handle it
in 'IRQ' mode, so it can be completed.

> 
> > +			bio->bi_opf &= ~REQ_POLLED;
> >  			return;
> > +		}
> >  
> >  		if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
> >  			/*
> > @@ -1574,6 +1587,32 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
> >  	return true;
> >  }
> >  
> > +static void dm_setup_polled_io(struct clone_info *ci)
> > +{
> > +	struct bio *bio = ci->bio;
> > +
> > +	/*
> > +	 * Only support bio polling for normal IO, and the target io is
> > +	 * exactly inside the dm io instance
> > +	 */
> 
> This comment should be clearer with:
> 
> > +	/*
> > +	 * Only support bio polling for normal IO that also
> > +	 * hasn't been split or cloned further.
> > +	 */

This bio could have been split in __split_and_process_bio() already and
re-submitted via submit_bio_noacct(), and we still can support poll on it
because it is always the bio originated from FS layer. All split bios(dm io)
from this bio are added into hlist which head is stored in this FS bio's bi_end_io().

> 
> That way DM's use of 'inside_dm_io' flag isn't a factor.
> (it just so happens 'inside_dm_io' reflects IO is first DM clone bio).
> 
> But wouldn't early return if !ci->io->tio.inside_dm_io also make sense
> here?  That way you could get rid of the WARN_ON_ONCE in dm_poll_dm_io?

inside_dm_io is always true here, and it will be updated in alloc_tio()
which isn't run yet.

> 
> > +	ci->submit_as_polled = !!(bio->bi_opf & REQ_POLLED);
> > +	if (!ci->submit_as_polled)
> > +		return;
> > +
> > +	INIT_HLIST_NODE(&ci->io->node);
> > +	/*
> > +	 * Save .bi_end_io into dm_io, so that we can reuse .bi_end_io
> > +	 * for storing dm_io list
> > +	 */
> > +	if (bio->bi_opf & REQ_SAVED_END_IO) {
> > +		ci->io->saved_bio_end_io = NULL;
> > +	} else {
> > +		ci->io->saved_bio_end_io = bio->bi_end_io;
> > +		INIT_HLIST_HEAD((struct hlist_head *)&bio->bi_end_io);
> > +		bio->bi_opf |= REQ_SAVED_END_IO;
> > +	}
> > +}
> > +
> >  /*
> >   * Select the correct strategy for processing a non-flush bio.
> >   */
> > @@ -1590,6 +1629,8 @@ static int __split_and_process_non_flush(struct clone_info *ci)
> >  	if (__process_abnormal_io(ci, ti, &r))
> >  		return r;
> >  
> > +	dm_setup_polled_io(ci);
> > +
> >  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> >  
> >  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
> > @@ -1666,8 +1707,18 @@ static void __split_and_process_bio(struct mapped_device *md,
> >  		}
> >  	}
> >  
> > -	/* drop the extra reference count */
> > -	dec_pending(ci.io, errno_to_blk_status(error));
> > +	/*
> > +	 * Drop the extra reference count for non-POLLED bio, and hold one
> > +	 * reference for POLLED bio, which will be released in dm_poll_bio
> > +	 *
> > +	 * Add every dm_io instance into the hlist_head which is stored in
> > +	 * bio->bi_end_io, so that dm_poll_bio can poll them all.
> > +	 */
> > +	if (!ci.submit_as_polled)
> > +		dec_pending(ci.io, errno_to_blk_status(error));
> > +	else
> > +		hlist_add_head(&ci.io->node,
> > +				(struct hlist_head *)&bio->bi_end_io);
> >  }
> >  
> >  static void dm_submit_bio(struct bio *bio)
> > @@ -1690,8 +1741,11 @@ static void dm_submit_bio(struct bio *bio)
> >  			bio_wouldblock_error(bio);
> >  		else if (bio->bi_opf & REQ_RAHEAD)
> >  			bio_io_error(bio);
> > -		else
> > +		else {
> > +			/* Not ready for poll */
> > +			bio->bi_opf &= ~REQ_POLLED;
> >  			queue_io(md, bio);
> > +		}
> 
> "Not ready for poll" isn't really a useful comment.  Maybe?:
> /* Cannot support polling once IO is queued */

We setup dm bio polling mechanism only after __split_and_process_bio()
is called, so 'not ready for poll'.

> 
> But should you just bio_wouldblock_error() the IO if REQ_POLLED set?
> Same as done for REQ_NOWAIT?

I guess we can't, because the two flags are independent.
> 
> (thought I've seen a comparable response to REQ_POLLED before but not
> finding one now that I look, maybe it was in Jeffle's earlier patchset?).
> 
> But all said, I'm missing why this particular instance of queue_io()
> is a problem relative to polling.  The bio will just block waiting to
> be processed, if blocking is a problem then it really does seem like
> bio_wouldblock_error() is appropriate.

It was cleared because I thought we can't call dm_poll_bio() for this
bio queued via queue_io() here, because we don't call dm_setup_polled_io
yet.

But looks we needn't to clear REQ_POLLED here, since REQ_SAVED_END_IO
isn't set for this bio, and it won't be polled in dm_poll_bio()
really until they are submitted finally.

> 
> And what about dm_io_dec_pending() should its use of queue_io() also
> clear REQ_POLLED (so push clearing REQ_POLLED into queue_io?)?
> Or is flush-with-data (via REQ_PREFLUSH) and REQ_POLLING mutually
> exclussive?

We only poll normal bio, and REQ_SAVED_END_IO isn't set for flush &
other abnormal bios, so they won't be polled via dm_poll_bio() really
and still rely on underlying's interrupt handler to complete.


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

