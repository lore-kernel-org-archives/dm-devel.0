From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-deptree.c
Date: 13 Oct 2006 14:03:35 -0000
Message-ID: <20061013140335.28520.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-13 14:03:35

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-deptree.c 

Log message:
	Avoid deptree attempting to suspend a device that's already suspended.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.129&r2=1.130
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.28&r2=1.29

--- device-mapper/WHATS_NEW	2006/10/12 17:45:11	1.129
+++ device-mapper/WHATS_NEW	2006/10/13 14:03:33	1.130
@@ -1,5 +1,6 @@
 Version 1.02.12 -
 ==============================
+  Avoid deptree attempting to suspend a device that's already suspended.
 
 Version 1.02.11 -  12 Oct 2006
 ==============================
--- device-mapper/lib/libdm-deptree.c	2006/05/16 16:20:29	1.28
+++ device-mapper/lib/libdm-deptree.c	2006/10/13 14:03:35	1.29
@@ -1028,7 +1028,7 @@
 			continue;
 
 		if (!_info_by_dev(dinfo->major, dinfo->minor, 0, &info) ||
-		    !info.exists)
+		    !info.exists || info.suspended)
 			continue;
 
 		if (!_suspend_node(name, info.major, info.minor,
