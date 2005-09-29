From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: [PATCH] multipath-tools/kpartx - loop support
Date: Thu, 29 Sep 2005 16:25:51 +0200
Message-ID: <20050929142551.GB18325@wavehammer.waldi.eu.org>
References: <20050929131723.GA16105@wavehammer.waldi.eu.org>
	<20050929135216.GX18976@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0765774044=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050929135216.GX18976@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0765774044==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 29, 2005 at 02:52:16PM +0100, Alasdair G Kergon wrote:
> On Thu, Sep 29, 2005 at 03:17:23PM +0200, Bastian Blank wrote:
> > Use kernel definition of __kernel_old_dev_t.
>=20
> That only works if your glibc-kernheaders package defines it=20
> and not all do, which is why it's there.

It breaks the rule to not use the libc supplied linux headers anyway. On
the otherside, the correct dev_t definition is supplied by
linux/types.h for versions which have no selfcontaining linux/loop.h.

>                                           The story seems=20
> to be that that package lags behind the kernel because people don't=20
> update glibc immediately every time something is added to the kernel.

The glibc headers are supposed to match the kernel it is built against.

> So while it's OK to remove it for some distributions, you can't
> remove it upstream.

With the linux/types.h include it should work for the headers from linux
>=3D 1.3.78, it this old enough? Without it seems to be okay for 2.6.

Bastian

--=20
Earth -- mother of the most beautiful women in the universe.
		-- Apollo, "Who Mourns for Adonais?" stardate 3468.1

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEUEARECAAYFAkM7+W8ACgkQnw66O/MvCNFs1wCfX42tZ7nSh1KFV0Zoj88yikjz
Y74Al020ehXNKOU4x3rjjiSLgFu5Aiw=
=7uqF
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--


--===============0765774044==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0765774044==--
