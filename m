From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] (2/4) dmsetup info to use dm_report
Date: Fri, 12 Jan 2007 18:31:45 -0500
Message-ID: <45A81A61.4070401@ce.jp.nec.com>
References: <45A81618.2080608@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060301010606060801070304"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45A81618.2080608@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060301010606060801070304
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch makes "dmsetup info -c" to use dm_report
in libdevmapper.

For example, to see what maps are overlaying on each map,

  # dmsetup info -c -o name,parents_count,parent_maps -O name
  Name               Parents Parent Maps
  B8-root                  0
  B9-root                  0
  d1                       2 testvg-m1_mimage_0,testvg-lvol2
  d2                       2 testvg-m1_mimage_1,testvg-lvol2
  d3                       1 testvg-lvol0-real
  d4                       2 testvg-lvol2,testvg-lvol0-real
  d5                       1 testvg-lvol1-cow
  d6                       1 testvg-lvol2
  d7                       1 testvg-m1_mlog
  testvg-lvol0             0
  testvg-lvol0-real        2 testvg-lvol1,testvg-lvol0
  testvg-lvol1             0
  testvg-lvol1-cow         1 testvg-lvol1
  testvg-lvol2             0
  testvg-m1                0
  testvg-m1_mimage_0       1 testvg-m1
  testvg-m1_mimage_1       1 testvg-m1
  testvg-m1_mlog           1 testvg-m1

Then, to see the top level map names,
  # dmsetup info -c -o name,-parents_count=0 --noheadings
  B9-root
  testvg-m1
  testvg-lvol2
  testvg-lvol1
  testvg-lvol0
  B8-root

Output of "dmsetup info -c" is basically same as the former version
except for a few spacing difference, which should be harmless.
  - Field width is correctly aligned (e.g. in case of long map name)
  - Trailing space is added to fill the width
    (same behaviour as LVM2 lvs/pvs/vgs)

Thanks,
--
Jun'ichi Nomura, NEC Corporation of America

--------------060301010606060801070304
Content-Type: text/x-patch;
 name="02-dmsetup-report.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-dmsetup-report.patch"

