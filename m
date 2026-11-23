Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466531;
	b=CXhvsLyfwRr30AecGfrP1UMRz0nZ7646RNJW68fPxJe3yScRH7uLf8wYP1otm4s3CSLJ
	 QwQ4n8hVF3YSBNsgmo6vJsyKLMwsYZKgjwK8aKtnnxnWuP6lcRBC/gOroK1r/LvlTr6Wi
	 zJU6ZfGQ/dhh0UAwgAYpZr8a6KgIIMRufD8GlVF9Gx751YVosU6tLzx+Gk+9Yj+a7IuGd
	 sM2GBuyvyiS/RWQE4flUiCZViMTp8SrfqNyEbw/9KgP53/sg8bPEf4j4oSuQ1kooYJ+az
	 mNEGflORipNNOCBuT7ddQvDSJRZVytf7zdJQIpQOC4QpNq0EkVJm+OVwcRI3GMt27zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466531;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YkHq8BoFq1lI3g44PvutpueEpB2lYRjaY8du0gcLNC4=;
	b=0nhUlCpWpGc2xuN1cYizAr/U5CkaTDPKloRBdpKoZt4e0UxY3LURzomiVNeA501N7vIs
	 DN0HMkPhDWVkpcG9POldBWzzK7cv0MTBOxMB5dnuiQnkX9FYeuG1d8iHVTd1lXnwI27QQ
	 4cmVVCKA60kMF++HQCKxlG+rSZQldmSr1JQqvBw5Riy8FJSEXTgkrkaV+TpxwTcTPTF40
	 dOnEIE+3F3VRuWpWNTXoDWKk/w2Pwf0miV1LgP1xk5oZHHcF+KiclK+OZED2WrD6Ffy9a
	 DxbnGVEreivPSAfkSlM7UeoMmF1bhkAfIF9DBBev8fguKYvXGiZj+Orw2zkAFpjtocg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WmvGdHuM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2B2606A337
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WmvGdHuM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5123B1F000C6;
	Mon, 23 Nov 2026 20:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795466530;
	bh=YkHq8BoFq1lI3g44PvutpueEpB2lYRjaY8du0gcLNC4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WmvGdHuMaEDXZLSaC9Atpm5sTW/X3kt6b4i22ALOhZA2SU9f3hbDa/H/w9abLQkpb
	 VTnu5JUrw04fArTJRMiDWptM8k55bvS55cT7KYQgJzNHDTmd0WaJEIGUNV/FQ8UuCD
	 LSV1Y3VxfbbPy6v0R504ZLtKA+Dhd+IJrCXhb6MGi0BYMKEkINTQXpHlQK4P+SdxZv
	 XbjT67IVglGE/IshUZUxc/7/Iujl2hAkwynWQBEQnD9/t9TyZ9ST09xvy/NNeQk+tm
	 lDPD7kHc23qXgb3O/LyrADhxbjgXRLrV6mQXGYihl9QHDoOf4Rz8DtQJIQJDvDiUlR
	 +0gpxvtlhl5Lw==
Message-ID: <sashiko-outbox-230016@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dm-verity: fix shift-out-of-bounds when computing hash
 level sizes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jake Joyner" <jake@jakejoyner.com>, "Alasdair Kergon" <agk@redhat.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, syzbot+3f8f5b65af8de862dcec@syzkaller.appspotmail.com
In-Reply-To: <20261123203413.145298-1-jake@jakejoyner.com>
References: <20261123203413.145298-1-jake@jakejoyner.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 20:42:09 +0000
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
- [Medium] dm-verity: 64-bit addition overflow in verity_ctr() hash
  level calculation
--

commit cd7aad3c8d1954be46e65f7c6faabc1543f1ca63
Author: Jake Joyner <jake@jakejoyner.com>

dm-verity: fix shift-out-of-bounds when computing hash level sizes

This commit avoids shifting by 64 or more in verity_ctr() when computing
the number of hash blocks at the top level of the hash tree, setting the
level block count directly to 1 when the shift count reaches 64.

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 1c0ce746adf67..553e85aa0a457 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1583,10 +1583,13 @@ static int verity_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
>  	hash_position =3D v->hash_start;
>  	for (i =3D v->levels - 1; i >=3D 0; i--) {
>  		sector_t s;
> +		unsigned int shift =3D (i + 1) * v->hash_per_block_bits;
> =20
>  		v->hash_level_block[i] =3D hash_position;
> -		s =3D (v->data_blocks + ((sector_t)1 << ((i + 1) * v->hash_per_block_b=
its)) - 1)
> -					>> ((i + 1) * v->hash_per_block_bits);
> +		if (shift >=3D 64)
> +			s =3D 1;
> +		else
> +			s =3D (v->data_blocks + ((sector_t)1 << shift) - 1) >> shift;

[Severity: Medium]
Can the addition in the else branch still overflow sector_t and wrap s to 0
for the lower levels when v->data_blocks is near U64_MAX?

With 512-byte data blocks (v->data_dev_block_bits =3D=3D SECTOR_SHIFT),
verity_ctr() accepts v->data_blocks up to U64_MAX.  When v->data_blocks is
U64_MAX and the top level has shift >=3D 64, this sets s =3D 1 for the top
level while every lower level with 1 <=3D shift < 64 overflows the 64-bit
addition and computes s =3D 0.  That leaves v->hash_end at v->hash_start + =
1,
allowing the table to pass the dm_bufio_get_device_size() check on a small
hash device and later underflowing the block count in verity_prefetch_io()
when hash_block_end is clamped to v->hash_end - 1:

drivers/md/dm-verity-target.c:verity_prefetch_io() {
    ...
			if (unlikely(hash_block_end >=3D v->hash_end))
				hash_block_end =3D v->hash_end - 1;
		}
no_prefetch_cluster:
		dm_bufio_prefetch_with_ioprio(v->bufio, hash_block_start,
					hash_block_end - hash_block_start + 1,
					pw->ioprio);
    ...
}

Since v->data_blocks is always non-zero when v->levels > 0, computing s as
((v->data_blocks - 1) >> shift) + 1 would avoid both the 64-bit addition
overflow and the shift-out-of-bounds when shift =3D=3D 64 (or for all shift=
 < 64
 alongside the shift >=3D 64 check).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123203413.1452=
98-1-jake@jakejoyner.com?part=3D1
