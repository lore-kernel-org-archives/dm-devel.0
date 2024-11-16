Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CD528FF
	for <dm-devel@lists.linux.dev>; Sat, 16 Nov 2024 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731758491; cv=fail; b=n2YbzBNjHEu8VwQhUS5yGa0ZjLTUwYvX+y1lxb7e0L7tyAkEAmTGRE/j+dbCaWpVYEiUM4Gjn4uc+Qr+2pMj9TamwbhEB8rE57FhWq8Y2ADcsQ9D0p+XCWAkhmwKrPwLmALUW+q7GI+fGCb9ppH+EISkxIY5fw0na6gucK0iHD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731758491; c=relaxed/simple;
	bh=imsdWN83wDqXvmIIqc8/aum484lB6doOW+UX9UO9VPw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vEXqMQVW9lVeQ/i0p3X2qCrINSC0X6dNqpoODlTX87/yT/xGa/4kdIR4URNYpVDe8ekb/xpYYTn1mqw+Mbl+rjBXEX0evgaxpYBmaSU3YKp2nv2D9gBXLOJSOTBGI7rf0xKNsGCwtPTw+F58jbARPbnFoFa19J0W3ZxsM4oqCYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=ReKLBLV5; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=ojUDzAfH; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="ReKLBLV5";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="ojUDzAfH"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.sapience.com (srv8.sapience.com [x.x.x.x])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id 489B64800BA;
	Sat, 16 Nov 2024 07:01:29 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1731758489;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=+PURL2InYOsj3BhypDb0PKUe2mpdYPN2P0wnuC/FnZQ=;
 b=ReKLBLV5D/Hgvbl/MRpObjWRnSBTK4LLu8VmJs3Nq0JtYsVTCF1zyvGF4bmvmV4/hr8Ff
 Tt26ZunUn8FVfIfBQ==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1731758489;
	cv=none; b=UwPSPz9WEqRhHVKp8r5BGTZ/rFhoP6M+5mU60VPsJuPXmgkXPEDeRX0/hsoZNURVj71gyKHuMVChDFaXW0N7BlB60wftVAfSpG1KwNUYs3ISWtVzN3IzkXfkfRwQaPqzE6fei3WCPX0HRL0yP5GuwoBAPr8J8UCy8MFGS4NxsdSdPur8Sm6z5WD5mkmrI5zOPGKb8+gL5B4GcB2/QHXdSJOZ3SHtls+qlDSshDj0W65lzjiVq3YjDgiAd3apDAS7ywSacr7PGlLQiS63z7RBE4R9Dpjqg5c4Og4BoOSgiWrAFD8O5ZTehRWhEralXmFN2HM5gM+oRc6IKyvWUthWgg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1731758489; c=relaxed/simple;
	bh=imsdWN83wDqXvmIIqc8/aum484lB6doOW+UX9UO9VPw=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=xahICJHBXNEXopCshqzGUbFU/Nebt7i+KdwvsZsTiD1bB49Ygn80J8MSZGcBjHcPJIKrg09wylBwy3GZQDcaYbFBhxl83od+IyBa5K3nU6B9Pf45yTP1Gkm6ikRQ+y2Nt6RqkooFjv6bTLh585Xwj7AnSfFHxiT3M99V/gadl435teef2dFos08pINDNNQrZYuXGX1aTdiFQl5ZnAayf8kuZHE17qh9CMl2Xh2Mvb0GhxeyaHx/8GQxb+8VPT1mfRvN5k9c5GtHJYSSrds24mdh6QnWz5i14ZAtJvJBFycZ8B/2/nqYaaGxQurExDsrDmJeCVyTFj8Eo8h//ZjPSNw==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1731758489;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=+PURL2InYOsj3BhypDb0PKUe2mpdYPN2P0wnuC/FnZQ=;
 b=ojUDzAfHn+9fmwyxUE583DeO3yEandILLk86SVMNXqeIFsAtr1msNYt77UBtVCotHSFfM
 RjOqNpdOvFIQUjUQ3nthJwbtbwhx8sRM9XeJTPaDdoz+ylIyVELYJgoP0f9REEBre0QIAw2
 N4/35di8rNQXjVHSAC0hL6Tp7ssyq6zjE94QI2wIksyf/s68Xmf9Ld4cCNFVdWHXmZ1egrn
 3a90O1MabgszhmEcsTXGvbV2RpriMY/2F0h8YCDB+QqPPw7qyWkSvXL8NGAeNLq7PB57nzd
 XRgZKgPUpQmKp9eHP/afoIiYkwbcAKppsENt2xpbXZYxDTgwzfejh57j6Sog==
Received: from lap7.sapience.com (lap7w.sapience.com [x.x.x.x])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by srv8.sapience.com (Postfix) with ESMTPS id 0E54E28004A;
	Sat, 16 Nov 2024 07:01:29 -0500 (EST)
Message-ID: <9f1b81682e853655c74589ace5debf9a55edff51.camel@sapience.com>
Subject: Re: md-raid 6.11.8 page fault oops
From: Genes Lists <lists@sapience.com>
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
	dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, Mike Snitzer
	 <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux@leemhuis.info, "yukuai (C)" <yukuai3@huawei.com>
Date: Sat, 16 Nov 2024 07:01:28 -0500
In-Reply-To: <058cd646-2d2a-202d-5f99-6e635a95fead@huaweicloud.com>
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
	 <CAPhsuW4kNYbcXERCQFqO-r8Q_rCLxrkQPt777cB_8TwyBfy8FA@mail.gmail.com>
	 <058cd646-2d2a-202d-5f99-6e635a95fead@huaweicloud.com>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-jBSfqBSm7l/Og52McZTK"
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0


--=-jBSfqBSm7l/Og52McZTK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2024-11-16 at 11:34 +0800, Yu Kuai wrote:
>=20
>=20
> While reporting bugs, it'll be much helpful if you can provide
> addr2line
> here, fo example:
>=20
> gdb dm_mod.ko
> list *(clone_endio+0x43)
>=20
> Thanks,
> Kuai
>=20
Of course thank you.

Let me know if there's anything else that would be helpful.

I needed to rebuild with debug turned on as production build has it off
- but toolchain is unchanged so this should be valid:

(gdb) list *(clone_endio+0x43)
0x3733 is in clone_endio (drivers/md/dm.c:1111).
1106	static void clone_endio(struct bio *bio)
1107	{
1108		blk_status_t error =3D bio->bi_status;
1109		struct dm_target_io *tio =3D clone_to_tio(bio);
1110		struct dm_target *ti =3D tio->ti;
1111		dm_endio_fn endio =3D likely(ti !=3D NULL) ? ti->type-
>end_io : NULL;
1112		struct dm_io *io =3D tio->io;
1113		struct mapped_device *md =3D io->md;
1114=09
1115		if (unlikely(error =3D=3D BLK_STS_TARGET)) {

--=20
Gene


--=-jBSfqBSm7l/Og52McZTK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCZziJmAAKCRA5BdB0L6Ze
23lDAQDmKDRogYmRFOkIyrPg/zvJdLhQXFoaznflVHIJjkFMbwD/YzM8epUhSi2w
SqsCzdjU83b511s+4dDdHwphvXL9OwI=
=vF5u
-----END PGP SIGNATURE-----

--=-jBSfqBSm7l/Og52McZTK--
