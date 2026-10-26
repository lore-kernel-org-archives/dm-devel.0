Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792974156;
	b=xbY+urVAnohxHFQbe8TOzSyCljlMBaUU1TxrRyLgPl1yXUMTdyKU74tXF17hwpKgFDEX
	 mNqrrghhMQOsHLTHKiKi+pWIY3j41HFqReg9/xjtQwy/3R/QS7NG4EvzHShDJVu5P6Bdr
	 CIq68VWQl9GjpTbIfVvuPMpLB9gQrWtFADVK1czwyOQPgeAwi/FWB6juSwC254a2OwOWw
	 qFIGOdsqPXwv87/YTg2DLcXjJmG7kmmthFuJqL4pNw37MTRIF297Sgmg40V+0jc/8HwzU
	 sIOqw7jdQJtDsD/JDcQbvI4pBoS/m20idlP3uZl56pPCSyzmkb5Ux1aXyGMREijzVag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792974156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5zupIBKtZCHsLd3NEPNe8A9I1VJniBLcoDSyVg4vOEA=;
	b=wdnygmakpqeClALdEPjeykKmZPG69dCEVrDtjEB5UtkO5BtoMiXrFTVhfDqzJ2HXJ57E
	 tXFbpOd6k7xp3q1UsFX7+FLZDruvifYaiIg3oUwtJMRyPP9nV4UISg0sAd/3MaOyfg3vT
	 Acs7GtYx9UUEwcFJsek7TzzLyKW1GwAuFqTZzgYRscwSBIL6Xsha1NL56UzaxLbYKinnF
	 f9brZWxiPbTQd4Fh4pGw/MtpMQgi9QGf/KQfB418PIEdDNey63fslYma3uxNNetSOjRqE
	 T4+TnvaCYnIZxregx3B5TcAeUb5md1zll2e+eq31dCzbfHYkeg0wuCjppRwF3ctSicw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Poloigkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3744E606A31A
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 00:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Poloigkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F2A1F01825;
	Mon, 26 Oct 2026 00:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792974155;
	bh=5zupIBKtZCHsLd3NEPNe8A9I1VJniBLcoDSyVg4vOEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Poloigkd2Q6tg0FQveFM0NTIgJaI8KjiUDyHm3H0jRBFswtHhX/C92LiCpzlkA7z6
	 6LEfB7BBO121TyE1LSOiZmkLXgQBoMR3BnFXO2aYQi4b69QPox04+j/nxeItqLeGhq
	 hdo+f1RxUikzWOQ7Btoa1tBFZFw7utVoG/j61AqgJ7eSKhG1RL0NmKr8lDeuKErn1s
	 2CFvmKg/lSTQIDz6gQajJmXVdHXD4xhnfMNaFGEeGN7n1mVUo9tUusQrWOhn9fyYFh
	 dnrpC6vmYr89NW9I9hv2cdFTizXTNp5VuWs/LlhosMjMJUfvl3aQlkM9Xrwmhv35F/
	 KLbPTi4MhVI8A==
Message-ID: <sashiko-outbox-184561@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] block: fix discard alignment for non-power-of-two
 granularities
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>, axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, mtsai@redhat.com, colyli@suse.de
In-Reply-To: <20261026000511.73371-1-dennylin0707@gmail.com>
References: <20261026000511.73371-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 00:22:35 +0000
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
- [Critical] block: divide-by-zero in bio_discard_limit() when discard_gran=
ularity is 0
--

commit c2a5682afd9058576d36c11b303c1f6073d6bfa9
Author: Hungyu Lin <dennylin0707@gmail.com>

block: fix discard alignment for non-power-of-two granularities

This commit replaces round_up() and round_down() in bio_discard_limit()
with sector_div() and rounddown() to properly align discard bios when
discard_granularity is not a power of two.

Link: https://lore.kernel.org/r/CALjSBEvjbiGDVewuapWKhGDtaxZwcn4=3D22raUiBE=
Oyj22rY7-g@mail.gmail.com

> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 688bc67cbf733..e0de5bb4d969e 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -13,26 +13,25 @@
>  static sector_t bio_discard_limit(struct block_device *bdev, sector_t se=
ctor)
>  {
>  	unsigned int discard_granularity =3D bdev_discard_granularity(bdev);
> -	sector_t granularity_aligned_sector;
> +	unsigned int remainder;
> =20
>  	if (bdev_is_partition(bdev))
>  		sector +=3D bdev->bd_start_sect;
> =20
> -	granularity_aligned_sector =3D
> -		round_up(sector, discard_granularity >> SECTOR_SHIFT);
> +	remainder =3D sector_div(sector, discard_granularity >> SECTOR_SHIFT);
> =20
>  	/*
>  	 * Make sure subsequent bios start aligned to the discard granularity if
>  	 * it needs to be split.
>  	 */
> -	if (granularity_aligned_sector !=3D sector)
> -		return granularity_aligned_sector - sector;
> +	if (remainder)
> +		return (discard_granularity >> SECTOR_SHIFT) - remainder;
> =20
>  	/*
>  	 * Align the bio size to the discard granularity to make splitting the =
bio
>  	 * at discard granularity boundaries easier in the driver if needed.
>  	 */
> -	return round_down(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
> +	return rounddown(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
>  }

[Severity: Critical]
Can this trigger a divide-by-zero when discard_granularity is 0?

When a block device does not support discard or has discard disabled via
sysfs, blk_validate_limits() in block/blk-settings.c explicitly sets
discard_granularity to 0:

	if (lim->max_discard_sectors)
		lim->discard_granularity =3D
			max(lim->discard_granularity, lim->physical_block_size);
	else
		lim->discard_granularity =3D 0;

Since commit 094259204578 ("block: remove the discard_granularity check
in __blkdev_issue_discard") and commit 30f1e7241422 ("block: move discard
checks into the ioctl handler"), neither blkdev_issue_discard(),
__blkdev_issue_discard(), nor blk_alloc_discard_bio() checks
bdev_max_discard_sectors(bdev) or bdev_discard_granularity(bdev) before
calling bio_discard_limit(bdev, *sector):

block/blk-lib.c:blk_alloc_discard_bio() {
	sector_t bio_sects =3D min(*nr_sects, bio_discard_limit(bdev, *sector));
	...
}

Instead, they rely on submit_bio_noacct() -> blk_check_bio() in
block/blk-core.c to reject unsupported REQ_OP_DISCARD bios with
BLK_STS_NOTSUPP.

Several callers can reach blk_alloc_discard_bio() on a device with
discard_granularity =3D=3D 0, such as:

- Callers that do not pre-check bdev_max_discard_sectors(), for example
  hpfs_ioctl() -> hpfs_trim_fs() -> do_trim() -> sb_issue_discard(),
  nvmet_bdev_execute_discard() -> __blkdev_issue_discard(),
  fat_free_clusters() / fat_trim_fs() when mounted with -o discard,
  nilfs_discard_segments(), jfs_issue_discard(), __ext4_remount() with
  -o remount,discard, f2fs_secure_erase(), Xen dispatch_discard_io(),
  r5l_write_super_and_discard_space(), and fd_execute_unmap().

- Any discard caller (such as blk_ioctl_discard(), blkdev_cmd_discard(),
  or active filesystem/swap discard) racing with runtime discard
  disablement when 0 is written to discard_max_bytes via
  queue_max_discard_sectors_store().

Previously, round_up(sector, 0) and round_down(BIO_MAX_SIZE, 0) used
bitwise masks and did not trap. With sector_div() and rounddown(), a zero
discard_granularity divides by zero.

Should discard_granularity be guarded here (similar to
max(lim->discard_granularity >> 9, 1U) in __bio_split_discard()), or
should bio_discard_limit() / blk_alloc_discard_bio() handle
discard_granularity =3D=3D 0 before dividing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026000511.7337=
1-1-dennylin0707@gmail.com?part=3D1
