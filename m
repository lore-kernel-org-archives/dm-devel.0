Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD86335957;
	Thu, 17 Jul 2025 08:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752740299; cv=none; b=btjVhGWqFFwZ7xR4imOqk/V5eFTNoo2V9PeDRcO/9XsAyQSUQ1qlzsVtpO3OXRHeXMI0wYqLK8189SceTYtL7GbRP71/O/uMmujl5EUs6x0PBIVqfYM0GAewMFXAvY28VNuiMBhvUy1b/Vr/RACXQ3g3UQYmQRS50krvSzvVy3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752740299; c=relaxed/simple;
	bh=Pcu1txU/YjqR1FQHCcnzNBX23O5aqYuwqewelpZEQsw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FY1FavRwhw29che+aGYU2s1krYm0SvT6i2Fw54/tywOiH+xM59r3Q8wT6e6p6DDgb0wQsKWV1izlujEUrDwUwGIuFQxerWcZpYej3N/HSJbBRoQbs91rdd4MygKCrqnLuBEaTEMVJIVkv7eR0zWVqOOI3Cr7DYP7itjcKDyze5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbGzIexL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbGzIexL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5950DC4CEED;
	Thu, 17 Jul 2025 08:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752740298;
	bh=Pcu1txU/YjqR1FQHCcnzNBX23O5aqYuwqewelpZEQsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AbGzIexLrt55g+X1/m1YiNnqqdvDpec0l9oquF1/q61pGFhLzN8cAIHvdRDFGvI9+
	 QvtIDjRrlC6kyTKAkRDOlvPI7P7SoXETnyxbiY+h5U2NryRFHvkOGKI78Do6juIzQg
	 qKW6I/ETjsdYyDiQxR7fPLsuTUs4dH++7jWTRcxBK7x3q46hg/0J4wBgbcqomOWEGM
	 OUK7vYnGEC5PvuELrw7deRp7JRxQiL54VM3QYuwOHbxztUOdSC7NevyDOXd/UjPAbR
	 s1VXFpuH6jO3NEgzsCY4AdofxucwyYIhJv+eRkDhSqE1hjkF0gDv3O4nfSUwSkJrhl
	 QKfsAFSmc2t3w==
Message-ID: <9ac957aa-682a-4997-8578-068444a4b778@kernel.org>
Date: Thu, 17 Jul 2025 17:18:16 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] dm: split write BIOs on zone boundaries when
 zone append is not emulated
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20250717023255.15111-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250717023255.15111-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/07/17 11:32, Shin'ichiro Kawasaki wrote:
> Since commit f70291411ba2 ("block: Introduce
> bio_needs_zone_write_plugging()"), blk_mq_submit_bio() no longer splits
> write BIOs to comply with the requirements of zoned block devices. This
> change applies to write BIOs issued by zoned DM targets. Following this
> modification, it is expected that DM targets themselves split write BIOs
> for zoned block devices.

This description is confusing: if the underlying device of a DM target is a
blk-mq block device, then blk_mq_submit_bio() will be called and will split BIOs
as needed, regardless of what the DM target did. For BIOs that are issued by the
user/FS to the DM device, then that is when bio_needs_zone_write_plugging() is
used by DM core to determine if a BIO must be split.

Anyway, I do not think you need to reference this commit. So I would drop this
entire paragraph from the commit message, and start the explanation with the
below paragraph. That is very clear I think.

> Commit 2df7168717b7 ("dm: Always split write BIOs to zoned device
> limits") updates the device-mapper driver to perform splits for the
> write BIOs. However, it did not address the cases where DM targets do
> not emulate zone append, such as in the cases of dm-linear or dm-flakey.
> For these targets, when the write BIOs span across zone boundaries, they
> trigger WARN_ON_ONCE(bio_straddles_zones(bio)) in
> blk_zone_wplug_handle_write(). This results in I/O errors. The errors
> are reproduced by running blktests test case zbd/004 using zoned
> dm-linear or dm-flakey devices.
> 
> To avoid the I/O errors, handle the write BIOs regardless whether DM
> targets emulate zone append or not, so that all write BIOs are split at
> zone boundaries. For that purpose, drop the check for zone append
> emulation in dm_zone_bio_needs_split(). Its argument 'md' is no longer
> used then drop it also.
> 
> Fixes: 2df7168717b7 ("dm: Always split write BIOs to zoned device limits")
> Cc: stable@vger.kernel.org

The above patch is queued in block-next, so there is no need for this CC-stable.
Remove it please.

> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

One more nit below.

With these fixed, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  drivers/md/dm.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ca889328fdfe..a64809f04241 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1785,8 +1785,7 @@ static void init_clone_info(struct clone_info *ci, struct dm_io *io,
>  }
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
> -static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
> -					   struct bio *bio)
> +static inline bool dm_zone_bio_needs_split(struct bio *bio)
>  {
>  	/*
>  	 * Special case the zone operations that cannot or should not be split.
> @@ -1802,13 +1801,10 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
>  	}
>  
>  	/*
> -	 * Mapped devices that require zone append emulation will use the block
> -	 * layer zone write plugging. In such case, we must split any large BIO
> -	 * to the mapped device limits to avoid potential deadlocks with queue
> -	 * freeze operations.
> +	 * When mapped devices use the block layer zone write plugging, we must
> +	 * split any large BIO to the mapped device limits to avoid potential
> +	 * deadlocks with queue freeze operations.

Nit:
	 * split any large BIO to the mapped device limits to not submit BIOs
	 * that span zone boundaries and to avoid potential deadlocks with
	 * queue freeze operations.


>  	 */
> -	if (!dm_emulate_zone_append(md))
> -		return false;
>  	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
>  }
>  
> @@ -1932,8 +1928,7 @@ static blk_status_t __send_zone_reset_all(struct clone_info *ci)
>  }
>  
>  #else
> -static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
> -					   struct bio *bio)
> +static inline bool dm_zone_bio_needs_split(struct bio *bio)
>  {
>  	return false;
>  }
> @@ -1960,7 +1955,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  
>  	is_abnormal = is_abnormal_io(bio);
>  	if (static_branch_unlikely(&zoned_enabled)) {
> -		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
> +		need_split = is_abnormal || dm_zone_bio_needs_split(bio);
>  	} else {
>  		need_split = is_abnormal;
>  	}


-- 
Damien Le Moal
Western Digital Research
