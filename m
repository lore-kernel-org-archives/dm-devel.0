From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-common.c l ...
Date: 14 Dec 2007 19:49:27 -0000
Message-ID: <20071214194927.30197.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-14 19:49:27

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-common.c libdm-deptree.c 

Log message:
	more readahead node fixes/debug messages

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.219&r2=1.220
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.57&r2=1.58
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.35&r2=1.36

--- device-mapper/WHATS_NEW	2007/12/14 17:57:04	1.219
+++ device-mapper/WHATS_NEW	2007/12/14 19:49:26	1.220
@@ -1,6 +1,7 @@
 Version 1.02.24 -
 ===================================
   Fix deptree to pass new name to _resume_node after a rename.
+  Suppress other node operations if node is deleted.
   Add node operation stack debug messages.
   Report error when empty device name passed to readahead functions.
   Fix minimum readahead debug message.
--- device-mapper/lib/libdm-common.c	2007/12/14 17:26:09	1.57
+++ device-mapper/lib/libdm-common.c	2007/12/14 19:49:27	1.58
@@ -300,6 +300,8 @@
 		return 0;
 	}
 
+	log_debug("Created %s", path);
+
 #ifdef HAVE_SELINUX
 	if (!dm_set_selinux_context(path, S_IFBLK))
 		return 0;
@@ -341,6 +343,8 @@
 		return 0;
 	}
 
+	log_debug("Renamed %s to %s", oldpath, newpath);
+
 	return 1;
 }
 
@@ -359,6 +363,8 @@
 		return 0;
 	}
 
+	log_debug("Removed %s", path);
+
 	return 1;
 }
 
@@ -531,9 +537,23 @@
 			  uint32_t read_ahead_flags)
 {
 	struct node_op_parms *nop;
+	struct list *noph, *nopht;
 	size_t len = strlen(dev_name) + strlen(old_name) + 2;
 	char *pos;
 
+	/*
+	 * Ignore any outstanding operations on the node if deleting it
+	 */
+	if (type == NODE_DEL) {
+		list_iterate_safe(noph, nopht, &_node_ops) {
+			nop = list_item(noph, struct node_op_parms);
+			if (!strcmp(dev_name, nop->dev_name)) {
+				list_del(&nop->list);
+				dm_free(nop);
+			}
+		}
+	}
+
 	if (!(nop = dm_malloc(sizeof(*nop) + len))) {
 		log_error("Insufficient memory to stack mknod operation");
 		return 0;
@@ -592,7 +612,7 @@
 
 int rm_dev_node(const char *dev_name)
 {
-	log_debug("%s: Stacking NODE_DEL", dev_name);
+	log_debug("%s: Stacking NODE_DEL (replaces other stacked ops)", dev_name);
 
 	return _stack_node_op(NODE_DEL, dev_name, 0, 0, 0, 0, 0, "", 0, 0);
 }
--- device-mapper/lib/libdm-deptree.c	2007/12/14 17:57:04	1.35
+++ device-mapper/lib/libdm-deptree.c	2007/12/14 19:49:27	1.36
@@ -1510,7 +1510,6 @@
 	void *handle = NULL;
 	struct dm_tree_node *child;
 	struct dm_info newinfo;
-	const char *name;
 
 	/* Preload children first */
 	while ((child = dm_tree_next_child(&handle, dnode, 0))) {
@@ -1526,11 +1525,6 @@
 		if (dm_tree_node_num_children(child, 0))
 			dm_tree_preload_children(child, uuid_prefix, uuid_prefix_len);
 
-		if (!(name = dm_tree_node_get_name(child))) {
-			stack;
-			continue;
-		}
-
 		/* FIXME Cope if name exists with no uuid? */
 		if (!child->info.exists) {
 			if (!_create_node(child)) {
@@ -1553,11 +1547,11 @@
 		if (!child->info.inactive_table && !child->info.suspended)
 			continue;
 
-		if (!_resume_node(name, child->info.major, child->info.minor,
+		if (!_resume_node(child->name, child->info.major, child->info.minor,
 				  child->props.read_ahead,
 				  child->props.read_ahead_flags, &newinfo)) {
 			log_error("Unable to resume %s (%" PRIu32
-				  ":%" PRIu32 ")", name, child->info.major,
+				  ":%" PRIu32 ")", child->name, child->info.major,
 				  child->info.minor);
 			continue;
 		}
