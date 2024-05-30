Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0AC176AD7;
	Thu, 30 May 2024 07:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717054634; cv=none; b=P6WTPURqydCEJejSkEmTdg9tUH3NL+XPY2wwVXp0tdMgC0dXB0ZaxDvNA+pfiv/ZtkA305ntlLc0eJZ3Wh8dlygs6lgUvXyPWF5cK8zn9euw1CRjXep1Rw8iosgAbMzTlYOJqeuHxAfq6G9V5lt8A0V+dhh1q2L+c+KDbst2p80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717054634; c=relaxed/simple;
	bh=iL5yPu5QHv8P4EuhBRD+yXyYZUPty/l0bQpJeJk7fJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uhxm4MkzMbepYqtekJK4M1Uj59WeEUCexaOKSfdKjo5KsxqnY0h6Pbg9E2xZO4JrDNcj8HKO5SmDyaM0y6j5teGO0Xrn0Mr3Ba693Dz+vA+59+jsgNZ5m0JXVQ+wVBIpRk2tpEwCAphtuz3vnDgIJ/5cksvqU1W+JXRmoz1Ue4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YvgTC7dH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YvgTC7dH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CACC2BBFC;
	Thu, 30 May 2024 07:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717054633;
	bh=iL5yPu5QHv8P4EuhBRD+yXyYZUPty/l0bQpJeJk7fJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YvgTC7dHljG52xS6zo4f+aNTGWqPERadz302O6Tkcp/k+3vHwMJDpqouLsU9Y/mpw
	 X4l1JW4THg9lztaH/dnyxTRxIbuIwEUELT+LTk0gLNRMtu9LP6CgBZNOKrQ2YUhLYs
	 TpS5W40MVor0ybLj2Ks8/Ub37EAT4nzKkJIUc9H3tC/3AmwG4tD0ubdEzhdUx3m3CF
	 kYW/eHGd96iWvEbXC+6UdHOD5Pjc9dHAZX43A1AkYjrw73q6vaPQRdAFveY0d8s/Kl
	 fvsvbXSPdjaFAFy3Y/4pbVczEGcijpFFsDASzUPdUxpxAa0uPS2EqzpT6ysjNAjBw6
	 TH+6xhIVgHw5A==
Date: Thu, 30 May 2024 09:37:09 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/4] block: Fix zone write plugging handling of devices
 with a runt zone
Message-ID: <ZlgspRAZQ4lmqBcC@ryzen.lan>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-4-dlemoal@kernel.org>

On Thu, May 30, 2024 at 02:40:34PM +0900, Damien Le Moal wrote:
> A zoned device may have a last sequential write required zone that is
> smaller than other zones. However, all tests to check if a zone write
> plug write offset exceeds the zone capacity use the same capacity
> value stored in the gendisk zone_capacity field. This is incorrect for a
> zoned device with a last runt (smaller) zone.
> 
> Add the new field last_zone_capacity to struct gendisk to store the
> capacity of the last zone of the device. blk_revalidate_seq_zone() and
> blk_revalidate_conv_zone() are both modified to get this value when
> disk_zone_is_last() returns true. Similarly to zone_capacity, the value
> is first stored using the last_zone_capacity field of struct
> blk_revalidate_zone_args. Once zone revalidation of all zones is done,
> this is used to set the gendisk last_zone_capacity field.
> 
> The checks to determine if a zone is full or if a sector offset in a
> zone exceeds the zone capacity in disk_should_remove_zone_wplug(),
> disk_zone_wplug_abort_unaligned(), blk_zone_write_plug_init_request(),
> and blk_zone_wplug_prepare_bio() are modified to use the new helper
> functions disk_zone_is_full() and disk_zone_wplug_is_full().
> disk_zone_is_full() uses the zone index to determine if the zone being
> tested is the last one of the disk and uses the either the disk
> zone_capacity or last_zone_capacity accordingly.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/blk-zoned.c      | 35 +++++++++++++++++++++++++++--------
>  include/linux/blkdev.h |  1 +
>  2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 402a50a1ac4d..52abebf56027 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -455,6 +455,20 @@ static bool disk_zone_is_last(struct gendisk *disk, struct blk_zone *zone)
>  	return zone->start + zone->len >= get_capacity(disk);
>  }
>  
> +static bool disk_zone_is_full(struct gendisk *disk,
> +			      unsigned int zno, unsigned int offset_in_zone)

Why not just call the third parameter wp?


