From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 03/11] dm: suspend: parameter change
Date: Wed, 22 Nov 2006 19:00:46 +0000
Message-ID: <20061122190046.GT6993@agk.surrey.redhat.com>
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
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

This patch changes the interface of dm_suspend() so that we can pass
several options without increasing the number of parameters.
The existing 'do_lockfs' integer parameter is replaced by a flag
DM_SUSPEND_LOCKFS_FLAG.

There is no functional change to the code.

Test results:
I have tested 'dmsetup suspend' command with/without the '--nolockfs'
option and confirmed the do_lockfs value is correctly set.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc6/drivers/md/dm.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm.c	2006-11-22 17:26:56.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm.c	2006-11-22 17:26:57.000000000 +0000
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
 
Index: linux-2.6.19-rc6/drivers/md/dm.h
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm.h	2006-11-22 17:26:46.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm.h	2006-11-22 17:26:57.000000000 +0000
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
Index: linux-2.6.19-rc6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm-ioctl.c	2006-11-22 17:26:46.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm-ioctl.c	2006-11-22 17:26:57.000000000 +0000
@@ -765,7 +765,7 @@ out:
 static int do_suspend(struct dm_ioctl *param)
 {
 	int r = 0;
-	int do_lockfs = 1;
+	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -773,10 +773,10 @@ static int do_suspend(struct dm_ioctl *p
 		return -ENXIO;
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
-		do_lockfs = 0;
+		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 
 	if (!dm_suspended(md))
-		r = dm_suspend(md, do_lockfs);
+		r = dm_suspend(md, suspend_flags);
 
 	if (!r)
 		r = __dev_status(md, param);
@@ -788,7 +788,7 @@ static int do_suspend(struct dm_ioctl *p
 static int do_resume(struct dm_ioctl *param)
 {
 	int r = 0;
-	int do_lockfs = 1;
+	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map;
@@ -814,9 +814,9 @@ static int do_resume(struct dm_ioctl *pa
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
Index: linux-2.6.19-rc6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.19-rc6.orig/include/linux/device-mapper.h	2006-11-22 17:26:46.000000000 +0000
+++ linux-2.6.19-rc6/include/linux/device-mapper.h	2006-11-22 17:26:57.000000000 +0000
@@ -173,7 +173,7 @@ void *dm_get_mdptr(struct mapped_device 
 /*
  * A device can still be used while suspended, but I/O is deferred.
  */
-int dm_suspend(struct mapped_device *md, int with_lockfs);
+int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
 int dm_resume(struct mapped_device *md);
 
 /*
