Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023807;
	b=bPu3hX0M+wgczntE2HXHGXBj7B6Ilh07d09qbfQzFtry5vVlENGneY90l1fvCaQnx2vR
	 iPL2bCpI4pCaa/2rd0OLtcH7nM8/+f58AGzg39TF/bG+3mNHnyS9bmjLVxK+Fv3i8Zo2A
	 QGbMbluIWIn32uqk5vyl+zNEXxUP2ZANldkEFjHYKH+YWHQTfSjJbkk9CDzjVEc3HAk5K
	 o3eaUa3JO6ZnnKjeuWxSXC0byGbCwLeLL8i9kiTx1qIHqyVRXnIuP+iogNxP+Ljf1YttB
	 2im0E6wAC0Ap1hkiIN8lm1JU54TU1rfUdzMzTUvBDYzGObAObo/WomNi4swnr9C6OWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023807;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=A52iasclaMGn55CnoWsk9m1Kpv5JAEAAzN+HRgO3nPc=;
	b=DT7HKEJbPTp7ED4AkGGP80VAOIORwZfQcsI/CLsLdxV3pgjBynj/05sGj3Wj71CCe7zW
	 glOj0cyWarz1wp7ehmT5vFR9EcZ65oMfcXZ6siyS5xpyE+ynnWUhqxyFbiuWahWCrXLcz
	 2d/T5mDbce2THSxlKvwIDDHndyCMXjL4uJTt27+7R0LZPSUuMHGPf5e/7/C5CVRjPBUqC
	 mJLKKgDVbpiSwsIbSW9L66CnOGt7HLOIY5S0wISEt3l/uRtN+71xOh3Y0KKJc3j+Y7d71
	 f4RjIxyOtT7QrB/Q8dO2uIpdBjT5AoAHkxYcvsVpSfKMKI+dlToOo9g+Gc12T+Y/0Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaUWvIui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957A8606A333
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaUWvIui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE011F000C6;
	Wed, 18 Nov 2026 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795023807;
	bh=A52iasclaMGn55CnoWsk9m1Kpv5JAEAAzN+HRgO3nPc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VaUWvIui4ObFC5TqrlvRTksqILEnqSF+GrHclfC0IzZ4tVUA8Xai/nl/HG9fiwFdf
	 jy9TrKax4MofEhLBrDA/2+3RaGtDz4fwV96aZsFqn/V84mVbpzXq46m5wYYkbHY0C/
	 CEob7t9JEX2Hiduo+Y07vdynBj0pdBugO/plfM73AAWrXP0EhuU13r2iggoatuWADH
	 oNENzLWMODrZUKZRVcjEEe8bfaOMC/WxOEoud+ZM0H1ZtFOOYBe5ewRNaqKMT3zd4z
	 COjiyKtbviPoAoucCg4YSbEceQDyVelI7MD23lr+RLJC0fbDlZWIFN7wze2GVU2BvJ
	 eDbA9/V60SE8g==
Message-ID: <sashiko-outbox-221679@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] dm-verity: add messages to inspect, prefetch and
 drop hash blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, mpatocka@redhat.com, snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
In-Reply-To: <20261118172133.689163-6-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
 <20261118172133.689163-6-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:43:26 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] dm-verity: unsynchronized prefetch in verity_prefetch_hash()
  across suspend
- [Low] dm-verity: unchecked start when total is 0 and duplicated range
  parsing
--

commit 836508fe811e1c71a731130ee4c4606452302695
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-verity: add messages to inspect, prefetch and drop hash blocks

This commit adds target messages to dm-verity to inspect or set the bufio
retain target (retain_bytes), asynchronously prefetch hash blocks
(prefetch_hash), and evict cached hash blocks (drop_hash), along with
documentation in verity.rst.

> diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documen=
tation/admin-guide/device-mapper/verity.rst
> index 9e9d4b8157c03..ec29cc6b6dc73 100644
> --- a/Documentation/admin-guide/device-mapper/verity.rst
> +++ b/Documentation/admin-guide/device-mapper/verity.rst
> @@ -328,6 +328,49 @@ Status

[ ... ]

