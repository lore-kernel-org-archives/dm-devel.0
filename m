Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792770076;
	b=E+5y14Ir+Zz3q1fpko99yyWKIBCyBuPcLKQ6PrVYs/sZAfmfuhQCCFjmZy+1MG25rs3H
	 00lxeApMc0Uiq44gZtoMVgFkyHUZZ53OQTDLcbBGhm0ERSut5TzRoGv12YuQ4PjeXkcMZ
	 TcrDNBFxBzHLJ8S5PzkOcxejbtynF9vUphR3yhuWu0sKvDSbyvjSfA5PxJ+dzuOOkLe7Q
	 eJH7qA+lwlMUaBb2ROCy9bpTfkqbGi0fIavSBxKCHQVVphKG2YCzcejBfD/9kBrXS44q8
	 fvINUU8p/ktSDVJn6CSUA3pnhO4xf/+e4Ulv2I8zamqSW6c+fvtW6AxM2IyeLdFeUkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792770076;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=RDiGfCc6duwviiXhhIvB3N776rJ+Z9VsnNbyDKyfVoA=;
	b=abhvueQDnz8wprK1N2QFTmG/uq8woB9208tIz7TIGW1zDvG6OTi8cxVC+mOUyJR0cRxG
	 3huM0FwcUMV/pl29sej9aj1+z6BDCwivxSYjN1hRvEhRf01QT9rfjlLxN3ajpwZG6ZDzQ
	 27NzM0HK8rsTlB8wx2Fg7hpl3Zi2h7GVXFyZnOlREXGD4IKbvBXP3Nrg4+9w1McOcAK58
	 /gisATy0REp4DOldngm2iaWdY1Qj1DINB9hctAj/bQBPSyN7Y5il1bX8DObhvoUEXRkHd
	 plYxf6tWR3SpcoDIoOcDgyvsgDvEssByqD+tvuCOkO6gaU8/w1HfcXcfXR1Q8bL6wiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D1aB0vMb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA64E606A331
	for <dm-devel@lists.linux.dev>; Fri, 23 Oct 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D1aB0vMb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326D01F031EB;
	Fri, 23 Oct 2026 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792770075;
	bh=RDiGfCc6duwviiXhhIvB3N776rJ+Z9VsnNbyDKyfVoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D1aB0vMbGXpMRvyXmp/c9CZWv1WzyJNAs8cJI70GUZMae27Lgc+FHWBKfX2ePJoV5
	 kHTl3E8HYqv96GbvLD/+M+i6yaKAarQgTatL09r6ZfW1IAC84JzebJYSlmtOdqhoKq
	 67+k6bfEKK51vkDkNxlw2VR+BLnjHR7YK/unRE/t9bLcimyxEPisqC9SCX3QxQ5q/1
	 oCbX/VZq+e/uoxah5VenqPpuKMabkP/Vr6MQB4krYTLYf3Dc8YO+rZOUMO4LKPteu+
	 443g4WNy7QN14+WTRmHcp7aE7MJjf+/lKEtJ1fZaRqPwWF2L7lDxw7byMEaQsQ7eb7
	 uRCJxNLzlhOIg==
Date: Fri, 23 Oct 2026 11:41:14 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: sashiko-bot@kernel.org
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	dm-devel@lists.linux.dev, mpatocka@redhat.com, bmarzins@redhat.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: block: let a stacking device inherit its members' DMA alignment
Message-ID: <atuAGpRkY5cPLKfT@kernel.org>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com>
 <atpBVtPqGDWZ2AFo@kernel.org>
 <sashiko-outbox-181857@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-181857@kernel.org>

On Thu, Oct 22, 2026 at 05:25:02PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] block: blk_set_stacking_limits() corrupts data in dm-ebs and dm-writecache
> --
> 
> commit da5c2e4cde4a12a4f8b254dc27480cf9078b36d2
> Author: Mike Snitzer <snitzer@kernel.org>
> 
> block: let a stacking device inherit its members' DMA alignment
> 
> This commit removes the default sector-size dma_alignment initialization in
> blk_set_stacking_limits() so that stacking devices inherit the strictest
> dma_alignment of their underlying member devices. When no member devices are
> stacked, blk_validate_limits() still applies the default sector alignment.
> 
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index e469baa1f08b7..36fcbecdf793b 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -41,7 +41,14 @@ void blk_set_stacking_limits(struct queue_limits *lim)
> >  	lim->physical_block_size = SECTOR_SIZE;
> >  	lim->io_min = SECTOR_SIZE;
> >  	lim->discard_granularity = SECTOR_SIZE;
> > -	lim->dma_alignment = SECTOR_SIZE - 1;
> > +	/*
> > +	 * No dma_alignment of its own: blk_stack_limits() keeps the strictest
> > +	 * of the devices stacked under it, and blk_validate_limits() gives the
> > +	 * sector-size default to a device left with none.  A driver that looks
> > +	 * at the data and needs it laid out by logical block says so in its
> > +	 * own limits, as dm-crypt, dm-integrity, dm-verity and dm-log-writes
> > +	 * do.
> > +	 */
> 
> [Severity: Critical]
> Could leaving lim->dma_alignment at 0 in blk_set_stacking_limits() cause data
> corruption regressions in targets like dm-ebs and dm-writecache that inspect
> bio data but do not set limits->dma_alignment in their io_hints callbacks?
> 
> When stacked over a device with sub-sector dma_alignment (such as an nvme
> device with dma_alignment = 3), direct I/O using a 4-byte-aligned user buffer
> that crosses a page boundary or uses sub-sector iovecs can produce bio_vec
> segments whose lengths are not multiples of 512 bytes (for example,
> bv_len = 4092 followed by bv_len = 4).

