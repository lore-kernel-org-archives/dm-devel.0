Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD7EC636D3
	for <dm-devel@archiver.kernel.org>; Fri,  3 Feb 2023 02:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675389643;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Yp3vDYMPvRkmog6eveM+6D5g3CHMY8Bhxj3vjD8UQE4=;
	b=ha42oEHlcpIHYYyg7I+11CGkPb6t3Sx4fxYm04xvKjXllfQppeoRaOunJxJlmF778wrXVw
	KsIttH2saT3iXyYqnesLdQdgZ9bpafdYL6LNv31IRpb9xPhrhMjxSehlz5SpP6Y9py3bGV
	lBZhVMSXooAqQVhn5zVaT24k3hNnumY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-LJRDXAhLNjGk7l8_GpxGjQ-1; Thu, 02 Feb 2023 21:00:40 -0500
X-MC-Unique: LJRDXAhLNjGk7l8_GpxGjQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FA7B101A521;
	Fri,  3 Feb 2023 02:00:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1BBD3492C14;
	Fri,  3 Feb 2023 02:00:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0116B194658C;
	Fri,  3 Feb 2023 02:00:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 427BB1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Feb 2023 02:00:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DB2D2166B34; Fri,  3 Feb 2023 02:00:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 26CE82166B33
 for <dm-devel@redhat.com>; Fri,  3 Feb 2023 02:00:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2E1F802314
 for <dm-devel@redhat.com>; Fri,  3 Feb 2023 02:00:33 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-0rZ-Q8zHMm6Hv-AJBA5UuQ-1; Thu, 02 Feb 2023 21:00:31 -0500
X-MC-Unique: 0rZ-Q8zHMm6Hv-AJBA5UuQ-1
Received: by mail-qt1-f174.google.com with SMTP id g7so4134933qto.11
 for <dm-devel@redhat.com>; Thu, 02 Feb 2023 18:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=WNAXgpbtcZRCTNBMsTEAXSDSa4OEwcc+H5wD8QDm/E8=;
 b=GJPauTNsGj2ExZbvUazpUWl6L0Vqzv6s90TD81+Lt+LOt6aHMQc6nQoBfFdCrMFT/5
 PCarUpSwJ1zJOS7K9oVD9R/A5Y2JEJQlXOgkShxCtha8s8N3VNjy/ZpdhdF1UnyWM3SB
 qXGqkqRpBdOjeQMz4zKsaa3VwToTg/MvQxet4v+gQ1CRz3WaivGxMQclBesIRZ40z1rX
 vWv9W5fbvm4ycyj4Qf3qOQXZUd/xYMyc+vT/es5q2zqjq2vDka9QunWEHRDvXpmGqBAW
 Ob5D+WQ1frC0K8by/rV/L/JDVdFwn5fH2jEUcgS6I07Als4TW8ogQAE+ziumsMaSMhnQ
 yL6A==
X-Gm-Message-State: AO0yUKWWklQ2NrZy7hFe7ScN5023oyltQAB8wOJ/GGcTFf+105Ufs8N5
 +UEHnaiMnxLx9Dp8cMzO79q2McY=
X-Google-Smtp-Source: AK7set+6GEF8RMlPNpH12a1jsy9LuRD4KKzljB1EFaKQRX7je7sSS3PUU8wBonfBVlgm4fnfIsL98g==
X-Received: by 2002:ac8:5e06:0:b0:3b9:a6be:56f6 with SMTP id
 h6-20020ac85e06000000b003b9a6be56f6mr11901225qtx.26.1675389630227; 
 Thu, 02 Feb 2023 18:00:30 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 x11-20020a05620a448b00b0072c01a3b6aasm934428qkp.100.2023.02.02.18.00.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 02 Feb 2023 18:00:29 -0800 (PST)
Date: Thu, 2 Feb 2023 21:00:28 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y9xqvF6nTptzHwpv@redhat.com>
References: <20230202181423.2910619-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230202181423.2910619-1-hch@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] block: remove submit_bio_noacct
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-raid@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 02 2023 at  1:14P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> The current usage of submit_bio vs submit_bio_noacct which skips the
> VM events and task account is a bit unclear.  It seems to be mostly
> intended for sending on bios received by stacking drivers, but also
> seems to be used for stacking drivers newly generated metadata
> sometimes.

