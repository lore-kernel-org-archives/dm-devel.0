From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/4] dm: rename dm_suspended() to
	dm_suspended_md()
Date: Fri, 20 Nov 2009 16:12:11 +0900
Message-ID: <4B06414B.6080305@ct.jp.nec.com>
References: <4B06408A.1080700@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B06408A.1080700@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch renames dm_suspended() to dm_suspended_md().
No functional change.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c         |    8 ++++----
 drivers/md/dm-sysfs.c         |    2 +-
 drivers/md/dm.c               |   12 ++++++------
 drivers/md/dm.h               |    5 +++++
 include/linux/device-mapper.h |    1 -
 5 files changed, 16 insertions(+), 12 deletions(-)

Index: 2.6.32-rc7/drivers/md/dm-ioctl.c
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm-ioctl.c
+++ 2.6.32-rc7/drivers/md/dm-ioctl.c
@@ -547,7 +547,7 @@ static int __dev_status(struct mapped_de
 	param->flags &= ~(DM_SUSPEND_FLAG | DM_READONLY_FLAG |
 			  DM_ACTIVE_PRESENT_FLAG);
 
-	if (dm_suspended(md))
+	if (dm_suspended_md(md))
 		param->flags |= DM_SUSPEND_FLAG;
 
 	param->dev = huge_encode_dev(disk_devt(disk));
@@ -795,7 +795,7 @@ static int do_suspend(struct dm_ioctl *p
 	if (param->flags & DM_NOFLUSH_FLAG)
 		suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 
-	if (!dm_suspended(md))
+	if (!dm_suspended_md(md))
 		r = dm_suspend(md, suspend_flags);
 
 	if (!r)
@@ -837,7 +837,7 @@ static int do_resume(struct dm_ioctl *pa
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (param->flags & DM_NOFLUSH_FLAG)
 			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
-		if (!dm_suspended(md))
+		if (!dm_suspended_md(md))
 			dm_suspend(md, suspend_flags);
 
 		r = dm_swap_table(md, new_map);
@@ -853,7 +853,7 @@ static int do_resume(struct dm_ioctl *pa
 			set_disk_ro(dm_disk(md), 1);
 	}
 
-	if (dm_suspended(md))
+	if (dm_suspended_md(md))
 		r = dm_resume(md);
 
 
Index: 2.6.32-rc7/drivers/md/dm-sysfs.c
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm-sysfs.c
+++ 2.6.32-rc7/drivers/md/dm-sysfs.c
@@ -59,7 +59,7 @@ static ssize_t dm_attr_uuid_show(struct 
 
 static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 {
-	sprintf(buf, "%d\n", dm_suspended(md));
+	sprintf(buf, "%d\n", dm_suspended_md(md));
 
 	return strlen(buf);
 }
Index: 2.6.32-rc7/drivers/md/dm.c
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm.c
+++ 2.6.32-rc7/drivers/md/dm.c
@@ -415,7 +415,7 @@ static int dm_blk_ioctl(struct block_dev
 
 	tgt = dm_table_get_target(map, 0);
 
-	if (dm_suspended(md)) {
+	if (dm_suspended_md(md)) {
 		r = -EAGAIN;
 		goto out;
 	}
@@ -2176,7 +2176,7 @@ void dm_put(struct mapped_device *md)
 			    MINOR(disk_devt(dm_disk(md))));
 		set_bit(DMF_FREEING, &md->flags);
 		spin_unlock(&_minor_lock);
-		if (!dm_suspended(md)) {
+		if (!dm_suspended_md(md)) {
 			dm_table_presuspend_targets(map);
 			dm_table_postsuspend_targets(map);
 		}
@@ -2374,7 +2374,7 @@ int dm_swap_table(struct mapped_device *
 	mutex_lock(&md->suspend_lock);
 
 	/* device must be suspended */
-	if (!dm_suspended(md))
+	if (!dm_suspended_md(md))
 		goto out;
 
 	r = dm_calculate_queue_limits(table, &limits);
@@ -2453,7 +2453,7 @@ int dm_suspend(struct mapped_device *md,
 
 	mutex_lock(&md->suspend_lock);
 
-	if (dm_suspended(md)) {
+	if (dm_suspended_md(md)) {
 		r = -EINVAL;
 		goto out_unlock;
 	}
@@ -2560,7 +2560,7 @@ int dm_resume(struct mapped_device *md)
 	struct dm_table *map = NULL;
 
 	mutex_lock(&md->suspend_lock);
-	if (!dm_suspended(md))
+	if (!dm_suspended_md(md))
 		goto out;
 
 	map = dm_get_live_table(md);
@@ -2671,7 +2671,7 @@ struct mapped_device *dm_get_from_kobjec
 	return md;
 }
 
-int dm_suspended(struct mapped_device *md)
+int dm_suspended_md(struct mapped_device *md)
 {
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
Index: 2.6.32-rc7/drivers/md/dm.h
===================================================================
--- 2.6.32-rc7.orig/drivers/md/dm.h
+++ 2.6.32-rc7/drivers/md/dm.h
@@ -94,6 +94,11 @@ int dm_split_args(int *argc, char ***arg
 int dm_deleting_md(struct mapped_device *md);
 
 /*
+ * Is this mapped_device suspended?
+ */
+int dm_suspended_md(struct mapped_device *md);
+
+/*
  * The device-mapper can be driven through one of two interfaces;
  * ioctl or filesystem, depending which patch you have applied.
  */
Index: 2.6.32-rc7/include/linux/device-mapper.h
===================================================================
--- 2.6.32-rc7.orig/include/linux/device-mapper.h
+++ 2.6.32-rc7/include/linux/device-mapper.h
@@ -235,7 +235,6 @@ void dm_uevent_add(struct mapped_device 
 const char *dm_device_name(struct mapped_device *md);
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
-int dm_suspended(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 union map_info *dm_get_mapinfo(struct bio *bio);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
