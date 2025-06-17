Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76954296153
	for <dm-devel@lists.linux.dev>; Tue, 17 Jun 2025 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201213; cv=none; b=bHtXesKeduegytgVTVlwxxjrjrvzeMlhvchBiaZLCzGzOLfyVPoyeerP8QkMpadnGeYJroPxU/8tjdFh98Um1sLVz19oHNZY1aMJVRWScfjpc4NJOH34pL6VYVTombCk5UuNO10hTfBCFwKjG9ZRdY0sOY8mwipte4xIaoiPAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201213; c=relaxed/simple;
	bh=UMHE3afR+fj3nR8iBoIDw9Fipi4dgmGshJbLsHFcpOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCCOUa/0+8Y6D76hIWcuRoDl4j2C4onzmlbNFfOh81oVxIC+4t7EeNNZgx82PXKoQmV29zT+G5aWK14IZYco5eyPg38VLJrxQRfDSOUxvlN8B1JYU7LHXVu4w6kxoycMXIIhjtZj+0FM6+fAko4b/OikOdgGq+gAHLKZSdouHqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QsZCb7LQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsZCb7LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2198C4CEE3;
	Tue, 17 Jun 2025 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750201213;
	bh=UMHE3afR+fj3nR8iBoIDw9Fipi4dgmGshJbLsHFcpOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QsZCb7LQQrdpzUJq7VirbKeEK46Vc1sLCj3VfGzCBdGP4DyNMFWLgwIms9MFJ4S6t
	 4xIiLWT2oq/SXYIMbeo0MDd7UTbSp+peuAEiVQkJJIi/jJfzXeK27KOCjT3hRFKCPu
	 TzGks0Hu6OfTHe5PAx5lIvfkc5rErvZAXGqMeDypeTOoXEKg42o7gNB76qG8EjydO0
	 f5yAwWQmugpUQImTuh+ME1MEbWRBOLAJk1lEkeDl8tuG/ynsXkQhrRiDNMqOoxdYOt
	 dNTn0DzM3/c1A3P0C2IoH4gwX0COjzrvDW7AYiP0LV4UyS/16ZykA4uvIjCdyfjf9c
	 //Rzj4AjuhHaA==
Date: Tue, 17 Jun 2025 19:00:11 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: dm-table: fix checking for rq stackable devices
Message-ID: <aFHze2MNk1LU1_13@kernel.org>
References: <20250613230852.2838268-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613230852.2838268-1-bmarzins@redhat.com>

On Fri, Jun 13, 2025 at 07:08:52PM -0400, Benjamin Marzinski wrote:
> Due to the semantics of iterate_devices(), the current code allows a
> request-based dm table as long as it includes one request-stackable
> device. It is supposed to only allow tables where there are no
> non-request-stackable devices.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Amazing this type of bug is still lurking, thought I audited all of
the iterate_devices callout functions.. anyway, thanks for fixing it!

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

> ---
>  drivers/md/dm-table.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 9f95f77687ef..d91207b2d77f 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -898,17 +898,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
>  	return true;
>  }
>  
> -static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
> -				  sector_t start, sector_t len, void *data)
> +static int device_is_not_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
> +				      sector_t start, sector_t len, void *data)
>  {
>  	struct block_device *bdev = dev->bdev;
>  	struct request_queue *q = bdev_get_queue(bdev);
>  
>  	/* request-based cannot stack on partitions! */
>  	if (bdev_is_partition(bdev))
> -		return false;
> +		return true;
>  
> -	return queue_is_mq(q);
> +	return !queue_is_mq(q);
>  }
>  
>  static int dm_table_determine_type(struct dm_table *t)
> @@ -1004,7 +1004,7 @@ static int dm_table_determine_type(struct dm_table *t)
>  
>  	/* Non-request-stackable devices can't be used for request-based dm */
>  	if (!ti->type->iterate_devices ||
> -	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
> +	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
>  		DMERR("table load rejected: including non-request-stackable devices");
>  		return -EINVAL;
>  	}
> -- 
> 2.48.1
> 
> 
