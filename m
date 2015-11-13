From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Fri, 13 Nov 2015 11:51:44 +0000
Message-ID: <20151113115144.GR12392@sirena.org.uk>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151111181813.GD12236@redhat.com>
 <CAMz4kuKNAkFG4-f6TU1HRxgkAn+YX-D_tTQAWio-A_np3brr+A@mail.gmail.com>
 <20151112100422.GM12392@sirena.org.uk>
 <5644AFA2.6040201@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="562f9N4fbIs+fPrJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5644AFA2.6040201@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Baolin Wang <baolin.wang@linaro.org>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>, keith.busch@intel.com, jmoyer@redhat.com, tj@kernel.org, bart.vanassche@sandisk.com, "Garg, Dinesh" <dineshg@quicinc.com>
List-Id: dm-devel.ids


--562f9N4fbIs+fPrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2015 at 08:26:26AM -0700, Jens Axboe wrote:
> On 11/12/2015 03:04 AM, Mark Brown wrote:

> >Android now wants to encrypt phones and tablets by default and have been
> >seeing substantial performance hits as a result, we can try to get
> >people to share performance data from productionish systems but it might
> >be difficult.

> Well, shame on them for developing out-of-tree, looks like they are reapi=
ng
> all the benefits of that.

> Guys, we need some numbers, enough with the hand waving. There's no point
> discussing this further until we know how much of a difference it makes to
> handle X MB chunks instead of Y MB chunks. As was previously stated, unle=
ss
> there's a _substantial_ performance benefit, this patchset isn't going
> anywhere.

Yeah, what I'm saying here is that there will issues getting the numbers
=66rom relevant production systems - we are most likely to be looking at
proxies which are hopefully reasonably representative but there's likely
to be more divergence than you'd see just running benchmark workloads on
similar systems to those used in production.

--562f9N4fbIs+fPrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWRc7PAAoJECTWi3JdVIfQVssH/3H4CZgV1sXNGbagnlJMH4PF
wfNmBCGuN6mRIeqEoBFJEmj7ol+bw099rQyVGNh1gTLIJScGRgaqM68cQwvhoNAY
vQdUXl5GBtx2gzn6esBcNaH0FCj39PXFl4476JmsoMeegdqM+w+Lf2ftZzC1asKQ
0Ee5tv7Brn/VNCLYhmLPtwLkLfiA15/yWtV3JADa1cak+gYoszPMYqt3DYCjyqn6
RdUYZN1NaOnoVVKD8ef/MAK6SS6S40I4/ud8VGWXNc0OKAZ9CD5rzVnNwEY7cwfY
cQ07/wCwC4GIKKoAJIDIaR6kIzenE0XlR8kycpW32hWdy3US/mdtsmChzCG359A=
=WM5U
-----END PGP SIGNATURE-----

--562f9N4fbIs+fPrJ--
