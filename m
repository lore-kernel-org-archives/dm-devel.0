Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795251301;
	b=GGPRozDEEbT/fCA+uPMFmdiInKSCkbfpZKG4QTMryD2yezmhheYxUmVFEezRhC7u5NKE
	 9dRlKLUGmWbfkEGzvMQ1PPYzsihJ/VC5n+QZqJJIdORSPV7kRmbxNdIu/yR+W3M6htKqo
	 fDPNKvyn9iH+q1Axm+iiFrPqO6ufNPz6ojnJhfVOAHXpYE/DmoSicx4xrc1lcLSB+l32M
	 ZNB5Sp1Xg3/C3wL5xcmoWMvDSHZS64M73+Zi8QiulVgVqenJm8enCfVhnH3kj5rdZSVXz
	 tCPfrVZBh+drQEQ1L1dX6VlOCcnQBTlaR6oQ5RPRG7ogavBG4hZDm/DePDakpZB3A1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795251301;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z+DZAGgqbJC3G5OJTab45kuDm/qiqwh11hVtl/sIq0U=;
	b=zQeNjXwCWOgf4aO8erwQr4tt3zYKilZxtfQlNVP2wwLongVcA1Q9uaZJXGp7cc1ivAd+
	 bHeGRNTV3VmPKtPrsfd6ydMBHGIyS4ZGPB/x6dYbZo5UjaCtZlw8BGQzEb3Ld3Alr4GrP
	 C2QdrFW3RXyufOcMzb10VPHMHjRsi7XlVEKKILKw1b1ASAikTNveDnmaAZrKaXTGffpPd
	 gBppoCjRzkFtogFinhvdtHGzbPNEianoLMiX5qy1bzR234fX6dx65Pb20jqor17OKRjK+
	 QOCZ1UFjpujk3434Htfa7lRFIW40wvWbqiDJBgCKBdAwFjuYDL0PPJmfBYTtnbzrRWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6PQJgj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E0606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6PQJgj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A501F000C0;
	Sat, 21 Nov 2026 08:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795251300;
	bh=Z+DZAGgqbJC3G5OJTab45kuDm/qiqwh11hVtl/sIq0U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O6PQJgj66/xGMpLp1MQK5WVXmWmVZl5tjIZPWqqeqKlNAC4hCPfOjGWSCkujsPUst
	 JBvVTV727Bh3ysMaIX4t3ZjjzQ9OnTcAR2cn6J7kKT5/DAg0RpAl4n7qb8ZGrU4lV+
	 xnX6jmxeXSRH+VwfOoWTxq0SKxofFHySC7iE2gspp/QH9sziDGRdesOsL2Z6w/lWhw
	 CNJiIYi3u7FRmpnMNcTolhkaarFQ9WsT+XIuCv+bFfgZ8XfjGgoinMdj3rcHve7YF4
	 fHUJU2Q4MFgwD8h+riyU6hIngXycPRXkOD0Pbxs0zc1uOZtptQ6DWjOp5ZG13aoG7w
	 JVYzloUzG+mpA==
Message-ID: <sashiko-outbox-226847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/4] dm-verity: add messages to prefetch and drop the
 hash cache
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, agk@redhat.com, bmarzins@redhat.com, mpatocka@redhat.com, snitzer@kernel.org, okozina@redhat.com, zkabelac@redhat.com, dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
In-Reply-To: <20261121084119.3418879-6-yangyongpeng.storage@gmail.com>
References: <20261121084119.3418879-2-yangyongpeng.storage@gmail.com>
 <20261121084119.3418879-6-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:55:00 +0000
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
- [Medium] dm-verity: race between verity_message() and __dm_destroy()
  postsuspend
--

commit f3898ae3e053835b95d79be7c97db5541a15ab64
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-verity: add messages to prefetch and drop the hash cache

This commit adds the prefetch_hash and drop_hash target messages to
dm-verity to allow userspace to warm or evict blocks from the hash cache.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 44b95dbdaebbc..04a986c343666 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c

[ ... ]

> @@ -1885,6 +1990,21 @@ static int verity_message(struct dm_target *ti, un=
signed int argc, char **argv,
>  	if (!strcasecmp(argv[0], "retain_bytes"))
>  		return verity_retain_bytes(v, argc, argv, result, maxlen);
> =20
> +	/*
> +	 * prefetch/drop touch the bufio cache and the backing device, whose
> +	 * reads bypass the suspended dm queue: reject them while suspended.
> +	 */
> +	if (dm_suspended(ti)) {
> +		DMERR("message during suspend");
> +		return -EBUSY;
> +	}
> +
> +	if (!strcasecmp(argv[0], "prefetch_hash"))
> +		return verity_prefetch_hash(v, argc, argv, result, maxlen);
> +
> +	if (!strcasecmp(argv[0], "drop_hash"))
> +		return verity_drop_hash(v, argc, argv, result, maxlen);

[Severity: Medium]
Can verity_prefetch_hash() still race with verity_postsuspend() when an
active, unsuspended device is removed?

Unlike __dm_suspend(), __dm_destroy() sets DMF_SUSPENDED and immediately
calls dm_table_postsuspend_targets() without an intervening
synchronize_srcu(&md->io_barrier) and before waiting for md->holders to
drain:

drivers/md/dm.c:__dm_destroy() {
    ...
	if (!dm_suspended_md(md)) {
		dm_table_presuspend_targets(map);
		set_bit(DMF_SUSPENDED, &md->flags);
		set_bit(DMF_POST_SUSPENDING, &md->flags);
		dm_table_postsuspend_targets(map);
	}
    ...
}

Because target_message() only takes a holder reference (via find_device())
and does not increment md->open_count, removing an unmounted device via
dev_remove() while prefetch_hash is running allows verity_postsuspend() to
run concurrently with dm_bufio_prefetch():

CPU0                                  CPU1
target_message()
  dm_get_live_table()
  verity_message()
    dm_suspended(ti) -> false
    verity_prefetch_hash()
      dm_bufio_prefetch()
        __bufio_new()
          /* b->hold_count =3D=3D 1 */
        dm_bufio_unlock(c)
                                      dev_remove()
                                        __dm_destroy()
                                          set_bit(DMF_SUSPENDED, ...)
                                          dm_table_postsuspend_targets()
                                            verity_postsuspend()
                                              dm_bufio_client_reset()
                                                drop_buffers()
                                                  <-- fails eviction / WARN=
_ON
        submit_io(...)
        dm_bufio_release(b)

When drop_buffers() encounters the buffer held with hold_count =3D=3D 1 out=
side
dm_bufio_lock, eviction fails and triggers WARN_ON in warn_leak() and
drop_buffers() (or a use-after-free if CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
is enabled, where warn_leak() zeroes b->hold_count and drop_buffers() frees
b while __dm_bufio_prefetch() is still submitting I/O on it).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121084119.3418=
879-2-yangyongpeng.storage@gmail.com?part=3D4
