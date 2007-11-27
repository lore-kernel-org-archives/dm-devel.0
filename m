From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c li ...
Date: 27 Nov 2007 20:57:06 -0000
Message-ID: <20071127205706.24376.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-11-27 20:57:05

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 
	lib            : .exported_symbols libdevmapper.h libdm-common.c 
	                 libdm-deptree.c 
	lib/ioctl      : libdm-iface.c libdm-targets.h 
	man            : dmsetup.8 

Log message:
	add read_ahead functions to library and dmsetup --readahead
	(Not live yet.)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.210&r2=1.211
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.96&r2=1.97
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.31&r2=1.32
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.76&r2=1.77
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.47&r2=1.48
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.32&r2=1.33
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.46&r2=1.47
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-targets.h.diff?cvsroot=dm&r1=1.21&r2=1.22
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.18&r2=1.19

--- device-mapper/WHATS_NEW	2007/11/27 12:26:06	1.210
+++ device-mapper/WHATS_NEW	2007/11/27 20:57:04	1.211
@@ -1,7 +1,8 @@
 Version 1.02.23 - 
 ==================================
-  Fix possible double-free in libdevmapper-event.
-  Define DM_READ_AHEAD_* values and flags.
+  Add --readahead to dmsetup.
+  Add external read_ahead library functions and DM_READ_AHEAD_* definitions.
+  Fix double free in a libdevmapper-event error path.
   Fix configure --with-dmeventd-path substitution.
   Allow $DM_DEV_DIR envvar to override default of "/dev".
   Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
--- device-mapper/dmsetup/dmsetup.c	2007/10/09 12:14:48	1.96
+++ device-mapper/dmsetup/dmsetup.c	2007/11/27 20:57:05	1.97
@@ -120,6 +120,7 @@
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
+	READAHEAD_ARG,
 	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
 	SORT_ARG,
@@ -336,6 +337,8 @@
 	       info->suspended ? "SUSPENDED" : "ACTIVE",
 	       info->read_only ? " (READ-ONLY)" : "");
 
+	printf("Read Ahead:       %d\n", (int) dm_task_get_read_ahead(dmt));
+
 	if (!info->live_table && !info->inactive_table)
 		printf("Tables present:    None\n");
 	else
@@ -494,6 +497,11 @@
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
 
+	/* FIXME Provide way to set read_ahead_flags */
+	if (_switches[READAHEAD_ARG] &&
+	    !dm_task_set_read_ahead(dmt, _int_args[READAHEAD_ARG], 0))
+		goto out;
+
 	if (!dm_task_run(dmt))
 		goto out;
 
@@ -673,6 +681,11 @@
 	if (_switches[NOLOCKFS_ARG] && !dm_task_skip_lockfs(dmt))
 		goto out;
 
+	/* FIXME Provide way to set read_ahead_flags */
+	if (_switches[READAHEAD_ARG] &&
+	    !dm_task_set_read_ahead(dmt, _int_args[READAHEAD_ARG], 0))
+		goto out;
+
 	r = dm_task_run(dmt);
 
 	if (r && display && _switches[VERBOSE_ARG])
@@ -1594,6 +1607,16 @@
 	return dm_report_field_string(rh, field, &uuid);
 }
 