Extend "dmsetup info -c -o" using dm_report API.
New options "-O" and "--seprator" are also added.

  Usage:
    dmsetup info -c -o <field1>[,<field2>...] \
                   [-O <field>[,<field>...]
                   [--separator <string>]

Combination of the following field name is allowed:
    name
    device
    major
    minor
    uuid
    status
    open_count
    target_count
    event_nr
    deps
    deps_count
    parents
    parents_count
    parent_maps

Examples:

If you have the following dm tree:
    # dmsetup ls --tree -o inverted
     (7:0)
     |-d4 (254:6)
     |  |-testvg-lvol2 (254:17)
     |  `-testvg-lvol0-real (254:15)
     |     |-testvg-lvol1 (254:14)
     |     `-testvg-lvol0 (254:13)
     |-d1 (254:3)
     |  |-testvg-m1_mimage_0 (254:10)
     |  |  `-testvg-m1 (254:12)
     |  `-testvg-lvol2 (254:17)
     |-d3 (254:5)
     |  `-testvg-lvol0-real (254:15)
     |     |-testvg-lvol1 (254:14)
     |     `-testvg-lvol0 (254:13)
     |-d2 (254:4)
     |  |-testvg-m1_mimage_1 (254:11)
     |  |  `-testvg-m1 (254:12)
     |  `-testvg-lvol2 (254:17)
     |-d7 (254:9)
     |  `-testvg-m1_mlog (254:0)
     |     `-testvg-m1 (254:12)
     |-d6 (254:8)
     |  `-testvg-lvol2 (254:17)
     `-d5 (254:7)
        `-testvg-lvol1-cow (254:16)
           `-testvg-lvol1 (254:14)
     (8:48)
     `-asr_HOSTRAID1 (254:18)
        |-asr_HOSTRAID15 (254:22)
        |-asr_HOSTRAID13 (254:21)
        |-asr_HOSTRAID12 (254:20)
        `-asr_HOSTRAID11 (254:19)
     (8:32)
     `-asr_HOSTRAID1 (254:18)
        |-asr_HOSTRAID15 (254:22)
        |-asr_HOSTRAID13 (254:21)
        |-asr_HOSTRAID12 (254:20)
        `-asr_HOSTRAID11 (254:19)

To obtain the sorted list of the maps which have no parent maps:
    # dmsetup info -c -o 'name,-parents_count=0' --noheadings -O name
    asr_HOSTRAID11     
    asr_HOSTRAID12     
    asr_HOSTRAID13     
    asr_HOSTRAID15     
    testvg-lvol0       
    testvg-lvol1       
    testvg-lvol2       
    testvg-m1          


Output of "dmsetup info -c" is basically same as the former version
except for a few spacing difference, which should be harmless.
  - Field width is correctly aligned (e.g. in case of long map name)
  - Trailing space is added to fill the width
    (same behaviour as LVM2 lvs/pvs/vgs)


Index: device-mapper/dmsetup/dmsetup.c
===================================================================
--- device-mapper.orig/dmsetup/dmsetup.c	2007-01-12 16:50:37.000000000 -0500
+++ device-mapper/dmsetup/dmsetup.c	2007-01-12 17:03:45.000000000 -0500
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc. All rights reserved.
- * Copyright (C) 2005 NEC Corperation
+ * Copyright (C) 2004-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2005-2007 NEC Corperation
  *
  * This file is part of the device-mapper userspace tools.
  *
@@ -114,7 +114,9 @@ enum {
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
+	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
+	SORTKEYS_ARG,
 	TABLE_ARG,
 	TARGET_ARG,
 	TREE_ARG,
@@ -129,11 +131,12 @@ static int _switches[NUM_SWITCHES];
 static int _values[NUM_SWITCHES];
 static int _num_devices;
 static char *_uuid;
-static char *_fields;
+static char *_fields[NUM_SWITCHES];
 static char *_table;
 static char *_target;
 static char *_command;
 static struct dm_tree *_dtree;
+static struct dm_report *_rhandle;
 
 /*
  * Commands
@@ -322,6 +325,8 @@ static void _display_info_long(struct dm
 	printf("\n");
 }
 
+static int _report(int argc, char **argv, void *data);
+
 static int _display_info(struct dm_task *dmt)
 {
 	struct dm_info info;
@@ -1056,6 +1061,12 @@ static int _info(int argc, char **argv, 
 	struct dm_names *names = (struct dm_names *) data;
 	char *name = NULL;
 
+	/*
+	 * Using reporter function
+	 */
+	if (_switches[COLS_ARG])
+		return _report(argc, argv, data);
+
 	if (data)
 		name = names->name;
 	else {
@@ -1506,6 +1517,414 @@ static int _ls(int argc, char **argv, vo
 		return _process_all(argc, argv, 0, _display_name);
 }
 
+
+/*
+ * Report device information
+ */
+
+/* dm specific display functions */
+
+static int _dm_name_disp(struct dm_report *rh, struct dm_pool *mem,
+			 struct dm_report_field *field, const void *data)
+{
+	const char *name = dm_task_get_name((struct dm_task *) data);
+
+	return dm_report_field_string(rh, mem, field, &name);
+}
+
+static int _dm_uuid_disp(struct dm_report *rh, struct dm_pool *mem,
+			 struct dm_report_field *field,
+			 const void *data)
+{
+	const char *uuid = dm_task_get_uuid((struct dm_task *) data);
+
+	if (!uuid || !*uuid)
+		uuid = "";
+
+	return dm_report_field_string(rh, mem, field, &uuid);
+}
+
+static int _dm_info_status_disp(struct dm_report *rh, struct dm_pool *mem,
+				struct dm_report_field *field, const void *data)
+{
+	char buf[5], *s = buf;
+	struct dm_info *info = (struct dm_info *) data;
+
+	buf[0] = info->live_table ? 'L' : '-';
+	buf[1] = info->inactive_table ? 'I' : '-';
+	buf[2] = info->suspended ? 's' : '-';
+	buf[3] = info->read_only ? 'r' : 'w';
+	buf[4] = 0;
+
+	return dm_report_field_string(rh, mem, field, &s);
+}
+
+#define MAJ_MIN_LEN 32
+
+static int _dm_info_device_disp(struct dm_report *rh, struct dm_pool *mem,
+				struct dm_report_field *field, const void *data)
+{
+	char *repstr;
+	struct dm_info *info = (struct dm_info *) data;
+
+	if (!(repstr = dm_pool_zalloc(mem, MAJ_MIN_LEN))) {
+		log_error("dm_pool_alloc failed");
+		return 0;
+	}
+
+	if (dm_snprintf(repstr, MAJ_MIN_LEN, "%d:%d",
+			info->major, info->minor) < 0) {
+		dm_pool_free(mem, repstr);
+		log_error("dm_pool_alloc failed");
+		return 0;
+	}
+
+	return dm_report_field_raw(rh, mem, field, repstr);
+}
+
+static int _dm_tree_parent_maps_disp(struct dm_report *rh,
+				     struct dm_pool *mem,
+				     struct dm_report_field *field,
+				     const void *data)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data, *parent;
+	void *t = NULL;
+	const char *name;
+	int first_node = 1;
+	char *repstr;
+
+	if (!dm_pool_begin_object(mem, 256)) {
+		log_error("dm_pool_begin_object failed");
+		return 0;
+	}
+
+	while ((parent = dm_tree_next_child(&t, node, 1))) {
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
+	return dm_report_field_raw(rh, mem, field, repstr);
+
+	return 1;
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
+static int _dm_tree_parents_disp(struct dm_report *rh, struct dm_pool *mem,
+				 struct dm_report_field *field,
+				 const void *data)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data, *parent;
+	void *t = NULL;
+	const struct dm_info *info;
+	int first_node = 1;
+	char buf[MAJ_MIN_LEN], *repstr;
+
+	if (!dm_pool_begin_object(mem, 256)) {
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
+		if (dm_snprintf(buf, MAJ_MIN_LEN, "%d:%d",
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
+	return dm_report_field_raw(rh, mem, field, repstr);
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
+static int _dm_tree_parents_count_disp(struct dm_report *rh,
+				       struct dm_pool *mem,
+				       struct dm_report_field *field,
+				       const void *data)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data;
+	int num_parent = dm_tree_node_num_children(node, 1);
+
+	return dm_report_field_int(rh, mem, field, &num_parent);
+}
+
+static int _dm_deps_disp(struct dm_report *rh, struct dm_pool *mem,
+			 struct dm_report_field *field, const void *data)
+{
+	struct dm_deps *deps = (struct dm_deps *) data;
+	int i;
+	char buf[MAJ_MIN_LEN], *repstr;
+
+	if (!dm_pool_begin_object(mem, 256)) {
+		log_error("dm_pool_begin_object failed");
+		return 0;
+	}
+
+	for (i = 0; i < deps->count; i++) {
+		if (dm_snprintf(buf, sizeof(buf) - 1, "%d:%d",
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
+	return dm_report_field_raw(rh, mem, field, repstr);
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
+/* Report object types */
+
+#define DESC1 "Device Mapper Device"
+#define DESC2 "Dependency"
+#define PREFIX "dm_"
+enum { DR_TASK = 1, DR_INFO = 2, DR_DEPS = 4, DR_TREE = 8 };
+
+struct dmsetup_report_obj {
+	struct dm_task *task;
+	struct dm_info *info;
+	struct dm_tree_node *tree;
+};
+
+static void *_task_get_obj(void *obj)
+{
+	return ((struct dmsetup_report_obj *)obj)->task;
+}
+
+static void *_info_get_obj(void *obj)
+{
+	return ((struct dmsetup_report_obj *)obj)->info;
+}
+
+static void *_tree_get_obj(void *obj)
+{
+	return ((struct dmsetup_report_obj *)obj)->tree;
+}
+
+static void *_deps_get_obj(void *obj)
+{
+	struct dm_task *dmt;
+
+	if (!(dmt = _task_get_obj((struct dmsetup_report_obj *)obj)))
+		return NULL;
+
+	return dm_task_get_deps(dmt);
+}
+
+static const struct dm_report_object_type _report_types[] = {
+	{ DR_TASK, DESC1, PREFIX, _task_get_obj },
+	{ DR_INFO, DESC1, PREFIX, _info_get_obj },
+	{ DR_DEPS, DESC2, PREFIX, _deps_get_obj },
+	{ DR_TREE, DESC2, PREFIX, _tree_get_obj },
+};
+
+/* Column definitions */
+static union {
+	struct dm_info _dm_info;
+	struct dm_deps _dm_deps;
+} _dummy;
+
+#define OFFSET_OF(struct, field) ((unsigned int) ((void *)&_dummy._ ## struct.field - (void *)&_dummy._ ## struct))
+#define STR (DM_REPORT_FIELD_STRING | DM_REPORT_FIELD_ALIGN_LEFT)
+#define NUM (DM_REPORT_FIELD_NUMBER | DM_REPORT_FIELD_ALIGN_RIGHT)
+#define FIELD_O(type, strct, sorttype, head, field, width, func, id) {DR_ ## type, id, OFFSET_OF(strct, field), head, width, sorttype, &dm_report_field_ ## func},
+#define FIELD_F(type, sorttype, head, width, func, id) {DR_ ## type, id, 0, head, width, sorttype, &_ ## func ## _disp},
+
+static const struct dm_report_field_type _report_fields[] = {
+/* *INDENT-OFF* */
+FIELD_F(TASK, STR, "Name", 16, dm_name, "name")
+FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid")
+FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "status")
+FIELD_F(INFO, STR, "Device", 6, dm_info_device, "device")
+FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major")
+FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor")
+FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open_count")
+FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "target_count")
+FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "event_nr")
+FIELD_O(DEPS, dm_deps, NUM, "Deps", count, 4, int32, "deps_count")
+FIELD_F(DEPS, STR, "Depend on", 10, dm_deps, "deps")
+FIELD_F(TREE, STR, "Parent Devices", 16, dm_tree_parents, "parents")
+FIELD_F(TREE, STR, "Parent Maps", 12, dm_tree_parent_maps, "parent_maps")
+FIELD_F(TREE, NUM, "Parents", 7, dm_tree_parents_count, "parents_count")
+/* *INDENT-ON* */
+};
+
+#undef STR
+#undef NUM
+#undef FIELD_O
+#undef FIELD_F
+
+static const char *default_report_options = "name,major,minor,status,open_count,target_count,event_nr,uuid";
+static unsigned int _num_report_fields = sizeof(_report_fields) / sizeof(_report_fields[0]);
+static unsigned int _num_report_types = sizeof(_report_types) / sizeof(_report_types[0]);
+
+static int _do_report(int argc, char **argv, void *data)
+{
+	const char *name = NULL;
+	struct dm_task *dmt;
+	struct dm_info info;
+	int r = 0;
+	struct dmsetup_report_obj obj;
+
+	if (data) {
+		if (argc == 0)
+			name = dm_task_get_name((struct dm_task *)data);
+		else
+			name = ((struct dm_names *)data)->name;
+	} else {
+		if (argc == 1)
+			return _process_all(argc, argv, 0, _report);
+		if (argc == 2)
+			name = argv[1];
+	}
+
+	if (!(dmt = dm_task_create(DM_DEVICE_DEPS)))
+		return 0;
+
+	if (!_set_task_device(dmt, name, 0))
+		goto out;
+
+	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto out;
+
+	obj.task = dmt;
+	obj.info = &info;
+	obj.tree = dm_tree_find_node(_dtree, info.major, info.minor);
+	dm_report_object(_rhandle, &obj);
+
+	r = 1;
+
+      out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
+static int _report(int argc, char **argv, void *data)
+{
+	char *options = (char *) default_report_options;
+	const char *keys = "";
+	const char *separator = " ";
+	int aligned = 1, buffered = 1;
+	int headings = !_switches[NOHEADINGS_ARG];
+	uint32_t report_type = 0;
+
+	if (_rhandle)
+		return _do_report(argc, argv, data);
+
+	if (!(_dtree = dm_tree_create()))
+		return 0;
+	if (!_process_all(argc, argv, 0, _add_dep))
+		return 0;
+
+	if (_switches[OPTIONS_ARG] && _fields[OPTIONS_ARG]) {
+		if (*_fields[OPTIONS_ARG] == '+') {
+			int len = strlen(default_report_options) +
+				  strlen(_fields[OPTIONS_ARG]);
+			if (!(options = dm_malloc(len))) {
+				err("Failed to malloc option string.");
+				return 0;
+			}
+			if (dm_snprintf(options, len, "%s,%s",
+					default_report_options,
+					&_fields[OPTIONS_ARG][1]) < 0) {
+				err("snprintf failed");
+				return 0;
+			}
+		} else
+			options = _fields[OPTIONS_ARG];
+	}
+	if (_switches[SORTKEYS_ARG] && _fields[SORTKEYS_ARG])
+		keys = _fields[SORTKEYS_ARG];
+	if (_switches[SEPARATOR_ARG] && _fields[SEPARATOR_ARG]) {
+		separator = _fields[SEPARATOR_ARG];
+		aligned = 0;
+	}
+
+	if (!(_rhandle = dm_report_init(options, keys, &report_type,
+					separator, aligned, buffered, headings,
+					_report_fields, _num_report_fields,
+					_report_types, _num_report_types,
+					NULL)))
+		return 0;
+
+	_do_report(argc, argv, data);
+
+	dm_report_output(_rhandle);
+	dm_report_free(_rhandle);
+	_rhandle = NULL;
+
+	if (_dtree) {
+		dm_tree_free(_dtree);
+		_dtree = NULL;
+	}
+
+	return 1;
+}
+
 /*
  * dispatch table
  */
@@ -1884,7 +2303,9 @@ static int _process_switches(int *argc, 
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
+		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
+		{"sortkeys", 1, &ind, SORTKEYS_ARG},
 		{"table", 1, &ind, TABLE_ARG},
 		{"target", 1, &ind, TARGET_ARG},
 		{"tree", 0, &ind, TREE_ARG},
@@ -1914,7 +2335,7 @@ static int _process_switches(int *argc, 
 		_switches[OPTIONS_ARG]++;
 		_switches[MAJOR_ARG]++;
 		_switches[MINOR_ARG]++;
-		_fields = (char *) "name";
+		_fields[OPTIONS_ARG] = (char *) "name";
 
 		if (*argc == 3) {
 			_values[MAJOR_ARG] = atoi((*argv)[1]);
@@ -1946,7 +2367,7 @@ static int _process_switches(int *argc, 
 
 	optarg = 0;
 	optind = OPTIND_INIT;
-	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfGj:m:Mno:ru:Uv",
+	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfGj:m:Mno:O:ru:Uv",
 					    long_options, NULL)) != -1) {
 		if (c == ':' || c == '?')
 			return 0;
@@ -1968,7 +2389,15 @@ static int _process_switches(int *argc, 
 			_switches[NOTABLE_ARG]++;
 		if (c == 'o' || ind == OPTIONS_ARG) {
 			_switches[OPTIONS_ARG]++;
-			_fields = optarg;
+			_fields[OPTIONS_ARG] = optarg;
+		}
+		if (ind == SEPARATOR_ARG) {
+			_switches[SEPARATOR_ARG]++;
+			_fields[SEPARATOR_ARG] = optarg;
+		}
+		if (c == 'O' || ind == SORTKEYS_ARG) {
+			_switches[SORTKEYS_ARG]++;
+			_fields[SORTKEYS_ARG] = optarg;
 		}
 		if (c == 'v' || ind == VERBOSE_ARG)
 			_switches[VERBOSE_ARG]++;
@@ -2027,13 +2456,7 @@ static int _process_switches(int *argc, 
 		return 0;
 	}
 
-	if (_switches[COLS_ARG] && _switches[OPTIONS_ARG] &&
-	    strcmp(_fields, "name")) {
-		fprintf(stderr, "Only -o name is supported so far.\n");
-		return 0;
-	}
-
-	if (_switches[TREE_ARG] && !_process_tree_options(_fields))
+	if (_switches[TREE_ARG] && !_process_tree_options(_fields[OPTIONS_ARG]))
 		return 0;
 
 	if (_switches[TABLE_ARG] && _switches[NOTABLE_ARG]) {

--------------060301010606060801070304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060301010606060801070304--
