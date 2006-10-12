From: agk@sourceware.org
Subject: device-mapper WHATS_NEW
Date: 12 Oct 2006 17:41:21 -0000
Message-ID: <20061012174121.7891.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-12 17:41:21

Modified files:
	.              : WHATS_NEW 

Log message:
	missing mesg

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.126&r2=1.127

--- device-mapper/WHATS_NEW	2006/10/12 17:37:42	1.126
+++ device-mapper/WHATS_NEW	2006/10/12 17:41:21	1.127
@@ -2,6 +2,7 @@
 ==============================
   Add suspend noflush support.
   Add basic dmsetup loop support.
+  Switch dmsetup to use dm_malloc etc.
 
 Version 1.02.10 - 19 Sep 2006
 =============================
