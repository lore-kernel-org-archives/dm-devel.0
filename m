From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH] multipath-tools/kpartx - fix endianes,
	undefined behaviour, cleanup
Date: Thu, 29 Sep 2005 14:41:15 +0200
Message-ID: <20050929124115.GA8988@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0688060513=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0688060513==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christophe

The following patches makes kpartx with dos partitions behave correctly
on powerpc and makes it a little bit easier to read.

You can also pull this changes from
http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git.

Bastian


Use endian.h and byteswap.h.

---
commit 2be146862254c9941cb0754fadd45cb34dd05694
tree 1f6997be9d4b30258d6abfa25aefb2106b61ff96
parent f67cb7d39e9f0a0046d97af3bf78e8c4be2e68bf
author Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 12:55:36 +0000
committer Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 12:55:36 +0000

 kpartx/byteorder.h |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kpartx/byteorder.h b/kpartx/byteorder.h
--- a/kpartx/byteorder.h
+++ b/kpartx/byteorder.h
@@ -1,15 +1,19 @@
 #ifndef BYTEORDER_H_INCLUDED
 #define BYTEORDER_H_INCLUDED
=20
-#if defined (__s390__) || defined (__s390x__)
-#define le32_to_cpu(x)	( \
-		(*(((unsigned char *) &(x)))) + \
-		(*(((unsigned char *) &(x))+1) << 8) + \
-		(*(((unsigned char *) &(x))+2) << 16) + \
-		(*(((unsigned char *) &(x))+3) << 24) \
-	)
+#ifdef __linux__
+#  include <endian.h>
+#  include <byteswap.h>
 #else
-#define le32_to_cpu(x)	(x)
+#  error unsupported
+#endif
+
+#if BYTE_ORDER =3D=3D LITTLE_ENDIAN
+#  define le32_to_cpu(x) (x)
+#elif BYTE_ORDER =3D=3D BIG_ENDIAN
+#  define le32_to_cpu(x) bswap_32(x)
+#else
+#  error unsupported
 #endif
=20
 #endif				/* BYTEORDER_H_INCLUDED */


=0C
!-------------------------------------------------------------flip-


Don't use unalligned pointers, always copy the structures to a properly
alligned piece of memory. This triggered undefined behaviour.

---
commit 6399c88650be9835b90bad91a7b6268db8db3303
tree aa0fb4438812f0a116d4e7a7db092bfd45edfcf3
parent 2be146862254c9941cb0754fadd45cb34dd05694
author Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 13:01:45 +0000
committer Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 13:01:45 +0000

 kpartx/dos.c |   43 ++++++++++++++++++++-----------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -1,6 +1,7 @@
 #include "kpartx.h"
 #include "byteorder.h"
 #include <stdio.h>
+#include <string.h>
 #include "dos.h"
=20
 static int
