Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781B4176AD7;
	Thu, 30 May 2024 07:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717054665; cv=none; b=fECMjHG0bsYDWBVaUj+xY0nBf2HXFBbDpPIjfrYR7o/9B/MYaGe3FrWaeWuOx6BlZ0rCNSRT1gVq2d4LiRZXETNB/HcpP+K+HnBXeB44ayLSm9xyKUs6eBhK8/7wAFadkQMIlBAgHtE+gYKPF9BvVAJJ+aKpy04qz+PKTajDJ4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717054665; c=relaxed/simple;
	bh=t47nt73u46S/pYHRaj7HlLf4zx6IfDXYnp4j3ZiqJpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7z4d/osFbUA8BcYas+YthvB7yQVrhJdxUrO9SLsEvarqRmTk5O7Iyxeeaixo/RnZtcUlCiA4daS+fVUrxi+0c1J2bD24vibkC6aO6KMxojLHptQFV1v2B1EDiL6Er8/PoFHWuulCJiEu8wPfIKvxhtjwPlDCW0Q9akZcPLSKgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0are+Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0are+Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BF0C2BBFC;
	Thu, 30 May 2024 07:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717054664;
	bh=t47nt73u46S/pYHRaj7HlLf4zx6IfDXYnp4j3ZiqJpE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0are+Dy+JmJmqmvD+r0WEmRQuIbQYdtjbW/RoSMIvsFNzqL7tG5soyXiW0b9xLsf
	 6Jz0LSXsM7p7VpeaYkcH4ZASmhLct17E2/RC/6TDWc5ghRYpdkW1rJInHkogccKTLM
	 xdxeI2ECO1jre9RBn1VSsyx7d+23LhWpaCjhRgnQcYsxNHDhm1EADo2XYkJYvy3FpC
	 W10ulzyra2v0URiLXb5vkCzUHx0NopiTz/OYtPpSExf7oeHhrRSRUqQGnejYg+A1Nz
	 UmkL1BD+tTUHBKM/Y/7P/4PsN+1yOztfnDr6MmLSgn8BX5acHo0MrJOPLdIjVuz2zA
	 fjPziqC3BMSiw==
Date: Thu, 30 May 2024 09:37:40 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
Message-ID: <ZlgsxKE2tpu68O3n@ryzen.lan>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-5-dlemoal@kernel.org>

