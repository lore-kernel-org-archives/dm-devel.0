From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 19 Jun 2007 16:50:39 -0000
Message-ID: <20070619165039.23483.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-06-19 16:50:38

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	revert accidental change

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.93&r2=1.94

--- device-mapper/dmsetup/dmsetup.c	2007/06/19 15:47:20	1.93
+++ device-mapper/dmsetup/dmsetup.c	2007/06/19 16:50:38	1.94
@@ -1662,7 +1662,7 @@
 		name = dm_tree_node_get_name(parent);
 		if (!name || !*name)
 			continue;
-		if (!first_node && !dm_pool_grow_object(mem, ",", 2)) {
+		if (!first_node && !dm_pool_grow_object(mem, ",", 1)) {
 			log_error("dm_pool_grow_object failed");
 			goto out_abandon;
 		}
