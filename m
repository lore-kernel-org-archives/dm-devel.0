From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] Uevent cookie env var support
Date: Wed, 08 Apr 2009 14:04:28 +0200
Message-ID: <49DC92CC.30708@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

Hi,

this is a kernel side patch that adds support for cookie variables.
A cookie is a random unsigned 32 bit value generated in userspace
and passed into the DM through ioctl (reusing the event_nr field to
avoid the change in the interface). These values are sent back in
CHANGE and REMOVE uevents. This way we can easily pair a process
waiting for udev's rule completion and the udev event itself. Also,
we can use the cookie value to group the actions and related uevents
together, so we know which uevents belong to actions done on one
DM tree.

Peter


diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 823ceba..6ad924a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -276,7 +276,7 @@ retry:
 	up_write(&_hash_lock);
 }
 
-static int dm_hash_rename(const char *old, const char *new)
+static int dm_hash_rename(uint32_t cookie, const char *old, const char *new)
 {
 	char *new_name, *old_name;
 	struct hash_cell *hc;
@@ -333,6 +333,7 @@ static int dm_hash_rename(const char *old, const char *new)
 		dm_table_put(table);
 	}
 
+	dm_set_cookie(hc->md, cookie);
 	dm_kobject_uevent(hc->md);
 
 	dm_put(hc->md);
@@ -678,9 +679,11 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 		return r;
 	}
 
+	dm_set_cookie(md, param->event_nr);
+
 	__hash_remove(hc);
-	up_write(&_hash_lock);
 	dm_put(md);
+	up_write(&_hash_lock);
 	param->data_size = 0;
 	return 0;
 }
@@ -715,7 +718,7 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 		return r;
 
 	param->data_size = 0;
-	return dm_hash_rename(param->name, new_name);
+	return dm_hash_rename(param->event_nr, param->name, new_name);
 }
 
 static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
@@ -814,8 +817,6 @@ static int do_resume(struct dm_ioctl *param)
 	hc->new_map = NULL;
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
-	up_write(&_hash_lock);
-
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		/* Suspend if it isn't already suspended */
@@ -839,13 +840,18 @@ static int do_resume(struct dm_ioctl *param)
 			set_disk_ro(dm_disk(md), 1);
 	}
 
+	dm_set_cookie(md, param->event_nr);
+
 	if (dm_suspended(md))
 		r = dm_resume(md);
+	else
+		dm_kobject_uevent(md);
 
 	if (!r)
 		r = __dev_status(md, param);
 
 	dm_put(md);
+	up_write(&_hash_lock);
 	return r;
 }
 
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index a2a45e6..2c9b0db 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -95,5 +95,9 @@ int dm_sysfs_init(struct mapped_device *md)
  */
 void dm_sysfs_exit(struct mapped_device *md)
 {
+	char *envp[] = {dm_get_cookie(md), NULL};
+	struct kobject *kobj = &disk_to_dev(dm_disk(md))->kobj;
+
+	kobject_uevent_env(kobj, KOBJ_REMOVE, envp);
 	kobject_put(dm_kobject(md));
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a994be..52bee12 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -155,6 +155,7 @@ struct mapped_device {
 	atomic_t uevent_seq;
 	struct list_head uevent_list;
 	spinlock_t uevent_lock; /* Protect access to uevent_list */
+	char cookie[24];
 
 	/*
 	 * freeze/thaw support require holding onto a super block
@@ -1727,7 +1728,9 @@ out:
  *---------------------------------------------------------------*/
 void dm_kobject_uevent(struct mapped_device *md)
 {
-	kobject_uevent(&disk_to_dev(md->disk)->kobj, KOBJ_CHANGE);
+	char *envp[] = {dm_get_cookie(md), NULL};
+
+	kobject_uevent_env(&disk_to_dev(md->disk)->kobj, KOBJ_CHANGE, envp);
 }
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
@@ -1764,6 +1767,16 @@ struct gendisk *dm_disk(struct mapped_device *md)
 	return md->disk;
 }
 
+void dm_set_cookie(struct mapped_device *md, uint32_t cookie)
+{
+	snprintf(md->cookie, sizeof(md->cookie), "COOKIE=%u", (unsigned) cookie);
+}
+
+char *dm_get_cookie(struct mapped_device *md)
+{
+	return md->cookie;
+}
+
 struct kobject *dm_kobject(struct mapped_device *md)
 {
 	return &md->kobj;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index a31506d..0c6dbaa 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -93,6 +93,8 @@ int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
 void dm_kobject_uevent(struct mapped_device *md);
+void dm_set_cookie(struct mapped_device *md, uint32_t cookie);
+char *dm_get_cookie(struct mapped_device *md);
 
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index 48e44ee..dcf0192 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -123,7 +123,8 @@ struct dm_ioctl {
 	__u32 target_count;	/* in/out */
 	__s32 open_count;	/* out */
 	__u32 flags;		/* in/out */
-	__u32 event_nr;      	/* in/out */
+	__u32 event_nr;      	/* in/out
+				 * used both for event numbers and cookie values */
 	__u32 padding;
 
 	__u64 dev;		/* in/out */
@@ -256,9 +257,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	14
+#define DM_VERSION_MINOR	15
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2008-04-23)"
+#define DM_VERSION_EXTRA	"-ioctl (2009-04-01)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
