From: agk@sourceware.org
Subject: device-mapper/lib libdm-deptree.c
Date: 18 Sep 2008 22:55:33 -0000
Message-ID: <20080918225533.19806.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-09-18 22:55:33

Modified files:
	lib            : libdm-deptree.c 

Log message:
	Fix last checkin - tested wrong dnode.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.42&r2=1.43

--- device-mapper/lib/libdm-deptree.c	2008/09/18 18:34:53	1.42
+++ device-mapper/lib/libdm-deptree.c	2008/09/18 22:55:33	1.43
@@ -1551,7 +1551,7 @@
 		}
 
 		/* Resume device immediately if it has parents and its size changed */
-		if (!dm_tree_node_num_children(child, 1) || !dnode->props.size_changed)
+		if (!dm_tree_node_num_children(child, 1) || !child->props.size_changed)
 			continue;
 
 		if (!child->info.inactive_table && !child->info.suspended)
