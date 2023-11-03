Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1301A585;
	Fri,  3 Nov 2023 15:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="w96ZssLt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Tc3yw/8i"
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.west.internal (Postfix) with ESMTP id A1DF33200921;
	Fri,  3 Nov 2023 11:01:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 03 Nov 2023 11:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1699023686; x=1699110086; bh=8rI9gXS7PRI2oTRO29ALzS6qReZNHb1zj/h
	ti9DlwAo=; b=w96ZssLttYEYRJHkH7AbUgFmzxSm9R0UX6HonBkBV4JTc09juJ6
	zOs4kpvDt0Rjllhy8Mg/lp/LedBBMS0wa4Hx33ybYAw2Uq8RIztol1nuJ3GL7qch
	SKhUIIzo3/uUbuOhuPz8tqQ2v/NRIH4eBmKJCQrWCh1NTaa+Y0z7cRikixE8R4dl
	XBz50Uvu3TD6qtDQ7gxkYbUp+gd9nRhDI3GO0XNMXNFX+CLmzKukfO1dlfa5R4OK
	zUT8JQe1fhX8tVgoEZjlhDRSoPTZ4Co/Q33zIGXT8N9A+YFmfXwblI4VptLvv+VT
	DMFwJQnzbxxY4CR8kYLQc+Yw5pux+IIH7Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1699023686; x=1699110086; bh=8rI9gXS7PRI2o
	TRO29ALzS6qReZNHb1zj/hti9DlwAo=; b=Tc3yw/8iSXzh40pTuZcHpImoly+ew
	7HN9xOokJDzzlbawsfta1TmGebJlQdCwJcxPuPPR9Utqt4rTwET6GYSHyguvR1er
	kftDET/nagoXCad56oCIQLVXQWPuoPfdI05VFnQDAVnqKZixUEz+rwib2jngjURu
	HkZS3ZpMjbRJNoyUl3TN26KD6S6UZ+0EYwDkjqp6DyaX0bt3TFiL5n0g/6DvfH/L
	1xaiyTYNPoX+tvWb6dVK3XRPooCkeBqK8G29bljJvMTN2R7WwuD/WeJ3DMo9AYM0
	Q1mOeQ+ucdeWPqW9pYcjOg7QbtL4pX2hEEZhudUeI5HkbULGjlnWGyG7Q==
X-ME-Sender: <xms:RAtFZesuDBgmtXQQmrC3txh3tPhYeL_K74o5l_i8zNJ_he1VyyXwTg>
    <xme:RAtFZTc48YG2caMuraTQ9IefKMX1W3zWha1C5Z27td1IQVbs3l6TpASt04f0h--xt
    b63gzrGuSWsog>
X-ME-Received: <xmr:RAtFZZyxSoi-y8ftEJXBU49VVzjSoi2u3gIHDc7eC4HUY-sgOKFM8Avz9Du2YUxsGLbrymwJ7MKz7GteTOqoV1l1IMylByRJcVI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddtkedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:RAtFZZMzE2wYFu6UoTeRn6K505TltGpU-tckaqm-9a3Flrd91L9IPA>
    <xmx:RAtFZe_LSoaxWy_KFPEBVhaIY-GjaUI1QhUYgGm25b5OkF5z-z6Zuw>
    <xmx:RAtFZRUrTCSBU7ZKhOVYyi3SVRXbVFZXoFaQstXF2X2PxvjxVhGwdA>
    <xmx:RgtFZQcwZf5BiNLX260xrKD1g4tsKhuMdTvNQG-D8hJKf0FtuNnIGg>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Nov 2023 11:01:22 -0400 (EDT)
Date: Fri, 3 Nov 2023 16:01:19 +0100
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
Message-ID: <ZUULQBAwS2/KknwH@mail-itl>
References: <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
 <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jJXFS76+C6nnDWam"
Content-Disposition: inline
In-Reply-To: <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>


--jJXFS76+C6nnDWam
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 3 Nov 2023 16:01:19 +0100
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

On Thu, Nov 02, 2023 at 06:06:33PM +0100, Mikulas Patocka wrote:
>=20
>=20
> On Thu, 2 Nov 2023, Marek Marczykowski-G=C3=B3recki wrote:
>=20
> > On Thu, Nov 02, 2023 at 10:28:57AM +0100, Mikulas Patocka wrote:
> >=20
> > > Try lowring /sys/block/nvme0n1/queue/max_sectors_kb to some small val=
ue=20
> > > (for example 64) and test if it helps.
> >=20
> > Yes, this helps too.
>=20
> On a plain upstream kernel with no other modifications (and with default=
=20
> max_sectors_kb), set the value /sys/module/nvme/parameters/sgl_threshold=
=20
> to "0" and test it if it deadlocks. Then, set this value to "1" and test=
=20
> it again.

Got deadlock wit both values.

> Revert sgl_threshold back to the default (32768). Boot the kernel with th=
e=20
> option "iommu=3Dpanic". Reproduce the deadlock and if you get a kernel=20
> panic, send us the panic log.

This is a Xen PV, so Linux is not in charge of IOMMU here. And there is
SWIOTLB involved (64MB of it), I'm not sure if for every DMA, but
definitely for some.=20

> Then, try this patch (without "iommu=3Dpanic"), reproduce the deadlock an=
d=20
> tell us which one of the "printk" statements is triggered during the=20
> deadlock.

I'll try this next.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--jJXFS76+C6nnDWam
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVFC0AACgkQ24/THMrX
1yxTwAf/SFlkRMbe2ZO3nNL4wgyZQkhMn5+snIYJwfkUhabco4QTc1GHGfsaMD7N
fjghgVc3TYnCGTU/vIMZlZg+zv+6Ol2Sp2XIoglAX7EhpHuHdgb6X+RnOk0jNvBr
BqvMILFZdElEuB260lKCrH1xV2CGDo+MmvU18UszgOmy3uMR8Pb6b493ckklabyC
w+p80dzKcjNSKzSpMtjU/w21s0dWgFGoSouz9xqtQFWQEHjLw8TptA3+qSSFl/Yq
VlTy+zGB+Buj3qMOzXW97roTJH8KxI7I9wdbKboZWq3EXH7eFD9t6k000i72z/6T
qTVgLfU0itg1QJHAFMcAV0LsZKkEJA==
=bk7Z
-----END PGP SIGNATURE-----

--jJXFS76+C6nnDWam--
