From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-report.c
Date: 27 Apr 2007 15:22:27 -0000
Message-ID: <20070427152227.27655.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-04-27 16:22:27

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-report.c 

Log message:
	Avoid trailing separator in reports when there are hidden sort fields.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.178&r2=1.179
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.13&r2=1.14

--- device-mapper/WHATS_NEW	2007/04/27 15:12:26	1.178
+++ device-mapper/WHATS_NEW	2007/04/27 15:22:27	1.179
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Avoid trailing separator in reports when there are hidden sort fields.
   Fix segfault in 'dmsetup status' without --showkeys against crypt target.
   Deal with some more compiler warnings.
   Introduce _add_field() and _is_same_field() to libdm-report.c.
--- device-mapper/lib/libdm-report.c	2007/04/19 20:24:00	1.13
+++ device-mapper/lib/libdm-report.c	2007/04/27 15:22:27	1.14
@@ -316,7 +316,15 @@
 	}
 
 	fp->flags |= flags;
-	list_add(&rh->field_props, &fp->list);
+
+	/*
+	 * Place hidden fields at the front so list_end() will
+	 * tell us when we've reached the last visible field.
+	 */
+	if (fp->flags & FLD_HIDDEN)
+		list_add_h(&rh->field_props, &fp->list);
+	else
+		list_add(&rh->field_props, &fp->list);
 
 	return fp;
 }
