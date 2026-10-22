Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792689903;
	b=PO0hoakkWcp9JlrqKvGfhXf/wjJ7o5+pfJ0dHxXZxLDA5O5NtxemlQjFdqrQ25GqTnZU
	 ggax2uGc9Au27Ko6Z8unyvbxiHwQl8l0koMXmlAta+LkmNP0PV1bD4VRtrMHikbqHM9mb
	 9wyTAhiifAsIcZaM55jMyh1+AdEM9S/thsNIwl9TevD20lacEChyawqcIOM0/yZALvsG2
	 jGzMtCH/FCnxg/pG8DTT83DEDd9Min14oJ8rU1grZmsbX1yIHMT+Wp2NwEmwAtVuSj1n7
	 YRydtleQrCYgQyCbWirMrksgQDT6vSgr9FmVeqzqUXPZE5UxXetf/1GCtjkb1Vo0KMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689903;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=S2g0dNv50+bt5WStkW536+XufqVUz5Tl/wWpHMwU0mQ=;
	b=gZjcJyITSJeW/OekArzTdy3OPvOKlE2Bq/zqmOU1ZXYfSwZ2HaQwtet1CKA8pvs+szMn
	 SWB18/eGd0X9Ia5+3v5sZB7F8O9LBUyy6N3+uodyrJ2VACUMAtHNPzGvmmaEbd25FRR+2
	 7UnF43HMRoaTyjseU586+qfHqwkf8nBl4rcKfJs5ChtQQdbZuzyNtxTbh0dT/ZlvDJ6nL
	 BDGAWJRUFNEsc/KqsTgknLSUt+vTiqLszLmNfpDLu0l140FNH8Qe/qUsCdA6zdLu7rmy3
	 yq9tFj3VGQr06O1EVLbhlXTkkxF0TRLMvZwyr2AxKkbFVTFbTwybIKrKx+/C9Y6nVMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2ldxGDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CA8606A319
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y2ldxGDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D361F01825;
	Thu, 22 Oct 2026 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792689903;
	bh=S2g0dNv50+bt5WStkW536+XufqVUz5Tl/wWpHMwU0mQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y2ldxGDwZ7RV3DALR+hwaN19M+ohFpRLTzYU8k3QvEj03yxB3m9LDf/tQ6x2QlgKU
	 P8H+f9Oxqh/D1W6/VrqILl2VFHsX8VdWk6gpiYvOunPA9BKlajN7YnfvKealUhMp3q
	 CmJCw9x1fU//i/rTLVFKw2tV11+jkMZ5IWFSnMZWIMvMvg6kX+zgTDzouvU0/CcBGr
	 Ip26+zw1tJqKChxtJWTjVay7WL6N0iIAzMzN2JC9S0+9h7h2NFkjf6sioMLve4S0jI
	 /TyPIbq5BV67pZIe200g00Ko8su2g/H+nfW6G5Q3/O/DGk9dn3FmaS3pFBqXEdxmun
	 Yt6tAJag9n+gA==
Message-ID: <sashiko-outbox-181857@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] block: let a stacking device inherit its members' DMA
 alignment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Keith Busch" <kbusch@meta.com>, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, bmarzins@redhat.com, "Keith
 Busch" <kbusch@kernel.org>
In-Reply-To: <atpBVtPqGDWZ2AFo@kernel.org>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com> <atpBVtPqGDWZ2AFo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 17:25:02 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] block: blk_set_stacking_limits() corrupts data in dm-ebs and d=
m-writecache
--

commit da5c2e4cde4a12a4f8b254dc27480cf9078b36d2
Author: Mike Snitzer <snitzer@kernel.org>

block: let a stacking device inherit its members' DMA alignment

This commit removes the default sector-size dma_alignment initialization in
blk_set_stacking_limits() so that stacking devices inherit the strictest
dma_alignment of their underlying member devices. When no member devices are
stacked, blk_validate_limits() still applies the default sector alignment.

> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index e469baa1f08b7..36fcbecdf793b 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -41,7 +41,14 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->physical_block_size =3D SECTOR_SIZE;
>  	lim->io_min =3D SECTOR_SIZE;
>  	lim->discard_granularity =3D SECTOR_SIZE;
> -	lim->dma_alignment =3D SECTOR_SIZE - 1;
> +	/*
> +	 * No dma_alignment of its own: blk_stack_limits() keeps the strictest
> +	 * of the devices stacked under it, and blk_validate_limits() gives the
> +	 * sector-size default to a device left with none.  A driver that looks
> +	 * at the data and needs it laid out by logical block says so in its
> +	 * own limits, as dm-crypt, dm-integrity, dm-verity and dm-log-writes
> +	 * do.
> +	 */

[Severity: Critical]
Could leaving lim->dma_alignment at 0 in blk_set_stacking_limits() cause da=
ta
corruption regressions in targets like dm-ebs and dm-writecache that inspect
bio data but do not set limits->dma_alignment in their io_hints callbacks?

