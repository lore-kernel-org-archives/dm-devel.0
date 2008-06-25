From: agk@sourceware.org
Subject: device-mapper ./VERSION ./WHATS_NEW lib/libdm- ...
Date: 25 Jun 2008 14:24:18 -0000
Message-ID: <20080625142418.22142.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-25 14:24:18

Modified files:
	.              : VERSION WHATS_NEW 
	lib            : libdm-deptree.c 

Log message:
	pre-commit

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.136&r2=1.137
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.245&r2=1.246
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.39&r2=1.40

--- device-mapper/VERSION	2008/06/06 19:22:09	1.136
+++ device-mapper/VERSION	2008/06/25 14:24:17	1.137
@@ -1 +1 @@
-1.02.27-cvs (2008-06-06)
+1.02.27-cvs (2008-06-25)
--- device-mapper/WHATS_NEW	2008/06/25 14:10:33	1.245
+++ device-mapper/WHATS_NEW	2008/06/25 14:24:17	1.246
@@ -1,5 +1,5 @@
-Version 1.02.27 -
-===============================
+Version 1.02.27 - 25th June 2008
+================================
   Align struct memblock in dbg_malloc for sparc.
   Add --unquoted and --rows to dmsetup.
   Avoid compiler warning about cast in dmsetup.c's OFFSET_OF macro.
--- device-mapper/lib/libdm-deptree.c	2008/06/10 11:19:19	1.39
+++ device-mapper/lib/libdm-deptree.c	2008/06/25 14:24:17	1.40
@@ -937,7 +937,7 @@
 	log_verbose("Suspending %s (%" PRIu32 ":%" PRIu32 ")%s%s",
 		    name, major, minor,
 		    skip_lockfs ? "" : " with filesystem sync",
-		    no_flush ? " without device flush" : "");
+		    no_flush ? "" : " with device flush");
 
 	if (!(dmt = dm_task_create(DM_DEVICE_SUSPEND))) {
 		log_error("Suspend dm_task creation failed for %s", name);
