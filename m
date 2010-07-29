From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] Add support for dm-mod module autoloading
Date: Thu, 29 Jul 2010 15:02:32 +0200
Message-ID: <4C517BE8.2050004@redhat.com>
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

Add devname:mapper/control and MAPPER_CTRL_MINOR module alias
to support dm-mod module autoloading.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Peter Rajnoha <prajnoha@redhat.com>
---
 Documentation/devices.txt  |    1 +
 drivers/md/dm-ioctl.c      |    7 +++++--
 include/linux/dm-ioctl.h   |    1 +
 include/linux/miscdevice.h |    1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 1d83d12..be55807 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -445,6 +445,7 @@ Your cooperation is appreciated.
 		233 = /dev/kmview	View-OS A process with a view
 		234 = /dev/btrfs-control	Btrfs control device
 		235 = /dev/autofs	Autofs control device
+		236 = /dev/mapper/control	Device-Mapper control device
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 6acca8a..efe6eda 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1592,12 +1592,15 @@ static const struct file_operations _ctl_fops = {
 };
 
 static struct miscdevice _dm_misc = {
-	.minor 		= MISC_DYNAMIC_MINOR,
+	.minor		= MAPPER_CTRL_MINOR,
 	.name  		= DM_NAME,
-	.nodename	= "mapper/control",
+	.nodename	= DM_DIR "/" DM_CONTROL_NODE,
 	.fops  		= &_ctl_fops
 };
 
+MODULE_ALIAS_MISCDEV(MAPPER_CTRL_MINOR);
+MODULE_ALIAS("devname:" DM_DIR "/" DM_CONTROL_NODE);
+
 /*
  * Create misc character device and link to DM_DIR/control.
  */
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index 43b2de1..49eab36 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 
 #define DM_DIR "mapper"		/* Slashes not supported */
+#define DM_CONTROL_NODE "control"
 #define DM_MAX_TYPE_NAME 16
 #define DM_NAME_LEN 128
 #define DM_UUID_LEN 129
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index f6c9b7d..bafffc7 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -38,6 +38,7 @@
 #define KVM_MINOR		232
 #define BTRFS_MINOR		234
 #define AUTOFS_MINOR		235
+#define MAPPER_CTRL_MINOR	236
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
