Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989139;
	b=NJhKPhWJcO2M4ZTEE+WFLWmaK6lr7vGTZdA+M+QSttUDT2uZyC/cx/LRfIG3rjrzFYWt
	 pT298/23JU1OEzuMGr2VmPrkcEJkCfGptJemjiC6GqxpSDyrffKfKpSWDQKU/0+hUu3Wz
	 ZOhI1SKet4Ra7lYRj2CXyHbN5/5FMD5r95RkBv9VYaZDFgrp5/3M6J1gBzJ05qClMNrrg
	 N/fMzIXy++AaXDFeKn9z2o7w9ynnlTMI+uL7LN/wcxFI/kfsodyJ0rKXdDYwCk26hdTEU
	 CTnir9CvqN/lNJN2KwM9EvHO636U7YQxXZk6KJ8Foc0pXpRr+uuAThnz/TffXSEGeMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989139;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9mObKINwcoFqG5TqBZKTv6T7ZeO56VjQh01jz6CJVEA=;
	b=JMfVGEqBHc5EDxQLWlWAEmk9ZjjKfcY4wFh3aRCNnC4gXCmloeI5RzyTqrIAcwYXvp1o
	 rDi3VV/ZKTrkN6BsHJwhR3jxZ8h8ctDh41yuytyKQLfD2exu0Z8ziVRRMKmKm17XQUy82
	 2griUAHmnK7xplOqctX2m6Lpaz2DXt/VhE6ZWe2Nn2CzFQnSUBfmMR8nqGMR95DqGCx8l
	 eNVukI9TXdk1hcbDMAJzg4SmYFKHcBrbD0u/b1Eqsjcaex80JSMKLv0Ojf7r+1i3dkiJQ
	 QGkVAtlQnmVuGiAPteavCvzbbO4bTK/GmCQgLy8wDfb+QbfeeEJ3Sm3nZn/s3aTHfNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfBglyid;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD01606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfBglyid
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F9F1F0089F;
	Fri,  6 Nov 2026 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989138;
	bh=9mObKINwcoFqG5TqBZKTv6T7ZeO56VjQh01jz6CJVEA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PfBglyidsaEKzNp0JlrY1I+K0nQqLwU6abU0qB2fojKsrdX7jDr/Mw6/XETmNVq3G
	 lpZnQ3f+9ZDVLiRilL2uq27HAtnjBq5XtQagL4y0sRnoxmnpZot1SdEiAuKxf0nYqI
	 A7BudOc+vWbLzAguSjzU+HCN/t8q3YJ5UvnbeacOXl6nwkZUWXm3XjxqQPIbTGHxQN
	 x1G2G5sw/JBaCwMgj+easXKdxAGBGnXNMY9cfPQdl4EfEj+rlmI2tyR8aFro8Gtkrt
	 +hXfbFXn7EjLowY4T1LMtyX8ydgvvBiXrdktpGtkkOaZVDqsqhC95J+C44Cj1M7q4b
	 6mF5vJlhpsNXQ==
Message-ID: <sashiko-outbox-202008@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm cache: fix divide error in too_many_discard_blocks()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Drif Abdelmalek Mohamed Said" <drifabdelmalekmohamedsaid@gmail.com>, "Alasdair
 Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Benjamin Marzinski" <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Cc: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com
In-Reply-To: <20261106180809.1419-1-drifabdelmalekmohamedsaid@gmail.com>
References: <20261106180809.1419-1-drifabdelmalekmohamedsaid@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:18:57 +0000
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
- [Medium] dm cache: 32-bit truncation and divide error in
  cache_create()
- [Low] dm cache: line-wrapped Fixes: trailer in commit message
--

commit 1daf5e2259576307a337e1dd87d8c7878f108ae2
Author: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>

> dm cache: fix divide error in too_many_discard_blocks()
>=20
> too_many_discard_blocks() uses sector_div(), whose divisor is a u32.
> discard_block_size is a 64-bit sector_t that calculate_discard_block_size=
()
> keeps doubling, so once it reaches a multiple of 2^32 the divisor is
> truncated to 0 and the division traps with a divide error. Smaller values
> above 2^32 are also silently truncated, giving a wrong quotient.
>=20
> This needs an origin of more than 2^45 sectors, which is unrealistic (this
> is a thing still in 2026!!) for a real device but reachable with a fuzzer.
>=20
> Use div64_u64 so the full 64-bit divisor is used.
>=20
> Reported-by: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D3e16980543e238b95bd1
> Fixes: 08b184514f65d ("dm cache: revert "prevent corruption caused by
>                                 discard_block_size > cache_block_size"")
> Cc: stable@vger.kernel.org
> Signed-off-by: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gm=
ail.com>

[Severity: Low]
The Fixes: trailer is wrapped across two lines with a 13-character SHA,
which should be on a single unwrapped line with a 12-character SHA:

Fixes: 08b184514f65 ("dm cache: revert "prevent corruption caused by discar=
d_block_size > cache_block_size"")

> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 1a5072425c4a1..2d40d6047ef11 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2383,9 +2383,7 @@ static int create_cache_policy(struct cache *cache,=
 struct cache_args *ca,
>  static bool too_many_discard_blocks(sector_t discard_block_size,
>  				    sector_t origin_size)
>  {
> -	(void) sector_div(origin_size, discard_block_size);
> -
> -	return origin_size > MAX_DISCARD_BLOCKS;
> +	return div64_u64(origin_size, discard_block_size) > MAX_DISCARD_BLOCKS;
>  }
> =20
>  static sector_t calculate_discard_block_size(sector_t cache_block_size,

[Severity: Medium]
Does allowing calculate_discard_block_size() to return values >=3D 2^32 just
move the 32-bit truncation and divide-by-zero into cache_create()?

struct cache declares discard_block_size as uint32_t, and cache_create()
immediately passes it to dm_sector_div_up(), which uses sector_div():

drivers/md/dm-cache-target.c:cache_create() {
	...
	cache->discard_block_size =3D
		calculate_discard_block_size(cache->sectors_per_block,
					     cache->origin_sectors);
	cache->discard_nr_blocks =3D to_dblock(dm_sector_div_up(cache->origin_sect=
ors,
							      cache->discard_block_size));
	...
}

When origin_sectors > 2^45 and calculate_discard_block_size() returns a
multiple of 2^32, assigning it to cache->discard_block_size truncates it to
0 and dm_sector_div_up() traps with a divide error.  For non-power-of-two
cache->sectors_per_block where the truncated lower 32 bits are non-zero,
cache->discard_block_size is no longer a multiple of
cache->sectors_per_block, so oblock_to_dblock() can produce dblock indices
>=3D cache->discard_nr_blocks and hit the BUG_ON() in set_discard() or acce=
ss
cache->discard_bitset out of bounds.  The other uses of
cache->discard_block_size in oblock_to_dblock(),
calc_discard_block_range(), set_discard_range(), and set_discard_limits()
also use 32-bit division helpers or shifts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106180809.1419=
-1-drifabdelmalekmohamedsaid@gmail.com?part=3D1
