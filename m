From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-common.c
Date: 14 Dec 2007 17:26:09 -0000
Message-ID: <20071214172609.20871.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-14 17:26:09

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-common.c 

Log message:
	Add node operation stack debug messages.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.217&r2=1.218
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.56&r2=1.57

--- device-mapper/WHATS_NEW	2007/12/13 02:25:45	1.217
+++ device-mapper/WHATS_NEW	2007/12/14 17:26:08	1.218
@@ -1,5 +1,6 @@
 Version 1.02.24 -
 ===================================
+  Add node operation stack debug messages.
   Report error when empty device name passed to readahead functions.
   Fix minimum readahead debug message.
 
--- device-mapper/lib/libdm-common.c	2007/12/13 02:25:45	1.56
+++ device-mapper/lib/libdm-common.c	2007/12/14 17:26:09	1.57
@@ -575,18 +575,25 @@
 int add_dev_node(const char *dev_name, uint32_t major, uint32_t minor,
 		 uid_t uid, gid_t gid, mode_t mode)
 {
+	log_debug("%s: Stacking NODE_ADD (%" PRIu32 ",%" PRIu32 ") %u:%u 0%o",
+		  dev_name, major, minor, uid, gid, mode);
+
 	return _stack_node_op(NODE_ADD, dev_name, major, minor, uid, gid, mode,
 			      "", 0, 0);
 }
 
 int rename_dev_node(const char *old_name, const char *new_name)
 {
+	log_debug("%s: Stacking NODE_RENAME to %s", old_name, new_name);
+
 	return _stack_node_op(NODE_RENAME, new_name, 0, 0, 0, 0, 0, old_name,
 			      0, 0);
 }
 
 int rm_dev_node(const char *dev_name)
 {
+	log_debug("%s: Stacking NODE_DEL", dev_name);
+
 	return _stack_node_op(NODE_DEL, dev_name, 0, 0, 0, 0, 0, "", 0, 0);
 }
 
@@ -596,6 +603,9 @@
 	if (read_ahead == DM_READ_AHEAD_AUTO)
 		return 1;
 
+	log_debug("%s: Stacking NODE_READ_AHEAD %" PRIu32 " (flags=%" PRIu32
+		  ")", dev_name, read_ahead, read_ahead_flags);
+
 	return _stack_node_op(NODE_READ_AHEAD, dev_name, 0, 0, 0, 0, 0, "",
 			      read_ahead, read_ahead_flags);
 }
