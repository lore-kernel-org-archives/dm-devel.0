Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922856;
	b=Fdzt/VXA3f9oZ6vy8yX/7j2b/R/bE0TkXbDHOXrjzSvIN6KT0gASM+KMUbRsj7fFJCiY
	 ESHG+bISA3302X9AK2lbezZ5GMnYz4xa49aBTijvHJPCpbgqWdiX8f7Rk7hpM6wZTwrlL
	 908ocNIensaQE77mpfhnBxiFGHdLHDBZIf8gKMrFE5jPGOc38wyXgC//EtqJgw/o/IYxf
	 y+jKVuJUXC4FfQFBPqvEKDc8WDuJK0MllnSKSGgJR/n2dtUxHEYkSS3feg05fzQ9y3z4n
	 wMLk1phF/N3til0lWXNF2FNBp9o2Ye9meaDbRE+2weIu9QHWFvYbXtYdHCM3bBS9IsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922856;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SPXkwQ3CPc8v6L5K1xlSNlGBY2mHwebgESsUOGn0H38=;
	b=XpA+UatoU24G7+9Y9jl3/DpJU05dzvj10FUi4t63OnSKYNEizAv3t5OzPR44E6j37ZPj
	 CtOMkKapOHMJT6FlIhb88Ylq6gMLvyT66gX3ghbJs9Ohtccia9kUxRS+FkIzGdVAmdFdF
	 /CDOehcMzBcDLirlVxr3JAiBMsJDBH3BghqOANqR5XAC1uBGhJ1pWkAMtEkPXHO4Tbjt+
	 45rET/sAWY+WNfz4b/KGU5KQc8vSfgxZVAX+s55QtSkI5iO1er8lRddeI/BoCVoL/jApD
	 BqyVawC6NC+LtbNWwGz36k0vc7k2uc0LqHUHOm7sBGK6xuDgUlHLrbbnKjgg+4fjmbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LO1bPbPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C0606A31C
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LO1bPbPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA061F000C4;
	Tue, 17 Nov 2026 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794922856;
	bh=SPXkwQ3CPc8v6L5K1xlSNlGBY2mHwebgESsUOGn0H38=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LO1bPbPoRg0PGFc5sfTKin5LYh6PRxf6+xXTwqY5xwicf2d2iP5//yXM0oB9nt7Yu
	 z8pvNbDofreqVfVE6OYvK3fUWcdftgAcGI+OtlilDcrbadNV6pG9K6+sN5UXy5y/xC
	 yb0mv+OkuTIe6bdumh9A+J18rY/g8ueBPJZ/uK4feqCgjVf+8wolJUyRk39A4BoKOy
	 aEbY2nlnAaOsL4pSdJBxSx8S834aHkQD1N0yVl2zKcHCOlGO2P0I74enzH3GXxDeT1
	 sLdF/eV1U4pWqJvb1GcbK2n6yPNTBM5PzsILWExbnlTcd5XQQ10oj8vE/nbg0Gb6Nv
	 DppVKm3bGSEng==
Message-ID: <sashiko-outbox-218893@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a
 caller-chosen kobject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, "Yongpeng Yang" <yangyongpeng@xiaomi.com>
In-Reply-To: <20261117131918.2745193-5-yangyongpeng.storage@gmail.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
 <20261117131918.2745193-5-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 13:40:55 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] dm-bufio: module unload race in dm_bufio_kobj_release()
- [Medium] dm-bufio: double free of kobj.name if
  dm_bufio_client_sysfs_add() is retried
- [Medium] dm-bufio: missing sysfs unregistration API breaks DM table
  reloads
--

commit 865aec6258e84e1a7aa1322dc0e3b22f9e5e966b
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject

This commit adds dm_bufio_client_sysfs_add() to expose per-client dm-bufio
statistics and the writable retain_bytes target in sysfs under a
caller-supplied kobject.

> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 75b6e5c027ae2..627a64f981c5c 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c

[ ... ]

