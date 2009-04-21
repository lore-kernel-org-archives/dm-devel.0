From: Alasdair G Kergon <agk@redhat.com>
Subject: FW: Re: [PATCH] another (fixed) dm cookie support
Date: Tue, 21 Apr 2009 13:07:22 +0100
Message-ID: <20090421120722.GE1332@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

----- Forwarded message from Milan Broz <mbroz@redhat.com> -----

Date: Wed, 15 Apr 2009 18:19:44 +0200
From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] another (fixed) dm cookie support

Add support for passing a 32 bit "cookie" into the kernel with the
DM_SUSPEND, DM_DEV_RENAME and DM_DEV_REMOVE ioctls.  The (unsigned)
value of this cookie is returned to userspace alongside the uevents
issued by these ioctls in the variable DM_COOKIE.

This means the userspace process issuing these ioctls can be notified
by udev after udev has completed any actions triggered.

To minimise the interface extension, we pass the cookie into the
kernel in the event_nr field which is otherwise unused when calling
these ioctls.  Incrementing the version number allows userspace to
determine in advance whether or not the kernel supports the cookie.
If the kernel does support this but userspace does not, there should
be no impact as the new variable will just get ignored.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c    |   14 ++++++++++----
 drivers/md/dm.c          |   26 ++++++++++++++++++++------
 drivers/md/dm.h          |    3 ++-
 include/linux/dm-ioctl.h |   14 ++++++++++++--
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 823ceba..410f2d0 100644
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
@@ -333,7 +333,7 @@ static int dm_hash_rename(const char *old, const char *new)
 		dm_table_put(table);
 	}
 
-	dm_kobject_uevent(hc->md);
+	dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie);
 
 	dm_put(hc->md);
 	up_write(&_hash_lock);
@@ -680,6 +680,9 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 
 	__hash_remove(hc);
 	up_write(&_hash_lock);
+
+	dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr);
+
 	dm_put(md);
 	param->data_size = 0;
 	return 0;
@@ -715,7 +718,7 @@ static int dev_rename(struct dm_ioctl *param, size_t param_size)
 		return r;
 
 	param->data_size = 0;
-	return dm_hash_rename(param->name, new_name);
+	return dm_hash_rename(param->event_nr, param->name, new_name);
 }
 
 static int dev_set_geometry(struct dm_ioctl *param, size_t param_size)
@@ -842,8 +845,11 @@ static int do_resume(struct dm_ioctl *param)
 	if (dm_suspended(md))
 		r = dm_resume(md);
 
-	if (!r)
+
+	if (!r) {
+		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
 		r = __dev_status(md, param);
+	}
 
 	dm_put(md);
 	return r;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 424f7b0..5a1e5ac 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -24,6 +24,13 @@
 
 #define DM_MSG_PREFIX "core"
 
+/*
+ * Cookies are numeric values sent with CHANGE and REMOVE
+ * uevents while resuming, removing or renaming the device.
+ */
+#define DM_COOKIE_ENV_VAR_NAME "DM_COOKIE"
+#define DM_COOKIE_LENGTH 24
+
 static const char *_name = DM_NAME;
 
 static unsigned int major = 0;
@@ -1709,11 +1716,7 @@ int dm_resume(struct mapped_device *md)
 	clear_bit(DMF_SUSPENDED, &md->flags);
 
 	dm_table_unplug_all(map);
-
-	dm_kobject_uevent(md);
-
 	r = 0;
-
 out:
 	dm_table_put(map);
 	mutex_unlock(&md->suspend_lock);
@@ -1724,9 +1727,20 @@ out:
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
-void dm_kobject_uevent(struct mapped_device *md)
+void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
+		       unsigned cookie)
 {
-	kobject_uevent(&disk_to_dev(md->disk)->kobj, KOBJ_CHANGE);
+	char udev_cookie[DM_COOKIE_LENGTH];
+	char *envp[] = { udev_cookie, NULL };
+
+	if (cookie)
+		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
+			 DM_COOKIE_ENV_VAR_NAME, cookie);
+	else
+		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=",
+			 DM_COOKIE_ENV_VAR_NAME);
+
+	kobject_uevent_env(&disk_to_dev(md->disk)->kobj, action, envp);
 }
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index a31506d..b5935c6 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -92,7 +92,8 @@ void dm_stripe_exit(void);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
-void dm_kobject_uevent(struct mapped_device *md);
+void dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
+		       unsigned cookie);
 
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index 48e44ee..2ab84c8 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -123,6 +123,16 @@ struct dm_ioctl {
 	__u32 target_count;	/* in/out */
 	__s32 open_count;	/* out */
 	__u32 flags;		/* in/out */
+
+	/*
+	 * event_nr holds either the event number (input and output) or the
+	 * udev cookie value (input only).
+	 * The DM_DEV_WAIT ioctl takes an event number as input.
+	 * The DM_SUSPEND, DM_DEV_REMOVE and DM_DEV_RENAME ioctls
+	 * use the field as a cookie to return in the DM_COOKIE
+	 * variable with the uevents they issue.
+	 * For output, the ioctls return the event number, not the cookie.
+	 */
 	__u32 event_nr;      	/* in/out */
 	__u32 padding;
 
@@ -256,9 +266,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	14
+#define DM_VERSION_MINOR	15
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2008-04-23)"
+#define DM_VERSION_EXTRA	"-ioctl (2009-04-01)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
