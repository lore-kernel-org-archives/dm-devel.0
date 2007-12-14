From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-deptree.c
Date: 14 Dec 2007 17:57:05 -0000
Message-ID: <20071214175705.31687.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-14 17:57:05

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-deptree.c 

Log message:
	Fix deptree to pass new name to _resume_node after a rename.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.218&r2=1.219
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.34&r2=1.35

--- device-mapper/WHATS_NEW	2007/12/14 17:26:08	1.218
+++ device-mapper/WHATS_NEW	2007/12/14 17:57:04	1.219
@@ -1,5 +1,6 @@
 Version 1.02.24 -
 ===================================
+  Fix deptree to pass new name to _resume_node after a rename.
   Add node operation stack debug messages.
   Report error when empty device name passed to readahead functions.
   Fix minimum readahead debug message.
--- device-mapper/lib/libdm-deptree.c	2007/12/03 22:48:35	1.34
+++ device-mapper/lib/libdm-deptree.c	2007/12/14 17:57:04	1.35
@@ -1160,11 +1160,11 @@
 			if (!child->info.inactive_table && !child->info.suspended)
 				continue;
 
-			if (!_resume_node(name, child->info.major, child->info.minor,
+			if (!_resume_node(child->name, child->info.major, child->info.minor,
 					  child->props.read_ahead,
 					  child->props.read_ahead_flags, &newinfo)) {
 				log_error("Unable to resume %s (%" PRIu32
-					  ":%" PRIu32 ")", name, child->info.major,
+					  ":%" PRIu32 ")", child->name, child->info.major,
 					  child->info.minor);
 				continue;
 			}
