From: agk@sourceware.org
Subject: device-mapper WHATS_NEW
Date: 13 Oct 2006 19:01:31 -0000
Message-ID: <20061013190131.1956.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-13 19:01:31

Modified files:
	.              : WHATS_NEW 

Log message:
	post-release.
	
	Note that I've dropped the 2.4 kernel files from the release tarballs now.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.131&r2=1.132

--- device-mapper/WHATS_NEW	2006/10/13 18:43:53	1.131
+++ device-mapper/WHATS_NEW	2006/10/13 19:01:30	1.132
@@ -1,3 +1,6 @@
+Version 1.02.13 - 
+=============================
+
 Version 1.02.12 - 13 Oct 2006
 =============================
   Avoid deptree attempting to suspend a device that's already suspended.
