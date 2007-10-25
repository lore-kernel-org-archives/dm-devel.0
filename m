From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm: noflush resizing (0/3)
Date: Thu, 25 Oct 2007 19:51:40 -0400
Message-ID: <47212C0C.4080501@ce.jp.nec.com>
References: <471FB83D.4060307@ce.jp.nec.com>	<20071025012456.GK10006@agk.fab.redhat.com>	<4720A59A.8060001@ce.jp.nec.com>	<20071025144833.GN10006@agk.fab.redhat.com>
	<4720E479.4020906@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4720E479.4020906@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Alasdair,

Jun'ichi Nomura wrote:
> So as far as I understand, the point is:
>   1. it's preferable to resize inode after the resume, if possible

Attached is a modified version of the (2/3) patch.
  - The logic is basically the same as before.
  - Moved the set-size function outside of the table swapping.
  - Moved the uevent to the end of resize from the end of resume.
  - Lightly tested on LVM2 mirror resizing.
  - (1/3) and (3/3) are unchanged.

What do you think about this?

---
 drivers/md/dm-ioctl.c         |    4 ++
 drivers/md/dm.c               |   61 ++++++++++++++++++++++++++----------------
 include/linux/device-mapper.h |    5 +++
 3 files changed, 46 insertions(+), 24 deletions(-)

Index: linux-2.6.23.work/drivers/md/dm.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm.c
+++ linux-2.6.23.work/drivers/md/dm.c
@@ -1099,31 +1099,11 @@ static void event_callback(void *context
 	wake_up(&md->eventq);
 }
 
-static void __set_size(struct mapped_device *md, sector_t size)
-{
-	set_capacity(md->disk, size);
-
-	mutex_lock(&md->suspended_bdev->bd_inode->i_mutex);
-	i_size_write(md->suspended_bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->suspended_bdev->bd_inode->i_mutex);
-}
-
 static int __bind(struct mapped_device *md, struct dm_table *t)
 {
 	struct request_queue *q = md->queue;
-	sector_t size;
-
-	size = dm_table_get_size(t);
-
-	/*
-	 * Wipe any geometry if the size of the table changed.
-	 */
-	if (size != get_capacity(md->disk))
-		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (md->suspended_bdev)
-		__set_size(md, size);
-	if (size == 0)
+	if (!dm_table_get_size(t))
 		return 0;
 
 	dm_table_get(t);
@@ -1497,8 +1477,6 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
-	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
-
 	r = 0;
 
 out:
@@ -1508,6 +1486,43 @@ out:
 	return r;
 }
 
+void dm_set_size(struct mapped_device *md)
+{
+	struct dm_table *map;
+	struct block_device *bdev;
+	sector_t size;
+
+	down(&md->suspend_lock);
+
+	map = dm_get_table(md);
+	if (!map)
+		goto out;
+
+	size = dm_table_get_size(map);
+
+	/*
+	 * Wipe any geometry if the size of the table changed.
+	 */
+	if (size != get_capacity(md->disk))
+		memset(&md->geometry, 0, sizeof(md->geometry));
+
+	set_capacity(md->disk, size);
+
+	bdev = bdlookup_disk(md->disk, 0);
+	if (bdev) {
+		mutex_lock(&bdev->bd_mutex);
+		i_size_write(bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
+		mutex_unlock(&bdev->bd_mutex);
+		bdput(bdev);
+	}
+
+	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
+
+out:
+	dm_table_put(map);
+	up(&md->suspend_lock);
+}
+
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
Index: linux-2.6.23.work/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm-ioctl.c
+++ linux-2.6.23.work/drivers/md/dm-ioctl.c
@@ -840,8 +840,10 @@ static int do_resume(struct dm_ioctl *pa
 	if (dm_suspended(md))
 		r = dm_resume(md);
 
-	if (!r)
+	if (!r) {
+		dm_set_size(md);
 		r = __dev_status(md, param);
+	}
 
 	dm_put(md);
 	return r;
Index: linux-2.6.23.work/include/linux/device-mapper.h
===================================================================
--- linux-2.6.23.work.orig/include/linux/device-mapper.h
+++ linux-2.6.23.work/include/linux/device-mapper.h
@@ -198,6 +198,11 @@ int dm_noflush_suspending(struct dm_targ
 int dm_get_geometry(struct mapped_device *md, struct hd_geometry *geo);
 int dm_set_geometry(struct mapped_device *md, struct hd_geometry *geo);
 
+/*
+ * Update device size
+ */
+void dm_set_size(struct mapped_device *md);
+
 
 /*-----------------------------------------------------------------
  * Functions for manipulating device-mapper tables.
