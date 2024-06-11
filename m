Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF916B759;
	Tue, 11 Jun 2024 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073087; cv=none; b=N0gSbJSBNPtmVt7Hf3Z+TWKl2yn9EXC7t5b0L5a8lZyg/qPgULS/IWZBOs4rDY0x+rAqk2mZYGTPyCX43NvuG0ERxSLsPc9e9H8pE5V592WSfoJkei9MkkCkIlWoKpTdfwYN1XaSsNs1K7knoCHtOVMDbK9Ob4O/+Phu3AJp0JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073087; c=relaxed/simple;
	bh=LZn6Zk4n8nKuOHEtIM6M8776IVYNFYgBUeTnFH1X1dM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LvcNwZqUk/yrpvfaPy8D1LTKqsNsunV0mdmH25TjBr8eeUBzqGHwa4025TAXGZRVFYmhUNMnm494CPVtuqE7RNTdGvK+aa8Km1vaIPeytq8OV92r4DU2QVZF1dhflJMn33vQ7wB8YbLPAKidOql6xDdJRjry9I1DNHFlDJF/TeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xf8d5x15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xf8d5x15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D62C2BBFC;
	Tue, 11 Jun 2024 02:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718073087;
	bh=LZn6Zk4n8nKuOHEtIM6M8776IVYNFYgBUeTnFH1X1dM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Xf8d5x15Gn6pdqgpfM4TooO1jfyu0T/v7lRI0PCRKETcVYgGNC1LTJbbxKH1dykdQ
	 q7u1NtKlPUgYnLPuLfOIfbEmLMlrsNmFVh1INXM+4gnmLdetji01dUOw11OHwDfGhV
	 Yxd1uc3IT6vJ72H25L3pBWv+iBzltyLqMUmA2YPGgTWywmlFWFrHJPRWW0Bm3Tv1Yd
	 cLDvCDLUwk2aGgcX6uIXO/Wulol6VUX1/HrXLra9tc8BocsLpba0BMlGfVSCMGXBVt
	 nGOKtKFUSqKU8K4ET6D4p2Cj5FKE+V1jFKtL8aTzqnLlYkQuSbNNZobugk0y9WsX/N
	 WPzGDJg8hIZng==
Message-ID: <4848b4c2-6792-42c9-89c7-792db924bd33@kernel.org>
Date: Tue, 11 Jun 2024 11:31:24 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/4] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
References: <20240610075655.249301-1-dlemoal@kernel.org>
 <20240610075655.249301-5-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240610075655.249301-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/24 4:56 PM, Damien Le Moal wrote:
> With the switch to using the zone append emulation of the block layer
> zone write plugging, the macro DM_ZONE_INVALID_WP_OFST is no longer used
> in dm-zone.c. Remove its definition.
> 
> Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Reviewed-by: Niklas Cassel <cassel@kernel.org>
> ---
>  drivers/md/dm-zone.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index d9f8b7c0957a..70719bf32a2e 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -13,8 +13,6 @@
>  
>  #define DM_MSG_PREFIX "zone"
>  
> -#define DM_ZONE_INVALID_WP_OFST		UINT_MAX
> -
>  /*
>   * For internal zone reports bypassing the top BIO submission path.
>   */
> @@ -285,8 +283,6 @@ static int device_get_zone_resource_limits(struct dm_target *ti,
>  		return ret;
>  	}
>  
> -	zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;
> -
>  	/*
>  	 * If the target does not map any sequential zones, then we do not need
>  	 * any zone resource limits.
> @@ -317,6 +313,13 @@ static int device_get_zone_resource_limits(struct dm_target *ti,
>  	zlim->lim->max_open_zones =
>  		min_not_zero(max_open_zones, zlim->lim->max_open_zones);
>  
> +	/*
> +	 * Also count the total number of sequential zones for the mapped
> +	 * device so that when we are done inspecting all its targets, we are
> +	 * able to check if the mapped device actually has any sequential zones.
> +	 */
> +	zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;
> +

Jens,

I messed up the rebase for v7: this hunk belongs to patch 3.
So I will resend a V8. My apologies for the churn.

>  	return 0;
>  }
>  

-- 
Damien Le Moal
Western Digital Research

