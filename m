From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/libdm-deptree.c  ...
Date: 18 Sep 2008 18:34:54 -0000
Message-ID: <20080918183454.16665.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-09-18 18:34:53

Modified files:
	.              : WHATS_NEW 
	lib            : libdm-deptree.c 
	lib/ioctl      : libdm-iface.c libdm-targets.h 

Log message:
	Only resume devices in dm_tree_preload_children if size changes.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.250&r2=1.251
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.41&r2=1.42
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.51&r2=1.52
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-targets.h.diff?cvsroot=dm&r1=1.22&r2=1.23

--- device-mapper/WHATS_NEW	2008/09/02 12:16:06	1.250
+++ device-mapper/WHATS_NEW	2008/09/18 18:34:53	1.251
@@ -1,7 +1,8 @@
-Version 1.02.28 - 
-================================
+Version 1.02.28 - 18th September 2008
+=====================================
+  Only resume devices in dm_tree_preload_children if size changes.
   Extend deptree buffers so the largest possible device numbers fit.
-  Added generation of the versioned libdevmapper-event.so for LVM's test
+  Generate versioned libdevmapper-event.so.
   Underline longer report help text headings.
 
 Version 1.02.27 - 25th June 2008
--- device-mapper/lib/libdm-deptree.c	2008/09/02 12:16:07	1.41
+++ device-mapper/lib/libdm-deptree.c	2008/09/18 18:34:53	1.42
@@ -99,6 +99,7 @@
 	uint32_t read_ahead_flags;
 
 	unsigned segment_count;
+	unsigned size_changed;
 	struct list segs;
 
 	const char *new_name;
@@ -603,6 +604,7 @@
 		dnode->props.major = major;
 		dnode->props.minor = minor;
 		dnode->props.new_name = NULL;
+		dnode->props.size_changed = 0;
 	} else if (strcmp(name, dnode->name)) {
 		/* Do we need to rename node? */
 		if (!(dnode->props.new_name = dm_pool_strdup(dtree->mem, name))) {
@@ -1494,6 +1496,13 @@
 		if (r && !dnode->info.inactive_table)
 			log_verbose("Suppressed %s identical table reload.",
 				    dnode->name);
+
+		if ((dnode->props.size_changed =
+		     (dm_task_get_existing_table_size(dmt) == seg_start) ? 0 : 1))
+			log_debug("Table size changed from %" PRIu64 " to %"
+				  PRIu64 " for %s",
+				  dm_task_get_existing_table_size(dmt),
+				  seg_start, dnode->name);
 	}
 
 	dnode->props.segment_count = 0;
@@ -1505,8 +1514,8 @@
 }
 
 int dm_tree_preload_children(struct dm_tree_node *dnode,
-				 const char *uuid_prefix,
-				 size_t uuid_prefix_len)
+			     const char *uuid_prefix,
+			     size_t uuid_prefix_len)
 {
 	void *handle = NULL;
 	struct dm_tree_node *child;
@@ -1541,8 +1550,8 @@
 			}
 		}
 
-		/* Resume device immediately if it has parents */
-		if (!dm_tree_node_num_children(child, 1))
+		/* Resume device immediately if it has parents and its size changed */
+		if (!dm_tree_node_num_children(child, 1) || !dnode->props.size_changed)
 			continue;
 
 		if (!child->info.inactive_table && !child->info.suspended)
--- device-mapper/lib/ioctl/libdm-iface.c	2008/05/21 16:14:45	1.51
+++ device-mapper/lib/ioctl/libdm-iface.c	2008/09/18 18:34:53	1.52
@@ -1501,6 +1501,11 @@
 	return r;
 }
 
+uint64_t dm_task_get_existing_table_size(struct dm_task *dmt)
+{
+	return dmt->existing_table_size;
+}
+
 static int _reload_with_suppression_v4(struct dm_task *dmt)
 {
 	struct dm_task *task;
@@ -1534,6 +1539,12 @@
 		return r;
 	}
 
+	/* Store existing table size */
+	t2 = task->head;
+	while (t2 && t2->next)
+		t2 = t2->next;
+	dmt->existing_table_size = t2 ? t2->start + t2->length : 0;
+
 	if ((task->dmi.v4->flags & DM_READONLY_FLAG) ? 1 : 0 != dmt->read_only)
 		goto no_match;
 
--- device-mapper/lib/ioctl/libdm-targets.h	2007/11/27 20:57:05	1.22
+++ device-mapper/lib/ioctl/libdm-targets.h	2008/09/18 18:34:53	1.23
@@ -58,6 +58,7 @@
 	int no_open_count;
 	int skip_lockfs;
 	int suppress_identical_reload;
+	uint64_t existing_table_size;
 
 	char *uuid;
 };
@@ -69,5 +70,6 @@
 };
 
 int dm_check_version(void);
+uint64_t dm_task_get_existing_table_size(struct dm_task *dmt);
 
 #endif
