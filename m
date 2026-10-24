Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792859836;
	b=uk+ry3dC2Y70sdsJCNl6EXKKv08IIJwMuMBdnwdFhfOKCrQMbUOHoZcp/Ui2aWYqHfsq
	 C/VCmV5/AO/AnW35Zp+DPo8S10sRIz/njEKaIeG9XZ37oPw97UvEbzMK2mqgJ5pEVxVAJ
	 cp8kQCesxwhEkgmCCQsVMGrREp/Yn9YvRtcsn/DhboyxQ+AZZlbc7vyqie5E8t1dKNVny
	 6Y1153e47o3Xd6aqwEbzQmQEKmlnuDPxQ6Qgvt78dqEBhmbeRH3qxUUXa7KjJvAtwju1L
	 dVA7RXT0x6FOg89zWSKIDpQMkwmdq39dpWccg8wsP6nW5XE3DNrB3SuADJVOONS/38w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792859836;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6Y7gjBPVCqk5ly9XCo3/1r0hzzsH3cSM5PMCCYdJFNg=;
	b=eiN7f9ndbb18Zl3GP8QS4tuZoZ5+ouPqnR+FrE0H9wRlQC+LikZbh3IHKIj3v21QF4AK
	 uJmY/Zhi9qUA6q1ZCuiHSI08yaE3NnbUPQzJw0rshkzSStVtoBVTWGjvlQbZ4jUQFiWGK
	 bCN3Gl2IpjyxYNLFXYY+zSd8AbsQu/k5dErv9ZlZHlAqPJ6E/G7upbBA+wtWePSgRA8Fe
	 /tuDMYE+4/ysv2CTBbRAyr+4c14oF8yOzClDeKhHF95JEhSatJ6zFh2r6e/2c91FRU7K+
	 5zattSFqoivULXG6kuQK69mISJD4sYvAqupucRFQANAqTUbrvkKDBzLUhwpFG7QFtsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjGsGmfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAC5606A31A
	for <dm-devel@lists.linux.dev>; Sat, 24 Oct 2026 16:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FjGsGmfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425301F01825;
	Sat, 24 Oct 2026 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792859835;
	bh=6Y7gjBPVCqk5ly9XCo3/1r0hzzsH3cSM5PMCCYdJFNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FjGsGmfdbzSKlxSDAavR/P3lyUjxUMnvubDVtmUW5+UEzDEq1ROW2ZkNEB05vuP+I
	 ABt3Nm+EE6qUnSkFL1DfwTn0SdbNQDo9051dy3L9jIieohdmIN5Qqe5ZeDb+V7WNk0
	 Do2uDHBp/U5UVIDW/pRUlNqumLnqqaW0JPo9vu198bl2kI+PVCiAEZQa+OfGZZ19nB
	 hyEKk8CuKaKnbQ9+hiObA3GmoqShnx9xTnZRCFkyeyw6+kMGiGJpCDDe8mSNNMhw4L
	 XteWD3Mus7+OLzfug6XTLxYzFTIQ0myg49lJK/hnwsvzO+/VH8UhCoxKOUOjssSgRH
	 7pCOWFb7cvHxQ==
Message-ID: <sashiko-outbox-183792@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm snap: fix use-after-free when origin and COW devices
 match
Reply-To: sashiko-reviews@lists.linux.dev
To: "Igor Putko" <igorpetindev@gmail.com>, "Mike Snitzer" <snitzer@kernel.org>, "Alasdair
 Kergon" <agk@redhat.com>, "Mikulas Patocka" <mpatocka@redhat.com>
Cc: "Benjamin Marzinski" <bmarzins@redhat.com>, "Jens Axboe" <axboe@kernel.dk>, dm-devel@lists.linux.dev, syzbot+8e6fc64255334ccf3ab3@syzkaller.appspotmail.com
In-Reply-To: <20261024161459.5539-1-igorpetindev@gmail.com>
References: <20261024161459.5539-1-igorpetindev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 16:37:14 +0000
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
- [Critical] dm snap: TOCTOU race in snapshot_ctr() allows upgrade_mode() U=
AF on s->origin
--

