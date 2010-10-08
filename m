From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] device-mapper: Allow setting of UUID via rename
	if not	already set
Date: Fri, 08 Oct 2010 16:33:22 -0500
Message-ID: <1286573602.9513.8.camel@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com, pjones@redhat.com
List-Id: dm-devel.ids

Peter, please add your "signed-off-by" if you approve of the changes
(above my signed-off-by, because you are the creator).  It still would
be nice to have a better header - not too many people will look at the
bz, I think.  Better to say "There are times when we need to be able to
set device UUIDs, like when...".

Looks like I had in mind the same things as Mike.  :)

 brassow


This makes it possible to use DM_DEV_RENAME to add a uuid to a device so
long as one has not been previously set either with DM_DEV_CREATE or
with DM_DEV_RENAME. This is proposed as a fix to rhbz#584328 .

Also bump the minor number to 19.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -298,7 +298,7 @@ retry:
 static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 					    const char *new)
 {
-	char *new_name, *old_name;
+	char *new_data, *old_data;
 	struct hash_cell *hc;
 	struct dm_table *table;
 	struct mapped_device *md;
@@ -306,8 +306,8 @@ static struct mapped_device *dm_hash_ren
 	/*
 	 * duplicate new.
 	 */
-	new_name = kstrdup(new, GFP_KERNEL);
-	if (!new_name)
+	new_data = kstrdup(new, GFP_KERNEL);
+	if (!new_data)
 		return ERR_PTR(-ENOMEM);
 
 	down_write(&_hash_lock);
@@ -315,13 +315,19 @@ static struct mapped_device *dm_hash_ren
 	/*
 	 * Is new free ?
 	 */
-	hc = __get_name_cell(new);
+	if (param->flags & DM_NEW_UUID_FLAG)
+		hc = __get_uuid_cell(new);
+	else
+		hc = __get_name_cell(new);
+
 	if (hc) {
-		DMWARN("asked to rename to an already-existing name %s -> %s",
+		DMWARN("Unable to change %s on device, %s to one that "
+		       "already exists: %s",
+		       (param->flags & DM_NEW_UUID_FLAG) ? "uuid" : "name",
 		       param->name, new);
 		dm_put(hc->md);
 		up_write(&_hash_lock);
-		kfree(new_name);
+		kfree(new_data);
 		return ERR_PTR(-EBUSY);
 	}
 
@@ -330,22 +336,45 @@ static struct mapped_device *dm_hash_ren
 	 */
 	hc = __get_name_cell(param->name);
 	if (!hc) {
-		DMWARN("asked to rename a non-existent device %s -> %s",
+		DMWARN("Unable to rename non-existent device, %s to %s",
 		       param->name, new);
 		up_write(&_hash_lock);
-		kfree(new_name);
+		kfree(new_data);
 		return ERR_PTR(-ENXIO);
 	}
 
-	/*
-	 * rename and move the name cell.
-	 */
-	list_del(&hc->name_list);
-	old_name = hc->name;
-	mutex_lock(&dm_hash_cells_mutex);
-	hc->name = new_name;
-	mutex_unlock(&dm_hash_cells_mutex);
-	list_add(&hc->name_list, _name_buckets + hash_str(new_name));
+	if (param->flags & DM_NEW_UUID_FLAG) {
+		/*
+		 * Does this device already have a uuid?
+		 */
+		if (hc->uuid) {
+			DMWARN("Unable to change uuid of device, %s because "
+			       "uuid is already set to %s",
+			       param->name, hc->uuid);
+			up_write(&_hash_lock);
+			kfree(new_data);
+			return ERR_PTR(-EINVAL);
+		}
+		/*
+		 * change uuid and move the uuid cell.
+		 */
+		list_del(&hc->uuid_list);
+		old_data = hc->uuid;
+		mutex_lock(&dm_hash_cells_mutex);
+		hc->uuid = new_data;
+		mutex_unlock(&dm_hash_cells_mutex);
+		list_add(&hc->uuid_list, _uuid_buckets + hash_str(new_data));
+	} else {
+		/*
+		 * rename and move the name cell.
+		 */
+		list_del(&hc->name_list);
+		old_data = hc->name;
+		mutex_lock(&dm_hash_cells_mutex);
+		hc->name = new_data;
+		mutex_unlock(&dm_hash_cells_mutex);
+		list_add(&hc->name_list, _name_buckets + hash_str(new_data));
+	}
 
 	/*
 	 * Wake up any dm event waiters.
@@ -361,7 +390,7 @@ static struct mapped_device *dm_hash_ren
 
 	md = hc->md;
 	up_write(&_hash_lock);
-	kfree(old_name);
+	kfree(old_data);
 
 	return md;
 }
@@ -774,21 +803,30 @@ static int invalid_str(char *str, void *
 static int dev_rename(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
-	char *new_name = (char *) param + param->data_start;
+	char *new_data = (char *) param + param->data_start;
 	struct mapped_device *md;
 
-	if (new_name < param->data ||
-	    invalid_str(new_name, (void *) param + param_size) ||
-	    strlen(new_name) > DM_NAME_LEN - 1) {
-		DMWARN("Invalid new logical volume name supplied.");
-		return -EINVAL;
-	}
+	if (param->flags & DM_NEW_UUID_FLAG) {
+		if (new_data < param->data ||
+		    invalid_str(new_data, (void *) param + param_size) ||
+		    strlen(new_data) > DM_UUID_LEN - 1) {
+			DMWARN("Invalid new device uuid supplied.");
+			return -EINVAL;
+		}
+	} else {
+		if (new_data < param->data ||
+		    invalid_str(new_data, (void *) param + param_size) ||
+		    strlen(new_data) > DM_NAME_LEN - 1) {
+			DMWARN("Invalid new device name supplied.");
+			return -EINVAL;
+		}
 
-	r = check_name(new_name);
-	if (r)
-		return r;
+		r = check_name(new_data);
+		if (r)
+			return r;
+	}
 
-	md = dm_hash_rename(param, new_name);
+	md = dm_hash_rename(param, new_data);
 	if (IS_ERR(md))
 		return PTR_ERR(md);
 
Index: linux-2.6/include/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/linux/dm-ioctl.h
+++ linux-2.6/include/linux/dm-ioctl.h
@@ -267,9 +267,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	18
+#define DM_VERSION_MINOR	19
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2010-06-29)"
+#define DM_VERSION_EXTRA	"-ioctl (2010-10-07)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -322,4 +322,9 @@ enum {
  */
 #define DM_UEVENT_GENERATED_FLAG	(1 << 13) /* Out */
 
+/*
+ * If set, rename operates on uuid, not name.
+ */
+#define DM_NEW_UUID_FLAG        (1 << 14) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
