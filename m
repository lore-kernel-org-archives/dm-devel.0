From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 0/2] Introduce the bulk IV mode for improving the
 crypto engine efficiency
Date: Mon, 4 Jan 2016 20:13:43 +0000
Message-ID: <20160104201343.GQ16023@sirena.org.uk>
References: <cover.1450233399.git.baolin.wang@linaro.org>
 <56711C0F.8030105@gmail.com>
 <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com>
 <56885330.9080801@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wHwaWyh5/fUA7Dm/"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56885330.9080801@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Baolin Wang <baolin.wang@linaro.org>, Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, Kent Overstreet <kent.overstreet@gmail.com>, keith.busch@intel.com, tj@kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids


--wHwaWyh5/fUA7Dm/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 02, 2016 at 11:46:08PM +0100, Milan Broz wrote:

> Anyway, I think that you should optimize driver, not add strange hw-depen=
dent
> crypto modes to dmcrypt. This is not the first crypto accelerator that is=
 just not
> suited for this kind of use.

> (If it can process batch of chunks of data each with own IV, then it can =
work
> with dmcrypt, but I think such optimized code should be inside crypto API,
> not in dmcrypt.)

The flip side of this is there is an awful lot of hardware out there
that has basically this pattern and if we can make the difference
between people being able to encrypt or not encrypt their storage due to
performance then that seems like a win.  Getting hardware changes isn't
going to be a fast process.  From a brief look at the crypto layer it
does look there may be things we can do there, if only in terms of
factoring out the common patterns for driving the queue of operations
into the hardware so it's easy for drivers to do the best thing. =20

One thing that occurs to me for the IV programming that has been
proposed for SPI by Martin Sparl (and seen good results on Raspberry PI)
is to insert transfers programming the crypto engine into the stream of
DMA operations so we can keep the hardware busy.  It won't work with
every SoC out there but it will work with a lot of them, it's what
hardware that explicitly supports this will be doing internally.  It's
the sort of thing that would benefit from factoring out, it's a lot of
hassle to implement per driver.

The main thing the out of tree req-dm-crypt code is doing was using a
larger block size which does seem like a reasonable thing to allow
people to tune for performance tradeofffs but I undertand that's a lot
harder to achieve in a good way than one might hope.

--wHwaWyh5/fUA7Dm/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWitJ2AAoJECTWi3JdVIfQ33YH/1d/G6DQGa49xEi7UUxjekRW
GhxVr+EavcII7O0qptSoDjekzvjGKzWwxiS1WHY/1omD8PzHMSfkWCcap1UkRVOk
AoNPkULpeYOT/VqxQXLHHZzyn8Oki9txan3mESIiyoQyyXYsb6bjc6i9OzcBXcPB
bJGYKRlzXVkf/NmzLkeJnRrQ5BpgmsfnS1EquQVILV0y3uhnt7wVhnNLuE8+hSZR
vkzSHhssGrVjX1QhlPbWsT54rcPLcIREVxak+9AtCyOv9RAIQlBbEPk80TX80ST2
a8vWFNmlffrvvLEPnjqA/iNmiDxu6WvKlQblr/Bs21pHgYcCBZZh6GqyI7mO+1E=
=zudk
-----END PGP SIGNATURE-----

--wHwaWyh5/fUA7Dm/--
