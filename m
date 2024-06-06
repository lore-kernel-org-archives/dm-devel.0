Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC35E364;
	Thu,  6 Jun 2024 00:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717632422; cv=none; b=XRIVyh/pn7qGpAFhSmcdSNc50SmfT7QitWvkqZGwvUSVV2T4/A2nG93pmrUYFkgIsxHcb2uungXnw1CHymubrmxCw9sQoM7O0AtXGvn/aDtOsA3g9LX1CEbH0LBmIqRhCrEbN+mV53Tstk4LJnuCGHVznSpHcZ3ff5aMTTVeIT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717632422; c=relaxed/simple;
	bh=wfkomk6zFV4Oye3xNP64Tqa2P/qir+tHe8Li49wof44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qGhpHQsgBPDERGI8zeeGxDshB6lah8oKmUFbNRbVDfgRKCD0ZkdfOnbMB0MMbb1fwDDXWjRBlFJrJ3oWTisDMj+erQucLR3PXx70voPtBz+exJxahrJNTcchesFvJ7CNsjGtXxWRPhQPKJAsoZuIvQHrx1fdOW2/yoLq6uG2bBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mn9tL13S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mn9tL13S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124E0C2BD11;
	Thu,  6 Jun 2024 00:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717632421;
	bh=wfkomk6zFV4Oye3xNP64Tqa2P/qir+tHe8Li49wof44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mn9tL13SDkmzn5WocJ2xe/McFZePxZkHi49QhaoUnJGInTBD5+ZCOOcXkdOmqZNfX
	 Ptzbu+g0mwFBvUHxNZQjX0p7Kq5KdD6H/f3FQFyCqGossBSNtBVxaicVm9hGEEM/HE
	 tR5nWBY5DZjr0SNi4ia3seiu6aI8+5++f4ChM2ChmLOGtWjGmjxUlplxrxcZs5r07M
	 Q09WEiKGhsZS9DZK2C0bpKyYA14ujG3ihs+6CvqO6pnAUAxDwKjcxCHZviza0AD5Hd
	 lhWMXiAYSO7LK28ektNsmDBdqWR8+V1aobuU8J5qbkN9/A9ozUuvYY+crQXvSAZ4Xd
	 TR/arf8sN+3Ew==
