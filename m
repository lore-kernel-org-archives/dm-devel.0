Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107004;
	b=PLY0wYi5dM7/OdtEeCLTtf0335dE7geKEAO68z1+l9be8YX9myX4AhSC8acHyvp1w0+J
	 8yVk1EvqeNZUEeYzIs5VT0HLtBffT6SlZzwOU4yvIu4ndN97hMDHiJsswsm1xD+aF8GdM
	 xEdvyv6Un1MlizTAQCqspMSwSP0CM645fWYSth6TYDiyqs7q9ZQWGPVawXRV1bfmd/pqp
	 hjdzU1wSSwz987VHJ6vBGi9wZQBWfpait2Cn2NZZFjFqQQWL4sUwC9v3YNiHP8zHg1S3N
	 DVt2ehjT/0eDo9cqnc9aaz6cVKqBRzyALMS97MU98VGPKYy93qjXZvWaaJyyFIBpD2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107004;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/ZinwIquUz4prToqlULaTrGMh567BPOBRzKKgd3nD3s=;
	b=qIMF6H//UoWyrBalMpSBiazTH/+DxZgIsiiW4kS4Wb2/8o2AilPxE6/oZXv4IDAZQaro
	 3yagb/0S8lhLb8bhGdflHpVYJW3GThGhQsKjzv3lO46ItjChYMYscZRik6FivjauYG4Ad
	 wAl4wemfafVueqUsFdoDuSMsYEdEPhaWB5gHDTUeMwFaMVB4stcpuzmPkqy3TTx3D4Ned
	 RKZ90NpQCUlG9diCXxzo8I2wwoefQIWYbkhX1UIHnq5OmVZ4kJotXhn9qwhAcCgNv9TaY
	 0gyS4S6L+Ms7jOaVt9o/0FILzYWwAJYkNK6SwnBtMt2V7QVsq81QjIEHvOxckNcmcDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvvpL68m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83035606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MvvpL68m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D071F000D1;
	Thu, 19 Nov 2026 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795107004;
	bh=/ZinwIquUz4prToqlULaTrGMh567BPOBRzKKgd3nD3s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MvvpL68m79cxb288rxp2K/DT4V/iXcLPznJUvWKuWN/1Hx6V7L2k7Z4wGbTx/0bME
	 SOvqESVK40ZSDO2ClAQ7sSKYXrw05vSBDJWMrDPI+DKiFsdmvACx2k8XKMWjjvm41C
	 Tb8/3dHcPW0S7oSWDCCX71wVu/0XfxEh4BxPS0EZKRl/1icf/6a4Cb6Iu2U/RRTs8a
	 VQj05TyF6K85q1gntFIU/fLO3ZJsYSwnkjFm1Ic3arLlaejIm8BGEzpHOkp1/yON1I
	 flDgthk1L0kexzX0XZ/L2YaljK46hV/0orq/mwfG1+GzrzaeCnRRTQItnshq8cACcE
	 MrkFk8gys9EWQ==
Message-ID: <sashiko-outbox-223579@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] dm-verity: add messages to prefetch and drop the
 hash cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, agk@redhat.com, bmarzins@redhat.com, mpatocka@redhat.com, snitzer@kernel.org, okozina@redhat.com, zkabelac@redhat.com, dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
In-Reply-To: <20261119163110.1630269-7-yangyongpeng.storage@gmail.com>
References: <20261119163110.1630269-2-yangyongpeng.storage@gmail.com>
 <20261119163110.1630269-7-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:50:03 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] dm-verity: verity_prefetch_hash() races with suspend and breaks
  quiescence
--

commit d29b7b5d122e67887bc98258e3fe7f3b2d2db059
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-verity: add messages to prefetch and drop the hash cache

This commit adds prefetch_hash and drop_hash target messages to warm or
drop hash blocks in the dm-verity bufio cache.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 44b95dbdaebbc..622c427949a35 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1828,12 +1828,117 @@ static void verity_postsuspend(struct dm_target =
*ti)
>  	verity_security_clear_integrity(ti);
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

[Severity: High]
Can verity_prefetch_hash() race with verity_postsuspend() or run while the
device is suspended?

target_message() in drivers/md/dm-ioctl.c only takes the SRCU read lock via
dm_get_live_table() and does not take md->suspend_lock or check whether the
device is suspending or suspended.  In dm_suspend(), __dm_suspend()
completes synchronize_srcu(&md->io_barrier) before calling
dm_table_postsuspend_targets() -> verity_postsuspend().

CPU0                                  CPU1
target_message()
  verity_message()
    verity_prefetch_hash()
      __dm_bufio_prefetch()
        dm_bufio_lock(c)
        b =3D __bufio_new(...)
          b->hold_count =3D 1
        dm_bufio_unlock(c)
                                      dm_suspend()
                                        __dm_suspend()
                                        verity_postsuspend()
                                          dm_bufio_client_reset(v->bufio)
                                            drop_buffers()
                                              cache_iterate(..., warn_leak)
                                              WARN_ON(cache_count(...))
        submit_io(b, ...)
        dm_bufio_release(b)  <-- use-after-free if
                                 CONFIG_DM_DEBUG_BLOCK_STACK_TRACING

While __dm_bufio_prefetch() drops dm_bufio_lock(c) across submit_io() and
dm_bufio_release(), b remains in c->cache with hold_count =3D=3D 1.  A
concurrent dm_bufio_client_reset() skips b in __get_unclaimed_buffer(),
triggers the leak WARN_ONs in warn_leak() and drop_buffers(), and under
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING zeroes b->hold_count and frees b while
CPU0 still holds it.

Also, contrary to the documentation note in verity.rst, v->bufio is bound
to v->hash_dev->bdev rather than the top-level DM device, so calling
prefetch_hash while suspended submits read bios directly to the underlying
hash device instead of queueing them until resume, breaking the suspend
quiescence fixed by commit 2de510fccbca ("dm-verity: fix
prefetch-vs-suspend race").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119163110.1630=
269-2-yangyongpeng.storage@gmail.com?part=3D4