The code comment in the patch calls out the fact that
blk_validate_limits() will backfill dma_alignment if none is set (by
usual limits stacking or explicitly by DM targets).

But sure, there is potential for dragons if stacked block devices
like DM implicitly relied on block-core's coarse-grained default
dma_alignment.

Mikulas, would you be open to auditing the DM targets relative to
dma_alignment stacking after you're done with reviewing Keith's
related dm-crypt patchset?

Sorry for the extra work... but its worthwhile for DM to be more
precise with how it stacks dma_alignment

Thanks,
Mike

> In drivers/md/dm-ebs-target.c, ebs_io_hints() does not set
> limits->dma_alignment:
> 
> drivers/md/dm-ebs-target.c:ebs_io_hints() {
> 	struct ebs_c *ec = ti->private;
> 
> 	limits->logical_block_size = to_bytes(ec->e_bs);
> 	limits->physical_block_size = to_bytes(ec->u_bs);
> 	limits->alignment_offset = limits->physical_block_size;
> 	limits->io_min = limits->logical_block_size;
> }
> 
> When __ebs_rw_bio() iterates over the bio with bio_for_each_bvec() and calls
> __ebs_rw_bvec(), __ebs_rw_bvec() computes the buffer offset and block number
> from iter->bi_sector:
> 
> drivers/md/dm-ebs-target.c:__ebs_rw_bvec() {
> 	unsigned int bv_len = bv->bv_len;
> 	unsigned int buf_off = to_bytes(__block_mod(iter->bi_sector, ec->u_bs));
> 	sector_t block = __sector_to_block(ec, iter->bi_sector);
> 
> Because bio_for_each_bvec() advances iter via bio_advance_iter_single() in
> include/linux/bio.h:
> 
> include/linux/bio.h:bio_advance_iter_single() {
> 	iter->bi_sector += bytes >> 9;
> 
> a segment with bv_len = 4092 advances iter.bi_sector by 4092 >> 9 = 7 sectors
> (3584 bytes) instead of 4092 bytes, wouldn't the subsequent bio_vec read or
> write at the wrong offset in the dm-bufio block?
> 
> Similarly, in drivers/md/dm-writecache.c, writecache_io_hints() only calls
> dm_stack_bs_limits() and leaves limits->dma_alignment untouched:
> 
> drivers/md/dm-writecache.c:writecache_io_hints() {
> 	struct dm_writecache *wc = ti->private;
> 
> 	dm_stack_bs_limits(limits, wc->block_size);
> }
> 
> In persistent memory mode, writecache_map_read() and writecache_map_write()
> process multi-block bios in a loop using bio->bi_iter.bi_sector to look up
> and record cache entry sectors via write_original_sector_seq_count(), calling
> bio_copy_block() for each block:
> 
> drivers/md/dm-writecache.c:bio_copy_block() {
> 	do {
> 		struct bio_vec bv = bio_iter_iovec(bio, bio->bi_iter);
> 		...
> 		size = bv.bv_len;
> 		if (unlikely(size > remaining_size))
> 			size = remaining_size;
> 		...
> 		data = (char *)data + size;
> 		remaining_size -= size;
> 		bio_advance(bio, size);
> 	} while (unlikely(remaining_size));
> }
> 
> When a cache block spans multiple bio_vec segments with sub-sector lengths
> (such as 4092 and 4 for a 4096-byte block), bio_advance() ->
> bio_advance_iter() updates bio->bi_iter.bi_sector += size >> 9 on each step,
> advancing bi_sector by 7 sectors instead of 8 and corrupting
> bio->bi_iter.bi_sector for subsequent blocks in the bio.
> 
> In addition, when bio_copy_block() calls memcpy_flushcache_optimized() with a
> non-64-byte-multiple size >= 768 (such as 4092), doesn't the loop return
> early without copying the remaining size % 64 bytes?
> 
> drivers/md/dm-writecache.c:memcpy_flushcache_optimized() {
> 	if (cpu_feature_enabled(X86_FEATURE_CLFLUSHOPT) &&
> 	    likely(boot_cpu_data.x86_clflush_size == 64) &&
> 	    likely(size >= 768)) {
> 		do {
> 			memcpy((void *)dest, (void *)source, 64);
> 			clflushopt((void *)dest);
> 			dest += 64;
> 			source += 64;
> 			size -= 64;
> 		} while (size >= 64);
> 		return;
> 	}
> }
> 
> Finally, in solid-state cache mode, writecache_iterate_devices() only stacks
> limits from wc->dev and not wc->ssd_dev:
> 
> drivers/md/dm-writecache.c:writecache_iterate_devices() {
> 	struct dm_writecache *wc = ti->private;
> 
> 	return fn(ti, wc->dev, 0, ti->len, data);
> }
> 
> If wc->dev has dma_alignment = 3 while wc->ssd_dev has dma_alignment = 511,
> wouldn't dm-writecache advertise dma_alignment = 3 and remap 4-byte-aligned
> bios to wc->ssd_dev->bdev, causing bio_split_io_at() to reject them?
> 
> >  	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
> >  
> >  	/* Inherit limits from component devices */
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/atpBVtPqGDWZ2AFo@kernel.org?part=1
