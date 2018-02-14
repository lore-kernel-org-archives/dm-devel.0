From: NeilBrown <neilb@suse.com>
Subject: Re: DM Regression in 4.16-rc1 - read() returns data when it shouldn't
Date: Thu, 15 Feb 2018 07:39:50 +1100
Message-ID: <871shnqp9l.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14 2018, Milan Broz wrote:

> Hi,
>
> the commit (found by bisect)
>
>   commit 18a25da84354c6bb655320de6072c00eda6eb602
>   Author: NeilBrown <neilb@suse.com>
>   Date:   Wed Sep 6 09:43:28 2017 +1000
>
>     dm: ensure bio submission follows a depth-first tree walk
>
> cause serious regression while reading from DM device.
>
> The reproducer is below, basically it tries to simulate failure we see in=
 cryptsetup
> regression test: we have DM device with error and zero target and try to =
read
> "passphrase" from it (it is test for 64 bit offset error path):
>
> Test device:
> # dmsetup table test
> 0 10000000 error=20
> 10000000 1000000 zero=20
>
> We try to run this operation:
>   lseek64(fd, 5119999988, SEEK_CUR); // this should seek to error target =
sector
>   read(fd, buf, 13); // this should fail, if we seek to error part of the=
 device
>
> While on 4.15 the read properly fails:
>   Seek returned 5119999988.
>   Read returned -1.
>
> for 4.16 it actually succeeds returning some random data
> (perhaps kernel memory, so this bug is even more dangerous):
>   Seek returned 5119999988.
>   Read returned 13.
>
> Full reproducer below:
>
> #define _GNU_SOURCE
> #define _LARGEFILE64_SOURCE
> #include <stdio.h>
> #include <stddef.h>
> #include <stdint.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <inttypes.h>
>
> int main (int argc, char *argv[])
> {
>         char buf[13];
>         int fd;
>         //uint64_t offset64 =3D 5119999999;
>         uint64_t offset64 =3D   5119999988;
>         off64_t r;
>         ssize_t bytes;
>
>         system("echo -e \'0 10000000 error\'\\\\n\'10000000 1000000 zero\=
' | dmsetup create test");
>
>         fd =3D open("/dev/mapper/test", O_RDONLY);
>         if (fd =3D=3D -1) {
>                 printf("open fail\n");
>                 return 1;
>         }
>
>         r =3D lseek64(fd, offset64, SEEK_CUR);
>         printf("Seek returned %" PRIu64 ".\n", r);
>         if (r < 0) {
>                 printf("seek fail\n");
>                 close(fd);
>                 return 2;
>         }
>
>         bytes =3D read(fd, buf, 13);
>         printf("Read returned %d.\n", (int)bytes);
>
>         close(fd);
>         return 0;
> }
>
>
> Please let me know if you need more info to reproduce it.

Thanks for the detailed report.  I haven't tried to reproduce, but the
code looks very weird.
The patch I posted "Date: Wed, 06 Sep 2017 09:43:28 +1000" had:
      +				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
      +								 md->queue->bio_split);
      +				bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
      +				bio_chain(b, bio);
      +				generic_make_request(b);
      +				break;

The code in Linux has:

				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
								 md->queue->bio_split);
				ci.io->orig_bio =3D b;
				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
				bio_chain(b, bio);
				ret =3D generic_make_request(bio);
				break;

So the wrong bio is sent to generic_make_request().
Mike: do you remember how that change happened?  I think there were
discussions following the patch, but I cannot find anything about making
that change.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqEnpYACgkQOeye3VZi
gbkk4Q/+PQFcz83OjQXScwwnDYyQxKIVkfZzIc0MsnSuGgBiMcT0Gv0x+3h0qQxR
JchmINLbYYCuAr3dLV/1mbac0hMyKtTpNJ3JUG8lQwXHaLw/4lPt19mPGnu49Ap6
6NkYdqPaxJl0pXJGMbZEWoDm2QwqZBJHUw/3iVswHkypBXl47mY7RQxDtYilCpRc
AovLSmYvrkNPteyt7qrdXUVNQkRhD6Muj2SL5xJxv1XJpnS5o4LIZ0CsxOn4EMvh
wv5u7fMxlEue/aLzgB89x7fSMTiZiei8ye1u14ql82PeQ3qxDNbpc/vnTGhLVjuv
Uqb8irg5eVUadL/mxvE+PgB2xbk/KWmZG/szlPYgPGcX5solfcASpmyaag2Jyrsj
jmlq1NizBDr0tMjDkufILs/VPsoCUbb1mXRPR540vB6EvkFcm8994wIYa+8w3lFD
J/ZOKeMG9srfFG2hrwnUen0iND6eWa2pibsym9cAkW4qwwGkzOsybHCF1lHCS9n6
ZtczeL7WzkfFZjpUIqLjpTCkz3iC5eIpiFiC0bHdddFmw57Qi+AkW8kVUuRBIaEC
t3EBU1nxUGPTEATH+mhpnfgd78TNdnMGRAfqWdngQzYiAVh0CIMdCG3SmqMwaiLW
wNbf11FFSCUAMZ7v73dih0kWPgYALi9ZbBg7CTR2jbgbIzh/PRc=
=4fbz
-----END PGP SIGNATURE-----
--=-=-=--
