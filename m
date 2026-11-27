Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795740983;
	b=I9s3Cbh/0cPR4ruHaZDX19U2qtjWP7vAhlHNohRS5+nzWOSvdhRkVpgl2Md2xg7prh50
	 bzeoeyXivURbJxTlyrK/0CM+e/EfBaJ2Nv+nNYvIroVBTgdeFlxGlOmtMp7MsX376Je9k
	 /tWyBnE7UecAsEOJT/PYH6yYNAdOiqy4UdjhPR0diHP6JBn+G8eb81TVMRUsmj5uq0Qyb
	 jvHEPT0GN7W5ijC4EAuvgYz6iPEaXeHW9RuOeAkRGd1MbgALSzRk8HCHXZPkr8cBAOqy6
	 ruzUP8/H9NxsQjZWJMtf/pGDqre5QP3uDn/pibLudQn1L06XTh7CfbAXXNroLXSEB1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795740983;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=o+21jQKDDfiVTNFIRlUo9PWLi8sxY+x82+WzUJm5AYY=;
	b=EkM+LyAXJplJ51tjeo9RYhGksxiwyyVOmgIl2PZv2+ODxD8R26RoElduqgoc8PDGu8zL
	 cqHJSYHk3stqOx3biQwJr8oLISK5+EDHr2YT0D1/XJCh/3FVv7kTNxtHuYnDrvGzA4U/v
	 DFp0tOxw03Ny8VKrlinw1/4vtSi9foqRAMA1FTR3MAFvLRcXol/5J0FRYijLFvfQPvXgj
	 FJlNzGSA1ZdlmhXZgMnFjUrfsxf7IeXEFh3dubLUTRUhG1BQFUbBUYfd/YMS3SZHcyVPR
	 gKe4Pp29dKaRbmTQOxtGaaeMCwHN7KT8nIR5g3dd3fer9uZKMgEt3AdvVMc2JHgQAQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hchpHUkm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFF1606A32A
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hchpHUkm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A381F000C1;
	Fri, 27 Nov 2026 00:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795740983;
	bh=o+21jQKDDfiVTNFIRlUo9PWLi8sxY+x82+WzUJm5AYY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hchpHUkmGl7zWffElMK+P77WJjyI3qvshZTjR1GEW8bRgRSzcKwLt74VngbJ2pXWY
	 oA6p2WfAho3fzFpfxSyYMxMKfXUSBeIg1aACMTZf6x5tQetxFVKACuQRyr/zSCKFtT
	 kVuUNECgFhDCNe7rjEL3Vlsm5VPH9tHFieZ2ZNqqfibGxC70mRPmyBm8vqB0E4VzzH
	 JvKGFMGIeUU1xPzgSyXXU4bqrfV+t/4Kxlnvgct1Wd1QtOglyEzmmHtwu2O7kW/EG7
	 LnlxDcm5l6Kh6D5FlVEFYwRNSOAjkNJiy9kah13B80Mbd5qzcSEmT8yKstCrc0cxx/
	 6y9KEGQUKGfXA==
Message-ID: <sashiko-outbox-236381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] fs: tolerate an unfrozen superblock in the
 block-layer thaw
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikolai Dokutovich" <ndokutovich@gmail.com>, dm-devel@lists.linux.dev
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jens
 Axboe" <axboe@kernel.dk>, "Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Shuah
 Khan" <shuah@kernel.org>
In-Reply-To: <20261127003902.48-1-ndokutovich@gmail.com>
References: <20261127003902.48-1-ndokutovich@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 00:56:22 +0000
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
- [Medium] fs: thaw_super_locked() fails when FITHAW consumed credit
  under kernel freeze
- [Low] fs: inaccurate Fixes trailer ea4e4cc26301 and super_dev_add()
  description
--

commit eb13bf6902950f18bf92590801b7adf9ead4c94a
Author: Nikolai Dokutovich <ndokutovich@gmail.com>