+static int _dm_read_ahead_disp(struct dm_report *rh,
+			       struct dm_pool *mem __attribute((unused)),
+			       struct dm_report_field *field, const void *data,
+			       void *private __attribute((unused)))
+{
+	int32_t value = (int32_t) dm_task_get_read_ahead((const struct dm_task *) data);
+
+	return dm_report_field_int32(rh, field, &value);
+}
+
 static int _dm_info_status_disp(struct dm_report *rh,
 				struct dm_pool *mem __attribute((unused)),
 				struct dm_report_field *field, const void *data,
@@ -1849,6 +1872,10 @@
 /* *INDENT-OFF* */
 FIELD_F(TASK, STR, "Name", 16, dm_name, "name", "Name of mapped device.")
 FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique (optional) identifier for mapped device.")
+
+/* FIXME Next one should be INFO */
+FIELD_F(TASK, NUM, "RAhead", 6, dm_read_ahead, "readahead", "Read ahead in sectors.")
+
 FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "attr", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
 FIELD_F(INFO, STR, "DevNo", 5, dm_info_devno, "devno", "Device major and minor numbers")
 FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Block device major number.")
@@ -2010,7 +2037,8 @@
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
+		"        [-r|--readonly] [--noopencount] [--nolockfs] "
+		    "[--readahead <sectors>]\n"
 		"        [-c|-C|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
 		"        [--noheadings] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
@@ -2374,6 +2402,7 @@
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
+		{"readahead", 1, &ind, READAHEAD_ARG},
 		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
 		{"sort", 1, &ind, SORT_ARG},
@@ -2506,6 +2535,11 @@
 			_switches[NOLOCKFS_ARG]++;
 		if ((ind == NOOPENCOUNT_ARG))
 			_switches[NOOPENCOUNT_ARG]++;
+		/* FIXME Accept auto/none & set read_ahead_flags too */
+		if ((ind == READAHEAD_ARG)) {
+			_switches[READAHEAD_ARG]++;
+			_int_args[READAHEAD_ARG] = atoi(optarg);
+		}
 		if ((ind == SHOWKEYS_ARG))
 			_switches[SHOWKEYS_ARG]++;
 		if ((ind == TABLE_ARG)) {
--- device-mapper/lib/.exported_symbols	2007/07/28 10:48:36	1.31
+++ device-mapper/lib/.exported_symbols	2007/11/27 20:57:05	1.32
@@ -18,6 +18,7 @@
 dm_task_get_names
 dm_task_get_versions
 dm_task_get_uuid
+dm_task_get_read_ahead
 dm_task_set_ro
 dm_task_set_newname
 dm_task_set_event_nr
@@ -28,6 +29,7 @@
 dm_task_set_uid
 dm_task_set_gid
 dm_task_set_mode
+dm_task_set_read_ahead
 dm_task_suppress_identical_reload
 dm_task_add_target
 dm_task_no_flush
@@ -67,6 +69,7 @@
 dm_tree_node_add_mirror_target
 dm_tree_node_add_mirror_target_log
 dm_tree_node_add_target_area
+dm_tree_node_set_read_ahead
 dm_tree_skip_lockfs
 dm_tree_use_no_flush_suspend
 dm_is_dm_major
--- device-mapper/lib/libdevmapper.h	2007/11/12 20:47:18	1.76
+++ device-mapper/lib/libdevmapper.h	2007/11/27 20:57:05	1.77
@@ -141,11 +141,6 @@
 struct dm_names *dm_task_get_names(struct dm_task *dmt);
 struct dm_versions *dm_task_get_versions(struct dm_task *dmt);
 
-#define DM_READ_AHEAD_AUTO UINT32_MAX	/* Use kernel default readahead */
-#define DM_READ_AHEAD_NONE 0		/* Disable readahead */
-
-#define DM_READ_AHEAD_MINIMUM_FLAG	0x1	/* Value supplied is minimum */
-
 int dm_task_set_ro(struct dm_task *dmt);
 int dm_task_set_newname(struct dm_task *dmt, const char *newname);
 int dm_task_set_minor(struct dm_task *dmt, int minor);
@@ -163,6 +158,18 @@
 int dm_task_suppress_identical_reload(struct dm_task *dmt);
 
 /*
+ * Control read_ahead.
+ */
+#define DM_READ_AHEAD_AUTO UINT32_MAX	/* Use kernel default readahead */
+#define DM_READ_AHEAD_NONE 0		/* Disable readahead */
+
+#define DM_READ_AHEAD_MINIMUM_FLAG	0x1	/* Value supplied is minimum */
+
+int dm_task_set_read_ahead(struct dm_task *dmt, uint32_t read_ahead,
+			   uint32_t read_ahead_flags);
+uint32_t dm_task_get_read_ahead(const struct dm_task *dmt);
+
+/*
  * Use these to prepare for a create or reload.
  */
 int dm_task_add_target(struct dm_task *dmt,
@@ -381,6 +388,13 @@
 				    const char *dlid,
 				    uint64_t offset);
 
+/*
+ * Set readahead (in sectors) after loading the node.
+ */
+void dm_tree_node_set_read_ahead(struct dm_tree_node *dnode,
+				 uint32_t read_ahead,
+				 uint32_t read_ahead_flags);
+
 /*****************************************************************************
  * Library functions
  *****************************************************************************/
--- device-mapper/lib/libdm-common.c	2007/10/09 12:14:48	1.47
+++ device-mapper/lib/libdm-common.c	2007/11/27 20:57:05	1.48
@@ -118,6 +118,8 @@
 	dmt->gid = DEVICE_GID;
 	dmt->mode = DEVICE_MODE;
 	dmt->no_open_count = 0;
+	dmt->read_ahead = DM_READ_AHEAD_AUTO;
+	dmt->read_ahead_flags = 0;
 
 	return dmt;
 }
--- device-mapper/lib/libdm-deptree.c	2007/08/21 16:26:06	1.32
+++ device-mapper/lib/libdm-deptree.c	2007/11/27 20:57:05	1.33
@@ -95,6 +95,9 @@
 	uint32_t major;
 	uint32_t minor;
 
+	uint32_t read_ahead;
+	uint32_t read_ahead_flags;
+
 	unsigned segment_count;
 	struct list segs;
 
@@ -609,6 +612,8 @@
 	}
 
 	dnode->props.read_only = read_only ? 1 : 0;
