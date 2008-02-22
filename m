From: heinzm@sourceware.org
Subject: dmraid ./CHANGELOG ./KNOWN_BUGS ./README ./TOD ...
Date: 22 Feb 2008 17:06:56 -0000
Message-ID: <20080222170656.30272.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2008-02-22 17:06:54

Modified files:
	.              : CHANGELOG KNOWN_BUGS README TODO 
	lib            : version.h 
	lib/format     : format.c 
	lib/format/ddf : ddf1.c ddf1_crc.c ddf1_lib.c 
	tools          : Makefile.in VERSION 

Log message:
	1.0.0.rc14 checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CHANGELOG.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/KNOWN_BUGS.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/README.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/TODO.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/format.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_crc.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ddf/ddf1_lib.c.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/CHANGELOG	2008/02/22 17:06:00	1.3
+++ dmraid/CHANGELOG	2008/02/22 17:06:54	1.4
@@ -1,6 +1,23 @@
 
-Changelog from dmraid 1.0.0.rc12 to 1.0.0.rc13		2006.10.11
+Changelog from dmraid 1.0.0.rc13 to 1.0.0.rc14		2006.11.08
 
+FIXES:
+------
+o asr.c: fixed Adaptec HostRAID DDF1 discovery
+o ddf1_crc.c: added crc() routine to avoid linking to zlib alltogether,
+	      because Ubuntu had problems with this
+
+
+FEATURES:
+---------
+
+
+MISCELANIOUS:
+-------------
+
+
+
+Changelog from dmraid 1.0.0.rc12 to 1.0.0.rc13		2006.10.11
 
 FIXES:
 ------
@@ -11,7 +28,6 @@
 
 Changelog from dmraid 1.0.0.rc11 to 1.0.0.rc12		2006.09.22
 
-
 FIXES:
 ------
 o sil.c: quorate() OBO fix
@@ -24,7 +40,6 @@
 o added reload functionality to devmapper.c (IBM)
 o sil.[ch]: added JBOD support
 
-
 MISCELANIOUS:
 -------------
 o streamlined devmapper.c
--- dmraid/KNOWN_BUGS	2008/02/22 17:04:35	1.2
+++ dmraid/KNOWN_BUGS	2008/02/22 17:06:54	1.3
@@ -1,7 +1,4 @@
 
-KNOWN_BUGS in dmraid 1.0.0.rc12					2005.05.15
+KNOWN_BUGS in dmraid 1.0.0.rc14					2005.11.08
 
 o "dmraid --sets[a/i]" doesn't work properly. Use the short option -s.
-
-o DOS partition recognition fails to recognize all partitions in
-  certain cases; likely a size issue with the underlying RAID set
--- dmraid/README	2008/02/22 17:06:00	1.4
+++ dmraid/README	2008/02/22 17:06:54	1.5
@@ -1,6 +1,6 @@
 ********************************************************************************
 *                                                                              *
-*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc13  2006.10.11   *
+*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc14  2006.11.08   *
 *                                                                              *
 *   (C)opyright 2004-2006  Heinz Mauelshagen, Red Hat GmbH.                    *
 *   All rights reserved.                                                       *
--- dmraid/TODO	2008/02/22 17:04:35	1.2
+++ dmraid/TODO	2008/02/22 17:06:54	1.3
@@ -1,7 +1,7 @@
 
--- dmraid 1.0.0.rc12 TODO --					2006.09.19
+-- dmraid 1.0.0.rc14 TODO --					2006.11.08
 
-o use kpartx instead of my own metadata format handlers
+o use kpartx instead of my own DOS metadata format handler
 
 o more enhancements for RAID set consistency checks
 
--- dmraid/lib/version.h	2008/02/22 17:06:00	1.3
+++ dmraid/lib/version.h	2008/02/22 17:06:54	1.4
@@ -1,12 +1,12 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1.0.0.rc13"
+#define	DMRAID_LIB_VERSION		"1.0.0.rc14"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
-#define	DMRAID_LIB_VERSION_SUFFIX	"rc13"
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc14"
 
-#define	DMRAID_LIB_DATE			"(2006.10.11)"
+#define	DMRAID_LIB_DATE			"(2006.11.08)"
 
 #endif
--- dmraid/lib/format/format.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/format.c	2008/02/22 17:06:54	1.3
@@ -18,7 +18,7 @@
  * Comment next line out to avoid pre-registration
  * checks on metadata format handlers.
  */
-#define	CHECK_FORMAT_HANDLER
+// #define	CHECK_FORMAT_HANDLER
 #ifdef	CHECK_FORMAT_HANDLER
 /*
  * Check that mandatory members of a metadata form handler are present.
--- dmraid/lib/format/ddf/ddf1.c	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1.c	2008/02/22 17:06:54	1.2
@@ -353,7 +353,7 @@
 
 	if (ddf1->adapter &&
 	    ddf1->adapter->pci_vendor == PCI_VENDOR_ID_ADAPTEC2) {
-		log_notice(lc, "%s: Adaptec mode discvered on %s",
+		log_notice(lc, "%s: Adaptec mode discovered on %s",
 			   handler, di->path);
 		ddf1->adaptec_mode = 1;
 	}
@@ -682,7 +682,7 @@
 			 struct ddf1_config_record *cr,
 			 struct ddf1_phys_drive *pd)
 {
-	if (cr)
+	if (cr && cr->sectors)
 		/* Some Adaptec controllers need this clamping. */
 		return type(lc, ddf1, cr) == t_raid0 ?
 		       cr->sectors - cr->sectors % stride(cr) : cr->sectors;