> +{
> +	if (zno < disk->nr_zones - 1)
> +		return offset_in_zone >= disk->zone_capacity;
> +	return offset_in_zone >= disk->last_zone_capacity;
> +}
> +
> +static bool disk_zone_wplug_is_full(struct gendisk *disk,
> +				    struct blk_zone_wplug *zwplug)
> +{
> +	return disk_zone_is_full(disk, zwplug->zone_no, zwplug->wp_offset);
> +}
> +
>  static bool disk_insert_zone_wplug(struct gendisk *disk,
>  				   struct blk_zone_wplug *zwplug)
>  {
> @@ -548,7 +562,7 @@ static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
>  		return false;
>  
>  	/* We can remove zone write plugs for zones that are empty or full. */
> -	return !zwplug->wp_offset || zwplug->wp_offset >= disk->zone_capacity;
> +	return !zwplug->wp_offset || disk_zone_wplug_is_full(disk, zwplug);
>  }
>  
>  static void disk_remove_zone_wplug(struct gendisk *disk,
> @@ -669,13 +683,12 @@ static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
>  static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
>  					    struct blk_zone_wplug *zwplug)
>  {
> -	unsigned int zone_capacity = disk->zone_capacity;
>  	unsigned int wp_offset = zwplug->wp_offset;
>  	struct bio_list bl = BIO_EMPTY_LIST;
>  	struct bio *bio;
>  
>  	while ((bio = bio_list_pop(&zwplug->bio_list))) {
> -		if (wp_offset >= zone_capacity ||
> +		if (disk_zone_is_full(disk, zwplug->zone_no, wp_offset) ||

Why don't you use disk_zone_wplug_is_full() here?


>  		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
>  		     bio_offset_from_zone_start(bio) != wp_offset)) {
>  			blk_zone_wplug_bio_io_error(zwplug, bio);
> @@ -914,7 +927,6 @@ void blk_zone_write_plug_init_request(struct request *req)
>  	sector_t req_back_sector = blk_rq_pos(req) + blk_rq_sectors(req);
>  	struct request_queue *q = req->q;
>  	struct gendisk *disk = q->disk;
> -	unsigned int zone_capacity = disk->zone_capacity;
>  	struct blk_zone_wplug *zwplug =
>  		disk_get_zone_wplug(disk, blk_rq_pos(req));
>  	unsigned long flags;
> @@ -938,7 +950,7 @@ void blk_zone_write_plug_init_request(struct request *req)
>  	 * into the back of the request.
>  	 */
>  	spin_lock_irqsave(&zwplug->lock, flags);
> -	while (zwplug->wp_offset < zone_capacity) {
> +	while (!disk_zone_wplug_is_full(disk, zwplug)) {
>  		bio = bio_list_peek(&zwplug->bio_list);
>  		if (!bio)
>  			break;
> @@ -984,7 +996,7 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
>  	 * We know such BIO will fail, and that would potentially overflow our
>  	 * write pointer offset beyond the end of the zone.
>  	 */
> -	if (zwplug->wp_offset >= disk->zone_capacity)
> +	if (disk_zone_wplug_is_full(disk, zwplug))
>  		goto err;
>  
>  	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
> @@ -1561,6 +1573,7 @@ void disk_free_zone_resources(struct gendisk *disk)
>  	kfree(disk->conv_zones_bitmap);
>  	disk->conv_zones_bitmap = NULL;
>  	disk->zone_capacity = 0;
> +	disk->last_zone_capacity = 0;
>  	disk->nr_zones = 0;
>  }
>  
> @@ -1605,6 +1618,7 @@ struct blk_revalidate_zone_args {
>  	unsigned long	*conv_zones_bitmap;
>  	unsigned int	nr_zones;
>  	unsigned int	zone_capacity;
> +	unsigned int	last_zone_capacity;
>  	sector_t	sector;
>  };
>  
> @@ -1622,6 +1636,7 @@ static int disk_update_zone_resources(struct gendisk *disk,
>  
>  	disk->nr_zones = args->nr_zones;
>  	disk->zone_capacity = args->zone_capacity;
> +	disk->last_zone_capacity = args->last_zone_capacity;
>  	swap(disk->conv_zones_bitmap, args->conv_zones_bitmap);
>  	if (disk->conv_zones_bitmap)
>  		nr_conv_zones = bitmap_weight(disk->conv_zones_bitmap,
> @@ -1673,6 +1688,9 @@ static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
>  		return -ENODEV;
>  	}
>  
> +	if (disk_zone_is_last(disk, zone))
> +		args->last_zone_capacity = zone->capacity;
> +
>  	if (!disk_need_zone_resources(disk))
>  		return 0;
>  
> @@ -1703,8 +1721,9 @@ static int blk_revalidate_seq_zone(struct blk_zone *zone, unsigned int idx,
>  	 */
>  	if (!args->zone_capacity)
>  		args->zone_capacity = zone->capacity;
> -	if (!disk_zone_is_last(disk, zone) &&
> -	    zone->capacity != args->zone_capacity) {
> +	if (disk_zone_is_last(disk, zone)) {
> +		args->last_zone_capacity = zone->capacity;
> +	} else if (zone->capacity != args->zone_capacity) {
>  		pr_warn("%s: Invalid variable zone capacity\n",
>  			disk->disk_name);
>  		return -ENODEV;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index aefdda9f4ec7..24c36929920b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -186,6 +186,7 @@ struct gendisk {
>  	 */
>  	unsigned int		nr_zones;
>  	unsigned int		zone_capacity;
> +	unsigned int		last_zone_capacity;
>  	unsigned long		*conv_zones_bitmap;
>  	unsigned int            zone_wplugs_hash_bits;
>  	spinlock_t              zone_wplugs_lock;
> -- 
> 2.45.1
> 
