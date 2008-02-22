From: heinzm@sourceware.org
Subject: dmraid ./CHANGELOG ./README lib/version.h lib/ ...
Date: 22 Feb 2008 17:06:02 -0000
Message-ID: <20080222170602.29875.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2008-02-22 17:06:01

Modified files:
	.              : CHANGELOG README 
	lib            : version.h 
	lib/format/ataraid: asr.c pdc.c 
	lib/metadata   : metadata.c 
	tools          : VERSION 

Log message:
	1.0.0.rc13 checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/CHANGELOG.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/README.diff?cvsroot=dm&r1=1.3&r2=1.4
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/asr.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/format/ataraid/pdc.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/VERSION.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/CHANGELOG	2008/02/22 17:04:35	1.2
+++ dmraid/CHANGELOG	2008/02/22 17:06:00	1.3
@@ -1,4 +1,14 @@
 
+Changelog from dmraid 1.0.0.rc12 to 1.0.0.rc13		2006.10.11
+
+
+FIXES:
+------
+o pdc.c: magic number check
+o metadata.c: rd_type() returned wrong unified_type for asr
+
+
+
 Changelog from dmraid 1.0.0.rc11 to 1.0.0.rc12		2006.09.22
 
 
@@ -21,6 +31,7 @@
 
 
 
+
 Changelog from dmraid 1.0.0.rc10 to 1.0.0.rc11		2006.05.16
 
 FIXES:
--- dmraid/README	2008/02/22 17:04:35	1.3
+++ dmraid/README	2008/02/22 17:06:00	1.4
@@ -1,6 +1,6 @@
 ********************************************************************************
 *                                                                              *
-*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc12  2006.05.15   *
+*   dmraid (Device-Mapper Software RAID support tool) 1.0.0.rc13  2006.10.11   *
 *                                                                              *
 *   (C)opyright 2004-2006  Heinz Mauelshagen, Red Hat GmbH.                    *
 *   All rights reserved.                                                       *
--- dmraid/lib/version.h	2008/02/22 17:04:35	1.2
+++ dmraid/lib/version.h	2008/02/22 17:06:00	1.3
@@ -1,12 +1,12 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1.0.0.rc12"
+#define	DMRAID_LIB_VERSION		"1.0.0.rc13"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
 #define	DMRAID_LIB_SUBMINOR_VERSION	0
-#define	DMRAID_LIB_VERSION_SUFFIX	"rc12"
+#define	DMRAID_LIB_VERSION_SUFFIX	"rc13"
 
-#define	DMRAID_LIB_DATE			"(2006.09.15)"
+#define	DMRAID_LIB_DATE			"(2006.10.11)"
 
 #endif
--- dmraid/lib/format/ataraid/asr.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/asr.c	2008/02/22 17:06:00	1.3
@@ -114,6 +114,7 @@
 		{ 0, t_undef},
 	};
 
+printf("cl->raidtype=%d rd_type=%d\n", cl->raidtype, rd_type(types, (unsigned int) cl->raidtype));
 	return cl ? rd_type(types, (unsigned int) cl->raidtype) : t_undef;
 }
 
--- dmraid/lib/format/ataraid/pdc.c	2008/02/22 17:04:35	1.2
+++ dmraid/lib/format/ataraid/pdc.c	2008/02/22 17:06:00	1.3
@@ -170,8 +170,7 @@
 	 * No we've got the PDC magic string veryfied, we can
 	 * check that the rest of the metadata is valid.
 	 */
-	if (pdc->magic_0 == pdc->raid.magic_0 &&
-	    pdc->raid.total_disks &&
+	if (pdc->raid.total_disks &&
 	    pdc->raid.total_disks < PDC_MAXDISKS)
 		return 1;
 
--- dmraid/lib/metadata/metadata.c	2008/02/22 17:04:36	1.2
+++ dmraid/lib/metadata/metadata.c	2008/02/22 17:06:00	1.3
@@ -987,8 +987,7 @@
  */
 enum type rd_type(struct types *t, unsigned int type)
 {
-	for (; t->type && t->type != type; t++);
-
+	for (; t->unified_type != t_undef && t->type != type; t++);
 	return t->unified_type;
 }
 
@@ -1000,7 +999,6 @@
 enum status rd_status(struct states *s, unsigned int status, enum compare cmp)
 {
 	for (; s->status && (cmp == AND ? !(s->status & status) : (s->status != status)); s++);
-
 	return s->unified_status;
 }
 
--- dmraid/tools/VERSION	2008/02/22 17:04:36	1.2
+++ dmraid/tools/VERSION	2008/02/22 17:06:01	1.3
@@ -1 +1 @@
-1.0.0.rc12 (2006.09.15)
+1.0.0.rc13 (2006.10.11)
