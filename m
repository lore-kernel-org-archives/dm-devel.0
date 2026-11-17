Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794923348;
	b=aZB1DNlHiieUCxCRZZnsRTLfd79jU3R061BWS1WGqomSqaw71k1DC4CA8BfcEnJUWUY6
	 FnyFBhCsOM5eABfcuTEF79dd61DUN11XfbaWLjxOIm2Alp1YlPuAaGUMNcKXaBijsrmyU
	 yWRTOcnGVVvD7iZOTqOAzh2uyDeti9euRE9ehGkXo+0SNPVZQh+GiEZyfUX6HyOJJ1NKX
	 wlKgIRwvGKik5yrCA91U5f1pNzDkck+v1mo5fFztClYIJBQ+rwIxAkfzQtt3BwSdu7xi5
	 RLr9063FhQW0r/dYUtmUYM5TTiPVQ6wdfc6SDu0HfEGv+DAUP9haSSBK+kOF7VfFrFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794923348;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K4VHWRpxgdYJt4SQaqc9d2iW81AUgFgDaxj0VdCbRvc=;
	b=ljFDR3koo6fl70jzonzdyTJ5UW+WMppUzt7DRoLBS9DMwoJFkyjbJO/oioI9XIzpExVR
	 RAKd6bSypP8qGl2zaGUlbe8+8S4Z7kQlo4+B8dgDY9ioZ3nfGCErfDcUgYShNHrt2VLgo
	 WQr+rt2Lsl8Ka6x+d/ixX3sTQSBgGoaN86oUiSYYjs5BXdkAp/ZJqA+yKBClXHShRauYJ
	 qbApx0KE/WfGdCWY77LL9IJR9ixS9rqg+CCHOeRmj/ippxEXFf9/aNqfT57wJ5IU04L9n
	 +hQzxzaHyMozxKJ6RDaWWAbavxUlhrb/TsveXfxXL07Lji+HqnOC254xOrjqPFp15bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AhueLxEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF59B606A31C
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AhueLxEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CA21F000C6;
	Tue, 17 Nov 2026 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794923347;
	bh=K4VHWRpxgdYJt4SQaqc9d2iW81AUgFgDaxj0VdCbRvc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AhueLxEkyc6ZLGDuyPfDZ0SHsBgSTWcx27ucICPLGtZk17beVPCbF4dV1bd8KoYJ2
	 6z9YuodWeSc00o+G+NPrxsLiaUGfCz6iH/GHsQUeFL0e/P4/zFoE/6Vnb8oj14LN5K
	 AlsD+dc1elMItVriv/sbophtwD+j1XCFHbnw6oUVed6ebnpAEwz1BjC9usZIYSff39
	 eS74Ew7td3E5xgx/is9fjyFKsBr4uAudVYet1BYHcbNNcfbILrlAQ4P2cf4UurGPC8
	 cJGxmn0geV8oQhyuFWRFYaC/1rGw8fvo79bgzR1JtJfxLIkBMX+uDcFZxXLcvw++51
	 FYe/JZW59U2Rw==
Message-ID: <sashiko-outbox-218904@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] dm-verity: add messages to inspect, prefetch and
 drop hash blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, "Yongpeng Yang" <yangyongpeng@xiaomi.com>
In-Reply-To: <20261117131918.2745193-7-yangyongpeng.storage@gmail.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
 <20261117131918.2745193-7-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 13:49:07 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] dm-verity: verity_prefetch_hash() on no_sleep client causes UAF
  on teardown
- [High] dm-verity: 64-bit mult_frac() division and truncation in
  verity_ctr()
- [Medium] dm-verity: unsynchronized prefetch in verity_prefetch_hash()
  across suspend
- [Medium] dm-verity: duplicate sysfs kobject warning on reload in
  verity_register_bufio_sysfs()
- [Medium] dm-verity: premature dm_put_device() before verity_fec_dtr()
  in verity_dtr()
- [Low] dm-verity: zero-arg prefetch_hash and drop_hash fail when levels
  is zero
--

commit 1669fe0d8b13a61ae6909ea388b60b10f26a0954
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-verity: add messages to inspect, prefetch and drop hash blocks

This commit adds target messages (retain_bytes, prefetch_hash, and
drop_hash) to dm-verity to inspect or configure bufio retain targets and to
prefetch or drop cached hash blocks, and documents dm-verity metadata
caching and the new messages.

> diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documen=
tation/admin-guide/device-mapper/verity.rst
> index 9e9d4b8157c03..8fea6130765bb 100644
> --- a/Documentation/admin-guide/device-mapper/verity.rst
> +++ b/Documentation/admin-guide/device-mapper/verity.rst
> @@ -328,6 +328,48 @@ Status
>  2. Number of corrected blocks by Forward Error Correction.
>     '-' if Forward Error Correction is not enabled.
> =20
> +Metadata caching
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The hash blocks, and the FEC parity blocks when FEC is enabled, are cach=
ed in
> +memory by dm-bufio.  How much of the hash tree is kept cached is control=
led by
> +the ``hash_retain_percent`` module parameter (default 10), settable at b=
oot
> +time with ``dm_verity.hash_retain_percent=3D<0-100>`` or at run time thr=
ough
> +``/sys/module/dm_verity/parameters/hash_retain_percent``.  A value of 0 =
or
> +above 100 leaves the dm-bufio default (256 KiB), which is also what the =
FEC
> +clients keep.  Only devices created afterwards are affected.

[Severity: High]
Does the hash_retain_percent calculation in verity_ctr() from commit
"dm-verity: size the hash retain target from the hash area" fail to link on
32-bit architectures and truncate retain sizes at or above 4 GiB?

drivers/md/dm-verity-target.c:verity_ctr() {
    ...
	hash_retain_percent =3D READ_ONCE(dm_verity_hash_retain_percent);
	if (hash_retain_percent <=3D 100)
		dm_bufio_set_retain_bytes(v->bufio,
			mult_frac((u64)(v->hash_end - v->hash_start) <<
				  v->hash_dev_block_bits,
				  hash_retain_percent, 100));
    ...
}

mult_frac(x, n, d) uses typeof(x) and plain C '/' and '%' operators, so
passing a u64 first argument emits __udivdi3 and __umoddi3 calls on 32-bit
builds.  In addition, dm_bufio_set_retain_bytes() takes an unsigned long, so
a 64-bit byte count at or above 4 GiB wraps modulo 2^32 on 32-bit systems
unless clamped to ULONG_MAX.

> +
> +Each client's retain target and memory use are visible under
> +``/sys/block/dm-N/dm-bufio/<hash|fec|fec-data>/`` on the verity device's=
 own
> +block device, and the target can be changed by writing that directory's
> +``retain_bytes`` attribute; see
> +Documentation/admin-guide/device-mapper/dm-bufio.rst.  The directories a=
ppear

[Severity: Medium]
Can exposing v->fec->data_bufio under fec-data in commit "dm-verity: size
the hash retain target from the hash area" cause a use-after-free on
c->bdev during verity_dtr()?

drivers/md/dm-verity-target.c:verity_dtr() {
    ...
	if (v->data_dev)
		dm_put_device(ti, v->data_dev);

	verity_fec_dtr(v);
    ...
}

v->fec->data_bufio stores a raw pointer to v->data_dev->bdev, which
dm_bufio_attr_show() dereferences when reading fec-data/bdev or
fec-data/bdev_name.  Because verity_dtr() calls dm_put_device(ti,
v->data_dev) before verity_fec_dtr(v) destroys v->fec->data_bufio and
removes its sysfs kobject, a concurrent sysfs read during target teardown
can dereference v->data_dev->bdev after the device reference has been
dropped.

> +when the device is first activated and disappear with it.  Reloading the
> +table removes the old table's directories; the new table's reappear on t=
he
> +next resume.

[Severity: Medium]
Does calling kobject_create_and_add("dm-bufio", parent) in
verity_register_bufio_sysfs() from commit "dm-verity: size the hash retain
target from the hash area" trigger a kernel warning and stack trace on every
table reload?

During do_resume(), dm_resume() invokes verity_resume() on the new table
before dm_table_destroy() runs verity_dtr() on the old table.  Because the
old table's "dm-bufio" kobject is still registered under the disk kobject,
kobject_create_and_add("dm-bufio", parent) fails with -EEXIST in
sysfs_create_dir_ns() and calls sysfs_warn_dup(), which prints a kernel
warning and calls dump_stack(), and then destroying the old table removes
/sys/block/dm-N/dm-bufio altogether.

