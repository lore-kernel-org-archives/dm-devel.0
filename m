From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 25 Jan 2007 23:33:46 -0000
Message-ID: <20070125233346.16207.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-25 23:33:45

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.114&r2=1.115
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.160&r2=1.161

--- device-mapper/VERSION	2007/01/17 17:50:54	1.114
+++ device-mapper/VERSION	2007/01/25 23:33:45	1.115
@@ -1 +1 @@
-1.02.16-cvs (2007-01-17)
+1.02.16-cvs (2007-01-25)
--- device-mapper/WHATS_NEW	2007/01/25 14:16:20	1.160
+++ device-mapper/WHATS_NEW	2007/01/25 23:33:45	1.161
@@ -1,4 +1,4 @@
-Version 1.02.16 -
+Version 1.02.16 - 25th January 2007
 ===================================
   Add some missing close() and fclose() return value checks.
   Migrate dmsetup column-based output over to new libdevmapper report framework.
