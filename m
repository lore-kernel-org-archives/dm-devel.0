From: Alasdair G Kergon <agk@redhat.com>
Subject: LVM release 2.02.96 / git / veritysetup
Date: Sat, 9 Jun 2012 01:23:08 +0100
Message-ID: <20120609002308.GD15806@agk-dp.fab.redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7959508722046200498=="
Return-path: <lvm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: linux-lvm@redhat.com, lvm-devel@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids


--===============7959508722046200498==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

New LVM release
---------------
LVM version 2.02.96 is now available from
  ftp://sources.redhat.com/pub/lvm2/

and this is mirrored on the sites listed here:
  http://sourceware.org/mirrors.html

Lots of little enhancements and fixes this time.
For a summary:
  ftp://sources.redhat.com/pub/lvm2/WHATS_NEW_DM
  ftp://sources.redhat.com/pub/lvm2/WHATS_NEW


git
---
This release was done from a new git repository at:
  git://git.fedorahosted.org/git/lvm2.git
  http://git.fedorahosted.org/git/lvm2.git
 =20
The project web page should be up to date again with locations.
  http://sourceware.org/lvm2/

The CVS repository will no longer be updated.

veritysetup
-----------
Although this release contains a userspace tool for dm-verity,
  configure --with-verity-setup=3D<cryptlib>
we think the cryptsetup package would provide a better home for this
so watch out for an updated version in an upcoming cryptsetup release.

Alasdair


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJP0pdsAAoJEK2W1qbAHj1nMZcP/R3pB3a4/Yr+PGYeaNKfJcSJ
b3kRDsrRj8UX+0TW8WZpP0yMQDvmdh6yZnEY25rW48V2EdXn8IFQi6sLDOCYpkrZ
er/jdRc7UpV51gsCYiTMuzXG6H3riW0o6eddH5oZTa0giDq9MullA7Oa5g4UOdfI
zrg/YTZPHbeD3T+tGJmmyIPVTDYROCo6f84JOBjsEo5Ei8SDqV/8UXAq6X2KGTAc
uEuB6/ONUA5yVxa44hn+lEgHPOHEPS+6DmZlmtWE8hO2RDtmqwtYbzq5ymytZKpC
FzG0ox+O9Ew0iNeFdBq7Z6Js4y6evdUY79yEbygQtqEMWB99Bno3Ss3wEXKSE2Mp
jnpHDmTp25xUk4/KDD9cqC0roEIvkz4EhJilR2UAtlvn4akhtZrTavilI1XLqN0B
66SIzvpiEpL6pqdakIcz4/1PIge4CYZM6NGNnTEkl0uwFhxKKyO7eLkQrTrM2LLy
AuH3lf71zrFxxZK13cvFz7HXncDxX686/LzIrkVryFXB8rcMgnLztKYzMDrth6vj
6YWltxq9mqO3rWzTiWFnCEToPS+Q6tJTL8z5ppWZu1J00YuHmKaqNDXSDBA7w+pa
VQC5SQ2dOR351tcz8Xdv0nGur1kidkTbgvBjj/Y0EXynfA9zLK1pHPEIEj9QPfbJ
Nm9av06j1ZxZdeeMWmY1
=iZLx
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--


--===============7959508722046200498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
--===============7959508722046200498==--
