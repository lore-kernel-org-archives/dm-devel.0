From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/7] dm: interface change of dm_suspend()
Date: Tue, 10 Oct 2006 17:29:47 -0400 (EDT)
Message-ID: <20061010.172947.48535749.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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

This patch changes the interface of dm_suspend() so that we can pass
several options without increasing the number of arguments.
Should have no effect on the behavior.


Test results:
I have tested 'dmsetup suspend' command with/without the '--nolockfs'
option and confirmed the do_lockfs value is correctly set.


The patch is for:
    2.6.18-mm2 + patch 1

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 1-remove-space/drivers/md/dm.c 2-susp-iface-change/drivers/md/dm.c
--- 1-remove-space/drivers/md/dm.c	2006-10-05 10:25:49.000000000 -0400
+++ 2-susp-iface-change/drivers/md/dm.c	2006-10-05 10:26:33.000000000 -0400
@@ -1272,12 +1272,13 @@ static void unlock_fs(struct mapped_devi
  * dm_bind_table, dm_suspend must be called to flush any in
  * flight bios and ensure that any further io gets deferred.
  */
-int dm_suspend(struct mapped_device *md, int do_lockfs)
+int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
 	struct dm_table *map = NULL;
 	DECLARE_WAITQUEUE(wait, current);
 	struct bio *def;
 	int r = -EINVAL;
+	int do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG ? 1 : 0;
 
 	down(&md->suspend_lock);
 
diff -rupN 1-remove-space/drivers/md/dm.h 2-susp-iface-change/drivers/md/dm.h
--- 1-remove-space/drivers/md/dm.h	2006-10-05 10:23:59.000000000 -0400
+++ 2-susp-iface-change/drivers/md/dm.h	2006-10-05 10:26:33.000000000 -0400
@@ -33,6 +33,11 @@
 #define SECTOR_SHIFT 9
 
 /*
+ * Suspend feature flags
+ */
+#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev {
diff -rupN 1-remove-space/drivers/md/dm-ioctl.c 2-susp-iface-change/drivers/md/dm-ioctl.c
--- 1-remove-space/drivers/md/dm-ioctl.c	2006-09-19 23:42:06.000000000 -0400
+++ 2-susp-iface-change/drivers/md/dm-ioctl.c	2006-10-05 10:26:33.000000000 -0400
@@ -760,7 +760,7 @@ out:
 static int do_suspend(struct dm_ioctl *param)
 {
 	int r = 0;
-	int do_lockfs = 1;
+	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -768,10 +768,10 @@ static int do_suspend(struct dm_ioctl *p
 		return -ENXIO;
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
-		do_lockfs = 0;
+		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 
 	if (!dm_suspended(md))
-		r = dm_suspend(md, do_lockfs);
+		r = dm_suspend(md, suspend_flags);
 
 	if (!r)
 		r = __dev_status(md, param);
@@ -783,7 +783,7 @@ static int do_suspend(struct dm_ioctl *p
 static int do_resume(struct dm_ioctl *param)
 {
 	int r = 0;
-	int do_lockfs = 1;
+	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map;
@@ -809,9 +809,9 @@ static int do_resume(struct dm_ioctl *pa
 	if (new_map) {
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
-			do_lockfs = 0;
+			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 		if (!dm_suspended(md))
-			dm_suspend(md, do_lockfs);
+			dm_suspend(md, suspend_flags);
 
 		r = dm_swap_table(md, new_map);
 		if (r) {
diff -rupN 1-remove-space/include/linux/device-mapper.h 2-susp-iface-change/include/linux/device-mapper.h
--- 1-remove-space/include/linux/device-mapper.h	2006-10-05 10:24:05.000000000 -0400
+++ 2-susp-iface-change/include/linux/device-mapper.h	2006-10-05 10:26:33.000000000 -0400
@@ -173,7 +173,7 @@ void *dm_get_mdptr(struct mapped_device 
 /*
  * A device can still be used while suspended, but I/O is deferred.
  */
-int dm_suspend(struct mapped_device *md, int with_lockfs);
+int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
 int dm_resume(struct mapped_device *md);
 
 /*
