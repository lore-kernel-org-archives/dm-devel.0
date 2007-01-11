From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 11 Jan 2007 22:44:09 -0000
Message-ID: <20070111224409.7698.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-11 22:44:09

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.109&r2=1.110
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.142&r2=1.143

--- device-mapper/VERSION	2006/11/28 22:51:01	1.109
+++ device-mapper/VERSION	2007/01/11 22:44:09	1.110
@@ -1 +1 @@
-1.02.14-cvs (2006-11-28)
+1.02.14-cvs (2007-01-07)
--- device-mapper/WHATS_NEW	2007/01/11 21:54:51	1.142
+++ device-mapper/WHATS_NEW	2007/01/11 22:44:09	1.143
@@ -1,5 +1,5 @@
-Version 1.02.14 - 
-=============================
+Version 1.02.14 - 11th January 2007
+===================================
   Add dm_saprintf().
   Use CFLAGS when linking so mixed sparc builds can supply -m64.
   Add dm_tree_use_no_flush_suspend().
