Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194510;
	b=vlSbkzjzIRHjq/8L/roUrNjYsC2gFP2WoeP+TRp5mZFs+yxDo2KNYI6WfhvfMNamwL4J
	 fr5mWrRNQ1QkffHHVDatsHdeETY75izInhsF0bnHC7z2JFxlBKZ+AptCQhas/l1hTOw66
	 zLEdwuWDgYHfg3x9F6sJf6aF3jd9gadMCR1o9XAnBlSn2tUaObINRRswBycc4V7vU9lh1
	 bmqACB3f7LlPKKjZ3RGv6TyqKV7xK2JgqDORBjTrLrQv59tHtg+xnS6Ic1SKZXbeUMEKs
	 n+SIdgb/qKxnNOiGDuWkHan/pCHuqkL8Y+B5QEwxGdQ06W06955HUgkWs6/2yxL32WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194510;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MLubieIZakhvQCD9QssGY4reTRZXE0jARP2ANL06kB0=;
	b=e1kXMxWGpnCqHdsqaJS3BkXBlpMn0cRpY72YvuyQ0+eHVpDkIB/if5haQ/vI0s2RQz7H
	 2yTig/QULizz4MvebZoK81dNwOTslgu+7MLrw6qLUCRfuVyC6Le4uzKtstNUHWuVCxgij
	 z9lHnJfvLnnQ7B9yiiW+b6DJgcGOnkbryvqGSlu25LQUWVBJ4RBAuJFX5nj5EmHV/FaRV
	 FJby2m7ui0NHriC5JkPtzZ0phj6UU6GMk5F7AmY76lxNuV2qiJnCHQEFRjP6hrTPJx6J+
	 7/008hw+Heg1UeHaki7xYtotA9y9Gq4uo3c6DF+fvGwSG0D5RJ2ayrQ5XNDMPn/b2qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i45tSyvP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D22606A31C;
	Mon,  9 Nov 2026 03:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i45tSyvP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150871F0089F;
	Mon,  9 Nov 2026 03:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794194509;
	bh=MLubieIZakhvQCD9QssGY4reTRZXE0jARP2ANL06kB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i45tSyvPL1BGVqQl0k89W39r8COhcc5jdq7K4bWkZgesrOvri5eDD932Fh1N1uLGC
	 Sp1ChRtdwLe5kRZpJRYP9e0Fb7JgnhCkQJr17t1nzTa3sIbhRva0TeU9W6hpPdkiQM
	 1bZSkI7O7CQ8zq5+2bXvasJpcbSIDM/PLDZKWP+NIBJ9JDAIx4G4XrQlimTfJbnpGm
	 e6/pzxL/YyQLRVywueRGnFdTiO54uOJFxFqgcPLb2WvXPMktZZcx6KOio2+g5kN48H
	 ntR2/ybkM084EPu9lOXmB16WsYAnrMuAkPz7ghqUuLbuR1FAbw6ZCnzwJvQ2xjhFdC
	 1zwnmEbmCNi3w==
Message-ID: <sashiko-outbox-204370@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: validate raid_disks range before loading
 personality
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ran Hongyun" <ranhongyun1@huawei.com>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com, song@kernel.org, yukuai@fygo.io
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, chengzhihao1@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com
In-Reply-To: <20261109025621.2031722-1-ranhongyun1@huawei.com>
References: <20261109025621.2031722-1-ranhongyun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 03:21:48 +0000
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
- [High] md: md_run() cap at MAX_RAID_DEVICES breaks valid arrays with >
  253 disks
- [Medium] md: unchecked delta_disks in md_run() allows OOM warn and
  divide-by-zero
- [Medium] md: missing raid_disks upper bound in update_raid_disks() on
  online reshape
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Medium] md/raid1: missing raid_disks upper bounds check in
  raid1_reshape() [1]
--

commit fc41ec678e6b01e865c547317a0225da7de795ee
Author: Ran Hongyun <ranhongyun1@huawei.com>

md: validate raid_disks range before loading personality

This commit moves MAX_RAID_DEVICES (253) from dm-raid.c to md.h and rejects
mddev->raid_disks values outside [1, MAX_RAID_DEVICES] in md_run() before
invoking the personality run callback.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..7b202b483e98c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6703,6 +6703,13 @@ int md_run(struct mddev *mddev)
>  			return -EINVAL;
>  	}
> =20
> +	if (mddev->raid_disks <=3D 0 ||
> +	    mddev->raid_disks > MAX_RAID_DEVICES) {
> +		pr_warn("md: %s: raid_disks %d out of range [1, %d]\n",
> +			mdname(mddev), mddev->raid_disks, MAX_RAID_DEVICES);
> +		return -EINVAL;
> +	}
> +
>  	if (mddev->level !=3D LEVEL_NONE)
>  		request_module("md-level-%d", mddev->level);
>  	else if (mddev->clevel[0])

