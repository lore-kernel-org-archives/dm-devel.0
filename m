From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdevmapper.h l ...
Date: 29 Jan 2007 17:23:55 -0000
Message-ID: <20070129172355.16230.qmail@sourceware.org>
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
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-01-29 17:23:54

Modified files:
	.              : WHATS_NEW 
	lib            : libdevmapper.h libdm-report.c 

Log message:
	Use fixed-size fields in report interface.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.162&r2=1.163
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.67&r2=1.68
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.10&r2=1.11

--- device-mapper/WHATS_NEW	2007/01/25 23:36:05	1.162
+++ device-mapper/WHATS_NEW	2007/01/29 17:23:54	1.163
@@ -1,5 +1,6 @@
 Version 1.02.17 -
 ===================================
+  Use fixed-size fields in report interface.
 
 Version 1.02.16 - 25th January 2007
 ===================================
--- device-mapper/lib/libdevmapper.h	2007/01/23 19:18:52	1.67
+++ device-mapper/lib/libdevmapper.h	2007/01/29 17:23:54	1.68
@@ -657,11 +657,11 @@
 struct dm_report;
 struct dm_report_field_type {
 	uint32_t type;		/* object type id */
+	uint32_t flags;		/* DM_REPORT_FIELD_* */
+	uint32_t offset;	/* byte offset in the object */
+	int32_t width;		/* default width */
 	const char id[32];	/* string used to specify the field */
-	unsigned int offset;	/* byte offset in the object */
 	const char heading[32];	/* string printed in header */
-	int width;		/* default width */
-	uint32_t flags;		/* DM_REPORT_FIELD_* */
 	int (*report_fn)(struct dm_report *rh, struct dm_pool *mem,
 			 struct dm_report_field *field, const void *data,
 			 void *private);
--- device-mapper/lib/libdm-report.c	2007/01/24 16:41:33	1.10
+++ device-mapper/lib/libdm-report.c	2007/01/29 17:23:54	1.11
@@ -60,7 +60,7 @@
 	struct list list;
 	uint32_t field_num;
 	uint32_t sort_posn;
-	unsigned width;
+	int32_t width;
 	const struct dm_report_object_type *type;
 	uint32_t flags;
 };
@@ -750,7 +750,7 @@
 	struct dm_report_field *field;
 	const char *repstr;
 	char buf[4096];
-	unsigned width;
+	int32_t width;
 	uint32_t align;
 
 	if (list_empty(&rh->rows))
