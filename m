Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52F52376B;
	Fri,  3 Nov 2023 20:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="aPDouzBs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WgrMvcZN"
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.west.internal (Postfix) with ESMTP id 7D86F32009B5;
	Fri,  3 Nov 2023 16:30:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 03 Nov 2023 16:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1699043413; x=1699129813; bh=KaF+3T3a/TzRSmKZ675q0TaOsBnZDmND6vM
	igefoz7k=; b=aPDouzBsclXJs49u633wD/hecFvWsEatoZ4MZBMC8LVouga+ptV
	AKrk29md0UKEJ1kuAWYMxo/RWSARwcj/ZAk6LC6J6Rj/fr9UVWoAZ7bmm+mKzOOq
	soRQjgJKtcyNOKzhAN3I4kkf83ataywcbfsdoQelFelz4GzIvGvPKIzCB8woUQ7s
	sthaV4+e4r5vvfrSgkZHqpeC5E2PuOXDDeRgTaWFpwCxfbTgAqxvsW4c8wqISiwy
	mQLEFl+Kw+pSIvQyLV2sc7YnAZAuuN5O0Rfom2uUBTlZS9hptLNDaYjSO5oOU5Cw
	bWffFUy7v9jqK5mUls/OfJBgQCKB3BlSCgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1699043413; x=1699129813; bh=KaF+3T3a/TzRS
	mKZ675q0TaOsBnZDmND6vMigefoz7k=; b=WgrMvcZNgrf9ACKU73V+qoPOlcn9u
	1YjIpcE6Uj8SH4jnq6Rjs/KA+ue/LmajvzHTJvCKBD6lBaJqAEPJ6zdcRJerpcnI
	JQAw8DyRdMgfiSJHVV0szZvOJNOczve8UapzHoBNri44588brdmxauwTtiSgPZw0
	yzwcVkyEpLbyrdW6uGPaPvaGiDrvEUD/tt70bs7vasUSkp06AKsQD6Z98/WQF4tu
	nIFW9DFcO36pnMrvvnKL66gG61hNkX4PSAHsGZkhe0Yz/jIVTnTi81D+A7RlAAgQ
	yCB3msbC8VlBWIzCDEuhwz+8yqEAdJHTuiBGHTFtE9IRvZlHw5zbrArVA==
X-ME-Sender: <xms:VFhFZT58VIcfPnTMmuS4UR7kXz0_NKjo6Si1f-k2cBjlGoaRd6rMSA>
    <xme:VFhFZY62thsKp3PDMmitseUoJhio9-eONfNSRdXtZ2fcOmKdLVgASpw7gLYRnM_Lb
    l0235cOHfDKHg>
X-ME-Received: <xmr:VFhFZaemF1sLvX4Qs7aZelwqC3NcroT4Bnfcx7jJr2XVOK3J4A_W9091nctMgnMdGgWSw8HZg3G1M3Esvpw-N_FpkVmOBZpjGMo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtkedgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghr
    vghkucforghrtgiihihkohifshhkihdqifdkohhrvggtkhhiuceomhgrrhhmrghrvghkse
    hinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhep
    hfegieeuieehvdeujeefheffheegheduveevveetvdfhtdegiefgfeekfeeijefhnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghr
    vghksehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:VFhFZUJro8G51H2qFmIffcpxTnuYGFxrrgCxUenatzXwX-QtrdDH0w>
    <xmx:VFhFZXK7DZ41Aef5TItEQx-PJ4ZBvIJcKqU_3L08hHeAB5JzWLhuTA>
    <xmx:VFhFZdzXP8xFDNEQ-_zrUyp41A4lTq5-N54SfN-kVeQPk6J34i5arQ>
    <xmx:VVhFZWb5chh9pBVMC4bXQvMkiLqCF_wiWKYV-OcoUhs4UlgAhBN4EA>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Nov 2023 16:30:09 -0400 (EDT)
Date: Fri, 3 Nov 2023 21:30:07 +0100
From: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUVYT1Xp4+hFT27W@mail-itl>
References: <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
 <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
 <ZUUctamEFtAlSnSV@mail-itl>
 <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yuf1ZxSRHkcmxVTM"
Content-Disposition: inline
In-Reply-To: <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com>


--yuf1ZxSRHkcmxVTM
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 3 Nov 2023 21:30:07 +0100
From: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Fri, Nov 03, 2023 at 10:54:00AM -0600, Keith Busch wrote:
> On Fri, Nov 03, 2023 at 05:15:49PM +0100, Marek Marczykowski-G'orecki wro=
te:
> > On Thu, Nov 02, 2023 at 06:06:33PM +0100, Mikulas Patocka wrote:
> > > Then, try this patch (without "iommu=3Dpanic"), reproduce the deadloc=
k and=20
> > > tell us which one of the "printk" statements is triggered during the=
=20
> > > deadlock.
> >=20
> > The "821" one - see below.
>=20
> Thanks for confirming!
>=20
> Could you try this patch?

Besides min3() being unhappy about types, it works.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--yuf1ZxSRHkcmxVTM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVFWE8ACgkQ24/THMrX
1yyuJwf/QrvaBEdlhG9DYkM9z4WbVbcowiBQExRs882g+TwGp7fkdzpciHy7/T1a
qSblG2ULoUOVzXQrq4FHa8fvfnZm8mgACXTadcxFAZ00cPGhYFS7KNRrenEpx0W0
hWqFpM3jBayFqbDiN0otha5hY8KGhKu3H8AIxVJFFm1QaE2joGK31Xwy9FE5aN05
svFU7EHw1o8CLy6w2UKKorBgYJWFPgRXyGxXuwliN9VkL01pMDuA8t30cZdyDvMs
9bz/kKjkvOFlgMqGXCtL1gUqmzhZ53ZOejGYDavv9IiemNkjDVFF8/Drw7aowzn/
6uQnvCpIAy5TaIUE+G9kpyBm5jYEmQ==
=VPNu
-----END PGP SIGNATURE-----

--yuf1ZxSRHkcmxVTM--
