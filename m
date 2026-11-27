Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.165
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791629;
	b=x3s3CsmKdEpU0dKtjnza28td20974prsutns8EB9OhLj6ev8pUauTgMNA8mJBJ/2B7O2
	 YoRNcp2XM597IF4vwfsIOU6zkNMTQsKlN5mHaGhf5PMaVxV9kf0/w5v/DHFKkJcyB5b6c
	 yXZy0xIZ9zwi6EYEXvAVKTYu7Xhk8FP/t0WNjvAegsJJ6IOL3bdup0nWYz5OZqAnu105w
	 HJ8x4YKiFTFqo1XAE1zw1Q8XXt5NwINoPxpJSUZDVV2SyZofzPhZAxXWXD7PsUg6bYck9
	 j4yowNjQJXsr2qbA4UQXUs2QZqm+UR1IuzIqgYawWXAcj6qf+S4MvgIMh3IOA+T32jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791629;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GthgD+rr8Ts23jACHfsBnyhBDzvrFr+XUGtZyIjqgMo=;
	b=vqSxpuYo5O+olAq/In3gmsid4EVuqj4nTyEIlyRPpg0TdmOsrRpkxV18CIwV9zfBFKDb
	 DpezypAGThYeKk07dsVt+I27HxfX9FUXUl0vR90CI4+AywqUoSPR/KlCbyKZGNfh9R0TJ
	 CSmTnvAApmB77Yk8ToadJkTtequUpEqkxksNEKQv/sYs+Ixn/ozB/miVC3gBfMkYqgeTs
	 fso61v5EjarWhL3FJbxx8G6qPg+rRT19M6Z/rfvEttqBqvTSFPuV/sx5hQVlEgFM39G5D
	 2Hz1A3LWvXmnNUPFV9V7dV44udSioCLYBh4/jgmOCwV+kHLQ7zaQFqany0qWrrPtvRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="aT+rCe/t";
	arc=none smtp.remote-ip=91.218.175.165
Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF56E606A33C
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 15:00:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF56E606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aT+rCe/t
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=p6CYSM6z+3P1wrsy7GHqsmhfWnUf8tlYrj8G63KyQcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795791627; v=1; x=1796396427;
 b=aT+rCe/t76obmEY6v5E10g/25YT99wpmuurAIWHrtjJ9pV60pePR+nDWWx1m60b3A4yeuyet
 6ByauYRstUuwrSIxx6SEzqJnB6qrhVFGl9wa/kjjTU4jZvupHCjdxhRiugZlDUbTVmgoIH1QtYw
 ORnRVk9eHAAm/ClSdC27UMOw=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta12.migadu.com with ESMTPS id 4656ad381e0b016b;
	Fri, 27 Nov 2026 15:00:25 +0000
X-Mizu-Trace-ID: 4656ad381e0b016b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	axboe@kernel.dk,
	hch@infradead.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	mtsai@redhat.com,
	stable@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH v4] block: fix discard alignment for non-power-of-two granularities
Date: Fri, 27 Nov 2026 07:00:21 -0800
Message-ID: <20261127150023.3570227-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261120101758.45513-1-dennylin0707@gmail.com>
References: 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 20 Nov 2026 10:17:58 +0000 Hungyu Lin <dennylin0707@gmail.com> wrote:

> bio_discard_limit() uses round_up() and round_down(), which require a
> power-of-two alignment. However, discard_granularity need not be a power
> of two. For example, dm-thin supports data block sizes that are arbitrary
> multiples of 64 KiB and advertises the block size as its granularity.
> 
> With a 192 KiB granularity, discarding one complete block at offset
> 384 KiB is split into 128 KiB and 64 KiB bios. Neither covers a complete
> thin block, so dm-thin ignores both and the mapping remains allocated.
> 
> Use div_u64_rem() to find the starting sector's remainder without
> modifying the sector. Round the maximum bio size down with rounddown()
> and subtract the remainder so that the next bio starts on a granularity
> boundary. This handles non-power-of-two granularities and avoids a small
> initial bio when a large discard starts at an unaligned sector.
> 
> When discard is unsupported or disabled, discard_granularity can be zero.
> Return BIO_MAX_SECTORS in that case so the existing bio submission checks
> can handle unsupported discard requests without dividing by zero.
> 
> Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
> Reported-by: Ming-Hung Tsai <mtsai@redhat.com>
> Link: https://lore.kernel.org/r/CALjSBEvjbiGDVewuapWKhGDtaxZwcn4=22raUiBEOyj22rY7-g@mail.gmail.com
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

This also fixes a 7.1 regression for us. Since commit 1029298da365
("nvme: set discard_granularity from NPDG/NPDA"), NVMe namespaces can
report a granularity well above the LBA size (128K on the drives we hit
this on). The old code then split every unaligned discard in two, even
when the range fits in one bio, so XFS online discard of unaligned 1 MiB
extents sent two DSM ranges per extent and about twice the DSM commands
after large unlinks. With this patch it is one range per extent again.

Tested-by: Usama Arif <usama.arif@linux.dev>

> ---
> Changes in v4:
> - Add Christoph Hellwig's Reviewed-by.
> 
> v3: https://lore.kernel.org/r/20261103185909.71843-1-dennylin0707@gmail.com
> 
> Changes in v3:
> - Use div_u64_rem() instead of sector_div(), as suggested by Christoph
>   Hellwig, so the input sector is not modified.
> - Subtract the starting-sector remainder from the rounded maximum size
>   instead of emitting a short initial bio, following Christoph's proposal.
> - Include <linux/math64.h> explicitly and retain v2's zero-granularity guard.
> 
> Changes in v2:
> - Handle zero discard_granularity before dividing. Leave unsupported
>   discard handling to the bio submission path.
> 
> v2: https://lore.kernel.org/r/20261026195131.46699-1-dennylin0707@gmail.com
> 
>  block/blk-lib.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 688bc67cbf7..e98aa483707 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -3,6 +3,7 @@
>   * Functions related to generic helpers functions
>   */
>  #include <linux/kernel.h>
> +#include <linux/math64.h>
>  #include <linux/module.h>
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
> @@ -13,26 +14,25 @@
>  static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
>  {
>  	unsigned int discard_granularity = bdev_discard_granularity(bdev);
> -	sector_t granularity_aligned_sector;
> +	u32 unaligned_sectors;
> +
> +	if (!discard_granularity)
> +		return BIO_MAX_SECTORS;
>  
>  	if (bdev_is_partition(bdev))
>  		sector += bdev->bd_start_sect;
>  
> -	granularity_aligned_sector =
> -		round_up(sector, discard_granularity >> SECTOR_SHIFT);
> -
> -	/*
> -	 * Make sure subsequent bios start aligned to the discard granularity if
> -	 * it needs to be split.
> -	 */
> -	if (granularity_aligned_sector != sector)
> -		return granularity_aligned_sector - sector;
> -
>  	/*
> -	 * Align the bio size to the discard granularity to make splitting the bio
> -	 * at discard granularity boundaries easier in the driver if needed.
> +	 * Align the bio size to the discard granularity to make splitting the
> +	 * bio at discard granularity boundaries easier in the driver if needed.
> +	 *
> +	 * If the current sector is not aligned, shorten the range so that the
> +	 * next one is aligned.
>  	 */
> -	return round_down(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
> +	div_u64_rem(sector, discard_granularity >> SECTOR_SHIFT,
> +		    &unaligned_sectors);
> +	return (rounddown(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT) -
> +		unaligned_sectors;
>  }
>  
>  struct bio *blk_alloc_discard_bio(struct block_device *bdev,
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.50.1 (Apple Git-155)
> 
> 
