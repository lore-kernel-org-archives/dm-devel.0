Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E38E4653C
	for <dm-devel@lists.linux.dev>; Fri, 31 May 2024 19:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717183574; cv=none; b=MK5O8JaTPw60UyQ/lyJ9veY5TQ0OYdKO2ybx8uggLUVlnn5XxX2BC75fV2WxsKP+xnLaBaHJkcZHPa87obDNXtWR2hVU80VjAhxtT4+2xwD09coDKzFPybqZvlncpObl20pQJ4VMbUO+Z+MtefVQTgDC9ilvnJcXqMnLho57F8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717183574; c=relaxed/simple;
	bh=Tjd8XyRvNYA825ycNM02CT5voRkk1pbqKy1V3gNUADI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmmqBlmtgnbvLYY7MprZrNXy0P7v51kroNcEyrXWbIdumWAxdVHPUiGSYQQ0fUGEnp4vJMtFXChDV48dGp7nsBYWJm114ZkVQVsEV5FlhErMSnUyWCKa+bJQAVDecUC2xiqmnGecbnkzquLbDAfyUHAqt978qaNBIGTSLdXafJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqI+wJFp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqI+wJFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717183571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2YK9JY/U6RnkNw9DUJiT+1MQ8ZjrQ2mp/giGnUm45lQ=;
	b=FqI+wJFpLn8B6inx9WJamMvE31LZpXioPpvRirzjrpWffkK6I1ooGgxFNs+EjQ62Aid4DI
	o99aYCe2UaUOrh1DaLEPQsuLrowFvt+BlYtoLqLBXg43HtkRD8r5rvttlxjw1qMRoJ8RTr
	0u5+bU6xwG3XWEN1kLV1kIE0EOSjrz4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-MRgN5nZ7PGS6ZmVZEPqVkw-1; Fri,
 31 May 2024 15:26:07 -0400
X-MC-Unique: MRgN5nZ7PGS6ZmVZEPqVkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E17F93C025AC;
	Fri, 31 May 2024 19:26:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A9AD740F;
	Fri, 31 May 2024 19:26:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44VJQ6Bb439711
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 15:26:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44VJQ6ZG439710;
	Fri, 31 May 2024 15:26:06 -0400
Date: Fri, 31 May 2024 15:26:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
Message-ID: <ZlokTjm-l-7NWyhV@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

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

Does this mean that if a dm device was made up of two linear targets,
one of which mapped an entire zoned device, and one of which mapped a
single zone of another zoned device, the max active zone limit of the
entire dm device would be 1? That seems wrong.

-Ben
 
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
>  
>  	ret = dm_revalidate_zones(md, t);
>  	if (ret < 0)
> -- 
> 2.45.1
> 

