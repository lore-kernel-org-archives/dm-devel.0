Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701020;
	b=Kcw2xBENjKg8BQtlK7E1HyVP8+Y4rZHRuKDJmR/kWmphUsdc2u5gP0sX/gq3FKHpZVLj
	 V3DJlhhW3A4gkZEEPmXlRcNtmRKnVbWimWxJCORlhy5rKjO0U6lEkC6Fo19Uq1wHisO/Q
	 e1xODo4dHVN90U5/C577AWJSVT7/0VFPCHjEREU+NqbMm7tAf9V3VG/gZyrHFBo8he7Oi
	 BErqJOp31NN5QBr/cfBPhexECMphVV3UUp4YNqbaNP7fvBbSu63fCPS2lY7/jykh8+75S
	 C8/fl4jMHmYz4WewoKkshhzAVt3nW3d+aZqjk522gQwdx243K2AhOykVvlhgGSEoLWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701020;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=rRLij3XTVGso9Uz44bcLDss/GOkyK6j16uFo3GBaQE4=;
	b=A5EUencz9ZpeqhltnTfqeeSKVcP9DbOWBR3/AYGaqrhOIKzAXJtUGHgp1AwGB4AUqC8r
	 FLpq3kOGPm16C+HgXnOtmTQ5qFGtK5kok+1BsQjjMfC95iYH8PrdogZw8Saz1j2h0eyeN
	 A1oax5Oqq7qJ0dpzBjxW3N3OwzVlaBaYIKcwdkGPSzWuKFyx0YQ+zEHq+zF/1Luozi0ff
	 Nw7NjAwfKL6XNerZIsJ9J+uI8+vk2CDdnw12/ArlVM3AC7q05G7ZuSq7iga92F6Dk4VQ6
	 QEicqETb45FCYjdn3J7lechPYQXKykQwhJNeS6RqVTQTrpHuxDCEzw6+su+GNiawzGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZoAMAXYZ;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179D1606A324;
	Tue,  3 Nov 2026 10:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 179D1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZoAMAXYZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rRLij3XTVGso9Uz44bcLDss/GOkyK6j16uFo3GBaQE4=; b=ZoAMAXYZrR1rxiM3Ntu+4+j9Mp
	SDUCqT/XSjYcoRGB0hnkrzDMhhkQD/FQur5SjpvV7goEusFaQAXLapmngYItkX9DgNNFzJdzB1ssV
	CoUNzFXiGSwN4AWb1QC49oJE+B4X3W7u4IakXtCXszbyMTb/mdYIFFijsBbO0ypNmpagQMMi15h4L
	BxUm4keCC9d2GzS7m1oo6sl6R/YqO6R7Br5Gp2PSG1/PvzcyTZwPIItYz+P1BKHS2yfVkp4YjfZc9
	zeItOGyo6kJqHoJdIWrjpbUwxKq2KLdgHmW7Z4EASEyUQfA9MwSHS8xz5Ofu2RmRX3aRKQokJbFkY
	/r8lJQ5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOBZb-00000001wsV-2TAD;
	Tue, 03 Nov 2026 10:16:59 +0000
Date: Tue, 3 Nov 2026 02:16:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	mtsai@redhat.com, colyli@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH] block: fix discard alignment for non-power-of-two
 granularities
Message-ID: <aum0m6cC98UhzHOB@infradead.org>
References: <20261026000511.73371-1-dennylin0707@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026000511.73371-1-dennylin0707@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 26, 2026 at 12:05:11AM +0000, Hungyu Lin wrote:
> bio_discard_limit() uses round_up() and round_down(), which require a
> power-of-two alignment. However, discard_granularity need not be a power
> of two. For example, dm-thin supports data block sizes that are arbitrary
> multiples of 64 KiB and advertises the block size as its granularity.
> 
> With a 192 KiB granularity, discarding one complete block at offset
> 384 KiB is split into 128 KiB and 64 KiB bios. Neither covers a complete
> thin block, so dm-thin ignores both and the mapping remains allocated.
> 
> Use sector_div() to find the distance to the next granularity boundary,
> and rounddown() to align the maximum bio size. This handles non-power-of-
> two granularities while preserving the alignment for power-of-two ones.
> 
> Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
> Reported-by: Ming-Hung Tsai <mtsai@redhat.com>
> Link: https://lore.kernel.org/r/CALjSBEvjbiGDVewuapWKhGDtaxZwcn4=22raUiBEOyj22rY7-g@mail.gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  block/blk-lib.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 688bc67cbf73..e0de5bb4d969 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -13,26 +13,25 @@
>  static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
>  {
>  	unsigned int discard_granularity = bdev_discard_granularity(bdev);
> -	sector_t granularity_aligned_sector;
> +	unsigned int remainder;
>  
>  	if (bdev_is_partition(bdev))
>  		sector += bdev->bd_start_sect;
>  
> -	granularity_aligned_sector =
> -		round_up(sector, discard_granularity >> SECTOR_SHIFT);
> +	remainder = sector_div(sector, discard_granularity >> SECTOR_SHIFT);

Please avoid using do_div (or the obsolete sector_div wrapper around) it
becaus it modifies the first parameter in a sneaky and dangerous way.

>  
>  	/*
>  	 * Make sure subsequent bios start aligned to the discard granularity if
>  	 * it needs to be split.
>  	 */
> -	if (granularity_aligned_sector != sector)
> -		return granularity_aligned_sector - sector;
> +	if (remainder)
> +		return (discard_granularity >> SECTOR_SHIFT) - remainder;

Also this is actually suboptimal, we can just remove the remainder from
the full size.  Something like the untested patch below:

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 688bc67cbf73..6c45f15c41a2 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -13,26 +13,22 @@
 static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 {
 	unsigned int discard_granularity = bdev_discard_granularity(bdev);
-	sector_t granularity_aligned_sector;
+	u32 unaligned_sectors;
 
 	if (bdev_is_partition(bdev))
 		sector += bdev->bd_start_sect;
 
-	granularity_aligned_sector =
-		round_up(sector, discard_granularity >> SECTOR_SHIFT);
-
-	/*
-	 * Make sure subsequent bios start aligned to the discard granularity if
-	 * it needs to be split.
-	 */
-	if (granularity_aligned_sector != sector)
-		return granularity_aligned_sector - sector;
-
 	/*
-	 * Align the bio size to the discard granularity to make splitting the bio
-	 * at discard granularity boundaries easier in the driver if needed.
+	 * Align the bio size to the discard granularity to make splitting the
+	 * bio at discard granularity boundaries easier in the driver if needed.
+	 *
+	 * If the current sector is not aligned, shorten the range so that the
+	 * net one is aligned.
 	 */
-	return round_down(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
+	div_u64_rem(sector, discard_granularity >> SECTOR_SHIFT,
+			&unaligned_sectors);
+	return (rounddown(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT) -
+		unaligned_sectors;
 }
 
 struct bio *blk_alloc_discard_bio(struct block_device *bdev,
