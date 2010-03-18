From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 1/3] Send KOBJ_ADD event after dm resume ioctl.
Date: Thu, 18 Mar 2010 14:58:12 +0100
Message-ID: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
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
To: dm-devel@redhat.com, kay.sievers@vrfy.org
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Block layer sends ADD uevent when new device is initialised.

But the device-mapper block devices are more complex,
initialisation consists of allocating underlying device and
loading mapping table.

Because from the userspace all block devices should behave
the same, patch defines new flag indicating that ADD event
should be suppressed in block layer.

If the flag is set, caller then take full responsibility
for enabling and sending events later when device is ready
to use.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c |   29 +++++++++++++++++++++++------
 drivers/md/dm.c       |   24 +++++++++++++++++++++---
 drivers/md/dm.h       |    5 +++++
 fs/partitions/check.c |    4 ++++
 include/linux/genhd.h |    1 +
 5 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index d7500e1..b670922 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -61,6 +61,24 @@ static DECLARE_RWSEM(_hash_lock);
  */
 static DEFINE_MUTEX(dm_hash_cells_mutex);
 
+static void dm_ioctl_uevent(struct mapped_device *md,
+			    enum kobject_action action,
+			    unsigned cookie,
+			    uint32_t *dm_flags)
+{
+	/*
+	 * The first change event is translated to add event.
+	 */
+	if (!dm_initialised_md(md)) {
+		if (action == KOBJ_CHANGE)
+			action = KOBJ_ADD;
+		WARN_ON(action != KOBJ_ADD);
+	}
+
+	if (!dm_kobject_uevent(md, action, cookie))
+		*dm_flags |= DM_UEVENT_GENERATED_FLAG;
+}
+
 static void init_buckets(struct list_head *buckets)
 {
 	unsigned int i;
@@ -345,8 +363,7 @@ static int dm_hash_rename(uint32_t cookie, uint32_t *flags, const char *old,
 		dm_table_put(table);
 	}
 
-	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, cookie))
-		*flags |= DM_UEVENT_GENERATED_FLAG;
+	dm_ioctl_uevent(hc->md, KOBJ_CHANGE, cookie, flags);
 
 	dm_put(hc->md);
 	up_write(&_hash_lock);
@@ -738,8 +755,7 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 	__hash_remove(hc);
 	up_write(&_hash_lock);
 
-	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
-		param->flags |= DM_UEVENT_GENERATED_FLAG;
+	dm_ioctl_uevent(md, KOBJ_REMOVE, param->event_nr, &param->flags);
 
 	dm_put(md);
 	return 0;
@@ -903,8 +919,9 @@ static int do_resume(struct dm_ioctl *param)
 
 	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
-		if (!r && !dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
-			param->flags |= DM_UEVENT_GENERATED_FLAG;
+		if (!r)
+			dm_ioctl_uevent(md, KOBJ_CHANGE, param->event_nr,
+					&param->flags);
 	}
 
 	if (old_map)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d21e128..7b364d7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -109,6 +109,7 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_DELETING 4
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_QUEUE_IO_TO_THREAD 6
+#define DMF_INITIALISED 7
 
 /*
  * Work processed by per-device workqueue.
@@ -1932,6 +1933,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
+	md->disk->flags |= GENHD_FL_SUPPRESS_ADD_EVENT;
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
@@ -2619,19 +2621,30 @@ out:
  * Event notification.
  *---------------------------------------------------------------*/
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie)
+		      unsigned cookie)
 {
 	char udev_cookie[DM_COOKIE_LENGTH];
 	char *envp[] = { udev_cookie, NULL };
+	int r = 0;
+
+	if (action == KOBJ_ADD) {
+		set_bit(DMF_INITIALISED, &md->flags);
+		dev_set_uevent_suppress(disk_to_dev(md->disk), 0);
+	}
 
 	if (!cookie)
-		return kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
+		r = kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
 	else {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		return kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
+		r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
 					  action, envp);
 	}
+
+	if (!r && dev_get_uevent_suppress(disk_to_dev(md->disk)))
+		r = -EINVAL;
+
+	return r;
 }
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
@@ -2698,6 +2711,11 @@ int dm_suspended_md(struct mapped_device *md)
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_initialised_md(struct mapped_device *md)
+{
+	return test_bit(DMF_INITIALISED, &md->flags);
+}
+
 int dm_suspended(struct dm_target *ti)
 {
 	return dm_suspended_md(dm_table_get_md(ti->table));
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..1e9d7fc 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -99,6 +99,11 @@ int dm_deleting_md(struct mapped_device *md);
 int dm_suspended_md(struct mapped_device *md);
 
 /*
+ * Is the device initialised? (Add event was sent.)
+ */
+int dm_initialised_md(struct mapped_device *md);
+
+/*
  * The device-mapper can be driven through one of two interfaces;
  * ioctl or filesystem, depending which patch you have applied.
  */
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e8865c1..916173b 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -526,6 +526,10 @@ void register_disk(struct gendisk *disk)
 	blkdev_put(bdev, FMODE_READ);
 
 exit:
+	/* caller will send ADD event later */
+	if (disk->flags & GENHD_FL_SUPPRESS_ADD_EVENT)
+		return;
+
 	/* announce disk after possible partitions are created */
 	dev_set_uevent_suppress(ddev, 0);
 	kobject_uevent(&ddev->kobj, KOBJ_ADD);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 56b5051..ade71ff 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -116,6 +116,7 @@ struct hd_struct {
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 #define GENHD_FL_NATIVE_CAPACITY		128
+#define GENHD_FL_SUPPRESS_ADD_EVENT		256
 
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
-- 
1.7.0
