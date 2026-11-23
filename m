Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795467634;
	b=qPQg1CK4YECdAa6vR1AXEy0rRTKWQ6bHTRa95zflepigubRDOECd6V9DaR3S/FoUltSo
	 TWAKvdxc27YuQfUG2b/CHVvErZKm1j5gs1wgOGR43lnjvK04gLlmDlUJOOB8yi3TW5fCT
	 A8QzgRPPST6sY3Ci0bpOmv0ePuLThaGnGUCgfF3KWCtnqpDKl0QnBaYthVx+fiq4JYJDB
	 h35VQJxrtIx1p04kQqZud1Zz4daJArbnMJfHxGEEXsLA1n8lHRauX7DbMRmh44PclemmZ
	 3bBqGOozGo4nrEZz4M+uj2p0cjAAIo/L3z5Ay6dq5Cejp/rr9Fa489YhzeuvcmE7yqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795467634;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y1xOjJT2GANt3IYh5NUo/gK9icfjL1vW/4nvxvSwq8Y=;
	b=VapJ2fRVwceNZs6wtxqc6qnYPRQhT0wTr5gMY8TpX2xfcu089U34C7XZXhYTXlESj7Qy
	 vf2VuD6YqKiXTP/w3VfRx1H3TMnrpitbqmUg3AFqtcsk2eRKMiGHxSk+dgmvs72kDbTeu
	 142J93QuF2r7apQzH+HrUMdOB2znryHSYCogoLJAxBsMgBn/+1h3ETypl/a7pWxUcfYvm
	 p5Yrs5DHUqgp9b+ucZxowZEE2tUQQfLI1XnHuIH31S5vG7BJ4uxiI4v9uPW9DF2I+4JR0
	 alC1W0UwXMl3hGgBAz/dL8QM7NZcAwApJMTgQQ8N0Ef+H4SXpBr0OcYLS0QASIQPiWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="eyw/I+C3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA49A606A327
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eyw/I+C3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65221F000C0;
	Mon, 23 Nov 2026 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795467634;
	bh=y1xOjJT2GANt3IYh5NUo/gK9icfjL1vW/4nvxvSwq8Y=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=eyw/I+C3f9V6hOGP8FPrReLK/DZO2/SgCT9L4duULWa0mzE+9Dxn9nDCabRpgeJPe
	 W315u/kwHNhUC8nu7kFaeSPNioMrwJcWeSPko4P9EpR/FdkDUI4hoXlYyh7ielaVt2
	 4cjpJATs4QoOikIiDxfNPKTIDKi3kxstPQv/WSzqEQelWCuenbctGDhSHaZZzXL6B2
	 oWBvdePGbDYe6f0pmrFKUn2v15niv6dxPsKxM7h3RQB/PAMmrM8WF2GCDjiKTYYbY4
	 UCQlwzkv4FDaTTCaddNkXB3LMcKm2pxfxoGPoDr7OPCE00bQLLw45raixvDFpQnrr2
	 y6Oesii7gw+Qg==
Message-ID: <sashiko-outbox-230044@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm persistent data: fix invalid calls to vt->inc and
 vt->dec
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Ming-Hung
 Tsai" <mtsai@redhat.com>, dm-devel@lists.linux.dev
In-Reply-To: <9f8ed9a9-fb35-7a4d-4877-430268010b43@redhat.com>
References: <9f8ed9a9-fb35-7a4d-4877-430268010b43@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 21:00:33 +0000
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
- [Low] dm persistent data: missing Fixes trailer for commit
  be500ed721a6
--

commit 98fa2d52c80bc26e5eb99bb6a56f6fe2672f889c
Author: Mikulas Patocka <mpatocka@redhat.com>

> dm persistent data: fix invalid calls to vt->inc and vt->dec
>
> The dm-array library called vt->inc and vt->dec with invalid arguments.
> None of the users of the library actually use the callbacks, so the bug
> was latent.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5

[Severity: Low]
This fixes the vt->inc() and vt->dec() calls updated in fill_ablock() and
trim_ablock().  Should this include:

  Fixes: be500ed721a6 ("dm space maps: improve performance with inc/dec on =
ranges of blocks")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/9f8ed9a9-fb35-7a4d-=
4877-430268010b43@redhat.com?part=3D1
