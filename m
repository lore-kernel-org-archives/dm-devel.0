From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH] multipath-tools/kpartx - mac partition support
Date: Thu, 9 Feb 2006 22:33:15 +0100
Message-ID: <20060209213315.GA18454@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1741692317=="
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


--===============1741692317==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y7xTucakfITjPcLV"
Content-Disposition: inline


--Y7xTucakfITjPcLV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch adds mac partition table support to kpartx.

You can also pull this changes from                                        =
                                                    =20
http://137.250.31.225/rsync/git/linux/storage/multipath-tools.git.

Bastian


[kpartx] Add support for mac partition table

Signed-off-by: Bastian Blank <waldi@debian.org>

---
commit c2fbbb7907b589374f186ad57a9b3beba8578632
tree e6d05387a2c8c98f478d229678d454ce8e756161
parent 2f6c4c8ae93d599bf1c2630c97cc675e92fbea90
author Bastian Blank <waldi@debian.org> Thu, 09 Feb 2006 17:22:18 +0000
committer Bastian Blank <waldi@debian.org> Thu, 09 Feb 2006 17:22:18 +0000

 kpartx/Makefile    |    4 ++--
 kpartx/byteorder.h |    6 ++++++
 kpartx/kpartx.c    |    1 +
 kpartx/kpartx.h    |    1 +
 kpartx/mac.c       |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 kpartx/mac.h       |   30 ++++++++++++++++++++++++++++++
 6 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 1b68ca6..bf6e6c1 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -10,12 +10,12 @@ CFLAGS +=3D -I. -D_LARGEFILE64_SOURCE
=20
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS =3D bsd.o dos.o kpartx.o solaris.o unixware.o gpt.o crc32.o \
-	       lopart.o xstrncpy.o devmapper.o dasd.o \
+	       lopart.o xstrncpy.o devmapper.o dasd.o mac.o \
 	       $(MULTIPATHLIB)-$(BUILD).a $(libdm)
 else
 	LDFLAGS =3D -ldevmapper
 	OBJS =3D bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o \
-	       gpt.o crc32.o lopart.o xstrncpy.o devmapper.o
+	       gpt.o mac.o crc32.o lopart.o xstrncpy.o devmapper.o
 endif
=20
 EXEC =3D kpartx
diff --git a/kpartx/byteorder.h b/kpartx/byteorder.h
index 6d2588b..21962d6 100644
--- a/kpartx/byteorder.h
+++ b/kpartx/byteorder.h
@@ -9,9 +9,15 @@
 #endif
=20
 #if BYTE_ORDER =3D=3D LITTLE_ENDIAN
+#  define le16_to_cpu(x) (x)
+#  define be16_to_cpu(x) bswap_16(x)
 #  define le32_to_cpu(x) (x)
+#  define be32_to_cpu(x) bswap_32(x)
 #elif BYTE_ORDER =3D=3D BIG_ENDIAN
+#  define le16_to_cpu(x) bswap_16(x)
+#  define be16_to_cpu(x) (x)
 #  define le32_to_cpu(x) bswap_32(x)
+#  define be32_to_cpu(x) (x)
 #else
 #  error unsupported
 #endif
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index c1c2fae..2198302 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -78,6 +78,7 @@ initpts(void)
 	addpts("solaris", read_solaris_pt);
 	addpts("unixware", read_unixware_pt);
 	addpts("dasd", read_dasd_pt);
+	addpts("mac", read_mac_pt);
 }
=20
 static char short_opts[] =3D "ladgvnp:t:";
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index 9819268..6a715de 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -32,6 +32,7 @@ extern ptreader read_solaris_pt;
 extern ptreader read_unixware_pt;
 extern ptreader read_gpt_pt;
 extern ptreader read_dasd_pt;
+extern ptreader read_mac_pt;
=20
 char *getblock(int fd, unsigned int secnr);
=20
diff --git a/kpartx/mac.c b/kpartx/mac.c
new file mode 100644
index 0000000..5432e67
--- /dev/null
+++ b/kpartx/mac.c
@@ -0,0 +1,47 @@
+#include "kpartx.h"
+#include "byteorder.h"
+#include <stdio.h>
+#include <string.h>
+#include "mac.h"
+
+int
+read_mac_pt(int fd, struct slice all, struct slice *sp, int ns) {
+	struct mac_driver_desc *md;
+        struct mac_partition *part;
+	unsigned secsize;
+	char *data;
+	int blk, blocks_in_map;
+        int n =3D 0;
+
+	md =3D (struct mac_driver_desc *) getblock(fd, 0);
+	if (md =3D=3D NULL)
+		return -1;
+
+	if (be16_to_cpu(md->signature) !=3D MAC_DRIVER_MAGIC)
+		return -1;
+
+	secsize =3D be16_to_cpu(md->block_size);
+	data =3D getblock(fd, secsize/512);
+	if (!data)
+		return -1;
+	part =3D (struct mac_partition *) (data + secsize%512);
+
+	if (be16_to_cpu(part->signature) !=3D MAC_PARTITION_MAGIC)
+		return -1;
+
+	blocks_in_map =3D be32_to_cpu(part->map_count);
+	for (blk =3D 1; blk <=3D blocks_in_map && blk <=3D ns; ++blk, ++n) {
+		int pos =3D blk * secsize;
+		data =3D getblock(fd, pos/512);
+		if (!data)
+			return -1;
+
+		part =3D (struct mac_partition *) (data + pos%512);
+		if (be16_to_cpu(part->signature) !=3D MAC_PARTITION_MAGIC)
+			break;
+
+		sp[n].start =3D be32_to_cpu(part->start_block) * (secsize/512);
+		sp[n].size =3D be32_to_cpu(part->block_count) * (secsize/512);
+	}
+	return n;
+}
diff --git a/kpartx/mac.h b/kpartx/mac.h
new file mode 100644
index 0000000..3c712ba
--- /dev/null
+++ b/kpartx/mac.h
@@ -0,0 +1,30 @@
+#ifndef MAC_H
+#define MAC_H
+
+#include <stdint.h>
+
+#define MAC_PARTITION_MAGIC     0x504d
+
+/* type field value for A/UX or other Unix partitions */
+#define APPLE_AUX_TYPE  "Apple_UNIX_SVR2"
+
+struct mac_partition {
+        uint16_t  signature;      /* expected to be MAC_PARTITION_MAGIC */
+        uint16_t  res1;
+        uint32_t  map_count;      /* # blocks in partition map */
+        uint32_t  start_block;    /* absolute starting block # of partitio=
n */
+        uint32_t  block_count;    /* number of blocks in partition */
+        /* there is more stuff after this that we don't need */
+};
+
+#define MAC_DRIVER_MAGIC        0x4552
+
+/* Driver descriptor structure, in block 0 */
+struct mac_driver_desc {
+        uint16_t  signature;      /* expected to be MAC_DRIVER_MAGIC */
+        uint16_t  block_size;
+        uint32_t  block_count;
+    /* ... more stuff */
+};
+
+#endif
--=20
Captain's Log, star date 21:34.5...

--Y7xTucakfITjPcLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkPrtRsACgkQnw66O/MvCNEbpACfYqxFcUxMBazQLSUsM8a6VIBh
zRIAmgOd5ZegtNNC8/3LWF7abMlo3z+2
=3gpq
-----END PGP SIGNATURE-----

--Y7xTucakfITjPcLV--


--===============1741692317==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1741692317==--
