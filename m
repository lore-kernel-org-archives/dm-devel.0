From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-report.c
Date: 25 Jun 2008 19:52:52 -0000
Message-ID: <20080625195252.22185.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-25 19:52:52

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-report.c 

Log message:
	Underline longer report help text headings.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.247&r2=1.248
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-report.c.diff?cvsroot=dm&r1=1.22&r2=1.23

--- device-mapper/WHATS_NEW	2008/06/25 14:44:00	1.247
+++ device-mapper/WHATS_NEW	2008/06/25 19:52:51	1.248
@@ -1,5 +1,6 @@
 Version 1.02.28 - 
 ================================
+  Underline longer report help text headings.
 
 Version 1.02.27 - 25th June 2008
 ================================
--- device-mapper/lib/libdm-report.c	2008/06/25 00:10:36	1.22
+++ device-mapper/lib/libdm-report.c	2008/06/25 19:52:52	1.23
@@ -267,8 +267,7 @@
 			log_warn("%s Fields", desc);
 			log_warn("%*.*s", (int) strlen(desc) + 7,
 				 (int) strlen(desc) + 7,
-				 "------------------------------------------");
-				  
+				 "-------------------------------------------------------------------------------");
 		}
 
 		/* FIXME Add line-wrapping at terminal width (or 80 cols) */
