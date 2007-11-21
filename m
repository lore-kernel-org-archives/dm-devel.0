From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: build #338 failed for 2.6.24-rc2-g6e800af in linux/drivers/md/dm-mpath-hp-sw.c
Date: Wed, 21 Nov 2007 10:25:59 +0100
Message-ID: <200711211026.04363.toralf.foerster@gmx.de>
References: <200711121333.24398.toralf.foerster@gmx.de> <20071112152100.GA22847@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4418656.7OE01SeIUG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758125AbXKUJ0Y@vger.kernel.org>
In-Reply-To: <20071112152100.GA22847@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--nextPart4418656.7OE01SeIUG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 12. November 2007 schrieb Alasdair G Kergon:
> On Mon, Nov 12, 2007 at 01:33:21PM +0100, Toralf F=F6rster wrote:
> > the build with the attached .config failed, make ends with:
> > drivers/built-in.o: In function `hp_sw_end_io':
> > dm-mpath-hp-sw.c:(.text+0xb0596): undefined reference to `__scsi_print_=
sense'
> > make: *** [.tmp_vmlinux1] Error 1
> =20
> Does this patch fix it?
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/d=
m-mpath-hp-requires-scsi.patch
>=20
> Alasdair
>=20

oh yes :-)

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart4418656.7OE01SeIUG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHQ/mohyrlCH22naMRAvNBAKCJHmHYqMD6pqiEeGL4G46Aduyw1QCfReCI
SrU8bRWrFZCWL34fxTAkIbY=
=fNyf
-----END PGP SIGNATURE-----

--nextPart4418656.7OE01SeIUG--