+	dnode->props.read_ahead = DM_READ_AHEAD_AUTO;
+	dnode->props.read_ahead_flags = 0;
 
 	if (clear_inactive && !_node_clear_table(dnode))
 		return_NULL;
@@ -618,6 +623,14 @@
 	return dnode;
 }
 
+void dm_tree_node_set_read_ahead(struct dm_tree_node *dnode,
+				 uint32_t read_ahead,
+				 uint32_t read_ahead_flags)
+{                          
+	dnode->props.read_ahead = read_ahead;
+	dnode->props.read_ahead_flags = read_ahead_flags;
+}
+
 int dm_tree_add_dev(struct dm_tree *dtree, uint32_t major, uint32_t minor)
 {
 	return _add_dev(dtree, &dtree->root, major, minor) ? 1 : 0;
@@ -875,6 +888,7 @@
 
 /* FIXME Merge with _suspend_node? */
 static int _resume_node(const char *name, uint32_t major, uint32_t minor,
+			uint32_t read_ahead, uint32_t read_ahead_flags,
 			struct dm_info *newinfo)
 {
 	struct dm_task *dmt;
@@ -896,6 +910,9 @@
 	if (!dm_task_no_open_count(dmt))
 		log_error("Failed to disable open_count");
 
+	if (!dm_task_set_read_ahead(dmt, read_ahead, read_ahead_flags))
+		log_error("Failed to set read ahead");
+
 	if ((r = dm_task_run(dmt)))
 		r = dm_task_get_info(dmt, newinfo);
 
@@ -1136,7 +1153,9 @@
 			if (!child->info.inactive_table && !child->info.suspended)
 				continue;
 
-			if (!_resume_node(name, child->info.major, child->info.minor, &newinfo)) {
+			if (!_resume_node(name, child->info.major, child->info.minor,
+					  child->props.read_ahead,
+					  child->props.read_ahead_flags, &newinfo)) {
 				log_error("Unable to resume %s (%" PRIu32
 					  ":%" PRIu32 ")", name, child->info.major,
 					  child->info.minor);
@@ -1527,7 +1546,9 @@
 		if (!child->info.inactive_table && !child->info.suspended)
 			continue;
 
-		if (!_resume_node(name, child->info.major, child->info.minor, &newinfo)) {
+		if (!_resume_node(name, child->info.major, child->info.minor,
+				  child->props.read_ahead,
+				  child->props.read_ahead_flags, &newinfo)) {
 			log_error("Unable to resume %s (%" PRIu32
 				  ":%" PRIu32 ")", name, child->info.major,
 				  child->info.minor);
--- device-mapper/lib/ioctl/libdm-iface.c	2007/08/21 16:26:07	1.46
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/11/27 20:57:05	1.47
@@ -920,6 +920,14 @@
 	return 1;
 }
 
+uint32_t dm_task_get_read_ahead(const struct dm_task *dmt)
+{              
+	uint32_t read_ahead = 0; //FIXME default?  How cope with failure below?
+	// FIXME (void) dm_blockdev_get_read_ahead(dmt->dev_name, &read_ahead);
+
+	return read_ahead;
+}
+
 const char *dm_task_get_name(const struct dm_task *dmt)
 {
 #ifdef DM_COMPAT
@@ -974,6 +982,15 @@
 	return 1;
 }
 
+int dm_task_set_read_ahead(struct dm_task *dmt, uint32_t read_ahead,
+			   uint32_t read_ahead_flags)
+{
+	dmt->read_ahead = read_ahead;
+	dmt->read_ahead_flags = read_ahead_flags;
+
+	return 1;
+}
+
 int dm_task_suppress_identical_reload(struct dm_task *dmt)
 {
 	dmt->suppress_identical_reload = 1;
--- device-mapper/lib/ioctl/libdm-targets.h	2007/08/21 16:26:07	1.21
+++ device-mapper/lib/ioctl/libdm-targets.h	2007/11/27 20:57:05	1.22
@@ -44,6 +44,8 @@
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
+	uint32_t read_ahead;
+	uint32_t read_ahead_flags;
 	union {
 		struct dm_ioctl *v4;
 		struct dm_ioctl_v1 *v1;
--- device-mapper/man/dmsetup.8	2007/10/09 12:14:48	1.18
+++ device-mapper/man/dmsetup.8	2007/11/27 20:57:05	1.19
@@ -114,6 +114,9 @@
 .IP \fB-r|--readonly
 .br
 Set the table being loaded read-only.
+.IP \fB--readahead\ <sectors>
+.br    
+Specify read ahead size in units of sectors.
 .IP \fB--table\ <table>
 .br
 Specify a one-line table directly on the command line.
