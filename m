Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792693904;
	b=qELKGiYz7xrBjjcPSU/xWrEs6aGeVaGyeNrIKsc+oqokjfhkRpuA/5OesGtcZl8cYa81
	 eBHdiAzRVDfNrbPZYdP7Vz5d7OPcaaeOsMaNaJEEjK9F8jB70UnXVvbHQXaJqEkhY7YUW
	 sUAgfay1iZGH77rWrCJ3SlfZRFOTW6ix9R0qLEfZZ5AgO7DxxoDIihIRlz2pVSLWHpIL5
	 8Lm6woTBWVER6rZSGoGZ9J1LHptbtoilYz1nKSd8WNpt4kmHLjsS1a6Yl42fAHITDLavQ
	 547YESlCimNxoPxO/9dCqmgLYDOdPF5sU7+KbYXFQCwqZJg7dEkHP/KB+2LjD0nXPyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792693904;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MrM4N5zcsDzh05bxNdVa4RxgArim1I9tvL+fmS+AbYE=;
	b=vhBfTDi30lizykYL8GE64aePZBIKm5RpTECxiR8QElGrs4K2SW+5rDTZ5kC0rFawW0ip
	 vDmeLilNM/X0O5P+jrqAaY1CvwKoFgdUVURmPzKYbqfSQQCL74QVZ3+VYI6vJK9aqWiAV
	 j8eGt2g+QNBLFz8wN2Uol/ne1gcrXCnTPf3tRHrK04JsqGc2n0xRhppSsRf+rNjsQWQn5
	 KP7w55mim1Lr2k6HBnHRXyrcWSxmLBh9nhKCkZrHh6oUqoU6h03yTn0uHOMhFxGyHSEL+
	 jzCETxxLqo7dHCOqiBjKgT07jD1rwUqWyCY+vkRy5U2tGUutAP4nP9mDcB6jA7L1sqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fet5DSNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C6F606B7EA
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fet5DSNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FE41F031E2;
	Thu, 22 Oct 2026 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792693903;
	bh=MrM4N5zcsDzh05bxNdVa4RxgArim1I9tvL+fmS+AbYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fet5DSNO8vgcjQkxGhVeh9PeLfxeMozxUxbmOBGTJiK1GY01JrqAHCRWZDXg4Vw27
	 WguY1t5kMrxNxvcrmz6tb8up434z2TgsJaQ/C9zCcuKSrEnaT2ZUQYCBLrrJqmcmNA
	 SoX6KqCkY1UEran/jCwgfgbfU5xubtxWUxRGYqyyfJbdaa0sgvVfj2Kk5R3hwk6WDU
	 SoHb1xvgBhWwMXad01Tz4GRv2OMndC3nfB0hJchfqvhvZFzO8teoPKO628untme3iO
	 QN9qnZnsQTSEr7c35yhCyjSE+7uiF3WE1YtTkYnDsMoWBCC7EzK+vCswHBgNm1LdRR
	 hQwhkqHAEsatw==
Message-ID: <sashiko-outbox-181921@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-raid: bound array_position before indexing
 failed_devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jay Vadayath" <jay@artiphishell.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
In-Reply-To: <20261022181934.35685-1-jay@artiphishell.com>
References: <20261022181934.35685-1-jay@artiphishell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 18:31:42 +0000
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
- [High] dm-raid: wrong role bound and continue bypass in super_init_valida=
tion()
--

commit 46b04454594856163e75cd4dccd01fd7ff3efea6
Author: Jay Vadayath <jay@artiphishell.com>

dm-raid: bound array_position before indexing failed_devices

This commit bounds the on-disk array_position (role) by rs->raid_disks in
super_init_validation() before using it as a bit index into the on-stack
failed_devices bitmap.

> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index ac019a0f5a929..b973181bdce24 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -2420,7 +2420,8 @@ static int super_init_validation(struct raid_set *r=
s, struct md_rdev *rdev)
>  		 */
>  		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >=3D 0)) {
>  			role =3D le32_to_cpu(sb2->array_position);
> -			if (role < 0)
> +			/* Bound @role before it indexes the failed_devices stack bitmap. */
> +			if (role < 0 || role >=3D rs->raid_disks)
>  				continue;

[Severity: High]
Does using continue when role >=3D rs->raid_disks in
drivers/md/dm-raid.c:super_init_validation() introduce two regressions duri=
ng
table load (dm_ctl_ioctl() -> table_load() -> dm_table_add_target() ->
raid_ctr() -> analyse_superblocks() -> super_validate() ->
super_init_validation())?

First, the commit message states that this change rejects anything outside
[0, rs->raid_disks), but executing continue only skips the remainder of the
per-rdev loop body and allows super_init_validation() to return 0:

drivers/md/dm-raid.c:super_init_validation() {
    ...
		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >=3D 0)) {
			role =3D le32_to_cpu(sb2->array_position);
			/* Bound @role before it indexes the failed_devices stack bitmap. */
			if (role < 0 || role >=3D rs->raid_disks)
				continue;

			if (role !=3D r->raid_disk) {
				...
				} else if (!(rs_is_raid10(rs) && rt_is_raid0(rs->raid_type)) &&
					   !(rs_is_raid0(rs) && rt_is_raid10(rs->raid_type)) &&
					   !rt_is_raid1(rs->raid_type)) {
					rs->ti->error =3D "Cannot change device positions in raid set";
					return -EINVAL;
				}
    ...
}

Because r->raid_disk is in [0, rs->raid_disks), any device with
role >=3D rs->raid_disks has role !=3D r->raid_disk. Previously, on raid le=
vels
that forbid device reordering (such as raid4/5/6 or raid10 far/offset), a
device with role in [rs->raid_disks, 255] entered the role !=3D r->raid_disk
block and failed validation with return -EINVAL. With this continue, should=
n't
an out-of-bounds role return -EINVAL instead of silently bypassing both the
device reordering check and the failed_devices check?

Second, is rs->raid_disks the right upper bound for role here? In
super_init_validation(), role is the device's previous position in the
on-disk array of size mddev->raid_disks (le32_to_cpu(sb->num_devices)), and
failed_devices is indexed by that previous role, whereas rs->raid_disks is
the device count of the newly loaded table.

dm-raid allows loading tables with rs->raid_disks < mddev->raid_disks when
removing legs from a raid1 array without delta_disks or when removing mirror
copies from a raid10_near array:

drivers/md/dm-raid.c:rs_prepare_reshape() {
	if (rs_is_raid10(rs)) {
		if (rs->raid_disks !=3D mddev->raid_disks &&
		    __is_raid10_near(mddev->layout) &&
		    rs->raid10_copies &&
		    rs->raid10_copies !=3D __raid10_near_copies(mddev->layout)) {
			...
			__reorder_raid_disk_indexes(rs);
			...
		}
	...
	} else if (rs_is_raid1(rs)) {
		if (rs->delta_disks) {
			...
		} else {
			/* Process raid1 without delta_disks */
			mddev->raid_disks =3D rs->raid_disks;
			reshape =3D false;
		}
	}
}

When a non-trailing leg or mirror copy is removed so that rs->raid_disks <
mddev->raid_disks (for example, removing leg 0 from a 3-disk raid1 array so
old device 2 moves to r->raid_disk =3D 1 with rs->raid_disks =3D 2, or redu=
cing a
6-disk 3-copy raid10_near set to a 4-disk 2-copy set so old device 4 moves =
to
r->raid_disk =3D 3 with rs->raid_disks =3D 4), surviving devices legitimate=
ly
have rs->raid_disks <=3D role < mddev->raid_disks.

If role >=3D rs->raid_disks takes the continue branch, won't
super_init_validation() skip updating sb2->array_position for raid10_near a=
nd
skip testing failed_devices to set Faulty on a returning failed device,
preventing super_validate() from clearing In_sync and resetting
recovery_offset to 0?

> =20
>  			if (role !=3D r->raid_disk) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022181934.3568=
5-1-jay@artiphishell.com?part=3D1
