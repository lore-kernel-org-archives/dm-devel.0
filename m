From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/4] dm_queue: add API to libdevmapper (take 2)
Date: Mon, 10 Jul 2006 18:36:50 -0400 (EDT)
Message-ID: <20060710.183650.98855191.k-ueda@ct.jp.nec.com>
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

This patch adds the feature to use the kernel noflush suspend feature
to the device-mapper user-space tool.

For dmsetup:
    # dmsetup --noflush suspend <map name>

For library users:
    int dm_task_no_flush(struct dm_task *dmt);

This patch is for the CVS tree on July 7, 2006.

Regards,
Kiyoshi Ueda


diff -rup device-mapper.1.02.08.cvs20060707/dmsetup/dmsetup.c noflush/dmsetup/dmsetup.c
--- device-mapper.1.02.08.cvs20060707/dmsetup/dmsetup.c	2006-06-18 07:51:46.000000000 -0400
+++ noflush/dmsetup/dmsetup.c	2006-07-07 15:44:00.000000000 -0400
@@ -93,6 +93,7 @@ enum {
 	MAJOR_ARG,
 	MINOR_ARG,
 	MODE_ARG,
+	NOFLUSH_ARG,
 	NOHEADINGS_ARG,
 	NOLOCKFS_ARG,
 	NOOPENCOUNT_ARG,
@@ -588,6 +589,9 @@ static int _simple(int task, const char 
 	if (event_nr && !dm_task_set_event_nr(dmt, event_nr))
 		goto out;
 
+	if (_switches[NOFLUSH_ARG] && !dm_task_no_flush(dmt))
+		goto out;
+
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
 
@@ -1502,7 +1506,8 @@ static void _usage(FILE *out)
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs]\n\n");
+		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
+		"        [--noflush]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
@@ -1606,6 +1611,7 @@ static int _process_switches(int *argc, 
 		{"major", 1, &ind, MAJOR_ARG},
 		{"minor", 1, &ind, MINOR_ARG},
 		{"mode", 1, &ind, MODE_ARG},
+		{"noflush", 0, &ind, NOFLUSH_ARG},
 		{"noheadings", 0, &ind, NOHEADINGS_ARG},
 		{"nolockfs", 0, &ind, NOLOCKFS_ARG},
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
@@ -1714,6 +1720,8 @@ static int _process_switches(int *argc, 
 			_switches[TARGET_ARG]++;
 			_target = optarg;
 		}
+		if ((ind == NOFLUSH_ARG))
+			_switches[NOFLUSH_ARG]++;
 		if ((ind == NOHEADINGS_ARG))
 			_switches[NOHEADINGS_ARG]++;
 		if ((ind == NOLOCKFS_ARG))
diff -rup device-mapper.1.02.08.cvs20060707/kernel/ioctl/dm-ioctl.h noflush/kernel/ioctl/dm-ioctl.h
--- device-mapper.1.02.08.cvs20060707/kernel/ioctl/dm-ioctl.h	2006-02-20 18:55:57.000000000 -0500
+++ noflush/kernel/ioctl/dm-ioctl.h	2006-07-07 15:44:29.000000000 -0400
@@ -326,4 +326,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_NOFLUSH_FLAG		(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
diff -rup device-mapper.1.02.08.cvs20060707/lib/.exported_symbols noflush/lib/.exported_symbols
--- device-mapper.1.02.08.cvs20060707/lib/.exported_symbols	2006-02-20 18:55:58.000000000 -0500
+++ noflush/lib/.exported_symbols	2006-07-07 15:41:56.000000000 -0400
@@ -28,6 +28,7 @@ dm_task_set_gid
 dm_task_set_mode
 dm_task_suppress_identical_reload
 dm_task_add_target
+dm_task_no_flush
 dm_task_no_open_count
 dm_task_skip_lockfs
 dm_task_update_nodes
diff -rup device-mapper.1.02.08.cvs20060707/lib/ioctl/libdm-iface.c noflush/lib/ioctl/libdm-iface.c
--- device-mapper.1.02.08.cvs20060707/lib/ioctl/libdm-iface.c	2006-06-14 18:00:03.000000000 -0400
+++ noflush/lib/ioctl/libdm-iface.c	2006-07-07 15:41:56.000000000 -0400
@@ -1026,6 +1026,13 @@ int dm_task_set_geometry(struct dm_task 
 	return 1;
 }
 
+int dm_task_no_flush(struct dm_task *dmt)
+{
+	dmt->noflush = 1;
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
+	if (dmt->noflush)
+		dmi->flags |= DM_NOFLUSH_FLAG;
 	if (dmt->read_only)
 		dmi->flags |= DM_READONLY_FLAG;
 	if (dmt->skip_lockfs)
diff -rup device-mapper.1.02.08.cvs20060707/lib/ioctl/libdm-targets.h noflush/lib/ioctl/libdm-targets.h
--- device-mapper.1.02.08.cvs20060707/lib/ioctl/libdm-targets.h	2006-02-20 18:55:58.000000000 -0500
+++ noflush/lib/ioctl/libdm-targets.h	2006-07-07 15:41:56.000000000 -0400
@@ -52,6 +52,7 @@ struct dm_task {
 	char *message;
 	char *geometry;
 	uint64_t sector;
+	int noflush;
 	int no_open_count;
 	int skip_lockfs;
 	int suppress_identical_reload;
diff -rup device-mapper.1.02.08.cvs20060707/lib/libdevmapper.h noflush/lib/libdevmapper.h
--- device-mapper.1.02.08.cvs20060707/lib/libdevmapper.h	2006-05-11 15:10:55.000000000 -0400
+++ noflush/lib/libdevmapper.h	2006-07-07 15:41:56.000000000 -0400
@@ -150,6 +150,7 @@ int dm_task_set_event_nr(struct dm_task 
 int dm_task_set_geometry(struct dm_task *dmt, const char *cylinders, const char *heads, const char *sectors, const char *start);
 int dm_task_set_message(struct dm_task *dmt, const char *message);
 int dm_task_set_sector(struct dm_task *dmt, uint64_t sector);
+int dm_task_no_flush(struct dm_task *dmt);
 int dm_task_no_open_count(struct dm_task *dmt);
 int dm_task_skip_lockfs(struct dm_task *dmt);
 int dm_task_suppress_identical_reload(struct dm_task *dmt);
