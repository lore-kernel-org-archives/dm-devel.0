From: Christophe Saout <christophe@saout.de>
Subject: Re: possible dm-crypt leak over loop
Date: Thu, 10 Mar 2005 14:24:18 +0100
Message-ID: <1110461058.14581.3.camel@leto.cs.pocnet.net>
References: <1110147738.2266.26.camel@boxen>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0043736048=="
In-Reply-To: <1110147738.2266.26.camel@boxen>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alexander Nyberg <alexn@dsv.su.se>
Cc: dm-crypt@saout.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============0043736048==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-nX0/Gj0tv57QQ+nliMut"


--=-nX0/Gj0tv57QQ+nliMut
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Sonntag, den 06.03.2005, 23:22 +0100 schrieb Alexander Nyberg:

> I think this is more related to dm-crypt and not to loop. However - this
> only seems to happen when dm-crypt is on top of loop, something I cannot
> explain, how do they differ?. Sysrq-t trace at the bottom. My belief
> after looking at this is that dm-crypt leaks memory somewhere but I
> couldn't get around the dm code so here it is. This is 2.6.11, but this
> bug has been present forever (easier to trigger now though).
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Testcase:
> #!/bin/sh
> losetup /dev/loop7 loopbackfile
> echo 0 `blockdev --getsize /dev/loop7` crypt aes-plain 0123456789abcdef01=
23456789abcdef 0 /dev/loop7 0 | dmsetup create volume1
> mkfs.ext3 /dev/mapper/volume1
> mount /dev/mapper/volume1 mnt
> cd mnt
> dbench 20

How do you see there's a memory leak? Does your machine lock up? I just
ran your testcase several times and I don't see anything unusual. Total
system memory consumption doesn't change before and afterwards.

Can anybody else confirm this?


--=-nX0/Gj0tv57QQ+nliMut
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBCMEqBZCYBcts5dM0RAiPzAKCIcDVNEjwotV6T53sVejYiJcdpiACfV/Fw
ed3FCWiV1PTMj/9WV/MTrCs=
=gM6S
-----END PGP SIGNATURE-----

--=-nX0/Gj0tv57QQ+nliMut--


--===============0043736048==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0043736048==--
