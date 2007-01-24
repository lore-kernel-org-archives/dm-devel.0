From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 24 Jan 2007 18:09:07 -0000
Message-ID: <20070124180907.4949.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-24 18:09:07

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Migrate dmsetup column-based output over to new libdevmapper report framework.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.158&r2=1.159
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.78&r2=1.79

--- device-mapper/WHATS_NEW	2007/01/23 19:18:52	1.158
+++ device-mapper/WHATS_NEW	2007/01/24 18:09:06	1.159
@@ -1,5 +1,6 @@
 Version 1.02.16 -
 ===================================
+  Migrate dmsetup column-based output over to new libdevmapper report framework.
   Add descriptions to reporting field definitions.
   Add a dso-private variable to dmeventd dso interface.
   Add dm_event_handler_[gs]et_timeout functions.
--- device-mapper/dmsetup/dmsetup.c	2007/01/22 15:03:57	1.78
+++ device-mapper/dmsetup/dmsetup.c	2007/01/24 18:09:07	1.79
@@ -136,10 +136,22 @@
 static char *_target;
 static char *_command;
 static struct dm_tree *_dtree;
+static struct dm_report *_report;
 
 /*
  * Commands
  */
+
+typedef int (*command_fn) (int argc, char **argv, void *data);
+
+struct command {
+	const char *name;
+	const char *help;
+	int min_args;
+	int max_args;
+	command_fn fn;
+};
+
 static int _parse_line(struct dm_task *dmt, char *buffer, const char *file,
 		       int line)
 {
@@ -224,66 +236,27 @@
 	return r;
 }
 
-static void _display_info_cols_noheadings(struct dm_task *dmt,
-					  struct dm_info *info)
-{
-	const char *uuid;
-
-	if (!info->exists)
-		return;
-
-	uuid = dm_task_get_uuid(dmt);
-
-	if (_switches[OPTIONS_ARG])
-		printf("%s\n", dm_task_get_name(dmt));
-	else
-		printf("%s:%d:%d:%s%s%s%s:%d:%d:%" PRIu32 ":%s\n",
-		       dm_task_get_name(dmt),
-		       info->major, info->minor,
-		       info->live_table ? "L" : "-",
-		       info->inactive_table ? "I" : "-",
-		       info->suspended ? "s" : "-",
-		       info->read_only ? "r" : "w",
-		       info->open_count, info->target_count, info->event_nr,
-		       uuid && *uuid ? uuid : "");
-}
+struct dmsetup_report_obj {
+	struct dm_task *task;
+	struct dm_info *info;
+};
 
-static void _display_info_cols(struct dm_task *dmt, struct dm_info *info)
+static int _display_info_cols(struct dm_task *dmt, struct dm_info *info)
 {
-	static int _headings = 0;
-	const char *uuid;
+	struct dmsetup_report_obj obj;
 
 	if (!info->exists) {
-		printf("Device does not exist.\n");
-		return;
-	}
-
-	if (!_headings) {
-		if (_switches[OPTIONS_ARG])
-			printf("Name\n");
-		else
-			printf("Name             Maj Min Stat Open Targ "
-			       "Event  UUID\n");
-		_headings = 1;
+		fprintf(stderr, "Device does not exist.\n");
+		return 0;
 	}
 
-	if (_switches[OPTIONS_ARG])
-		printf("%s\n", dm_task_get_name(dmt));
-	else {
-		printf("%-16s %3d %3d %s%s%s%s %4d %4d %6" PRIu32 " ",
-		       dm_task_get_name(dmt),
-		       info->major, info->minor,
-		       info->live_table ? "L" : "-",
-		       info->inactive_table ? "I" : "-",
-		       info->suspended ? "s" : "-",
-		       info->read_only ? "r" : "w",
-		       info->open_count, info->target_count, info->event_nr);
+	obj.task = dmt;
+	obj.info = info;
 
-		if ((uuid = dm_task_get_uuid(dmt)) && *uuid)
-			printf("%s", uuid);
+	if (!dm_report_object(_report, &obj))
+		return 0;
 
-		printf("\n");
-	}
+	return 1;
 }
 
 static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
