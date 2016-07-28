From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: What license is multipath-tools under
Date: Thu, 28 Jul 2016 13:26:03 -0400
Message-ID: <1469726763.2295.20.camel@HansenPartnership.com>
References: <1469616127.6204.9.camel@debian.org>
	<26bf809d-9e9e-b4ae-9110-a67819246907@gmail.com>
	<1469724801.17451.27.camel@debian.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6391201060587246551=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469724801.17451.27.camel@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rrs@debian.org, Xose Vazquez Perez <xose.vazquez@gmail.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============6391201060587246551==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kI7/HyvZPlCDlIIPQImB"


--=-kI7/HyvZPlCDlIIPQImB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-28 at 22:23 +0530, Ritesh Raj Sarraf wrote:
> Thanks Xose, for digging this information. But shouldn't this=20
> information go into respective source files?

If there's a COPYING file, there's no need for individual files to have
a copyright.  The licence of the file defaults to whatever COPYING (or
LICENCE or some recognizable top level file says).  A significant
number of Linux Kernel files don't have individual file header copyrigh
ts, if you want an example of this.

> Recently, at Debconf, I came aware of Fossology [1]. It is a=20
> compliance tool for license, copyright and export control scans. I=20
> have spawned off a job [2] and am curious of the result. But looks=20
> like their server may be having a problem at the moment.
>=20
> But it is standard practise in most Free Software projects to define=20
> the licensing proper. And for a project with mixed licenses, it'd be=20
> best to have individual source files mention their license.
>=20

It may be a best practice and even practised by some projects, but if
Linux doesn't do it, it's hard to say it's standard practice.

James

> [1] https://www.fossology.org/
> [2] http://52.26.97.143/repo/?mod=3Dshowjobs
>=20
>=20
> On Thu, 2016-07-28 at 00:19 +0200, Xose Vazquez Perez wrote:
> > On 07/27/2016 12:42 PM, Ritesh Raj Sarraf wrote:
> >=20
> > >=20
> > > I just ran some compliance tools on multipath and the results
> > > weren't very
> > > appealing in regard to licensing and copyright information.
> > >=20
> > > The standard COPYING file mentions LGPL v2.
> > > On the other hand, the majority of the source code has no license
> > > mentioned
> > > in
> > > its header. Some that do have, mention it as GPLv2, and some as
> > > GPLv2+
> >=20
> > "No copyright" or "UNKNOWN" files should be covered by COPYING
> > licence(LGPL
> > v2).
> > Except:
> >=20
> > kpartx/
> > It comes from partx(util-linux), and these files are under "GPL v2"
> > or
> > "GPL v2 or later". Independent binary.
> >=20
> >=20
> > libmultipath/prioritizers/ontap.c
> > It's "GPL v2". But it's a plugin. ???
> >=20
> >=20
> > libmultipath/checkers/cciss_tur.c
> > Source says "GPL v2 or later", and:
> > /*
> >  *  This program originally derived from and inspired by
> >  *  Christophe Varoqui's tur.c, part of libchecker.
> >  */
> > At libmultipath/checkers/tur.c there is no licence, but it's
> > derived from
> > src/sg_turs.c
> > from sg3_utils. And this one is under "GPL v2 or later". But it's a
> > plugin.
> > ???
> >=20
> >=20
> > libmultipath/memory.c
> > libmultipath/memory.h
> > libmultipath/parser.c
> > libmultipath/parser.h
> > libmultipath/vector.c
> > libmultipath/vector.h
> > These comes from keepalived, and they are under "GPL v2 or later".
> >=20
> >=20
> > libmultipath/version.h:
> > "GPL v2 or later".
> >=20
> >=20
> > libmultipath/file.c
> > libmultipath/alias.c
> > Source says:
> > /*
> >  * significant parts of this file were taken from iscsi-bindings.c
> > of the
> >  * linux-iscsi project.
> > And they are under "GPL v2 or later".
> >=20
> >=20
> > libmultipath/uevent.c
> > libmultipath/sysfs.c
> > These come from udev, and they are "GPL v2".
> >=20
> >=20
> > GPL code can not be mixed with LGPL code. So I guess libmultipath/
> > files are
> > "GPL v2" ???
> >=20
> >=20
> > multipath/main.c
> > Under "GPL v2 or later". It's linked with libmultipath.so and
> > libmpathcmd.so.
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-kI7/HyvZPlCDlIIPQImB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXmkArAAoJEAVr7HOZEZN40fsP/iq869MOYW+TpnCwMEQClaEr
HyuSQf3E/pLu5j8wAzJk+hoUxpZxwE/zSgSg1lDp9o427gxlIbiqgvXfgiXYnSE8
fw/Qy+/5VOctDsu+06nlgO305B5IRQbIqyBp2aNRd8Xycwm4QuuTJc0MHIr5q1x3
8jJgnmUe+ceNSmNQnCtMCfBgSykWxrG32+yaDn3uZWLA/B0wFTjRqkMBhbsryUjY
2qLp4KWD8IQPLmNwrjE1lwqBHOIf+j8PA4eivnVr2sMAg853XiwDrylyaJ+OiW+K
8On7I8/tOQvpEJNqojatnJjyTFbO/V2Od4ALorGkAzvyG54vt838fExN1274sPZN
j27seTE04txMRKkQe8a8xIs0KkIFQgbRFOQZ8U5yhiBvmWhUzHudRTp0hWk3PzJI
nftVjwDcrJvEfKRTGqkowP7tY+JwhLZFTmt5Q+IZMCVcFiZHdJhlVYdZpC4c495o
UH8RYmw2pQ2Qg2UOO9iBae5no/UxmW74hf/FyZ6iANo5GpjHMCjqn4cXNLiygQzj
iK2rGGj6FFQyXxHqjMaSjGqEfuUdaQFS0zxBfEZEyVp3vXZ9pfFWUQamFGgm7cYs
diTicG8nlOJ5OTXbn9zmWk4CdI5UhteTbsI+CNJrKvuxa7u/1Ez00LaeIHXfyGox
u3Cx981PHeQ38IowWoBe
=ibCR
-----END PGP SIGNATURE-----

--=-kI7/HyvZPlCDlIIPQImB--


--===============6391201060587246551==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6391201060587246551==--
