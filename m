From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] dm_ioctl: Introduce DM_UEVENT_GENERATED_FLAG
Date: Mon, 01 Mar 2010 09:27:17 +0100
Message-ID: <4B8B7A65.3020301@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Introduce DM_UEVENT_GENERATED_FLAG in dm ioctl return and let user space
program know whether a uevent was generated or not. This helps the ioctl
caller to determine proper actions that should be taken while awaiting the 
uevent.

Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
---

diff -purN linux-2.6.33-rc8.orig/drivers/md/dm.c linux-2.6.33-rc8/drivers/md/dm.c
--- linux-2.6.33-rc8.orig/drivers/md/dm.c	2010-02-26 22:36:11.276554991 +0100
+++ linux-2.6.33-rc8/drivers/md/dm.c	2010-02-26 22:35:15.591552363 +0100
@@ -2618,18 +2618,19 @@ out:
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
-void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
+int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		       unsigned cookie)
 {
 	char udev_cookie[DM_COOKIE_LENGTH];
 	char *envp[] = { udev_cookie, NULL };
 
 	if (!cookie)
-		kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
+		return kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
 	else {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		kobject_uevent_env(&disk_to_dev(md->disk)->kobj, action, envp);
+		return kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
+					  action, envp);
 	}
 }
 
diff -purN linux-2.6.33-rc8.orig/drivers/md/dm.h linux-2.6.33-rc8/drivers/md/dm.h
--- linux-2.6.33-rc8.orig/drivers/md/dm.h	2010-02-26 22:30:46.635549737 +0100
+++ linux-2.6.33-rc8/drivers/md/dm.h	2010-02-26 22:35:15.592552351 +0100
@@ -125,8 +125,8 @@ void dm_stripe_exit(void);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
-void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie);
+int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
+		      unsigned cookie);
 
 int dm_io_init(void);
 void dm_io_exit(void);
diff -purN linux-2.6.33-rc8.orig/drivers/md/dm-ioctl.c linux-2.6.33-rc8/drivers/md/dm-ioctl.c
--- linux-2.6.33-rc8.orig/drivers/md/dm-ioctl.c	2010-02-26 22:36:11.296550413 +0100
+++ linux-2.6.33-rc8/drivers/md/dm-ioctl.c	2010-02-28 19:40:20.737790992 +0100
@@ -285,7 +285,8 @@ retry:
 	up_write(&_hash_lock);
 }
 
-static int dm_hash_rename(uint32_t cookie, const char *old, const char *new)
+static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
+			  const char *new)
 {
 	char *new_name, *old_name;
 	struct hash_cell *hc;
@@ -344,7 +345,8 @@ static int dm_hash_rename(uint32_t cooki
 		dm_table_put(table);
 	}
 
-	dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie);
+	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie))
+		*flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(hc->md);
 	up_write(&_hash_lock);
@@ -736,10 +738,10 @@ static int dev_remove(struct dm_ioctl *p
 	__hash_remove(hc);
 	up_write(&_hash_lock);
 
-	dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr);
+	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
+		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
-	param->data_size = 0;
 	return 0;
 }
 
@@ -773,7 +775,8 @@ static int dev_rename(struct dm_ioctl *p
 		return r;
 
 	param->data_size = 0;
-	return dm_hash_rename(param->event_nr, param->name, new_name);
+	return dm_hash_rename(param->event_nr, &param->flags,
+			      param->name, new_name);
 }
 
 static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
@@ -899,8 +902,8 @@ static int do_resume(struct dm_ioctl *pa
 
 	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
-		if (!r)
-			dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
+		if (!r && !dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
+			param->flags |= DM_UEVENT_GENERATED_FLAG;
 	}
 
 	if (old_map)
diff -purN linux-2.6.33-rc8.orig/include/linux/dm-ioctl.h linux-2.6.33-rc8/include/linux/dm-ioctl.h
--- linux-2.6.33-rc8.orig/include/linux/dm-ioctl.h	2010-02-26 22:30:47.168549633 +0100
+++ linux-2.6.33-rc8/include/linux/dm-ioctl.h	2010-02-28 19:42:35.197553190 +0100
@@ -266,9 +266,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	16
+#define DM_VERSION_MINOR	17
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2009-11-05)"
+#define DM_VERSION_EXTRA	"-ioctl (2010-03-01)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -316,4 +316,9 @@ enum {
  */
 #define DM_QUERY_INACTIVE_TABLE_FLAG	(1 << 12) /* In */
 
+/*
+ * Indicates whether a uevent was generated.
+ */
+#define DM_UEVENT_GENERATED_FLAG	(1 << 13) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */
