From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 4/4] dm_queue: add API to libdevmapper
Date: Fri, 23 Jun 2006 17:50:24 -0400 (EDT)
Message-ID: <20060623.175024.39151239.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds the feature to use the kernel fastsuspend feature
to the device-mapper user-space tool.

For dmsetup:
    # dmsetup --fastsuspend suspend <map name>

For library users:
    int dm_task_fastsuspend(struct dm_task *dmt);

This patch is for the latest CVS tree.

Regards,
Kiyoshi Ueda


diff -rup device-mapper.1.02.08.cvs20060623/dmsetup/dmsetup.c fastsusp/dmsetup/dmsetup.c
--- device-mapper.1.02.08.cvs20060623/dmsetup/dmsetup.c	2006-06-23 16:10:31.000000000 -0400
+++ fastsusp/dmsetup/dmsetup.c	2006-06-23 16:22:16.000000000 -0400
@@ -88,6 +88,7 @@ enum {
 	READ_ONLY = 0,
 	COLS_ARG,
 	EXEC_ARG,
+	FASTSUSPEND_ARG,
 	FORCE_ARG,
 	GID_ARG,
 	MAJOR_ARG,
@@ -588,6 +589,9 @@ static int _simple(int task, const char 
 	if (event_nr && !dm_task_set_event_nr(dmt, event_nr))
 		goto out;
 
+	if (_switches[FASTSUSPEND_ARG] && !dm_task_fastsuspend(dmt))
+		goto out;
+
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
 
@@ -1502,7 +1506,8 @@ static void _usage(FILE *out)
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs]\n\n");
+		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
+		"        [--fastsuspend]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
@@ -1601,6 +1606,7 @@ static int _process_switches(int *argc, 
 		{"readonly", 0, &ind, READ_ONLY},
 		{"columns", 0, &ind, COLS_ARG},
 		{"exec", 1, &ind, EXEC_ARG},
+		{"fastsuspend", 0, &ind, FASTSUSPEND_ARG},
 		{"force", 0, &ind, FORCE_ARG},
 		{"gid", 1, &ind, GID_ARG},
 		{"major", 1, &ind, MAJOR_ARG},
@@ -1714,6 +1720,8 @@ static int _process_switches(int *argc, 
 			_switches[TARGET_ARG]++;
 			_target = optarg;
 		}
+		if ((ind == FASTSUSPEND_ARG))
+			_switches[FASTSUSPEND_ARG]++;
 		if ((ind == NOHEADINGS_ARG))
 			_switches[NOHEADINGS_ARG]++;
 		if ((ind == NOLOCKFS_ARG))
diff -rup device-mapper.1.02.08.cvs20060623/kernel/ioctl/dm-ioctl.h fastsusp/kernel/ioctl/dm-ioctl.h
--- device-mapper.1.02.08.cvs20060623/kernel/ioctl/dm-ioctl.h	2006-06-23 16:10:35.000000000 -0400
+++ fastsusp/kernel/ioctl/dm-ioctl.h	2006-06-23 16:34:12.000000000 -0400
@@ -326,4 +326,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_FASTSUSPEND_FLAG	(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
diff -rup device-mapper.1.02.08.cvs20060623/lib/.exported_symbols fastsusp/lib/.exported_symbols
--- device-mapper.1.02.08.cvs20060623/lib/.exported_symbols	2006-06-23 16:10:35.000000000 -0400
+++ fastsusp/lib/.exported_symbols	2006-06-23 16:23:09.000000000 -0400
@@ -28,6 +28,7 @@ dm_task_set_gid
 dm_task_set_mode
 dm_task_suppress_identical_reload
 dm_task_add_target
+dm_task_fastsuspend
 dm_task_no_open_count
 dm_task_skip_lockfs
 dm_task_update_nodes
diff -rup device-mapper.1.02.08.cvs20060623/lib/ioctl/libdm-iface.c fastsusp/lib/ioctl/libdm-iface.c
--- device-mapper.1.02.08.cvs20060623/lib/ioctl/libdm-iface.c	2006-06-23 16:10:34.000000000 -0400
+++ fastsusp/lib/ioctl/libdm-iface.c	2006-06-23 16:24:14.000000000 -0400
@@ -1026,6 +1026,13 @@ int dm_task_set_geometry(struct dm_task 
 	return 1;
 }
 
+int dm_task_fastsuspend(struct dm_task *dmt)
+{
+	dmt->fastsuspend = 1;
+
+	return 1;
+}
+
 int dm_task_no_open_count(struct dm_task *dmt)
 {
 	dmt->no_open_count = 1;
@@ -1270,6 +1277,8 @@ static struct dm_ioctl *_flatten(struct 
 
 	if (dmt->type == DM_DEVICE_SUSPEND)
 		dmi->flags |= DM_SUSPEND_FLAG;
+	if (dmt->fastsuspend)
+		dmi->flags |= DM_FASTSUSPEND_FLAG;
 	if (dmt->read_only)
 		dmi->flags |= DM_READONLY_FLAG;
 	if (dmt->skip_lockfs)
diff -rup device-mapper.1.02.08.cvs20060623/lib/ioctl/libdm-targets.h fastsusp/lib/ioctl/libdm-targets.h
--- device-mapper.1.02.08.cvs20060623/lib/ioctl/libdm-targets.h	2006-06-23 16:10:34.000000000 -0400
+++ fastsusp/lib/ioctl/libdm-targets.h	2006-06-23 16:24:40.000000000 -0400
@@ -52,6 +52,7 @@ struct dm_task {
 	char *message;
 	char *geometry;
 	uint64_t sector;
+	int fastsuspend;
 	int no_open_count;
 	int skip_lockfs;
 	int suppress_identical_reload;
diff -rup device-mapper.1.02.08.cvs20060623/lib/libdevmapper.h fastsusp/lib/libdevmapper.h
--- device-mapper.1.02.08.cvs20060623/lib/libdevmapper.h	2006-06-23 16:10:35.000000000 -0400
+++ fastsusp/lib/libdevmapper.h	2006-06-23 16:25:04.000000000 -0400
@@ -150,6 +150,7 @@ int dm_task_set_event_nr(struct dm_task 
 int dm_task_set_geometry(struct dm_task *dmt, const char *cylinders, const char *heads, const char *sectors, const char *start);
 int dm_task_set_message(struct dm_task *dmt, const char *message);
 int dm_task_set_sector(struct dm_task *dmt, uint64_t sector);
+int dm_task_fastsuspend(struct dm_task *dmt);
 int dm_task_no_open_count(struct dm_task *dmt);
 int dm_task_skip_lockfs(struct dm_task *dmt);
 int dm_task_suppress_identical_reload(struct dm_task *dmt);
