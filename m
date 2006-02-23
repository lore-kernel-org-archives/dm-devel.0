From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH] User-configurable HDIO_GETGEO for dm
	volumes
Date: Thu, 23 Feb 2006 10:16:24 -0800
Message-ID: <1140718584.10148.2.camel@localhost.localdomain>
References: <43F38D83.3040702@us.ibm.com>
	 <20060217151650.GC12173@agk.surrey.redhat.com>
	 <43F6718E.2000908@us.ibm.com>
	 <20060222223240.GI31641@agk.surrey.redhat.com>
	 <1140655617.3300.14.camel@localhost.localdomain>
	 <20060223135639.GK31641@agk.surrey.redhat.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-71EWMkp8uf99Y+4Curub"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750908AbWBWSQ2@vger.kernel.org>
In-Reply-To: <20060223135639.GK31641@agk.surrey.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: dm-devel.ids


--=-71EWMkp8uf99Y+4Curub
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-02-23 at 13:56 +0000, Alasdair G Kergon wrote:

> My copy of the sd(4) man page says of that ioctl:
>=20
>     The information returned in the parameter is the disk
>     geometry of the drive as understood by DOS!   This geometry is not
>     the physical geometry of the drive.  It is used when constructing the
>     drive's partition table, however, and is needed for convenient
>     operation of fdisk(1), efdisk(1), and lilo(1).  If the geometry
>     information is not available, zero will be returned for all of the
>     parameters.
> =20
> Is there a preferred alternative specification?

Hm... in light of that, I'll acquiesce that 0/0/0 is fine by me, and no
other behavior is necessary.

--D

--=-71EWMkp8uf99Y+4Curub
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBD/fv4a6vRYYgWQuURAq7vAKC1m8pWPSlMfpr51lb2vCsC7x+eJwCgnWt2
FiGqWBC6ZOjAwVyj5Cf9yMY=
=ujkO
-----END PGP SIGNATURE-----

--=-71EWMkp8uf99Y+4Curub--
