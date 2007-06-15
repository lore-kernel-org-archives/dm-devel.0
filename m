From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 15 Jun 2007 18:20:29 -0000
Message-ID: <20070615182029.12509.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-06-15 18:20:29

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Fix default dmsetup report buffering and add --unbuffered.
	Add tree-based and dependency fields to dmsetup reports.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.184&r2=1.185
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.91&r2=1.92

--- device-mapper/WHATS_NEW	2007/06/11 13:20:28	1.184
+++ device-mapper/WHATS_NEW	2007/06/15 18:20:28	1.185
@@ -1,6 +1,7 @@
 Version 1.02.20 -
 =================================
-  Add capability for tree-based fields to dmsetup reports.
+  Fix default dmsetup report buffering and add --unbuffered.
+  Add tree-based and dependency fields to dmsetup reports.
 
 Version 1.02.19 - 27th April 2007
 =================================
--- device-mapper/dmsetup/dmsetup.c	2007/06/11 13:20:29	1.91
+++ device-mapper/dmsetup/dmsetup.c	2007/06/15 18:20:28	1.92
@@ -90,6 +90,11 @@
 #define ARGS_MAX 256
 #define LOOP_TABLE_SIZE (PATH_MAX + 255)
 
+/* FIXME Should be imported */
+#ifndef DM_MAX_TYPE_NAME
+#  define DM_MAX_TYPE_NAME 16
+#endif
+
 /* FIXME Should be elsewhere */
 #define SECTOR_SHIFT 9L
 #define DEV_PATH "/dev/"
@@ -121,6 +126,7 @@
 	TARGET_ARG,
 	TREE_ARG,
 	UID_ARG,
+	UNBUFFERED_ARG,
 	UUID_ARG,
 	VERBOSE_ARG,
 	VERSION_ARG,
@@ -130,6 +136,7 @@
 typedef enum {
 	DR_TASK = 1,
 	DR_INFO = 2,
+	DR_DEPS = 4,
 	DR_TREE = 8	/* Complete dependency tree required */
 } report_type_t;
 
@@ -247,9 +254,41 @@
 struct dmsetup_report_obj {
 	struct dm_task *task;
 	struct dm_info *info;
+	struct dm_task *deps_task;
 	struct dm_tree_node *tree_node;
 };
 
+static struct dm_task *_get_deps_task(int major, int minor)
+{
+	struct dm_task *dmt;
+	struct dm_info info;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_DEPS)))
+		return NULL;
+
+	if (!dm_task_set_major(dmt, major) ||
+	    !dm_task_set_minor(dmt, minor))
+		goto err;
+
+	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
+		goto err;
+
+	if (!dm_task_run(dmt))
+		goto err;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto err;
+
+	if (!info.exists)
+		goto err;
+
+	return dmt;
+
+      err:
+	dm_task_destroy(dmt);
+	return NULL;
+}
+
 static int _display_info_cols(struct dm_task *dmt, struct dm_info *info)
 {
 	struct dmsetup_report_obj obj;
@@ -262,16 +301,22 @@
 
 	obj.task = dmt;
 	obj.info = info;
+	obj.deps_task = NULL;
 
 	if (_report_type & DR_TREE)
 		obj.tree_node = dm_tree_find_node(_dtree, info->major, info->minor);
 
+	if (_report_type & DR_DEPS)
+		obj.deps_task = _get_deps_task(info->major, info->minor);
+
 	if (!dm_report_object(_report, &obj))
 		goto out;
 
 	r = 1;
 
       out:
+	if (obj.deps_task)
+		dm_task_destroy(obj.deps_task);
 	return r;
 }
 
@@ -1566,6 +1611,149 @@
 	return dm_report_field_string(rh, field, &s);
 }
 
