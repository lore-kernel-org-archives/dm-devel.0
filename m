Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794471109;
	b=ccAw6yHuEA54N1OhxnjvUZ9CrHpdXthUr5NP9419J+whVCk4XJzqMzAMInIzwtzlBbft
	 48pT0jnv/gzzz+pthwMMTN5zLvf82IwYFiXnzs3ib0M0CMW4VeYfugmAjPrfzPpTzGOK1
	 UW+kNm1YmJqWCTQotntd+ZmOrQXRNrA87MmxGZXnpFvLWOgpAP565w4mHQ0TKIdccE1MJ
	 pgrr08b29LFoe+8vQV/IrR4q5mcQXkImshMdUVxFegQCxr19VNynzrB3x1OrEgdVY6S3D
	 O9f755AJ2eufPztZ0JnBinbDj0fFsUy2jcpfaOSG/3+bK62UmSyPjVDLnslGfmXQ2ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471109;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WmLCy4HWhjXmf2c4yvSnZ3qhlcYn3t/BSaURG8UDPQI=;
	b=hW39yrfzurbk38mCT9g10yXhwdkRWFVRk68TwKjXKJfuVN6zaPDCv58Bu7nJBeIFn6gU
	 XPk0HA7TZq4wj648LAT2DMyEzqqjBL7fmvzecc8iFK+kfYAZVtnyPQUKOsva54c7RMRGN
	 RO7hVA3KKb5QLNc9NHA3g0KabXRbDlxbT2Z/qyXvrp8OBLtpZtJSoRPbXc9Tb4A7Hkg06
	 FbAmC8p/VVRWuUIFbsXFECWIdFHG+x8FIMn3FKtaZqMfDz8l1FJmEvh5sFxPicBFoebTe
	 MtNJtasiowkYiv0khnLIbiNwinRwKLLx1MURj2TyhaH9O3HFKtXOO8i8C/S5nl5HSQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PAYBqoI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5107B60A380B
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 08:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAYBqoI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893841F00A07;
	Thu, 12 Nov 2026 08:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794471108;
	bh=WmLCy4HWhjXmf2c4yvSnZ3qhlcYn3t/BSaURG8UDPQI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PAYBqoI/tffFcxkL7agFhzv8khQawSekcSzrEwb6pMIQTYyvELrviEALtfvWKDz9H
	 lKv2G4X9oTgdgmflHG9KKcLqd+wwZ25pDn7IujZ2g8ryBpTfknZk6EoBDwQpMjqq7p
	 8BX9dpcPHNyN5Q914vEZgUYRzBeBBzWL3TKVJvOQLQuWJLWQ/9QFYXpY0Aa6s4Qux1
	 c3JigBNyHOlfWMjQDHum2m+VAVVIq+q002piT4BmMXFKBl1iCJTAS6S0kbuiuy1xs2
	 mT7Z2lwEU/d8AiCgri3JIwlhjjy8O1Ug5YgJiqYGQVdq73t5bZTe/HzzObUOaPA05n
	 1b+HJHSfa8iUA==
Message-ID: <sashiko-outbox-210677@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-raid: fix use-after-free in raid_dtr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev, "Li Youhong" <liyouhong@kylinos.cn>
In-Reply-To: <20261112075741.1449168-1-dayou5941@163.com>
References: <20261112075741.1449168-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 08:11:48 +0000
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
- [Low] dm-raid: wrong Fixes trailer citing a17d1bca5aba instead of
  db29d79b34d9
--

commit ea394970c807037990938dd90a475a2a71496a69
Author: Li Youhong <liyouhong@kylinos.cn>

> dm-raid: fix use-after-free in raid_dtr()
>
> raid_dtr() currently flushes event_work only if work_pending() is true.
> This is insufficient because once a worker has dequeued the work, the
> PENDING bit is cleared while do_table_event() is still running. In that
> window raid_set_free() can free the raid_set, leading to a
> use-after-free when do_table_event() accesses rs->ti->table.
>
> Flush event_work whenever it has been initialized, so raid_set is not
> freed while the event handler is still running. The .func guard skips the
> flush for mddev instances where INIT_WORK has not run yet.
>
> Fixes: a17d1bca5aba ("md: fix stopping sync thread")
> Cc: stable@vger.kernel.org
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>

[Severity: Low]
Commit a17d1bca5aba ("md: fix stopping sync thread") is a stable backport
of f52f5c71f3d4 ("md: fix stopping sync thread"), which only touched
stop_sync_thread() in drivers/md/md.c.  The work_pending() check on
rs->md.event_work in raid_dtr() was introduced by db29d79b34d9 ("dm-raid:
delay flushing event_work() after reconfig_mutex is released").

Should the Fixes tag be:

  Fixes: db29d79b34d9 ("dm-raid: delay flushing event_work() after reconfig=
_mutex is released")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112075741.1449=
168-1-dayou5941@163.com?part=3D1
