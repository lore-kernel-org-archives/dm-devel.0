From: AJ Lewis <aj@terrascale.com>
Subject: Re: Next set of device-mapper  patches
Date: Wed, 21 Jun 2006 08:07:15 -0500
Message-ID: <20060621130620.GA11880@fenrir.local>
References: <3EC60E80D9AA7C4E910ACC9DA2003AC30606C55C@BGEEXC02.asiapacific.cpqcorp.net>
	<4499310F.3000007@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1295822311=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4499310F.3000007@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============1295822311==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 21, 2006 at 01:44:15PM +0200, Milan Broz wrote:
> ioctl patch simple route ioctls to underlying block device
> -> it supports all ioctl which are supported by your physical device.
>=20
> e.g.
> in simple case you have volume /dev/mapper/VolGroup00-LogVol0
> mapped to physical device /dev/sda, inquiry ioctl (using tools from=20
> sg3_util)
> sg_inq /dev/sda  =20
> 	is the same as
> sg_inq /dev/mapper/VolGroup00-LogVol0
>=20
> In the case of multipath target ioctl command is sent through
> active path.

So what happens when you have multiple block devices in the volume?  And wh=
at
if those block devices have different levels of support for the ioctls?
=20
--
AJ Lewis=20

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (Darwin)

iD8DBQFEmUSDn95okVnkz6cRAl8MAJ4xh6IxwwqLE/WifjLfRlZd/RZJJQCgiKnM
9amA4BIE9WgE3jsH0fI6jV4=
=MT9p
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--


--===============1295822311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1295822311==--
