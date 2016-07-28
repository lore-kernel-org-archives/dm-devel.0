From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: What license is multipath-tools under
Date: Thu, 28 Jul 2016 14:59:33 -0400
Message-ID: <1469732373.2295.43.camel@HansenPartnership.com>
References: <1469616127.6204.9.camel@debian.org>
	<26bf809d-9e9e-b4ae-9110-a67819246907@gmail.com>
	<1469724801.17451.27.camel@debian.org>
	<1469726763.2295.20.camel@HansenPartnership.com>
	<1469731260.4380.19.camel@debian.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8121575489862573331=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469731260.4380.19.camel@debian.org>
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


--===============8121575489862573331==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-2aPHYe9IrU//ve4roKPU"


--=-2aPHYe9IrU//ve4roKPU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-07-29 at 00:11 +0530, Ritesh Raj Sarraf wrote:
> Hello James,
>=20
> On Thu, 2016-07-28 at 13:26 -0400, James Bottomley wrote:
> > On Thu, 2016-07-28 at 22:23 +0530, Ritesh Raj Sarraf wrote:
> > > Thanks Xose, for digging this information. But shouldn't this=20
> > > information go into respective source files?
> >=20
> > If there's a COPYING file, there's no need for individual files to
> > have
> > a copyright.  The licence of the file defaults to whatever COPYING
> > (or
> > LICENCE or some recognizable top level file says).  A significant
> > number of Linux Kernel files don't have individual file header
> > copyrigh
> > ts, if you want an example of this.
>=20
> Yes. But as I understand, the entire Linux [1] code base is GPLv2
> only.

No it's not: We have a ton of dual licenced files (dual GPL/BSD is the
most common) and quite a few GPLv2+ ones.  Of course, all of those have
headers explaining the difference from COPYING (or at the very least
MODULE_LICENSE tags).

>  Whereas in case of multipath-tools, as Xose mentioned in the=20
> previous email, it is a mix of:
>=20
> * GPLv2 (only?)
> * GPLv2+
> * LGPLv2

This is also rather common.  Look at the COPYING file of the CRIU
project for instance

https://github.com/xemul/criu/blob/master/COPYING

It has a split GPL/LGPL model depending on which directory the file is
placed in.

> Having this information in the source repository (not necessarily as=20
> individual source headers) will speak out much clear.
>=20
> I think something like Debian's Machine-readable copyright format=20
> will be a good fit in this case.
>=20
> https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
>=20
> An example project, with mixed licenses:
> http://metadata.ftp-master.debian.org/changelogs/main/libs/libstorage
> mgmt/unstable_copyright
>=20
> BTW, this topic hit my mind 2 days ago when I looked at the aging=20
> (old format) multipath-tools/debian/copyright in my packaging repo
> and wanted to
> fix it.
>=20
> http://metadata.ftp-master.debian.org/changelogs/main/m/multipath-too
> ls/unstable_copyright
>=20
>=20
>=20
> I have attached a patch for a copyright file, based on what Xose had=20
> mentioned in the email. There still are files, like  libmultipath/pri
> oritizers/alua.c, which mention the license as plain GPL. So, this=20
> patch is still not complete.
>=20
>=20
> [1] with some minor exceptions I just noticed.

That's up to the maintainer of multipath-tools.  I was just point out
that doing this isn't required or even standard practice.

James

--=-2aPHYe9IrU//ve4roKPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXmlYVAAoJEAVr7HOZEZN4r+QQAL/MA4QGsYdm1skir91F/Ji3
MUPZx+X9uN8Wghzgjf/zFSntpGDCSGM1cRaEKTbz557psg8QcCYFPPxJwLLD3r7e
hdGNHf+bB3IttOyorqiV5Rc8RnBSbiSSckldaGVUAN07dI/mxjgam4/bbnJWLaXG
+ysQFX72y5i0v6j2uVNFcTnV9OAbr+777UVBLglyxz+U0usejO9QwSGpAlnU2nGF
TcPrBghqXxqcYkuQ1sd29dzCV7xsh+h5utrPRDvx4g67MUbQxYLGR2Wn06wLdM+1
JFRpY21/GNC5eWij7cLeLGuP1lVcrUW/Jo7/Uoupy60tjti+IX8K4HwJQxBWm6Xc
iXiqYZig62RwSOnSjUIJwOx4ZMd6XoXSoqRoukG6OJhyj1CpeqBS1ya3vL/pQ/1M
a71sT+dGps8W3GaB5tHa1Gd3bU78T63TWQJ+tWlKoX9gSVXSa3EGePdSBoognb5n
jJDWFdDQ5zgtakBcLDiXBX4TLx+yfDRpCuYqi8VPy993WKMmfikxC6e6j9Ng6cRL
0AKs0T0CBj3Rm2SebWt5qPmohjZASTJxoh/liXRZsAo4XcfFCdX2OPY5G/+kagSv
18bm/Xz1EAUfj5VrP3s8I49WpxdNyW2MBN8e7pmdSFZVT1qlTSiznhXcJAzl7ZfI
W9ZQHlc1OJKy2b7gcdOJ
=Olla
-----END PGP SIGNATURE-----

--=-2aPHYe9IrU//ve4roKPU--


--===============8121575489862573331==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8121575489862573331==--