> +Both cache commands still work while the device is suspended: prefetch
> +reads are queued and complete on resume, and ``drop_hash`` finds an empty
> +cache because verity resets the bufio client on suspend.
> +
>  Example
>  =3D=3D=3D=3D=3D=3D=3D
>  Set up a device::
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 15dee27d58a7a..78ae2e6bff186 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1924,6 +1924,174 @@ static void verity_resume(struct dm_target *ti)
> =20
>  static void verity_register_bufio_sysfs(struct dm_verity *v);
> =20
> +static int verity_prefetch_hash(struct dm_verity *v, unsigned int argc,
> +				char **argv, char *result, unsigned int maxlen)
> +{
> +	sector_t total =3D v->hash_end - v->hash_start;
> +	sector_t start, n;
> +	unsigned long long value;
> +	unsigned int sz =3D 0;
> +
> +	/*
> +	 * On a no_sleep client a buffer being read cannot be evicted or
> +	 * waited for, so an unfinished prefetch would outlive a suspend or
> +	 * teardown; drop_hash rejects this case for the same reason.
> +	 */
> +	if (v->use_bh_wq) {
> +		DMERR("prefetch_hash unsupported on tasklet-verifying device");
> +		return -EOPNOTSUPP;
> +	}
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
> +		if (!total) {
> +			n =3D 0;
> +			goto out;
> +		}
> +		DMERR("prefetch_hash start %llu beyond hash area (%llu blocks)",
> +		      (unsigned long long)start, (unsigned long long)total);
> +		return -EINVAL;
> +	}
> +
> +	n =3D min(n, total - start);
> +	n =3D min_t(sector_t, n, UINT_MAX);
> +
> +out:
> +	dm_bufio_prefetch(v->bufio, v->hash_start + start, n);

[Severity: Medium]
Can verity_prefetch_hash() race with verity_postsuspend() or submit reads
while the target is suspended?

target_message() runs under the live table SRCU lock without holding
md->suspend_lock or checking dm_suspended(ti).  Unlike verity_prefetch_io(),
which queues work on v->verify_wq that verity_postsuspend() drains before
calling dm_bufio_client_reset(v->bufio), verity_prefetch_hash() calls
dm_bufio_prefetch() directly in the ioctl context:

CPU0                              CPU1
target_message()
  verity_prefetch_hash()
    __dm_bufio_prefetch()
      dm_bufio_lock(c)
      b =3D __bufio_new(c, block, ...)
        /* b->hold_count =3D 1 */
      dm_bufio_unlock(c)
                                  dm_suspend()
                                    verity_postsuspend()
                                      flush_workqueue(v->verify_wq)
                                      dm_bufio_client_reset(v->bufio)
                                        drop_buffers(c)
                                          cache_iterate(..., warn_leak, ...)
                                            WARN_ON(!(*warned))
      submit_io(b, ...)
      dm_bufio_release(b)

drop_buffers() sees b->hold_count =3D=3D 1 and triggers WARN_ON in warn_lea=
k()
and WARN_ON(cache_count(&c->cache, i)); with
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING enabled, warn_leak() also resets
b->hold_count to 0 and drop_buffers() frees b while CPU0 still passes b to
submit_io() and dm_bufio_release(), causing a use-after-free and
BUG_ON(!atomic_read(&b->hold_count)).

In addition, because v->bufio is backed by v->hash_dev->bdev rather than
the dm-verity mapped_device, calling prefetch_hash while suspended
immediately submits read BIOs to v->hash_dev->bdev and populates v->bufio
(which a subsequent drop_hash while suspended can then drop), rather than
queueing reads until resume as described in verity.rst and expected by
2de510fccbca ("dm-verity: fix prefetch-vs-suspend race").

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
> +		if (!total) {
> +			n =3D 0;
> +			goto out;
> +		}
> +		DMERR("drop_hash start %llu beyond hash area (%llu blocks)",
> +		      (unsigned long long)start, (unsigned long long)total);
> +		return -EINVAL;
> +	}

[Severity: Low]
When total is 0 (levels =3D=3D 0), should a non-zero start argument such as
"prefetch_hash 100 10" or "drop_hash 100 10" still be rejected with
-EINVAL?

Both verity_prefetch_hash() and verity_drop_hash() take the !total branch
even when start > 0, jumping to out: and computing v->hash_start + start
with an unvalidated start offset.  Factoring the tasklet check, argument
parsing, and range clamping into a shared helper that only treats
(!start && !total) as an empty-range no-op would also remove the
duplicated parsing code between the two functions.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118172133.6891=
63-2-yangyongpeng.storage@gmail.com?part=3D4
