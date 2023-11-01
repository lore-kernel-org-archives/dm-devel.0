Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AEC1841;
	Wed,  1 Nov 2023 02:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="KINf4sO9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LhRGwDbX"
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.west.internal (Postfix) with ESMTP id 2BDA93200917;
	Tue, 31 Oct 2023 22:14:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 31 Oct 2023 22:14:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698804875; x=1698891275; bh=A5pCeYd8MpCWnO0m0EUGUv3Qfvsrj+mL/5N
	x7xBVp5g=; b=KINf4sO9WhA7o6h8Hk/Xq75BsB7qHFQ1ku42ydQ22Ehg2+scMTW
	ee8gFvmQ1p0ufd7/5jYYGrwYYm01MTzKjPA7Z4NQelKBefHqRe5d0AC7W4veojwp
	f2HIzecUbL4eGsJCaDi8a4iokuTwFVVvDjHt1Fm1QBPjrgKVb4Qm1WqSGXjtfHFb
	9f4hBJ9FRf/8K7ryqJzrY0n5DZxxtDVa+bH91haTfmWaigfjjBGHQLC+NWKP0L+C
	eisOpt7CUZ3WnXfc5fhRacY+lYj099l2LTS1tDTxnXHBEBfyC/4HunBuz/wtwszA
	n7Kah5vxpBTFEnfmz2veXrp1Z+ds5zf+YsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698804875; x=1698891275; bh=A5pCeYd8MpCWn
	O0m0EUGUv3Qfvsrj+mL/5Nx7xBVp5g=; b=LhRGwDbX/LHBM1vDHx9SQuNpnu3gw
	v1lOaWlAcHw2K9zmx1pR+8yLw4vsuXqa4kgT0tGOfYMf/+eTANYc6e2t2Uirjr3H
	05fDqS/IaHrgPniWyedsHhKDCtsBV90tUSPqMB4zAQpCG+HRGPnJtXl6pQYZ0i30
	mxUzOKg7eOt9JeumGvfhrjqqm5zgPREbuNxSMla2p+41zbRP9iyH5us0fx5iOz+3
	iDcV7qdk8t/DLr1uGt7t2zcoyqVS448N1eCXz045bCRmJygaBSPBnqYEd43wnwo0
	Z2IFTQ7klnEPcbjKLZdySF43xWQpcRgK5i/ImqVtRUTSLOrtxEOIQg7Zg==
X-ME-Sender: <xms:irRBZQtL85zb5aQBUnpGBMnrKHpW14jWPdLPW5iFDVh4VWTtFh7LLA>
    <xme:irRBZdfxHGlKbM43_oqsNJLtbEQTYlJEvuH13bxSJhQ3m6PYLG70gPzjxTSap4Xx6
    IdeFTuYKW8aOg>
X-ME-Received: <xmr:irRBZbx6Lh4toPYwOItfAA29CcNba-zLtvULOnXBir0s_YVvjy2NybvqqtSt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtfedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:irRBZTOWQg4NJWynqeZZh5ZL4c1-2utINrlrXocqI4oDbLCkRGAsOQ>
    <xmx:irRBZQ-Kk9L-wAGfenTWMCD402yw88L4S6zjsBYMAOtwOXkoCnO7Fw>
    <xmx:irRBZbXelf8IHKu8Dtzv5ra4buC0ATAW3tr2Yua9WyAW6NQNrRhm0g>
    <xmx:i7RBZR2-vF2fZhoSWiOM5mkwHNJ1YD4gorBYpBGKx6iq4zWJ__D3aw>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 31 Oct 2023 22:14:31 -0400 (EDT)
Date: Wed, 1 Nov 2023 03:14:22 +0100
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
Message-ID: <ZUG0gcRhUlFm57qN@mail-itl>
References: <20231030122513.6gds75hxd65gu747@quack3>
 <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OOaoeErUea6n3Riw"
Content-Disposition: inline
In-Reply-To: <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>


--OOaoeErUea6n3Riw
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 1 Nov 2023 03:14:22 +0100
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

