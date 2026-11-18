Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024210;
	b=WJcwyYaJnLprfZXjhnuFG1+fl8jb0iWGecU/wSEThyaKByh2KjL/Do/8jMLBm20DStTN
	 TytYjOehsjnLIjLRWEmCcdYHakYJGsAFWDU8LKo0JSRbTrdC237zt2UApWJrZ3pw0sl8H
	 utIhBMj33vdrCa7NcMq7wfChDHslv2SPb3qWkkuj8U1jAQuEnNxyukad++P1sV5u3SOS6
	 VopHL/kMKsoVy9FL8pxwIUtuyl8YFeSJLryU7QtYB4TfbLkr3Ve8xAIf85egk7e7ENy4P
	 /C9XoHuLWDVSHlPaxM+tpfQD2+wflwqb6HjrsmQnppHtispxqWJo/cjrRBnBP5n/g7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024210;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Rs92g8oh63ocRbobUL6srNX8QyIraXRPUM6Ng1CO8HY=;
	b=ILyjY1n94ERSStmNNLa9ujiVJRwlrn/cFalLvH9Fp4cM+PMUBu2EMz5XsOJFVWVXDa4W
	 uQvlvJI0tgnkx3QD5/WLA2buKU39MpAXL0FkCbLL2auEB5ytJcQyLQ+jhVh+UxL8oXNDV
	 ADQf1oZ2qCph4U3XC2sbJA0U3yEoVkMWOPhPjztqJl+7rfk6jhS9venBnza1tOjeQi86a
	 +t/5wpAhoJl1lq7kgsDKNN4QslKfyY2RGUbCvprLJgXI+DP6WQUuQC3/n19BTBf7JeTvm
	 4RGXIZEZXpPDmwfb5u1uTzfT516etfLQ0OuNRU3s1XRmFOWu8V1F9Pc0o6ig8g+4jTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i/9US7YI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8762F606A320
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i/9US7YI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0949C1F000C5;
	Wed, 18 Nov 2026 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024210;
	bh=Rs92g8oh63ocRbobUL6srNX8QyIraXRPUM6Ng1CO8HY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i/9US7YIQGz8dueDxteDlos6KvYJAXdPIfk/fl88ZUEmg0M1BuPkIu6KGzXcoFSNr
	 2kQaY1zfxaPCO97dNgpXBcBHeugoXDBT9THtsVTCeBA3BqAfe1VzJzKkVRuwDwObE1
	 nnJW5mxW4K4WgGzzbLltr4GxUzyYv1BuJYxZlTpUzY80qqRVRR0bPhEGG4UU5JuSSg
	 NAUUsbjKKUoUg+Wkcm7UhLDfLakTECLOR5uueFAf4oMUL2nsWem5Bq+9AtqmIeFPFG
	 LRAsNtb5cPyrnfgk0cquiJivQvkZ44hVzaQ74jDq/k5HHEiE+ogfWuVhb795cLcLlv
	 F9U8Yfv8h1AJg==
Message-ID: <sashiko-outbox-221697@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] dm-verity: size the hash retain target from the
 hash area
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yongpeng Yang" <yangyongpeng.storage@gmail.com>, agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, mpatocka@redhat.com, snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
In-Reply-To: <20261118172133.689163-5-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
 <20261118172133.689163-5-yangyongpeng.storage@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:50:09 +0000
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
- [Low] dm-verity: missing return on kobject_add() error in
  verity_presuspend_undo()
- [Low] dm-verity: redundant post-definition
  verity_register_bufio_sysfs() prototype
- [Low] dm-verity: dead code and redundant kobject reallocation in
  verity_resume()
--

commit 2adf10b9bb56217937bcf599cad99cc4d02fedf6
Author: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm-verity: size the hash retain target from the hash area

This commit sets the default dm-bufio retain target for a dm-verity hash
client to a configurable percentage of the hash area and publishes the
dm-bufio clients in sysfs under /sys/block/dm-N/dm-bufio/.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 6d589867623c0..15dee27d58a7a 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c

[ ... ]

