From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 19 Jun 2007 15:47:21 -0000
Message-ID: <20070619154721.23122.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-06-19 15:47:21

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Fix dmsetup -o devno string termination. (1.02.20)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.187&r2=1.188
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.92&r2=1.93

--- device-mapper/WHATS_NEW	2007/06/15 20:49:30	1.187
+++ device-mapper/WHATS_NEW	2007/06/19 15:47:20	1.188
@@ -1,5 +1,6 @@
 Version 1.02.21 -
 ================================
+  Fix dmsetup -o devno string termination. (1.02.20) 
 
 Version 1.02.20 - 15th June 2007
 ================================
--- device-mapper/dmsetup/dmsetup.c	2007/06/15 18:20:28	1.92
+++ device-mapper/dmsetup/dmsetup.c	2007/06/19 15:47:20	1.93
@@ -1629,7 +1629,7 @@
 		goto out_abandon;
 	}
 
-	if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+	if (!dm_pool_grow_object(mem, buf, strlen(buf) + 1)) {
 		log_error("dm_pool_grow_object failed");
 		goto out_abandon;
 	}
@@ -1662,7 +1662,7 @@
 		name = dm_tree_node_get_name(parent);
 		if (!name || !*name)
 			continue;
-		if (!first_node && !dm_pool_grow_object(mem, ",", 1)) {
+		if (!first_node && !dm_pool_grow_object(mem, ",", 2)) {
 			log_error("dm_pool_grow_object failed");
 			goto out_abandon;
 		}