commit b2c589f4852e6503996057072cf65216f108da3f
Author: Igor Putko <igorpetindev@gmail.com>

dm snap: fix use-after-free when origin and COW devices match

This commit resolves cow_path via dm_devt_from_path() in snapshot_ctr() and
compares the resulting dev_t against s->origin->bdev->bd_dev before calling
dm_get_device(), avoiding a use-after-free when upgrade_mode() replaces the
origin table_device.

> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index 797c432594d86..ecda207e800d7 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -1234,6 +1234,7 @@ static int snapshot_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
>  	int i;
>  	int r =3D -EINVAL;
>  	char *origin_path, *cow_path;
> +	dev_t cow_dev;
>  	unsigned int args_used, num_flush_bios =3D 1;
>  	blk_mode_t origin_mode =3D BLK_OPEN_READ;
> =20
> @@ -1276,15 +1277,21 @@ static int snapshot_ctr(struct dm_target *ti, uns=
igned int argc, char **argv)
>  	argv++;
>  	argc--;
> =20
> -	r =3D dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow=
);
> +	r =3D dm_devt_from_path(cow_path, &cow_dev);
>  	if (r) {
>  		ti->error =3D "Cannot get COW device";
>  		goto bad_cow;
>  	}
> -	if (s->cow->bdev && s->cow->bdev =3D=3D s->origin->bdev) {
> +	if (cow_dev =3D=3D s->origin->bdev->bd_dev) {
>  		ti->error =3D "COW device cannot be the same as origin device";
>  		r =3D -EINVAL;
> -		goto bad_store;
> +		goto bad_cow;
> +	}
> +
> +	r =3D dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow=
);
> +	if (r) {
> +		ti->error =3D "Cannot get COW device";
> +		goto bad_cow;
>  	}

[Severity: Critical]
Could a race between the two path lookups still trigger the use-after-free =
on
s->origin and leak the device reference?

When cow_path is a filesystem path rather than a major:minor string,
snapshot_ctr() first resolves it via dm_devt_from_path() -> lookup_bdev() ->
kern_path(), reads inode->i_rdev, and drops the path reference via
path_put().

Immediately afterwards, dm_get_device() resolves cow_path a second time:

drivers/md/dm-table.c:dm_get_device() {
	r =3D dm_devt_from_path(path, &dev);
	if (r)
		return r;
	...
	dd =3D find_device(&t->devices, dev);
	if (!dd) {
		...
	} else if (dd->dm_dev->mode !=3D (mode | dd->dm_dev->mode)) {
		r =3D upgrade_mode(dd, mode, t->md);
		if (r)
			return r;
	}
}

If cow_path (such as a symlink or block device node) is modified between the
first lookup in snapshot_ctr() and the second lookup in dm_get_device() to
point to the same block device as s->origin, find_device() matches the
existing dm_dev_internal entry for s->origin and calls upgrade_mode():

drivers/md/dm-table.c:upgrade_mode() {
	old_dev =3D dd->dm_dev;

	r =3D dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
				dd->dm_dev->mode | new_mode, &new_dev);
	if (r)
		return r;

	dd->dm_dev =3D new_dev;
	dm_put_table_device(md, old_dev);
}

Because the post-open check comparing s->cow->bdev and s->origin->bdev was
removed, wouldn't snapshot_ctr() continue execution with s->origin pointing
to the freed old_dev, dereferencing freed slab memory in register_snapshot()
(via snap->origin->bdev) or dm_put_device(), while also leaking the referen=
ce
on dd in ti->table->devices when dm_put_device(ti, s->origin) fails to find
the replaced dm_dev?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024161459.5539=
-1-igorpetindev@gmail.com?part=3D1
