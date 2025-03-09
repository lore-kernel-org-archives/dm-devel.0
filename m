Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F77217A312;
	Sun,  9 Mar 2025 23:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741562742; cv=none; b=HTEaygoW4YoniQjv6zGzNM7kaitnSkP0S/cerp+8O7Cpy8DGNI//aSMjZQbSvBCV7L2vNEexWSJWEnvEH4fgf/LDe/LetnjA/ex+4M2mEB/V3zOz9lDO5u3vlteJ4AuxXttksGScgxMdQ3V2ceViDTIOl45ueVTyKSaPJrTgvH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741562742; c=relaxed/simple;
	bh=4A3fGg6pb7eh/0o8agByZpYFTtAqMA9M+TVht/tMYsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvU78YmgN++o4reuFhoBShnY9c6BmjqyEUzJXmJBZRegJnwmA9C5BhjJFWr1PUCu8fkXXmMgv00psRuoep8kYK+93QlhAhvWcOGeUmmtMSOI+52muxh5eQ9mYRa7AyHKG+JCrs7lvp7PuNKKjGOlnhNijWjDK2G2sOLvM6Tziiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJqlNggE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJqlNggE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AD2C4CEE3;
	Sun,  9 Mar 2025 23:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741562741;
	bh=4A3fGg6pb7eh/0o8agByZpYFTtAqMA9M+TVht/tMYsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LJqlNggEDfeOWsqYfP7tYa4Xvv6ytAbmM6nWYlNR1wUgGmp/FsA5PiW9GyxEgFn9k
	 z6wZMHvBWGH3FHQYSu/LhxDYIRw0aCnaKv5Csb35Q74/rHAWsR0rVLqSV9eWxqCLma
	 D82j92eAkXKKOrjfvnG1Y7ExanOkXLPAAOw0NByUycPRBwlJE4h17UiJAX6AshcY60
	 wdd5Smn5k+KAoTnJoUC4A24chZiZbJG9iKWEojRsXUWrlnI3thtDzBaR0RXG1siBz0
	 TAGqfvDoaF1+J8KO/EpF3VLCwtFlTbLPjptkoETBSCAoOAnwNHy3G+IQhFbSV41OC4
	 dMm0wm20CNKEA==
Message-ID: <9b5ff861-964d-472c-9267-5e5b10186ed3@kernel.org>
Date: Mon, 10 Mar 2025 08:25:39 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] dm: handle failures in dm_table_set_restrictions
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-4-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-4-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:28, Benjamin Marzinski wrote:
> If dm_table_set_restrictions() fails while swapping tables,
> device-mapper will continue using the previous table. It must be sure to
> leave the mapped_device in it's previous state on failure.  Otherwise
> device-mapper could end up using the old table with settings from the
> unused table.
> 
> Do not update the mapped device in dm_set_zones_restrictions(). Wait
> till after dm_table_set_restrictions() is sure to succeed to update the
> md zoned settings. Do the same with the dax settings, and if
> dm_revalidate_zones() fails, restore the original queue limits.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-table.c | 24 ++++++++++++++++--------
>  drivers/md/dm-zone.c  | 26 ++++++++++++++++++--------
>  drivers/md/dm.h       |  1 +
>  3 files changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 0ef5203387b2..4003e84af11d 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1836,6 +1836,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  			      struct queue_limits *limits)
>  {
>  	int r;
> +	struct queue_limits old_limits;
>  
>  	if (!dm_table_supports_nowait(t))
>  		limits->features &= ~BLK_FEAT_NOWAIT;
> @@ -1862,16 +1863,11 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	if (dm_table_supports_flush(t))
>  		limits->features |= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA;
>  
> -	if (dm_table_supports_dax(t, device_not_dax_capable)) {
> +	if (dm_table_supports_dax(t, device_not_dax_capable))
>  		limits->features |= BLK_FEAT_DAX;
> -		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
> -			set_dax_synchronous(t->md->dax_dev);
> -	} else
> +	else
>  		limits->features &= ~BLK_FEAT_DAX;
>  
> -	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
> -		dax_write_cache(t->md->dax_dev, true);
> -
>  	/* For a zoned table, setup the zone related queue attributes. */
>  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
>  	    (limits->features & BLK_FEAT_ZONED)) {
> @@ -1883,6 +1879,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	if (dm_table_supports_atomic_writes(t))
>  		limits->features |= BLK_FEAT_ATOMIC_WRITES;
>  
> +	old_limits = q->limits;

I am not sure this is safe to do like this since the user may be simultaneously
changing attributes, which would result in the old_limits struct being in an
inconsistent state. So shouldn't we hold q->limits_lock here ? We probably want
a queue_limits_get() helper for that though.

>  	r = queue_limits_set(q, limits);

...Or, we could modify queue_limits_set() to also return the old limit struct
under the q limits_lock. That maybe easier.

>  	if (r)
>  		return r;
> @@ -1894,10 +1891,21 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
>  	    (limits->features & BLK_FEAT_ZONED)) {
>  		r = dm_revalidate_zones(t, q);
> -		if (r)
> +		if (r) {
> +			queue_limits_set(q, &old_limits);
>  			return r;
> +		}
>  	}
>  
> +	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED))
> +		dm_finalize_zone_settings(t, limits);
> +
> +	if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
> +		set_dax_synchronous(t->md->dax_dev);
> +
> +	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
> +		dax_write_cache(t->md->dax_dev, true);
> +
>  	dm_update_crypto_profile(q, t);
>  	return 0;
>  }
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 20edd3fabbab..681058feb63b 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -340,12 +340,8 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  	 * mapped device queue as needing zone append emulation.
>  	 */
>  	WARN_ON_ONCE(queue_is_mq(q));
> -	if (dm_table_supports_zone_append(t)) {
> -		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> -	} else {
> -		set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +	if (!dm_table_supports_zone_append(t))
>  		lim->max_hw_zone_append_sectors = 0;
> -	}
>  
>  	/*
>  	 * Determine the max open and max active zone limits for the mapped
> @@ -383,9 +379,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  		lim->zone_write_granularity = 0;
>  		lim->chunk_sectors = 0;
>  		lim->features &= ~BLK_FEAT_ZONED;
> -		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> -		md->nr_zones = 0;
> -		disk->nr_zones = 0;
>  		return 0;
>  	}
>  
> @@ -408,6 +401,23 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  	return 0;
>  }
>  
> +void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
> +{
> +	struct mapped_device *md = t->md;
> +
> +	if (lim->features & BLK_FEAT_ZONED) {
> +		if (dm_table_supports_zone_append(t))
> +			clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +		else
> +			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +	} else {
> +		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +		md->nr_zones = 0;
> +		md->disk->nr_zones = 0;
> +	}
> +}
> +
> +
>  /*
>   * IO completion callback called from clone_endio().
>   */
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index a0a8ff119815..e5d3a9f46a91 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -102,6 +102,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
>  int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  		struct queue_limits *lim);
>  int dm_revalidate_zones(struct dm_table *t, struct request_queue *q);
> +void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim);
>  void dm_zone_endio(struct dm_io *io, struct bio *clone);
>  #ifdef CONFIG_BLK_DEV_ZONED
>  int dm_blk_report_zones(struct gendisk *disk, sector_t sector,


-- 
Damien Le Moal
Western Digital Research
