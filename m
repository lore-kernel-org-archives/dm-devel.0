Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CC0372;
	Thu,  2 Nov 2023 00:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="PT0LNGhD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mbZXg7UJ"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 8699A5C01BF;
	Wed,  1 Nov 2023 20:38:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 01 Nov 2023 20:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698885535; x=1698971935; bh=XfCwqkrmHX39PAF8DgFnwRKfMHvhyDtQ9mQ
	nwUGuGdk=; b=PT0LNGhDj+vbfNHoMmL2qJ1AuJAWVHGJCctzbVQqfIEQuHvA5B7
	lFevgrg85IyGyvH4TBivJ30VIxMHlpLICzqJyhi23cTG18/2zl1dWY3xh2zygZ7k
	Lrjo+IGCRanEw1SiUYD9XOeccVO6bp2wmrnnPwu7KvHI4++/N4H3uZaGV0nOtwUU
	j1aasyAgjZa9iNtcb9WTf76NKC8EPJY7txIfPO81ieZcHdQlysdr+bFN/Bok+gym
	c9f1e9oh5OPLTVFVUiBpjT4Pr5yRdknVkplRrieIR2xkfiw5BAKnZX9SkEjxr9Mx
	6EGs5lLxvjQzkpQYw/6q3rogweNkOPAKy7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698885535; x=1698971935; bh=XfCwqkrmHX39P
	AF8DgFnwRKfMHvhyDtQ9mQnwUGuGdk=; b=mbZXg7UJ3EtBNWfqqbqJ8fKK2T4xf
	XZCzpWLT/P0bAwS2bHZvyMUBJSqImup9XkzFdTrzCRr0UHr2FAihjCFobrnSwJmo
	c4VLDXr3+lRFItdq+yVw2lZw4VWCYUosMGbD43VCwKSH9gMtleMOF0m4yMUfVk6A
	a60qWGxadK3mPzto7LVL9UCvBjpDSi/OYHp2fTlrs8y58d0AYet4pcIwsG2/pc3J
	BfIiTCBUl6q18ieV7tuvsbh+I9AcGLse2rR2YqVXRUJ2rY+fxtXZBOxCTSHvQ5+r
	zpdPifR8jr8mXT4/A+JfJFiwLVu0JI9lg5setnL1Bi9ts6kPLTAoQXDcA==
X-ME-Sender: <xms:nu9CZTQV5WSWgZxnPousH4Kk1EmLd5mrp-CEczCFo46eBMbNWDFKnA>
    <xme:nu9CZUzbfLKv9gGhccszQW5t5csux4wZ5KyGyazxMrEhIhYdgzZuNTbgdNemtYe5d
    C2duXCzwI-giw>
X-ME-Received: <xmr:nu9CZY3_nzXx8Ugk86rYhCxg_zNTD4YA6ewsHPdCinsBWF7_BFZOIn86bisF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddthedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:nu9CZTDpl7UTRqWsuQZiywimDWE2VCE0pS8lV7mgccpmhX9VmtA6lw>
    <xmx:nu9CZcgts6El5L8QQukb5pWOyzZWEGezDUYuXi_G_goXyV8dHsNIAg>
    <xmx:nu9CZXrKsvleiYQkAhB_jRc5d_wqxUsj5uuAh6m3yQnwPSIfm9_irA>
    <xmx:n-9CZfO1ORKBOgI3zycI-KCXjj60uFnqSD_ERyN6iq_Iqb6eqC2n4A>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Nov 2023 20:38:49 -0400 (EDT)
Date: Thu, 2 Nov 2023 01:38:40 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZULvkPhcpgAVyI8w@mail-itl>
References: <ZT+wDLwCBRB1O+vB@mail-itl>
 <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EW5Jd6ZInl+5b4q+"
Content-Disposition: inline
In-Reply-To: <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>


--EW5Jd6ZInl+5b4q+
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 2 Nov 2023 01:38:40 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Tue, Oct 31, 2023 at 06:24:19PM +0100, Mikulas Patocka wrote:
>=20
>=20
> On Tue, 31 Oct 2023, Mikulas Patocka wrote:
>=20
> >=20
> >=20
> > On Tue, 31 Oct 2023, Marek Marczykowski-G=C3=B3recki wrote:
> >=20
> > > On Tue, Oct 31, 2023 at 03:01:36PM +0100, Jan Kara wrote:
> > > > On Tue 31-10-23 04:48:44, Marek Marczykowski-G=C3=B3recki wrote:
> > > > > Then tried:
> > > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D4 - cannot reproduce,
> > > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D5 - cannot reproduce,
> > > > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D6 - freeze rather quickly
> > > > >=20
> > > > > I've retried the PAGE_ALLOC_COSTLY_ORDER=3D4,order=3D5 case sever=
al times
> > > > > and I can't reproduce the issue there. I'm confused...
> > > >=20
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
> > >=20
> > > Sometimes it freezes just after logging in, but in worst case it takes
> > > me about 10min of more or less `tar xz` + `dd`.
> >=20
> > Hi
> >=20
> > I would like to ask you to try this patch. Revert the changes to "order=
"=20
> > and "PAGE_ALLOC_COSTLY_ORDER" back to normal and apply this patch on a=
=20
> > clean upstream kernel.
> >=20
> > Does it deadlock?
> >=20
> > There is a bug in dm-crypt that it doesn't account large pages in=20
> > cc->n_allocated_pages, this patch fixes the bug.

