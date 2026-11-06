Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793992121;
	b=yBQrC0dj0rS10dJhL3s1pv7r6CCXF9bnEJ0eRcpadiCtwln4Vy7Dbz1mSo5qUN8zdONB
	 kkdoq3d+2RNeXwMOu/i461AteiEl1bN/3GoPyKehOaaWpv5/GPdW1jS6i14HCLgx8jTtX
	 H1qtKVObLWOFQuO5Ig4UENX2oRVUTb1/TIXev15cyt1p4/J3zTyWE3HcNG1tgco/4WoQm
	 szVekDXcdle1hnV9+a+77tHB5mqV+b4jcP+C6/h3sM+JpP1Iud8lLbi9nvTkrAkF/FrLW
	 O3LRmow0Z7GjDTqrtTesG7NGsTddfX+WA4uFUUvZ10rF3ZmBJBf1s8t0goctpg6JSCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793992121;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sgGu88jRVWzCl5eG1N7637zmrOZwgC8/pVbLmh6BaAg=;
	b=ymXLI4ynBq3XfCDHwqKCpTl/8bAZIl4vZB81hDVyvkUFvPN2DO64LH4UuAJ52l7krJ4w
	 MntFCIwVuYev9fRiuJPJs3NmVZlrxdJp/JglGIV7IKDJNuAVZrJxGMc/UfY9UXvtwQhDg
	 jchKKu8wI/LUrUWsz+2VqT963P1yuT+5jUv09wWAhLjcYyZR0rPFNmH8GLEsFSVSgY5hI
	 XwLXLQVyZD+19kLsARlO20o0gW3j6nwtYhA7bHntsiPILUCA59I/CNMxQjnSQwwQxFbFm
	 faEp9ktRYKvKLbZisnWscIjwy57rXUPlqGjuHviX6Whq8GmSyMojL0rzkJ4GzJ+wT8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4+Ybtk3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E151606A326
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 19:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4+Ybtk3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832731F0089F;
	Fri,  6 Nov 2026 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793992120;
	bh=sgGu88jRVWzCl5eG1N7637zmrOZwgC8/pVbLmh6BaAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4+Ybtk3mYZmEHmSF1re5WCduLPGm3FOLFxtAf9uRDUvVmoSC7YtGfsYPLLKrvcPo
	 Jcp1vF10kX5lRA5wM0PSUbeknNY30IzWS2EZKehtGJuBusiE+ts6tbYcrTwHbebsHk
	 I3B5qjojPgXfznZ2bnZAFEXoWOnkNdxpGj9f4Hkq0X6GQyI+US2w4o2Gscl7lJYFdH
	 1Q0wG0b5qhKWDhlZX35T4kQKPo+dtX3meAMROgeEAQVlNgEO8azK573s5TZa8e4uPo
	 NobP5I2SqHfSziMKyfU7NZS/ubo3eGmUPg8MkF9AuHIyXqt4DBZt0TWJxN2DJ1cbHp
	 jc1FnvyzuubnQ==
Message-ID: <sashiko-outbox-202135@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm: fix use-after-free when dm_get_device() widens the
 open mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "Ming Hung Tsai" <mtsai@redhat.com>, "Alasdair
 Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
In-Reply-To: <7acdd5f5-72bd-1fc2-cf90-26c9c2a16ba8@redhat.com>
References: <7acdd5f5-72bd-1fc2-cf90-26c9c2a16ba8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 19:08:40 +0000
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
- [Low] dm: missing Fixes trailer for commit 86f1152b117a in commit
  message
- [Low] dm: commit message claim about table_device->count contradicts
  code
--

commit 16907af74a028c1489b22d6e8c7c48ae64949725
Author: Ming-Hung Tsai <mtsai@redhat.com>

> dm: fix use-after-free when dm_get_device() widens the open mode
>
> There's an UAF bug in dm_get_device(): when a table construction calls
> dm_get_device() on the same device twice with widen access mode (e.g.,
> read-only first then read-write), the second dm_get_device() calls
> upgrade_mode(), which reopens the device in upgraded mode, making
> previously returned dm_dev* a stale pointer.
>
> Fixing approaches:
> - Add per-mode views (dm_dev_ref) from a per-device dm_dev_internal to
>   multiple table_devices.
> - Keep reusing the dm_dev_ref when the requested mode is included, i.e.,
>   a read-only reference can reuse the read-write opened device within a
>   table.
> - Maintain a canonical block_device pointer in dm_dev_internal for
>   handling the DM_TABLE_DEPS ioctl.
>
> Also tweak the way of mode sharing check in find_ref() to
> "(x & mask) =3D=3D mask". The result stays the same to the previous
> upgrade_mode() guard "(x | mask) =3D=3D x".
>
> Pros: keep the relationship between dm_dev_internal and table_device:
> one dm_dev_internal per device, regardless the mode, so the output of
> DMM_TABLE_DEPS ioctl unchanged.
>
> Cons: extra dm_dev_ref allocation.
>
> Note that now the table_device's count not necessarily mean the number
> tables referecing this <dev, mode> pair, since we're allowing multiple
> references within a table.

[Severity: Low]
Is the closing note about table_device->count accurate?  In
dm_get_device(), find_ref() reuses an existing dm_dev_ref whenever its
mode covers the requested mode, so a table still holds at most one
dm_dev_ref (and one reference to the table_device) for any given
<dev, mode> pair, as the comment on struct dm_dev_ref in
drivers/md/dm.h notes.

>
> Signed-off-by: Ming Hung Tsai <mtsai@redhat.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
> Cc: stable@vger.kernel.org

[Severity: Low]
Since 86f1152b117a ("dm: allow active and inactive tables to share
dm_devs") changed upgrade_mode() to replace dd->dm_dev and drop the old
table_device reference while earlier targets in the table still held it,
should this include:

  Fixes: 86f1152b117a ("dm: allow active and inactive tables to share dm_de=
vs")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/7acdd5f5-72bd-1fc2-=
cf90-26c9c2a16ba8@redhat.com?part=3D1