[Severity: High]
Does capping mddev->raid_disks at MAX_RAID_DEVICES (253) in md_run() break
assembling valid native MD arrays with more than 253 member devices?

MAX_RAID_DEVICES was a dm-raid target limit, whereas native MD v1.x
superblocks support up to 384 devices in a 1 KiB superblock and up to 1920
devices in a 4 KiB superblock:

drivers/md/md.c:super_1_validate() {
	...
	mddev->max_disks =3D  (4096-256)/2;
	...
}

In addition, raid6_takeover() converts a 253-disk RAID5 array into a
254-disk RAID6 array by incrementing mddev->raid_disks to 254, which
md_run() will now refuse to assemble with -EINVAL.

[Severity: Medium]
When an array is started with an active reshape (mddev->reshape_position !=
=3D
MaxSector), can an unvalidated mddev->delta_disks bypass this check and
still trigger the oversized allocations or a divide-by-zero?

On an inactive array, writing a large value to sysfs raid_disks, setting
reshape_position, and then writing a small valid value to raid_disks (or
loading a superblock with a crafted delta_disks) leaves mddev->raid_disks
within [1, MAX_RAID_DEVICES] while mddev->delta_disks is arbitrarily
negative.  raid5 setup_conf() and raid10 setup_conf() size their disk
allocations from mddev->raid_disks - mddev->delta_disks:

drivers/md/raid10.c:setup_conf() {
	...
	conf->mirrors =3D kzalloc_objs(struct raid10_info,
				     mddev->raid_disks + max(0, -mddev->delta_disks));
	...
}

This still hits the MAX_PAGE_ORDER warning (and overflows a signed int if
mddev->delta_disks =3D=3D INT_MIN).  Furthermore, if mddev->delta_disks equ=
als
mddev->raid_disks, conf->prev.raid_disks (mddev->raid_disks -
mddev->delta_disks) becomes 0 and raid10_run() -> enough() -> _enough()
divides by zero at (this + 1) % disks.

Checking that mddev->raid_disks - mddev->delta_disks is also within the
valid range when mddev->reshape_position !=3D MaxSector would close this ga=
p.

[Severity: Medium]
Does online reshape via update_raid_disks() bypass md_run() and leave
raid1, raid5, and raid10 exposed to the same unbounded allocations?

When reshaping an already-running array via sysfs raid_disks or
ioctl(SET_ARRAY_INFO), raid_disks_store() and update_array_info() call
update_raid_disks() directly without going through md_run():

drivers/md/md.c:update_raid_disks() {
	...
	if (raid_disks <=3D 0 ||
	    (mddev->max_disks && raid_disks >=3D mddev->max_disks))
		return -EINVAL;
	...
	mddev->delta_disks =3D raid_disks - mddev->raid_disks;
	...
	rv =3D mddev->pers->check_reshape(mddev);
	...
}

When mddev->max_disks is 0 (such as on non-persistent or external-metadata
arrays), any positive raid_disks up to INT_MAX is accepted and passed to
pers->check_reshape(), hitting the MAX_PAGE_ORDER and INT_MAX allocation
warnings in raid1_reshape(), raid10_check_reshape(), and raid5
check_reshape().

[Severity: Medium]
This problem wasn't introduced by this patch, but raid1_reshape() [1]
lacks an upper bounds check on raid_disks when reshaping a running array
with mddev->max_disks =3D=3D 0:

drivers/md/raid1.c:raid1_reshape() {
	...
	raid_disks =3D mddev->raid_disks + mddev->delta_disks;
	...
	new_r1bio_size =3D offsetof(struct r1bio, bios[raid_disks * 2]);
	newpool =3D mempool_create_kmalloc_pool(NR_RAID_BIOS, new_r1bio_size);
	if (!newpool) {
		return -ENOMEM;
	}
	newmirrors =3D kzalloc(array3_size(sizeof(struct raid1_info),
					 raid_disks, 2),
			     GFP_KERNEL);
	...
}

Because update_raid_disks() does not bound raid_disks when mddev->max_disks
is 0, a large raid_disks value overflows raid_disks * 2 in signed 32-bit
arithmetic or exceeds KMALLOC_MAX_SIZE in mempool_create_kmalloc_pool() and
kzalloc(), triggering a slab warning in ___kmalloc_large_node().

[1] https://sashiko.dev/#/bug/linux-9d642fe4-31fe-4998-ac3d-c07a30507ae7

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025621.2031=
722-1-ranhongyun1@huawei.com?part=3D1