When stacked over a device with sub-sector dma_alignment (such as an nvme
device with dma_alignment =3D 3), direct I/O using a 4-byte-aligned user bu=
ffer
that crosses a page boundary or uses sub-sector iovecs can produce bio_vec
segments whose lengths are not multiples of 512 bytes (for example,
bv_len =3D 4092 followed by bv_len =3D 4).

In drivers/md/dm-ebs-target.c, ebs_io_hints() does not set
limits->dma_alignment:

drivers/md/dm-ebs-target.c:ebs_io_hints() {
	struct ebs_c *ec =3D ti->private;

	limits->logical_block_size =3D to_bytes(ec->e_bs);
	limits->physical_block_size =3D to_bytes(ec->u_bs);
	limits->alignment_offset =3D limits->physical_block_size;
	limits->io_min =3D limits->logical_block_size;
}

When __ebs_rw_bio() iterates over the bio with bio_for_each_bvec() and calls
__ebs_rw_bvec(), __ebs_rw_bvec() computes the buffer offset and block number
from iter->bi_sector:

drivers/md/dm-ebs-target.c:__ebs_rw_bvec() {
	unsigned int bv_len =3D bv->bv_len;
	unsigned int buf_off =3D to_bytes(__block_mod(iter->bi_sector, ec->u_bs));
	sector_t block =3D __sector_to_block(ec, iter->bi_sector);

Because bio_for_each_bvec() advances iter via bio_advance_iter_single() in
include/linux/bio.h:

include/linux/bio.h:bio_advance_iter_single() {
	iter->bi_sector +=3D bytes >> 9;

a segment with bv_len =3D 4092 advances iter.bi_sector by 4092 >> 9 =3D 7 s=
ectors
(3584 bytes) instead of 4092 bytes, wouldn't the subsequent bio_vec read or
write at the wrong offset in the dm-bufio block?

Similarly, in drivers/md/dm-writecache.c, writecache_io_hints() only calls
dm_stack_bs_limits() and leaves limits->dma_alignment untouched:

drivers/md/dm-writecache.c:writecache_io_hints() {
	struct dm_writecache *wc =3D ti->private;

	dm_stack_bs_limits(limits, wc->block_size);
}

In persistent memory mode, writecache_map_read() and writecache_map_write()
process multi-block bios in a loop using bio->bi_iter.bi_sector to look up
and record cache entry sectors via write_original_sector_seq_count(), calli=
ng
bio_copy_block() for each block:

drivers/md/dm-writecache.c:bio_copy_block() {
	do {
		struct bio_vec bv =3D bio_iter_iovec(bio, bio->bi_iter);
		...
		size =3D bv.bv_len;
		if (unlikely(size > remaining_size))
			size =3D remaining_size;
		...
		data =3D (char *)data + size;
		remaining_size -=3D size;
		bio_advance(bio, size);
	} while (unlikely(remaining_size));
}

When a cache block spans multiple bio_vec segments with sub-sector lengths
(such as 4092 and 4 for a 4096-byte block), bio_advance() ->
bio_advance_iter() updates bio->bi_iter.bi_sector +=3D size >> 9 on each st=
ep,
advancing bi_sector by 7 sectors instead of 8 and corrupting
bio->bi_iter.bi_sector for subsequent blocks in the bio.

In addition, when bio_copy_block() calls memcpy_flushcache_optimized() with=
 a
non-64-byte-multiple size >=3D 768 (such as 4092), doesn't the loop return
early without copying the remaining size % 64 bytes?

drivers/md/dm-writecache.c:memcpy_flushcache_optimized() {
	if (cpu_feature_enabled(X86_FEATURE_CLFLUSHOPT) &&
	    likely(boot_cpu_data.x86_clflush_size =3D=3D 64) &&
	    likely(size >=3D 768)) {
		do {
			memcpy((void *)dest, (void *)source, 64);
			clflushopt((void *)dest);
			dest +=3D 64;
			source +=3D 64;
			size -=3D 64;
		} while (size >=3D 64);
		return;
	}
}

Finally, in solid-state cache mode, writecache_iterate_devices() only stacks
limits from wc->dev and not wc->ssd_dev:

drivers/md/dm-writecache.c:writecache_iterate_devices() {
	struct dm_writecache *wc =3D ti->private;

	return fn(ti, wc->dev, 0, ti->len, data);
}

If wc->dev has dma_alignment =3D 3 while wc->ssd_dev has dma_alignment =3D =
511,
wouldn't dm-writecache advertise dma_alignment =3D 3 and remap 4-byte-align=
ed
bios to wc->ssd_dev->bdev, causing bio_split_io_at() to reject them?

>  	lim->seg_boundary_mask =3D BLK_SEG_BOUNDARY_MASK;
> =20
>  	/* Inherit limits from component devices */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/atpBVtPqGDWZ2AFo@ke=
rnel.org?part=3D1
