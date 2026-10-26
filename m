Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019925;
	b=Nk9vv7hmOQtmhzylyQ8Ve+y/fKMqrozMsA0woKlGmOH51c6RCqLTfM+iUaaUQvc30GGp
	 /jbzAsXTQ4jbMDVLc1KHG9o4Zxx5Y7slK6tE5BFn9QXnrzJhOjBRv6F+mIodL1u11SzRs
	 syTvkqprA1hHGHEhwrAYpOxm0L+IChLiaoTnSVr5/7Nfb04XmFbN9lHOTrTvEJngaEGtZ
	 xcB9p3uRbHw5CgVONsVwlXO6nIpQJrybKM0EpoTbdcuwhyAGxWFTj3E8rPjIoFmHRRHpA
	 4JfQLk9+Tu3z4/etwYIFhDGn+cAwU44v8thAcm6AsAZlw7rcquoEToT8UYbBLm7Ajxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019925;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6szwWT0QzBZzb+/APZDYs8BFk+Phr0ePbCUVZoCv8i8=;
	b=Uu94qoUhHQ7Wz7e675PSdD31Lw+XGvnrBPQysuVVf7SCN8k5Z3g34iDfNU+Q5aACt6gr
	 G0ty7wAwOHNAo4WLj0wpcR9aAmGAek/TmNo0gFPd8H+sVtKBDak3Z2bnqge+d7X4RoJiy
	 QRZcFRuKDC26E7TGNZiQ/l+P9hbjbY+OL6/MrxFXg/n3rw4c8CyLrp174yn2sfsmYIZYp
	 m8llTJeKcZNvpk54eUi0YT4hMy2Tx8birdMMtmuODU/2J2C4gqF/WkNfQEV/AL/Aa/rhO
	 B8rooVgvEwsJa/rmkP8e7ZKVqB5f3vK64Ipx1nwAkp2XdRZFwsmtKfcjl+Rtde0xhLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNf0eHbK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33730606A31D
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 13:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RNf0eHbK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6745E1F01825;
	Mon, 26 Oct 2026 13:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793019924;
	bh=6szwWT0QzBZzb+/APZDYs8BFk+Phr0ePbCUVZoCv8i8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RNf0eHbKKEMIniMPTU4u0f6RZVAMIwhOlCkZsRppZVaTt2YK72aIiCyQdFOWaMnTo
	 Sutty76qgoZNcyfMQkGUhnkfBbiIvDXhAkxjf0huNj0NgaoekLP0I3BR17h6odsBjQ
	 EwBDnhM9a3tgw51k+sMhT5LrEkcOmIEb80vvft9S4So0euy/GZdLuKlvGcPo4oGINT
	 V3eS4ZBotPUb2xhA8u4u7Lejw0b03sdtMcPfXif5UvG/WD2RONx5hs/wQ7k+zQOISY
	 ffT9iQXwFZzBFkRLXBSejRPAUQYJpe+WOa5ccoS8ff1/VHgSjXxO7U8FcrsFt4LlFv
	 rhm5gBTwTOJHw==
Message-ID: <sashiko-outbox-185265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm: reject aliased metadata/data and pool/origin
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Drif Abdelmalek Mohamed Said" <drifabdelmalekmohamedsaid@gmail.com>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com, jason.cai.kern@gmail.com
Cc: dm-devel@lists.linux.dev, syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
In-Reply-To: <20261026125114.251-1-drifabdelmalekmohamedsaid@gmail.com>
References: <20261026125114.251-1-drifabdelmalekmohamedsaid@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 13:05:23 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] dm thin: TOCTOU race between dm_devt_from_path() and dm_get_device=
()
- [Medium] dm thin: memory leak of struct thin_c on error paths in thin_ctr=
()
- [Low] dm thin: wrong ti->error messages in thin_ctr() and pool_ctr()
--

commit 1eca47222f62970abc013ee1decbccbb30099b93
Author: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>

dm: reject aliased metadata/data and pool/origin devices

This commit validates resolved device numbers with dm_devt_from_path() in
pool_ctr() and thin_ctr() before opening the devices so that aliased
metadata/data or pool/origin paths pointing to the same block device are
rejected before upgrade_mode() can free an already-opened table_device.

> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 358ed77ffb2be..281b2e1745c31 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -3292,6 +3292,8 @@ static int pool_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
>  	dm_block_t low_water_blocks;
>  	struct dm_dev *metadata_dev;
>  	blk_mode_t metadata_mode;
> +	dev_t metadata_devt;
> +	dev_t data_devt;
> =20
>  	/*
>  	 * FIXME Remove validation from scope of lock.
> @@ -3314,6 +3316,22 @@ static int pool_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
>  		goto out_unlock;
>  	}
> =20
> +	r =3D dm_devt_from_path(argv[0], &metadata_devt);
> +	if (r) {
> +		ti->error =3D "Error opening metadata block device";
> +		goto out_unlock;
> +	}
> +	r =3D dm_devt_from_path(argv[1], &data_devt);
> +	if (r) {
> +		ti->error =3D "Error opening metadata data device";
> +		goto out_unlock;
> +	}
> +	if (metadata_devt =3D=3D data_devt) {
> +		ti->error =3D "Error setting metadata or data device";
> +		r =3D -EINVAL;
> +		goto out_unlock;
> +	}

[Severity: High]
Can a concurrent path modification between dm_devt_from_path() and
dm_get_device() still trigger the same slab-use-after-free in pool_ctr() and
thin_ctr()?

When given a filesystem path rather than major:minor, dm_devt_from_path()
calls lookup_bdev(), which resolves the path via kern_path(), reads
inode->i_rdev, and immediately drops the path reference via path_put()
without pinning the dentry or opening the block device:

drivers/md/dm-table.c:dm_devt_from_path() {
	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) =3D=3D 2) {
		...
	} else {
		r =3D lookup_bdev(path, &dev);
		...
	}
	*dev_p =3D dev;
	return 0;
}

Later in pool_ctr() (and similarly in thin_ctr()), dm_get_device() calls
dm_devt_from_path() -> lookup_bdev() a second time on each path string:

drivers/md/dm-thin.c:pool_ctr() {
	...
	r =3D dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
	...
	r =3D dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev=
);
}

Because no VFS lock or device reference is held across the pre-check and the
dm_get_device() calls during dm_ctl_ioctl() -> table_load() ->
populate_table() -> dm_table_add_target(), a concurrent symlink flip or blo=
ck
device node rename after the metadata_devt =3D=3D data_devt (or pool_devt =
=3D=3D
origin_devt) check passes can cause both dm_get_device() calls to resolve to
the same dev_t.

When the first dm_get_device() opens the device with BLK_OPEN_READ
(metadata_dev in a read-only pool in pool_ctr(), or origin_dev in thin_ctr(=
))
and the second dm_get_device() opens the same dev_t with
BLK_OPEN_READ | BLK_OPEN_WRITE, upgrade_mode() in drivers/md/dm-table.c
replaces dd->dm_dev and frees old_dev via dm_put_table_device() ->
close_table_device() -> kfree():

drivers/md/dm-table.c:upgrade_mode() {
	old_dev =3D dd->dm_dev;

	r =3D dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
				dd->dm_dev->mode | new_mode, &new_dev);
	if (r)
		return r;

	dd->dm_dev =3D new_dev;
	dm_put_table_device(md, old_dev);

	return 0;
}

Wouldn't that leave metadata_dev in pool_ctr() or tc->origin_dev in
thin_ctr() dangling before __pool_find(), thin target operations, or
dm_put_device() dereference it?

[ ... ]

> @@ -4204,12 +4222,30 @@ static int thin_ctr(struct dm_target *ti, unsigne=
d int argc, char **argv)
>  	tc->sort_bio_list =3D RB_ROOT;
> =20
>  	if (argc =3D=3D 3) {
> +		dev_t pool_devt;
> +		dev_t origin_devt;
>  		if (!strcmp(argv[0], argv[2])) {
>  			ti->error =3D "Error setting origin device";
>  			r =3D -EINVAL;
>  			goto bad_origin_dev;
>  		}
> =20
> +		r =3D dm_devt_from_path(argv[0], &pool_devt);
> +		if (r) {
> +			ti->error =3D "Error opening metadata block device";
> +			goto out_unlock;
> +		}
> +		r =3D dm_devt_from_path(argv[2], &origin_devt);
> +		if (r) {
> +			ti->error =3D "Error opening metadata data device";
> +			goto out_unlock;
> +		}
> +		if (pool_devt =3D=3D origin_devt) {
> +			ti->error =3D "Error setting metadata or data device";

[Severity: Low]
Are these ti->error strings in thin_ctr() and pool_ctr() copy-pasted from t=
he
metadata check?

In thin_ctr() when argc =3D=3D 3, argv[0] is the pool device and argv[2] is=
 the
origin device (where the surrounding checks use "Error setting origin devic=
e",
"Error opening origin device", and "Error opening pool device"), so reporti=
ng
metadata and data device errors when dm_devt_from_path(argv[0], &pool_devt)
fails, dm_devt_from_path(argv[2], &origin_devt) fails, or pool_devt =3D=3D
origin_devt looks mismatched.

Similarly, in pool_ctr() when dm_devt_from_path(argv[1], &data_devt) fails =
on
the data device argv[1], ti->error is set to "Error opening metadata data
device".

> +			r =3D -EINVAL;
> +			goto out_unlock;
> +		}

[Severity: Medium]
Does jumping to out_unlock in these three new error paths in thin_ctr() leak
tc?

In drivers/md/dm-thin.c, thin_ctr() allocates tc before entering the
argc =3D=3D 3 block:

drivers/md/dm-thin.c:thin_ctr() {
	...
	tc =3D ti->private =3D kzalloc_obj(*tc);
	if (!tc) {
		ti->error =3D "Out of memory";
		r =3D -ENOMEM;
		goto out_unlock;
	}
	...
	if (argc =3D=3D 3) {
		...
		if (!strcmp(argv[0], argv[2])) {
			ti->error =3D "Error setting origin device";
			r =3D -EINVAL;
			goto bad_origin_dev;
		}
		...
	}
	...
bad_origin_dev:
	kfree(tc);
out_unlock:
	mutex_unlock(&dm_thin_pool_table.mutex);

	return r;
}

When dm_ctl_ioctl() -> table_load() -> populate_table() ->
dm_table_add_target() -> thin_ctr() is called with argc =3D=3D 3 and
dm_devt_from_path(argv[0], &pool_devt) fails,
dm_devt_from_path(argv[2], &origin_devt) fails, or pool_devt =3D=3D origin_=
devt,
jumping to out_unlock bypasses bad_origin_dev where kfree(tc) is called, and
dm_table_add_target() does not invoke thin_dtr() on constructor failure.
Should these three error paths jump to bad_origin_dev instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026125114.251-=
1-drifabdelmalekmohamedsaid@gmail.com?part=3D1
