From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (6/6) Add deps and treenode fields
 for dmsetup info -c
Date: Wed, 18 Apr 2007 12:47:53 -0400
Message-ID: <46264BB9.2060206@ce.jp.nec.com>
References: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000301080704010103040208"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46264A57.1020800@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000301080704010103040208
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

This patch adds optional fields to 'dmsetup info -c'.
You can specify the following fields with '-o', '-O' and filtering option.
  - deps
  - deps_count
  - parents
  - parents_count

For example, you can find the top-level dm devices by:
  # dmsetup info -c -o name --filter 'parents_count == 0'

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------000301080704010103040208
Content-Type: text/x-patch;
 name="dmsetup-info-add-deps-columns.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmsetup-info-add-deps-columns.patch"

Add fields of deps and treenode to dmsetup

---
 dmsetup/dmsetup.c |  283 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 276 insertions(+), 7 deletions(-)

Index: device-mapper.work/dmsetup/dmsetup.c
===================================================================
--- device-mapper.work.orig/dmsetup/dmsetup.c
+++ device-mapper.work/dmsetup/dmsetup.c
@@ -241,11 +241,14 @@ static int _parse_file(struct dm_task *d
 struct dmsetup_report_obj {
 	struct dm_task *task;
 	struct dm_info *info;
+	struct dm_task *deps;
+	struct dm_tree_node *tree;
 };
 
 static int _display_info_cols(struct dm_task *dmt, struct dm_info *info)
 {
 	struct dmsetup_report_obj obj;
+	int r = 0;
 
 	if (!info->exists) {
 		fprintf(stderr, "Device does not exist.\n");
@@ -254,11 +257,18 @@ static int _display_info_cols(struct dm_
 
 	obj.task = dmt;
 	obj.info = info;
+	obj.deps = NULL; /* task is created later on demand */
+	obj.tree = NULL; /* deptree is created later on demand */
 
 	if (!dm_report_object(_report, &obj))
-		return 0;
+		goto out;
 
-	return 1;
+	r = 1;
+
+      out:
+	if (obj.deps)
+		dm_task_destroy(obj.deps);
+	return r;
 }
 
 static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
@@ -1457,17 +1467,26 @@ static int _add_dep(int argc __attribute
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
+
+static int _tree(int argc, char **argv, void *data __attribute((unused)))
+{
+	if (!_build_whole_deptree())
+		return 0;
 
-	dm_tree_free(_dtree);
+	_tree_walk_children(dm_tree_find_node(_dtree, 0, 0), 0);
 
 	return 1;
 }
@@ -1539,8 +1558,193 @@ static int _dm_info_status_disp(struct d
 	return dm_report_field_string(rh, field, &s);
 }
 
+#define MAJ_MIN_LEN 32
+
+static int _dm_info_device_disp(struct dm_report *rh, struct dm_pool *mem,
+				struct dm_report_field *field, const void *data,
+				void *private)
+{
+	char buf[MAJ_MIN_LEN], *repstr;
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
+static int _dm_tree_parent_maps_disp(struct dm_report *rh,
+				     struct dm_pool *mem,
+				     struct dm_report_field *field,
+				     const void *data, void *private)
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
+	dm_report_field_set_value(field, repstr, repstr);
+	return 1;
+
+      out_abandon:
+	dm_pool_abandon_object(mem);
+	return 0;
+}
+
+static int _dm_tree_parents_disp(struct dm_report *rh, struct dm_pool *mem,
+				 struct dm_report_field *field,
+				 const void *data, void *private)
+{
+	struct dm_tree_node *node = (struct dm_tree_node *) data, *parent;
+	void *t = NULL;
+	const struct dm_info *info;
+	int first_node = 1;
+	char buf[MAJ_MIN_LEN], *repstr;
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
+
+static int _dm_deps_disp(struct dm_report *rh, struct dm_pool *mem,
+			 struct dm_report_field *field, const void *data,
+			 void *private)
+{
+	struct dm_deps *deps = (struct dm_deps *) data;
+	int i;
+	char buf[MAJ_MIN_LEN], *repstr;
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
 /* Report types */
-enum { DR_TASK = 1, DR_INFO = 2 };
+enum { DR_TASK = 1, DR_INFO = 2, DR_DEPS = 4, DR_TREE = 8 };
 
 static void *_task_get_obj(void *obj)
 {
@@ -1552,9 +1756,65 @@ static void *_info_get_obj(void *obj)
 	return ((struct dmsetup_report_obj *)obj)->info;
 }
 
+static void *_tree_get_obj(void *obj)
+{
+	struct dmsetup_report_obj *o = (struct dmsetup_report_obj *) obj;
+	struct dm_info *info;
+
+	if (o->tree)
+		return o->tree;
+
+	if (!_build_whole_deptree())
+		return NULL;
+
+	if (!(info = _info_get_obj(o)))
+		return NULL;
+
+	o->tree = dm_tree_find_node(_dtree, info->major, info->minor);
+	return o->tree;
+}
+
+static void *_deps_get_obj(void *obj)
+{
+	struct dmsetup_report_obj *o = (struct dmsetup_report_obj *) obj;
+	struct dm_task *dmt;
+	const char *name;
+
+	if (o->deps)
+		return dm_task_get_deps(o->deps);
+
+	/* name */
+	if (!(dmt = _task_get_obj(o)))
+		return NULL;
+	if (!(name = dm_task_get_name(dmt)))
+		return NULL;
+
+	/* deps */
+	if (!(dmt = dm_task_create(DM_DEVICE_DEPS)))
+		return NULL;
+
+	if (!dm_task_set_name(dmt, name))
+		goto out;
+
+	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	o->deps = dmt;
+	return dm_task_get_deps(dmt);
+
+      out:
+	dm_task_destroy(dmt);
+	return NULL;
+}
+
 static const struct dm_report_object_type _report_types[] = {
 	{ DR_TASK, "Mapped Device Name", "", _task_get_obj },
 	{ DR_INFO, "Mapped Device Information", "", _info_get_obj },
+	{ DR_DEPS, "Mapped Device Dependency", "", _deps_get_obj },
+	{ DR_TREE, "Mapped Device Dependency", "", _tree_get_obj },
 	{ 0, "", "", NULL },
 };
 
@@ -1570,11 +1830,17 @@ static const struct dm_report_field_type
 FIELD_F(TASK, STR, "Name", 16, dm_name, "name", "Name of mapped device.")
 FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique (optional) identifier for mapped device.")
 FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "attr", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
+FIELD_F(INFO, STR, "Device", 6, dm_info_device, "device", "Device major and minor numbers")
 FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Block device major number.")
 FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Block device minor number.")
 FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open", "Number of references to open device, if requested.")
 FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "segments", "Number of segments in live table, if present.")
 FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "events", "Number of most recent event.")
+FIELD_O(DEPS, dm_deps, NUM, "Deps", count, 4, int32, "deps_count", "Number of underlying devices")
+FIELD_F(DEPS, STR, "Depend on", 10, dm_deps, "deps", "List of underlying devic es")
+FIELD_F(TREE, STR, "Parent Devices", 16, dm_tree_parents, "parents", "List of overlaying devices")
+FIELD_F(TREE, STR, "Parent Maps", 12, dm_tree_parent_maps, "parent_maps", "List of overlaying maps")
+FIELD_F(TREE, NUM, "Parents", 7, dm_tree_parents_count, "parents_count", "Number of overlaying devices")
 {0, 0, 0, 0, "", "", NULL, NULL},
 /* *INDENT-ON* */
 };
@@ -2300,5 +2566,8 @@ out:
 		dm_report_free(_report);
 	}
 
+	if (_dtree)
+		dm_tree_free(_dtree);
+
 	return r;
 }

--------------000301080704010103040208
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000301080704010103040208--
