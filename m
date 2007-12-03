From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 3 Dec 2007 22:53:04 -0000
Message-ID: <20071203225304.3256.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-03 22:53:04

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	fixme

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.100&r2=1.101

--- device-mapper/dmsetup/dmsetup.c	2007/12/03 22:48:35	1.100
+++ device-mapper/dmsetup/dmsetup.c	2007/12/03 22:53:04	1.101
@@ -339,6 +339,7 @@
 	       info->suspended ? "SUSPENDED" : "ACTIVE",
 	       info->read_only ? " (READ-ONLY)" : "");
 
+	/* FIXME Old value is being printed when it's being changed. */
 	if (dm_task_get_read_ahead(dmt, &read_ahead))
 		printf("Read Ahead:        %" PRIu32 "\n", read_ahead);
 