[ ... ]

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index d4fb06cb4e7ea..7f92bc14d39fe 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1865,6 +1865,154 @@ static void verity_resume(struct dm_target *ti)
>  	verity_register_bufio_sysfs(ti->private);
>  }
> =20
> +static int verity_prefetch_hash(struct dm_verity *v, unsigned int argc,
> +				char **argv, char *result, unsigned int maxlen)
> +{
> +	sector_t total =3D v->hash_end - v->hash_start;
> +	sector_t start, n;
> +	unsigned long long value;
> +	unsigned int sz =3D 0;
> +
> +	if (argc =3D=3D 1) {
> +		start =3D 0;
> +		n =3D total;
> +	} else if (argc =3D=3D 3) {
> +		if (kstrtoull(argv[1], 0, &value) || (sector_t)value !=3D value)
> +			return -EINVAL;
> +		start =3D value;
> +
> +		if (kstrtoull(argv[2], 0, &value) || (sector_t)value !=3D value)
> +			return -EINVAL;
> +		n =3D value;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	if (start >=3D total) {
> +		DMERR("prefetch_hash start %llu beyond hash area (%llu blocks)",
> +		      (unsigned long long)start, (unsigned long long)total);
> +		return -EINVAL;
> +	}

[Severity: Low]
Does the start >=3D total check in verity_prefetch_hash() and
verity_drop_hash() reject zero-argument calls on a valid 0-level verity
device?

When v->data_blocks <=3D 1, verity_ctr() sets v->levels =3D 0 and
v->hash_end =3D v->hash_start, so total is 0.  A zero-argument prefetch_hash
or drop_hash sets start =3D 0 and n =3D 0, hits start >=3D total, logs an e=
rror,
and fails with -EINVAL instead of succeeding as a 0-block no-op.

> +
> +	n =3D min(n, total - start);
> +	n =3D min_t(sector_t, n, UINT_MAX);
> +
> +	dm_bufio_prefetch(v->bufio, v->hash_start + start, n);

[Severity: Medium]
Can verity_prefetch_hash() race with verity_postsuspend() or submit reads to
v->hash_dev while the target is suspended?

CPU0                                  CPU1
target_message()
  verity_message()
    verity_prefetch_hash()
      dm_bufio_prefetch(v->bufio, ...)
        dm_bufio_lock(c)
        b =3D __bufio_new(...)
          /* b->hold_count =3D=3D 1 */
        dm_bufio_unlock(c)
                                      dm_suspend()
                                        verity_postsuspend()
                                          flush_workqueue(v->verify_wq)
                                          dm_bufio_client_reset(v->bufio)
                                            drop_buffers(c)
                                              cache_iterate(..., warn_leak)
                                                WARN_ON(!(*warned))
                                              WARN_ON(cache_count(...))
        submit_io(b, ...)
        dm_bufio_release(b)

Unlike verity_prefetch_io(), which runs on v->verify_wq and is drained by
flush_workqueue(v->verify_wq) in verity_postsuspend() (see 2de510fccbca
("dm-verity: fix prefetch-vs-suspend race")), target_message() calls
verity_message() without holding md->suspend_lock or checking
dm_suspended(ti).  If dm_bufio_client_reset() runs while
__dm_bufio_prefetch() has dropped dm_bufio_lock(c) with a buffer's
hold_count =3D=3D 1, drop_buffers() cannot evict that buffer and triggers t=
he
leak WARN_ONs in warn_leak() and drop_buffers() (and under
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING, warn_leak() zeroes b->hold_count and
drop_buffers() frees b before submit_io() and dm_bufio_release(b) run,
causing a use-after-free).

In addition, because v->bufio submits reads directly to v->hash_dev->bdev
rather than the dm-verity mapped device, calling prefetch_hash while
suspended immediately issues reads to v->hash_dev->bdev and populates
v->bufio instead of queueing them until resume as described in verity.rst.

> +
> +	DMEMIT("prefetch_hash: started %llu blocks", (unsigned long long)n);
> +
> +	return 1;
> +}
> +
> +static int verity_drop_hash(struct dm_verity *v, unsigned int argc,
> +			    char **argv, char *result, unsigned int maxlen)
> +{
> +	sector_t total =3D v->hash_end - v->hash_start;
> +	sector_t start, n;
> +	unsigned long long value;
> +	unsigned int sz =3D 0;
> +
> +	/*
> +	 * dm_bufio_forget_buffers() ends up in cache_remove_range(), which
> +	 * cannot run on a client created with DM_BUFIO_CLIENT_NO_SLEEP.
> +	 */
> +	if (v->use_bh_wq) {
> +		DMERR("drop_hash unsupported on tasklet-verifying device");
> +		return -EOPNOTSUPP;
> +	}

[Severity: High]
Can calling verity_prefetch_hash() on a v->use_bh_wq device leave in-flight
B_READING buffers that drop_buffers() cannot evict, leading to warnings and
a use-after-free on teardown?

drivers/md/dm-bufio.c:is_clean() {
    ...
	if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep &&
	    unlikely(test_bit(B_READING, &b->state)))
		return ER_DONT_EVICT;
    ...
}

When v->use_bh_wq is enabled, v->bufio is created with
DM_BUFIO_CLIENT_NO_SLEEP (c->no_sleep =3D true).  verity_prefetch_hash() do=
es
not reject v->use_bh_wq and submits asynchronous read BIOs to
v->hash_dev->bdev with B_READING set and b->hold_count =3D=3D 0, returning =
to
userspace while those reads are still in flight.  If the device is then
suspended (dm_bufio_client_reset()) or destroyed (dm_bufio_client_destroy())
before all prefetched reads complete, __get_unclaimed_buffer() -> is_clean()
refuses to evict the B_READING buffers.  drop_buffers() then triggers
WARN_ON(!(*warned)) in warn_leak(), calls cond_resched() inside
__cache_iterate() while holding spin_lock_bh(&c->spinlock), and on target
destruction destroys c->slab_buffer and frees c while read_endio() is still
in flight.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117131918.2745=
193-2-yangyongpeng.storage@gmail.com?part=3D4
