Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C0D15FD0B;
	Wed,  5 Jun 2024 23:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717631555; cv=none; b=H+J5hngqxjL64xyLeJ+e6YiXNpsF0FxnCZxTgyyp6rLrzLwSzAUJnVJYBYT5cxv581SeUb89PgjbbFB77/rBvsTsXeZ7lhigOapImERaMcHX0KbCP5hLD9eogqbi7fLJb3vJMUAUuIGckdrWwT6GnsNtm1l1ryVYKfVI94/sT2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717631555; c=relaxed/simple;
	bh=RViE+yDwPHMKwcj3LObh26OQLR9TJ/tVR/tAYs6LNzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=idiD0TiyWdZj+nkB2UN5+O7f6ydEUGhWpCy4Cm+2VKf5yNGEjnEFtXHG7zXCofdN5ww68zvbhl8v4Sp5TI+EWitxiwMtd86mmFTDfDyF3fWaSJOhgE8W9WO++GWwujleegQQ2dLVe4mosTp4/AeThKtZ2Wuy4nJyYfnHWlxvb+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caWCVx4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caWCVx4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D488AC2BD11;
	Wed,  5 Jun 2024 23:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717631554;
	bh=RViE+yDwPHMKwcj3LObh26OQLR9TJ/tVR/tAYs6LNzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=caWCVx4yrrHdSuFT8937kBbWdyHz/zy+QZW5l7BYFHI8WKusyw6e+ph9wDBQvu+bL
	 F8qqi1r8Md3hx2bBRvgb1D/9Ki1f7+kdoIqJGaCM0hNzQ61Jt/mmaWOAqyP8o573JV
	 62zjayu5LsiMXMefs1eBiJY78EQPnbacQJ6+o2rsIDkigdFa+GkuyRT39YWKbXiUZv
	 BS2SGWbpzd3gZPRpKrO2TJrHwirBDNoU4wZCblesz2OppveMd5skkV8i5X8duHt2hp
	 UIquvzb9tTYLGclHhpRUl+FXF4KG2NjjJz1Igp9ENe9cVP0afRq7hVsz/nKyguYF+s
	 tOI5tsP3QoOwg==
Message-ID: <90629a40-e45f-490b-bef6-436839d91b92@kernel.org>
Date: Thu, 6 Jun 2024 08:52:32 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] dm: Improve zone resource limits handling
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-3-dlemoal@kernel.org> <ZmDA5fmZMNGM1oFl@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZmDA5fmZMNGM1oFl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 4:47 AM, Benjamin Marzinski wrote:
> On Wed, Jun 05, 2024 at 04:51:43PM +0900, Damien Le Moal wrote:
>> +static int dm_device_count_zones(struct dm_dev *dev,
>> +				 struct dm_device_zone_count *zc)
>> +{
>> +	int ret;
>> +
>> +	ret = blkdev_report_zones(dev->bdev, 0, UINT_MAX,
>> +				  dm_device_count_zones_cb, zc);
> 
> Other than the nitpick that BLK_ALL_ZONES looks better than UINT_MAX
> here, looks good.

Thanks, will make this change.

However, I realized that we have another serious issue with this, so more
changes are needed. The issue is that we have the call chain:

dm_table_set_restrictions(t, q, lim) -> dm_set_zones_restrictions(t, q, lim) ->
dm_set_zone_resource_limits(md, t, lim) which  is fine as all these functions
operate looking at the same limits. But then after calling
dm_set_zone_resource_limits() which may modify the max open/max active limits,
dm_set_zones_restrictions() calls dm_revalidate_zones(md, t), which then calls
blk_revalidate_disk_zones(). This last function looks at the max open/max
active limits of the disk queue limits to setup zone write plugging (if needed
in the case of DM). But the disk queue limits are *different* from the lim
pointer passed from dm_table_set_restrictions() as these have not been applied
yet. So we have blk_revalidate_disk_zones() looking at the "old", not yet
corrected zone resource limits.

I have 22 different test cases for testing this and none of them can detect a
problem with this. But it is still wrong and needs to be fixed.

Christoph,

Unless you have a better idea, I think we need to pass a queue_limits struct
pointer to blk_revalidate_disk_zones() -> disk_update_zone_resources(). This
pointer can be NULL, in which case disk_update_zone_resources() needs to do the
limit start_update+commit. But if it is not NULL, then
disk_update_zone_resources() must use the passed limits.

-- 
Damien Le Moal
Western Digital Research

