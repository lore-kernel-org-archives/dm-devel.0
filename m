From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for Nov 15 (drivers/md/dm-integrity)
Date: Sat, 16 Nov 2019 09:46:20 +1100
Message-ID: <20191116094620.497663ab@canb.auug.org.au>
References: <20191115190525.77efdf6c@canb.auug.org.au>
        <f368f431-b741-d04f-440b-3d8c3c035537@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/eXHVxvF=qGFYOOsJe.=izN.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f368f431-b741-d04f-440b-3d8c3c035537@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Thornber <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

--Sig_/eXHVxvF=qGFYOOsJe.=izN.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 15 Nov 2019 08:17:48 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on i386:
>=20
> ld: drivers/md/dm-integrity.o: in function `calculate_device_limits':
> dm-integrity.c:(.text.unlikely+0x1e9): undefined reference to `__udivdi3'

Caused by commit

  a236c37603bd ("dm integrity: fix excessive alignment of metadata runs")

=46rom the device-mapper tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/eXHVxvF=qGFYOOsJe.=izN.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3PKrwACgkQAVBC80lX
0GwPbQgAkkzpeWaBKkI6HeFDee9HWiD5sxxknAq8l1BBraY7AeFPNtJ1Ct3pVItd
I46PVCzzqOqwUYE6XVXE0YEqB8hh7pnBVTXdM322uNDGK5K/RHHIUpVvGjUCgLkF
zR5xfv6MkZ4ZT0wBALxe1R2REp/wPsTa5k/g1IcOHumKTq7lOfxTHHa8gdTnuo94
2TmrvOANSyh2/bKwylOppoaJBrVo+5ev+h7YmcdzjLUQVhcaZn8I543LS7kcOhxO
qf8BelKVE6PelvRukZn16qWMosoq7ik/vKfVwY0jqzZKh+OGDjg60XOuyNzsPh8k
ZEGMKkUn4mHU5Hc9yBBIVvfU2vD3NQ==
=SARL
-----END PGP SIGNATURE-----

--Sig_/eXHVxvF=qGFYOOsJe.=izN.--
