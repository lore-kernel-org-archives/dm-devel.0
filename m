Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E61D26D;
	Wed,  5 Jun 2024 17:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717608351; cv=none; b=BQra4/nymkm9AwCZ8hCXVLkUApw7A4T38PldhJ2ZLssoyEpVGJ9lDVwdYeL4wHW6hHh0b1FzQpFrEw9SdK6k+zorZIp+ziF9CWRuS7kVlvY+EyJQ4YovNplULgyZ0oaCTHOiRIhj+5C6bXPvhngIGR/YMA7D+/Um/46CPcp8Rv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717608351; c=relaxed/simple;
	bh=JJdirOkbooIjU741BoU+nQHMzsqqaaFtQ7ASO+UgZ4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3vHgnauOL5izISDquKa1+Ei6Pr31usuDOAsoMdkswL+rlBbYgp5d6qWJiKQTi3LINJJBz41RjTiHhcYjR3OAunfEjRxH9Kq+rYswSuaoC8HMD/owoMq9hb/9AZeWi+If4KCqwIFsmbnDiirqayHjWuY73QgEmRgswezP32SbO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CP+h3CRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CP+h3CRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B4CC2BD11;
	Wed,  5 Jun 2024 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717608351;
	bh=JJdirOkbooIjU741BoU+nQHMzsqqaaFtQ7ASO+UgZ4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CP+h3CRi9egqS/MV2eEwOwsbZFSlx9yJ7RDAGPq0kGCn3FTeCjwL6SGSs161HBPzP
	 GNoRBHIrsUQ82sNLFj7WUUh1fP+j96JItjJzwMpKQAI7BX2ZTDz1h/EGNY/BuAPtL6
	 hLAlLYyLRyj+2jAiv7QRUXhk5pkAA4yBQwfXBLyEmK4ntBoMP4hg1U9TzqHUicbrt+
	 P52dSX5MnKCUYLjRAf0Nu2Rs4nRouYIKHazUcCg5aqerkr8MUFaCAsO90qAkkN0pbv
	 xzrMcGU3u54a9vvQZyJyn2x5+y2P/5azAt0lSbhzrKVq7os83NJImcTsEWzDreTpsh
	 vK4QnMuZF241A==
Date: Wed, 5 Jun 2024 19:25:46 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v4 1/3] block: Improve checks on zone resource limits
Message-ID: <ZmCfmlnoo7wjQLTg@ryzen.lan>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605075144.153141-2-dlemoal@kernel.org>

On Wed, Jun 05, 2024 at 04:51:42PM +0900, Damien Le Moal wrote:
> Make sure that the zone resource limits of a zoned block device are
> correct by checking that:
> (a) If the device has a max active zones limit, make sure that the max
>     open zones limit is lower than the max active zones limit.
> (b) If the device has zone resource limits, check that the limits
>     values are lower than the number of sequential zones of the device.
>     If it is not, assume that the zoned device has no limits by setting
>     the limits to 0.
> 
> For (a), a check is added to blk_validate_zoned_limits() and an error
> returned if the max open zones limit exceeds the value of the max active
> zone limit (if there is one).
> 
> For (b), given that we need the number of sequential zones of the zoned
> device, this check is added to disk_update_zone_resources(). This is
> safe to do as that function is executed with the disk queue frozen and
> the check executed after queue_limits_start_update() which takes the
> queue limits lock. Of note is that the early return in this function
> for zoned devices that do not use zone write plugging (e.g. DM devices
> using native zone append) is moved to after the new check and adjustment
> of the zone resource limits so that the check applies to any zoned
> device.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/blk-settings.c |  8 ++++++++
>  block/blk-zoned.c    | 20 ++++++++++++++++----
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index effeb9a639bb..474c709ea85b 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -80,6 +80,14 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
>  	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED)))
>  		return -EINVAL;
>  
> +	/*
> +	 * Given that active zones include open zones, the maximum number of
> +	 * open zones cannot be larger than the maximum numbber of active zones.

s/numbber/number/


> +	 */
> +	if (lim->max_active_zones &&
> +	    lim->max_open_zones > lim->max_active_zones)
> +		return -EINVAL;
> +
>  	if (lim->zone_write_granularity < lim->logical_block_size)
>  		lim->zone_write_granularity = lim->logical_block_size;
>  
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 52abebf56027..8f89705f5e1c 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1647,8 +1647,22 @@ static int disk_update_zone_resources(struct gendisk *disk,
>  		return -ENODEV;
>  	}
>  
> +	lim = queue_limits_start_update(q);
> +
> +	/*
> +	 * Some devices can advertize zone resource limits that are larger than
> +	 * the number of sequential zones of the zoned block device, e.g. a
> +	 * small ZNS namespace. For such case, assume that the zoned device has
> +	 * no zone resource limits.
> +	 */
> +	nr_seq_zones = disk->nr_zones - nr_conv_zones;
> +	if (lim.max_open_zones >= nr_seq_zones)
> +		lim.max_open_zones = 0;
> +	if (lim.max_active_zones >= nr_seq_zones)
> +		lim.max_active_zones = 0;
> +

Is this really correct to transform to no limits?

The MAR and MOR limits are defined in the I/O Command Set Specific Identify
Namespace Data Structure for the Zoned Namespace Command Set.

However, the user has no ability to control these limits themselves
during a namespace management create ns, or for the format command
(and this still seems to be the case in the latest ZNS spec 1.1d).

Which means that the controller has no way of knowing the number of
resources to allocate to each namespace.

Some (all?) controllers will right now simply report the same MAR/MOR
for all namespaces.


So if I use the namespace management command to create two small
zoned namespaces, the number of sequential zones might be smaller
than the limits in both namespaces, but could together be exceeding
the limit.

How is ignoring the limit that we got from the device better than
actually exposing the limit which we got from the device?

Since AFAICT, this also means that we will expose 0 to sysfs
instead of the value that the device reported.



Perhaps we should only do this optimization if:
- the device is not ZNS, or
- the device is ZNS and does not support NS management, or
- the device is ZNS and supports NS management and implements TP4115
  (Zoned Namespace Resource Management supported bit is set, even if
   that TP does not seem to be part of a Ratified ZNS version yet...)


Kind regards,
Niklas
