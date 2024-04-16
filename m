Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB036EB4C
	for <dm-devel@lists.linux.dev>; Tue, 16 Apr 2024 23:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713308497; cv=none; b=IW5K3nibrZX4QCq7m2pXhPKKJ/GXDG4URZXTb28M38CGFvvt7G+4k8Mzek2OcImUZCWsybcSW0jScvvQaHT5hupON3CEUlWa7bt8Rt/zyqfznrMk/hgfeBBQDcQ98QnsEk3O1cRG+ma8bEx2Katz+NrlYsAT/l591QzPYeqS+M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713308497; c=relaxed/simple;
	bh=Ifdw3xty4Bl/JsK1DvUYIIRG8k2TtrBj2hcD4duWlO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aFJIluE4k9fyuSg7TNdzg/dzPr500ZjtnZNYBoDtrF+S8x5ry9ZJPArLDH1xUhrSiuf0jONWQZYoUP/UxeFckRfNljD35nt+nDN50IKY/NHRlYqywwK30ZsvhngMS0ZaGSe3VLN4GULjmhRqMGt2Sd0N5NNviLj/bGBSh1HN+38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HguKWvje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HguKWvje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630B1C113CE;
	Tue, 16 Apr 2024 23:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713308497;
	bh=Ifdw3xty4Bl/JsK1DvUYIIRG8k2TtrBj2hcD4duWlO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HguKWvjeS7YpHCkagmN82kdCutalhDxujuByZABa9D9lR67OdHy5cD+dIA9yZ6urj
	 YSfLzi3qvYk23qbIb48p82lJr9XcuMxXUZnV9inyUUvFw9Vk3u+6IlAnw9RGr0in2H
	 CbnU0zwH8JHLHMdICU3pTZd/XgRX8YwCtlbWKkgq7zrutYMeYuZLc7lQREW2CgAdZK
	 6qaaDAGWiUtTuGY94cCqoep+jJkH1NVvIvz4CaT0QCgZVqyurqevMeX4wNA1vJgaUJ
	 E2e4x0TEE9f194E1nbTfcYpfRmI0DRuoAzYy13OuHo1Otm/19WsyEG45A+Aj928c1L
	 8hszoRipDafKQ==
Message-ID: <c5e8c781-24e6-4f06-8a97-7667e888aa82@kernel.org>
Date: Wed, 17 Apr 2024 09:01:34 +1000
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-io: don't warn if flush takes too long time
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Guangwu Zhang <guazhang@redhat.com>,
 dm-devel@lists.linux.dev
References: <c183dd5c-da91-c71-dccc-c923977bc77@redhat.com>
 <715f0135-2a64-4c95-9e8f-b20e1dd3b02d@kernel.org>
 <21b8a171-ea95-9eef-8c68-8cee98c7367@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <21b8a171-ea95-9eef-8c68-8cee98c7367@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/04/16 0:23, Mikulas Patocka wrote:
