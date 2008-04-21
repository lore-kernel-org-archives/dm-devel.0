From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 21 Apr 2008 16:57:12 -0000
Message-ID: <20080421165712.19636.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-04-21 16:57:11

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	Use 'active' for !suspended as the code already uses that.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.106&r2=1.107

--- device-mapper/dmsetup/dmsetup.c	2008/04/21 13:16:30	1.106
+++ device-mapper/dmsetup/dmsetup.c	2008/04/21 16:57:11	1.107
@@ -1678,7 +1678,7 @@
 	if (info->suspended)
 		dm_report_field_set_value(field, "Suspended", NULL);
 	else
-		dm_report_field_set_value(field, "", NULL);
+		dm_report_field_set_value(field, "Active", NULL);
 
 	return 1;
 }
