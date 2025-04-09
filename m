Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEB65464E
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 06:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744179674; cv=none; b=WGs8+4DjDa/2n9X/3H4wN3xH56fLztBrmTgVOBU502OFIYwrCqoElS0CeYmirLg9ojxPD6/2Rae+DfXeaUX/AL6DlPLLbVONei0YY/B7QFzrKnjEzaG5UoVMPvS6+0CX9EjjeDShmI+jJJYSx4KVq2oD5I/JaI3xUak7liMNj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744179674; c=relaxed/simple;
	bh=Le5nun+yHHLh2AO5YEC7JAynRBMXZKEWSc6Beook/HE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7YE0niifVboHlxGRNru+rsN3b7+pYw49sNEd/U0SuBgGQbq9o4E88GbReZsOpDHqfORd+fTjDVpfxOfzFeiwzd/eeJvPccVL+RtpHENvg0iPuMVfmQQjAv5qddOQjaASqlMQQKqF7T6bQX3si/cYrtgpogpZajnqpyy7qEa8bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUek+QdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUek+QdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA44C4CEE3;
	Wed,  9 Apr 2025 06:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744179673;
	bh=Le5nun+yHHLh2AO5YEC7JAynRBMXZKEWSc6Beook/HE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HUek+QdJ0n8YknYvM2rZIkFJahAY9W+1zJZMOIQFx9XvRfn3m2khpYV7OGvC/Bucp
	 nAezjoYE/XJBSr1egHPldiy9CcgTRDFzcFcRlWpMGyTE/CX0s27IZQftERfEN8Rvyx
	 KjGScAvYrwrq8Xfd5UGcpwmKHfu6D6neO20JQvF1D0FoxiIAw5SIMsWfRFm+kg9lBI
	 vuQ3XedlSU3TQsiYGUAHlHRTHkA52MIenfQaXz0WkqlZL1d3BZbWa3WQ/GhjLzhoLE
	 AUCaAV/pZF466varETEYDz/KJ+oguJPoono5RoZtuQfVwdoN1jDjBde9luWVuR1DMJ
	 LH1yTdVCI1aPQ==
Message-ID: <2fb19069-5e02-4f5a-9f8a-b362e08dffe3@kernel.org>
Date: Wed, 9 Apr 2025 15:20:31 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] dm: limit swapping tables for devices with zone
 write plugs
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-6-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250408235159.4128838-6-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/25 8:51 AM, Benjamin Marzinski wrote:
> dm_revalidate_zones() only allowed new or previously unzoned devices to
> call blk_revalidate_disk_zones(). If the device was already zoned,
> disk->nr_zones would always equal md->nr_zones, so dm_revalidate_zones()
> returned without doing any work. This would make the zoned settings for
> the device not match the new table. If the device had zone write plug
> resources, it could run into errors like bdev_zone_is_seq() reading
> invalid memory because disk->conv_zones_bitmap was the wrong size.
> 
> If the device doesn't have any zone write plug resources, calling
> blk_revalidate_disk_zones() will always correctly update device.  If
> blk_revalidate_disk_zones() fails, it can still overwrite or clear the
> current disk->nr_zones value. In this case, DM must restore the previous
> value of disk->nr_zones, so that the zoned settings will continue to
> match the previous that it failed back to.

s/previous/previous value ?
s/failed/fell ?

> 
> If the device already has zone write plug resources,
> blk_revalidate_disk_zones() will not correctly update them, if it is
> called for arbitrary zoned device changes.  Since there is not much need
> for this ability, the easiest solution is to disallow any table reloads
> that change the zoned settings, for devices that already have zone plug
> resources.  Specifically, if a device already has zone plug resources
> allocated, it can only switch to another zoned table that also emulates
> zone append.  Also, it cannot change the device size or the zone size. A
> device can switch to an error target.
> 
> Fixes: bb37d77239af2 ("dm: introduce zone append emulation")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

[...]

> @@ -1873,11 +1898,17 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  		limits->features &= ~BLK_FEAT_DAX;
>  
>  	/* For a zoned table, setup the zone related queue attributes. */
> -	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> -	    (limits->features & BLK_FEAT_ZONED)) {
> -		r = dm_set_zones_restrictions(t, q, limits);
> -		if (r)
> -			return r;
> +	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED)) {
> +		if (limits->features & BLK_FEAT_ZONED) {
> +			r = dm_set_zones_restrictions(t, q, limits);
> +			if (r)
> +				return r;
> +		} else if (dm_has_zone_plugs(t->md)) {
> +			DMWARN("%s: device has zone write plug resources. "
> +			       "Cannot switch to non-zoned table.",
> +			       dm_device_name(t->md));
> +			return -EINVAL;
> +		}

I am confused with this one. We can only have zone write plugs if the device is
zoned. So it seems that the check for "if (dm_has_zone_plugs(t->md)" should
really be inside dm_set_zones_restrictions(). Or is this trying to detect a
table change that would switch the device from zoned to non-zoned ? If that is
the case, regardless of the zone write plug initialization state, we should
never allow such change.

>  	}
>  
>  	if (dm_table_supports_atomic_writes(t))
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 11e19281bb64..1d419734fefc 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -158,22 +158,22 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
>  {
>  	struct mapped_device *md = t->md;
>  	struct gendisk *disk = md->disk;
> +	unsigned int nr_zones = disk->nr_zones;
>  	int ret;
>  
>  	if (!get_capacity(disk))
>  		return 0;
>  
> -	/* Revalidate only if something changed. */
> -	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
> -		DMINFO("%s using %s zone append",
> -		       disk->disk_name,
> -		       queue_emulates_zone_append(q) ? "emulated" : "native");
> -		md->nr_zones = 0;
> -	}
> -
> -	if (md->nr_zones)
> +	/*
> +	 * Do not revalidate if zone append emulation resources have already
> +	 * been allocated.

Maybe better to rephrased this (to be precise) to something like:

	/*
	 * Do not revalidate if zone write plug resources have already
	 * been allocated.
	 */