On Wed, Nov 01, 2023 at 09:27:24AM +0800, Ming Lei wrote:
> On Tue, Oct 31, 2023 at 11:42=E2=80=AFPM Marek Marczykowski-G=C3=B3recki
> <marmarek@invisiblethingslab.com> wrote:
> >
> > On Tue, Oct 31, 2023 at 03:01:36PM +0100, Jan Kara wrote:
> > > On Tue 31-10-23 04:48:44, Marek Marczykowski-G=C3=B3recki wrote:
> > > > Then tried:
> > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D4 - cannot reproduce,
> > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D5 - cannot reproduce,
> > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D6 - freeze rather quickly
> > > >
> > > > I've retried the PAGE_ALLOC_COSTLY_ORDER=3D4,order=3D5 case several=
 times
> > > > and I can't reproduce the issue there. I'm confused...
> > >
> > > And this kind of confirms that allocations > PAGE_ALLOC_COSTLY_ORDER
> > > causing hangs is most likely just a coincidence. Rather something eit=
her in
> > > the block layer or in the storage driver has problems with handling b=
ios
> > > with sufficiently high order pages attached. This is going to be a bit
> > > painful to debug I'm afraid. How long does it take for you trigger the
> > > hang? I'm asking to get rough estimate how heavy tracing we can affor=
d so
> > > that we don't overwhelm the system...
> >
> > Sometimes it freezes just after logging in, but in worst case it takes
> > me about 10min of more or less `tar xz` + `dd`.
>=20
> blk-mq debugfs is usually helpful for hang issue in block layer or
> underlying drivers:
>=20
> (cd /sys/kernel/debug/block && find . -type f -exec grep -aH . {} \;)
>=20
> BTW,  you can just collect logs of the exact disks if you know what
> are behind dm-crypt,
> which can be figured out by `lsblk`, and it has to be collected after
> the hang is triggered.

dm-crypt lives on the nvme disk, this is what I collected when it
hanged:

nvme0n1/hctx5/type:default
nvme0n1/hctx5/dispatch_busy:0
nvme0n1/hctx5/active:0
nvme0n1/hctx5/run:273
nvme0n1/hctx5/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx5/tags:nr_tags=3D1023
nvme0n1/hctx5/tags:nr_reserved_tags=3D0
nvme0n1/hctx5/tags:active_queues=3D0
nvme0n1/hctx5/tags:bitmap_tags:
nvme0n1/hctx5/tags:depth=3D1023
nvme0n1/hctx5/tags:busy=3D0
nvme0n1/hctx5/tags:cleared=3D7
nvme0n1/hctx5/tags:bits_per_word=3D64
nvme0n1/hctx5/tags:map_nr=3D16
nvme0n1/hctx5/tags:alloc_hint=3D{633, 450, 354, 913, 651, 645}
nvme0n1/hctx5/tags:wake_batch=3D8
nvme0n1/hctx5/tags:wake_index=3D0
nvme0n1/hctx5/tags:ws_active=3D0
nvme0n1/hctx5/tags:ws=3D{
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:	{.wait=3Dinactive},
nvme0n1/hctx5/tags:}
nvme0n1/hctx5/tags:round_robin=3D0
nvme0n1/hctx5/tags:min_shallow_depth=3D4294967295
nvme0n1/hctx5/ctx_map:00000000: 00
nvme0n1/hctx5/flags:alloc_policy=3DFIFO SHOULD_MERGE
nvme0n1/hctx4/cpu4/default_rq_list:000000000d41998f {.op=3DREAD, .cmd_flags=
=3D, .rq_flags=3DIO_STAT, .state=3Didle, .tag=3D65, .internal_tag=3D-1}
nvme0n1/hctx4/cpu4/default_rq_list:00000000d0d04ed2 {.op=3DREAD, .cmd_flags=
=3D, .rq_flags=3DIO_STAT, .state=3Didle, .tag=3D70, .internal_tag=3D-1}
nvme0n1/hctx4/type:default
nvme0n1/hctx4/dispatch_busy:9
nvme0n1/hctx4/active:0
nvme0n1/hctx4/run:20290468
nvme0n1/hctx4/tags_bitmap:00000000: 0000 0000 0000 0000 4240 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx4/tags:nr_tags=3D1023
nvme0n1/hctx4/tags:nr_reserved_tags=3D0
nvme0n1/hctx4/tags:active_queues=3D0
nvme0n1/hctx4/tags:bitmap_tags:
nvme0n1/hctx4/tags:depth=3D1023
nvme0n1/hctx4/tags:busy=3D3
nvme0n1/hctx4/tags:cleared=3D7
nvme0n1/hctx4/tags:bits_per_word=3D64
nvme0n1/hctx4/tags:map_nr=3D16
nvme0n1/hctx4/tags:alloc_hint=3D{899, 846, 390, 472, 73, 439}
nvme0n1/hctx4/tags:wake_batch=3D8
nvme0n1/hctx4/tags:wake_index=3D0
nvme0n1/hctx4/tags:ws_active=3D0
nvme0n1/hctx4/tags:ws=3D{
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:	{.wait=3Dinactive},
nvme0n1/hctx4/tags:}
nvme0n1/hctx4/tags:round_robin=3D0
nvme0n1/hctx4/tags:min_shallow_depth=3D4294967295
nvme0n1/hctx4/ctx_map:00000000: 01
nvme0n1/hctx4/dispatch:00000000b335fa89 {.op=3DWRITE, .cmd_flags=3DNOMERGE,=
 .rq_flags=3DDONTPREP|IO_STAT, .state=3Didle, .tag=3D78, .internal_tag=3D-1}
