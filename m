From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-report.c
Date: 18 Jan 2007 22:15:04 -0000
Message-ID: <20070118221504.32628.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-18 22:15:04

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-report.c 

Log message:
	Suppress 'Unrecognised field' error if report field is 'help'.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.152&r2=1.153
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.4&r2=1.5

--- device-mapper/WHATS_NEW	2007/01/18 17:47:56	1.152
+++ device-mapper/WHATS_NEW	2007/01/18 22:15:04	1.153
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Suppress 'Unrecognised field' error if report field is 'help'.
   Add --separator and --sort to dmsetup (unused).
   Make alignment flag optional when specifying report fields.
 
--- device-mapper/lib/libdm-report.c	2007/01/18 21:59:02	1.4
+++ device-mapper/lib/libdm-report.c	2007/01/18 22:15:04	1.5
@@ -416,8 +416,9 @@
 		if (!_field_match(rh, ws, (size_t) (we - ws))) {
 			_display_fields(rh);
 			log_print(" ");
-			log_error("dm_report: Unrecognised field: %.*s",
-				  (int) (we - ws), ws);
+			if (strcasecmp(ws, "help") && strcmp(ws, "?"))
+				log_error("Unrecognised field: %.*s",
+					  (int) (we - ws), ws);
 			return 0;
 		}
 	}