> +	 */
> +	if (dm_has_zone_plugs(md))
>  		return 0;
>  
> +	DMINFO("%s using %s zone append", disk->disk_name,
> +	       queue_emulates_zone_append(q) ? "emulated" : "native");
> +
>  	/*
>  	 * Our table is not live yet. So the call to dm_get_live_table()
>  	 * in dm_blk_report_zones() will fail. Set a temporary pointer to
> @@ -187,6 +187,7 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
>  
>  	if (ret) {
>  		DMERR("Revalidate zones failed %d", ret);
> +		disk->nr_zones = nr_zones;
>  		return ret;
>  	}
>  
> @@ -383,12 +384,28 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  		lim->max_open_zones = 0;
>  		lim->max_active_zones = 0;
>  		lim->max_hw_zone_append_sectors = 0;
> +		lim->max_zone_append_sectors = 0;
>  		lim->zone_write_granularity = 0;
>  		lim->chunk_sectors = 0;
>  		lim->features &= ~BLK_FEAT_ZONED;
>  		return 0;
>  	}
>  
> +	if (get_capacity(disk) && dm_has_zone_plugs(t->md)) {
> +		if (q->limits.chunk_sectors != lim->chunk_sectors) {
> +			DMWARN("%s: device has zone write plug resources. "
> +			       "Cannot change zone size",
> +			       disk->disk_name);
> +			return -EINVAL;
> +		}
> +		if (lim->max_hw_zone_append_sectors != 0 &&
> +		    !dm_table_is_wildcard(t)) {
> +			DMWARN("%s: device has zone write plug resources. "
> +			       "New table must emulate zone append",
> +			       disk->disk_name);
> +			return -EINVAL;
> +		}
> +	}

I have some concerns about this: what if the new table has the same capacity
and the same zone size but the types of zones changed ? We are not checking
this here and we cannot actually check that without doing a report zones. So I
really think we should just use the big hammer here and simply only allow the
wildcard target and no other change.

>  	/*
>  	 * Warn once (when the capacity is not yet set) if the mapped device is
>  	 * partially using zone resources of the target devices as that leads to
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 292414da871d..240f6dab8dda 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2429,6 +2429,12 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
>  	size = dm_table_get_size(t);
>  
>  	old_size = dm_get_size(md);
> +
> +	if (!dm_table_supports_size_change(t, old_size, size)) {
> +		old_map = ERR_PTR(-EINVAL);
> +		goto out;
> +	}

And I guess we could probably move the "wildcard-only is allowed" change check
here as that would further simplify the revalidation code. No ?

> +
>  	set_capacity(md->disk, size);
>  
>  	ret = dm_table_set_restrictions(t, md->queue, limits);
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index e5d3a9f46a91..245f52b59215 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -58,6 +58,7 @@ void dm_table_event_callback(struct dm_table *t,
>  			     void (*fn)(void *), void *context);
>  struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
>  bool dm_table_has_no_data_devices(struct dm_table *table);
> +bool dm_table_is_wildcard(struct dm_table *t);
>  int dm_calculate_queue_limits(struct dm_table *table,
>  			      struct queue_limits *limits);
>  int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> @@ -72,6 +73,8 @@ struct target_type *dm_table_get_immutable_target_type(struct dm_table *t);
>  struct dm_target *dm_table_get_immutable_target(struct dm_table *t);
>  struct dm_target *dm_table_get_wildcard_target(struct dm_table *t);
>  bool dm_table_request_based(struct dm_table *t);
> +bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
> +				   sector_t new_size);
>  
>  void dm_lock_md_type(struct mapped_device *md);
>  void dm_unlock_md_type(struct mapped_device *md);
> @@ -111,12 +114,14 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
>  int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
>  			     sector_t sector, unsigned int nr_zones,
>  			     unsigned long *need_reset);
> +#define dm_has_zone_plugs(md) ((md)->disk->zone_wplugs_hash != NULL)
>  #else
>  #define dm_blk_report_zones	NULL
>  static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>  {
>  	return false;
>  }
> +#define dm_has_zone_plugs(md) false
>  #endif
>  
>  /*


-- 
Damien Le Moal
Western Digital Research
