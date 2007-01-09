From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/.exported_symbol ...
Date: 9 Jan 2007 19:44:07 -0000
Message-ID: <20070109194407.12218.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-09 19:44:07

Modified files:
	.              : WHATS_NEW 
	lib            : .exported_symbols libdevmapper.h 
	                 libdm-deptree.c 

Log message:
	Add dm_tree_use_no_flush_suspend().

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.139&r2=1.140
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.24&r2=1.25
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.60&r2=1.61
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.29&r2=1.30

--- device-mapper/WHATS_NEW	2007/01/08 15:18:52	1.139
+++ device-mapper/WHATS_NEW	2007/01/09 19:44:07	1.140
@@ -1,5 +1,6 @@
 Version 1.02.14 - 
 =============================
+  Add dm_tree_use_no_flush_suspend().
   Lots of dmevent changes.
   Export dm_basename().
   Cope with a trailing space when comparing tables prior to possible reload.
--- device-mapper/lib/.exported_symbols	2007/01/08 15:18:52	1.24
+++ device-mapper/lib/.exported_symbols	2007/01/09 19:44:07	1.25
@@ -66,6 +66,7 @@
 dm_tree_node_add_mirror_target_log
 dm_tree_node_add_target_area
 dm_tree_skip_lockfs
+dm_tree_use_no_flush_suspend
 dm_is_dm_major
 dm_mknodes
 dm_malloc_aux
--- device-mapper/lib/libdevmapper.h	2007/01/08 15:18:52	1.60
+++ device-mapper/lib/libdevmapper.h	2007/01/09 19:44:07	1.61
@@ -316,6 +316,16 @@
 void dm_tree_skip_lockfs(struct dm_tree_node *dnode);
 
 /*
+ * Set the 'noflush' flag when suspending devices.
+ * If the kernel supports it, instead of erroring outstanding I/O that
+ * cannot be completed, the I/O is queued and resubmitted when the
+ * device is resumed.  This affects multipath devices when all paths
+ * have failed and queue_if_no_path is set, and mirror devices when
+ * block_on_error is set and the mirror log has failed.
+ */
+void dm_tree_use_no_flush_suspend(struct dm_tree_node *dnode);
+
+/*
  * Is the uuid prefix present in the tree?
  * Only returns 0 if every node was checked successfully.
  * Returns 1 if the tree walk has to be aborted.
--- device-mapper/lib/libdm-deptree.c	2006/10/13 14:03:35	1.29
+++ device-mapper/lib/libdm-deptree.c	2007/01/09 19:44:07	1.30
@@ -130,6 +130,7 @@
 	struct dm_hash_table *uuids;
 	struct dm_tree_node root;
 	int skip_lockfs;		/* 1 skips lockfs (for non-snapshots) */
+	int no_flush;		/* 1 sets noflush (mirrors/multipath) */
 };
 
 /* FIXME Consider exporting this */
@@ -162,6 +163,7 @@
 	list_init(&dtree->root.uses);
 	list_init(&dtree->root.used_by);
 	dtree->skip_lockfs = 0;
+	dtree->no_flush = 0;
 
 	if (!(dtree->mem = dm_pool_create("dtree", 1024))) {
 		log_error("dtree pool creation failed");
@@ -903,13 +905,15 @@
 }
 
 static int _suspend_node(const char *name, uint32_t major, uint32_t minor,
-			 int skip_lockfs, struct dm_info *newinfo)
+			 int skip_lockfs, int no_flush, struct dm_info *newinfo)
 {
 	struct dm_task *dmt;
 	int r;
 
-	log_verbose("Suspending %s (%" PRIu32 ":%" PRIu32 ")%s", name, major,
-		    minor, skip_lockfs ? "" : " with filesystem sync.");
+	log_verbose("Suspending %s (%" PRIu32 ":%" PRIu32 ")%s%s",
+		    name, major, minor,
+		    skip_lockfs ? "" : " with filesystem sync",
+		    no_flush ? "" : " without device flush");
 
 	if (!(dmt = dm_task_create(DM_DEVICE_SUSPEND))) {
 		log_error("Suspend dm_task creation failed for %s", name);
@@ -928,6 +932,9 @@
 	if (skip_lockfs && !dm_task_skip_lockfs(dmt))
 		log_error("Failed to set skip_lockfs flag.");
 
+	if (no_flush && !dm_task_no_flush(dmt))
+		log_error("Failed to set no_flush flag.");
+
 	if ((r = dm_task_run(dmt)))
 		r = dm_task_get_info(dmt, newinfo);
 
@@ -991,6 +998,11 @@
 	dnode->dtree->skip_lockfs = 1;
 }
 
+void dm_tree_use_no_flush_suspend(struct dm_tree_node *dnode)
+{
+	dnode->dtree->no_flush = 1;
+}
+
 int dm_tree_suspend_children(struct dm_tree_node *dnode,
 				   const char *uuid_prefix,
 				   size_t uuid_prefix_len)
@@ -1032,7 +1044,8 @@
 			continue;
 
 		if (!_suspend_node(name, info.major, info.minor,
-				   child->dtree->skip_lockfs, &newinfo)) {
+				   child->dtree->skip_lockfs,
+				   child->dtree->no_flush, &newinfo)) {
 			log_error("Unable to suspend %s (%" PRIu32
 				  ":%" PRIu32 ")", name, info.major,
 				  info.minor);
