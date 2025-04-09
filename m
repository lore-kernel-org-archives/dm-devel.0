Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38E11D8A0A
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 06:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744178621; cv=none; b=mn69iGdpQQbx2uI/Ltk5TnRUmB8kKJu89LtKy0snGeQ44v3I9AqrXmkKT2flz84vZIJuvp6aVaVsesQ2mgyW6BVwRF1Ha1CWxQyhFmKycg5FGBzilInE19WiMUBx0QfjfVSMz9IJNzAPXyZskdU7WtOVd4sNZLsMXeKYWzVDmss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744178621; c=relaxed/simple;
	bh=/pEdC3YudZCQ/UMVDZaIYqmD05+9QYbQstcZXWZcNLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ax7XilHH/SNFEwzsxSl9J5wr01GpDhXVXrGL/09iCmAkB+mDKPpZu1/ceQnwaRMT+uS0dTOU7o4LNIztyqwxIDylCPN2fB1eUryVbsSFYPuNeSx6Vf9ZqaGPjHUmsFZtsmafzuXgdiC8zRsXjVrRPZXtMOFM1R5SGvZb1h6l90w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRg/u/r3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRg/u/r3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1704C4CEE3;
	Wed,  9 Apr 2025 06:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744178620;
	bh=/pEdC3YudZCQ/UMVDZaIYqmD05+9QYbQstcZXWZcNLM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aRg/u/r3r+SvqdpudW8swODcpXLhDH2OkyPByXvQRlce1hI6QZJ/fX50s8RqG2oEw
	 wNa5Zobic8AhIGvk+7OrciabQwPAyrjC86hHTSiBfdA11h/e1OCnd07SE4bveh98pQ
	 WVSLIvNrQUmL6cUQJQF/wqkQHtksiRxHKxTzE8jYEEhoQ5Umrayxh0As+ndoMfKpW0
	 lPIigC06DPApx8i+pMx92n1uaIuhDLb1xmHoevLr+4hsND9OA13d516NtZbmHG0s/t
	 Kvq9PacukkqkqQ7ho+sicURsIKNbQ8NWKNT/B0x5qj1UhpwKL6qMFrDWJzV4jzmDKK
	 4rabsAR3PInsg==
Message-ID: <c3e3521a-daf2-4856-9db5-e093a7e59be9@kernel.org>
Date: Wed, 9 Apr 2025 15:02:58 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] dm: fix dm_blk_report_zones
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
 <20250408235159.4128838-5-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250408235159.4128838-5-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/9/25 8:51 AM, Benjamin Marzinski wrote:
> If dm_get_live_table() returned NULL, dm_put_live_table() was never
> called. Also, it is possible that md->zone_revalidate_map will change
> while calling this function. Only read it once, so that we are always
> using the same value. Otherwise we might miss a call to
> dm_put_live_table().
> 
> Finally, while md->zone_revalidate_map is set and a process is calling
> blk_revalidate_disk_zones() to set up the zone append emulation
> resources, it is possible that another process, perhaps triggered by
> blkdev_report_zones_ioctl(), will call dm_blk_report_zones(). If
> blk_revalidate_disk_zones() fails, these resources can be freed while
> the other process is still using them, causing a use-after-free error.
> 
> blk_revalidate_disk_zones() will only ever be called when initially
> setting up the zone append emulation resources, such as when setting up
> a zoned dm-crypt table for the first time. Further table swaps will not
> set md->zone_revalidate_map or call blk_revalidate_disk_zones().
> However it must be called using the new table (referenced by
> md->zone_revalidate_map) and the new queue limits while the DM device is
> suspended. dm_blk_report_zones() needs some way to distinguish between a
> call from blk_revalidate_disk_zones(), which must be allowed to use
> md->zone_revalidate_map to access this not yet activated table, and all
> other calls to dm_blk_report_zones(), which should not be allowed while
> the device is suspended and cannot use md->zone_revalidate_map, since
> the zone resources might be freed by the process currently calling
> blk_revalidate_disk_zones().
> 
> Solve this by tracking the process that set md->zone_revalidate_map
> dm_revalidate_zones() and only allowing that process to make use of it
> in dm_blk_report_zones().

..that sets md->zone_revalidate_map in dm_revalidate_zones() and... ?

> 
> Fixes: f211268ed1f9b ("dm: Use the block layer zone append emulation")
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

I do not recall reviewing this version, but looks OK to me with the sentence
above fixed.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>


-- 
Damien Le Moal
Western Digital Research