@@ -333,9 +306,8 @@
 
 	if (!_switches[COLS_ARG])
 		_display_info_long(dmt, &info);
-	else if (_switches[NOHEADINGS_ARG])
-		_display_info_cols_noheadings(dmt, &info);
 	else
+		/* FIXME return code */
 		_display_info_cols(dmt, &info);
 
 	return info.exists ? 1 : 0;
@@ -1499,6 +1471,194 @@
 }
 
 /*
+ * Report device information
+ */
+
+/* dm specific display functions */
+
+static int _int32_disp(struct dm_report *rh,
+		       struct dm_pool *mem __attribute((unused)),
+		       struct dm_report_field *field, const void *data,
+		       void *private)
+{
+	const int32_t value = *(const int32_t *)data;
+
+	return dm_report_field_int32(rh, field, &value);
+}
+
+static int _uint32_disp(struct dm_report *rh,
+			struct dm_pool *mem __attribute((unused)),
+		        struct dm_report_field *field, const void *data,
+		        void *private)
+{
+	const uint32_t value = *(const int32_t *)data;
+
+	return dm_report_field_uint32(rh, field, &value);
+}
+
+static int _dm_name_disp(struct dm_report *rh,
+			 struct dm_pool *mem __attribute((unused)),
+			 struct dm_report_field *field, const void *data,
+			 void *private)
+{
+	const char *name = dm_task_get_name((struct dm_task *) data);
+
+	return dm_report_field_string(rh, field, &name);
+}
+
+static int _dm_uuid_disp(struct dm_report *rh,
+			 struct dm_pool *mem __attribute((unused)),
+			 struct dm_report_field *field,
+			 const void *data, void *private)
+{
+	const char *uuid = dm_task_get_uuid((struct dm_task *) data);
+
+	if (!uuid || !*uuid)
+		uuid = "";
+
+	return dm_report_field_string(rh, field, &uuid);
+}
+
+static int _dm_info_status_disp(struct dm_report *rh,
+				struct dm_pool *mem __attribute((unused)),
+				struct dm_report_field *field, const void *data,
+				void *private)
+{
+	char buf[5];
+	const char *s = buf;
+	struct dm_info *info = (struct dm_info *) data;
+
+	buf[0] = info->live_table ? 'L' : '-';
+	buf[1] = info->inactive_table ? 'I' : '-';
+	buf[2] = info->suspended ? 's' : '-';
+	buf[3] = info->read_only ? 'r' : 'w';
+	buf[4] = '\0';
+
+	return dm_report_field_string(rh, field, &s);
+}
+
+/* Report types */
+enum { DR_TASK = 1, DR_INFO = 2 };
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
+static const struct dm_report_object_type _report_types[] = {
+	{ DR_TASK, "Mapped Device Name", "", _task_get_obj },
+	{ DR_INFO, "Mapped Device Information", "", _info_get_obj },
+	{ 0, "", "", NULL },
+};
+
+/* Column definitions */
+#define OFFSET_OF(strct, field) ((unsigned int) &((struct strct *)NULL)->field)
+#define STR (DM_REPORT_FIELD_TYPE_STRING)
+#define NUM (DM_REPORT_FIELD_TYPE_NUMBER)
+#define FIELD_O(type, strct, sorttype, head, field, width, func, id, desc) {DR_ ## type, id, OFFSET_OF(strct, field), head, width, sorttype, &_ ## func ## _disp, desc},
+#define FIELD_F(type, sorttype, head, width, func, id, desc) {DR_ ## type, id, 0, head, width, sorttype, &_ ## func ## _disp, desc},
+
+static const struct dm_report_field_type _report_fields[] = {
+/* *INDENT-OFF* */
+FIELD_F(TASK, STR, "Name", 16, dm_name, "name", "Name of mapped device.")
+FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique identifier for mapped device (optional).")
+FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "status", "Attributes.")
+FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Major number.")
+FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Minor number.")
+FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open_count", "Number of references to open device, if requested.")
+FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "target_count", "Number of segments in live table, if present.")
+FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "event_nr", "Current event number.")
+{0, "", 0, "", 0, 0, NULL, NULL},
+/* *INDENT-ON* */
+};
+
+#undef STR
+#undef NUM
+#undef FIELD_O
+#undef FIELD_F
+
+static const char *default_report_options = "name,major,minor,status,open_count,target_count,event_nr,uuid";
+
+static int _report_init(struct command *c)
+{
+	char *options = (char *) default_report_options;
+	const char *keys = "";
+	const char *separator = " ";
+	int aligned = 1, headings = 1, buffered = 0;
+	uint32_t report_type = 0;
+	uint32_t flags = 0;
+	size_t len = 0;
+	int r = 0;
+
+	/* emulate old dmsetup behaviour */
+	if (_switches[NOHEADINGS_ARG]) {
+		separator = ":";
+		aligned = 0;
+		headings = 0;
+	}
+
+	if (_switches[OPTIONS_ARG] && _string_args[OPTIONS_ARG]) {
+		if (*_string_args[OPTIONS_ARG] != '+')
+			options = _string_args[OPTIONS_ARG];
+		else {
+			len = strlen(default_report_options) +
+			      strlen(_string_args[OPTIONS_ARG]);
+			if (!(options = dm_malloc(len))) {
+				err("Failed to allocate option string.");
+				return 0;
+			}
+			if (dm_snprintf(options, len, "%s,%s",
+					default_report_options,
+					&_string_args[OPTIONS_ARG][1]) < 0) {
+				err("snprintf failed");
+				goto out;
+			}
+		}
+	}
+
+	if (_switches[SORT_ARG] && _string_args[SORT_ARG]) {
+		keys = _string_args[SORT_ARG];
+		buffered = 1;
+		if (!strcmp(c->name, "status") || !strcmp(c->name, "table")) {
+			err("--sort is not yet supported with status and table");
+			goto out;
+		}
+	}
+
+	if (_switches[SEPARATOR_ARG] && _string_args[SEPARATOR_ARG]) {
+		separator = _string_args[SEPARATOR_ARG];
+		aligned = 0;
+	}
+
+	if (aligned)
+		flags |= DM_REPORT_OUTPUT_ALIGNED;
+
+	if (buffered)
+		flags |= DM_REPORT_OUTPUT_BUFFERED;
+
+	if (headings)
+		flags |= DM_REPORT_OUTPUT_HEADINGS;
+
+	if (!(_report = dm_report_init(&report_type,
+					_report_types, _report_fields,
+					options, separator, flags, keys, NULL)))
+		goto out;
+
+	r = 1;
+
+out:
+	if (len)
+		dm_free(options);
+
+	return r;
+}
+
+/*
  * List devices
  */
 static int _ls(int argc, char **argv, void *data)
