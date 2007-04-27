From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 27 Apr 2007 15:12:27 -0000
Message-ID: <20070427151227.24704.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-04-27 16:12:26

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Fix segfault in 'dmsetup status' without --showkeys against crypt target. [nec]

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.177&r2=1.178
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.88&r2=1.89

--- device-mapper/WHATS_NEW	2007/04/27 14:52:40	1.177
+++ device-mapper/WHATS_NEW	2007/04/27 15:12:26	1.178
@@ -1,5 +1,6 @@
 Version 1.02.19 -
 ====================================
+  Fix segfault in 'dmsetup status' without --showkeys against crypt target.
   Deal with some more compiler warnings.
   Introduce _add_field() and _is_same_field() to libdm-report.c.
   Fix some libdevmapper-event and dmeventd memory leaks.
--- device-mapper/dmsetup/dmsetup.c	2007/04/27 14:52:40	1.88
+++ device-mapper/dmsetup/dmsetup.c	2007/04/27 15:12:26	1.89
@@ -962,17 +962,18 @@
 			if (data && !_switches[VERBOSE_ARG])
 				printf("%s: ", name);
 			if (target_type) {
-
-			/* Suppress encryption key */
-			if (!_switches[SHOWKEYS_ARG] &&
-			    !strcmp(target_type, "crypt")) {
-				c = params;
-				while (*c && *c != ' ')
-					c++;
-				c++;
-				while (*c && *c != ' ')
-					*c++ = '0';
-			}
+				/* Suppress encryption key */
+				if (!_switches[SHOWKEYS_ARG] &&
+				    cmd == DM_DEVICE_TABLE &&
+				    !strcmp(target_type, "crypt")) {
+					c = params;
+					while (*c && *c != ' ')
+						c++;
+					if (*c)
+						c++;
+					while (*c && *c != ' ')
+						*c++ = '0';
+				}
 				printf("%" PRIu64 " %" PRIu64 " %s %s",
 				       start, length, target_type, params);
 			}