This patch did not help.

> If the previous patch didn't fix it, try this patch (on a clean upstream=
=20
> kernel).
>
> This patch allocates large pages, but it breaks them up into single-page=
=20
> entries when adding them to the bio.

But this does help.

> If this patch deadlocks, it is a sign that allocating large pages causes=
=20
> the problem.
>=20
> If this patch doesn't deadlock, it is a sign that processing a bio with=
=20
> large pages is the problem.
>=20
> Mikulas
>=20
> ---
>  drivers/md/dm-crypt.c |   26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
>=20
> Index: linux-stable/drivers/md/dm-crypt.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/drivers/md/dm-crypt.c	2023-10-31 17:16:03.000000000=
 +0100
> +++ linux-stable/drivers/md/dm-crypt.c	2023-10-31 17:21:14.000000000 +0100
> @@ -1700,11 +1700,16 @@ retry:
>  		order =3D min(order, remaining_order);
> =20
>  		while (order > 0) {
> +			if (unlikely(percpu_counter_read_positive(&cc->n_allocated_pages) + (=
1 << order) > dm_crypt_pages_per_client))
> +				goto decrease_order;
>  			pages =3D alloc_pages(gfp_mask
>  				| __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN | __GFP_COMP,
>  				order);
> -			if (likely(pages !=3D NULL))
> +			if (likely(pages !=3D NULL)) {
> +				percpu_counter_add(&cc->n_allocated_pages, 1 << order);
>  				goto have_pages;
> +			}
> +decrease_order:
>  			order--;
>  		}
> =20
> @@ -1719,8 +1724,13 @@ retry:
> =20
>  have_pages:
>  		size_to_add =3D min((unsigned)PAGE_SIZE << order, remaining_size);
> -		__bio_add_page(clone, pages, size_to_add, 0);
>  		remaining_size -=3D size_to_add;
> +		while (size_to_add) {
> +			unsigned this_step =3D min(size_to_add, (unsigned)PAGE_SIZE);
> +			__bio_add_page(clone, pages, this_step, 0);
> +			size_to_add -=3D this_step;
> +			pages++;
> +		}
>  	}
> =20
>  	/* Allocate space for integrity tags */
> @@ -1739,13 +1749,21 @@ have_pages:
>  static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio =
*clone)
>  {
>  	struct folio_iter fi;
> +	unsigned skip =3D 0;
> =20
>  	if (clone->bi_vcnt > 0) { /* bio_for_each_folio_all crashes with an emp=
ty bio */
>  		bio_for_each_folio_all(fi, clone) {
> -			if (folio_test_large(fi.folio))
> +			if (skip) {
> +				skip--;
> +				continue;
> +			}
> +			if (folio_test_large(fi.folio)) {
> +				skip =3D (1 << folio_order(fi.folio)) - 1;
> +				percpu_counter_sub(&cc->n_allocated_pages, 1 << folio_order(fi.folio=
));
>  				folio_put(fi.folio);
> -			else
> +			} else {
>  				mempool_free(&fi.folio->page, &cc->page_pool);
> +			}
>  		}
>  	}
>  }


--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--EW5Jd6ZInl+5b4q+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmVC75AACgkQ24/THMrX
1yzj5gf/ToKBkxnC0lV27lc38Y5dkZb8PL1uH65jV1eoAUkXZxyaIBWniybQ8/Sk
z2AnmGLZQ4B+3cPVGRVsRxdVyZKbj4/RLdZNJX9vYZgz6lLrM6/uFqqTeEetoDwP
zMyiy/ZlA43O83rpnIqOCGxnuKxJAlLBPHPxcAUtHZNNFOT8nCs3Zc7sl8pSYcwp
R5+u+lOVJVMTMkjOYLLHeighXpjROK62QHl36L/09op7yX+22A6QhNFgLJRlLxbm
snQ4wRhJ3JlNDZMHm+7W5iXm/+TNzZJHCnAUY+ddSF57FGCHM8vnb8skkfHEKKUt
VtkX13+bgQ6fJKTyDhGAGMxNFnWpmw==
=DePr
-----END PGP SIGNATURE-----

--EW5Jd6ZInl+5b4q+--