@@ -1513,18 +1673,8 @@
 }
 
 /*
- * dispatch table
+ * Dispatch table
  */
-typedef int (*command_fn) (int argc, char **argv, void *data);
-
-struct command {
-	const char *name;
-	const char *help;
-	int min_args;
-	int max_args;
-	command_fn fn;
-};
-
 static struct command _commands[] = {
 	{"create", "<dev_name> [-j|--major <major> -m|--minor <minor>]\n"
 	  "\t                  [-U|--uid <uid>] [-G|--gid <gid>] [-M|--mode <octal_mode>]\n"
@@ -2044,12 +2194,6 @@
 		return 0;
 	}
 
-	if (_switches[COLS_ARG] && _switches[OPTIONS_ARG] &&
-	    strcmp(_string_args[OPTIONS_ARG], "name")) {
-		fprintf(stderr, "Only -o name is supported so far.\n");
-		return 0;
-	}
-
 	if (_switches[TREE_ARG] && !_process_tree_options(_string_args[OPTIONS_ARG]))
 		return 0;
 
@@ -2098,6 +2242,9 @@
 		goto out;
 	}
 
+	if (_switches[COLS_ARG] && !_report_init(c))
+		goto out;
+
       doit:
 	if (!c->fn(argc, argv, NULL)) {
 		fprintf(stderr, "Command failed\n");
@@ -2107,5 +2254,10 @@
 	r = 0;
 
 out:
+	if (_report) {
+		dm_report_output(_report);
+		dm_report_free(_report);
+	}
+
 	return r;
 }