> fs: tolerate an unfrozen superblock in the block-layer thaw
>
> The in-tree selftest tools/testing/selftests/filesystems/freeze fails in
> shared_bdev.unmounted_sharer on v7.4-rc1 and v7.4-rc3.
>
> DM suspend locks filesystems by default, so lock_fs() calls bdev_freeze(),
> which freezes the superblock through fs_bdev_freeze() -> fs_super_freeze()
> with FREEZE_HOLDER_USERSPACE.  A userspace FITHAW thaws that same credit.
> On resume bdev_thaw() calls fs_bdev_thaw() -> fs_super_thaw(); the
> superblock is already thawed, thaw_super() returns -EINVAL, and
> fs_bdev_thaw() propagates the error when a single superblock uses the
> device.  bdev_thaw() drops bd_fsfreeze_count only on success, so the count
> stays elevated and every later mount that registers a superblock on the
> device fails in super_dev_add() with -EBUSY.
>
> The same condition is already tolerated when more than one superblock
> uses the device.  Tolerate it for the single-superblock case too.
>
> Add FREEZE_SKIP_UNFROZEN, set only by fs_super_thaw(), the holder thaw of
> fs_bdev_thaw().  thaw_super_locked() returns success instead of -EINVAL
> when the superblock is SB_UNFROZEN and the flag is set; a partially
> frozen superblock, a superblock frozen by a different holder, and a
> filesystem thaw error still fail, so the block-device reference is
> released only when the holder thaw succeeds.
>
> Filesystems with a custom ->thaw_super (gfs2) are not changed.
>
> Block-layer freezes remain marked FREEZE_HOLDER_USERSPACE, so a userspace
> FITHAW can still consume a device-manager freeze credit.  Marking them
> FREEZE_HOLDER_KERNEL was considered but would change FITHAW behaviour
> during a suspend.
>
> Verified with the in-tree selftest: 5/6 before, 6/6 after.
>
> Fixes: ea4e4cc26301 ("block: allow making a block device unfreezable")
> Signed-off-by: Nikolai Dokutovich <ndokutovich@gmail.com>

[Severity: Low]
Is the Fixes tag accurate?  Before ea4e4cc26301 ("block: allow making a
block device unfreezable"), bdev_thaw() decremented bd_fsfreeze_count
before calling ->thaw() and incremented it back when ->thaw() returned an
error, so bd_fsfreeze_count was already left elevated on failure.  The
device-table thaw walk and multi-superblock error tolerance came from
cdb5146f8d5f ("fs: look up superblocks via the device table in
fs_holder_ops") and 7a7ef107b449 ("fs: tolerate per-superblock freeze
errors on shared devices").

Also, super_dev_add() returns void; the bd_fsfreeze_count > 0 check that
returns -EBUSY on later mounts is in fs_bdev_register() and
setup_bdev_super().

> diff --git a/fs/super.c b/fs/super.c
> index c5a0658f7aaf3..5d850736c8d9b 100644
> --- a/fs/super.c
> +++ b/fs/super.c

[ ... ]

> @@ -2296,6 +2298,11 @@ static int thaw_super_locked(struct super_block *s=
b, enum freeze_holder who,
>  {
>  	int error =3D -EINVAL;
> =20
> +	if (sb->s_writers.frozen =3D=3D SB_UNFROZEN) {
> +		if (who & FREEZE_SKIP_UNFROZEN)
> +			error =3D 0;
> +		goto out_unlock;
> +	}
>  	if (sb->s_writers.frozen !=3D SB_FREEZE_COMPLETE)
>  		goto out_unlock;
> =20

[Severity: Medium]
Can thaw_super_locked() still return -EINVAL and leak
bdev->bd_fsfreeze_count when FITHAW consumed the userspace credit while a
FREEZE_HOLDER_KERNEL freeze is active?

If both bdev_freeze() (FREEZE_HOLDER_USERSPACE) and a kernel freeze
(FREEZE_HOLDER_KERNEL) hold the superblock frozen, a userspace FITHAW
decrements sb->s_writers.freeze_ucount to 0 while freeze_kcount keeps
sb->s_writers.frozen at SB_FREEZE_COMPLETE.  When bdev_thaw() later calls
fs_super_thaw(), sb->s_writers.frozen is not SB_UNFROZEN, so
thaw_super_locked() proceeds to may_unfreeze():

fs/super.c:may_unfreeze() {
	...
	if (who & FREEZE_HOLDER_USERSPACE)
		return sb->s_writers.freeze_ucount > 0;
	...
}

Because freeze_ucount is already 0, may_unfreeze() returns false and
thaw_super_locked() fails with -EINVAL, leaving bdev->bd_fsfreeze_count
elevated and causing subsequent mounts on the device to fail with -EBUSY
even after the kernel freeze is thawed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127003902.48-1=
-ndokutovich@gmail.com?part=3D1