> @@ -2504,6 +2510,144 @@ static unsigned long dm_bufio_shrink_count(struct=
 shrinker *shrink, struct shrin

[ ... ]

> +static void dm_bufio_kobj_release(struct kobject *kobj)
> +{
> +	struct dm_bufio_client *c =3D container_of(kobj, struct dm_bufio_client=
, kobj);
> +
> +	/*
> +	 * The client is freed only after this completes, as in dm-sysfs.
> +	 */
> +	complete(&c->kobj_unregister);
> +}
> +
> +static const struct kobj_type dm_bufio_ktype =3D {
> +	.sysfs_ops	=3D &dm_bufio_sysfs_ops,
> +	.default_groups	=3D dm_bufio_groups,
> +	.release	=3D dm_bufio_kobj_release,
> +};
> +
> +static int dm_bufio_kobj_add(struct dm_bufio_client *c, struct kobject *=
parent,
> +			     const char *name)
> +{
> +	init_completion(&c->kobj_unregister);
> +
> +	return kobject_init_and_add(&c->kobj, &dm_bufio_ktype, parent, "%s",
> +				    name);
> +}
> +
> +/* Drop the sysfs reference and wait for the release method to run. */
> +static void dm_bufio_kobj_del(struct dm_bufio_client *c)
> +{
> +	kobject_put(&c->kobj);
> +	wait_for_completion(&c->kobj_unregister);
> +}

[Severity: Medium]
Can dm-bufio.ko be unloaded while another task is still returning from
dm_bufio_kobj_release()?

CONFIG_DM_BUFIO is tristate, so dm_bufio_kobj_release() lives in
loadable module text.  If the last reference to c->kobj is dropped by
another context after dm_bufio_kobj_del() calls kobject_put() (for
example, a concurrent sysfs reader or kobject_delayed_cleanup()), that
context can be preempted right after complete(&c->kobj_unregister):

CPU0                              CPU1
dm_bufio_client_destroy()
  dm_bufio_kobj_del()
    kobject_put(&c->kobj)
                                  kobject_put(&c->kobj)
                                    dm_bufio_kobj_release()
                                      complete(&c->kobj_unregister)
                                      <preempted>
    wait_for_completion()
  kfree(c)
delete_module("dm_bufio")
                                      return;  <-- unmapped module text

dm-sysfs avoids this race by placing dm_kobject_release() in built-in
code in drivers/md/dm-builtin.c.

> +
> +int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject =
*parent,
> +			      const char *name)
> +{
> +	int r;
> +
> +	if (c->sysfs_added)
> +		return -EBUSY;
> +
> +	r =3D dm_bufio_kobj_add(c, parent, name);
> +	if (r) {
> +		dm_bufio_kobj_del(c);
> +		return r;
> +	}
> +
> +	c->sysfs_added =3D true;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(dm_bufio_client_sysfs_add);

[Severity: Medium]
Does retrying dm_bufio_client_sysfs_add() after a failed call double free
c->kobj.name?

When kobject_init_and_add() fails after kobject_init() and
kobject_set_name_vargs(), dm_bufio_kobj_del() runs kobject_cleanup(),
which calls kfree_const(c->kobj.name) without clearing c->kobj.name or
c->kobj.state_initialized.  Because c->sysfs_added remains false and
c->kobj is not zeroed on the error path, a second call to
dm_bufio_client_sysfs_add() on the same client triggers the
state_initialized warning in kobject_init() and then calls
kfree_const(kobj->name) on the dangling pointer in
kobject_set_name_vargs().

> @@ -2660,6 +2804,9 @@ void dm_bufio_client_destroy(struct dm_bufio_client=
 *c)
>  {
>  	unsigned int i;
> =20
> +	if (c->sysfs_added)
> +		dm_bufio_kobj_del(c);
> +
>  	drop_buffers(c);
> =20
>  	shrinker_free(c->shrinker);

[Severity: Medium]
How can a device-mapper target reload its table without colliding on the
sysfs directory when c->kobj is only removed in
dm_bufio_client_destroy()?

During a table reload in do_resume(), dm_suspend() suspends the old table
and dm_resume() resumes the new table before dm_table_destroy() destroys
the old table and its dm_bufio_client.  When a target registers its
clients under the device-level path /sys/block/<dm-device>/dm-bufio/<name>
(as documented in Documentation/ABI/testing/sysfs-kernel-dm-bufio and
used by dm-verity in commit "dm-verity: size the hash retain target from
the hash area"), the old table's sysfs entries are still present when the
new table resumes, so kobject_init_and_add() fails with -EEXIST and
triggers a dump_stack() warning in sysfs_warn_dup().  Without an exported
unregistration helper that targets can call during suspend, reloading a
table fails to publish the new client's sysfs directory and leaves the
device without /sys/block/<dm-device>/dm-bufio/ once the old table is
destroyed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117131918.2745=
193-2-yangyongpeng.storage@gmail.com?part=3D2
