From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 5 Dec 2007 14:42:10 -0000
Message-ID: <20071205144210.28161.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 14:42:10

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	read_ahead in report with underscore to match lvm2 field

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.101&r2=1.102

--- device-mapper/dmsetup/dmsetup.c	2007/12/03 22:53:04	1.101
+++ device-mapper/dmsetup/dmsetup.c	2007/12/05 14:42:10	1.102
@@ -1881,7 +1881,7 @@
 FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique (optional) identifier for mapped device.")
 
 /* FIXME Next one should be INFO */
-FIELD_F(TASK, NUM, "RAhead", 6, dm_read_ahead, "readahead", "Read ahead in sectors.")
+FIELD_F(TASK, NUM, "RAhead", 6, dm_read_ahead, "read_ahead", "Read ahead in sectors.")
 
 FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "attr", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
 FIELD_F(INFO, STR, "DevNo", 5, dm_info_devno, "devno", "Device major and minor numbers")
