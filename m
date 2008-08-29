From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for August 27
Date: Fri, 29 Aug 2008 18:36:42 +1000
Message-ID: <20080829183642.6994f4dc.sfr@canb.auug.org.au>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au>
	<58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com>
	<200808272145.20627.bzolnier@gmail.com>
	<200808290210.37211.bzolnier@gmail.com>
	<20080829070515.GL20055@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Aug_2008_18_36_42_+1000_s4a5xCxuCRDQeqG1"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080829070515.GL20055@kernel.dk>
Sender: linux-next-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

--Signature=_Fri__29_Aug_2008_18_36_42_+1000_s4a5xCxuCRDQeqG1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bart,

On Fri, 29 Aug 2008 09:05:16 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Fri, Aug 29 2008, Bartlomiej Zolnierkiewicz wrote:
> >=20
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] block: fix part0 handling in bdget_disk() / blk_lookup=
_devt()
> >=20
> > part0 is a "special" partition and doesn't need to have capacity set - =
this
> > fixes regression caused by "block: move __dev from disk to part0" commi=
t.
> >=20
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Jens, please integrate it into the original commit if feasible.
>=20
> Thanks Bart, I folded it into the original commit.

And applied to today's linux-next.

> > On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
> > introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
> > implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
> > enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
> > in no longer bootable systems (+ help entry for the new option says
> > "Say N if you are unsure.").
> >=20
> > Tejun/Jens: please consider changing this.
>=20
> I have change the default to 'n' for now.

I will do this for today as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Aug_2008_18_36_42_+1000_s4a5xCxuCRDQeqG1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki3tRoACgkQjjKRsyhoI8zrOACeL58yGBAQqJo4CPgd19e/IGPv
27IAoLQJMftfG5KW+AYLWwIEZuCwG58h
=ZTQa
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Aug_2008_18_36_42_+1000_s4a5xCxuCRDQeqG1--