Your lack of confidence conveyed in the above shook me a little bit
considering so much of this code is attributed to you -- I mostly got
past that, but I am a bit concerned about one aspect of the
submit_bio() change (2nd to last comment inlined below).

> Remove the separate API and just skip the accounting if submit_bio
> is called recursively.  This gets us an accounting behavior that
> is very similar (but not quite identical) to the current one, while
> simplifying the API and code base.

Can you elaborate on the "but not quite identical"? This patch is
pretty mechanical, just folding code and renaming.. but you obviously
saw subtle differences.  Likely worth callign those out precisely.

How have you tested this patch?  Seems like I should throw all the lvm
and DM tests at it.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../fault-injection/fault-injection.rst       |  2 +-
>  Documentation/trace/ftrace.rst                |  2 -
>  block/bio.c                                   | 14 +--
>  block/blk-core.c                              | 92 ++++++++-----------
>  block/blk-crypto-fallback.c                   |  2 +-
>  block/blk-crypto.c                            |  2 +-
>  block/blk-merge.c                             |  2 +-
>  block/blk-throttle.c                          |  2 +-
>  block/blk.h                                   |  2 +-
>  block/bounce.c                                |  2 +-
>  drivers/block/drbd/drbd_int.h                 |  2 +-
>  drivers/block/drbd/drbd_main.c                |  2 +-
>  drivers/block/drbd/drbd_req.c                 |  2 +-
>  drivers/block/drbd/drbd_worker.c              |  2 +-
>  drivers/block/pktcdvd.c                       |  2 +-
>  drivers/md/bcache/bcache.h                    |  2 +-
>  drivers/md/bcache/btree.c                     |  2 +-
>  drivers/md/bcache/request.c                   |  6 +-
>  drivers/md/dm-clone-target.c                  | 10 +-
>  drivers/md/dm-era-target.c                    |  2 +-
>  drivers/md/dm-integrity.c                     |  4 +-
>  drivers/md/dm-mpath.c                         |  2 +-
>  drivers/md/dm-raid1.c                         |  2 +-
>  drivers/md/dm-snap-persistent.c               |  2 +-
>  drivers/md/dm-snap.c                          |  6 +-
>  drivers/md/dm-verity-target.c                 |  2 +-
>  drivers/md/dm-writecache.c                    |  2 +-
>  drivers/md/dm-zoned-target.c                  |  2 +-
>  drivers/md/dm.c                               | 10 +-
>  drivers/md/md-faulty.c                        |  4 +-
>  drivers/md/md-linear.c                        |  4 +-
>  drivers/md/md-multipath.c                     |  4 +-
>  drivers/md/md.c                               |  2 +-
>  drivers/md/raid0.c                            |  6 +-
>  drivers/md/raid1.c                            | 14 +--
>  drivers/md/raid10.c                           | 32 +++----
>  drivers/md/raid5.c                            | 10 +-
>  drivers/nvme/host/multipath.c                 |  4 +-
>  include/linux/blkdev.h                        |  2 +-
>  39 files changed, 127 insertions(+), 141 deletions(-)
> 
> diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
> index 5f6454b9dbd4d9..6e326b2117b6e0 100644
> --- a/Documentation/fault-injection/fault-injection.rst
> +++ b/Documentation/fault-injection/fault-injection.rst
> @@ -32,7 +32,7 @@ Available fault injection capabilities
>  
>    injects disk IO errors on devices permitted by setting
>    /sys/block/<device>/make-it-fail or
> -  /sys/block/<device>/<partition>/make-it-fail. (submit_bio_noacct())
> +  /sys/block/<device>/<partition>/make-it-fail. (submit_bio())
>  
>  - fail_mmc_request
>  
> diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
> index 21f01d32c95985..310248593225bf 100644
> --- a/Documentation/trace/ftrace.rst
> +++ b/Documentation/trace/ftrace.rst
> @@ -1471,7 +1471,6 @@ function-trace, we get a much larger output::
>     => __blk_run_queue_uncond
>     => __blk_run_queue
>     => blk_queue_bio
> -   => submit_bio_noacct
>     => submit_bio
>     => submit_bh
>     => __ext3_get_inode_loc
> @@ -1756,7 +1755,6 @@ tracers.
>     => __blk_run_queue_uncond
>     => __blk_run_queue
>     => blk_queue_bio
> -   => submit_bio_noacct
>     => submit_bio
>     => submit_bh
>     => ext3_bread
> diff --git a/block/bio.c b/block/bio.c
> index d7fbc7adfc50aa..ea143fd825d768 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -373,7 +373,7 @@ static void bio_alloc_rescue(struct work_struct *work)
>  		if (!bio)
>  			break;
>  
> -		submit_bio_noacct(bio);
> +		submit_bio(bio);
>  	}
>  }
>  
> @@ -473,19 +473,19 @@ static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
>   * previously allocated bio for IO before attempting to allocate a new one.
>   * Failure to do so can cause deadlocks under memory pressure.
>   *
> - * Note that when running under submit_bio_noacct() (i.e. any block driver),
> + * Note that when running under submit_bio() (i.e. any block driver),
>   * bios are not submitted until after you return - see the code in
> - * submit_bio_noacct() that converts recursion into iteration, to prevent
> + * submit_bio() that converts recursion into iteration, to prevent
>   * stack overflows.

