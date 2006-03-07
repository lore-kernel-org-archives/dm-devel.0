From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] hostraid dmraid plugin should check for hostraid
	controller
Date: Tue, 07 Mar 2006 15:00:30 -0800
Message-ID: <1141772430.24849.41.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0901202620=="
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
To: dm-devel <dm-devel@redhat.com>, ataraid-list <ataraid-list@redhat.com>
Cc: Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids


--===============0901202620==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-l6AkJES/qH2R3nbUhXWx"


--=-l6AkJES/qH2R3nbUhXWx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all (and Heinz in particular),

The attached patch against dmraid v1.0.0rc10 removes an unneeded
comment, supplements an existing one, and most importantly, and causes
is_asr to reject a disk if it can prove that the PCI controller attached
to the disk is not a categorized as a RAID controller (this
characteristic of the PCI class code is true for all the hostraid
adapters in my lab).

This part of the patch helps us to avoid the situation where you can
take a disk out of a HostRAID array, plug it in to a different system,
and have dmraid -ay go all haywire when it can't find the rest of the
disks.  It is my intent, however, that if is_asr will not reject a disk
if it can't make this positive identification; this patch therefore
should not affect Heinz's dm-based fakefakeraid testing rig. :)

Heinz, if you like this patch, could you put it in dmraid CVS?

Thanks,

--D

-------------

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
diff -Naurp v7.orig/lib/format/ataraid/asr.c v7-hr/lib/format/ataraid/asr.c
--- v7.orig/lib/format/ataraid/asr.c	2006-02-17 09:26:44.000000000 -0800
+++ v7-hr/lib/format/ataraid/asr.c	2006-03-07 14:58:53.000000000 -0800
@@ -8,6 +8,7 @@
=20
 #include <errno.h>
 #include <netinet/in.h>
+#include <limits.h>
=20
 #define	HANDLER	"asr"
=20
@@ -88,9 +89,6 @@ static char *name(struct lib_context *lc
=20
 	if ((ret =3D dbg_malloc((len =3D _name(lc, asr, NULL, 0) + 1)))) {
 		_name(lc, asr, ret, len);
-		/* Why do we call mk_alpha?  This makes labels like
-		 * "OS-u320-15k" become "OS-udca-bek", which is confusing.
-		 * mk_alpha(lc, ret + HANDLER_LEN, len - HANDLER_LEN); */
 	} else
 		log_alloc_err(lc, handler);
=20
@@ -109,6 +107,9 @@ static inline unsigned int stride(struct
  * combination?  The BIOS implies that it only does RAID 0, 1 and 10.
  * The emd driver implied support for RAID3/4/5, but dm doesn't
  * do any of those right now (RAID4 and RAID5 are in the works).
+ *
+ * The HostRAID User Guide only claims to do RAID 0 and 1, which is
+ * inaccurate, as the BIOS clearly supports RAID01 as well.
  */
 static struct types types[] =3D {
 	{ ASR_RAID0,   t_raid0 },
@@ -297,22 +298,59 @@ static int read_extended(struct lib_cont
 static int is_asr(struct lib_context *lc, struct dev_info *di, void *meta)
 {
 	struct asr *asr =3D meta;
+	char *slash;
+	char sysfspath[_POSIX_PATH_MAX], class_str[PCI_CLASS_ID_LENGTH];
+	FILE *fp;
+	long class_type;
=20
 	/*
 	 * Check our magic numbers and that the version =3D=3D v8.
 	 * We don't support anything other than that right now.
 	 */
-	if (asr->rb.b0idcode =3D=3D B0RESRVD &&
-	    asr->rb.smagic =3D=3D SVALID) {
-		if (asr->rb.resver =3D=3D RBLOCK_VER)
-			return 1;
-	=09
+	if (asr->rb.b0idcode !=3D B0RESRVD ||
+	    asr->rb.smagic !=3D SVALID) {
+		return 0;
+	}
+
+	/*
+	 * Figure out if the disk came from a HostRAID controller.
+	 * We can discover PCI information from sysfs.  We only jump out
+	 * if we see an ASR signature on a non-HostRAID controller; if
+	 * we get no data from sysfs, keep going.
+	 */
+	slash =3D strrchr(di->path, '/');
+	if (!slash)
+		goto skip_pci_check;
+
+	slash++;
+	snprintf(sysfspath, _POSIX_PATH_MAX,
+		 "/sys/block/%s/device/../../../class", slash);
+	fp =3D fopen(sysfspath, "r");
+	if (!fp)
+		goto skip_pci_check;
+
+	memset(class_str, 0, PCI_CLASS_ID_LENGTH);
+	if (fread(class_str, 1, PCI_CLASS_ID_LENGTH, fp)) {
+		class_type =3D strtol(class_str, NULL, 0);
+		class_type >>=3D 8;
+
+		if (class_type !=3D PCI_CLASS_STORAGE_RAID)
+			LOG_ERR(lc, 0,
+				"%s: Skipping disk with ASR signature"
+				" because the controller is not in "
+				"RAID mode.\n", handler);
+	}
+	fclose(fp);
+
+skip_pci_check:
+	/* Check version support. */
+	if (asr->rb.resver !=3D RBLOCK_VER) {
 		LOG_ERR(lc, 0,
 			"%s: ASR v%d detected, but we only support v8.\n",
 			handler, asr->rb.resver);
 	}
=20
-	return 0;
+	return 1;
 }
=20
 /*
diff -Naurp v7.orig/lib/format/ataraid/asr.h v7-hr/lib/format/ataraid/asr.h
--- v7.orig/lib/format/ataraid/asr.h	2006-01-19 02:08:10.000000000 -0800
+++ v7-hr/lib/format/ataraid/asr.h	2006-03-07 14:40:25.000000000 -0800
@@ -53,6 +53,10 @@
 /* Assume block size is 512.  So much for CD dmraid... */
 #define ASR_DISK_BLOCK_SIZE	512
=20
+/* PCI device detection constants */
+#define PCI_CLASS_ID_LENGTH	12
+#define PCI_CLASS_STORAGE_RAID	0x0104
+
 /* End of stuff that Darrick Wong added */
=20
 /* Begining of stuff copied verbatim from Adaptec's emd driver. */

--=-l6AkJES/qH2R3nbUhXWx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEDhCOa6vRYYgWQuURAn++AJ4s+a9nNnPpFT6QPPr7cMhJjQo9PgCcDqLR
EIRU4oawVogwhhKO9neLQiY=
=l6y8
-----END PGP SIGNATURE-----

--=-l6AkJES/qH2R3nbUhXWx--


--===============0901202620==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0901202620==--
