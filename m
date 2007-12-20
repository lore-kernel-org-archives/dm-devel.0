From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 20 Dec 2007 15:12:58 -0000
Message-ID: <20071220151258.31792.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-20 15:12:58

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.130&r2=1.131
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.220&r2=1.221

--- device-mapper/VERSION	2007/12/05 17:14:30	1.130
+++ device-mapper/VERSION	2007/12/20 15:12:57	1.131
@@ -1 +1 @@
-1.02.24-cvs (2007-12-05)
+1.02.24-cvs (2007-12-20)
--- device-mapper/WHATS_NEW	2007/12/14 19:49:26	1.220
+++ device-mapper/WHATS_NEW	2007/12/20 15:12:57	1.221
@@ -1,5 +1,5 @@
-Version 1.02.24 -
-===================================
+Version 1.02.24 - 20th December 2007
+====================================
   Fix deptree to pass new name to _resume_node after a rename.
   Suppress other node operations if node is deleted.
   Add node operation stack debug messages.
