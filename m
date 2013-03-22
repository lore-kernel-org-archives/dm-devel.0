From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] dm: dm-cache fails to write the cache device in
 writethrough mode
Date: Fri, 22 Mar 2013 20:21:56 +0000
Message-ID: <1363983716.3728.42.camel@deadeye.wl.decadent.org.uk>
References: <20130322201151.GB5357@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xL1yf2M+VvuXOU057dBO"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130322201151.GB5357@blackbox.djwong.org>
Sender: stable-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Paul Taysom <taysom@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
List-Id: dm-devel.ids


--=-xL1yf2M+VvuXOU057dBO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-22 at 13:11 -0700, Darrick J. Wong wrote:
> The new writethrough strategy for dm-cache issues a bio to the origin dev=
ice,
> remaps the bio to the cache device, and issues the bio to the cache devic=
e.
> However, the block layer modifies bi_sector and bi_size, so we need to pr=
eserve
> these or else nothing gets written to the cache (bi_size =3D=3D 0).  This=
 fixes the
> problem where someone writes a block through the cache, but a subsequent =
reread
> (from the cache) returns old contents.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[...]

This is not the correct way to submit a change to stable.  See
Documentation/stable_kernel_rules.txt

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-xL1yf2M+VvuXOU057dBO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUy9ZOe/yOyVhhEJAQoHvg//Sgjxk/3keq0IR14wAVOFqldqHXYlJ4mf
6rTUfWPLQzxcmPOtOdpRhH8e7tBufe30wTwh/RUmGC9t+vB4U/NzCCwXm5RSl1e6
O5Ur3aoUBBhVw0An/jvcTIXRtYowK9Sc5xDWBsPE6I3QG+jBQB1KkZHdRsbYVJIz
bhrhA+ZVitt0OOiSkBwfgm+Zy1I3BEoutnbJuknn5NkAI7zkWhCnSc5k0IZ6PR9+
zMdIzsQB7F96LFJIE9PO/pM+v92cqDLKWPFGRUzrYlQStOF3M3qzdTn1QSUg3bW/
ipsQklsFlHSQFMdedIMjkAFZtkrXssh/LQ38zpGxT8SynCgSfKEm6037AZhVE7eZ
kBbr5QcR+iAuq8loZuvG8FXEPJCLYTLC5Wp5bU1ntJyUpNyv25AZETiDdOUcd41N
FtRg3hDx21Oo29wxXFAqZIuSgm3YHmfz8whJeZmCWiGlo1dO6QM4ZN4vK6/6/uWT
WkxqdUz1OIHK47XbzDTYJFRFs4fOOjbiyjDC8x9lGXdR9FsufAxV3OadwTYlt9xx
rnBNrUjrIftb2hoXf8YpTAGMeJK9LzkEPGtTDoJazBZD/VfI9sM1bcutEcDmTSQA
m1/pKt0F9LoMJHXxUh0YBvJW73Sz+TwYMt3fIpSYeurEPVRhMnk6DEOqypV4CE0i
91lh8P/QFNw=
=nvqL
-----END PGP SIGNATURE-----

--=-xL1yf2M+VvuXOU057dBO--
