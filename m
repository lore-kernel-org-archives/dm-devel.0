Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064C0219FC;
	Thu, 30 May 2024 07:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717054645; cv=none; b=ljf/tZU1SDH+4hElO+De7hPDSW8Fvl7/ArO8qnZwZfdwtRPJkve5/WW+FNexMEmz1jfyAedddc1K5UK2vdTqVjhb0a+WiFKNLVB7qzNenz5bE3qjHdMb6cXQuDtvAmFYxOiaGGaT9jcMdEFp8fU9nRbMrZMGPAuu4gHI3jFqCIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717054645; c=relaxed/simple;
	bh=NFvkV7tZcUeqsci++YDCnYl/HcT68fx58n8kJz28bCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+fhmC5C8d+3OsWHP9JrkpnpFYosC/tr5T+gTGfqd1gui+EtkcaSKZ/M2IdyYG9Iv0kaqA16ufgOHbP0CfiH7tcYBGMpC70olPfS2QB9RkXngz4Pb4mWq4VjahxQQ+fzvCgYCcJTqUoezmKrDQMWoY7TNdKJisSPd/mkBmbPZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMy8VN84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMy8VN84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663E3C2BBFC;
	Thu, 30 May 2024 07:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717054644;
	bh=NFvkV7tZcUeqsci++YDCnYl/HcT68fx58n8kJz28bCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PMy8VN84U9a35ZUsasqXZQ5lQlZtl/0qmHZY7PN/HTQo2LAIDJ8GIydBU7O6X3lDQ
	 09NjCAyRmYn2CAhdoBJDVYYHpLOyhHNDojuj13szsbXhOaWIvj/ARdddmgO6huY1eN
	 2mQTZl8dmbvCxXc/ZDWVcnIZAi5vMc+SBwnpCjzQu8SrDk4BHTwa5zyfGIQachYbbI
	 I69KUoIqIKkVWIPW7CaGPtNS1oUlT7TglIggBPInf9eEP66LFOXWU3oE/Say2pYB6s
	 WYVCqA1AbvqwuLRokQXBRonJm5Gi8LfkdY6Yu87evZgWzNkyp1vFOUecFumRnj4jrB
	 llc3Jm29FfIlw==
Date: Thu, 30 May 2024 09:37:20 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/4] null_blk: Do not allow runt zone with zone capacity
 smaller then zone size
Message-ID: <ZlgssCJl9HwjYhzJ@ryzen.lan>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-2-dlemoal@kernel.org>

On Thu, May 30, 2024 at 02:40:32PM +0900, Damien Le Moal wrote:
> A zoned device with a smaller last zone together with a zone capacity
> smaller than the zone size does make any sense as that does not
> correspond to any possible setup for a real device:
> 1) For ZNS and zoned UFS devices, all zones are always the same size.
> 2) For SMR HDDs, all zones always have the same capacity.
> In other words, if we have a smaller last runt zone, then this zone
> capacity should always be equal to the zone size.
> 
> Add a check in null_init_zoned_dev() to prevent a configuration to have
> both a smaller zone size and a zone capacity smaller than the zone size.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/block/null_blk/zoned.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 79c8e5e99f7f..f118d304f310 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -74,6 +74,17 @@ int null_init_zoned_dev(struct nullb_device *dev,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * If a smaller zone capacity was requested, do not allow a smaller last
> +	 * zone at the same time as such zone configuration does not correspond
> +	 * to any real zoned device.
> +	 */
> +	if (dev->zone_capacity != dev->zone_size &&
> +	    dev->size & (dev->zone_size - 1)) {
> +		pr_err("A smaller last zone is not allowed with zone capacity smaller than zone size.\n");
> +		return -EINVAL;
> +	}
> +
>  	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
>  	dev_capacity_sects = mb_to_sects(dev->size);
>  	dev->zone_size_sects = mb_to_sects(dev->zone_size);
> -- 
> 2.45.1
> 

Reviewed-by: Niklas Cassel <cassel@kernel.org>
