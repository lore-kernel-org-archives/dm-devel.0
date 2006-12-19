From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 4/8] rqbased-dm: add ioctl for request-based
 device creation
Date: Tue, 19 Dec 2006 17:12:49 -0500 (EST)
Message-ID: <20061219.171249.105435409.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, agk@redhat.com, mchristi@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds DM_REQUEST_BASE_FLAG ioctl for mapped device creation.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 3-create-iface-change/drivers/md/dm.h 4-add-ioctl/drivers/md/dm.h
--- 3-create-iface-change/drivers/md/dm.h	2006-12-11 14:32:53.000000000 -0500
+++ 4-add-ioctl/drivers/md/dm.h	2006-12-15 10:26:43.000000000 -0500
@@ -33,6 +33,11 @@
 #define SECTOR_SHIFT 9
 
 /*
+ * Create feature flags
+ */
+#define DM_CREATE_REQUEST_BASE_FLAG	(1 << 0)
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev {
diff -rupN 3-create-iface-change/drivers/md/dm-ioctl.c 4-add-ioctl/drivers/md/dm-ioctl.c
--- 3-create-iface-change/drivers/md/dm-ioctl.c	2006-12-15 10:24:52.000000000 -0500
+++ 4-add-ioctl/drivers/md/dm-ioctl.c	2006-12-15 10:26:43.000000000 -0500
@@ -573,6 +573,8 @@ static int dev_create(struct dm_ioctl *p
 
 	if (param->flags & DM_PERSISTENT_DEV_FLAG)
 		m = MINOR(huge_decode_dev(param->dev));
+	if (param->flags & DM_REQUEST_BASE_FLAG)
+		create_flags |= DM_CREATE_REQUEST_BASE_FLAG;
 
 	r = dm_create(m, &md, create_flags);
 	if (r)
diff -rupN 3-create-iface-change/include/linux/dm-ioctl.h 4-add-ioctl/include/linux/dm-ioctl.h
--- 3-create-iface-change/include/linux/dm-ioctl.h	2006-12-11 14:32:53.000000000 -0500
+++ 4-add-ioctl/include/linux/dm-ioctl.h	2006-12-15 10:27:35.000000000 -0500
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
+ * Set this to create request based device-mapper device.
+ */
+#define DM_REQUEST_BASE_FLAG	(1 << 11) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
