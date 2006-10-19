From: agk@sourceware.org
Subject: device-mapper WHATS_NEW
Date: 19 Oct 2006 16:50:06 -0000
Message-ID: <20061019165006.18807.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-19 16:50:06

Modified files:
	.              : WHATS_NEW 

Log message:
	getline debug free

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.133&r2=1.134

--- device-mapper/WHATS_NEW	2006/10/19 15:34:49	1.133
+++ device-mapper/WHATS_NEW	2006/10/19 16:50:05	1.134
@@ -1,5 +1,6 @@
 Version 1.02.13 - 
 =============================
+  Fix dmsetup free after getline with debug.
   Suppress encryption key in 'dmsetup table' output unless --showkeys supplied.
 
 Version 1.02.12 - 13 Oct 2006
