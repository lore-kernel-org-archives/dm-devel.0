Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024675;
	b=iB10wlrpndPvmJEto+lyXYPaTxggDiNtWwLquI0t78mtOl7QFIb4e8PcPPPNisOrFZ28
	 aOouuz39bYVE5MrsV+dtJaPFsFTBiwlceDoPfKkKtOuqgx+uykRcq/BhsouT3EczsLXVZ
	 66I8mMp2PQGWb2oBp3Ww0RrLibw7aHggnDGKBs4/h9FRHOiRG3cHxtkDu/jRjkqC09mE+
	 S4v1rO/k4HiTyzqXsEmXqgMXLKgAzAPlulsFmeIWjK/Y7sjIdQgv9IbP4dRZM6SJpmXVz
	 FerkvhJIMRvyBOQVGM8PBgCie0MXrEC68GpTmKA/I52tjA5pgJs0tm7zrPyRB5ddKxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024675;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=svj0BHG168+ZLom5aMPF2ldJYlU9TXd2YpuIAAYm1vY=;
	b=i1cqSYngufxg7TAVuvX3D1IPdEW03tj3IkvX+kUCVcnxFCGPVLNZj+SLgQPMjGkvZhzz
	 lMucAE+aCnbaQA9om0sLMh0LqgrqDmDwBBfI1YZzvdPnAltxQRoecrtVVThdZlcskCCpJ
	 OKVxP2WzHKkd3oS5e50m3mto6Q+HXY+AUycGLFwZbYAs0/HXAR6ze5amyWOEOgn9Rq1m6
	 oGsQe4972oNHLEUVW2ets+Ojz1jRCX3gBgoCDFN+RtyqKzUY8FKGfQYWMGqYIm5rYO59t
	 saLl1GKRBa/bteMZzUNWtpOvx0WTo8HX31cZh+rdKTsAMOlAkAbojFPKq1X1YTSgJUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUwbD8Nt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB5F606A31C
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUwbD8Nt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B4E1F000C5;
	Wed, 18 Nov 2026 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024675;
	bh=svj0BHG168+ZLom5aMPF2ldJYlU9TXd2YpuIAAYm1vY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KUwbD8NtRLB7cf/Zqax1RbBzg2JJb7565695lsdzoYuoy6Zer+FXMt5fBeP9zvVzy
	 s1h7sr1FZj0JaBlBPugQ/CZmcxBuVS6QKr5WF/nyN+pdq1jq5Df87xRaleUb3BeKM3
	 ICGTYN9HIGv8GCA4+z070fJYJuAJ9pxg6fJlZjpmRLpKG2O3nGXmd0kr9+eyuajiX+
	 icpKBwnZ3cwcEt5ujBiz6W0oVoe1ZexhdYI0HHMq9MNm1Vxyz7ic3+gIUllBadoeem
	 VZEurgEnKa2q6FOtnJKs5cxRFCWp2F+XrEvYv+5KT5tlmPGCQKCW22OB4tjFjaaA1M
	 0BkQl4pmHnvQQ==
Message-ID: <sashiko-outbox-221706@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] dm-bufio: allow exposing a client in sysfs under
 a caller-chosen kobject
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, mpatocka@redhat.com, snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
In-Reply-To: <20261118172133.689163-4-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
 <20261118172133.689163-4-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:57:54 +0000
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
- [High] dm-bufio: sysfs client exposure retained despite maintainer
  direction
- [Medium] dm-bufio: module unload race in dm_bufio_kobj_release()
- [Low] dm-bufio: undocumented dm_bufio_client_sysfs_detach() and
  lifetime claims
--

commit a1c1b2bd57f6306f0bce7f21a188c32909bec5c3
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject

This commit adds dm_bufio_client_sysfs_add() and
dm_bufio_client_sysfs_detach() to expose a dm-bufio client's attributes and
writable retain_bytes target in sysfs under a caller-supplied kobject.