@@ -12,7 +13,7 @@ static int
 read_extended_partition(int fd, struct partition *ep,
 			struct slice *sp, int ns)
 {
-	struct partition *p;
+	struct partition p;
 	unsigned long start, here;
 	unsigned char *bp;
 	int loopct =3D 0;
@@ -33,14 +34,13 @@ read_extended_partition(int fd, struct p
 		if (bp[510] !=3D 0x55 || bp[511] !=3D 0xaa)
 			return n;
=20
-		p =3D (struct partition *) (bp + 0x1be);
-
-		for (i=3D0; i<2; i++, p++) {
-			if (p->nr_sects =3D=3D 0 || is_extended(p->sys_type))
+		for (i=3D0; i<2; i++) {
+			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
+			if (p.nr_sects =3D=3D 0 || is_extended(p.sys_type))
 				continue;
 			if (n < ns) {
-				sp[n].start =3D here + le32_to_cpu(p->start_sect);
-				sp[n].size =3D le32_to_cpu(p->nr_sects);
+				sp[n].start =3D here + le32_to_cpu(p.start_sect);
+				sp[n].size =3D le32_to_cpu(p.nr_sects);
 				n++;
 			} else {
 				fprintf(stderr,
@@ -50,10 +50,10 @@ read_extended_partition(int fd, struct p
 			loopct =3D 0;
 		}
=20
-		p -=3D 2;
-		for (i=3D0; i<2; i++, p++) {
-			if(p->nr_sects !=3D 0 && is_extended(p->sys_type)) {
-				here =3D start + le32_to_cpu(p->start_sect);
+		for (i=3D0; i<2; i++) {
+			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
+			if(p.nr_sects !=3D 0 && is_extended(p.sys_type)) {
+				here =3D start + le32_to_cpu(p.start_sect);
 				moretodo =3D 1;
 				break;
 			}
@@ -69,7 +69,7 @@ is_gpt(int type) {
=20
 int
 read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
-	struct partition *p;
+	struct partition p;
 	unsigned long offset =3D all.start;
 	int i, n=3D0;
 	unsigned char *bp;
@@ -81,32 +81,29 @@ read_dos_pt(int fd, struct slice all, st
 	if (bp[510] !=3D 0x55 || bp[511] !=3D 0xaa)
 		return -1;
=20
-	p =3D (struct partition *) (bp + 0x1be);
 	for (i=3D0; i<4; i++) {
-		if (is_gpt(p->sys_type)) {
+		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
+		if (is_gpt(p.sys_type)) {
 			return 0;
 		}
-		p++;
 	}
-	p =3D (struct partition *) (bp + 0x1be);
 	for (i=3D0; i<4; i++) {
+		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
 		/* always add, even if zero length */
 		if (n < ns) {
-			sp[n].start =3D  le32_to_cpu(p->start_sect);
-			sp[n].size =3D le32_to_cpu(p->nr_sects);
+			sp[n].start =3D  le32_to_cpu(p.start_sect);
+			sp[n].size =3D le32_to_cpu(p.nr_sects);
 			n++;
 		} else {
 			fprintf(stderr,
 				"dos_partition: too many slices\n");
 			break;
 		}
-		p++;
 	}
-	p =3D (struct partition *) (bp + 0x1be);
 	for (i=3D0; i<4; i++) {
-		if (is_extended(p->sys_type))
-			n +=3D read_extended_partition(fd, p, sp+n, ns-n);
-		p++;
+		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
+		if (is_extended(p.sys_type))
+			n +=3D read_extended_partition(fd, &p, sp+n, ns-n);
 	}
 	return n;
 }


=0C
!-------------------------------------------------------------flip-


Only use one loop to read all data.

---
commit 1d586d3a1a998b64fa27e61777478d8735d4152a
tree 4553a5ad1ef3367600b00abded4e521ce7629088
parent 6399c88650be9835b90bad91a7b6268db8db3303
author Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 13:06:34 +0000
committer Bastian Blank <waldi@debian.org> Thu, 29 Sep 2005 13:06:34 +0000

 kpartx/dos.c |   37 ++++++++++++++-----------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -36,8 +36,14 @@ read_extended_partition(int fd, struct p
=20
 		for (i=3D0; i<2; i++) {
 			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
-			if (p.nr_sects =3D=3D 0 || is_extended(p.sys_type))
-				continue;
+			if (is_extended(p.sys_type)) {
+				if (p.nr_sects) {
+					here =3D start + le32_to_cpu(p.start_sect);
+					moretodo =3D 1;
+				}
+				else
+					continue;
+			}
 			if (n < ns) {
 				sp[n].start =3D here + le32_to_cpu(p.start_sect);
 				sp[n].size =3D le32_to_cpu(p.nr_sects);
@@ -49,15 +55,6 @@ read_extended_partition(int fd, struct p
 			}
 			loopct =3D 0;
 		}
-
-		for (i=3D0; i<2; i++) {
-			memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
-			if(p.nr_sects !=3D 0 && is_extended(p.sys_type)) {
-				here =3D start + le32_to_cpu(p.start_sect);
-				moretodo =3D 1;
-				break;
-			}
-		}
 	}
 	return n;
 }
@@ -71,7 +68,7 @@ int
 read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	struct partition p;
 	unsigned long offset =3D all.start;
-	int i, n=3D0;
+	int i, n=3D4;
 	unsigned char *bp;
=20
 	bp =3D (unsigned char *)getblock(fd, offset);
@@ -83,25 +80,19 @@ read_dos_pt(int fd, struct slice all, st
=20
 	for (i=3D0; i<4; i++) {
 		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
-		if (is_gpt(p.sys_type)) {
-			return 0;
-		}
 	}
 	for (i=3D0; i<4; i++) {
 		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
-		/* always add, even if zero length */
-		if (n < ns) {
-			sp[n].start =3D  le32_to_cpu(p.start_sect);
-			sp[n].size =3D le32_to_cpu(p.nr_sects);
-			n++;
+		if (is_gpt(p.sys_type))
+			return 0;
+		if (i < ns) {
+			sp[i].start =3D  le32_to_cpu(p.start_sect);
+			sp[i].size =3D le32_to_cpu(p.nr_sects);
 		} else {
 			fprintf(stderr,
 				"dos_partition: too many slices\n");
 			break;
 		}
-	}
-	for (i=3D0; i<4; i++) {
-		memcpy(&p, bp + 0x1be + i * sizeof (p), sizeof (p));
 		if (is_extended(p.sys_type))
 			n +=3D read_extended_partition(fd, &p, sp+n, ns-n);
 	}


=0C
!-------------------------------------------------------------flip-


--=20
Women professionals do tend to over-compensate.
		-- Dr. Elizabeth Dehaver, "Where No Man Has Gone Before",
		   stardate 1312.9.

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkM74OsACgkQnw66O/MvCNFZywCgg00sxpxGFtaqCvznGMyY9Czf
LO8An1ke+lqEzMEdDfDfmZzdLFDjOWSG
=KeGT
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--


--===============0688060513==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0688060513==--
