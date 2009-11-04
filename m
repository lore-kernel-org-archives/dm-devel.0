From: heinzm@sourceware.org
Subject: dmraid/lib/metadata metadata.c
Date: 4 Nov 2009 13:06:36 -0000
Message-ID: <20091104130636.12529.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-11-04 13:06:36

Modified files:
	lib/metadata   : metadata.c 

Log message:
	Return error when no block devices or no RAID disks found

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/metadata/metadata.c.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/lib/metadata/metadata.c	2009/09/16 11:45:16	1.7
+++ dmraid/lib/metadata/metadata.c	2009/11/04 13:06:36	1.8
@@ -2096,7 +2096,7 @@
 
 	if (!count_devices(lc, DEVICE)) {
 		log_print(lc, "no block devices found");
-		return 1;
+		return 0;
 	}
 
 	if (!(M_RAID & p->metadata))
@@ -2118,7 +2118,7 @@
 	if (!OPT_HOT_SPARE_SET(lc) && !OPT_CREATE(lc)
 	    && !count_devices(lc, RAID)) {
 		format_error(lc, "disks", argv);
-		return 1;
+		return 0;
 	}
 
 	if (M_SET & p->metadata) {