nvme0n1/hctx4/flags:alloc_policy=3DFIFO SHOULD_MERGE
nvme0n1/hctx4/state:SCHED_RESTART
nvme0n1/hctx3/type:default
nvme0n1/hctx3/dispatch_busy:0
nvme0n1/hctx3/active:0
nvme0n1/hctx3/run:296
nvme0n1/hctx3/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx3/tags:nr_tags=3D1023
nvme0n1/hctx3/tags:nr_reserved_tags=3D0
nvme0n1/hctx3/tags:active_queues=3D0
nvme0n1/hctx3/tags:bitmap_tags:
nvme0n1/hctx3/tags:depth=3D1023
nvme0n1/hctx3/tags:busy=3D0
nvme0n1/hctx3/tags:cleared=3D23
nvme0n1/hctx3/tags:bits_per_word=3D64
nvme0n1/hctx3/tags:map_nr=3D16
nvme0n1/hctx3/tags:alloc_hint=3D{862, 557, 480, 24, 841, 23}
nvme0n1/hctx3/tags:wake_batch=3D8
nvme0n1/hctx3/tags:wake_index=3D0
nvme0n1/hctx3/tags:ws_active=3D0
nvme0n1/hctx3/tags:ws=3D{
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:	{.wait=3Dinactive},
nvme0n1/hctx3/tags:}
nvme0n1/hctx3/tags:round_robin=3D0
nvme0n1/hctx3/tags:min_shallow_depth=3D4294967295
nvme0n1/hctx3/ctx_map:00000000: 00
nvme0n1/hctx3/flags:alloc_policy=3DFIFO SHOULD_MERGE
nvme0n1/hctx2/type:default
nvme0n1/hctx2/dispatch_busy:0
nvme0n1/hctx2/active:0
nvme0n1/hctx2/run:279
nvme0n1/hctx2/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx2/tags:nr_tags=3D1023
nvme0n1/hctx2/tags:nr_reserved_tags=3D0
nvme0n1/hctx2/tags:active_queues=3D0
nvme0n1/hctx2/tags:bitmap_tags:
nvme0n1/hctx2/tags:depth=3D1023
nvme0n1/hctx2/tags:busy=3D0
nvme0n1/hctx2/tags:cleared=3D16
nvme0n1/hctx2/tags:bits_per_word=3D64
nvme0n1/hctx2/tags:map_nr=3D16
nvme0n1/hctx2/tags:alloc_hint=3D{960, 528, 145, 730, 447, 1002}
nvme0n1/hctx2/tags:wake_batch=3D8
nvme0n1/hctx2/tags:wake_index=3D0
nvme0n1/hctx2/tags:ws_active=3D0
nvme0n1/hctx2/tags:ws=3D{
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:	{.wait=3Dinactive},
nvme0n1/hctx2/tags:}
nvme0n1/hctx2/tags:round_robin=3D0
nvme0n1/hctx2/tags:min_shallow_depth=3D4294967295
nvme0n1/hctx2/ctx_map:00000000: 00
nvme0n1/hctx2/flags:alloc_policy=3DFIFO SHOULD_MERGE
nvme0n1/hctx1/type:default
nvme0n1/hctx1/dispatch_busy:0
nvme0n1/hctx1/active:0
nvme0n1/hctx1/run:458
nvme0n1/hctx1/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx1/tags:nr_tags=3D1023
nvme0n1/hctx1/tags:nr_reserved_tags=3D0
nvme0n1/hctx1/tags:active_queues=3D0
nvme0n1/hctx1/tags:bitmap_tags:
nvme0n1/hctx1/tags:depth=3D1023
nvme0n1/hctx1/tags:busy=3D0
nvme0n1/hctx1/tags:cleared=3D31
nvme0n1/hctx1/tags:bits_per_word=3D64
nvme0n1/hctx1/tags:map_nr=3D16
nvme0n1/hctx1/tags:alloc_hint=3D{689, 284, 498, 188, 808, 610}
nvme0n1/hctx1/tags:wake_batch=3D8
nvme0n1/hctx1/tags:wake_index=3D0
nvme0n1/hctx1/tags:ws_active=3D0
nvme0n1/hctx1/tags:ws=3D{
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:	{.wait=3Dinactive},
nvme0n1/hctx1/tags:}
nvme0n1/hctx1/tags:round_robin=3D0
nvme0n1/hctx1/tags:min_shallow_depth=3D4294967295
nvme0n1/hctx1/ctx_map:00000000: 00
nvme0n1/hctx1/flags:alloc_policy=3DFIFO SHOULD_MERGE
nvme0n1/hctx0/type:default
nvme0n1/hctx0/dispatch_busy:0
nvme0n1/hctx0/active:0
nvme0n1/hctx0/run:375
nvme0n1/hctx0/tags_bitmap:00000000: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000010: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000020: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000030: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000040: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000050: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000060: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags_bitmap:00000070: 0000 0000 0000 0000 0000 0000 0000 0000
nvme0n1/hctx0/tags:nr_tags=3D1023
nvme0n1/hctx0/tags:nr_reserved_tags=3D0
nvme0n1/hctx0/tags:active_queues=3D0
nvme0n1/hctx0/tags:bitmap_tags:
nvme0n1/hctx0/tags:depth=3D1023
nvme0n1/hctx0/tags:busy=3D0
nvme0n1/hctx0/tags:cleared=3D6
nvme0n1/hctx0/tags:bits_per_word=3D64
nvme0n1/hctx0/tags:map_nr=3D16
nvme0n1/hctx0/tags:alloc_hint=3D{5, 18, 320, 448, 728, 9}
nvme0n1/hctx0/tags:wake_batch=3D8
nvme0n1/hctx0/tags:wake_index=3D0
nvme0n1/hctx0/tags:ws_active=3D0
nvme0n1/hctx0/tags:ws=3D{
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:	{.wait=3Dinactive},
nvme0n1/hctx0/tags:}
nvme0n1/hctx0/tags:round_robin=3D0
nvme0n1/hctx0/tags:min_shallow_depth=3D4294967295
nvme0n1/hctx0/ctx_map:00000000: 00
nvme0n1/hctx0/flags:alloc_policy=3DFIFO SHOULD_MERGE
nvme0n1/state:SAME_COMP|NONROT|IO_STAT|INIT_DONE|WC|FUA|REGISTERED|NOWAIT
nvme0n1/pm_only:0

This is without any of the patches Mikulas proposed.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--OOaoeErUea6n3Riw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVBtIEACgkQ24/THMrX
1yzGNAf9G86nx39Hl8FvKLLalWaMf6/VbHw9VzbCawSkGhBs6Srbq1PwC0YDsb+p
j1h+FLUaj7IsIxYjCY2k6bUiPBkoA4a+0jvKd8yROj1DWbbo++wibJ2yvXnOUmbD
x0qgjPkBdOKcFk49wEtc13JAj3Fx+JQJM6ykvx+J4hCA/ar8Psu0TfskjAN6tCfA
PZOg5oQsZ8zI9nJG5aPrWtuXDHrNXATcpC7Obs4UKdTq+ASFWl1K5/qc8EAmWO5G
B6OSOYPeQx4VTZKecEaP0WvkdSfpvKrEswCX3mIGbCA1mXtSJd5C0A2GriM/TlBO
Se2t0LvilG/fPDkuS3aHeHmd3qaYWQ==
=GAoT
-----END PGP SIGNATURE-----

--OOaoeErUea6n3Riw--
