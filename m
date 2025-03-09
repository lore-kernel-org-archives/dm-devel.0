Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8606D14885B;
	Sun,  9 Mar 2025 23:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741564768; cv=none; b=Sj7pOJxIaAfrU4mBHC+5ZLCitZM+kHCHtLH6LMPeD8rv6QdjkGQdtlCbcQYe2bmgdj8fsCCfSjyt7DeGjpe6bIomrwwEOMKbMhUZ5RV4NfnRtrtob2xMK8aoJLA0/xiUqWNDibhOp5YToZps71pSFuRFbRxxfm16hiteSuSo+1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741564768; c=relaxed/simple;
	bh=pNKpqJ+CVqOFsGvdTXBJ1Gv/GX2FszZ+1rt65BkOFsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=upuucOQ3e6Ef9GTxt+It2E8BAgjhN1dIbLAT+eF1MaHtvvMnZ8D+8GztAMarSUUk5AVDV5wl4RhBtV1rOu27lVD1M4R2xKAL/bu3nnAflIMInObKId6gdwyQ3KXVa5vVMOfWBA2EkdYwdYFzQHfAEXPFgbbEJOggkSiwb8SBr6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+xGHSlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+xGHSlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20219C4CEE3;
	Sun,  9 Mar 2025 23:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741564768;
	bh=pNKpqJ+CVqOFsGvdTXBJ1Gv/GX2FszZ+1rt65BkOFsc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y+xGHSlf4gMiIs8gHblW+QfQUNW5Yj/5ZRpQvOpWWl13Dc6PVUZlHFz9RWhNL/jss
	 vxieO2bn8X4l68a250s/q7nvglYRAlyiF50qlq1CvrTZ4U4Gpywnk4gRZReKX/0pi5
	 ulM9+WyLcpbJqrkhlhaVMM22kmGJ16bqz+ZzLRTHnkCbTMmMV/kyn2UuuuoOOjRzga
	 JDsObI58BLomzrR3IP7arB9pzl7C2j+ychgJtfyZg17dDBdpueT2cvlJxOg/avMRvy
	 dAcsOsSuVxNEDeyDxvhuN+aHfesvHJlOEdHlyb7sCV2lCTP1DQpWOFO5Fb4zLneN77
	 Y+f1KFR/xHk4Q==
Message-ID: <7e0a1b47-3c96-4864-80b0-813f357845ad@kernel.org>
Date: Mon, 10 Mar 2025 08:59:26 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] dm: allow devices to revalidate existing zones
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-8-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-8-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:29, Benjamin Marzinski wrote:
> dm_revalidate_zones() only allowed devices that had no zone resources
> set up to call blk_revalidate_disk_zones(). If the device already had
> zone resources, disk->nr_zones would always equal md->nr_zones so
> dm_revalidate_zones() returned without doing any work. Instead, always
> call blk_revalidate_disk_zones() if you are loading a new zoned table.
> 
> However, if the device emulates zone append operations and already has
> zone append emulation resources, the table size cannot change when
> loading a new table. Otherwise, all those resources will be garbage.
> 
> If emulated zone append operations are needed and the zone write pointer
> offsets of the new table do not match those of the old table, writes to
> the device will still fail. This patch allows users to safely grow and
> shrink zone devices. But swapping arbitrary zoned tables will still not
> work.

I do not think that this patch correctly address the shrinking of dm zoned
device: blk_revalidate_disk_zones() will look at a smaller set of zones, which
will leave already hashed zone write plugs outside of that new zone range in the
disk zwplug hash table. disk_revalidate_zone_resources() does not cleanup and
reallocate the hash table if the number of zones shrinks. For a physical drive,
this can only happen if the drive is reformatted with some magic vendor unique
command, which is why this was never implemented as that is not a valid
production use case.

To make things simpler, I think we should allow growing/shrinking zoned device
tables, and much less swapping tables between zoned and not-zoned. I am more
inclined to avoid all these corner cases by simply not supporting table
switching for zoned device. That would be much safer I think.
No-one complained about any issue with table switching until now, which likely
means that no-one is using this. So what about simply returning an error for
table switching for a zoned device ? If someone request this support, we can
revisit this.

> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  drivers/md/dm-zone.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index ac86011640c3..7e9ebeee7eac 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -164,16 +164,8 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
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
> -		return 0;
> +	DMINFO("%s using %s zone append", disk->disk_name,
> +	       queue_emulates_zone_append(q) ? "emulated" : "native");
>  
>  	/*
>  	 * Our table is not live yet. So the call to dm_get_live_table()
> @@ -392,6 +384,17 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
>  		return 0;
>  	}
>  
> +	/*
> +	 * If the device needs zone append emulation, and the device already has
> +	 * zone append emulation resources, make sure that the chunk_sectors
> +	 * hasn't changed size. Otherwise those resources will be garbage.
> +	 */
> +	if (!lim->max_hw_zone_append_sectors && disk->zone_wplugs_hash &&
> +	    q->limits.chunk_sectors != lim->chunk_sectors) {
> +		DMERR("Cannot change zone size when swapping tables");
> +		return -EINVAL;
> +	}
> +
>  	/*
>  	 * Warn once (when the capacity is not yet set) if the mapped device is
>  	 * partially using zone resources of the target devices as that leads to


-- 
Damien Le Moal
Western Digital Research
