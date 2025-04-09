Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375691D90A9
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 06:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744179883; cv=none; b=Kms9md8EUa0CMexiYNYIee67RtWDM6QanGNOmdb6hxHVUAYFyNR90mDPzBo5S7gyLO/pJmeyASx/r1NWTxWWX6COcs2LS13qvmbeLrurC2wHX7Y2AdcSuvSQBmR3QOCayh/G+gJT2pVTIWNXy/vqUERZv0K8Ck/OUVKU6zM5XTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744179883; c=relaxed/simple;
	bh=sjmEiTAMIt3HOWBkXaV5BeM8u1nlp8SvJulWEWfM+g8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r1KNVRpgjBeo2ZAGeatp51oYfMTmgEI+f8tCPUKNpDvcK0DwKx5yOu+rRmItGI+Q1ameOjuvixujVchA7/JCjnuNsC/Wc1qufqaeeYBh1433NJHAcJZavW4n20a99rZfSQruZh+LPUT0+z+yf+8ok1HQ5F0gr2F/HBsYO2Z4aBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwZNmMSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwZNmMSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D23AC4CEE3;
	Wed,  9 Apr 2025 06:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744179882;
	bh=sjmEiTAMIt3HOWBkXaV5BeM8u1nlp8SvJulWEWfM+g8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cwZNmMSzzQtEAxv1QHuwY+/Bw4LdHh6A0U4Gx+OCg9LlBZgCYTOcBvTZA0Ug8Rd1T
	 HedPMchcmPYDTdd2g9rT8kixGYyEsWt5WUFd7QThZYq4SQrVOTAQGUjyGgUYWJFcxe
	 0MR0p6W3iIXu10GJYsmKsRdkoHuJ6ySPt9H1vz1zvpI186yP8c6BF9w2LuSP3td/Bi
	 gdDGWDyzmTbX36GIM+U4OMNQNEQPOLRT55CG2AACxqg+Iq4YhnclZqYSVCSoLD27fP
	 fDGWMKzIYIvVxQYJI/5E62T7/SVRtwIBvD2VcjRseRL45YTzmgVAqpLO/4wC6mryPz
	 R80YQe5A4vuQw==
Message-ID: <2602b517-3826-452b-b640-36c84c4ccef0@kernel.org>
Date: Wed, 9 Apr 2025 15:24:00 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] [PATCH v3 0/6] dm: fix issues with swapping dm
 tables
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250408235159.4128838-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/25 8:51 AM, Benjamin Marzinski wrote:

Thanks for all the fixes. Of note is that I am looking into the dm-delay
pre-suspend problem for zoned case (potential reordering of writes). It turns
out to not be an easy fix given how dm-delay works. Still scratching my head :)

> There were multiple places in dm's __bind() function where it could fail
> and not completely roll back, leaving the device using the the old
> table, but with device limits and resources from the new table.
> Additionally, unused mempools for request-based devices were not always
> freed immediately.
> 
> Also, there were a number of issues with switching zoned tables that
> emulate zone append (in other words, dm-crypt on top of zoned devices).
> dm_blk_report_zones() could be called while the device was initially
> setting up a zoned table and creating zoned resources or could possibly
> fail to end a srcu read section.  More importantly,
> blk_revalidate_disk_zones() would never get called when updating a zoned
> table. This could cause the dm device to see the wrong zone write
> offsets, not have a large enough zwplugs reserved in its mempool, or
> read invalid memory when checking the conventional zones bitmap.
> 
> Finally, any DM device created on top of a device emulating zone appeads
> will automatically have zone write plug resources created for it, since
> max_hw_zone_append_sectors will always be 0 for a device stacked on top
> of a device max_hw_zone_append_sectors = 0
> 
> This patchset fixes these issues. It deals with the problems around
> blk_revalidate_disk_zones() by only calling it for devices that have no
> zone write plug resources. This will always correctly update the zoned
> settings. If a device has zone write plug resources, calling
> blk_revalidate_disk_zones() will not correctly update them in many
> cases, so DM simply doesn't call it for devices with zone write plug
> resources. Instead of allowing people to load tables that can break the
> device, like currently happens, DM disallosw any table reloads that
> change the zoned setting for devices that already have zone write plug
> resources. Finally, it deals with the max_hw_zone_append_sectors issue
> by making sure that it is non-zero for zoned DM devices that do not need
> zone write append emulation.
> 
> Changes in V3:
> - Use queue_limits_start_update() instead of modifying
>   queue_limits_set()
> - Rewrote the commit message for patch 0004 ("dm: fix
>   dm_blk_report_zones") to explain that this only happens when initially
>   setting up a table with zone append resources, so disallowing table
>   swaps after you set up a zoned dm-crypt device will not effect the
>   issue at all. I did not implement Christoph's suggestion because I
>   don't understand how it would work here. Perhaps I'm just being dense.
>   I'm not wedded to this solution. Any one that keeps this
>   use-after-free error from being possible is fine by me.
> - Added a final patch to deal with the issue of stacked devices always
>   getting zone append resources if any underlying device needs them.
> 
> Changes in V2:
> - Made queue_limits_set() optionally return the old limits (grabbed
>   while holding the limits_lock), and used this in
>   dm_table_set_restrictions()
> - dropped changes to disk_free_zone_resources() and the
>   blk_revalidate_disk_zones() code path (removed patches 0005 & 0006)
> - Instead of always calling blk_revalidate_disk_zones(), disallow
>   changes that would change zone settings if the device has
>   zone write plug resources (final patch).
> 
> Benjamin Marzinski (6):
>   dm: don't change md if dm_table_set_restrictions() fails
>   dm: free table mempools if not used in __bind
>   dm: handle failures in dm_table_set_restrictions
>   dm: fix dm_blk_report_zones
>   dm: limit swapping tables for devices with zone write plugs
>   dm: fix native zone append devices on top of emulated ones
> 
>  drivers/md/dm-core.h  |  1 +
>  drivers/md/dm-table.c | 67 +++++++++++++++++++++++++-------
>  drivers/md/dm-zone.c  | 90 ++++++++++++++++++++++++++++++-------------
>  drivers/md/dm.c       | 36 ++++++++++-------
>  drivers/md/dm.h       |  6 +++
>  5 files changed, 146 insertions(+), 54 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
