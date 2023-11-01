Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA71845;
	Wed,  1 Nov 2023 02:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="oY6rpI/f";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KB2J3QrS"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.west.internal (Postfix) with ESMTP id EC8093200917;
	Tue, 31 Oct 2023 22:16:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 31 Oct 2023 22:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698804962; x=1698891362; bh=0hw/kNdOvPl+FaYJ5iGkWY8ufVDteO0iqsb
	t/Smv8Tw=; b=oY6rpI/f79bS0qf2QYvrxxiVyHcz/DLCarXJEw2kd5HUTo0+ZtV
	J8h4kbC0JRLCf16Xqai58E1iTsS9DmF7uMm6J3Ke4ycqA3cY7SDwo6GWGuwCNcnA
	VW1rj5kyI8Yq1E8z+h5vELxgC2FEfSbtAX2dezPsumjD7lnPpnQIIix+94g18xnm
	gs9fKlQfK3ZA5gWN7c/iX8gsrfT9tGBI6XduIi4lDlmFgpZeCgnaGkoUKBBNAgbe
	DyAUPNGMIbgrI18i+u1EZhJ/kT5OiNlSuiDte02t5MztWRyNnfxgPQko065QXLY3
	Gicia25oJ3PM1ijf5UY5bZp+JPXoO3nIKmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698804962; x=1698891362; bh=0hw/kNdOvPl+F
	aYJ5iGkWY8ufVDteO0iqsbt/Smv8Tw=; b=KB2J3QrSHUkC+JttdPUCP8z8X1B0L
	aGbw4ARAO5AEKgSevPRLH14yl/Cuc8iaAITGPOanuxKty8pi1oiq/pio86bYs9/W
	hj/7d2ornYPM8uPafdT9k5gsOJ+Mqxsm8nWDtPcryECyf3P5Oze39Y22L20dKikV
	exA2YGKYBRneLaD0Ne65WWN4KjxZDqNwkaWQtfdaFZf0VFYNZUP2KXDdRWfpYEcp
	I6jnZ5SXfQKJci1rzk2UZy9esDv/MUIyy0a9FPlt1oZH/E2JcEga1zuAWbQxQSQR
	dA8NQHUUNZmkP2i7V74b3E/o7SJZ2+tW4KoQ/D8vGtb1DEmg4vn1uT5pg==
X-ME-Sender: <xms:4bRBZdBefufYM4hY78cDlmi_ElS6GM-DWQj4q9QbLhVnptusLgufMQ>
    <xme:4bRBZbhasynuheqKoA1XaxFicU5ByZKuJJ_iudpEFMYPbnVGGI2vjio31Qd0iNnBM
    32rAtuTJL0kmA>
X-ME-Received: <xmr:4bRBZYlI3w07hY7GoLcNP6DnxU1aojStjqRC7vWOEL_u3qAyfePzlerh_9YX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtfedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:4bRBZXxkbHRI-FrWcNqwiZcucJj_bliWQ1tLoY_h7VaGfpX8XFuIFw>
    <xmx:4bRBZST1AVvlWGEH84cLp4tY9lMWunh6VLZGRcDBmkGCPCNz4khCxA>
    <xmx:4bRBZaZUKjhWDFaC4E7vIQWbWejDI3yCNu8DlEZ1p52h15p-3UckBQ>
    <xmx:4rRBZXIYIEQmhFP-KP4JqrTBr-BVG2HqgI-s-fw0DraPO0J8oUdMYQ>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 31 Oct 2023 22:15:54 -0400 (EDT)
Date: Wed, 1 Nov 2023 03:15:50 +0100
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
Message-ID: <ZUG016NyTms2073C@mail-itl>
References: <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>
 <ZUG0gcRhUlFm57qN@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Rjmc5GZJD8n9uySH"
Content-Disposition: inline
In-Reply-To: <ZUG0gcRhUlFm57qN@mail-itl>


--Rjmc5GZJD8n9uySH
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 1 Nov 2023 03:15:50 +0100
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

