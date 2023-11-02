Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F63214AB3;
	Thu,  2 Nov 2023 11:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="N5WuW9tF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ToeFUeiA"
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id DEB8D5C0087;
	Thu,  2 Nov 2023 07:46:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 02 Nov 2023 07:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698925561; x=1699011961; bh=jyR214XHmiYuLiqo14R8R1Hmefqc34vJfyv
	prJgyycI=; b=N5WuW9tFkWLqw8Pnijhdo7CtpshkwsARFGFqwVhaMG9EFkUyTdY
	M2grn94+F+ckmaJLJg90vKyvfoRBEfxTOMMMECHpzzXPYeWafW3pLCo4t/ZtcC71
	TmFFNMFBxd4UYfUNpO+j9tGRWq1y0GFJWUf6evWnQeEZAeDkNsW84Gt9RmZs1yMC
	DVBGivL7HpbIAygmTAwUDC/7UaYnxzByVnkfmlSDPEPpiME3Ddnhmn0SP4cYv9VC
	jumkuS/DhuPXv61wBgZ4u23tiyDoZEGWox8V8Wi7LOxfxju5FZhqUeR3qf9H+MFn
	BQu/ARO/DzlFERK3Hv730B6+y5Z8VVhYxxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698925561; x=1699011961; bh=jyR214XHmiYuL
	iqo14R8R1Hmefqc34vJfyvprJgyycI=; b=ToeFUeiA/zZbb+OeBzfcmtZbAlV6O
	G3Dv1dj+ZhtQLjkV+uEYn1t74MOxFs3MPvD3+yQHPoiS+Ip4ir6l27Bhidu1/fu9
	eH/EA7ZdZT4QGXnPsZb55JNsNqajZednb4flvTpHtNyARMi6gIUWfF6+aoks8zmL
	t91pGDKLGzs/KWPnU2cQ2+iKwQnq90frLX81QY3/B+e8CrWjx60qtFuR9eaTcHDr
	YyPpBTon2oSW04OA72SKcyJ41VR3oHiHisYieYK0e4y4CQQ/TduOGqbAd2OMh1qy
	2OJM9LayXUwOGJtukorW45iQcKfe95slF2JQdIueZOFugDEQDZrl7D/6Q==
X-ME-Sender: <xms:-ItDZRMHktnmpFYetdJ1VgjimzgywAqvd8YLAZOy-qtyGo-fIRSENA>
    <xme:-ItDZT8xAh2sYA_azHc_C55f-DX47iXF56LaMI5zWEMZPPgMOg__gFn65Ts0g7kWt
    647d4kmEpPGNg>
X-ME-Received: <xmr:-ItDZQTqoVGxon6gXacJDtpQLsG7aUI6vm-Dtpw3pfbrRUgGwhLNkgN_BixY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtiedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepieel
    uddvkeejueekhfffteegfeeiffefjeejvdeijedvgfejheetuddvkeffudeinecuffhomh
    grihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhm
X-ME-Proxy: <xmx:-ItDZdunw7LxYGH9cIinZ5fBBq2YxpMRcrfIXDwf6I9ghCVj3Pj9aQ>
    <xmx:-ItDZZf-RMryPiSqznnH9HssE0SbKckQ4tX-GfojqhGw0UFEy7VBrg>
    <xmx:-ItDZZ2sNkJiRt_Pvnco2TF6_lVyiytIJIjmZDbMJ3NBFsex12b3oQ>
    <xmx:-YtDZc9iwYaCveHDyW5vCojBE3h2f0Mvs7o-Yl4b0onbKnCT7OUTfw>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Nov 2023 07:45:56 -0400 (EDT)
Date: Thu, 2 Nov 2023 12:45:54 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUOL8kXVTF1OngeN@mail-itl>
References: <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ryHRs7NcQmS/qwTv"
Content-Disposition: inline
In-Reply-To: <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>