>>> @@ -119,4 +120,16 @@ extern void complete(struct completion *
>>>  extern void complete_on_current_cpu(struct completion *x);
>>>  extern void complete_all(struct completion *);
>>>  
>>> +static inline void blk_wait_io(struct completion *done)
>>
>> Since you move this function outside of the block layer, the "blk_" prefix seems
>> out of place. What about renaming this to something like
>> "wait_for_completion_blk_io()", or to make it clear that it is not the same as
>> wait_for_completion_io(), may be "wait_for_completion_long_io()" ?
> 
> Yes. Here I'm sending a second patch that renames this function to 
> wait_for_completion_long_io.

This looks good to me, but you sent this new version as a reply. Please post a
properly formatted new patch. And since you are touching the block layer, this
needs to be sent to linux-block and Jens as well.

> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> There was reported hang warning when using dm-integrity on the top of loop
> device on XFS on a rotational disk. The warning was triggered because
> flush on the loop device was too slow.
> 
> There's no easy way to reduce the latency, so I made a patch that shuts
> the warning up.
> 
> There's already a function blk_wait_io that avoids the hung task warning.
> This commit moves this function from block/blk.h to
> include/linux/completion.h, renames it to wait_for_completion_long_io
> (because it is not dependent on the block layer at all) and uses it in
> dm-io instead of wait_for_completion_io.
> 
> [ 1352.586981] INFO: task kworker/1:2:14820 blocked for more than 120 seconds.
> [ 1352.593951] Not tainted 4.18.0-552.el8_10.x86_64 #1
> [ 1352.599358] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1352.607202] Call Trace:
> [ 1352.609670] __schedule+0x2d1/0x870
> [ 1352.613173] ? update_load_avg+0x7e/0x710
> [ 1352.617193] ? update_load_avg+0x7e/0x710
> [ 1352.621214] schedule+0x55/0xf0
> [ 1352.624371] schedule_timeout+0x281/0x320
> [ 1352.628393] ? __schedule+0x2d9/0x870
> [ 1352.632065] io_schedule_timeout+0x19/0x40
> [ 1352.636176] wait_for_completion_io+0x96/0x100
> [ 1352.640639] sync_io+0xcc/0x120 [dm_mod]
> [ 1352.644592] dm_io+0x209/0x230 [dm_mod]
> [ 1352.648436] ? bit_wait_timeout+0xa0/0xa0
> [ 1352.652461] ? vm_next_page+0x20/0x20 [dm_mod]
> [ 1352.656924] ? km_get_page+0x60/0x60 [dm_mod]
> [ 1352.661298] dm_bufio_issue_flush+0xa0/0xd0 [dm_bufio]
> [ 1352.666448] dm_bufio_write_dirty_buffers+0x1a0/0x1e0 [dm_bufio]
> [ 1352.672462] dm_integrity_flush_buffers+0x32/0x140 [dm_integrity]
> [ 1352.678567] ? lock_timer_base+0x67/0x90
> [ 1352.682505] ? __timer_delete.part.36+0x5c/0x90
> [ 1352.687050] integrity_commit+0x31a/0x330 [dm_integrity]
> [ 1352.692368] ? __switch_to+0x10c/0x430
> [ 1352.696131] process_one_work+0x1d3/0x390
> [ 1352.700152] ? process_one_work+0x390/0x390
> [ 1352.704348] worker_thread+0x30/0x390
> [ 1352.708019] ? process_one_work+0x390/0x390
> [ 1352.712214] kthread+0x134/0x150
> [ 1352.715459] ? set_kthread_struct+0x50/0x50
> [ 1352.719659] ret_from_fork+0x1f/0x40 
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  block/bio.c                |    2 +-
>  block/blk-mq.c             |    2 +-
>  block/blk.h                |   12 ------------
>  drivers/md/dm-io.c         |    2 +-
>  include/linux/completion.h |   17 +++++++++++++++++
>  5 files changed, 20 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/block/blk.h
> ===================================================================
> --- linux-2.6.orig/block/blk.h	2024-04-15 15:54:22.000000000 +0200
> +++ linux-2.6/block/blk.h	2024-04-15 15:54:21.000000000 +0200
> @@ -72,18 +72,6 @@ static inline int bio_queue_enter(struct
>  	return __bio_queue_enter(q, bio);
>  }
>  
> -static inline void blk_wait_io(struct completion *done)
> -{
> -	/* Prevent hang_check timer from firing at us during very long I/O */
> -	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
> -
> -	if (timeout)
> -		while (!wait_for_completion_io_timeout(done, timeout))
> -			;
> -	else
> -		wait_for_completion_io(done);
> -}
> -
>  #define BIO_INLINE_VECS 4
>  struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
>  		gfp_t gfp_mask);
> Index: linux-2.6/drivers/md/dm-io.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-io.c	2024-04-15 15:54:22.000000000 +0200
> +++ linux-2.6/drivers/md/dm-io.c	2024-04-15 15:54:21.000000000 +0200
> @@ -450,7 +450,7 @@ static int sync_io(struct dm_io_client *
>  
>  	dispatch_io(opf, num_regions, where, dp, io, 1, ioprio);
>  
> -	wait_for_completion_io(&sio.wait);
> +	wait_for_completion_long_io(&sio.wait);
>  
>  	if (error_bits)
>  		*error_bits = sio.error_bits;
> Index: linux-2.6/include/linux/completion.h
> ===================================================================
> --- linux-2.6.orig/include/linux/completion.h	2024-04-15 15:54:22.000000000 +0200
> +++ linux-2.6/include/linux/completion.h	2024-04-15 15:57:14.000000000 +0200
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/swait.h>
> +#include <linux/sched/sysctl.h>
>  
>  /*
>   * struct completion - structure used to maintain state for a "completion"
> @@ -119,4 +120,20 @@ extern void complete(struct completion *
>  extern void complete_on_current_cpu(struct completion *x);
>  extern void complete_all(struct completion *);
>  
> +/**
> + * wait_for_completion_long_io - this is like wait_for_completion_io,
> + * but it doesn't warn if the wait takes too long.
> + */
> +static inline void wait_for_completion_long_io(struct completion *done)
> +{
> +	/* Prevent hang_check timer from firing at us during very long I/O */
> +	unsigned long timeout = sysctl_hung_task_timeout_secs * HZ / 2;
> +
> +	if (timeout)
> +		while (!wait_for_completion_io_timeout(done, timeout))
> +			;
> +	else
> +		wait_for_completion_io(done);
> +}
> +
>  #endif
> Index: linux-2.6/block/bio.c
> ===================================================================
> --- linux-2.6.orig/block/bio.c	2024-03-30 20:07:03.000000000 +0100
> +++ linux-2.6/block/bio.c	2024-04-15 15:55:13.000000000 +0200
> @@ -1378,7 +1378,7 @@ int submit_bio_wait(struct bio *bio)
>  	bio->bi_end_io = submit_bio_wait_endio;
>  	bio->bi_opf |= REQ_SYNC;
>  	submit_bio(bio);
> -	blk_wait_io(&done);
> +	wait_for_completion_long_io(&done);
>  
>  	return blk_status_to_errno(bio->bi_status);
>  }
> Index: linux-2.6/block/blk-mq.c
> ===================================================================
> --- linux-2.6.orig/block/blk-mq.c	2024-03-30 20:07:03.000000000 +0100
> +++ linux-2.6/block/blk-mq.c	2024-04-15 15:55:05.000000000 +0200
> @@ -1407,7 +1407,7 @@ blk_status_t blk_execute_rq(struct reque
>  	if (blk_rq_is_poll(rq))
>  		blk_rq_poll_completion(rq, &wait.done);
>  	else
> -		blk_wait_io(&wait.done);
> +		wait_for_completion_long_io(&wait.done);
>  
>  	return wait.ret;
>  }
> 

-- 
Damien Le Moal
Western Digital Research

