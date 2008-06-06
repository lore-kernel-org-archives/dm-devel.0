From: agk@sourceware.org
Subject: device-mapper VERSION WHATS_NEW
Date: 6 Jun 2008 19:09:20 -0000
Message-ID: <20080606190920.10589.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-06 19:09:20

Modified files:
	.              : VERSION WHATS_NEW 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.134&r2=1.135
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.235&r2=1.236

--- device-mapper/VERSION	2008/04/10 18:04:31	1.134
+++ device-mapper/VERSION	2008/06/06 19:09:19	1.135
@@ -1 +1 @@
-1.02.26-cvs (2008-04-10)
+1.02.26-cvs (2008-06-06)
--- device-mapper/WHATS_NEW	2008/06/06 18:53:26	1.235
+++ device-mapper/WHATS_NEW	2008/06/06 19:09:19	1.236
@@ -1,5 +1,5 @@
-Version 1.02.26 - 
-=================================
+Version 1.02.26 - 6th June 2008
+===============================
   Initialise params buffer to empty string in _emit_segment.
   Skip add_dev_node when ioctls disabled.
   Make dm_hash_iter safe against deletion.