--ryHRs7NcQmS/qwTv
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 2 Nov 2023 12:45:54 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Thu, Nov 02, 2023 at 10:28:57AM +0100, Mikulas Patocka wrote:
>=20
>=20
> On Thu, 2 Nov 2023, Marek Marczykowski-G=C3=B3recki wrote:
>=20
> > On Tue, Oct 31, 2023 at 06:24:19PM +0100, Mikulas Patocka wrote:
> >=20
> > > > Hi
> > > >=20
> > > > I would like to ask you to try this patch. Revert the changes to "o=
rder"=20
> > > > and "PAGE_ALLOC_COSTLY_ORDER" back to normal and apply this patch o=
n a=20
> > > > clean upstream kernel.
> > > >=20
> > > > Does it deadlock?
> > > >=20
> > > > There is a bug in dm-crypt that it doesn't account large pages in=
=20
> > > > cc->n_allocated_pages, this patch fixes the bug.
> >=20
> > This patch did not help.
> >=20
> > > If the previous patch didn't fix it, try this patch (on a clean upstr=
eam=20
> > > kernel).
> > >
> > > This patch allocates large pages, but it breaks them up into single-p=
age=20
> > > entries when adding them to the bio.
> >=20
> > But this does help.
>=20
> Thanks. So we can stop blaming the memory allocator and start blaming the=
=20
> NVMe subsystem.
>=20
>=20
> I added NVMe maintainers to this thread - the summary of the problem is:=
=20
> In dm-crypt, we allocate a large compound page and add this compound page=
=20
> to the bio as a single big vector entry. Marek reports that on his system=
=20
> it causes deadlocks, the deadlocks look like a lost bio that was never=20
> completed. When I chop the large compound page to individual pages in=20
> dm-crypt and add bio vector for each of them, Marek reports that there ar=
e=20
> no longer any deadlocks. So, we have a problem (either hardware or=20
> software) that the NVMe subsystem doesn't like bio vectors with large=20
> bv_len. This is the original bug report:=20
> https://lore.kernel.org/stable/ZTNH0qtmint%2FzLJZ@mail-itl/
>=20
>=20
> Marek, what NVMe devices do you use? Do you use the same device on all 3=
=20
> machines where you hit this bug?

This one is "Star Drive PCIe SSD", another one is "Samsung SSD 970 EVO
Plus 1TB", I can't check the third one right now.

> In the directory /sys/block/nvme0n1/queue: what is the value of=20
> dma_alignment, max_hw_sectors_kb, max_sectors_kb, max_segment_size,=20
> max_segments, virt_boundary_mask?

/sys/block/nvme0n1/queue/dma_alignment:3
/sys/block/nvme0n1/queue/max_hw_sectors_kb:2048
/sys/block/nvme0n1/queue/max_sectors_kb:1280
/sys/block/nvme0n1/queue/max_segment_size:4294967295
/sys/block/nvme0n1/queue/max_segments:128
/sys/block/nvme0n1/queue/virt_boundary_mask:4095

> Try lowring /sys/block/nvme0n1/queue/max_sectors_kb to some small value=
=20
> (for example 64) and test if it helps.

Yes, this helps too.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--ryHRs7NcQmS/qwTv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVDi/IACgkQ24/THMrX
1ywWiAgAi+onSGtXf8qh3OO8wNl5vwpa+xEkcDadwdJPa9ICy67uroUWHAhHQAGR
BQf0lKlq3bFyzRqn8+Zc3CtF4oDTt5NOqymZwhmm3zFvfvBy924TpWe5IGdmqlz6
06VcRIpTlX27WRMqlzYwPPUrUbW9gtQEoSEzZejU4E++YaEgzMkk9YFEYic2PcQ7
XqOmFVswdWqAKliEaOqyqx0aj5BGEM/Hbca7NY1jSUds/YShs6mkXk1GpKrBtmJ+
74TQiwr5nIyERqUvg7dOCE/NYTnyLEVPUtSXQdYVsyfg6Ok9Gg2mp4KDWZu26v4J
9YX3BdqjNVHXhIPOxJ10aDJga0Y0fQ==
=7y+j
-----END PGP SIGNATURE-----

--ryHRs7NcQmS/qwTv--
