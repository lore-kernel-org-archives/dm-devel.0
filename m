From: agk@sourceware.org
Subject: device-mapper/lib libdm-report.c
Date: 18 Jan 2007 21:59:02 -0000
Message-ID: <20070118215902.18646.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-18 21:59:02

Modified files:
	lib            : libdm-report.c 

Log message:
	fix last checkin

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.3&r2=1.4

--- device-mapper/lib/libdm-report.c	2007/01/18 17:47:58	1.3
+++ device-mapper/lib/libdm-report.c	2007/01/18 21:59:02	1.4
@@ -782,7 +782,7 @@
 						goto bad_snprintf;
 					if (!dm_pool_grow_object(rh->mem, buf, width))
 						goto bad_grow;
-				} else if (field->props->flags & DM_REPORT_FIELD_ALIGN_RIGHT) {
+				} else if (align & DM_REPORT_FIELD_ALIGN_RIGHT) {
 					if (dm_snprintf(buf, sizeof(buf), "%*.*s",
 							 width, width, repstr) < 0)
 						goto bad_snprintf;
