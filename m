Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D18C48BE6
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 16:05:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B9AA61164
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 16:05:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B9AA61164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623859537;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WPVNg6AvnE7ebvO2Dx3WVzggSWeL7Wzv20W+c3MHtDE=;
	b=CD5Mbkd+zlNBfxIvqb+TUjOfCH4X5xTWHXQ7+vKI95PNhraziT1+NxxkiH8hkOkEe3Hz9q
	K/EbM32d4SveGQetOIQWxXUuQpX7W8Fdmu+lqMwyZT0UMlbMJYbVETL6a7p3xwXG4YJ6wt
	DMaAfhn2+DmjsY7+WOUURHjIrbG26O0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-zcN8jkNzNM2RxqSJ6yQF2Q-1; Wed, 16 Jun 2021 12:05:35 -0400
X-MC-Unique: zcN8jkNzNM2RxqSJ6yQF2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FE08100C668;
	Wed, 16 Jun 2021 16:05:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6F041037F20;
	Wed, 16 Jun 2021 16:05:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B149546F59;
	Wed, 16 Jun 2021 16:05:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15GG5OnF018791 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 12:05:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A644B202879A; Wed, 16 Jun 2021 16:05:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A23ED216028B
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:05:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 427D880B926
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:05:21 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
	[209.85.219.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-175-fg0iGqwlPZmzAwdmWRCsMA-1; Wed, 16 Jun 2021 12:05:17 -0400
X-MC-Unique: fg0iGqwlPZmzAwdmWRCsMA-1
Received: by mail-qv1-f44.google.com with SMTP id x6so1825150qvx.4;
	Wed, 16 Jun 2021 09:05:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=WhJvDM8RFKP8VCl/aredIhXrpJyPqDIkrwkoKNyfGPY=;
	b=ilODfRLIKKCKVQkcNb6z+yG2rL70BY4MyfBHCYJU6oPV/zAC5G+GVZqXQNUfFUu5LD
	ZuqBZP2kWToalrntX+XCOr3pj73xvGflwY6ExJtn1qnWgz2hX6q8dpMCU5qrK5Sgtg7M
	3U/XPE7naFRjVSrvijfpUIg4WrNP65BJ36z/Tyvep2GKHadhGyG3d/6qZ2IbXw1tXnL7
	e92302XPElXtOkTaKIyqPSHwMYAGlLWh/pgAHSCMHWMr0jHGhDpri19sJUmRdUBSX013
	xrXmEEE0xcU3MmaQBQmzStiwUweh84t8CI6GawR1XuA6RzCDwbVM/jq2OmnhEbS9+I95
	nfmw==
X-Gm-Message-State: AOAM533QGU89pb6fJzonJ/QRXkTu+gAAlk14nutUoS17LMyet9FrfIA5
	Jeint0k7MTA+OInCjvRrGuvD6D6xghG3uA==
X-Google-Smtp-Source: ABdhPJxUXmQY69GLCqEPqb/S7NzJh+rYAXrKGL3LRvLp5QFl+nd9+6S5vnsro7jetvBCY527FbZ2NA==
X-Received: by 2002:a0c:c68d:: with SMTP id d13mr765778qvj.60.1623859515708;
	Wed, 16 Jun 2021 09:05:15 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	t139sm1774717qka.85.2021.06.16.09.05.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 16 Jun 2021 09:05:14 -0700 (PDT)
Date: Wed, 16 Jun 2021 12:05:13 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Message-ID: <YMohOUlopTcO1Bzd@redhat.com>
References: <20210616130533.754248-1-ming.lei@redhat.com>
	<20210616130533.754248-5-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210616130533.754248-5-ming.lei@redhat.com>
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
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [RFC PATCH 4/4] dm: support bio polling
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 16 2021 at  9:05P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> Support bio(REQ_POLLED) polling in the following approach:
> 
> 1) setup one list in instance of 'struct dm_io', adds every 'struct
> dm_target_io' instance cloned for current dm bio into this list;
> store the list in 1) into bio->bi_bio_drv_data
> 
> 2) hold one refcnt on io->io_count after submitting this dm bio with
> REQ_POLLED
> 
> 4) implement .poll_bio() callback, and iterate over the list in 1) and
> polled on each ->clone of 'dm_target_io' instance; call dec_pending()
> if all target ios are done in .poll_bio().
> 
> 4) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
> which is based on Jeffle's previous patch.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Thanks for refreshing this DM bio polling support Ming.

In general I'm really happy to see polling switch over to using bios,
nice job Christoph! Are you hoping for all this to land in time for
5.14 merge?

Once Ming responds to my review inlined below, and I Acked-by his
set, would you be willing to fold it at the end of your patchset so
that I don't need to rebase on block to get these changes in, etc?

Mike

