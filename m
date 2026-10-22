Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688472;
	b=XD/dXsBYgK9Yv9eMd8SqKlSrCStXimmDZz/nyT+sptAFIWjRKBZSSr2z3bSTQOMUU0uE
	 rwunS7PwA02fGA81IuSx1pSUQENIrzgv3h93FvjMKdlIhlspu7wKgJzYMIeak5I2yo2Cf
	 DuzHu4moFmyRBZjnBJp9Mst7LZI30C1V7XmAgplcqTFQuY9E3h/jVLKld3uMeFzLjo8lD
	 6aqaJUOznYRlss/ziQKvBnVQVwAyhX7CFZ8c1mY1aKH0MDTZzBhpITf2X7ohOTGc+bQHR
	 SUk9EQHQ48CzcZ6BwvnXF5ySeXrucvjfL4y9Xhhl/Qh1SCyLOABuk3LFwR38YaVxD0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688472;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NBJ0aniVhrR8tDLjJgaeln00bRmLYZmDqTLDwkgAqcw=;
	b=sCt+6eFbBnXK6duh3doNRXgNDo0SUQVPOhRaa5cXh9AV9nS6Tn8q+q314nZjc8YjhSDB
	 AjedMnG2krQ6bErqOyAw2OJUUn6Q9sRj/2gLRRuMQn7kmrNwr1mRJbXqIU6PMgj20t/qM
	 ZFuj/myh1H1iEgT2AerJKOf/cBdz3t8SExt1xl9HsNv5mvAp9UJ/n+ffborMFxSQZ8ycK
	 Rdd73E989JkqBGeb5VwXHyW0okh34Yrl7mzS5VRwWHO17h/qjyfY9w7z4T57msIkuP/5p
	 khzdip0LsLn3I0o04Ohknd8TEVDnexo5lKUZ9wp0qlS69SNXrulPzhYE362Ay+ivoRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxDYY2yA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63583606A31A;
	Thu, 22 Oct 2026 17:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RxDYY2yA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD0D1F01825;
	Thu, 22 Oct 2026 17:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792688472;
	bh=NBJ0aniVhrR8tDLjJgaeln00bRmLYZmDqTLDwkgAqcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RxDYY2yAUdF5Bt5QLyX1/+fgxZAxLU5FaB7WM9TFao6wib8ozVuARDtudys37tfSI
	 0nqPD5AfnMYwBxLstJzfLYy8Qw0Z4wQ3vqZ5WtCHwrMwJweP1/OFoqTn+Egz1hS6gx
	 9LBjigDiUibkTZCNTD1xzIt1YVoJVrtDC2+jysIj4d0YII3ZTUi5ERNP2nKUSQ9okS
	 GY7MuEUBe5Zn4Ar8jI+CBfL208i2RJC4+l8213ygVTis8kT42onsJjJJDh4vBmn3tB
	 f9IxaSl8POmhfSl6n5mHBbcEwi+ZO/OW8PDEhJiVfvRDmYb5Qlw3psNE79KplfZejE
	 gF/oeGIzKpbWQ==
Date: Thu, 22 Oct 2026 13:01:10 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, bmarzins@redhat.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH] block: let a stacking device inherit its members' DMA
 alignment
Message-ID: <atpBVtPqGDWZ2AFo@kernel.org>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com>
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
In-Reply-To: <20260709161519.1559723-2-kbusch@meta.com>

On Thu, Jul 09, 2026 at 09:15:17AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> All device mappers that want to override the dma_alignment do so.
> However, because the default stacking limit is set to 511, a device
> mapper couldn't make it smaller even if it is capable of handling
> finer grained alignment.
> 
> Set the default dm stacking dma_alignment limit to 0 so that it can be
> stacked with any value a device mapper wants. If a mapper doesn't
> override the value, the initial 0 value will get changed to the original
> default 511 value when the limits are validated after the device
> stacking is complete.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/md/dm-table.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index dc2eff6b739df..80326f8096cb7 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -591,6 +591,7 @@ static void dm_set_stacking_limits(struct queue_limits *limits)
>  {
>  	blk_set_stacking_limits(limits);
>  	limits->features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
> +	limits->dma_alignment = 0;
>  }
>  
>  /*
> -- 
> 2.52.0
> 

This isn't a DM-specific concern (just happens to be that you're
focused on dm-crypt in this patchset).  dm-crypt is still imposing a
too strict dma_alignment, and so that'll need fixing too (along with
other DM targets that aren't properly considering the underlying
devices' queue_limits provided dma_alignment).

But this is a proper fix that I needed to allow MD RAID0 to allow
O_DIRECT to NVMe devices beneath the MD device:

From: Mike Snitzer <snitzer@kernel.org>
Date: Fri, 9 Oct 2026 06:26:29 -0600
Subject: [PATCH] block: let a stacking device inherit its members' DMA alignment

blk_set_stacking_limits() initializes dma_alignment to SECTOR_SIZE - 1,
and blk_stack_limits() then takes the maximum of that and each member's
value.  As a result every MD array and device-mapper table requires
512-byte aligned memory regardless of what its members need: a raid0
of NVMe namespaces reports a dma_alignment of 511 while each member
reports 3.

Direct I/O from memory every member accepts is therefore rejected at
the stacking device, and callers that check the advertised alignment
(for instance through STATX_DIOALIGN) fall back to buffered I/O.

Leave dma_alignment at zero in blk_set_stacking_limits() so that the
stacked value is the strictest of the members'.  blk_validate_limits()
still applies the SECTOR_SIZE - 1 default when nothing was stacked,
such as for a table with no devices.  Targets that process the data
themselves and need logical-block-aligned memory already set
dma_alignment in their io_hints (dm-crypt, dm-integrity, dm-verity,
dm-log-writes), and NVMe multipath sets its own.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/blk-settings.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8274631290db..c4b0fba01c4b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -41,7 +41,14 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->physical_block_size = SECTOR_SIZE;
 	lim->io_min = SECTOR_SIZE;
 	lim->discard_granularity = SECTOR_SIZE;
-	lim->dma_alignment = SECTOR_SIZE - 1;
+	/*
+	 * No dma_alignment of its own: blk_stack_limits() keeps the strictest
+	 * of the devices stacked under it, and blk_validate_limits() gives the
+	 * sector-size default to a device left with none.  A driver that looks
+	 * at the data and needs it laid out by logical block says so in its
+	 * own limits, as dm-crypt, dm-integrity, dm-verity and dm-log-writes
+	 * do.
+	 */
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 
 	/* Inherit limits from component devices */
-- 
2.52.0

