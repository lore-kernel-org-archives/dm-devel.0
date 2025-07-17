Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A27029B228
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 10:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752749567; cv=none; b=BW0fCO4oj1mxgldo9YJTeS+S3alU+ZyP0tGkNaDKPZr9RXJvJgcbbuaO7h1k1rYBbxjf6Xnpi0aJWwKI+ern/0WH9/PNoH/W+UGHbw48hSNXgRg29fxetnR/EiBfgRE+KuvdJRoo3F6wWFUnZw0XKwZPUCy5V+udZ5MnaLU7baM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752749567; c=relaxed/simple;
	bh=Yjrduz0zHZnXsjD1NCSlvcO896Gr7Ip/3vFBC5vN66M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=H4THDWJ3JqtmXxxepQb2UpvYSbMuLrEBzg2skouXKjlH5oW5Ytd6wlmYurPdRUwPdhpUFWjIKmoC3Y+DBvRd3OOr6wcyIBA3zMJIfnXeCkG7AJGGm1KBMZbaxMX13EKccMG9wjPJdCVxmE8On3OSAvax+U/vwh46fSoSyJmhYtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RvMDB73Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RvMDB73Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752749564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ky4QUOopsMW3nX5KHpu6kPgcddWT/xNbScFkjjv2xpE=;
	b=RvMDB73ZGcGjIrPJQ66Hcsuij5x6r4d5cQ78LXAKESDInJrES81GQZYop+9ziWzp8wBzr6
	vdyumxUkGT97ErlXmDv6lhjY57Pl2jrk1D6EinurHF3iXgkYkeqxGv6NPt5XUdumyjjXpC
	U/Yq7deUkmnlJLJgPjCQgp/iSMYdMWM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-hK2DZC_KPoyfLLNxXspa8g-1; Thu,
 17 Jul 2025 06:52:41 -0400
X-MC-Unique: hK2DZC_KPoyfLLNxXspa8g-1
X-Mimecast-MFC-AGG-ID: hK2DZC_KPoyfLLNxXspa8g_1752749560
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71D9E1800282;
	Thu, 17 Jul 2025 10:52:39 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32624196664F;
	Thu, 17 Jul 2025 10:52:36 +0000 (UTC)
Date: Thu, 17 Jul 2025 12:52:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
    Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH for-next v2] dm: split write BIOs on zone boundaries when
 zone append is not emulated
In-Reply-To: <20250717103539.37279-1-shinichiro.kawasaki@wdc.com>
Message-ID: <1c653ea9-2cb0-8d81-0940-b9bfb9940545@redhat.com>
References: <20250717103539.37279-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Thu, 17 Jul 2025, Shin'ichiro Kawasaki wrote:

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
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
> * Changes from v1:
> - Dropped the first paragraph of the commit message
> - Improved the block comment
> 
>  drivers/md/dm.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index ca889328fdfe..abfe0392b5a4 100644
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
> @@ -1802,13 +1801,11 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
>  	}
>  
>  	/*
> -	 * Mapped devices that require zone append emulation will use the block
> -	 * layer zone write plugging. In such case, we must split any large BIO
> -	 * to the mapped device limits to avoid potential deadlocks with queue
> -	 * freeze operations.
> +	 * When mapped devices use the block layer zone write plugging, we must
> +	 * split any large BIO to the mapped device limits to not submit BIOs
> +	 * that span zone boundaries and to avoid potential deadlocks with
> +	 * queue freeze operations.
>  	 */
> -	if (!dm_emulate_zone_append(md))
> -		return false;
>  	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
>  }
>  
> @@ -1932,8 +1929,7 @@ static blk_status_t __send_zone_reset_all(struct clone_info *ci)
>  }
>  
>  #else
> -static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
> -					   struct bio *bio)
> +static inline bool dm_zone_bio_needs_split(struct bio *bio)
>  {
>  	return false;
>  }
> @@ -1960,7 +1956,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  
>  	is_abnormal = is_abnormal_io(bio);
>  	if (static_branch_unlikely(&zoned_enabled)) {
> -		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
> +		need_split = is_abnormal || dm_zone_bio_needs_split(bio);
>  	} else {
>  		need_split = is_abnormal;
>  	}
> -- 
> 2.50.1
> 