On Wed, Nov 01, 2023 at 03:14:22AM +0100, Marek Marczykowski-G=C3=B3recki w=
rote:
> On Wed, Nov 01, 2023 at 09:27:24AM +0800, Ming Lei wrote:
> > On Tue, Oct 31, 2023 at 11:42=E2=80=AFPM Marek Marczykowski-G=C3=B3recki
> > <marmarek@invisiblethingslab.com> wrote:
> > >
> > > On Tue, Oct 31, 2023 at 03:01:36PM +0100, Jan Kara wrote:
> > > > On Tue 31-10-23 04:48:44, Marek Marczykowski-G=C3=B3recki wrote:
> > > > > Then tried:
> > > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D4 - cannot reproduce,
> > > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D5 - cannot reproduce,
> > > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D6 - freeze rather quickly
> > > > >
> > > > > I've retried the PAGE_ALLOC_COSTLY_ORDER=3D4,order=3D5 case sever=
al times
> > > > > and I can't reproduce the issue there. I'm confused...
> > > >
> > > > And this kind of confirms that allocations > PAGE_ALLOC_COSTLY_ORDER
> > > > causing hangs is most likely just a coincidence. Rather something e=
ither in
> > > > the block layer or in the storage driver has problems with handling=
 bios
> > > > with sufficiently high order pages attached. This is going to be a =
bit
> > > > painful to debug I'm afraid. How long does it take for you trigger =
the
> > > > hang? I'm asking to get rough estimate how heavy tracing we can aff=
ord so
> > > > that we don't overwhelm the system...
> > >
> > > Sometimes it freezes just after logging in, but in worst case it takes
> > > me about 10min of more or less `tar xz` + `dd`.
> >=20
> > blk-mq debugfs is usually helpful for hang issue in block layer or
> > underlying drivers:
> >=20
> > (cd /sys/kernel/debug/block && find . -type f -exec grep -aH . {} \;)
> >=20
> > BTW,  you can just collect logs of the exact disks if you know what
> > are behind dm-crypt,
> > which can be figured out by `lsblk`, and it has to be collected after
> > the hang is triggered.
>=20
> dm-crypt lives on the nvme disk, this is what I collected when it
> hanged:
>=20
> nvme0n1/hctx5/type:default
> nvme0n1/hctx5/dispatch_busy:0
> nvme0n1/hctx5/active:0
> nvme0n1/hctx5/run:273
> nvme0n1/hctx5/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx5/tags:nr_tags=3D1023
> nvme0n1/hctx5/tags:nr_reserved_tags=3D0
> nvme0n1/hctx5/tags:active_queues=3D0
> nvme0n1/hctx5/tags:bitmap_tags:
> nvme0n1/hctx5/tags:depth=3D1023
> nvme0n1/hctx5/tags:busy=3D0
> nvme0n1/hctx5/tags:cleared=3D7
> nvme0n1/hctx5/tags:bits_per_word=3D64
> nvme0n1/hctx5/tags:map_nr=3D16
> nvme0n1/hctx5/tags:alloc_hint=3D{633, 450, 354, 913, 651, 645}
> nvme0n1/hctx5/tags:wake_batch=3D8
> nvme0n1/hctx5/tags:wake_index=3D0
> nvme0n1/hctx5/tags:ws_active=3D0
> nvme0n1/hctx5/tags:ws=3D{
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:	{.wait=3Dinactive},
> nvme0n1/hctx5/tags:}
> nvme0n1/hctx5/tags:round_robin=3D0
> nvme0n1/hctx5/tags:min_shallow_depth=3D4294967295
> nvme0n1/hctx5/ctx_map:00000000: 00
> nvme0n1/hctx5/flags:alloc_policy=3DFIFO SHOULD_MERGE
> nvme0n1/hctx4/cpu4/default_rq_list:000000000d41998f {.op=3DREAD, .cmd_fla=
gs=3D, .rq_flags=3DIO_STAT, .state=3Didle, .tag=3D65, .internal_tag=3D-1}
> nvme0n1/hctx4/cpu4/default_rq_list:00000000d0d04ed2 {.op=3DREAD, .cmd_fla=
gs=3D, .rq_flags=3DIO_STAT, .state=3Didle, .tag=3D70, .internal_tag=3D-1}
> nvme0n1/hctx4/type:default
> nvme0n1/hctx4/dispatch_busy:9
> nvme0n1/hctx4/active:0
> nvme0n1/hctx4/run:20290468
> nvme0n1/hctx4/tags_bitmap:00000000: 0000 0000 0000 0000 4240 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx4/tags:nr_tags=3D1023
> nvme0n1/hctx4/tags:nr_reserved_tags=3D0
> nvme0n1/hctx4/tags:active_queues=3D0
> nvme0n1/hctx4/tags:bitmap_tags:
> nvme0n1/hctx4/tags:depth=3D1023
> nvme0n1/hctx4/tags:busy=3D3
> nvme0n1/hctx4/tags:cleared=3D7
> nvme0n1/hctx4/tags:bits_per_word=3D64
> nvme0n1/hctx4/tags:map_nr=3D16
> nvme0n1/hctx4/tags:alloc_hint=3D{899, 846, 390, 472, 73, 439}
> nvme0n1/hctx4/tags:wake_batch=3D8
> nvme0n1/hctx4/tags:wake_index=3D0
> nvme0n1/hctx4/tags:ws_active=3D0
> nvme0n1/hctx4/tags:ws=3D{
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:	{.wait=3Dinactive},
> nvme0n1/hctx4/tags:}
> nvme0n1/hctx4/tags:round_robin=3D0
> nvme0n1/hctx4/tags:min_shallow_depth=3D4294967295
> nvme0n1/hctx4/ctx_map:00000000: 01
> nvme0n1/hctx4/dispatch:00000000b335fa89 {.op=3DWRITE, .cmd_flags=3DNOMERG=
E, .rq_flags=3DDONTPREP|IO_STAT, .state=3Didle, .tag=3D78, .internal_tag=3D=
-1}
> nvme0n1/hctx4/flags:alloc_policy=3DFIFO SHOULD_MERGE
> nvme0n1/hctx4/state:SCHED_RESTART
> nvme0n1/hctx3/type:default
> nvme0n1/hctx3/dispatch_busy:0
> nvme0n1/hctx3/active:0
> nvme0n1/hctx3/run:296
> nvme0n1/hctx3/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx3/tags:nr_tags=3D1023
> nvme0n1/hctx3/tags:nr_reserved_tags=3D0
> nvme0n1/hctx3/tags:active_queues=3D0
> nvme0n1/hctx3/tags:bitmap_tags:
> nvme0n1/hctx3/tags:depth=3D1023
> nvme0n1/hctx3/tags:busy=3D0
> nvme0n1/hctx3/tags:cleared=3D23
> nvme0n1/hctx3/tags:bits_per_word=3D64
> nvme0n1/hctx3/tags:map_nr=3D16
> nvme0n1/hctx3/tags:alloc_hint=3D{862, 557, 480, 24, 841, 23}
> nvme0n1/hctx3/tags:wake_batch=3D8
> nvme0n1/hctx3/tags:wake_index=3D0
> nvme0n1/hctx3/tags:ws_active=3D0
> nvme0n1/hctx3/tags:ws=3D{
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:	{.wait=3Dinactive},
> nvme0n1/hctx3/tags:}
> nvme0n1/hctx3/tags:round_robin=3D0
> nvme0n1/hctx3/tags:min_shallow_depth=3D4294967295
> nvme0n1/hctx3/ctx_map:00000000: 00
> nvme0n1/hctx3/flags:alloc_policy=3DFIFO SHOULD_MERGE
> nvme0n1/hctx2/type:default
> nvme0n1/hctx2/dispatch_busy:0
> nvme0n1/hctx2/active:0
> nvme0n1/hctx2/run:279
> nvme0n1/hctx2/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx2/tags:nr_tags=3D1023
> nvme0n1/hctx2/tags:nr_reserved_tags=3D0
> nvme0n1/hctx2/tags:active_queues=3D0
> nvme0n1/hctx2/tags:bitmap_tags:
> nvme0n1/hctx2/tags:depth=3D1023
> nvme0n1/hctx2/tags:busy=3D0
> nvme0n1/hctx2/tags:cleared=3D16
> nvme0n1/hctx2/tags:bits_per_word=3D64
> nvme0n1/hctx2/tags:map_nr=3D16
> nvme0n1/hctx2/tags:alloc_hint=3D{960, 528, 145, 730, 447, 1002}
> nvme0n1/hctx2/tags:wake_batch=3D8
> nvme0n1/hctx2/tags:wake_index=3D0
> nvme0n1/hctx2/tags:ws_active=3D0
> nvme0n1/hctx2/tags:ws=3D{
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:	{.wait=3Dinactive},
> nvme0n1/hctx2/tags:}
> nvme0n1/hctx2/tags:round_robin=3D0
> nvme0n1/hctx2/tags:min_shallow_depth=3D4294967295
> nvme0n1/hctx2/ctx_map:00000000: 00
> nvme0n1/hctx2/flags:alloc_policy=3DFIFO SHOULD_MERGE
> nvme0n1/hctx1/type:default
> nvme0n1/hctx1/dispatch_busy:0
> nvme0n1/hctx1/active:0
> nvme0n1/hctx1/run:458
> nvme0n1/hctx1/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx1/tags:nr_tags=3D1023
> nvme0n1/hctx1/tags:nr_reserved_tags=3D0
> nvme0n1/hctx1/tags:active_queues=3D0
> nvme0n1/hctx1/tags:bitmap_tags:
> nvme0n1/hctx1/tags:depth=3D1023
> nvme0n1/hctx1/tags:busy=3D0
> nvme0n1/hctx1/tags:cleared=3D31
> nvme0n1/hctx1/tags:bits_per_word=3D64
> nvme0n1/hctx1/tags:map_nr=3D16
> nvme0n1/hctx1/tags:alloc_hint=3D{689, 284, 498, 188, 808, 610}
> nvme0n1/hctx1/tags:wake_batch=3D8
> nvme0n1/hctx1/tags:wake_index=3D0
> nvme0n1/hctx1/tags:ws_active=3D0
> nvme0n1/hctx1/tags:ws=3D{
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:	{.wait=3Dinactive},
> nvme0n1/hctx1/tags:}
> nvme0n1/hctx1/tags:round_robin=3D0
> nvme0n1/hctx1/tags:min_shallow_depth=3D4294967295
> nvme0n1/hctx1/ctx_map:00000000: 00
> nvme0n1/hctx1/flags:alloc_policy=3DFIFO SHOULD_MERGE
> nvme0n1/hctx0/type:default
> nvme0n1/hctx0/dispatch_busy:0
> nvme0n1/hctx0/active:0
> nvme0n1/hctx0/run:375
> nvme0n1/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 00=
00
> nvme0n1/hctx0/tags:nr_tags=3D1023
> nvme0n1/hctx0/tags:nr_reserved_tags=3D0
> nvme0n1/hctx0/tags:active_queues=3D0
> nvme0n1/hctx0/tags:bitmap_tags:
> nvme0n1/hctx0/tags:depth=3D1023
> nvme0n1/hctx0/tags:busy=3D0
> nvme0n1/hctx0/tags:cleared=3D6
> nvme0n1/hctx0/tags:bits_per_word=3D64
> nvme0n1/hctx0/tags:map_nr=3D16
> nvme0n1/hctx0/tags:alloc_hint=3D{5, 18, 320, 448, 728, 9}
> nvme0n1/hctx0/tags:wake_batch=3D8
> nvme0n1/hctx0/tags:wake_index=3D0
> nvme0n1/hctx0/tags:ws_active=3D0
> nvme0n1/hctx0/tags:ws=3D{
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:	{.wait=3Dinactive},
> nvme0n1/hctx0/tags:}
> nvme0n1/hctx0/tags:round_robin=3D0
> nvme0n1/hctx0/tags:min_shallow_depth=3D4294967295
> nvme0n1/hctx0/ctx_map:00000000: 00
> nvme0n1/hctx0/flags:alloc_policy=3DFIFO SHOULD_MERGE
> nvme0n1/state:SAME_COMP|NONROT|IO_STAT|INIT_DONE|WC|FUA|REGISTERED|NOWAIT
> nvme0n1/pm_only:0
>=20
> This is without any of the patches Mikulas proposed.

And BTW, an attempt to access another partition on the same disk (not
covered with dm-crypt) hangs too.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--Rjmc5GZJD8n9uySH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVBtNcACgkQ24/THMrX
1yy5cAgAj8NrsDACOJnHYT9BUDoyqdyHtJpzjgehsiArQPARf002A9PlCdU1vmnN
xePB8hT3ZIi0uHRn3OmwkaVwScKXPtQap4kuywe/73onMKglajVeifUXTpc92l16
Jwrg0nb1Wp6xrJ55AispYsMu9CvBSVqCC1fzvOPfqvC4y2UekVJnsdk2UWHzKZmB
IdHJbrdGSGrvqbzBgKY6AFIZ2ziUZU3Ev7MaJn5Mk8wg8okc82eOEj7UQvVXt8eC
hYMZACAp5qqSHA67Nc9e0EnEA7MaaSjLweu12oBFItiXIMjcKjYI7YaDFZX+gOCa
HaU48QunvN8DGW+A7Bf0gJy8+cSyXA==
=ry4r
-----END PGP SIGNATURE-----

--Rjmc5GZJD8n9uySH--
