Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5581288C00
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 13:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894510; cv=none; b=WQDr9sraMdzhjzNOvn+/GpAxR0OpBpB8pn88/eD+H3NmdmorrfXNwxykggJrfG4HtiPI24fGEIdTraNJ+3EiN24J3fhokLKmxQVDFvAsl5WvBHcN7hvX5/bxZWATwBwUT8LlYwM9q0WxJyFLthS2nhJtvget+w958LV6kxI7ztA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894510; c=relaxed/simple;
	bh=sHqT4gPX2MG0eD4gLAhP71hdx982ZM0dFkQzgKo8Ls8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Swxqz20kKDEpeDJpLWTJNSXfy4ATnIQrOy1Xnm7zU4qiAfcb/rNUQrMSMXpgMzZy9QdqYkbOnXK9kK6oJoYwbkxMGbAaZhgSNoMH3TOAm18ikap7uBFGOJzKS2xkhUdWUcX+qVTgv+Yjyt1NUI3i8r3CUqnkYhuQFJFicWnTYIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PoOw437I; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PoOw437I"
Message-ID: <862bc5bb-13fb-41bb-85c9-84411ad9dda3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751894505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHXXpXsUX90+irq5UnXG4C7GzzcKZZZjhjr9uFTK9yc=;
	b=PoOw437Ih6bNYyKih2+8UTmaWHrXePmc/9Wa3cBxrRPhRASheU3n6bigzYxGVsQdq16imw
	xuQlAuKS1SIgm1yfOUJMxHE6TQWDRTLd6k4lTChp3EysJcCuemVcktOIINzME/tl2QsgQm
	MH8Zf1JaTFU0fzl75XM9n5D7geDzvrM=
Date: Mon, 7 Jul 2025 21:21:37 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm-stripe: fix a possible integer overflow
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, John Garry <john.g.garry@oracle.com>
Cc: dm-devel@lists.linux.dev
References: <0f1d0d2d-8840-a256-d628-39e074f021c1@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <0f1d0d2d-8840-a256-d628-39e074f021c1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/7/2025 6:39 PM, Mikulas Patocka 写道:
> There's a possible integer overflow in stripe_io_hints if we have too
> large chunk size. Test if the overflow happened, and if it did, don't set
> limits->io_min and limits->io_opt;
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>   drivers/md/dm-stripe.c |   10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-stripe.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-stripe.c	2025-07-06 15:02:23.000000000 +0200
> +++ linux-2.6/drivers/md/dm-stripe.c	2025-07-07 12:32:49.000000000 +0200
> @@ -456,10 +456,14 @@ static void stripe_io_hints(struct dm_ta
>   			    struct queue_limits *limits)
>   {
>   	struct stripe_c *sc = ti->private;
> -	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
> +	unsigned int io_min = sc->chunk_size << SECTOR_SHIFT;
> +	unsigned int io_opt = io_min * sc->stripes;
>   
> -	limits->io_min = chunk_size;
> -	limits->io_opt = chunk_size * sc->stripes;
> +	if (io_min >> SECTOR_SHIFT == sc->chunk_size &&
> +	    io_opt / sc->stripes == io_min) {
> +		limits->io_min = io_min;
> +		limits->io_opt = io_opt;
> +	}


Hi Mikulas,

     What about using check_xxx_overflow() ? something like:


     if (check_shl_overflow(sc->chunk_size, SECTOR_SHIFT, &io_min))
         return;


     if (check_mul_overflow(io_min, sc->stripes, &io_opt))
         return;

     limits->io_min = io_min;
     limits->io_opt = io_opt;

>   }
>   
>   static struct target_type stripe_target = {
>
>
