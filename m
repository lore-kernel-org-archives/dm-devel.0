Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F508F40;
	Sun, 29 Oct 2023 11:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="buFakbTn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BfCcUYNf"
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 11A6E5C0159;
	Sun, 29 Oct 2023 07:15:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Oct 2023 07:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698578133; x=1698664533; bh=hG9nPWZ6C6E8JBsR1SCGNCxjbuY1BGNUrEL
	IfEi0QXE=; b=buFakbTnTGDmwsAFIuyj1s2CkemgdADZ3/iAGZ8J3rBmHB871+c
	7NJuGK+amNeXCdRkOFop6ZWb91eyxzSs8brwVMWcPpng/KZHQj6zBDYF26ze86sQ
	ivYXtvCROj5VAm3HilCp/FjLQgf2zDRGq1Ie/lU7vh5ZRO0bhuOWaYoAWNFCeATd
	sgI5PNL/wwuq6vGX1GYLuqLFQ2AWbLlmP2yZKgKQYGAWnKEU36YUSU+6A1yrXVFj
	mWNTndOCXHx1NwcRvL3VVUtFy5D3sLO6YPjd5G82ZoKWrifbhgtVAN4xn+F65E6j
	YJ2bywDYelNGlbHyYFejr5046uoDZgI2KIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698578133; x=1698664533; bh=hG9nPWZ6C6E8J
	BsR1SCGNCxjbuY1BGNUrELIfEi0QXE=; b=BfCcUYNfJ9a0Xg+Ap0fuDlZG26s1m
	xmDe0334Sxu8cR6X7YwVHVKRovO5tCg0iCy8jFM7luLqdzReFK7Z1wj8unYFSKnb
	QO4jL/BA0o03H/WF9KLrdTlsXIe4a/+pvVnpFhrBw9hGU9k6yNxPzBXjKk5603+y
	o6CJJmlL3eWFm4EPMGyLybaJbEI1ky7nizRD18yyg5FQLgJiBfHVymEeiR/rF7CE
	ESmRc1FwTtIGKnP8gGo9JEbifVQed864TRYXO4ADF4TjGkgvFJ0xUQ2LCenh1lRr
	UWaAq5TJjsbXAjTEUk4L/SMSge2/Qpy8mQfrW/5A7kRhsyX37PxErea+A==
X-ME-Sender: <xms:1D4-ZZGzMp5Rcjuh9amNH_iodHGr3sHnjYyrm8GfYxT-82B6YJKVDg>
    <xme:1D4-ZeXWjHguapsed4JM07Us2UlBePYURQkVv2ff0lJ1lCNFrfNwJzxUPhJvb7HpZ
    fEul_va1D4pVg>
X-ME-Received: <xmr:1D4-ZbKVhYUdTerA6evel7xvj5JVtsrciHoV7ZyOVxQaqjIfPGfqMh6qUBWc9eQlzTkoMT1smTqv-cNcAO2Tnrpf4GxgghGYiqE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrleekgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeehudff
    udffhfduheeitdduhfetueehheduudetieevgefgfedvteeuffdvgefgueenucffohhmrg
    hinhepshhpihhnihgtshdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhm
X-ME-Proxy: <xmx:1D4-ZfEUWn89IpTcClDfWZtW1st6flQ3N0YHtxx0D71__Ic4urEyig>
    <xmx:1D4-ZfU0m7BYSiaiDeV6i_qhHVdY6uAVR-6v0PZAAGnB2lYan-Wsog>
    <xmx:1D4-ZaNGbGwzIeoKCeUjgH6YXcM8_LCgxDGC4kFAvTYMv-Jl9fWN0g>
    <xmx:1T4-ZbpObb7iVwaO9guBF8sBk8D2M-4WAoGmYfkbcix-k8roSsWbgA>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 29 Oct 2023 07:15:30 -0400 (EDT)
Date: Sun, 29 Oct 2023 12:15:26 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	dm-devel@lists.linux.dev, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZT4+z9NLwUg6to7w@mail-itl>
References: <ZTNH0qtmint/zLJZ@mail-itl>
 <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com>
 <ZTiHQDY54E7WAld+@mail-itl>
 <ZTiJ3CO8w0jauOzW@mail-itl>
 <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <34f6678e-6460-f77-73f4-fc8d3652a8e5@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JaZFwqy2vaQ13kIE"
Content-Disposition: inline
In-Reply-To: <34f6678e-6460-f77-73f4-fc8d3652a8e5@redhat.com>


--JaZFwqy2vaQ13kIE
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sun, 29 Oct 2023 12:15:26 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	dm-devel@lists.linux.dev, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Fri, Oct 27, 2023 at 07:32:54PM +0200, Mikulas Patocka wrote:
> So, we got no reponse from the MM maintainers. Marek - please try this=20
> patch on all the machines where you hit the bug and if you still hit the=
=20
> bug with this patch, report it.

I've tested it for a bit and did not hit the issue again.

>=20
> Mikulas
>=20
>=20
>=20
> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH] dm-crypt: don't allocate large compound pages
>=20
> It was reported that the patch 5054e778fcd9cd29ddaa8109077cd235527e4f94
> ("dm crypt: allocate compound pages if possible") causes intermittent
> freezes [1].
>=20
> So far, it is not clear what is the root cause. It was reported that with
> the allocation order 3 or lower it works [1], so we restrict the order to
> 3 (that is PAGE_ALLOC_COSTLY_ORDER).
>=20
> [1] https://www.spinics.net/lists/dm-devel/msg56048.html
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
=2Ecom>
> Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.c=
om>
> Cc: stable@vger.kernel.org	# v6.5+
> Fixes: 5054e778fcd9 ("dm crypt: allocate compound pages if possible")
>=20
> ---
>  drivers/md/dm-crypt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux-2.6/drivers/md/dm-crypt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-crypt.c
> +++ linux-2.6/drivers/md/dm-crypt.c
> @@ -1679,7 +1679,7 @@ static struct bio *crypt_alloc_buffer(st
>  	unsigned int nr_iovecs =3D (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	gfp_t gfp_mask =3D GFP_NOWAIT | __GFP_HIGHMEM;
>  	unsigned int remaining_size;
> -	unsigned int order =3D MAX_ORDER - 1;
> +	unsigned int order =3D PAGE_ALLOC_COSTLY_ORDER;
> =20
>  retry:
>  	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))


--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--JaZFwqy2vaQ13kIE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmU+Ps8ACgkQ24/THMrX
1yyy4wf+M/HkjAHUOykzSkcTW+8halVvS2uzcggOdM5RpP9Djo20fE42OqzroPNv
Ua36RcxTuODyPFrJksGkrQ8N4HdMhceO1aE8d5xddMrZFnRVngJ0efN9TzhRYs+d
fZ0hsRZ78rXlfwVkxugN3clx54gdk3Gob/Z+6Av0d6yT8CQFnRy8X4fVNMFDfW0h
PM1FdVNtdMom3tSeEEkFKO/FWi6dEGTcO4C0pNPuoN8q93HGqZg1Nxj4VQD1yGny
axCjIJl+D5z2mxiPQaPKOkuhOZNZsPo10iFLV8lwtm7Ge0Q5mWXCt2oDzTGcWdQK
v+cA8UEUM+s3Shxt5wXIAoVl28dI7g==
=jJmi
-----END PGP SIGNATURE-----

--JaZFwqy2vaQ13kIE--
