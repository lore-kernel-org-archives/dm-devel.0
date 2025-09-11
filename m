Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3822F49E5
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 23:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757631833; cv=none; b=jFKkD90Oh/LfZn7ygDJ6y8xgbx+927sR6JQKQ0pdCdOB833Ha2ENhKmZhJaNGWwswyVdKRh2Igpe7pCaffOapD/XJfSiX30RNTtMhCcUhGCjxiYgjQIhQ154HqKvoRBdTvoLcbijh0tBzWxksF+2Fb/Ji7UU2dd9kVuDEeb9h38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757631833; c=relaxed/simple;
	bh=EYuTurq2ZVkh18AXuaEYbFntOqHluv+ypBw1ZLq69Wk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f5Uyqgeyisc+Z+SZIM96qfS1p84857InAmamxcS8zP7auTUVAA6OuGWI5h7Zck9WHlNkz38t5+hW61dIddYady7fuQZ9XICUG8QtUt7TMWBjlS7cvtXY6PydffC6s3J+qCJ1QYckbpigpqdEY2Hh8g+HD/zjV+X3Hi/Wudw2egk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZAuF8IU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZAuF8IU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6864C4CEF0;
	Thu, 11 Sep 2025 23:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757631832;
	bh=EYuTurq2ZVkh18AXuaEYbFntOqHluv+ypBw1ZLq69Wk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kZAuF8IUqqipBO26dkXQqCMBEMBc7EDkcQ+ZIOkoVmQWnv4JVU/keApBjeq/EWLgg
	 Q1TRxswu7DdMjvMFKkBEUgI7DU9KRJ3kzdjw09Fqh6NUK9Fl8TuCM0OLRAdQ+NeyBO
	 j0U3Lihb/TLj2lVE+2kPWfso5LuHG6595cS2Zm+C4y1Q4dcRuawf7ruLQPLBN/vBbQ
	 WqFIRcTJV+5OYh4dkF+yDnkpoFnDj8am9un728YU0dgejJu3rD+BwUIU5pqwy84WMl
	 aU3EGnl2FDeT3tUGHAXfDtWacWrEC0b+MugNDEfo/rviM+3bQ6xxdYTkZCuNfa1Rig
	 gyCD11eJeRmMA==
Message-ID: <4f959ea8-b3c2-402d-9777-48abdc488ba7@kernel.org>
Date: Fri, 12 Sep 2025 08:03:50 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250910172742.187645-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/25 02:27, Bart Van Assche wrote:
> The dm core splits REQ_PREFLUSH bios that have data into two bios.
> First, a REQ_PREFLUSH bio with no data is submitted to all underlying
> dm devices. Next, the REQ_PREFLUSH flag is cleared and the same bio is
> resubmitted. This approach is essential if there are multiple underlying
> devices to provide correct REQ_PREFLUSH semantics.

The same can be said if there is a single underlying device.

> Splitting a bio into an empty flush bio and a non-flush data bio is
> not necessary if there is only a single underlying device. Hence this
> patch that does not split REQ_PREFLUSH bios if there is only one
> underlying device.

Why is it not necessary ? You are not giving any justification/explanation of
that here, which makes your patch impossible to review.

I suspect it is because this will be handled by the flush machinery during the
submit_bio() to the underlying device ? But if that is the case, why is it a
problem with multiple devices ? The same block layer flush machinery will handle
that preflush write for all devices.

> 
> This patch preserves the order of REQ_PREFLUSH writes if there is only
> one underlying device and if one or more write bios have been queued
> past the REQ_PREFLUSH bio before the REQ_PREFLUSH bio is processed.
> 
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> 
> Changes compared to v1:
>  - Made the patch description more detailed.
>  - Removed the reference to write pipelining from the patch description.
> 
>  drivers/md/dm.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 66dd5f6ce778..d0791eef21f7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -490,9 +490,13 @@ u64 dm_start_time_ns_from_clone(struct bio *bio)
>  }
>  EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
>  
> -static inline bool bio_is_flush_with_data(struct bio *bio)
> +static inline bool bio_is_flush_with_data(struct mapped_device *md,
> +					  struct bio *bio)
>  {
> -	return ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size);
> +	guard(rcu)();
> +
> +	return bio->bi_opf & REQ_PREFLUSH && bio->bi_iter.bi_size &&
> +	       ((struct dm_table *)rcu_dereference(md->map))->num_targets > 1;
>  }
>  
>  static inline unsigned int dm_io_sectors(struct dm_io *io, struct bio *bio)
> @@ -501,7 +505,7 @@ static inline unsigned int dm_io_sectors(struct dm_io *io, struct bio *bio)
>  	 * If REQ_PREFLUSH set, don't account payload, it will be
>  	 * submitted (and accounted) after this flush completes.
>  	 */
> -	if (bio_is_flush_with_data(bio))
> +	if (bio_is_flush_with_data(io->md, bio))
>  		return 0;
>  	if (unlikely(dm_io_flagged(io, DM_IO_WAS_SPLIT)))
>  		return io->sectors;
> @@ -976,7 +980,7 @@ static void __dm_io_complete(struct dm_io *io, bool first_stage)
>  	if (requeued)
>  		return;
>  
> -	if (bio_is_flush_with_data(bio)) {
> +	if (bio_is_flush_with_data(md, bio)) {
>  		/*
>  		 * Preflush done for flush with data, reissue
>  		 * without REQ_PREFLUSH.
> @@ -1715,7 +1719,7 @@ static void dm_queue_poll_io(struct bio *bio, struct dm_io *io)
>  }
>  
>  /*
> - * Select the correct strategy for processing a non-flush bio.
> + * Select the correct strategy for processing a bio.
>   */
>  static blk_status_t __split_and_process_bio(struct clone_info *ci)
>  {
> @@ -1996,7 +2000,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  	}
>  	init_clone_info(&ci, io, map, bio, is_abnormal);
>  
> -	if (bio->bi_opf & REQ_PREFLUSH) {
> +	if (bio->bi_opf & REQ_PREFLUSH && ci.map->num_targets > 1) {
>  		__send_empty_flush(&ci);
>  		/* dm_io_complete submits any data associated with flush */
>  		goto out;


-- 
Damien Le Moal
Western Digital Research
