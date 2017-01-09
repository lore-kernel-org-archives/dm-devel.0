From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/3] dm: Change ioctl handlers to take struct
	file*
Date: Mon,  9 Jan 2017 10:20:38 -0800
Message-ID: <20170109182040.31337-2-agrover@redhat.com>
References: <20170109182040.31337-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170109182040.31337-1-agrover@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

We will need access to struct file in a following commit in an ioctl
handler. Since lookup_ioctl() wants all ioctl handler functions to have
the same signature, change all signatures to take struct file.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/md/dm-ioctl.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a5a9b17..17c9bf9 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -463,9 +463,9 @@ void dm_deferred_remove(void)
  * All the ioctl commands get dispatched to functions with this
  * prototype.
  */
-typedef int (*ioctl_fn)(struct dm_ioctl *param, size_t param_size);
+typedef int (*ioctl_fn)(struct file *filp, struct dm_ioctl *param, size_t param_size);
 
-static int remove_all(struct dm_ioctl *param, size_t param_size)
+static int remove_all(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	dm_hash_remove_all(true, !!(param->flags & DM_DEFERRED_REMOVE), false);
 	param->data_size = 0;
@@ -498,7 +498,7 @@ static void *get_result_buffer(struct dm_ioctl *param, size_t param_size,
 	return ((void *) param) + param->data_start;
 }
 
-static int list_devices(struct dm_ioctl *param, size_t param_size)
+static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	unsigned int i;
 	struct hash_cell *hc;
@@ -589,7 +589,7 @@ static void list_version_get_info(struct target_type *tt, void *param)
     info->vers = align_ptr(((void *) ++info->vers) + strlen(tt->name) + 1);
 }
 
-static int list_versions(struct dm_ioctl *param, size_t param_size)
+static int list_versions(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	size_t len, needed = 0;
 	struct dm_target_versions *vers;
@@ -731,7 +731,7 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	}
 }
 
-static int dev_create(struct dm_ioctl *param, size_t param_size)
+static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r, m = DM_ANY_MINOR;
 	struct mapped_device *md;
@@ -823,7 +823,7 @@ static struct mapped_device *find_device(struct dm_ioctl *param)
 	return md;
 }
 
-static int dev_remove(struct dm_ioctl *param, size_t param_size)
+static int dev_remove(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	struct hash_cell *hc;
 	struct mapped_device *md;
@@ -888,7 +888,7 @@ static int invalid_str(char *str, void *end)
 	return -EINVAL;
 }
 
-static int dev_rename(struct dm_ioctl *param, size_t param_size)
+static int dev_rename(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r;
 	char *new_data = (char *) param + param->data_start;
@@ -918,7 +918,7 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 	return 0;
 }
 
-static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
+static int dev_set_geometry(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r = -EINVAL, x;
 	struct mapped_device *md;
@@ -1067,7 +1067,7 @@ static int do_resume(struct dm_ioctl *param)
  * Set or unset the suspension state of a device.
  * If the device already is in the requested state we just return its status.
  */
-static int dev_suspend(struct dm_ioctl *param, size_t param_size)
+static int dev_suspend(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	if (param->flags & DM_SUSPEND_FLAG)
 		return do_suspend(param);
@@ -1079,7 +1079,7 @@ static int dev_suspend(struct dm_ioctl *param, size_t param_size)
  * Copies device info back to user space, used by
  * the create and info ioctls.
  */
-static int dev_status(struct dm_ioctl *param, size_t param_size)
+static int dev_status(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	struct mapped_device *md;
 
@@ -1170,7 +1170,7 @@ static void retrieve_status(struct dm_table *table,
 /*
  * Wait for a device to report an event
  */
-static int dev_wait(struct dm_ioctl *param, size_t param_size)
+static int dev_wait(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r = 0;
 	struct mapped_device *md;
@@ -1276,7 +1276,7 @@ static bool is_valid_type(unsigned cur, unsigned new)
 	return false;
 }
 
-static int table_load(struct dm_ioctl *param, size_t param_size)
+static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r;
 	struct hash_cell *hc;
@@ -1363,7 +1363,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	return r;
 }
 
-static int table_clear(struct dm_ioctl *param, size_t param_size)
+static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	struct hash_cell *hc;
 	struct mapped_device *md;
@@ -1437,7 +1437,7 @@ static void retrieve_deps(struct dm_table *table,
 	param->data_size = param->data_start + needed;
 }
 
-static int table_deps(struct dm_ioctl *param, size_t param_size)
+static int table_deps(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	struct mapped_device *md;
 	struct dm_table *table;
@@ -1463,7 +1463,7 @@ static int table_deps(struct dm_ioctl *param, size_t param_size)
  * Return the status of a device as a text string for each
  * target.
  */
-static int table_status(struct dm_ioctl *param, size_t param_size)
+static int table_status(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	struct mapped_device *md;
 	struct dm_table *table;
@@ -1518,7 +1518,7 @@ static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
 /*
  * Pass a message to the target that's at the supplied device offset.
  */
-static int target_message(struct dm_ioctl *param, size_t param_size)
+static int target_message(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
 	int r, argc;
 	char **argv;
@@ -1794,7 +1794,7 @@ static int validate_params(uint cmd, struct dm_ioctl *param)
 	return 0;
 }
 
-static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
+static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *user)
 {
 	int r = 0;
 	int ioctl_flags;
@@ -1848,7 +1848,7 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 		goto out;
 
 	param->data_size = sizeof(*param);
-	r = fn(param, input_param_size);
+	r = fn(file, param, input_param_size);
 
 	if (unlikely(param->flags & DM_BUFFER_FULL_FLAG) &&
 	    unlikely(ioctl_flags & IOCTL_FLAGS_NO_PARAMS))
@@ -1867,7 +1867,7 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 
 static long dm_ctl_ioctl(struct file *file, uint command, ulong u)
 {
-	return (long)ctl_ioctl(command, (struct dm_ioctl __user *)u);
+	return (long)ctl_ioctl(file, command, (struct dm_ioctl __user *)u);
 }
 
 #ifdef CONFIG_COMPAT
-- 
2.9.3
