Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475428DF3D
	for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 12:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766613; cv=none; b=svFTK01Bg2aez6N+FP0rCcWMxTM4pQmcOKAfIUwtajrdLfSJgVMAonEEpK0AT3Y4/XrZqQt7fXNB+1olmhfgyxLrxf58vWiAF0bzLChIC+SdP5Yq3E2d39Lwdeme2G/U19caVnX17R0XkrbcA174napMNFHYPR1nlKx9rUWRnjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766613; c=relaxed/simple;
	bh=yWnLzRGy91Qfh6APnsCIsx10Z79GI8nfTmmdY9MGvsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dCvAb+bWyyHjXoh8qZ8o6MxT40fD8/vMjCMUNCcp3dUuLsb4bzckMwVKNsGF2u+aeywX+w06xQRc+OBuW5BrcAjC2c0IKz45GEu1b9fijsTalyklQXuc0qh8BgoGUuAbx6QrPfq6LRnHqqpaEKQ/sdtI9UC3Jj/kiO86CbUigZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DT7GNvWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DT7GNvWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A868CC4CEF0;
	Tue, 24 Jun 2025 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750766613;
	bh=yWnLzRGy91Qfh6APnsCIsx10Z79GI8nfTmmdY9MGvsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DT7GNvWC/JRCmBFJ5p3ytkdcyi/lwQRlefII9VNjhcqclE5YkFZnj/yTAGibEFZV1
	 fCAMAaSdXOqp+37SGD6qFnYS3WQKGdqhO7vOiepa+3sWnm7NP/1cUuuQcMPKOj0854
	 x81/rwCzCQV69U5JUyYejOvlwANczLoo0qcyqJP5+2V19+/XI/bvuGPQ0XWYK0Cyzh
	 xnsncLuVlyqfGnFJxo6T2iDsjx51fYGe2kWIPtRzO5heslQqKObWxyLlb65F71af5p
	 F8r/5759kcxsf4j/WLihsWnkAAMUsp4eS9UrmB6T2qlP/IhHzfvKP6tlNr6SLb2PtS
	 JOCk3y4eWR3Yg==
Message-ID: <53fc38c0-26f7-473b-b782-2f9a60a628db@kernel.org>
Date: Tue, 24 Jun 2025 21:03:31 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-crypt: Prevent splitting of emulated zone append
 operations
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
References: <20250611011340.92226-1-dlemoal@kernel.org>
 <20250611011340.92226-2-dlemoal@kernel.org>
 <b5f54f1e-bd70-1003-a94f-fb6b8e131b4c@redhat.com>
 <959e29bd-a303-a3a0-13a9-ab4506fbac25@redhat.com>
 <9e3e723f-dde8-4ea7-a606-275ee779d7ec@kernel.org>
 <b459b3d0-15f2-16c0-15f0-f25f85ce4136@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b459b3d0-15f2-16c0-15f0-f25f85ce4136@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/25 20:54, Mikulas Patocka wrote:
