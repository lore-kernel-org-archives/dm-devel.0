Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6FE79F2
	for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 01:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750727130; cv=none; b=IyxkN01evrjc4PttgJDxuSbdu2WuI8scuXMv+9UEtJO9zScc63jeuU0OYhxtsOabpqKXjo8w4xxIyAv4KRbRrI223vj1RnDk6guz7mCEcCr8QsZoOBPNjKJmY3beNzvPTIvctd/vUVw+fxSP745XqwJsJxppoOhe1pyuNej2nLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750727130; c=relaxed/simple;
	bh=JTNtcHDxzRfWPJvGfc8jOjsOYa09Nx6ktFMuZ9N8aJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ua+ILBar3RbMGZvpy5OnJMS9iQmm+zfDHUMkeENWEfq8U4uBLec96NWR8POEgBkOaJcs1YXTmQlZmCDO5pwoUNj7Gm8CJ85Un7z/maayAZTuk0p0EugHHp32AM7v/hNIBKJbNVlF3C3HsRlyK4SAd71lnTmaw5dDkwq8RO9IYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+VWiDrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+VWiDrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F1BC4CEEA;
	Tue, 24 Jun 2025 01:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750727130;
	bh=JTNtcHDxzRfWPJvGfc8jOjsOYa09Nx6ktFMuZ9N8aJ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s+VWiDrdzsAC4KGJSMdi1CwW4fi2ckCQKPbD8GJZLOJGYhKGNhQ1Kg1UFOyxluBJA
	 0PhT0iCWuC1zzPL+XU4+wvYWhaNxI5/NMrgBBv+iCWfgBSHW783V9cTl7+s5xjHVUW
	 Zx72I+duwIihdw9V1d5X5ydJazk5gxKK5TLxglHdbL6iLOrmHQbblLGIwI5ofu7dw9
	 FaNFjcNewUV0VxtDQn5oOxdPE2cEGBJ4+CZU+xUCrcYQAJJYfXDZigkutERQw0Ois0
	 g5qdk1oCRSucJ1y2fy9+P4WnV4Nah5GJ3DQ83OVU0MsTMpda3LWt6NEYOlCHpdjeBU
	 Dzc9vHdI3jy0g==
Message-ID: <9e3e723f-dde8-4ea7-a606-275ee779d7ec@kernel.org>
Date: Tue, 24 Jun 2025 10:03:25 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dm: dm-crypt: Prevent splitting of emulated zone
 append operations
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
References: <20250611011340.92226-1-dlemoal@kernel.org>
 <20250611011340.92226-2-dlemoal@kernel.org>
 <b5f54f1e-bd70-1003-a94f-fb6b8e131b4c@redhat.com>
 <959e29bd-a303-a3a0-13a9-ab4506fbac25@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <959e29bd-a303-a3a0-13a9-ab4506fbac25@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/25 12:44 AM, Mikulas Patocka wrote:
> 
> 
> On Mon, 23 Jun 2025, Mikulas Patocka wrote:
> 
>> Applied, thanks.
>>
>> Mikulas
> 
> Applied and reverted :)
> 
> I've just realized that this patch won't work because the value 
> get_max_request_size is changeable by the user - it's in the file 
> /sys/module/dm_crypt/parameters/max_write_size. So, if there is some large 
> value when you create the device and later the user sets smaller value, 
> dm-crypt will still split emulated zone append bios.

Indeed. Good catch.

> I suggest to set the limit limits->max_hw_sectors to BIO_MAX_VECS << 
> PAGE_SHIFT (that's the maximum allowable value for dm-crypt) and then 
> modify dm-crypt to not split bios that have the flag 
> BIO_EMULATES_ZONE_APPEND.

I think we simply need to do a limit update when the user modifies the write
limit through sysfs. That will prevent things from going out of sync if the
user ever modifies the limit.

Of note is that this patch turns out to be more than just about zone append
emulation. We absolutely need it for any write request (for emulating zone
append or regular writes) to avoid the accept partial return which would
trigger issuing another BIO. In this case, we are at risk of deadlocking with
queue freeze on blk_queue_enter() in the submission path. So this patch, and
another one forcing splitting of all write BIOs to zoned DM devices is needed
to avoid this deadlock.

I will send a v2 with the additional patch and a better commit message for this
patch explaining this.

> 
> Mikulas
> 
>> On Wed, 11 Jun 2025, Damien Le Moal wrote:
>>
>>> For a zoned dm-crypt device, the native support for zone append
>>> operations (REQ_OP_ZONE_APPEND) is not enabled and instead dm-crypt
>>> relies on the emulation done by the block layer using regular write
>>> operations. This still requires to properly return the written sector as
>>> the BIO sector of the original BIO. However, this can be done correctly
>>> only and only if there is a single clone BIO used for processing the
>>> original zone append operation issued by the user. If the size of a zone
>>> append operation is larger than dm-crypt max_write_size, then the
>>> orginal BIO will be split and processed as a chain of regular write
>>> operations. Such chaining result in an incorrect written sector being
>>> returned to the zone append issuer using the original BIO sector.
>>> This in turn results in file system data corruptions using xfs or btrfs.
>>>
>>> Fix this by modifying crypt_io_hints() to cap the max_hw_sectors limit
>>> for the dm-crypt device to the max_write_size limit. As this limit also
>>> caps the device max_zone_append_sectors limit, this forces the caller to
>>> issue zone append operations smaller than this limit, thus moving the
>>> splitting of large append operations to the caller instead of the
>>> incorrect internal splitting.
>>>
>>> This change does not have any effect on the size of BIOs received by
>>> dm-crypt since the block layer does not automatically splits BIOs for
>>> BIO-based devices. So there is no impact on the performance of regular
>>> read and write operations.
>>>
>>> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>> ---
>>>  drivers/md/dm-crypt.c | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>>> index 9dfdb63220d7..7b1e88781a82 100644
>>> --- a/drivers/md/dm-crypt.c
>>> +++ b/drivers/md/dm-crypt.c
>>> @@ -3730,6 +3730,18 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>>>  		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
>>>  	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
>>>  	limits->dma_alignment = limits->logical_block_size - 1;
>>> +
>>> +	/*
>>> +	 * For zoned devices, we cannot split write operations used to emulate
>>> +	 * zone append operations. And since all write requests are going to be
>>> +	 * split on get_max_request_size(cc, true) size, apply this limit to the
>>> +	 * maximum hardware I/O size so that we have a cap on the
>>> +	 * max_zone_append_sectors limit when the zone limits are validated by
>>> +	 * the block layer.
>>> +	 */
>>> +	if (ti->emulate_zone_append)
>>> +		limits->max_hw_sectors = min(limits->max_hw_sectors,
>>> +					     get_max_request_size(cc, true));
>>>  }
>>>  
>>>  static struct target_type crypt_target = {
>>> -- 
>>> 2.49.0
>>>
>>
> 


-- 
Damien Le Moal
Western Digital Research
