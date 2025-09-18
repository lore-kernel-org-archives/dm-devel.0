Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB7305E28;
	Thu, 18 Sep 2025 20:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758227238; cv=none; b=BiMs8yVVE6l48HyE7zXITUIseTCFGFOqNLWmDUND3Hqp0pkwx+pYLZKHj4e8AJU2LNtcB8sp7BsmHXJ39HYj8XMpZX2jWVgZ5U1nukqOEXYYmsvzVmAbZaWncxJO4xZWKvr6R0zMZr5wlIcDsqGq4FgMpcdy0t0mCSbCoZaVLAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758227238; c=relaxed/simple;
	bh=OIqJ4QIxT7pMGNPe/P8tgCFOyYinRvK0QJlGdIZV03s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBRDz/ZEnp1FvMLp+BhYYVB6GHS4ZrSmRh6KP4/uD3V1Cd/nxMtzWkgNIpXMoRiXoVhWf9hL5s4/KU0Ic22zgcQnkyMcWNWpnWs6zsoUpsD3AvFlGe5rvx4e9+oMPvqAyko0vS2HKFBuNbzaZE2zWBMGUUYj0TAM6vvPSzMuMkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmlRDS6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmlRDS6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D692C4CEE7;
	Thu, 18 Sep 2025 20:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758227235;
	bh=OIqJ4QIxT7pMGNPe/P8tgCFOyYinRvK0QJlGdIZV03s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BmlRDS6hXPyzChZ1Sca+ZAKw8+Hb6i8w25rbpnd+pekkbVrnJEI7Pe+qGCm+0Skwr
	 brUJ4jajbOHHw2nXDALtJi/M7jY2waIrk2tYYgxr4FmaAXfJGU4cpVHu/MbhUsEB9x
	 O9zl6vXudXgRWaLHeGlczTcXHONLdShKHNaD5eTtvh7dKRB+1Ce7VCah5V/eAVkCXb
	 ANS2SFo5vQsgCtR5ow/GUNGU2r6HBRI9udJKYcJPjBcUT4rFY7LTorUzaIpVrO5ezQ
	 W2eyx9meJxb9krJ9eSS8kVqyXWPwm+5GArnWZg884omCZTMJD+M8U4aGSwbHrnbs4n
	 +KLKJoa1hKRqg==
Date: Thu, 18 Sep 2025 16:27:14 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	mpatocka@redhat.com, ebiggers@google.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <aMxrIjcFqaT2WztN@kernel.org>
References: <20250918161642.2867886-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918161642.2867886-1-kbusch@meta.com>

On Thu, Sep 18, 2025 at 09:16:42AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Most storage devices can handle DMA for data that is not aligned to the
> sector block size. The block and filesystem layers have introduced
> updates to allow that kind of memory alignment flexibility when
> possible.

I'd love to understand what changes in filesystems you're referring
to.  Because I know for certain that DIO with memory that isn't
'dma_alignment' aligned fails with certainty ontop of XFS.

Pretty certain it balks at DIO that isn't logical_block_size aligned
ondisk too.

> dm-crypt, however, currently constrains itself to aligned memory because
> it sends a single scatterlist element for the input ot the encrypt and
> decrypt algorithms. This forces applications that have unaligned data to
> copy through a bounce buffer, increasing CPU and memory utilization.

Even this notion that an application is somehow able to (unwittingly)
lean on "unaligned data to copy through a bounce buffer" -- has me
asking: where does Keith get these wonderful toys?

Anyway, just asking these things because if they were true I wouldn't
be needing to add specialized code to NFSD and NFS to handle
misaligned DIO.

> It appears to be a pretty straight forward thing to modify for skcipher
> since there are 3 unused scatterlist elements immediately available. In
> practice, that should be enough as the sector granularity of data
> generally doesn't straddle more than one page, if at all.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/md/dm-crypt.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 5ef43231fe77f..f860716b7a5c1 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1429,18 +1429,14 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
>  					struct skcipher_request *req,
>  					unsigned int tag_offset)
>  {
> -	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
>  	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
> +	unsigned int bytes = cc->sector_size;
>  	struct scatterlist *sg_in, *sg_out;
>  	struct dm_crypt_request *dmreq;
>  	u8 *iv, *org_iv, *tag_iv;
>  	__le64 *sector;
>  	int r = 0;
>  
> -	/* Reject unexpected unaligned bio. */
> -	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
> -		return -EIO;
> -
>  	dmreq = dmreq_of_req(cc, req);
>  	dmreq->iv_sector = ctx->cc_sector;
>  	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
> @@ -1457,11 +1453,24 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
>  	*sector = cpu_to_le64(ctx->cc_sector - cc->iv_offset);
>  
>  	/* For skcipher we use only the first sg item */
> -	sg_in  = &dmreq->sg_in[0];
>  	sg_out = &dmreq->sg_out[0];
>  
> -	sg_init_table(sg_in, 1);
> -	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
> +	do {
> +		struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
> +		int len = min(bytes, bv_in.bv_len);
> +
> +		if (r >= ARRAY_SIZE(dmreq->sg_in))
> +			return -EINVAL;
> +
> +		sg_in = &dmreq->sg_in[r++];
> +		memset(sg_in, 0, sizeof(*sg_in));
> +		sg_set_page(sg_in, bv_in.bv_page, len, bv_in.bv_offset);
> +		bio_advance_iter_single(ctx->bio_in, &ctx->iter_in, len);
> +		bytes -= len;
> +	} while (bytes);
> +
> +	sg_mark_end(sg_in);
> +	sg_in = dmreq->sg_in[0];
>  
>  	sg_init_table(sg_out, 1);
>  	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
> @@ -1495,7 +1504,6 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
>  	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
>  		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
>  
> -	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
>  	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
>  
>  	return r;
> @@ -3750,7 +3758,8 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	limits->physical_block_size =
>  		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
> -	limits->dma_alignment = limits->logical_block_size - 1;
> +	if (crypt_integrity_aead(cc))
> +		limits->dma_alignment = limits->logical_block_size - 1;
>  
>  	/*
>  	 * For zoned dm-crypt targets, there will be no internal splitting of
> -- 
> 2.47.3
> 
> 
