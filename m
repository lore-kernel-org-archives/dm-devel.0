From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 13 Jul 2007 16:07:30 -0000
Message-ID: <20070713160730.9998.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-07-13 16:07:30

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.124&r2=1.125
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.189&r2=1.190

--- device-mapper/VERSION	2007/06/15 20:49:30	1.124
+++ device-mapper/VERSION	2007/07/13 16:07:30	1.125
@@ -1 +1 @@
-1.02.21-cvs (2007-06-15)
+1.02.21-cvs (2007-07-13)
--- device-mapper/WHATS_NEW	2007/06/28 17:27:01	1.189
+++ device-mapper/WHATS_NEW	2007/07/13 16:07:30	1.190
@@ -1,7 +1,7 @@
-Version 1.02.21 -
+Version 1.02.21 - 13th July 2007
 ================================
+  Introduce _LOG_STDERR to send log_warn() messages to stderr not stdout.
   Fix dmsetup -o devno string termination. (1.02.20) 
-  Print warnings to stderr instead of stdout.
 
 Version 1.02.20 - 15th June 2007
 ================================
