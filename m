Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1B1EEB2
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 00:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757465793; cv=none; b=tZW52Toto05PS5aclsWzwCub5idFs+rMXEW2/31rE8XMaVKFsF61lOLjxxub4TfJB7SkGqzE/8tZUl+X9XQADT4X3SEw+wrvqZ7XoHQui4W/P5U2yFx1rrnOZX/KT1s+XXaOL6egmav+/s1xZ2tGHHe9Yq/ZMMvsSG0FtIXNDKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757465793; c=relaxed/simple;
	bh=c91FYxK2bi3VaqyiNYB2y+EvuiPu0ZeIKc5xePOj8+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjDWmXSeWQ05DBMerAVXVwIBYgT+AoLkgef6XzCNKBROxPwnQSy/i5F5EwzZ8XiKQ95GVTQ2IvV782YK31wopz71/jpr3z71UJb87iNCsEHUWTeiQ0SfVQSERj6phrHHqFGiWfn0k4oElySDbxbK9gzIXInmS0Kd8IckL0e5zCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHhNwkcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHhNwkcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F083C4CEF4;
	Wed, 10 Sep 2025 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757465793;
	bh=c91FYxK2bi3VaqyiNYB2y+EvuiPu0ZeIKc5xePOj8+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VHhNwkcPU0/Kr1bpcG2XJH46G2h0UGZ9yb4Jhs/LZT6EfXWdAwN0x8xqsEdVGmxUS
	 XxebP0qnqQmUikkPnPHycbOjVaen8VUDF1F4WATIFhBzkd8wZzfjIbkkt3J+HXXlKo
	 UAydydS6IBw42t/P6zV/LnAxqZBiHGpSTOSEJJkA1+XNO2B0u2Kxv1on8amVxxuj7s
	 qGUguVvGiJvTV+F7aCTDN/W47UDGbSCitlPotSOU7/ujB4Z6OqqWj+yVghxxzPnNUx
	 Qw0YbAcd4y8bskSIJqxF0Z/hK7bZz4f80EoDxeJorSeBgWUNinMo+q4FyAD00HhngO
	 V/3nrnn+uHHCw==
Message-ID: <aec57265-20e4-4012-b3ae-8cb9c375da60@kernel.org>
Date: Wed, 10 Sep 2025 09:53:30 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Preserve the order of REQ_PREFLUSH writes
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250909182641.3496300-1-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250909182641.3496300-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/25 3:26 AM, Bart Van Assche wrote:
> Splitting a bio into an empty flush bio and a non-flush data bio is
> only necessary if there are multiple underlying devices. Do not split
> REQ_PREFLUSH bios if there is only one underlying device. This patch
> preserves the order of REQ_PREFLUSH writes if there is only one
> underlying device and if multiple writes are queued. This patch fixes
> a write error observed with zoned storage devices and with write
> pipelining enabled.

Write pipelining is not upstream. So is this fixing an actual problem with
upstream kernels ?

If that is the case and you have a reproducer, please share it (and maybe make
it a blktest case).

> 
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
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