+static int _dm_info_devno_disp(struct dm_report *rh, struct dm_pool *mem,
+			       struct dm_report_field *field, const void *data,
+			       void *private)
+{
+	char buf[DM_MAX_TYPE_NAME], *repstr;
+	struct dm_info *info = (struct dm_info *) data;
+
+	if (!dm_pool_begin_object(mem, 8)) {
+		log_error("dm_pool_begin_object failed");
+		return 0;
+	}
+
+	if (dm_snprintf(buf, sizeof(buf), "%d:%d",
+			info->major, info->minor) < 0) {
+		log_error("dm_pool_alloc failed");
+		goto out_abandon;
+	}
+
+	if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+		log_error("dm_pool_grow_object failed");
+		goto out_abandon;
+	}
+
+	repstr = dm_pool_end_object(mem);
+	dm_report_field_set_value(field, repstr, repstr);
+	return 1;
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
+static int _dm_tree_names(struct dm_report *rh, struct dm_pool *mem,
+			  struct dm_report_field *field, const void *data,
+			  void *private, unsigned inverted)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data, *parent;
+	void *t = NULL;
+	const char *name;
+	int first_node = 1;
+	char *repstr;
+
+	if (!dm_pool_begin_object(mem, 16)) {
+		log_error("dm_pool_begin_object failed");
+		return 0;
+	}
+
+	while ((parent = dm_tree_next_child(&t, node, inverted))) {
+		name = dm_tree_node_get_name(parent);
+		if (!name || !*name)
+			continue;
+		if (!first_node && !dm_pool_grow_object(mem, ",", 1)) {
+			log_error("dm_pool_grow_object failed");
+			goto out_abandon;
+		}
+		if (!dm_pool_grow_object(mem, name, strlen(name))) {
+			log_error("dm_pool_grow_object failed");
+			goto out_abandon;
+		}
+		if (first_node)
+			first_node = 0;
+	}
+
+	if (!dm_pool_grow_object(mem, "\0", 1)) {
+		log_error("dm_pool_grow_object failed");
+		goto out_abandon;
+	}
+
+	repstr = dm_pool_end_object(mem);
+	dm_report_field_set_value(field, repstr, repstr);
+	return 1;
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
+static int _dm_deps_names_disp(struct dm_report *rh,
+				      struct dm_pool *mem,
+				      struct dm_report_field *field,
+				      const void *data, void *private)
+{
+	return _dm_tree_names(rh, mem, field, data, private, 0);
+}
+
+static int _dm_tree_parents_names_disp(struct dm_report *rh,
+				       struct dm_pool *mem,
+				       struct dm_report_field *field,
+				       const void *data, void *private)
+{
+	return _dm_tree_names(rh, mem, field, data, private, 1);
+}
+
+static int _dm_tree_parents_devs_disp(struct dm_report *rh, struct dm_pool *mem,
+				      struct dm_report_field *field,
+				      const void *data, void *private)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data, *parent;
+	void *t = NULL;
+	const struct dm_info *info;
+	int first_node = 1;
+	char buf[DM_MAX_TYPE_NAME], *repstr;
+
+	if (!dm_pool_begin_object(mem, 16)) {
+		log_error("dm_pool_begin_object failed");
+		return 0;
+	}
+
+	while ((parent = dm_tree_next_child(&t, node, 1))) {
+		info = dm_tree_node_get_info(parent);
+		if (!info->major && !info->minor)
+			continue;
+		if (!first_node && !dm_pool_grow_object(mem, ",", 1)) {
+			log_error("dm_pool_grow_object failed");
+			goto out_abandon;
+		}
+		if (dm_snprintf(buf, sizeof(buf), "%d:%d",
+				info->major, info->minor) < 0) {
+			log_error("dm_snprintf failed");
+			goto out_abandon;
+		}
+		if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+			log_error("dm_pool_grow_object failed");
+			goto out_abandon;
+		}
+		if (first_node)
+			first_node = 0;
+	}
+
+	if (!dm_pool_grow_object(mem, "\0", 1)) {
+		log_error("dm_pool_grow_object failed");
+		goto out_abandon;
+	}
+
+	repstr = dm_pool_end_object(mem);
+	dm_report_field_set_value(field, repstr, repstr);
+	return 1;
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
 static int _dm_tree_parents_count_disp(struct dm_report *rh,
 				       struct dm_pool *mem,
 				       struct dm_report_field *field,
@@ -1577,6 +1765,50 @@
 	return dm_report_field_int(rh, field, &num_parent);
 }
 