Please fix comment to read "- see the code in __submit_bio_nocheck() ...",
since it now has the code "that converts recursion into iteration,"

>   *
> - * This would normally mean allocating multiple bios under submit_bio_noacct()
> + * This would normally mean allocating multiple bios under submit_bio()
>   * would be susceptible to deadlocks, but we have
>   * deadlock avoidance code that resubmits any blocked bios from a rescuer
>   * thread.
>   *
>   * However, we do not guarantee forward progress for allocations from other
>   * mempools. Doing multiple allocations from the same mempool under
> - * submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
> + * submit_bio() should be avoided - instead, use bio_set's front_pad
>   * for per bio allocations.
>   *
>   * Returns: Pointer to new bio on success, NULL on failure.
> @@ -518,12 +518,12 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
>  	}
>  
>  	/*
> -	 * submit_bio_noacct() converts recursion to iteration; this means if
> +	 * submit_bio() converts recursion to iteration; this means if
>  	 * we're running beneath it, any bios we allocate and submit will not be
>  	 * submitted (and thus freed) until after we return.

This one is fine because submit_bio() is the exported interface that
people need to be mindful of.

>  	 *
>  	 * This exposes us to a potential deadlock if we allocate multiple bios
> -	 * from the same bio_set() while running underneath submit_bio_noacct().
> +	 * from the same bio_set() while running underneath submit_bio().
>  	 * If we were to allocate multiple bios (say a stacking block driver
>  	 * that was splitting bios), we would deadlock if we exhausted the
>  	 * mempool's reserve.
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ccf9a7683a3cc7..6423bd4104a0a3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -615,7 +615,7 @@ static void __submit_bio(struct bio *bio)
>   *  - We pretend that we have just taken it off a longer list, so we assign
>   *    bio_list to a pointer to the bio_list_on_stack, thus initialising the
>   *    bio_list of new bios to be added.  ->submit_bio() may indeed add some more
> - *    bios through a recursive call to submit_bio_noacct.  If it did, we find a
> + *    bios through a recursive call to submit_bio.  If it did, we find a
>   *    non-NULL value in bio_list and re-enter the loop from the top.
>   *  - In this case we really did just take the bio of the top of the list (no
>   *    pretending) and so remove it from bio_list, and call into ->submit_bio()
> @@ -625,7 +625,7 @@ static void __submit_bio(struct bio *bio)
>   * bio_list_on_stack[1] contains bios that were submitted before the current
>   *	->submit_bio, but that haven't been processed yet.
>   */
> -static void __submit_bio_noacct(struct bio *bio)
> +static void __submit_bio_nocheck(struct bio *bio)
>  {
>  	struct bio_list bio_list_on_stack[2];
>  
> @@ -669,7 +669,7 @@ static void __submit_bio_noacct(struct bio *bio)
>  	current->bio_list = NULL;
>  }
>  
> -static void __submit_bio_noacct_mq(struct bio *bio)
> +static void __submit_bio_nocheck_mq(struct bio *bio)
>  {
>  	struct bio_list bio_list[2] = { };
>  
> @@ -682,32 +682,28 @@ static void __submit_bio_noacct_mq(struct bio *bio)
>  	current->bio_list = NULL;
>  }
>  
> -void submit_bio_noacct_nocheck(struct bio *bio)
> +void submit_bio_nocheck(struct bio *bio)
>  {
> -	/*
> -	 * We only want one ->submit_bio to be active at a time, else stack
> -	 * usage with stacked devices could be a problem.  Use current->bio_list
> -	 * to collect a list of requests submited by a ->submit_bio method while
> -	 * it is active, and then process them after it returned.
> -	 */
> -	if (current->bio_list)
> -		bio_list_add(&current->bio_list[0], bio);
> -	else if (!bio->bi_bdev->bd_disk->fops->submit_bio)
> -		__submit_bio_noacct_mq(bio);
> +	if (!bio->bi_bdev->bd_disk->fops->submit_bio)
> +		__submit_bio_nocheck_mq(bio);
>  	else
> -		__submit_bio_noacct(bio);
> +		__submit_bio_nocheck(bio);
>  }
>  
>  /**
> - * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> - * @bio:  The bio describing the location in memory and on the device.
> + * submit_bio - submit a bio to the block device layer for I/O
> + * @bio: The &struct bio which describes the I/O
>   *
> - * This is a version of submit_bio() that shall only be used for I/O that is
> - * resubmitted to lower level drivers by stacking block drivers.  All file
> - * systems and other upper level users of the block layer should use
> - * submit_bio() instead.
> + * submit_bio() is used to submit I/O requests to block devices.  It is passed a
> + * fully set up &struct bio that describes the I/O that needs to be done.  The
> + * bio will be send to the device described by the bi_bdev field.
> + *
> + * The success/failure status of the request, along with notification of
> + * completion, is delivered asynchronously through the ->bi_end_io() callback
> + * in @bio.  The bio must NOT be touched by the caller until ->bi_end_io() has
> + * been called.
>   */
> -void submit_bio_noacct(struct bio *bio)
> +void submit_bio(struct bio *bio)
>  {
>  	struct block_device *bdev = bio->bi_bdev;
>  	struct request_queue *q = bdev_get_queue(bdev);
> @@ -716,6 +712,27 @@ void submit_bio_noacct(struct bio *bio)
>  
>  	might_sleep();
>  
> +	/*
> +	 * We only want one ->submit_bio to be active at a time, else stack
> +	 * usage with stacked devices could be a problem.  Use current->bio_list
> +	 * to collect a list of requests submited by a ->submit_bio method while
> +	 * it is active, and then process them after it returned.
> +	 */
> +	if (current->bio_list) {
> +		bio_list_add(&current->bio_list[0], bio);
> +		return;
> +	}

It seems pretty aggressive to queue the bio to current->bio_list so
early. Before this patch, that didn't happen until the very end
(meaning all the negative checks of submit_bio_noacct were done before
doing the bio_list_add() due to recursion). This is my primary concern
with this patch. Is that the biggest aspect of your "not quite
identical" comment in the patch header?

In practice this will manifest as delaying the negative checks, until
returning from active submit_bio, but they will still happen.

I just don't have a handle on how important it is to do those checks
late vs early (certainly not for all submit_bio_noacct calls from
stacked drivers). Could all be fine!

> +
> +	if (blkcg_punt_bio_submit(bio))
> +		return;
> +
> +	if (bio_op(bio) == REQ_OP_READ) {
> +		task_io_account_read(bio->bi_iter.bi_size);
> +		count_vm_events(PGPGIN, bio_sectors(bio));
> +	} else if (bio_op(bio) == REQ_OP_WRITE) {
> +		count_vm_events(PGPGOUT, bio_sectors(bio));
> +	}
> +
>  	plug = blk_mq_plug(bio);
>  	if (plug && plug->nowait)
>  		bio->bi_opf |= REQ_NOWAIT;
> @@ -799,7 +816,7 @@ void submit_bio_noacct(struct bio *bio)
>  		 */
>  		bio_set_flag(bio, BIO_TRACE_COMPLETION);
>  	}
> -	submit_bio_noacct_nocheck(bio);
> +	submit_bio_nocheck(bio);
>  	return;
>  
>  not_supported:

This ^ submit_bio_noacct_nocheck() used to provide the late adding to
current->bio_list.

Otherwise, this patch is pretty straight-forward.

A major thing that gets lost is the implied documentation we got as
a side-effect of callers using submit_bio_noacct().  But I've screwed
up and called submit_bio() when submit_bio_noacct() needed during
development -- so there is a definite benefit in being able to not
require knowing to use submit_bio() vs submit_bio_noacct().

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

