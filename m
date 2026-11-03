Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735499;
	b=YnRE+grgOnQmqvJblyXdCRSXb8XylgOViKllFqdpy2YlQgTaqibcEdNPhsHCxrTx7YAM
	 DKHaLkVen2DkvlFG3Xs6eFQxEB3SrY4HEMuCARY+RRAVv9JshEx1OTvzW5MtjYS21xCmW
	 posGuHc03Qa0jayCPH6mJpzmX6ZnDJwlCbpXGsQuBYWdKbbb0f/a3kqgFhKGruROoPRpy
	 t0gGI53nfBEZdGAbIuw05stDnB/HKzjwS3ZcGzG02MVde0qlhlmL1dJMN6r1upsa6WGdC
	 M1R/y8zmTKmFo8D0CRNtcxuwho2i56HZO6L231i4N5HlMOzkEVA7oFN8i84o/5phHEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735499;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qj3/SpTtZDjYiLOQjArtmggLviDJGnAV5OUkVtocxq0=;
	b=3Tgqm0XPhJ8KB53CDq0acINxMWgzyWoBONc/xI7ex3z/emaEGydC2/QAq4kw9Q0p69RY
	 jEzuH/y2fcoHZ8cavBFY9hSO71dGcl0Y+2gUPYGiSu0UtEj2LGaAN/Ub6AciQwgC1hM6k
	 swJrvx+saMXVWh0Hx16q7xDO8q2Uxrenb6v+7fQwrqLEn8tsuOdqQSlxI1ynQqvrPhETa
	 YyNKdKWlUhQOoD9QEvMx45UbQN5VkQ5Hd9ZSKyZ/O1TQvVHtRb9CW7QXdsLhLJs5bkRIC
	 eA30/Ij5yRhi35d0ZDDF3BrFw7v4XYp69MX5LU+mYkTfTp3Qf+rpUajQ/hoX0jxCfrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WryYaOsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B7D606A324
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WryYaOsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC541F000C1;
	Tue,  3 Nov 2026 19:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793735499;
	bh=qj3/SpTtZDjYiLOQjArtmggLviDJGnAV5OUkVtocxq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WryYaOskGayv9f3I07utM4vE4BM2HJGjVMDImN09+s9+3NLloJMDaDKSF6vE78rpu
	 dwn0J3P8uUT3XXGa/iC/MbuxYgS24Y2/pj9KeZrwub4vRxXw6FN7RrVwGRr9615+oF
	 i12jpb0C/ymooJZYn+Kv6Sv2dKgeagYNCG9LCHDOl+POBRQ+SGo3fY5rD8d+tavvUZ
	 xwLNxozOGGGiaZ868Oy51qAl2Kfb58BG/7gYyATCqdCjIsE1CUeGSYPuYbDSjaVW15
	 WwGqAwmEqXonO/Jnou86KIkoBybDb7ybCqyAW6prp0M1WYv0gIQFWIHWJG3Yp1NiC9
	 LGg4M8ixaKMEg==
Message-ID: <sashiko-outbox-195941@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm thin: reject metadata and data devices that resolve
 to the same device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mohammad Pishdar" <mohamadpishdar@gmail.com>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev, syzbot+9519233e6d144970bbc2@syzkaller.appspotmail.com
In-Reply-To: <20261103193956.63354-1-mohamadpishdar@gmail.com>
References: <20261103193956.63354-1-mohamadpishdar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:51:38 +0000
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
- [High] dm thin: TOCTOU race in pool_ctr() device check still allows UAF
--

commit 5ead52d14677a9859b05ed7a484ff22ce5ff6bca
Author: Mohammad Pishdar <mohamadpishdar@gmail.com>

dm thin: reject metadata and data devices that resolve to the same device

This commit updates pool_ctr() in drivers/md/dm-thin.c to resolve the
metadata and data device paths via dm_devt_from_path() and reject the table
if both paths resolve to the same dev_t, aiming to prevent dm_get_device()
from calling upgrade_mode() and freeing metadata_dev while it is still held.

> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 358ed77ffb2be..6285bbc8c746d 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -3292,6 +3292,7 @@ static int pool_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
>  	dm_block_t low_water_blocks;
>  	struct dm_dev *metadata_dev;
>  	blk_mode_t metadata_mode;
> +	dev_t metadata_devt, data_devt;
> =20
>  	/*
>  	 * FIXME Remove validation from scope of lock.
> @@ -3307,8 +3308,17 @@ static int pool_ctr(struct dm_target *ti, unsigned=
 int argc, char **argv)
>  	as.argc =3D argc;
>  	as.argv =3D argv;
> =20
> -	/* make sure metadata and data are different devices */
> -	if (!strcmp(argv[0], argv[1])) {
> +	/*
> +	 * Make sure metadata and data are different devices. Comparing the
> +	 * strings is not enough: "/dev/foo" and "major:minor" can name the
> +	 * same device, which would make dm_get_device() upgrade the open
> +	 * mode of the already acquired metadata device and free the
> +	 * struct dm_dev we are still holding.
> +	 */
> +	if (!strcmp(argv[0], argv[1]) ||
> +	    (!dm_devt_from_path(argv[0], &metadata_devt) &&
> +	     !dm_devt_from_path(argv[1], &data_devt) &&
> +	     metadata_devt =3D=3D data_devt)) {
>  		ti->error =3D "Error setting metadata or data device";
>  		r =3D -EINVAL;
>  		goto out_unlock;

[Severity: High]
Can a concurrent symlink or device node change between this pre-check and
the subsequent dm_get_device() calls still trigger the use-after-free in
dm_put_device()?

For filesystem paths, dm_devt_from_path() calls lookup_bdev(), which
resolves the path via kern_path(), reads inode->i_rdev, and drops the path
reference via path_put() without pinning the dentry or block device. In
addition, if either dm_devt_from_path() call returns an error here (for
instance -ENOENT if a symlink or device node does not exist yet), the
condition evaluates to false and execution continues.

When pool_ctr() later calls dm_get_device() for metadata_dev and data_dev:

drivers/md/dm-thin.c:pool_ctr() {
	...
	metadata_mode =3D BLK_OPEN_READ |
		((pf.mode =3D=3D PM_READ_ONLY) ? 0 : BLK_OPEN_WRITE);
	r =3D dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
	if (r) {
		ti->error =3D "Error opening metadata block device";
		goto out_unlock;
	}
	warn_if_metadata_device_too_big(metadata_dev->bdev);

	r =3D dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev=
);
	...
}

each dm_get_device() call invokes dm_devt_from_path() a second time. If
argv[0] or argv[1] is created or modified in that window so that both now
resolve to the same dev_t:

- When pf.mode is PM_READ_ONLY, metadata_dev is opened with BLK_OPEN_READ
  and data_dev is opened with BLK_OPEN_READ | BLK_OPEN_WRITE, causing the
  second dm_get_device() call to invoke upgrade_mode() and free the
  struct dm_dev still held in metadata_dev, followed by the same slab
  use-after-free on metadata_dev->name in dm_put_device(ti, metadata_dev)
  when pool_ctr() fails.
- When pf.mode is not PM_READ_ONLY, pool_ctr() has no check after opening
  that metadata_dev->bdev !=3D data_dev->bdev, allowing a thin-pool to be
  created with metadata_dev and data_dev aliasing the same block device.

Would opening data_dev (which always requests BLK_OPEN_READ | BLK_OPEN_WRIT=
E)
before metadata_dev and checking metadata_dev->bdev =3D=3D data_dev->bdev a=
fter
both dm_get_device() calls avoid both upgrade_mode() and the double path
lookup race?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103193956.6335=
4-1-mohamadpishdar@gmail.com?part=3D1