+static int _dm_deps_disp(struct dm_report *rh, struct dm_pool *mem,
+			 struct dm_report_field *field, const void *data,
+			 void *private)
+{
+	struct dm_deps *deps = (struct dm_deps *) data;
+	int i;
+	char buf[DM_MAX_TYPE_NAME], *repstr;
+
+	if (!dm_pool_begin_object(mem, 16)) {
+		log_error("dm_pool_begin_object failed");
+		return 0;
+	}
+
+	for (i = 0; i < deps->count; i++) {
+		if (dm_snprintf(buf, sizeof(buf), "%d:%d",
+		       (int) MAJOR(deps->device[i]),
+		       (int) MINOR(deps->device[i])) < 0) {
+			log_error("dm_snprintf failed");
+			goto out_abandon;
+		}
+		if (!dm_pool_grow_object(mem, buf, strlen(buf))) {
+			log_error("dm_pool_grow_object failed");
+			goto out_abandon;
+		}
+		if (i + 1 < deps->count && !dm_pool_grow_object(mem, ",", 1)) {
+			log_error("dm_pool_grow_object failed");
+			goto out_abandon;
+		}
+	}
+
+	if (!dm_pool_grow_object(mem, "\0", 1)) {
+		log_error("dm_pool_grow_object failed");
+		goto out_abandon;
+	}
+
+	repstr = dm_pool_end_object(mem);
+	dm_report_field_set_value(field, repstr, repstr);
+	return 1;
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
 static void *_task_get_obj(void *obj)
 {
 	return ((struct dmsetup_report_obj *)obj)->task;
@@ -1587,6 +1819,11 @@
 	return ((struct dmsetup_report_obj *)obj)->info;
 }
 
+static void *_deps_get_obj(void *obj)
+{
+	return dm_task_get_deps(((struct dmsetup_report_obj *)obj)->deps_task);
+}
+
 static void *_tree_get_obj(void *obj)
 {
 	return ((struct dmsetup_report_obj *)obj)->tree_node;
@@ -1595,7 +1832,8 @@
 static const struct dm_report_object_type _report_types[] = {
 	{ DR_TASK, "Mapped Device Name", "", _task_get_obj },
 	{ DR_INFO, "Mapped Device Information", "", _info_get_obj },
-	{ DR_TREE, "Mapped Device Dependency", "", _tree_get_obj },
+	{ DR_DEPS, "Mapped Device Relationship Information", "", _deps_get_obj },
+	{ DR_TREE, "Mapped Device Relationship Information", "", _tree_get_obj },
 	{ 0, "", "", NULL },
 };
 
@@ -1611,12 +1849,20 @@
 FIELD_F(TASK, STR, "Name", 16, dm_name, "name", "Name of mapped device.")
 FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique (optional) identifier for mapped device.")
 FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "attr", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
+FIELD_F(INFO, STR, "DevNo", 5, dm_info_devno, "devno", "Device major and minor numbers")
 FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Block device major number.")
 FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Block device minor number.")
 FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open", "Number of references to open device, if requested.")
 FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "segments", "Number of segments in live table, if present.")
 FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "events", "Number of most recent event.")
-FIELD_F(TREE, NUM, "#DevsUsing", 10, dm_tree_parents_count, "devs_using_count", "Number of devices using this one.")
+
+FIELD_O(DEPS, dm_deps, NUM, "#Devs", count, 5, int32, "device_count", "Number of devices used by this one.")
+FIELD_F(TREE, STR, "DevNames", 8, dm_deps_names, "devs_used", "List of names of mapped devices used by this one.")
+FIELD_F(DEPS, STR, "DevNos", 6, dm_deps, "devnos_used", "List of device numbers of devices used by this one.")
+
+FIELD_F(TREE, NUM, "#Refs", 5, dm_tree_parents_count, "device_ref_count", "Number of mapped devices referencing this one.")
+FIELD_F(TREE, STR, "RefNames", 8, dm_tree_parents_names, "names_using_dev", "List of names of mapped devices using this one.")
+FIELD_F(TREE, STR, "RefDevNos", 9, dm_tree_parents_devs, "devnos_using_dev", "List of device numbers of mapped devices using this one.")
 {0, 0, 0, 0, "", "", NULL, NULL},
 /* *INDENT-ON* */
 };
@@ -1633,7 +1879,7 @@
 	char *options = (char *) default_report_options;
 	const char *keys = "";
 	const char *separator = " ";
-	int aligned = 1, headings = 1, buffered = 0;
+	int aligned = 1, headings = 1, buffered = 1;
 	uint32_t flags = 0;
 	size_t len = 0;
 	int r = 0;
@@ -1645,6 +1891,9 @@
 		headings = 0;
 	}
 
+	if (_switches[UNBUFFERED_ARG])
+		buffered = 0;
+
 	if (_switches[OPTIONS_ARG] && _string_args[OPTIONS_ARG]) {
 		if (*_string_args[OPTIONS_ARG] != '+')
 			options = _string_args[OPTIONS_ARG];
@@ -2125,6 +2374,7 @@
 		{"tree", 0, &ind, TREE_ARG},
 		{"uid", 1, &ind, UID_ARG},
 		{"uuid", 1, &ind, UUID_ARG},
+		{"unbuffered", 0, &ind, UNBUFFERED_ARG},
 		{"verbose", 1, &ind, VERBOSE_ARG},
 		{"version", 0, &ind, VERSION_ARG},
 		{0, 0, 0, 0}
@@ -2256,6 +2506,8 @@
 		}
 		if ((ind == TREE_ARG))
 			_switches[TREE_ARG]++;
+		if ((ind == UNBUFFERED_ARG))
+			_switches[UNBUFFERED_ARG]++;
 		if ((ind == VERSION_ARG))
 			_switches[VERSION_ARG]++;
 	}