> ---
>  drivers/md/dm-table.c | 24 ++++++++++++++++++
>  drivers/md/dm.c       | 59 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 79 insertions(+), 4 deletions(-)
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
> index 363f12a285ce..0a0e4a38f435 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -84,6 +84,7 @@ struct dm_target_io {
>  	struct dm_target *ti;
>  	unsigned target_bio_nr;
>  	unsigned *len_ptr;
> +	struct list_head list;
>  	bool inside_dm_io;
>  	struct bio clone;
>  };
> @@ -99,6 +100,7 @@ struct dm_io {
>  	blk_status_t status;
>  	atomic_t io_count;
>  	struct bio *orig_bio;
> +	struct list_head poll_head;
>  	unsigned long start_time;
>  	spinlock_t endio_lock;
>  	struct dm_stats_aux stats_aux;
> @@ -655,6 +657,11 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
>  	io->md = md;
>  	spin_lock_init(&io->endio_lock);
>  
> +	if (bio->bi_opf & REQ_POLLED) {
> +		bio->bi_bio_drv_data = io;
> +		INIT_LIST_HEAD(&io->poll_head);
> +	}
> +
>  	start_io_acct(io);
>  
>  	return io;
> @@ -692,6 +699,8 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci, struct dm_target *t
>  
>  static void free_tio(struct dm_target_io *tio)
>  {
> +	list_del_init(&tio->list);
> +
>  	if (tio->inside_dm_io)
>  		return;
>  	bio_put(&tio->clone);
> @@ -936,10 +945,15 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>  		io_error = io->status;
>  		bio = io->orig_bio;
>  		end_io_acct(io);
> +
>  		free_io(md, io);
>  
> -		if (io_error == BLK_STS_DM_REQUEUE)
> +		if (io_error == BLK_STS_DM_REQUEUE) {
> +			/* not poll any more in case of requeue */
> +			if (bio->bi_opf & REQ_POLLED)
> +				bio->bi_opf &= ~REQ_POLLED;
>  			return;
> +		}
>  
>  		if ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
>  			/*
> @@ -1043,7 +1057,9 @@ static void clone_endio(struct bio *bio)
>  		up(&md->swap_bios_semaphore);
>  	}
>  
> -	free_tio(tio);
> +	/* Any cloned bio submitted as POLLED, free them all after dm_io is done */
> +	if (list_empty(&tio->list))
> +		free_tio(tio);
>  	dec_pending(io, error);
>  }
>  
> @@ -1300,6 +1316,11 @@ static void __map_bio(struct dm_target_io *tio)
>  	struct dm_io *io = tio->io;
>  	struct dm_target *ti = tio->ti;
>  
> +	if (clone->bi_opf & REQ_POLLED)
> +		list_add_tail(&tio->list, &io->poll_head);
> +	else
> +		INIT_LIST_HEAD(&tio->list);
> +

Why not INIT_LIST_HEAD() at end of alloc_tio()? Shouldn't that be done
even if you have this else claue here because you can clear REQ_POLLED
on BLK_STS_DM_REQUEUE? (otherwise you're calling list_add_tail on list
that wasn't ever INIT_LIST_HEAD).

>  	clone->bi_end_io = clone_endio;
>  
>  	/*
> @@ -1666,8 +1687,9 @@ static void __split_and_process_bio(struct mapped_device *md,
>  		}
>  	}
>  
> -	/* drop the extra reference count */
> -	dec_pending(ci.io, errno_to_blk_status(error));
> +	/* drop the extra reference count for non-POLLED bio */
> +	if (!(bio->bi_opf & REQ_POLLED))
> +		dec_pending(ci.io, errno_to_blk_status(error));
>  }
>  
>  static void dm_submit_bio(struct bio *bio)
> @@ -1707,6 +1729,34 @@ static void dm_submit_bio(struct bio *bio)
>  	dm_put_live_table(md, srcu_idx);
>  }
>  
> +static int dm_poll_bio(struct bio *bio, unsigned int flags)
> +{
> +	struct dm_io *io = bio->bi_bio_drv_data;
> +	struct dm_target_io *tio;
> +
> +	if (!(bio->bi_opf & REQ_POLLED) || !io)
> +		return 0;

Should this be a WARN_ON()? Cannot see why this would ever happen
other than a bug?  Or is there some race that makes it more likely?

> +	list_for_each_entry(tio, &io->poll_head, list)
> +		bio_poll(&tio->clone, flags);
> +
> +	/* bio_poll holds the last reference */
> +	if (atomic_read(&io->io_count) == 1) {
> +		/* free all target IOs submitted as POLLED */
> +		while (!list_empty(&io->poll_head)) {
> +			struct dm_target_io *tio =
> +				list_entry(io->poll_head.next,
> +					struct dm_target_io, list);
> +			free_tio(tio);
> +		}
> +		bio->bi_bio_drv_data = NULL;
> +		dec_pending(io, 0);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  /*-----------------------------------------------------------------
>   * An IDR is used to keep track of allocated minor numbers.
>   *---------------------------------------------------------------*/
> @@ -3121,6 +3171,7 @@ static const struct pr_ops dm_pr_ops = {
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

