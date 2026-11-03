Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695211;
	b=gM+ZR4QzOwjGtpoWb+VcrJaPXiq8wYun2G+JMabq0GA3LLrBW+DlBLAImXYzQ9N7qviG
	 MN+XKE7s+H87lONExlefk6/Z+4BAiqD8+EVw7QJ6O8qhALeWWIdhWQFlNxN+vNtbCHAzr
	 OtrPlR9Q7+K7BeQ02eME0KLFptwc4zaOBn6bmcBM8hrjoPTfnYufEP4yqytZkqILtRXEL
	 3FuZ0YQY5IuMh6VgNQjUXY+Atw/ZXCl2cqsKbexu1zkb+Ef1UC8RNkf9YbnHTYIQiMt8D
	 LjrW5Bapykw6cTg9ATPdlGXVabS0Ub2TibND7ccOEViOa8/dg81KlQWjNcbTA/dNJDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695211;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FPZA4U3Q8VMbAYV4FCZfrPlCPt9bGNvwsJ9yOGXCYLE=;
	b=xfcQVclyX9h7f1AuySOt8X45Qz/7Diyw+Xk3xcpdMYp5mfn9a/yVaABGRorJpfrCYpzs
	 Z/lGmwAkAOr493pv6WCP3HjF8W+t8bLI/i0fpT6PRgmZ4gYJAa/7/nRgBbQHYY+rbrqXU
	 JUqSR8ca98Z195nsfaKdm4K9EjxvEURFxB/ypUQSMO0golL/f1r2uYtrJaNzGpqSlSC5B
	 2XRGrrB5suezZtdmQZdCsJb+hs4lKqZKWJzyBWpLcHlSiVs+0nOn5VVhFUbXvAT7aPQku
	 VUB7wkCgLO1kw+Q8z/4TCf7or0e87qpUXoKGXQvOC2jxRVATk6W6QYccA4glkviLIMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fsqGm/H5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3C0606A337
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 08:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fsqGm/H5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980DB1F000C1;
	Tue,  3 Nov 2026 08:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695211;
	bh=FPZA4U3Q8VMbAYV4FCZfrPlCPt9bGNvwsJ9yOGXCYLE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fsqGm/H56AYjEAQ54y2/6YmXX0KMBybzK47I+K+I49INOkBFmi11emBJlZ35io4Q9
	 +6PXe+RxF1LSM0raJCeThkeK9/ZfdhR8H1tFsrtv2NJgxtxCDvwuuf4XKzIB12pH/w
	 pVyDDWEsdooixuf0MWx5ICMj9ny/TqbqC3ffpzbvx8Lv87FjwHHNskbVazZRtQT29r
	 ZQNP1DAoulGcUZFzXbAdLmki6V3RWYW7sugb55r6hxyGZNPp/CJEEaSVV4Okk7R8xM
	 UzkDMAyPUtDLQM5ufEyDD/EluRATpU3CVOTSdZe/vRi7UzV/koBMSjs646k8Gej92S
	 jwQLWQ1VpZwXg==
Message-ID: <sashiko-outbox-194850@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm: release the sysfs kobject when its initialization
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: bmarzins@redhat.com, dm-devel@lists.linux.dev
In-Reply-To: <20261103082329.1159472-1-vulab@iscas.ac.cn>
References: <20261103082329.1159472-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:40:10 +0000
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
- [High] dm: double free and kobject re-init on dm_setup_md_queue() retry
--

commit ade936ffb3a2324034883b5668b49bcb6d404c6d
Author: Wentao Liang <vulab@iscas.ac.cn>

dm: release the sysfs kobject when its initialization fails

This commit calls dm_sysfs_exit() on the error path of dm_setup_md_queue()
when dm_sysfs_init() fails, so that the initialized kobject is released and
waited on before unwinding the disk and holder links.

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 1881d86111fb2..08b87fd6f955c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2647,8 +2647,10 @@ int dm_setup_md_queue(struct mapped_device *md, st=
ruct dm_table *t)
>  	mutex_unlock(&md->table_devices_lock);
> =20
>  	r =3D dm_sysfs_init(md);
> -	if (r)
> +	if (r) {
> +		dm_sysfs_exit(md);
>  		goto lock_out_undo_holders;
> +	}

[Severity: High]
What happens if dm_setup_md_queue() is retried on the same mapped_device
after dm_sysfs_init() fails and dm_sysfs_exit() runs?

In dm_sysfs_init(), kobject_init_and_add() calls kobject_init(), which sets
kobj->state_initialized =3D 1, and kobject_set_name_vargs(), which sets
kobj->name (heap-allocated via kstrdup() when dm-mod is built as a module,
since the string literal "dm" is in module rodata rather than core kernel
rodata).

If adding the kobject to sysfs fails, dm_sysfs_exit() calls kobject_put() a=
nd
waits for completion:

lib/kobject.c:kobject_cleanup() {
	...
	/* free name if we allocated it */
	if (name) {
		pr_debug("'%s': free name\n", name);
		kfree_const(name);
	}
}

kobject_cleanup() frees kobj->name via kfree_const(), but neither
kobject_cleanup() nor dm_sysfs_exit() clears kobj->name or
kobj->state_initialized.

Because dm_setup_md_queue() returns before setting md->type, md remains ali=
ve
with md->type =3D=3D DM_TYPE_NONE:

drivers/md/dm-ioctl.c:table_load() {
	...
	if (dm_get_md_type(md) =3D=3D DM_TYPE_NONE) {
		/* setup md->queue to reflect md's type (may block) */
		r =3D dm_setup_md_queue(md, t);
		if (r) {
			DMERR("unable to set up device queue for new table.");
			goto err_unlock_md_type;
		}
	}
}

If userspace retries DM_TABLE_LOAD on the same mapped_device, table_load()
calls dm_setup_md_queue() -> dm_sysfs_init() -> kobject_init_and_add() on t=
he
same embedded md->kobj_holder.kobj.

Won't kobject_init() complain that kobj->state_initialized is already 1 and
dump a stack trace, followed by kobject_set_name_vargs() calling
kfree_const(kobj->name) on the dangling pointer that was already freed duri=
ng
the first dm_sysfs_exit()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103082329.1159=
472-1-vulab@iscas.ac.cn?part=3D1
