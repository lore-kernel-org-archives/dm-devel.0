From: agk@sourceware.org
Subject: device-mapper dmsetup/dmsetup.c lib/libdevmapp ...
Date: 30 Nov 2007 14:59:58 -0000
Message-ID: <20071130145958.32760.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-11-30 14:59:58

Modified files:
	dmsetup        : dmsetup.c 
	lib            : libdevmapper.h libdm-common.c libdm-common.h 
	lib/ioctl      : libdm-iface.c 

Log message:
	read_ahead node ops

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.98&r2=1.99
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.77&r2=1.78
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.48&r2=1.49
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.h.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.47&r2=1.48

--- device-mapper/dmsetup/dmsetup.c	2007/11/29 14:44:28	1.98
+++ device-mapper/dmsetup/dmsetup.c	2007/11/30 14:59:57	1.99
@@ -326,6 +326,7 @@
 static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
 {
 	const char *uuid;
+	uint32_t read_ahead;
 
 	if (!info->exists) {
 		printf("Device does not exist.\n");
@@ -338,7 +339,8 @@
 	       info->suspended ? "SUSPENDED" : "ACTIVE",
 	       info->read_only ? " (READ-ONLY)" : "");
 
-	printf("Read Ahead:       %d\n", (int) dm_task_get_read_ahead(dmt));
+	if (dm_task_get_read_ahead(dmt, &read_ahead))
+		printf("Read Ahead:       %" PRIu32 "\n", read_ahead);
 
 	if (!info->live_table && !info->inactive_table)
 		printf("Tables present:    None\n");
@@ -1613,9 +1615,12 @@
 			       struct dm_report_field *field, const void *data,
 			       void *private __attribute((unused)))
 {
-	int32_t value = (int32_t) dm_task_get_read_ahead((const struct dm_task *) data);
+	uint32_t value;
 
-	return dm_report_field_int32(rh, field, &value);
+	if (!dm_task_get_read_ahead((const struct dm_task *) data, &value))
+		value = 0;
+
+	return dm_report_field_uint32(rh, field, &value);
 }
 
 static int _dm_info_status_disp(struct dm_report *rh,
--- device-mapper/lib/libdevmapper.h	2007/11/27 20:57:05	1.77
+++ device-mapper/lib/libdevmapper.h	2007/11/30 14:59:57	1.78
@@ -167,7 +167,8 @@
 
 int dm_task_set_read_ahead(struct dm_task *dmt, uint32_t read_ahead,
 			   uint32_t read_ahead_flags);
-uint32_t dm_task_get_read_ahead(const struct dm_task *dmt);
+uint32_t dm_task_get_read_ahead(const struct dm_task *dmt,
+				uint32_t *read_ahead);
 
 /*
  * Use these to prepare for a create or reload.
--- device-mapper/lib/libdm-common.c	2007/11/27 20:57:05	1.48
+++ device-mapper/lib/libdm-common.c	2007/11/30 14:59:57	1.49
@@ -356,15 +356,55 @@
 	return 1;
 }
 
+int get_dev_node_read_ahead(const char *dev_name, uint32_t *read_ahead)
+{
+	*read_ahead = 0;
+
+	return 1;
+}
+
+static int _set_read_ahead(const char *dev_name, uint32_t read_ahead)
+{
+	return 1;
+}
+
+static int _set_dev_node_read_ahead(const char *dev_name, uint32_t read_ahead,
+				    uint32_t read_ahead_flags)
+{
+	uint32_t current_read_ahead;
+
+	if (read_ahead == DM_READ_AHEAD_AUTO)
+		return 1;
+
+	if (read_ahead == DM_READ_AHEAD_NONE)
+		read_ahead = 0;
+
+	if (read_ahead_flags & DM_READ_AHEAD_MINIMUM_FLAG) {
+		if (!get_dev_node_read_ahead(dev_name, &current_read_ahead))
+			return_0;
+
+		if (current_read_ahead > read_ahead) {
+			log_debug("%s: read ahead %" PRIu32
+				  " below minimum of %" PRIu32,
+				  dev_name, current_read_ahead, read_ahead);
+			return 1;
+		}
+	}
+
+	return _set_read_ahead(dev_name, read_ahead);
+}
+
 typedef enum {
 	NODE_ADD,
 	NODE_DEL,
-	NODE_RENAME
+	NODE_RENAME,
+	NODE_READ_AHEAD
 } node_op_t;
 
 static int _do_node_op(node_op_t type, const char *dev_name, uint32_t major,
 		       uint32_t minor, uid_t uid, gid_t gid, mode_t mode,
-		       const char *old_name)
+		       const char *old_name, uint32_t read_ahead,
+		       uint32_t read_ahead_flags)
 {
 	switch (type) {
 	case NODE_ADD:
@@ -373,6 +413,9 @@
 		return _rm_dev_node(dev_name);
 	case NODE_RENAME:
 		return _rename_dev_node(old_name, dev_name);
+	case NODE_READ_AHEAD:
+		return _set_dev_node_read_ahead(dev_name, read_ahead,
+						read_ahead_flags);
 	}
 
 	return 1;
@@ -389,6 +432,8 @@
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
+	uint32_t read_ahead;
+	uint32_t read_ahead_flags;
 	char *old_name;
 	char names[0];
 };
@@ -402,7 +447,8 @@
 
 static int _stack_node_op(node_op_t type, const char *dev_name, uint32_t major,
 			  uint32_t minor, uid_t uid, gid_t gid, mode_t mode,
-			  const char *old_name)
+			  const char *old_name, uint32_t read_ahead,
+			  uint32_t read_ahead_flags)
 {
 	struct node_op_parms *nop;
 	size_t len = strlen(dev_name) + strlen(old_name) + 2;
@@ -420,6 +466,8 @@
 	nop->uid = uid;
 	nop->gid = gid;
 	nop->mode = mode;
+	nop->read_ahead = read_ahead;
+	nop->read_ahead_flags = read_ahead_flags;
 
 	_store_str(&pos, &nop->dev_name, dev_name);
 	_store_str(&pos, &nop->old_name, old_name);
@@ -437,7 +485,8 @@
 	list_iterate_safe(noph, nopht, &_node_ops) {
 		nop = list_item(noph, struct node_op_parms);
 		_do_node_op(nop->type, nop->dev_name, nop->major, nop->minor,
-			    nop->uid, nop->gid, nop->mode, nop->old_name);
+			    nop->uid, nop->gid, nop->mode, nop->old_name,
+			    nop->read_ahead, nop->read_ahead_flags);
 		list_del(&nop->list);
 		dm_free(nop);
 	}
@@ -447,17 +496,28 @@
 		 uid_t uid, gid_t gid, mode_t mode)
 {
 	return _stack_node_op(NODE_ADD, dev_name, major, minor, uid, gid, mode,
-			      "");
+			      "", 0, 0);
 }
 
 int rename_dev_node(const char *old_name, const char *new_name)
 {
-	return _stack_node_op(NODE_RENAME, new_name, 0, 0, 0, 0, 0, old_name);
+	return _stack_node_op(NODE_RENAME, new_name, 0, 0, 0, 0, 0, old_name,
+			      0, 0);
 }
 
 int rm_dev_node(const char *dev_name)
 {
-	return _stack_node_op(NODE_DEL, dev_name, 0, 0, 0, 0, 0, "");
+	return _stack_node_op(NODE_DEL, dev_name, 0, 0, 0, 0, 0, "", 0, 0);
+}
+
+int set_dev_node_read_ahead(const char *dev_name, uint32_t read_ahead,
+			    uint32_t read_ahead_flags)
+{
+	if (read_ahead == DM_READ_AHEAD_AUTO)
+		return 1;
+
+	return _stack_node_op(NODE_READ_AHEAD, dev_name, 0, 0, 0, 0, 0, "",
+			      read_ahead, read_ahead_flags);
 }
 
 void update_devs(void)
--- device-mapper/lib/libdm-common.h	2007/08/21 16:26:06	1.4
+++ device-mapper/lib/libdm-common.h	2007/11/30 14:59:57	1.5
@@ -26,6 +26,9 @@
 		 uid_t uid, gid_t gid, mode_t mode);
 int rm_dev_node(const char *dev_name);
 int rename_dev_node(const char *old_name, const char *new_name);
+int get_dev_node_read_ahead(const char *dev_name, uint32_t *read_ahead);
+int set_dev_node_read_ahead(const char *dev_name, uint32_t read_ahead,
+			    uint32_t read_ahead_flags);
 void update_devs(void);
 
 #endif
--- device-mapper/lib/ioctl/libdm-iface.c	2007/11/27 20:57:05	1.47
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/11/30 14:59:57	1.48
@@ -920,12 +920,9 @@
 	return 1;
 }
 
-uint32_t dm_task_get_read_ahead(const struct dm_task *dmt)
+uint32_t dm_task_get_read_ahead(const struct dm_task *dmt, uint32_t *read_ahead)
 {              
-	uint32_t read_ahead = 0; //FIXME default?  How cope with failure below?
-	// FIXME (void) dm_blockdev_get_read_ahead(dmt->dev_name, &read_ahead);
-
-	return read_ahead;
+	return get_dev_node_read_ahead(dmt->dev_name, read_ahead);
 }
 
 const char *dm_task_get_name(const struct dm_task *dmt)
@@ -1685,6 +1682,11 @@
 			rename_dev_node(dmt->dev_name, dmt->newname);
 		break;
 
+	case DM_DEVICE_RESUME:
+		set_dev_node_read_ahead(dmi->name, dmt->read_ahead,
+					dmt->read_ahead_flags);
+		break;
+	
 	case DM_DEVICE_MKNODES:
 		if (dmi->flags & DM_EXISTS_FLAG)
 			add_dev_node(dmi->name, MAJOR(dmi->dev),
