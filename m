From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-ioctl: introduce ioctl_flags
Date: Mon, 14 Jan 2013 23:21:01 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1301142320240.11994@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-ioctl: introduce ioctl_flags

This patch introduces flags for each ioctl function.
So far, one flag is defined, IOCTL_FLAGS_NO_PARAMS, it means that the
function doesn't take or produce any parameters.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   56 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

Index: linux-3.8-rc3-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.8-rc3-fast.orig/drivers/md/dm-ioctl.c	2013-01-11 04:02:27.000000000 +0100
+++ linux-3.8-rc3-fast/drivers/md/dm-ioctl.c	2013-01-11 04:02:34.000000000 +0100
@@ -1516,39 +1516,46 @@ static int target_message(struct dm_ioct
 	return r;
 }
 
+#define IOCTL_FLAGS_NO_PARAMS	1
+
 /*-----------------------------------------------------------------
  * Implementation of open/close/ioctl on the special char
  * device.
  *---------------------------------------------------------------*/
-static ioctl_fn lookup_ioctl(unsigned int cmd)
+static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 {
 	static struct {
 		int cmd;
+		int flags;
 		ioctl_fn fn;
 	} _ioctls[] = {
-		{DM_VERSION_CMD, NULL},	/* version is dealt with elsewhere */
-		{DM_REMOVE_ALL_CMD, remove_all},
-		{DM_LIST_DEVICES_CMD, list_devices},
-
-		{DM_DEV_CREATE_CMD, dev_create},
-		{DM_DEV_REMOVE_CMD, dev_remove},
-		{DM_DEV_RENAME_CMD, dev_rename},
-		{DM_DEV_SUSPEND_CMD, dev_suspend},
-		{DM_DEV_STATUS_CMD, dev_status},
-		{DM_DEV_WAIT_CMD, dev_wait},
-
-		{DM_TABLE_LOAD_CMD, table_load},
-		{DM_TABLE_CLEAR_CMD, table_clear},
-		{DM_TABLE_DEPS_CMD, table_deps},
-		{DM_TABLE_STATUS_CMD, table_status},
+		{DM_VERSION_CMD, 0, NULL}, /* version is dealt with elsewhere */
+		{DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS, remove_all},
+		{DM_LIST_DEVICES_CMD, 0, list_devices},
+
+		{DM_DEV_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS, dev_create},
+		{DM_DEV_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS, dev_remove},
+		{DM_DEV_RENAME_CMD, 0, dev_rename},
+		{DM_DEV_SUSPEND_CMD, IOCTL_FLAGS_NO_PARAMS, dev_suspend},
+		{DM_DEV_STATUS_CMD, IOCTL_FLAGS_NO_PARAMS, dev_status},
+		{DM_DEV_WAIT_CMD, 0, dev_wait},
+
+		{DM_TABLE_LOAD_CMD, 0, table_load},
+		{DM_TABLE_CLEAR_CMD, IOCTL_FLAGS_NO_PARAMS, table_clear},
+		{DM_TABLE_DEPS_CMD, 0, table_deps},
+		{DM_TABLE_STATUS_CMD, 0, table_status},
 
-		{DM_LIST_VERSIONS_CMD, list_versions},
+		{DM_LIST_VERSIONS_CMD, 0, list_versions},
 
-		{DM_TARGET_MSG_CMD, target_message},
-		{DM_DEV_SET_GEOMETRY_CMD, dev_set_geometry}
+		{DM_TARGET_MSG_CMD, 0, target_message},
+		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry}
 	};
 
-	return (cmd >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[cmd].fn;
+	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
+		return NULL;
+
+	*ioctl_flags = _ioctls[cmd].flags;
+	return _ioctls[cmd].fn;
 }
 
 /*
@@ -1690,6 +1697,7 @@ static int validate_params(uint cmd, str
 static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 {
 	int r = 0;
+	int ioctl_flags;
 	int param_flags;
 	unsigned int cmd;
 	struct dm_ioctl *uninitialized_var(param);
@@ -1719,7 +1727,7 @@ static int ctl_ioctl(uint command, struc
 	if (cmd == DM_VERSION_CMD)
 		return 0;
 
-	fn = lookup_ioctl(cmd);
+	fn = lookup_ioctl(cmd, &ioctl_flags);
 	if (!fn) {
 		DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
 		return -ENOTTY;
@@ -1741,6 +1749,12 @@ static int ctl_ioctl(uint command, struc
 	param->data_size = sizeof(*param);
 	r = fn(param, input_param_size);
 
+	/* Warn if IOCTL_FLAGS_NO_PARAMS is set for wrong ioctl */
+	if (unlikely(param->flags & DM_BUFFER_FULL_FLAG) &&
+	    unlikely(ioctl_flags & IOCTL_FLAGS_NO_PARAMS)) {
+		DMWARN("ioctl %d tried to output some data", cmd);
+	}
+
 	/*
 	 * Copy the results back to userland.
 	 */
