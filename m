From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 21 Aug 2007 16:33:20 -0000
Message-ID: <20070821163320.21975.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-08-21 16:33:18

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.126&r2=1.127
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.200&r2=1.201

--- device-mapper/VERSION	2007/07/13 16:10:24	1.126
+++ device-mapper/VERSION	2007/08/21 16:33:18	1.127
@@ -1 +1 @@
-1.02.22-cvs (2007-07-13)
+1.02.22-cvs (2007-08-21)
--- device-mapper/WHATS_NEW	2007/08/21 16:26:06	1.200
+++ device-mapper/WHATS_NEW	2007/08/21 16:33:18	1.201
@@ -1,5 +1,5 @@
-Version 1.02.22 - 
-================================
+Version 1.02.22 - 21st August 2007
+==================================
   Fix inconsistent licence notices: executables are GPLv2; libraries LGPLv2.1.
   Update to use autoconf 2.61, while still supporting 2.57.
   Avoid repeated dm_task free on some dm_event_get_registered_device errors.
