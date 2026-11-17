Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794923096;
	b=ZGj7GndZwD+Sf10kPW9sUB9B9s6yWuqXXyaDrbI3pp7VJCw+zJUi/0kamRMTBn1gypNP
	 75eQL9ponSDjOs6ORe8+m5yzgXGVN+z11ynoQoB67+pAoYFL1z6873JnPJCLuywyaTH7i
	 pKMAjS571ivqVHBVEQ72tj+TISxsMN+nvpapsoJ2YbUgHREaXdkwjR9RL77dpsi6J8+Wh
	 QgO47kNJ7/i8jjMxtfusLRAB1HnHtlhjP4kAbPlurQHEE2Mu4ZpO3PLsV9iaYi5q9X6cg
	 Kz3gN8OeAkckzxhcyksaEgSA6qfbl4UXA/7b4itNFb0JbLeFfRHzyWPRkxrGOnLPdkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794923096;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1qTWx7KJ9eA40rlzEEHBRZz3EMelc8/e9ysa/My4uCQ=;
	b=m5Y2N9PO10995HB7vmqQp6xJTcRnSsDW68DihPLxmeecG5pYursn9iJ6os9rIynM/MNH
	 PcIh8knvAAY4UAjn21yi4Rpu3AbrCsQ6K8KqzntI0wTVKVdiDbbrLR5i9GQI9w7D5TVPP
	 QY8VP8NgjcZNS9rO/qpDFTUvo4ouVHaUBf6tHgeJqXoLAmy780Ps4XaQUvm50WaJ3nfFX
	 DdXU2v5pPQk+joHlktv35KGS/zbqIV4otady9sX3ToDHKS/5PYVVPWJN2LC3sma2hFRRv
	 9Mr9pS4FYeUhI4ucO/kSnqUpgy6rnt3LoUzoKTDJtKMcYz6KXWCoNCocayefwRYcIFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=avAY7pIP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605D2606A31C
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=avAY7pIP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08AB1F000C4;
	Tue, 17 Nov 2026 13:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794923096;
	bh=1qTWx7KJ9eA40rlzEEHBRZz3EMelc8/e9ysa/My4uCQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=avAY7pIPhcP3tHxiPRFFuaHQcvoPrErRM982JCyFz5CozDE5jYnw1pmG3AgdYuTlL
	 LpbkKt9VaSAyQBTPk4Nh7/4385oVWTwEeof/rkLoLfCDFWWHFwbiA65HS6QB0phh4Y
	 iQez0+VhQaiy3dXrnacTd3B1OWo2F2+bmeuod7ewVHORs7k0ufwu4AuX0Lmg9vgJbA
	 z80fn+WS0FcnnYWgikXtY/UaUBhnFP3ULkGZ1G+B1D4VVzv5wNP6RUEHggueMugnMh
	 h1+UO/3XfGu1JYXX9UaBYicqp8iCvn4wMFMmYhYPdh5ZFfZ/3vKGVfOPSFBAPAqQvy
	 tGgFImxYVdmUA==
Message-ID: <sashiko-outbox-218898@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] dm-verity: size the hash retain target from the
 hash area
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, "Yongpeng Yang" <yangyongpeng@xiaomi.com>
In-Reply-To: <20261117131918.2745193-6-yangyongpeng.storage@gmail.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
 <20261117131918.2745193-6-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 13:44:55 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] dm-verity: 64-bit division and 32-bit truncation in
  verity_ctr()
- [Medium] dm-verity: duplicate sysfs dir warning and missing dir on
  table reload
- [Medium] dm-verity: release of data_dev before verity_fec_dtr() in
  verity_dtr()
- [Low] dm-verity: document dm_verity.hash_retain_percent in
  kernel-parameters.txt
--

commit 6fe0fff5c789faa19fdefcb12c794d8f32e868cd
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-verity: size the hash retain target from the hash area

This commit configures the dm-verity hash bufio client's retain target as a
configurable percentage of the hash area and exposes dm-verity's bufio
clients under /sys/block/dm-N/dm-bufio/.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 6d589867623c0..d4fb06cb4e7ea 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -32,6 +32,8 @@
>  #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
>  #define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
> =20
> +#define DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT	10
> +
>  #define DM_VERITY_MAX_CORRUPTED_ERRS	100
> =20
>  #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
> @@ -50,6 +52,13 @@ static unsigned int dm_verity_prefetch_cluster =3D DM_=
VERITY_DEFAULT_PREFETCH_SIZE
> =20
>  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0=
644);
> =20
> +/* Default fraction of the hash tree that dm-bufio is asked to keep cach=
ed. */
> +static unsigned int dm_verity_hash_retain_percent =3D DM_VERITY_DEFAULT_=
HASH_RETAIN_PERCENT;
> +
> +module_param_named(hash_retain_percent, dm_verity_hash_retain_percent, u=
int, 0644);
> +MODULE_PARM_DESC(hash_retain_percent,
> +	"Percentage of the hash area to keep cached by default");

[Severity: Low]
Since Documentation/admin-guide/kernel-parameters.txt already documents
dm_verity.keyring_unsealed=3D, should dm_verity.hash_retain_percent=3D be a=
dded
there as well?

> @@ -1083,6 +1092,9 @@ static void verity_dtr(struct dm_target *ti)
> =20
>  	verity_fec_dtr(v);
> =20
> +	if (v->bufio_kobj)
> +		kobject_put(v->bufio_kobj);
> +

