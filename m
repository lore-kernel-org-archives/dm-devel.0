From: NeilBrown <neil@brown.name>
Subject: [PATCH] dm: fix to_sector() for 32bit
Date: Sun, 06 Jan 2019 21:06:25 +1100
Message-ID: <87tvimje1q.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8805542695904257593=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Guillaume =?utf-8?Q?Perr=C3=A9al?= <gperreal@free.fr>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============8805542695904257593==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


A dm-raid array with devices larger than 4GB won't assemble on
a 32 bit host since _check_data_dev_sectors() was added in 4.16.
This is because to_sector() treats its argument as an "unsigned long"
which is 32bits (4GB) on a 32bit host.  Using "unsigned long long"
is more correct.

Kernels as early as 4.2 can have other problems due to to_sector()
being used on the size of a device.

Fixes: 0cf4503174c1 ("dm raid: add support for the MD RAID0 personality")
cc: stable@vger.kernel.org (v4.2+)
Reported-and-tested-by: Guillaume Perr=C3=A9al <gperreal@free.fr>
Signed-off-by: NeilBrown <neil@brown.name>
=2D--
 include/linux/device-mapper.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e528baebad69..bee4bb9f81bc 100644
=2D-- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -609,7 +609,7 @@ do {									\
  */
 #define dm_target_offset(ti, sector) ((sector) - (ti)->begin)
=20
=2Dstatic inline sector_t to_sector(unsigned long n)
+static inline sector_t to_sector(unsigned long long n)
 {
 	return (n >> SECTOR_SHIFT);
 }
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlwx0yEACgkQOeye3VZi
gblbsw/8DeUnpaOk8Ap1UQ2kgp0t4BtXRUtilRRmgM9gwaFaczfQeazYWePHEeig
lJdBFalDzdFdEUWN8MPJUZ0jU4IZ7rH7AIx2YnNSXhUxUIyQ3Gp36jTO/uSCDTSj
PKxj+aFMMWN8eNZLKutjAFjFPK5I808sT2ww3xS/uQOHWvO+TUKcgjCzbjlTwKEw
ZJU9RZtMn/TwS8M5szz7SQ7tJhZftCvlxnQ4gYcN2FGXhUP6Ppg+I4wZjj6nlgRW
cNNJl7pJALdVziOy11NeKaFGkJEfOmHGoVgdYV5vthDE0jRV0XlMkZ9iqc6aXdIE
ATDDXAHtW4ssvxhUlbY9Ar+wt5x1Bk/B9/6u9uKoMrVYQw5TX18gOtm3JHvqjK7k
6JJi4MAiG3zB/01ym76q1pUqnM2IF0ELABycTK04jIYz1q8OjwPLhRJOo4MAeGkM
rwiX7xrqdMl+NKbKZB1E3Vk+0NNMtlvMz5RBOKFBHbZkf3OyGLZyAuJ6ZaTGJdRm
/iJp4XnU9EeXXWag0fWFm6FP81JMwMBQLWBr8oo2wh3iRDiZa5V6yGIHuKBD1Pwe
HMr5Ss5uBOMjeb3q1aBymRF4LdPfaDvaBuK4OfySGnVoZzVRgGqzrv0/kMfQPTPT
sbc4WUotlrjYkiik9gZwT4xUvPoXyoSxMnxY/+p0DrLglzLSeBs=
=4Jvr
-----END PGP SIGNATURE-----
--=-=-=--


--===============8805542695904257593==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8805542695904257593==--