--- dmraid/lib/format/ddf/ddf1_crc.c	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1_crc.c	2008/02/22 17:06:54	1.2
@@ -16,11 +16,51 @@
 #include "ddf1.h"
 #include "ddf1_crc.h"
 #include "ddf1_lib.h"
-#include "zlib.h"
 
 #define DM_BYTEORDER_SWAB
 #include <datastruct/byteorder.h>
 
+/*
+ * CRC table code to avoid linking to zlib, because Ubuntu has
+ * problems with that plus this additionally saves space.
+ */
+
+/* Make the table for a fast CRC. */
+#define	CRC_TABLE_SIZE	256
+static inline void crc_table_init(uint32_t *crc_table)
+{
+	static int new = 1; /* Flag for table not yet computed. */
+
+	if (new) {
+		uint32_t c, n, k;
+
+		for (new = n = 0; n < CRC_TABLE_SIZE; *(crc_table++) = c, n++) {
+			for (c = n, k = 0; k < 8; k++)
+				c = (c & 1) ? (c >> 1) ^ 0xEDB88320L : c >> 1;
+		}
+	}
+}
+
+/*
+ * Update a running CRC with the bytes buf[0..len-1] -- the CRC
+ * should be initialized to all 1's, and the transmitted value
+ * is the 1's complement of the final running CRC (see the
+ * crc() routine below).
+ */
+/* Return the CRC of the bytes buf[0..len-1]. */
+static uint32_t crc(uint32_t crc, unsigned char *buf, int len)
+{
+	int n;
+	static uint32_t crc_table[CRC_TABLE_SIZE]; /* CRCs of 8-bit messages. */
+
+	crc_table_init(crc_table);
+	for (n = 0; n < len; n++)
+		crc = crc_table[(crc ^ buf[n]) & (CRC_TABLE_SIZE - 1)] ^
+		      (crc >> 8);
+
+	return crc ^ 0xFFFFFFFFL;
+}
+
 /* CRC info for various functions below */
 struct crc_info {
 	void *p;
@@ -32,22 +72,23 @@
 /* Compute the checksum of a table */
 static uint32_t do_crc32(struct lib_context *lc, struct crc_info *ci)
 {
-	uint32_t old_csum = *ci->crc, ret = crc32(0, NULL, 0); /* Init CRC */
+	uint32_t old_csum = *ci->crc, ret = 0xFFFFFFFF;
 
-	*ci->crc = 0xFFFFFFFF;
-	ret = crc32(ret, ci->p, ci->size); /* zlib */
+	*ci->crc = ret;
+	ret = crc(ret, ci->p, ci->size);
 	*ci->crc = old_csum;
 	return ret;
 }
 
+/* Return VD record size. */
 static inline size_t record_size(struct ddf1 *ddf1)
 {
 	return ddf1->primary->vd_config_record_len * DDF1_BLKSIZE;
 }
 
-#define CRC32(postfix, record_type, macro) \
-static int crc32_ ## postfix(struct lib_context *lc, struct dev_info *di, \
-			     struct ddf1 *ddf1, int idx) \
+#define CRC32(suffix, record_type, macro) \
+static int crc32_ ## suffix(struct lib_context *lc, struct dev_info *di, \
+			    struct ddf1 *ddf1, int idx) \
 { \
 	struct record_type *r = macro(ddf1, idx); \
 	struct crc_info ci = { \
@@ -86,9 +127,10 @@
 
 	crc32 = do_crc32(lc, ci);
 	if (*ci->crc != crc32)
-		log_warn(lc, "%s: %s with CRC %X, expected %X on %s",
+		log_print(lc, "%s: %s with CRC %X, expected %X on %s",
 			 HANDLER, ci->text, crc32, *ci->crc, di->path);
 	
+	
 	return 1;
 
 }
@@ -159,7 +201,7 @@
 		}
 	}
 
-	return type == CHECK ? ret & check_cfg_crc(lc, di, ddf1) :
+	return type == CHECK ? (ret & check_cfg_crc(lc, di, ddf1)) :
 			       update_cfg_crc(lc, di, ddf1);
 }
 
--- dmraid/lib/format/ddf/ddf1_lib.c	2008/02/22 17:04:35	1.1
+++ dmraid/lib/format/ddf/ddf1_lib.c	2008/02/22 17:06:54	1.2
@@ -57,7 +57,9 @@
 	struct ddf1_header *h = ddf1->primary;
 
 	/* The 0xFFFF nonsense is a weird Adaptec quirk */
-	return (h->max_primary_elements == 0xFFFF && ddf1->adaptec_mode) ?
+//	bz211016
+//	return (h->max_primary_elements == 0xFFFF && ddf1->adaptec_mode) ?
+	return (h->max_primary_elements == 0xFFFF) ?
 		h->max_phys_drives : h->max_primary_elements;
 }
 
--- dmraid/tools/Makefile.in	2008/02/22 17:04:36	1.2
+++ dmraid/tools/Makefile.in	2008/02/22 17:06:54	1.3
@@ -20,7 +20,7 @@
 TARGETS=\
 	dmraid
 
-DMRAIDLIBS=-ldmraid -lz
+DMRAIDLIBS=-ldmraid
 
 include $(top_srcdir)/make.tmpl
 
--- dmraid/tools/VERSION	2008/02/22 17:06:01	1.3
+++ dmraid/tools/VERSION	2008/02/22 17:06:54	1.4
@@ -1 +1 @@
-1.0.0.rc13 (2006.10.11)
+1.0.0.rc14 (2006.11.08)
