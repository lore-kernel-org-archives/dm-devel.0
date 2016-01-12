From: Mark Brown <broonie@kernel.org>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for
 improving the crypto engine efficiency
Date: Tue, 12 Jan 2016 23:40:25 +0000
Message-ID: <20160112234025.GF6588@sirena.org.uk>
References: <cover.1450233399.git.baolin.wang@linaro.org>
 <56711C0F.8030105@gmail.com>
 <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com>
 <56885330.9080801@gmail.com>
 <20160104201343.GQ16023@sirena.org.uk>
 <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CKsGbYqZLAW+svb0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, Arnd Bergmann <arnd@arndb.de>, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--CKsGbYqZLAW+svb0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2016 at 06:31:19PM -0500, Mikulas Patocka wrote:
> On Mon, 4 Jan 2016, Mark Brown wrote:

> > The main thing the out of tree req-dm-crypt code is doing was using a
> > larger block size which does seem like a reasonable thing to allow
> > people to tune for performance tradeofffs but I undertand that's a lot
> > harder to achieve in a good way than one might hope.

> But as Milan pointed out, that larger block size doesn't work if you=20
> process requests with different sizes - the data encrypted with one=20
> request size won't match if you decrypt them with a different request=20
> size.

Sure, you need to fix that block size.

> Does the hardware encryption you are optimizing for allow setting=20
> arbitrary tweaks in XTS mode? What is the specific driver you are=20
> optimizing for?

This isn't targeted at a specific driver or system, it's trying to make
dm-crypt better able to make use of hardware acceleration in general.

--CKsGbYqZLAW+svb0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWlY7oAAoJECTWi3JdVIfQwx8H/2Rzv5vE20KBn05CUrja+nkt
X4cWPfecFggycjeYIegOEIGUg+4xbVMu7haVLSTWHcNefcOunmljsIWD0+LMFNDI
YmSySH43+BLdR6AMnaEWr3ASAz6WGBUh4TJ/coyQk6wdSBqLjp6Hy42D1QmBbsEf
Z0Xa/pn6ZbCHKuDNyeEpggY2HmByhhSzSWeLEYXG5e5p4hTA9NM6/astLSPTSLfS
WY6R9CpQ5HAUG4i2/FPRxudS5JhhPlZDaq8zrvsHAoeWGZ0YLszTcUArvsCwL9UK
fNyM/kvHDfGcg49lZojsiSQ8+mLssHj/SpW1ydAs4u43yeFtkxX91NnDuqV1r8U=
=26zk
-----END PGP SIGNATURE-----

--CKsGbYqZLAW+svb0--