> @@ -1797,6 +1825,49 @@ static inline void verity_security_clear_integrity=
(struct dm_target *ti)
> =20
>  #endif /* CONFIG_SECURITY */
> =20
> +/* Detach the dm-bufio directories from sysfs, keeping the kobjects. */
> +static void verity_detach_bufio_sysfs(struct dm_verity *v)
> +{
> +	dm_bufio_client_sysfs_detach(v->bufio);
> +	if (verity_fec_is_enabled(v)) {
> +		dm_bufio_client_sysfs_detach(v->fec->bufio);
> +		dm_bufio_client_sysfs_detach(v->fec->data_bufio);
> +	}
> +
> +	if (v->bufio_kobj && v->bufio_kobj->state_in_sysfs)
> +		kobject_del(v->bufio_kobj);
> +}
> +
> +/*
> + * Free the directory names before a table reload resumes a new
> + * instance.  Presuspend runs before the queue is frozen, so the kernfs
> + * drain cannot block on I/O.
> + */
> +static void verity_presuspend(struct dm_target *ti)
> +{
> +	verity_detach_bufio_sysfs(ti->private);
> +}
> +
> +static void verity_presuspend_undo(struct dm_target *ti)
> +{
> +	struct dm_verity *v =3D ti->private;
> +	struct mapped_device *md =3D dm_table_get_md(v->ti->table);
> +	struct kobject *parent =3D &disk_to_dev(dm_disk(md))->kobj;
> +
> +	if (!v->bufio_kobj)
> +		return;
> +
> +	if (!v->bufio_kobj->state_in_sysfs &&
> +	    kobject_add(v->bufio_kobj, parent, "%s", "dm-bufio"))
> +		DMERR("cannot re-attach dm-bufio sysfs directory");
> +
> +	(void)dm_bufio_client_sysfs_add(v->bufio, v->bufio_kobj, "hash");
> +	if (verity_fec_is_enabled(v)) {
> +		(void)dm_bufio_client_sysfs_add(v->fec->bufio, v->bufio_kobj, "fec");
> +		(void)dm_bufio_client_sysfs_add(v->fec->data_bufio, v->bufio_kobj, "fe=
c-data");
> +	}
> +}

[Severity: Low]
Should verity_presuspend_undo() return early when kobject_add() fails to
re-attach v->bufio_kobj?  Falling through passes the unattached
v->bufio_kobj (with a NULL kernfs node) as the parent to
dm_bufio_client_sysfs_add(), causing each child registration to fail with
-ENOENT and emit additional kobject error messages.  Also, the client
registration sequence here duplicates verity_register_bufio_sysfs().

>  static void verity_postsuspend(struct dm_target *ti)
>  {
>  	struct dm_verity *v =3D ti->private;
> @@ -1806,6 +1877,53 @@ static void verity_postsuspend(struct dm_target *t=
i)
>  	verity_security_clear_integrity(ti);
>  }
> =20
> +/*
> + * Publish the bufio clients under /sys/block/dm-N/dm-bufio/.  This runs
> + * from ->resume, not ->ctr, because the dm device's block device does n=
ot
> + * exist until the table is loaded.
> + */
> +static void verity_register_bufio_sysfs(struct dm_verity *v)
> +{
> +	struct mapped_device *md =3D dm_table_get_md(v->ti->table);
> +	struct kobject *parent =3D &disk_to_dev(dm_disk(md))->kobj;
> +
> +	if (v->bufio_kobj)
> +		return;
> +
> +	v->bufio_kobj =3D kobject_create_and_add("dm-bufio", parent);
> +	if (!v->bufio_kobj) {
> +		DMERR("cannot create dm-bufio sysfs directory");
> +		return;
> +	}
> +
> +	if (dm_bufio_client_sysfs_add(v->bufio, v->bufio_kobj, "hash"))
> +		DMERR("cannot register hash bufio client in sysfs");
> +
> +	if (verity_fec_is_enabled(v)) {
> +		if (dm_bufio_client_sysfs_add(v->fec->bufio, v->bufio_kobj, "fec"))
> +			DMERR("cannot register FEC bufio client in sysfs");
> +		if (dm_bufio_client_sysfs_add(v->fec->data_bufio, v->bufio_kobj, "fec-=
data"))
> +			DMERR("cannot register FEC data bufio client in sysfs");
> +	}
> +}
> +
> +static void verity_resume(struct dm_target *ti)
> +{
> +	struct dm_verity *v =3D ti->private;
> +
> +	if (v->bufio_kobj) {
> +		/* detached by presuspend, or re-attached by presuspend_undo */
> +		if (v->bufio_kobj->state_in_sysfs)
> +			kobject_del(v->bufio_kobj);
> +		kobject_put(v->bufio_kobj);
> +		v->bufio_kobj =3D NULL;
> +	}
> +
> +	verity_register_bufio_sysfs(v);
> +}

[Severity: Low]
Why does verity_resume() drop and reallocate v->bufio_kobj instead of
re-attaching it?

The commit message notes that presuspend keeps the kobjects until the
table is destroyed, and verity_register_bufio_sysfs() checks if
v->bufio_kobj is already allocated, which is dead code because
verity_resume() is its only caller and always clears v->bufio_kobj first.
In addition, if v->bufio_kobj->state_in_sysfs were ever set on entry to
verity_resume(), calling kobject_del(v->bufio_kobj) without detaching the
child client kobjects first would leave their state_in_sysfs flags set and
cause the subsequent dm_bufio_client_sysfs_add() calls to fail with
-EBUSY.

> +
> +static void verity_register_bufio_sysfs(struct dm_verity *v);

[Severity: Low]
This isn't a bug, but this forward declaration of
verity_register_bufio_sysfs() is placed after both its definition and its
caller.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118172133.6891=
63-2-yangyongpeng.storage@gmail.com?part=3D3
