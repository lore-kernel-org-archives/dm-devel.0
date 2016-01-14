From: Mark Brown <broonie@kernel.org>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for
 improving the crypto engine efficiency
Date: Thu, 14 Jan 2016 11:35:27 +0000
Message-ID: <20160114113527.GR6588@sirena.org.uk>
References: <cover.1450233399.git.baolin.wang@linaro.org>
 <56711C0F.8030105@gmail.com>
 <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com>
 <56885330.9080801@gmail.com>
 <20160104201343.GQ16023@sirena.org.uk>
 <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com>
 <20160112234025.GF6588@sirena.org.uk>
 <alpine.LRH.2.02.1601122111040.24452@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="aO2SyuDEANnesPMC"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1601122111040.24452@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, Arnd Bergmann <arnd@arndb.de>, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--aO2SyuDEANnesPMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2016 at 09:13:19PM -0500, Mikulas Patocka wrote:
> On Tue, 12 Jan 2016, Mark Brown wrote:

> > This isn't targeted at a specific driver or system, it's trying to make
> > dm-crypt better able to make use of hardware acceleration in general.

> If the hardware acceleration doesn't allow to set arbitrary XTS tweak,=20
> then this "large block" optimization on XTS can't be done at all.

> So, we need to know which driver(s) you want to optimize for and how do=
=20
> those driver(s) handle tweak generation.

Unfortunately the reality is just as I described it - we're looking for
general improvements, not at specific devices (well, Linaro is mainly
interested in ARM based SoCs but the range of ARM SoCs is such that that
that doesn't really narrow things down).  It's probably better to ask if
there exists any hardware which could use this usefully, software only
implementations (or hardware that only does AES) at least give us
control over supplying the tweak.

--aO2SyuDEANnesPMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWl4f/AAoJECTWi3JdVIfQo5wH/AoKG6I1KT5tbYm+WK2ddlYP
WWXZO2LNFy8l2WES7I7ZGeC9AT9/VBY8ldDZZhOIStlJe66GzRbyQDQqgf+dhD6O
xXK8dYrr2AoFy6mOXL+E+9yGVB1A/8spyVpwfm9+FObf/D2Irft1GRP0KDYagYKS
d2GM8cro/6J4UB75eeI2P11iNn9Kf3/hKNNl17q7b+j2Vk8tSCuPYB94CpoEeylf
1crHv3Dtu8tOZmpDcHnRQ12OdTcXVy3r+oy/WqbETbYbaKYdlo9xMOt3CYDhl3it
pnEEKKBobGKJjGnKQmRAyhSQqneQAqMD48R2/Fa4FYhIRc+nPGjIWRWTbaR/28o=
=6L9f
-----END PGP SIGNATURE-----

--aO2SyuDEANnesPMC--
