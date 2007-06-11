From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 11 Jun 2007 13:20:29 -0000
Message-ID: <20070611132029.7314.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-06-11 13:20:29

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Add capability for tree-based fields to dmsetup reports.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.183&r2=1.184
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.90&r2=1.91

--- device-mapper/WHATS_NEW	2007/04/27 20:09:08	1.183
+++ device-mapper/WHATS_NEW	2007/06/11 13:20:28	1.184
@@ -1,5 +1,6 @@
 Version 1.02.20 -
 =================================
+  Add capability for tree-based fields to dmsetup reports.
 
 Version 1.02.19 - 27th April 2007
 =================================
--- device-mapper/dmsetup/dmsetup.c	2007/04/27 18:01:45	1.90
+++ device-mapper/dmsetup/dmsetup.c	2007/06/11 13:20:29	1.91
@@ -127,6 +127,12 @@
 	NUM_SWITCHES
 };
 
+typedef enum {
+	DR_TASK = 1,
+	DR_INFO = 2,
+	DR_TREE = 8	/* Complete dependency tree required */
+} report_type_t;
+
 static int _switches[NUM_SWITCHES];
 static int _int_args[NUM_SWITCHES];
 static char *_string_args[NUM_SWITCHES];
@@ -137,6 +143,7 @@
 static char *_command;
 static struct dm_tree *_dtree;
 static struct dm_report *_report;
+static report_type_t _report_type;
 
 /*
  * Commands
@@ -240,11 +247,13 @@
 struct dmsetup_report_obj {
 	struct dm_task *task;
 	struct dm_info *info;
+	struct dm_tree_node *tree_node;
 };
 
 static int _display_info_cols(struct dm_task *dmt, struct dm_info *info)
 {
 	struct dmsetup_report_obj obj;
+	int r = 0;
 
 	if (!info->exists) {
 		fprintf(stderr, "Device does not exist.\n");
@@ -254,10 +263,16 @@
 	obj.task = dmt;
 	obj.info = info;
 
+	if (_report_type & DR_TREE)
+		obj.tree_node = dm_tree_find_node(_dtree, info->major, info->minor);
+
 	if (!dm_report_object(_report, &obj))
-		return 0;
+		goto out;
 
-	return 1;
+	r = 1;
+
+      out:
+	return r;
 }
 
 static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
@@ -1419,7 +1434,8 @@
 /*
  * Walk the dependency tree
  */
-static void _tree_walk_children(struct dm_tree_node *node, unsigned depth)
+static void _display_tree_walk_children(struct dm_tree_node *node,
+					unsigned depth)
 {
 	struct dm_tree_node *child, *next_child;
 	void *handle = NULL;
@@ -1438,7 +1454,7 @@
 				   next_child ? 0U : 1U, has_children);
 
 		if (has_children)
-			_tree_walk_children(child, depth + 1);
+			_display_tree_walk_children(child, depth + 1);
 
 		first_child = 0;
 	}
@@ -1457,17 +1473,28 @@
 /*
  * Create and walk dependency tree
  */
-static int _tree(int argc, char **argv, void *data __attribute((unused)))
+static int _build_whole_deptree(void)
 {
+	if (_dtree)
+		return 1;
+
 	if (!(_dtree = dm_tree_create()))
 		return 0;
 
-	if (!_process_all(argc, argv, 0, _add_dep))
+	if (!_process_all(0, NULL, 0, _add_dep))
 		return 0;
 
-	_tree_walk_children(dm_tree_find_node(_dtree, 0, 0), 0);
+	return 1;
+}
 
-	dm_tree_free(_dtree);
+static int _display_tree(int argc __attribute((unused)),
+			 char **argv __attribute((unused)),
+			 void *data __attribute((unused)))
+{
+	if (!_build_whole_deptree())
+		return 0;
+
+	_display_tree_walk_children(dm_tree_find_node(_dtree, 0, 0), 0);
 
 	return 1;
 }
@@ -1490,8 +1517,8 @@
 
 static int _uint32_disp(struct dm_report *rh,
 			struct dm_pool *mem __attribute((unused)),
-		        struct dm_report_field *field, const void *data,
-		        void *private __attribute((unused)))
+			struct dm_report_field *field, const void *data,
+			void *private __attribute((unused)))
 {
 	const uint32_t value = *(const int32_t *)data;
 
@@ -1539,8 +1566,16 @@
 	return dm_report_field_string(rh, field, &s);
 }
 
-/* Report types */
-enum { DR_TASK = 1, DR_INFO = 2 };
+static int _dm_tree_parents_count_disp(struct dm_report *rh,
+				       struct dm_pool *mem,
+				       struct dm_report_field *field,
+				       const void *data, void *private)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data;
+	int num_parent = dm_tree_node_num_children(node, 1);
+
+	return dm_report_field_int(rh, field, &num_parent);
+}
 
 static void *_task_get_obj(void *obj)
 {
@@ -1552,9 +1587,15 @@
 	return ((struct dmsetup_report_obj *)obj)->info;
 }
 
+static void *_tree_get_obj(void *obj)
+{
+	return ((struct dmsetup_report_obj *)obj)->tree_node;
+}
+
 static const struct dm_report_object_type _report_types[] = {
 	{ DR_TASK, "Mapped Device Name", "", _task_get_obj },
 	{ DR_INFO, "Mapped Device Information", "", _info_get_obj },
+	{ DR_TREE, "Mapped Device Dependency", "", _tree_get_obj },
 	{ 0, "", "", NULL },
 };
 
@@ -1575,6 +1616,7 @@
 FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open", "Number of references to open device, if requested.")
 FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "segments", "Number of segments in live table, if present.")
 FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "events", "Number of most recent event.")
+FIELD_F(TREE, NUM, "#DevsUsing", 10, dm_tree_parents_count, "devs_using_count", "Number of devices using this one.")
 {0, 0, 0, 0, "", "", NULL, NULL},
 /* *INDENT-ON* */
 };
@@ -1592,7 +1634,6 @@
 	const char *keys = "";
 	const char *separator = " ";
 	int aligned = 1, headings = 1, buffered = 0;
-	uint32_t report_type = 0;
 	uint32_t flags = 0;
 	size_t len = 0;
 	int r = 0;
@@ -1646,10 +1687,15 @@
 	if (headings)
 		flags |= DM_REPORT_OUTPUT_HEADINGS;
 
-	if (!(_report = dm_report_init(&report_type,
-					_report_types, _report_fields,
-					options, separator, flags, keys, NULL)))
+	if (!(_report = dm_report_init(&_report_type,
+				       _report_types, _report_fields,
+				       options, separator, flags, keys, NULL)))
+		goto out;
+
+	if ((_report_type & DR_TREE) && !_build_whole_deptree()) {
+		err("Internal device dependency tree creation failed.");
 		goto out;
+	}
 
 	r = 1;
 
@@ -1669,7 +1715,7 @@
 	    (_switches[EXEC_ARG] && _command))
 		return _status(argc, argv, data);
 	else if ((_switches[TREE_ARG]))
-		return _tree(argc, argv, data);
+		return _display_tree(argc, argv, data);
 	else
 		return _process_all(argc, argv, 0, _display_name);
 }
@@ -2289,5 +2335,8 @@
 		dm_report_free(_report);
 	}
 
+	if (_dtree)
+		dm_tree_free(_dtree);
+
 	return r;
 }