[Severity: Medium]
Can exposing v->fec->data_bufio in sysfs cause a use-after-free of
v->data_dev->bdev during teardown?

verity_dtr() calls dm_put_device(ti, v->data_dev) before verity_fec_dtr(v)
destroys and unregisters f->data_bufio:

drivers/md/dm-verity-target.c:verity_dtr() {
    ...
	if (v->data_dev)
		dm_put_device(ti, v->data_dev);

	verity_fec_dtr(v);
    ...
}

v->fec->data_bufio is created on v->data_dev->bdev, and
dm_bufio_client_create() stores c->bdev without taking its own reference.
When FEC uses a separate device from data_dev, dm_put_device(ti, v->data_de=
v)
closes the underlying block device while /sys/block/dm-N/dm-bufio/fec-data =
is
still registered in sysfs, so a concurrent read of the bdev or bdev_name
attribute in dm_bufio_attr_show() can dereference c->bdev after it has been
released:

CPU0                                  CPU1
verity_dtr()
  dm_put_device(ti, v->data_dev)
                                      dm_bufio_attr_show()
                                        sysfs_emit(buf, "%pg\n", c->bdev)
                                          <-- use-after-free
  verity_fec_dtr(v)
    dm_bufio_client_destroy(f->data_bufio)

Calling verity_fec_dtr(v) before releasing v->data_dev and v->hash_dev would
ensure the FEC bufio clients are unregistered before their backing devices
are put.

[ ... ]

> @@ -1629,6 +1642,13 @@ static int verity_ctr(struct dm_target *ti, unsign=
ed int argc, char **argv)
>  		goto bad;
>  	}
> =20
> +	hash_retain_percent =3D READ_ONCE(dm_verity_hash_retain_percent);
> +	if (hash_retain_percent <=3D 100)
> +		dm_bufio_set_retain_bytes(v->bufio,
> +			mult_frac((u64)(v->hash_end - v->hash_start) <<
> +				  v->hash_dev_block_bits,
> +				  hash_retain_percent, 100));
> +

[Severity: High]
Does passing a u64 expression to mult_frac() break 32-bit builds and silent=
ly
truncate the retain target above ULONG_MAX?

mult_frac(x, n, d) declares its internal variables with typeof(x) and expan=
ds
to raw '/' and '%' operations, which emit __udivdi3 and __umoddi3 libcalls =
on
32-bit architectures when x is u64 and n is a runtime variable.  In additio=
n,
dm_bufio_set_retain_bytes() takes an unsigned long, so on 32-bit kernels a
u64 result at or above 4 GiB is truncated modulo 2^32 (and if truncated to =
0,
resets retain_bytes to the global default).  Using mul_u64_u32_div() and
min_t(u64, ..., ULONG_MAX) would avoid both problems.

> @@ -1806,6 +1826,45 @@ static void verity_postsuspend(struct dm_target *t=
i)
>  	verity_security_clear_integrity(ti);
>  }
> =20
> +/*
> + * Publish the bufio clients under /sys/block/dm-N/dm-bufio/.  Runs from
> + * ->resume because the dm device's block device does not exist in ->ctr.
> + */
> +static void verity_register_bufio_sysfs(struct dm_verity *v)
> +{
> +	struct mapped_device *md =3D dm_table_get_md(v->ti->table);
> +	struct kobject *parent;
> +
> +	if (v->bufio_kobj)
> +		return;
> +
> +	parent =3D &disk_to_dev(dm_disk(md))->kobj;
> +	/*
> +	 * On a table reload the old table's directory is still there; it is
> +	 * removed only after this resume returns.  We retry on the next one.
> +	 */
> +	v->bufio_kobj =3D kobject_create_and_add("dm-bufio", parent);
> +	if (!v->bufio_kobj) {
> +		DMERR("cannot create dm-bufio sysfs directory, will retry on next resu=
me");
> +		return;
> +	}

[Severity: Medium]
Does reloading a dm-verity table trigger a sysfs_warn_dup() stack trace and
leave the device without a /sys/block/dm-N/dm-bufio directory?

On table reload, do_resume() suspends the old table, swaps in the new table,
and calls dm_resume(md) before calling dm_table_destroy(old_map):

drivers/md/dm-ioctl.c:do_resume() {
    ...
	if (dm_suspended_md(md)) {
		r =3D dm_resume(md);
    ...
	}
    ...
	if (old_map)
		dm_table_destroy(old_map);
    ...
}

Because the old table's v->bufio_kobj is only freed in verity_dtr(),
/sys/block/dm-N/dm-bufio still exists when verity_resume() runs on the new
table.  kobject_create_and_add("dm-bufio", parent) hits -EEXIST in
sysfs_create_dir_ns() and calls sysfs_warn_dup(), which logs a duplicate
filename warning and a full dump_stack() backtrace.  Then
dm_table_destroy(old_map) runs verity_dtr() on the old table and removes the
directory, and since no second resume occurs, the reloaded table is left wi=
th
v->bufio_kobj =3D=3D NULL and no dm-bufio sysfs directory.

Unregistering and freeing v->bufio_kobj (and removing the bufio clients from
sysfs) in verity_postsuspend() would release the old table's directory befo=
re
the new table's ->resume hook runs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117131918.2745=
193-2-yangyongpeng.storage@gmail.com?part=3D3
