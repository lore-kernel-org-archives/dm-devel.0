From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 5/7] dm: add 'DM_NOFLUSH_FLAG' ioctl option for
	suspend
Date: Tue, 10 Oct 2006 17:31:26 -0400 (EDT)
Message-ID: <20061010.173126.28782074.k-ueda@ct.jp.nec.com>
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

This patch adds ioctl option for noflush suspending.
As the interface is extended, the version number is incremented.
Should have no effect on the behavior.


Test results:
Confirmed the option is given from user-space correctly.


The patch is for:
    2.6.18-mm2 + patch 1-4

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 4-target-rval-iface-change/drivers/md/dm.h 5-add-noflush-ioctl-opt/drivers/md/dm.h
--- 4-target-rval-iface-change/drivers/md/dm.h	2006-10-05 10:45:08.000000000 -0400
+++ 5-add-noflush-ioctl-opt/drivers/md/dm.h	2006-10-05 10:54:03.000000000 -0400
@@ -47,6 +47,7 @@
  * Suspend feature flags
  */
 #define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
+#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
 
 /*
  * List of devices that a metadevice uses and should open/close.
diff -rupN 4-target-rval-iface-change/drivers/md/dm-ioctl.c 5-add-noflush-ioctl-opt/drivers/md/dm-ioctl.c
--- 4-target-rval-iface-change/drivers/md/dm-ioctl.c	2006-10-05 10:26:33.000000000 -0400
+++ 5-add-noflush-ioctl-opt/drivers/md/dm-ioctl.c	2006-10-05 10:53:22.000000000 -0400
@@ -769,6 +769,8 @@ static int do_suspend(struct dm_ioctl *p
 
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
 		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+	if (param->flags & DM_NOFLUSH_FLAG)
+		suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 
 	if (!dm_suspended(md))
 		r = dm_suspend(md, suspend_flags);
@@ -810,6 +812,8 @@ static int do_resume(struct dm_ioctl *pa
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
+		if (param->flags & DM_NOFLUSH_FLAG)
+			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 		if (!dm_suspended(md))
 			dm_suspend(md, suspend_flags);
 
diff -rupN 4-target-rval-iface-change/include/linux/dm-ioctl.h 5-add-noflush-ioctl-opt/include/linux/dm-ioctl.h
--- 4-target-rval-iface-change/include/linux/dm-ioctl.h	2006-10-05 10:24:05.000000000 -0400
+++ 5-add-noflush-ioctl-opt/include/linux/dm-ioctl.h	2006-10-05 10:55:10.000000000 -0400
@@ -285,7 +285,7 @@ typedef char ioctl_struct[308];
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	10
+#define DM_VERSION_MINOR	11
 #define DM_VERSION_PATCHLEVEL	0
 #define DM_VERSION_EXTRA	"-ioctl (2006-09-14)"
 
@@ -323,4 +323,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_SKIP_LOCKFS_FLAG	(1 << 10) /* In */
 
+/*
+ * Set this to suspend without flushing queued ios.
+ */
+#define DM_NOFLUSH_FLAG		(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
