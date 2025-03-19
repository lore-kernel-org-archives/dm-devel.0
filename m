Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C8A12CD8B;
	Wed, 19 Mar 2025 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742348472; cv=none; b=OX1quNh+yDADRbABBbuVWT+XnTHCXgpWr2IeyEkU753rG40iovLMA6UvqoNkeeyfzXTaS6RfK6IYIFnPMMMyhTmGfJ1CdMy/EIMgp7gOo/QiCCGnJALdKNZmFAer8CyLfABn45Zs9obF+tji75xgj77L7mzG2welt+6ixRdpXWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742348472; c=relaxed/simple;
	bh=u4VHbYwCy1SXsrB93FaqV0IDSgJLRNG/nVselvNk5tc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qMgWyqwhM4ng10yWf6XHxMdXnD4FXI50IGFR/TdS/0uu37nk5qm96sQojyhJ0oVch8jOZ5ORuS8/0Sgy4mMOIT0w7UdMPr8V0K9QtIOtQ53afkJCJ1jFyOIObQsSKSacUmPA9lno3Gb3g0z0wCz73cUj2bea7OT6w4LUyO2QGIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+OEW0v+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+OEW0v+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C3EC4CEDD;
	Wed, 19 Mar 2025 01:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742348471;
	bh=u4VHbYwCy1SXsrB93FaqV0IDSgJLRNG/nVselvNk5tc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q+OEW0v+EP1swX61eH89htc1YJ8I60kVlUChKew66UC33nAV8NjpJvHQR1TCnO0ON
	 796xOzZSzmmfO8Rnd6FzrDFhkH5POxpEfwoIvrsqtw4VsJtEX99YCIrU6kMOB1sUiC
	 3lj1PZ3YjcuCARAHJVLEEfLIphIxs5eQkBU9Vl+IcDGEw+dozSJeiU/O7naBaqw0fp
	 lS5bTeps372XJulRysfhMdhsH2NUKMmDVEegw/9+Dae+KJXlidJTWBCdtEoDAizbNX
	 EPK5xsJAb0918iSneanWHkcdqDU557P6/LbdMvkFNbdEG2Y+7M0mLKiuUGAFhs4Xrs
	 EFKirTUVuqcyQ==
Message-ID: <ae356993-ffa3-4ee1-87e3-3257dedf9908@kernel.org>
Date: Wed, 19 Mar 2025 10:40:38 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] dm: fix dm_blk_report_zones
To: Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org
References: <20250317044510.2200856-1-bmarzins@redhat.com>
 <20250317044510.2200856-6-bmarzins@redhat.com>
 <20250318065721.GB16259@lst.de> <Z9nvOcQRrxopHfrF@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <Z9nvOcQRrxopHfrF@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/25 7:10 AM, Benjamin Marzinski wrote:
> On Tue, Mar 18, 2025 at 07:57:21AM +0100, Christoph Hellwig wrote:
>> On Mon, Mar 17, 2025 at 12:45:09AM -0400, Benjamin Marzinski wrote:
>>> __bind(). Otherwise the zone resources could change while accessing
>>> them. Finally, it is possible that md->zone_revalidate_map will change
>>> while calling this function. Only read it once, so that we are always
>>> using the same value. Otherwise we might miss a call to
>>> dm_put_live_table().
>>
>> This checking for calling context is pretty ugly.  Can you just use
>> a separate report zones helper or at least a clearly documented flag for it?
> 
> Not sure how that would work. The goal is to keep another process,
> calling something like blkdev_report_zones_ioctl(), from being able to
> call its report_zones_cb, while DM is in blk_revalidate_disk_zones()
> which needs to use that same disk->fops->report_zones() interface in
> order to call blk_revalidate_zone_cb(). We need some way to distinguish
> between the callers. We could export blk_revalidate_zone_cb() and have
> dm_blk_report_zones() check if it was called with that report_zones_cb.
> That seems just as ugly to me. But if you like that better, fine.
> Otherwise I don't see how we can distinguish between the call from
> blk_revalidate_disk_zones() and a call from something like
> blkdev_report_zones_ioctl(). Am I not understanding your suggestion?
> 
> Allowing the blkdev_report_zones_ioctl() call to go ahead using
> md->zone_revalidate_map runs into three problems.
> 
> 1. It's running while the device is switching tables, and there's no
> guarantee that DM won't encounter an error and have to fail back. So it
> could report information for this unused table. We could just say that
> this is what you get from trying to grab the zone information of a
> device while it's switching tables. Fine.
> 
> 2. Without this patch, it's possible that while
> blkdev_report_zones_ioctl() is still running its report_zones_cb, DM
> fails switching tables and frees the new table that's being used by
> blkdev_report_zones_ioctl(), causing use-after-free errors. However,
> this is solvable by calling srcu_read_lock(&md->io_barrier) to make sure
> that we're in a SRCU read section while using md->zone_revalidate_map.
> Making that chage should make DM as safe as any other zoned device,
> which brings me to...
> 
> 3. On any zoned device, not just DM, what's stopping
> one process from syncing the zone write plug offsets:
> blkdev_report_zones_ioctl() -> blkdev_report_zones() ->
> various.report_zones() -> disk_report_zones_cb() ->
> disk_zone_wplug_sync_wp_offset()

disk_zone_wplug_sync_wp_offset() is a nop for any zone write plug that does not
have BLK_ZONE_WPLUG_NEED_WP_UPDATE set. And that flag is set only for zones
that had a write error. Given that recovering from write errors on zoned device
requires to:
1) stop writing to the zone,
2) Do a report zone (which will sync the wp offset)
3) Restart writing
there is no write IOs going on for the zone that is being reported, for a well
behaved user. If the user is not well behaved, it will get errors/out of sync
wp, until the user behaves :) So I would not worry too much about this.
As we discussed, the table switching should be allowed only for the wildcard
target (dm-error) and that's it. We should not allow table switching otherwise.
And given that inserting dm-error does not cause any change to the zone
configuration, I do not see why we need to revalidate zones.

> 
> While another process is running into problems while dealing with the
> gendisk's zone configuration changing:
> 
> blk_revalidate_disk_zones() -> disk_free_zone_resources()

We should not allow the zone configuration to change. That is impossible to
deal with at the user level.

> I don't see any synchronizing between these two call paths. Am I missing
> something that stops this? Can this only happen for DM devices, for some
> reason? If this can't happen, I'm fine with just adding a
> srcu_read_lock() to dm_blk_report_zones() and calling it good.  If it
> can happen, then we should fix that.

I think it can happen today but no-one ever had this issue because no-one has
tried to switch a dm-table on a zoned drive. And I really think we should
prevent that from being done, except for dm-error since that's used for fstests.

> 
> -Ben
> 


-- 
Damien Le Moal
Western Digital Research