> diff --git a/Documentation/ABI/testing/sysfs-kernel-dm-bufio b/Documentat=
ion/ABI/testing/sysfs-kernel-dm-bufio
> new file mode 100644
> index 0000000000000..bccd679c1b607
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
> @@ -0,0 +1,76 @@
> +What:		/sys/block/<dm-device>/dm-bufio/<name>/
> +Date:		November 2026
> +KernelVersion:	7.4
> +Contact:	dm-devel@lists.linux.dev
> +Description:
> +		Directory exposing one dm-bufio client whose user opted in
> +		through dm_bufio_client_sysfs_add().  <name> is chosen by that
> +		user; dm-verity, which places the directory under the block
> +		device of its own dm device, uses <name> "hash" for the hash
> +		tree client, "fec" for the FEC parity client and "fec-data"
> +		for the FEC data client.  The directory lives from
> +		registration until the client is destroyed, independently of
> +		any device-mapper table loaded on the device, so a suspend or
> +		table reload never leaves dangling entries behind.  The
> +		read-only counters are instantaneous snapshots and may be
> +		approximate.

[Severity: High]
As reported by Mikulas Patocka on v1 [1], should dm-bufio clients be
exposed in sysfs at all?

Multiple targets in a device-mapper table would clash under the same
/sys/block/<dm-device>/dm-bufio/ directory, and reloading a table creates a
new dm_bufio_client and discards any retain_bytes value configured in
sysfs.  The maintainer requested configuring dm-bufio parameters through
device-mapper target messages or constructor arguments instead.

[ ... ]

> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 367f878c17dc1..a2991dcd532fb 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
[ ... ]
> @@ -2505,6 +2511,165 @@ static unsigned long dm_bufio_shrink_count(struct=
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
Can dm-bufio.ko be unloaded while dm_bufio_kobj_release() is still
executing?

CONFIG_DM_BUFIO is tristate, and when the release callback runs
asynchronously (for example via kobject_delayed_cleanup() under
CONFIG_DEBUG_KOBJECT_RELEASE=3Dy, or when another task drops the last kobje=
ct
reference), the caller waiting in dm_bufio_kobj_del() unblocks as soon as
complete() is called:

CPU0                              CPU1
dm_bufio_client_destroy()
  dm_bufio_kobj_del()
    kobject_put(&c->kobj)
    wait_for_completion()
                                  kobject_release()
                                    dm_bufio_kobj_release()
                                      complete(&c->kobj_unregister)
                                      <preempted>
  kfree(c)
sys_delete_module("dm_bufio")
                                      return;  <-- unmapped module text

2995fa78e423 ("dm sysfs: fix a module unload race") added
dm_kobject_release() in drivers/md/dm-builtin.c (always built into vmlinux
when CONFIG_BLK_DEV_DM is enabled) so kobject release callbacks that signal
a completion do not reside in unloadable module text.

> diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
> index 9bf3f805c43c2..ac168ac797e4f 100644
> --- a/include/linux/dm-bufio.h
> +++ b/include/linux/dm-bufio.h
[ ... ]
> @@ -165,6 +166,14 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_cl=
ient *c, unsigned int n);
>  void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long =
bytes);
>  unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
> =20
> +/*
> + * Publish the client as <name> under <parent> in sysfs; removed in
> + * dm_bufio_client_destroy().
> + */
> +int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject =
*parent,
> +			      const char *name);
> +void dm_bufio_client_sysfs_detach(struct dm_bufio_client *c);

[Severity: Low]
This comment, the commit message, Documentation/ABI/testing/sysfs-kernel-dm=
-bufio,
and Documentation/admin-guide/device-mapper/dm-bufio.rst all state that the
sysfs directory lives from registration until the client is destroyed in
dm_bufio_client_destroy(), without mentioning dm_bufio_client_sysfs_detach()
or that dm_bufio_client_sysfs_add() can re-attach a detached directory
across suspend and table reload.

[1] https://lore.kernel.org/r/d4fc9150-4768-f747-ca97-688bc9bebc46@redhat.c=
om

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118172133.6891=
63-2-yangyongpeng.storage@gmail.com?part=3D2
