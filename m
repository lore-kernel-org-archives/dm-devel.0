Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A11C48BE8
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 13:36:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BACCA611CC
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 13:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BACCA611CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1624023395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9YHV2ARXpIGc4de/PEHKqgMkpeU06USl4+a1g0R7sC8=;
	b=EBmtBWkCpAPN8pLaw6TSarSdD7ea8XRpPxPkSfAE5g0WltjF7qdC8HtfsArRH65udc5eQS
	79bjVQESN9zzXNPZUNPBQv3/12TtZsv75RX+OF/QhWjTCIBdQ+kmf/aKS0qwxxO/FlfBKB
	rt1YuhPHCl7EGr1SZatW2Bs/tMbINW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-Pn3e3MM6Pti9BoEUgsoh9A-1; Fri, 18 Jun 2021 09:36:34 -0400
X-MC-Unique: Pn3e3MM6Pti9BoEUgsoh9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D3E710C1ADC;
	Fri, 18 Jun 2021 13:36:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A01C82CAC0;
	Fri, 18 Jun 2021 13:36:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E80C46F58;
	Fri, 18 Jun 2021 13:36:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15IDU5lE004037 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Jun 2021 09:30:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D2AAE60FC2; Fri, 18 Jun 2021 13:30:05 +0000 (UTC)
Received: from T590 (ovpn-12-158.pek2.redhat.com [10.72.12.158])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE04160CC9;
	Fri, 18 Jun 2021 13:29:51 +0000 (UTC)
Date: Fri, 18 Jun 2021 21:29:47 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YMyfy49I22KIlNOJ@T590>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
	<5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <5ba43dac-b960-7c85-3a89-fdae2d1e2f51@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Jeffle,

On Fri, Jun 18, 2021 at 04:19:10PM +0800, JeffleXu wrote:
> 
> 
> On 6/17/21 6:35 PM, Ming Lei wrote:
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
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/dm-table.c |  24 +++++++++
> >  drivers/md/dm.c       | 111 ++++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 132 insertions(+), 3 deletions(-)
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
> > index 363f12a285ce..9745c3deacc3 100644
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
> > @@ -97,8 +99,11 @@ struct dm_io {
> >  	unsigned magic;
> >  	struct mapped_device *md;
> >  	blk_status_t status;
> > +	bool	submit_as_polled;
> >  	atomic_t io_count;
> >  	struct bio *orig_bio;
> > +	void	*saved_bio_end_io;
> > +	struct hlist_node  node;
> >  	unsigned long start_time;
> >  	spinlock_t endio_lock;
> >  	struct dm_stats_aux stats_aux;
> > @@ -687,6 +692,8 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
> >  	tio->ti = ti;
> >  	tio->target_bio_nr = target_bio_nr;
> >  
> > +	WARN_ON_ONCE(ci->io->submit_as_polled && !tio->inside_dm_io);
> > +
> >  	return tio;
> >  }
> >  
> > @@ -938,8 +945,12 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
> >  		end_io_acct(io);
> >  		free_io(md, io);
> >  
> > -		if (io_error == BLK_STS_DM_REQUEUE)
> > +		if (io_error == BLK_STS_DM_REQUEUE) {
> > +			/* not poll any more in case of requeue */
> > +			if (bio->bi_opf & REQ_POLLED)
> > +				bio->bi_opf &= ~REQ_POLLED;
> >  			return;
> > +		}
> 
> Actually I'm not sure why REQ_POLLED should be cleared here.

It this is one dm native split bio(the one returned from bio_split() in 
__split_and_process_bio()), we will never get chance to poll it after it
is requeued.

> 
> Besides, there's one corner case where bio is submitted when dm device
> is suspended.
> 
> ```
> static blk_qc_t dm_submit_bio(struct bio *bio)
> 
> 	/* If suspended, queue this IO for later */
> 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
> 		if (bio->bi_opf & REQ_NOWAIT)
> 			bio_wouldblock_error(bio);
> 		else if (bio->bi_opf & REQ_RAHEAD)
> 			bio_io_error(bio);
> 		else
> 			queue_io(md, bio);
> 		goto out;
> 	}
> ```
> 
> When the dm device is suspended with DMF_BLOCK_IO_FOR_SUSPEND, the
> submitted bio is inserted into @md->deferred list by calling queue_io().
> Then the following bio_poll() calling will trigger the
> 'WARN_ON_ONCE(!saved_bi_end_io)' in dm_poll_bio(), if the previously
> submitted bio is still buffered in @md->deferred list.

Good catch, bio_poll() shouldn't call on bio which isn't submitted
really, we can clear REQ_POLLED for avoiding the race. 