Message-ID: <2e8b1334-61a1-4c1c-a4f7-9550e32e7be6@kernel.org>
Date: Thu, 6 Jun 2024 09:06:58 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] block: Improve checks on zone resource limits
To: Niklas Cassel <cassel@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-2-dlemoal@kernel.org> <ZmCfmlnoo7wjQLTg@ryzen.lan>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZmCfmlnoo7wjQLTg@ryzen.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 2:25 AM, Niklas Cassel wrote:
> On Wed, Jun 05, 2024 at 04:51:42PM +0900, Damien Le Moal wrote:
>> Make sure that the zone resource limits of a zoned block device are
>> correct by checking that:
>> (a) If the device has a max active zones limit, make sure that the max
>>     open zones limit is lower than the max active zones limit.
>> (b) If the device has zone resource limits, check that the limits
>>     values are lower than the number of sequential zones of the device.
>>     If it is not, assume that the zoned device has no limits by setting
>>     the limits to 0.
>>
>> For (a), a check is added to blk_validate_zoned_limits() and an error
>> returned if the max open zones limit exceeds the value of the max active
>> zone limit (if there is one).
>>
>> For (b), given that we need the number of sequential zones of the zoned
>> device, this check is added to disk_update_zone_resources(). This is
>> safe to do as that function is executed with the disk queue frozen and
>> the check executed after queue_limits_start_update() which takes the
>> queue limits lock. Of note is that the early return in this function
>> for zoned devices that do not use zone write plugging (e.g. DM devices
>> using native zone append) is moved to after the new check and adjustment
>> of the zone resource limits so that the check applies to any zoned
>> device.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>  block/blk-settings.c |  8 ++++++++
>>  block/blk-zoned.c    | 20 ++++++++++++++++----
>>  2 files changed, 24 insertions(+), 4 deletions(-)
>>
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index effeb9a639bb..474c709ea85b 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -80,6 +80,14 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
>>  	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED)))
>>  		return -EINVAL;
>>  
>> +	/*
>> +	 * Given that active zones include open zones, the maximum number of
>> +	 * open zones cannot be larger than the maximum numbber of active zones.
> 
> s/numbber/number/
> 
> 
>> +	 */
>> +	if (lim->max_active_zones &&
>> +	    lim->max_open_zones > lim->max_active_zones)
>> +		return -EINVAL;
>> +
>>  	if (lim->zone_write_granularity < lim->logical_block_size)
>>  		lim->zone_write_granularity = lim->logical_block_size;
>>  
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 52abebf56027..8f89705f5e1c 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -1647,8 +1647,22 @@ static int disk_update_zone_resources(struct gendisk *disk,
>>  		return -ENODEV;
>>  	}
>>  
>> +	lim = queue_limits_start_update(q);
>> +
>> +	/*
>> +	 * Some devices can advertize zone resource limits that are larger than
>> +	 * the number of sequential zones of the zoned block device, e.g. a
>> +	 * small ZNS namespace. For such case, assume that the zoned device has
>> +	 * no zone resource limits.
>> +	 */
>> +	nr_seq_zones = disk->nr_zones - nr_conv_zones;
>> +	if (lim.max_open_zones >= nr_seq_zones)
>> +		lim.max_open_zones = 0;
>> +	if (lim.max_active_zones >= nr_seq_zones)
>> +		lim.max_active_zones = 0;
>> +
> 
> Is this really correct to transform to no limits?
> 
> The MAR and MOR limits are defined in the I/O Command Set Specific Identify
> Namespace Data Structure for the Zoned Namespace Command Set.
> 
> However, the user has no ability to control these limits themselves
> during a namespace management create ns, or for the format command
> (and this still seems to be the case in the latest ZNS spec 1.1d).
> 
> Which means that the controller has no way of knowing the number of
> resources to allocate to each namespace.
> 
> Some (all?) controllers will right now simply report the same MAR/MOR
> for all namespaces.
> 
> 
> So if I use the namespace management command to create two small
> zoned namespaces, the number of sequential zones might be smaller
> than the limits in both namespaces, but could together be exceeding
> the limit.
> 
> How is ignoring the limit that we got from the device better than
> actually exposing the limit which we got from the device?

If the limits are larger than the number of zones in the namespace, there is no
limits at all. This is what this change does. No question that this is correct.
Even if we do not change the values, any application/fs looking at these limits
being larger than the number of zones will conclude the same.

The problem you are raising is the reliability of the limits themselves, and
for NVMe ZNS, given that MOR/MAR are not defined per namespace, we are in the
same situation as with DM devices sharing the same zoned block dev through
different targets: even if the user respects the limits, write errors may
happen due to the backing dev limits (or controller limits for ZNS) being
exceeded. Nothing much we can do to easily deal with this right now. We would
need to constantly track zone states and implement a software driven zone state
machine checking the limits all the time to actually provide guarantees.

> Since AFAICT, this also means that we will expose 0 to sysfs
> instead of the value that the device reported.

Yes. But the value reported by the device is for the whole controller. The
sysfs attributes are for the block device == namespace.

> Perhaps we should only do this optimization if:
> - the device is not ZNS, or
> - the device is ZNS and does not support NS management, or
> - the device is ZNS and supports NS management and implements TP4115
>   (Zoned Namespace Resource Management supported bit is set, even if
>    that TP does not seem to be part of a Ratified ZNS version yet...)

Right now, this all works the same way for DM and nvme zns, so I think this is
all good. If anything, we should probably add a warning in the nvme driver
about the potentially unreliable moz/moz limits if we see a ZNS device with
multiple zoned namespaces.

-- 
Damien Le Moal
Western Digital Research