> 
> 
> On Tue, 24 Jun 2025, Damien Le Moal wrote:
> 
>> On 6/24/25 12:44 AM, Mikulas Patocka wrote:
>>>
>>>
>>> On Mon, 23 Jun 2025, Mikulas Patocka wrote:
>>>
>>>> Applied, thanks.
>>>>
>>>> Mikulas
>>>
>>> Applied and reverted :)
>>>
>>> I've just realized that this patch won't work because the value 
>>> get_max_request_size is changeable by the user - it's in the file 
>>> /sys/module/dm_crypt/parameters/max_write_size. So, if there is some large 
>>> value when you create the device and later the user sets smaller value, 
>>> dm-crypt will still split emulated zone append bios.
>>
>> Indeed. Good catch.
>>
>>> I suggest to set the limit limits->max_hw_sectors to BIO_MAX_VECS << 
>>> PAGE_SHIFT (that's the maximum allowable value for dm-crypt) and then 
>>> modify dm-crypt to not split bios that have the flag 
>>> BIO_EMULATES_ZONE_APPEND.
>>
>> I think we simply need to do a limit update when the user modifies the write
>> limit through sysfs. That will prevent things from going out of sync if the
>> user ever modifies the limit.
> 
> I think that's too complicated.
> 
> The sysfs limit was originally introduced to improve performance through 
> concurrent encryption - if dm-crypt splits large bio to several smaller 
> bios, it may improve performance because these smaller bios are encrypted 
> by multiple cores in parallel.
> 
> As zoned devices won't see improved performance from limiting write size, 
> we can just ignore the sysfs limit for zone append operations.
> 
>> Of note is that this patch turns out to be more than just about zone append
>> emulation. We absolutely need it for any write request (for emulating zone
>> append or regular writes) to avoid the accept partial return which would
>> trigger issuing another BIO. In this case, we are at risk of deadlocking with
>> queue freeze on blk_queue_enter() in the submission path. So this patch, and
>> another one forcing splitting of all write BIOs to zoned DM devices is needed
>> to avoid this deadlock.
>>
>> I will send a v2 with the additional patch and a better commit message for this
>> patch explaining this.
> 
> I've created this patch - please review it and test it.
> 
> Mikulas
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> For a zoned dm-crypt device, the native support for zone append
> operations (REQ_OP_ZONE_APPEND) is not enabled and instead dm-crypt
> relies on the emulation done by the block layer using regular write
> operations. This still requires to properly return the written sector as
> the BIO sector of the original BIO. However, this can be done correctly
> only and only if there is a single clone BIO used for processing the
> original zone append operation issued by the user. If the size of a zone
> append operation is larger than dm-crypt max_write_size, then the
> orginal BIO will be split and processed as a chain of regular write
> operations. Such chaining result in an incorrect written sector being
> returned to the zone append issuer using the original BIO sector.
> This in turn results in file system data corruptions using xfs or btrfs.
> 
> Fix this by modifying crypt_io_hints() to cap the max_hw_sectors limit
> for the dm-crypt device to the BIO_MAX_VECS << PAGE_SHIFT limit. As this
> limit also caps the device max_zone_append_sectors limit, this forces the
> caller to issue zone append operations smaller or equal than this limit,
> thus moving the splitting of large append operations to the caller
> instead of the incorrect internal splitting.
> 
> This change does not have any effect on the size of BIOs received by
> dm-crypt since the block layer does not automatically splits BIOs for
> BIO-based devices. So there is no impact on the performance of regular
> read and write operations.
> 
> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
> Cc: stable@vger.kernel.org
> Reported-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-crypt.c |   24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> Index: linux-dm/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-dm.orig/drivers/md/dm-crypt.c
> +++ linux-dm/drivers/md/dm-crypt.c
> @@ -3496,9 +3496,15 @@ static int crypt_map(struct dm_target *t
>  	/*
>  	 * Check if bio is too large, split as needed.
>  	 */
> -	max_sectors = get_max_request_size(cc, bio_data_dir(bio) == WRITE);
> -	if (unlikely(bio_sectors(bio) > max_sectors))
> -		dm_accept_partial_bio(bio, max_sectors);
> +	if (unlikely(bio_flagged(bio, BIO_EMULATES_ZONE_APPEND))) {
> +		max_sectors = BIO_MAX_VECS << PAGE_SHIFT >> SECTOR_SHIFT;
> +		if (unlikely(bio_sectors(bio) > max_sectors))
> +			return DM_MAPIO_KILL;
> +	} else {
> +		max_sectors = get_max_request_size(cc, bio_data_dir(bio) == WRITE);
> +		if (unlikely(bio_sectors(bio) > max_sectors))
> +			dm_accept_partial_bio(bio, max_sectors);
> +	}

Thanks.

I think we can simplify all this by passing the bio to get_max_request_size()
and move the bio_flagged() test there.

I will correct this and send patches tomorrow. This patch is now in fact more
than just for zone append. It must also operate on regular write as otherwise we
can endup deadlocking with queue freeze operations. There is another patch
needed to go with this, to force a call to bio split to limit for any write to a
zoned DM device in dm.c, before passing the BIO to the target driver.
So all of this needs some more massaging. Sending stuff tomorrow after testing.

>  
>  	/*
>  	 * Ensure that bio is a multiple of internal sector encryption size
> @@ -3733,6 +3739,18 @@ static void crypt_io_hints(struct dm_tar
>  		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
>  	limits->dma_alignment = limits->logical_block_size - 1;
> +
> +	/*
> +	 * For zoned devices, we cannot split write operations used to emulate
> +	 * zone append operations. And since all write requests must be split on
> +	 * BIO_MAX_VECS << PAGE_SHIFT size, apply this limit to the maximum
> +	 * hardware I/O size so that we have a cap on the
> +	 * max_zone_append_sectors limit when the zone limits are validated by
> +	 * the block layer.
> +	 */
> +	if (ti->emulate_zone_append)
> +		limits->max_hw_sectors = min(limits->max_hw_sectors,
> +				BIO_MAX_VECS << PAGE_SHIFT >> SECTOR_SHIFT);
>  }
>  
>  static struct target_type crypt_target = {
> 


-- 
Damien Le Moal
Western Digital Research
