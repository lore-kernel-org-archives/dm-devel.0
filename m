From: agk@sourceware.org
Subject: device-mapper WHATS_NEW
Date: 6 Jun 2008 20:45:41 -0000
Message-ID: <20080606204541.29827.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-06 20:45:41

Modified files:
	.              : WHATS_NEW 

Log message:
	.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.238&r2=1.239

--- device-mapper/WHATS_NEW	2008/06/06 20:33:13	1.238
+++ device-mapper/WHATS_NEW	2008/06/06 20:45:41	1.239
@@ -1,5 +1,6 @@
 Version 1.02.27 -
 ===============================
+  Remove --enable-jobs from configure. (Set at runtime instead.)
   Bring configure.in into line with the lvm2 version.
 
 Version 1.02.26 - 6th June 2008