On Thu, May 30, 2024 at 02:40:35PM +0900, Damien Le Moal wrote:
> The generic stacking of limits implemented in the block layer cannot
> correctly handle stacking of zone resource limits (max open zones and
> max active zones) because these limits are for an entire device but the
> stacking may be for a portion of that device (e.g. a dm-linear target
> that does not cover an entire block device). As a result, when DM
> devices are created on top of zoned block devices, the DM device never
> has any zone resource limits advertized, which is only correct if all
> underlying target devices also have no zone resource limits.
> If at least one target device has resource limits, the user may see
> either performance issues (if the max open zone limit of the device is
> exceeded) or write I/O errors if the max active zone limit of one of
> the underlying target devices is exceeded.
> 
> While it is very difficult to correctly and reliably stack zone resource
> limits in general, cases where targets are not sharing zone resources of
> the same device can be dealt with relatively easily. Such situation
> happens when a target maps all sequential zones of a zoned block device:
> for such mapping, other targets mapping other parts of the same zoned
> block device can only contain conventional zones and thus will not
> require any zone resource to correctly handle write operations.
> 
> For a mapped device constructed with such targets, which includes mapped
> devices constructed with targets mapping entire zoned block devices, the
> zone resource limits can be reliably determined using the non-zero
> minimum of the zone resource limits of all targets.
> 
> For mapped devices that include targets partially mapping the set of
> sequential write required zones of zoned block devices, instead of
> advertizing no zone resource limits, it is also better to set the mapped
> device limits to the non-zero minimum of the limits of all targets,
> capped with the number of sequential zones being mapped.
> While still not completely reliable, this allows indicating to the user
> that the underlying devices used have limits.
> 
> This commit improves zone resource limits handling as described above
> using the function dm_set_zone_resource_limits(). This function is
> executed from dm_set_zones_restrictions() and iterates the targets of a
> mapped device to evaluate the max open and max active zone limits. This
> relies on an internal "stacking" of the limits of the target devices
> combined with a direct counting of the number of sequential zones
> mapped by the target.
> 1) For a target mapping an entire zoned block device, the limits are
>    evaluated as the non-zero minimum of the limits of the target device
>    and of the mapped device.
> 2) For a target partially mapping a zoned block device, the number of
>    mapped sequential zones is compared to the total number of sequential
>    zones of the target device to determine the limits: if the target
>    maps all sequential write required zones of the device, then the
>    target can reliably inherit the device limits. Otherwise, the target
>    limits are set to the device limits capped by the number of mapped
>    sequential zones.
> With this evaluation done for each target, the mapped device zone
> resource limits are evaluated as the non-zero minimum of the limits of
> all the targets.
> 
> For configurations resulting in unreliable limits, a warning message is
> issued.
> 
> The counting of mapped sequential zones for the target is done using the
> new function dm_device_count_zones() which performs a report zones on
> the entire block device with the callback dm_device_count_zones_cb().
> This count of mapped sequential zones is used to determine if the mapped
> device contains only conventional zones. This allows simplifying
> dm_set_zones_restrictions() to not do a report zones. For mapped devices
> mapping only conventional zones, dm_set_zone_resource_limits() changes
> the mapped device to a regular device.
> 
> To further cleanup dm_set_zones_restrictions(), the message about the
> type of zone append (native or emulated) is moved inside
> dm_revalidate_zones().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/md/dm-zone.c | 214 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 177 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 5d66d916730e..5f8b499529cf 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -145,17 +145,174 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>  	}
>  }
>  
> +struct dm_device_zone_count {
> +	sector_t start;
> +	sector_t len;
> +	unsigned int total_nr_seq_zones;
> +	unsigned int target_nr_seq_zones;
> +};
> +
>  /*
> - * Count conventional zones of a mapped zoned device. If the device
> - * only has conventional zones, do not expose it as zoned.
> + * Count the total number of and the number of mapped sequential zones of a
> + * target zoned device.
>   */
> -static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
> -			     void *data)
> +static int dm_device_count_zones_cb(struct blk_zone *zone,
> +				    unsigned int idx, void *data)
>  {
> -	unsigned int *nr_conv_zones = data;
> +	struct dm_device_zone_count *zc = data;
> +
> +	if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
> +		zc->total_nr_seq_zones++;
> +		if (zone->start >= zc->start &&
> +		    zone->start < zc->start + zc->len)
> +			zc->target_nr_seq_zones++;
> +	}
>  
> -	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
> -		(*nr_conv_zones)++;
> +	return 0;
> +}
> +
> +static int dm_device_count_zones(struct dm_dev *dev,
> +				 struct dm_device_zone_count *zc)
> +{
> +	int ret;
> +
> +	ret = blkdev_report_zones(dev->bdev, 0, UINT_MAX,
> +				  dm_device_count_zones_cb, zc);
> +	if (ret < 0)
> +		return ret;
> +	if (!ret)
> +		return -EIO;
> +	return 0;
> +}
> +
> +struct dm_zone_resource_limits {
> +	unsigned int mapped_nr_seq_zones;
> +	unsigned int max_open_zones;
> +	unsigned int max_active_zones;
> +	bool reliable_limits;
> +};
> +
> +static int device_get_zone_resource_limits(struct dm_target *ti,
> +					   struct dm_dev *dev, sector_t start,
> +					   sector_t len, void *data)
> +{
> +	struct dm_zone_resource_limits *zlim = data;
> +	struct gendisk *disk = dev->bdev->bd_disk;
> +	int ret;
> +	struct dm_device_zone_count zc = {
> +		.start = start,
> +		.len = len,
> +	};
> +
> +	/*
> +	 * If the target is not the whole device, the device zone resources may
> +	 * be shared between different targets. Check this by counting the
> +	 * number of mapped sequential zones: if this number is smaller than the
> +	 * total number of sequential zones of the target device, then resource
> +	 * sharing may happen and the zone limits will not be reliable.
> +	 */
> +	ret = dm_device_count_zones(dev, &zc);
> +	if (ret) {
> +		DMERR("Count device %s zones failed",
> +		      disk->disk_name);
> +		return ret;
> +	}
> +
> +	zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;
> +
> +	/*
> +	 * If the target does not map any sequential zones, then we do not need
> +	 * any zone resource limits.
> +	 */
> +	if (!zc.target_nr_seq_zones)
> +		return 0;
> +
> +	/*
> +	 * If the target does not map all sequential zones, the limits
> +	 * will not be reliable.
> +	 */
> +	if (zc.target_nr_seq_zones < zc.total_nr_seq_zones)
> +		zlim->reliable_limits = false;
> +
> +	zlim->max_active_zones =
> +		min_not_zero(disk->queue->limits.max_active_zones,
> +			     zlim->max_active_zones);
> +	if (zlim->max_active_zones != UINT_MAX)
> +		zlim->max_active_zones =
> +			min(zlim->max_active_zones, zc.target_nr_seq_zones);
> +
> +	zlim->max_open_zones =
> +		min_not_zero(disk->queue->limits.max_open_zones,
> +			     zlim->max_open_zones);
> +	if (zlim->max_open_zones != UINT_MAX)
> +		zlim->max_open_zones =
> +			min3(zlim->max_open_zones, zc.target_nr_seq_zones,
> +			     zlim->max_active_zones);
> +
> +	return 0;
> +}
> +
> +static int dm_set_zone_resource_limits(struct mapped_device *md,
> +				struct dm_table *t, struct queue_limits *lim)
> +{
> +	struct gendisk *disk = md->disk;
> +	struct dm_zone_resource_limits zlim = {
> +		.max_open_zones = UINT_MAX,
> +		.max_active_zones = UINT_MAX,
> +		.reliable_limits = true,
> +	};
> +
> +	/* Get the zone resource limits from the targets. */
> +	for (unsigned int i = 0; i < t->num_targets; i++) {
> +		struct dm_target *ti = dm_table_get_target(t, i);
> +
> +		if (!ti->type->iterate_devices ||
> +		    ti->type->iterate_devices(ti,
> +				device_get_zone_resource_limits, &zlim)) {
> +			DMERR("Could not determine %s zone resource limits",
> +			      md->disk->disk_name);
> +			return -ENODEV;
> +		}
> +	}
> +
> +	/*
> +	 * If we only have conventional zones mapped, expose the mapped device
> +	 + as a regular device.
> +	 */
> +	if (!zlim.mapped_nr_seq_zones) {
> +		lim->max_open_zones = 0;
> +		lim->max_active_zones = 0;
> +		lim->max_zone_append_sectors = 0;
> +		lim->zone_write_granularity = 0;
> +		lim->zoned = false;
> +		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> +		md->nr_zones = 0;
> +		disk->nr_zones = 0;
> +		return 0;
> +	}
> +
> +	/*
> +	 * Warn if the mapped device is partially using zone resources of the
> +	 * target devices as that leads to unreliable limits, i.e. if another
> +	 * mapped device uses the same underlying devices, we cannot enforce
> +	 * zone limits to guarantee that writing will not lead to errors.
> +	 * Note that we really should return an error for such case but there is
> +	 * no easy way to find out if another mapped device uses the same
> +	 * underlying zoned devices.
> +	 */
> +	if (!zlim.reliable_limits)
> +		DMWARN("%s zone resource limits may be unreliable",
> +		       disk->disk_name);
> +
> +	if (zlim.max_open_zones >= zlim.mapped_nr_seq_zones)
> +		lim->max_open_zones = 0;
> +	else
> +		lim->max_open_zones = zlim.max_open_zones;
> +
> +	if (zlim.max_active_zones >= zlim.mapped_nr_seq_zones)
> +		lim->max_active_zones = 0;
> +	else
> +		lim->max_active_zones = zlim.max_active_zones;
>  
>  	return 0;
>  }
> @@ -172,8 +329,13 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  	int ret;
>  
>  	/* Revalidate only if something changed. */
> -	if (!disk->nr_zones || disk->nr_zones != md->nr_zones)
> +	if (!disk->nr_zones || disk->nr_zones != md->nr_zones) {
> +		DMINFO("%s using %s zone append",
> +		       md->disk->disk_name,
> +		       queue_emulates_zone_append(disk->queue) ?
> +		       "emulated" : "native");
>  		md->nr_zones = 0;
> +	}
>  
>  	if (md->nr_zones)
>  		return 0;
> @@ -224,8 +386,6 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  		struct queue_limits *lim)
>  {
>  	struct mapped_device *md = t->md;
> -	struct gendisk *disk = md->disk;
> -	unsigned int nr_conv_zones = 0;
>  	int ret;
>  
>  	/*
> @@ -244,36 +404,16 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  		return 0;
>  
>  	/*
> -	 * Count conventional zones to check that the mapped device will indeed 
> -	 * have sequential write required zones.
> +	 * Determine the max open and max active zone limits for the mapped
> +	 * device. For a mapped device containing only conventional zones, the
> +	 * mapped device is changed to be a regular block device, so exit early
> +	 * for such case.
>  	 */
> -	md->zone_revalidate_map = t;
> -	ret = dm_blk_report_zones(disk, 0, UINT_MAX,
> -				  dm_check_zoned_cb, &nr_conv_zones);
> -	md->zone_revalidate_map = NULL;
> -	if (ret < 0) {
> -		DMERR("Check zoned failed %d", ret);
> +	ret = dm_set_zone_resource_limits(md, t, lim);
> +	if (ret)
>  		return ret;
> -	}
> -
> -	/*
> -	 * If we only have conventional zones, expose the mapped device as
> -	 * a regular device.
> -	 */
> -	if (nr_conv_zones >= ret) {
> -		lim->max_open_zones = 0;
> -		lim->max_active_zones = 0;
> -		lim->zoned = false;
> -		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> -		disk->nr_zones = 0;
> +	if (!lim->zoned)
>  		return 0;
> -	}
> -
> -	if (!md->disk->nr_zones) {
> -		DMINFO("%s using %s zone append",
> -		       md->disk->disk_name,
> -		       queue_emulates_zone_append(q) ? "emulated" : "native");
> -	}

I would have moved this print in a separate commit.

Regardless:
Reviewed-by: Niklas Cassel <cassel@kernel.org>
