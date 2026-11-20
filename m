Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795171778;
	b=HJ17zBKt/rUGZoK2yUaINUKhYPX/4HUZMgLBoXw9ZHI4sIijQi0AkOiCXcKG71A4jcP5
	 yJCgkd1Px86+YTVDCr+4yGjEDhZNiAJuwF+DwYTaYRqTKSYMQ41sJWNWNnD6jNARgqsz+
	 h0DY6BJG/3xG/yGzZXd0R5fdu0pJ/fAM49rLkwPCRVs5pvZiyGTuSEA59xMnxpJFsAcn/
	 CI4vGsyYEHrzxvPhII9cx+DYF58O+ofNNrSNOdDke7p5KmtGRNc2XuaOCI6GFOPHyGDVx
	 eX1mOU624gnC8UDKDcsOzpMJ0T0RYfuLDttocMGV35AoxCA3jVPR/XkCxyeSWlvBcMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171778;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dbwCl3jdKQTR4CCJxLTpV3IWqT2LUPkJ9ys2ydt/poM=;
	b=wSx9Ek63XXiPAn5oE75BBEuQRdHHAvvbKUy2tsn9Bhg9yx74hXwacGP+6p6yPkZQ6vhJ
	 IYb+3XX1XilKoykmYFQZXBJ+GVxxs9ngDUaUmSTNN9IGdDq5PLG9+neaX+SQiQj9Mj9Nd
	 G7L0Q3Wni0Lw8fq7uATgrcvW4IMaUQxKECSh0Ha/Z/paWuQoIZVs32tzn5qIqDlh6OahF
	 h9UyOeQfuMjF4O+E3UENz2s0Kjpuq2fPwFMiSry3HnjKaFDBq1S8r2BiLPSS5IalgpNXJ
	 euTV34pant7vq+88OR2GUIIQal85JA3rQTAGQFY4tWg1LYsPyAqzClInoFRzY2k4Vcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="c7g2a/Ni";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0F0606A325
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c7g2a/Ni
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4CA1F000C0;
	Fri, 20 Nov 2026 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795171777;
	bh=dbwCl3jdKQTR4CCJxLTpV3IWqT2LUPkJ9ys2ydt/poM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c7g2a/NiYHOKavOaF1N/XDO2+jdpKoeGh6uVNTdSmy69xWJPgZxl3mpc3vzKSHDFA
	 cN2FyGexvL3dRSpzFRUA1vF8QzIodhuubiGs9ryh3Juj1hpeJgIUsy2p3hh+hToaVm
	 yFGESoF45z0Xru5bt2gwQz0Qp3LUoqpBchQqudLQob8AU2YhvE97jUThRYE/YtJt9l
	 7TqL3tcVn7hzEgLnE8Yil0eNcKbBc9dzSkzqtOG178zuDmzSOrQTIgnY1R9cfaA4an
	 qFTqRMq0n7TJd+IGdsKKg4b3IXbfDokhu7j0+aGhb8mnoSO/QFco6cC9HxsU8ba6FM
	 GgBBbKt4SmOpg==
Message-ID: <sashiko-outbox-224959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] block: fix divide by zero in
 queue_limit_discard_alignment()
Reply-To: sashiko-reviews@lists.linux.dev
To: tongzhiwei <tongzhiwei@cmss.chinamobile.com>, "Jens Axboe" <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com, syzbot+1288484b13bf6af3620d@syzkaller.appspotmail.com
In-Reply-To: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
References: <20261120103040.610-1-tongzhiwei@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 10:49:36 +0000
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
- [Medium] block: misdiagnosed sub-sector check in
  queue_limit_discard_alignment()
--

commit 863891ebff09d5d7c6b856e9fe20f0c7b376f993
Author: tongzhiwei <tongzhiwei@cmss.chinamobile.com>

block: fix divide by zero in queue_limit_discard_alignment()

This commit restores the zero check for the sector-shifted discard
granularity in queue_limit_discard_alignment() to avoid a divide by zero
when discard_granularity is smaller than a sector.

> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 1f5ee2453269f..a0487226f48b5 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -643,6 +643,10 @@ static unsigned int queue_limit_discard_alignment(
>  	alignment =3D lim->discard_alignment >> SECTOR_SHIFT;
>  	granularity =3D lim->discard_granularity >> SECTOR_SHIFT;
> =20
> +	/* sub-sector granularity: no meaningful alignment, avoid div by 0 */
> +	if (!granularity)
> +		return 0;

[Severity: Medium]
Can a validated queue ever have a non-zero discard_granularity smaller
than SECTOR_SIZE, or does this check only paper over callers passing
unvalidated sector units instead of bytes?

blk_validate_limits() enforces physical_block_size >=3D logical_block_size
>=3D SECTOR_SIZE and clamps discard_granularity to at least
physical_block_size whenever max_discard_sectors is non-zero:

block/blk-settings.c:blk_validate_limits() {
	...
	if (lim->max_discard_sectors)
		lim->discard_granularity =3D
			max(lim->discard_granularity, lim->physical_block_size);
	else
		lim->discard_granularity =3D 0;
	...
}

The syzbot crash cited in the commit message happened because
dm_calculate_queue_limits() passed unvalidated target limits from
snapshot_io_hints() to blk_stack_limits(), and snapshot_io_hints()
stored chunk_size in sectors rather than bytes.  That root cause was
already fixed by d7216d7be2bb ("dm snapshot: fix discard_granularity
unit in snapshot_io_hints"), so returning 0 here is redundant and would
silently mask future callers that pass sector counts in
discard_granularity while leaving the bogus sub-sector value in the
stacked limits.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120103040.610-=
1-tongzhiwei@cmss.chinamobile.com?part=3D1
