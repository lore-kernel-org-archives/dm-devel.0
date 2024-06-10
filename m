Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC4922F08;
	Mon, 10 Jun 2024 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718003934; cv=none; b=LQkX2PAM7qt7Vs/qPSZH+OcjohM+sM0yz48f1NKh0lmXrkDb1Awnx+89bbAhE5ORw2lW7OL8CswgGQHfHcPoOcsylt/IrDI3bXHVpPs28OCK0oS5LMZRyfe0xib4LH72AmVqw7hdVAJww8UX/TzmlZnjMv+f86yL/tUuuoUyHTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718003934; c=relaxed/simple;
	bh=qdxwHkdnGsRkF8UuUYR7yEoqEaVvIk//4nGXwt4gEWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpTt3knlxD4DMIIrkIt/vuVYs7Yb26bGYH/9+H6tDen98T8avIqrMjruTbmDU0T/XsYiZEOSihGu1x3FzsPwwXHeYijwZ57h7/dKqF0Z6cFFSmc5CCTUjrOKtSvNxcUntOm4YRyRcBU7sC6oZp2ILb2DofzmQxHaGrt38h8jtQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsTeUTFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsTeUTFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69E8C2BBFC;
	Mon, 10 Jun 2024 07:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718003933;
	bh=qdxwHkdnGsRkF8UuUYR7yEoqEaVvIk//4nGXwt4gEWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TsTeUTFEO9mYq8Kst7X3N6P1Amk4e2mpM6zOlQae5Io/NWiINOQvPA1GaQwQV3VWH
	 /WFzw+zH9VrMs+zaHmY650lTL4MlT27iwyM8JJmHHWtOo1ZdQdNTof5dqsj2JvWhyG
	 9AWRsIQ6TWly/g68lwr8+YOMP1LWSz2pDbQSXYYdLwBnrIhs/f0SpazXef5/88UVYN
	 6PmNApvRO7bbTLKlMCzjIkYz2/M0pKJZy3xwtkFBFXvHy59Mxun/UazkKXu7eAKUIc
	 BLufgBHe/kcV0FTKxGiO8uvQPTLe75ZoAHd89TJizOZMJ0y7gzhe5pkPvFYgMuok39
	 V5L9JlqV5/9xA==
Date: Mon, 10 Jun 2024 09:18:48 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v6 3/4] dm: Improve zone resource limits handling
Message-ID: <Zmao2Br4eOKiOUaa@ryzen.lan>
References: <20240606082147.96422-1-dlemoal@kernel.org>
 <20240606082147.96422-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606082147.96422-4-dlemoal@kernel.org>

On Thu, Jun 06, 2024 at 05:21:46PM +0900, Damien Le Moal wrote:
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
> device limits to the non-zero minimum of the limits of all targets. In
> this case the limits for a target depend on the number of sequential
> zones being mapped: if this number of zone is larger than the limits,
> then the limits of the device apply and can be used. If on the other
> hand the target maps a number of zones smaller than the limits, then no
> limits is needed and we can assume that the target has no limits (limits
> set to 0).
> 
> This commit improves zone resource limits handling as described above
> by modifying dm_set_zones_restrictions() to iterate the targets of a
> mapped device to evaluate the max open and max active zone limits. This
> relies on an internal "stacking" of the limits of the target devices
> combined with a direct counting of the number of sequential zones
> mapped by the targets.
> 1) For a target mapping an entire zoned block device, the limits for the
>    target are set to the limits of the device.
> 2) For a target partially mapping a zoned block device, the number of
>    mapped sequential zones is used to determine the limits: if the
>    target maps more sequential write required zones than the device
>    limits, then the limits of the device are used as-is. If the number
>    of mapped sequential zones is lower than the limits, then we assume
>    that the target has no limits (limits set to 0).
> As this evaluation is done for each target, the zone resource limits
> for the mapped device are evaluated as the non-zero minimum of the
> limits of all the targets.
> 
> For configurations resulting in unreliable limits, i.e. a table
> containing a target partially mapping a zoned device, a warning message
> is issued.
> 
> The counting of mapped sequential zones for the target is done using the
> new function dm_device_count_zones() which performs a report zones on
> the entire block device with the callback dm_device_count_zones_cb().
> This count of mapped sequential zones is also used to determine if the
> mapped device contains only conventional zones. This allows simplifying
> dm_set_zones_restrictions() to not do a report zones just for this.
> For mapped devices mapping only conventional zones, as before, the
> mapped device is changed to a regular device by setting its zoned limit
> to false and clearing all its zone related limits.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-zone.c | 175 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 145 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 75d0019a0649..d9f8b7c0957a 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -145,21 +145,6 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>  	}
>  }
>  
> -/*
> - * Count conventional zones of a mapped zoned device. If the device
> - * only has conventional zones, do not expose it as zoned.
> - */
> -static int dm_check_zoned_cb(struct blk_zone *zone, unsigned int idx,
> -			     void *data)
> -{
> -	unsigned int *nr_conv_zones = data;
> -
> -	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
> -		(*nr_conv_zones)++;
> -
> -	return 0;
> -}
> -
>  /*
>   * Revalidate the zones of a mapped device to initialize resource necessary
>   * for zone append emulation. Note that we cannot simply use the block layer
> @@ -228,13 +213,122 @@ static bool dm_table_supports_zone_append(struct dm_table *t)
>  	return true;
>  }
>  
> +struct dm_device_zone_count {
> +	sector_t start;
> +	sector_t len;
> +	unsigned int total_nr_seq_zones;
> +	unsigned int target_nr_seq_zones;
> +};
> +
> +/*
> + * Count the total number of and the number of mapped sequential zones of a
> + * target zoned device.
> + */
> +static int dm_device_count_zones_cb(struct blk_zone *zone,
> +				    unsigned int idx, void *data)
> +{
> +	struct dm_device_zone_count *zc = data;
> +
> +	if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
> +		zc->total_nr_seq_zones++;
> +		if (zone->start >= zc->start &&
> +		    zone->start < zc->start + zc->len)
> +			zc->target_nr_seq_zones++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dm_device_count_zones(struct dm_dev *dev,
> +				 struct dm_device_zone_count *zc)
> +{
> +	int ret;
> +
> +	ret = blkdev_report_zones(dev->bdev, 0, BLK_ALL_ZONES,
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
> +	struct queue_limits *lim;
> +	bool reliable_limits;
> +};
> +
> +static int device_get_zone_resource_limits(struct dm_target *ti,
> +					   struct dm_dev *dev, sector_t start,
> +					   sector_t len, void *data)
> +{
> +	struct dm_zone_resource_limits *zlim = data;
> +	struct gendisk *disk = dev->bdev->bd_disk;
> +	unsigned int max_open_zones, max_active_zones;
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
> +		DMERR("Count %s zones failed %d", disk->disk_name, ret);
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

Nit: To me, it would be more logical to do the:

if (!zc.target_nr_seq_zones)
	return 0;

before doing:
zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;

Sure, if zero, += will not modify zlim->mapped_nr_seq_zones,
but since we do the check anyway, why not just do in before
the addition?

Personally, I would respin, but I leave it to the patch author.

Regardless:
Reviewed-by: Niklas Cassel <cassel@kernel.org>
