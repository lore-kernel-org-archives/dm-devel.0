Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68180367;
	Wed,  1 Nov 2023 02:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="ld3shsB5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tFQ9bzhS"
Received: from compute7.internal (compute7.nyi.internal [10.202.2.48])
	by mailout.west.internal (Postfix) with ESMTP id 64F5B320091B;
	Tue, 31 Oct 2023 22:35:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Tue, 31 Oct 2023 22:35:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698806122; x=1698892522; bh=toWqzNW+iMWIeaM1eKZlhsB3zxFYDFs0dkO
	c+aPifIU=; b=ld3shsB5i53LUbI8stbuQcrPojZ+KazagqOv0Np+VbzzYbskbyn
	nOEdMpMxUnSipNFZWQYY+HZblHQC6+4uZCc6cbWPGy4K/yGqBvTcQ4Hwt3urFK9b
	Tm8TiEdSsZEuO0XK5Ci7LaDS/1keSdwaCfqohaDymR6/WC8jRKtYDU1A8Nj91iP1
	nhhKKOwYHLTEaBI7CjwwHnG2DACCYdwBeygA2HlZL/3CFFV2KWHb4dYhKxI4wMQs
	L2amSD98EvEBHgN+6mgUTB3ctdVSQMRr0t0rdIO5oNhvqNYFBUEDZ4+sdufRjJjl
	swcxMPE+wLzRf5B5K8KA0YoIzCSepCJ8Nsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698806122; x=1698892522; bh=toWqzNW+iMWIe
	aM1eKZlhsB3zxFYDFs0dkOc+aPifIU=; b=tFQ9bzhS2/avGJKX0gaARz+7fU8Nw
	KLi88v+sguvk13Yb6vtThVydHBHjRTP4voFUJLX5vr1AiH6/5eHo9Tn8NqABRcO6
	HKii73SnkcKwYtWpV2czb3H/ZEVeYPlBSIuO5rqbWVp7RLEFrpUJehnzT0jMHHCm
	AzQ/Y+ji2qnp7DWjYtxiflXf+lY3UTppVEQE0GKPm4LoeycA+whAF5TNDgSRzwN8
	a9kL+eSZeU+CnG9DuhIH4Ef2qGzj4AMQ7nRgOi6SLdyitDQhcMRWCgN3tZhVZpfp
	fnmsXqt3yBh+Yay8Ow16WpJb/KaubmA8v60kkj6Cs4WAFRuI//6JiJYlA==
X-ME-Sender: <xms:ablBZRtHKUxKOIIadLbjX2wCzAkl1AZALRDCpYyrfmYRtn4JcC7S3A>
    <xme:ablBZaekT8JpXTIlERpS13LCt5gY5-nASIBc0vu-cSM1ueEpo73VAYWH0Rc7K2IaT
    KbLRFJMFC2aPw>
X-ME-Received: <xmr:ablBZUx9K91s3oDUMcClUZiy__EnDUrVdcw1rV019bhmdIqTQcg0a_pDoWuZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtfedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:ablBZYMNCu2B1E0GR5yfu69YnR8DtVI1ndRDDLvZp2WZ0F6obWFwjw>
    <xmx:ablBZR83c0AjK3QyOty1MRzv0bp3vxxNiD7Pkx-uzE2up-aNqOy0WQ>
    <xmx:ablBZYXuDijSLc6iWnn2OvsXTqfHla4Xiuppu69JNiY2vrJZUsO_zQ>
    <xmx:arlBZS3PIW4M9zP1D4-aCE40f191q-QhjAF5eFY_OXbpgVnp2JkIYA>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 31 Oct 2023 22:35:18 -0400 (EDT)
Date: Wed, 1 Nov 2023 03:35:14 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUG5ZCSS1/tMUgql@mail-itl>
References: <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>
 <ZUG0gcRhUlFm57qN@mail-itl>
 <ZUG016NyTms2073C@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="34v3My9/eDDcajxk"
Content-Disposition: inline
In-Reply-To: <ZUG016NyTms2073C@mail-itl>


--34v3My9/eDDcajxk
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 1 Nov 2023 03:35:14 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Wed, Nov 01, 2023 at 03:15:50AM +0100, Marek Marczykowski-G=C3=B3recki w=
rote:
> And BTW, an attempt to access another partition on the same disk (not
> covered with dm-crypt) hangs too.

No, not sure about that part, it was rather reading /bin/ls hanging...

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--34v3My9/eDDcajxk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVBuWQACgkQ24/THMrX
1ywBCwf+NBJd0oU6k0s/Q1kRXigL0eXZ/7To0/Tv3r7ASDyuqxTtjU/Ncs9/QqZ2
vguzFCGPHY03deZSBy0o6ScY5cVBK32IHYDcAq1klnTpUuwN6JAQ7NvOgyWRV/4k
do7Nu4vUT/KG/BLy7qx6GqWDyxWsDDNEkm/mKEzwOBeyYvVLyKkPExkrxkkAXiGm
R7OyiGyCJkhM2sPY4RCgkBaYk9H0OMwsF0vnrFO5zTCE/1Um7PfqrDawXiHOU2us
Fv6mSGyrHvbnJ/avVhYpSfqjsqSazkjFI8sDAO0ym6ZVTR/78AkvWR3IWbMBO2Xw
70vJPYpCwlA9DrmlSnxxh/VTqihCqg==
=Lw5K
-----END PGP SIGNATURE-----

--34v3My9/eDDcajxk--
