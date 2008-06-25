From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/mm/dbg_malloc.c
Date: 25 Jun 2008 14:10:34 -0000
Message-ID: <20080625141034.12407.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-25 14:10:34

Modified files:
	.              : WHATS_NEW 
	lib/mm         : dbg_malloc.c 

Log message:
	Align struct memblock in dbg_malloc for sparc.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.244&r2=1.245
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/mm/dbg_malloc.c.diff?cvsroot=dm&r1=1.11&r2=1.12

--- device-mapper/WHATS_NEW	2008/06/24 22:53:47	1.244
+++ device-mapper/WHATS_NEW	2008/06/25 14:10:33	1.245
@@ -1,5 +1,6 @@
 Version 1.02.27 -
 ===============================
+  Align struct memblock in dbg_malloc for sparc.
   Add --unquoted and --rows to dmsetup.
   Avoid compiler warning about cast in dmsetup.c's OFFSET_OF macro.
   Fix inverted no_flush debug message.
--- device-mapper/lib/mm/dbg_malloc.c	2007/08/21 16:26:07	1.11
+++ device-mapper/lib/mm/dbg_malloc.c	2008/06/25 14:10:33	1.12
@@ -40,7 +40,7 @@
 	const char *file;	/* File that allocated */
 	int line;		/* Line that allocated */
 	void *magic;		/* Address of this block */
-};
+} __attribute__((aligned(8)));
 
 static struct {
 	unsigned block_serialno;/* Non-decreasing serialno of block */
