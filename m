Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875EE176AD7;
	Thu, 30 May 2024 07:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717054656; cv=none; b=oi7S10ZJGk0dKA0Nsv9ZyR8KS7SgQD0377aHA/xeXesRp1ImGS+0FMckcZq0QUJS3rZCWuBMnCsws9KpMb1e0YpmNkduk3HrZq0csPASOauT8G0EPd5me+JoA8LwyGebBlK1mgQbj37utVIkauyMp38KWXWBh3F7/8jz/ULk7II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717054656; c=relaxed/simple;
	bh=OouTkeBr3XIQh67VkbAhOA5MbZH5mR7nssaq6k/cCxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iL9hh+wWf35bfA5OnrukJGB4XzBSKYysuZWLTYemDF4sFna+ZPoZcmFc9LVQrbW6USpQNt2MSBPfHktZGAsQVepulzJ366gtWGzOGY17t3IAqBmFiW6EMSWshElfsAOoJrvHIa2ermTlXLfckiOMPAarhluJqE0ov0ITVjyHiDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zu0c/ml9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zu0c/ml9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF555C2BBFC;
	Thu, 30 May 2024 07:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717054656;
	bh=OouTkeBr3XIQh67VkbAhOA5MbZH5mR7nssaq6k/cCxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zu0c/ml97r+gBlBbeecF1UfWlpzXVO2++qDw9pwBHes9wP9mdyypatIrHjoT9Wn4E
	 rXQ0Xff5Uov+hyBoaXLmqYJn/9w/IcQBrWRmmFdfZJgfSjqlYY29pShRp1TgbMlak1
	 xRrByJ/KwRkSY5lsaJqQO5tubteG7GZL6ZNmuBmo4cCrX2+2Vm3WLbf9sxEmvK7u9Z
	 zy/nbodypOFYFmG6Bj1i9vV4GqjvPX3ws3Mksj3Vmg4hrXyK6EkxwhV5hWa7HYBnYH
	 ebyT6EEQu9GJHsH6uWLr9iiBQumqoBLCqy8nklIAaTGigdF+TC30fD8J5Wj73/4Zei
	 gnYTjr8U9pjJw==
Date: Thu, 30 May 2024 09:37:31 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/4] block: Fix validation of zoned device with a runt
 zone
Message-ID: <Zlgsu5vB0Q4upDsH@ryzen.lan>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-3-dlemoal@kernel.org>

On Thu, May 30, 2024 at 02:40:33PM +0900, Damien Le Moal wrote:
> Commit ecfe43b11b02 ("block: Remember zone capacity when revalidating
> zones") introduced checks to ensure that the capacity of the zones of
> a zoned device is constant for all zones. However, this check ignores
> the possibility that a zoned device has a smaller last zone with a size
> not equal to the capacity of other zones. Such device correspond in
> practice to an SMR drive with a smaller last zone and all zones with a
> capacity equal to the zone size, leading to the last zone capacity being
> different than the capacity of other zones.
> 
> Correctly handle such device by fixing the check for the constant zone
> capacity in blk_revalidate_seq_zone() using the new helper function
> disk_zone_is_last(). This helper function is also used in
> blk_revalidate_zone_cb() when checking the zone size.
> 
> Fixes: ecfe43b11b02 ("block: Remember zone capacity when revalidating zones")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/blk-zoned.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 03aa4eead39e..402a50a1ac4d 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -450,6 +450,11 @@ static inline bool disk_zone_is_conv(struct gendisk *disk, sector_t sector)
>  	return test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
>  }
>  
> +static bool disk_zone_is_last(struct gendisk *disk, struct blk_zone *zone)
> +{
> +	return zone->start + zone->len >= get_capacity(disk);
> +}
> +
>  static bool disk_insert_zone_wplug(struct gendisk *disk,
>  				   struct blk_zone_wplug *zwplug)
>  {
> @@ -1693,11 +1698,13 @@ static int blk_revalidate_seq_zone(struct blk_zone *zone, unsigned int idx,
>  
>  	/*
>  	 * Remember the capacity of the first sequential zone and check
> -	 * if it is constant for all zones.
> +	 * if it is constant for all zones, ignoring the last zone as it can be
> +	 * smaller.
>  	 */
>  	if (!args->zone_capacity)
>  		args->zone_capacity = zone->capacity;
> -	if (zone->capacity != args->zone_capacity) {
> +	if (!disk_zone_is_last(disk, zone) &&
> +	    zone->capacity != args->zone_capacity) {
>  		pr_warn("%s: Invalid variable zone capacity\n",
>  			disk->disk_name);
>  		return -ENODEV;
> @@ -1732,7 +1739,6 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>  {
>  	struct blk_revalidate_zone_args *args = data;
>  	struct gendisk *disk = args->disk;
> -	sector_t capacity = get_capacity(disk);
>  	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
>  	int ret;
>  
> @@ -1743,7 +1749,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>  		return -ENODEV;
>  	}
>  
> -	if (zone->start >= capacity || !zone->len) {
> +	if (zone->start >= get_capacity(disk) || !zone->len) {
>  		pr_warn("%s: Invalid zone start %llu, length %llu\n",
>  			disk->disk_name, zone->start, zone->len);
>  		return -ENODEV;
> @@ -1753,7 +1759,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
>  	 * All zones must have the same size, with the exception on an eventual
>  	 * smaller last zone.
>  	 */
> -	if (zone->start + zone->len < capacity) {
> +	if (!disk_zone_is_last(disk, zone)) {
>  		if (zone->len != zone_sectors) {
>  			pr_warn("%s: Invalid zoned device with non constant zone size\n",
>  				disk->disk_name);
> -- 
> 2.45.1
> 

Reviewed-by: Niklas Cassel <cassel@kernel.org>
