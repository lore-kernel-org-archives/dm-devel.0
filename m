From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-deptree.c
Date: 10 Jun 2008 11:19:19 -0000
Message-ID: <20080610111919.18537.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-10 11:19:19

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-deptree.c 

Log message:
	Fix inverted no_flush debug message. (mpatocka)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.240&r2=1.241
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.38&r2=1.39

--- device-mapper/WHATS_NEW	2008/06/08 14:53:51	1.240
+++ device-mapper/WHATS_NEW	2008/06/10 11:19:18	1.241
@@ -1,5 +1,6 @@
 Version 1.02.27 -
 ===============================
+  Fix inverted no_flush debug message.
   Remove --enable-jobs from configure. (Set at runtime instead.)
   Bring configure.in and list.h into line with the lvm2 versions.
 
--- device-mapper/lib/libdm-deptree.c	2008/06/05 19:10:35	1.38
+++ device-mapper/lib/libdm-deptree.c	2008/06/10 11:19:19	1.39
@@ -937,7 +937,7 @@
 	log_verbose("Suspending %s (%" PRIu32 ":%" PRIu32 ")%s%s",
 		    name, major, minor,
 		    skip_lockfs ? "" : " with filesystem sync",
-		    no_flush ? "" : " without device flush");
+		    no_flush ? " without device flush" : "");
 
 	if (!(dmt = dm_task_create(DM_DEVICE_SUSPEND))) {
 		log_error("Suspend dm_task creation failed for %s", name);