> 
> ```
> submit_bio()
>   dm_submit_bio
>     queue_io
> 
> bio_poll
>   dm_poll_bio
> ```
> 
> 
> >  
> >  		if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
> >  			/*
> > @@ -1590,6 +1601,12 @@ static int __split_and_process_non_flush(struct clone_info *ci)
> >  	if (__process_abnormal_io(ci, ti, &r))
> >  		return r;
> >  
> > +	/*
> > +	 * Only support bio polling for normal IO, and the target io is
> > +	 * exactly inside the dm io instance
> > +	 */
> > +	ci->io->submit_as_polled = !!(ci->bio->bi_opf & REQ_POLLED);
> > +
> >  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> >  
> >  	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
> > @@ -1608,6 +1625,22 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
> >  	ci->map = map;
> >  	ci->io = alloc_io(md, bio);
> >  	ci->sector = bio->bi_iter.bi_sector;
> > +
> > +	if (bio->bi_opf & REQ_POLLED) {
> > +		INIT_HLIST_NODE(&ci->io->node);
> > +
> > +		/*
> > +		 * Save .bi_end_io into dm_io, so that we can reuse .bi_end_io
> > +		 * for storing dm_io list
> > +		 */
> > +		if (bio->bi_opf & REQ_SAVED_END_IO) {
> > +			ci->io->saved_bio_end_io = NULL;
> > +		} else {
> > +			ci->io->saved_bio_end_io = bio->bi_end_io;
> > +			INIT_HLIST_HEAD((struct hlist_head *)&bio->bi_end_io);
> > +			bio->bi_opf |= REQ_SAVED_END_IO;
> > +		}
> > +	}
> >  }
> >  
> >  #define __dm_part_stat_sub(part, field, subnd)	\
> > @@ -1666,8 +1699,19 @@ static void __split_and_process_bio(struct mapped_device *md,
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
> > +	if (!ci.io->submit_as_polled)
> > +		dec_pending(ci.io, errno_to_blk_status(error));
> > +	else
> > +		hlist_add_head(&ci.io->node,
> > +				(struct hlist_head *)&bio->bi_end_io);
> > +
> >  }
> >  
> >  static void dm_submit_bio(struct bio *bio)
> > @@ -1707,6 +1751,66 @@ static void dm_submit_bio(struct bio *bio)
> >  	dm_put_live_table(md, srcu_idx);
> >  }
> >  
> > +static int dm_poll_dm_io(struct dm_io *io, unsigned int flags)
> > +{
> > +	if (!io || !io->submit_as_polled)
> > +		return 0;
> 
> Wondering if '!io->submit_as_polled' is necessary here. dm_io will be
> added into the hash list only when 'io->submit_as_polled' is true in
> __split_and_process_bio.

OK, we can kill the above check.

> 
> 
> > +
> > +	WARN_ON_ONCE(!io->tio.inside_dm_io);
> > +	bio_poll(&io->tio.clone, flags);
> > +
> > +	/* bio_poll holds the last reference */
> > +	if (atomic_read(&io->io_count) == 1)
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static int dm_poll_bio(struct bio *bio, unsigned int flags)
> > +{
> > +	struct dm_io *io;
> > +	void *saved_bi_end_io = NULL;
> > +	struct hlist_head tmp = HLIST_HEAD_INIT;
> > +	struct hlist_head *head = (struct hlist_head *)&bio->bi_end_io;
> > +	struct hlist_node *next;
> > +
> > +	/*
> > +	 * This bio can be submitted from FS as POLLED so that FS may keep
> > +	 * polling even though the flag is cleared by bio splitting or
> > +	 * requeue, so return immediately.
> > +	 */
> > +	if (!(bio->bi_opf & REQ_POLLED))
> > +		return 0;
> > +
> > +	hlist_move_list(head, &tmp);
> > +
> > +	hlist_for_each_entry(io, &tmp, node) {
> > +		if (io->saved_bio_end_io && !saved_bi_end_io) {
> 
> Seems that checking if saved_bi_end_io NULL here is not necessary, since
> you will exit thte loop once saved_bi_end_io is assigned.

Yeah, indeed.

> 
> 
> 
> > +			saved_bi_end_io = io->saved_bio_end_io;
> > +			break;
> > +		}
> > +	}
> > +
> > +	/* restore .bi_end_io before completing dm io */
> > +	WARN_ON_ONCE(!saved_bi_end_io);
> 
> Abnormal bio flagged with REQ_POLLED (is this possible?) can still be
> called with dm_poll_bio(), and will trigger this warning.

OK, I think we need to return 0 from dm_poll_bio() immediately if
the hlist stored in bio->bi_end_io is empty.


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

