From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH] multipath-tools: check sysfs path state for
	NVMe/NVMf
Date: Fri, 28 Jul 2017 09:28:43 +0800
Message-ID: <1501205323-13440-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, hare@suse.de, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: philip.yang@huawei.com, zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

The previous code of path_offline checking was only valid for SCSI
device. It returned PATH_UP for other devices and throwed path check-
ing to chekers. This patch supplements checking sysfs path state for
NVMe/NVMf devices. For example, if NVMe/NVMf path is reconnectting or
resetting, we return PATH_PENDING in order to skip current path check-
ing and reschedule path checking in the next tick as soon as possible.

Signed-off-by: Guan Junxiong <guanjunxiong@huawei.com>
---
 libmultipath/discovery.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8eaa..b549ce0e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1383,14 +1383,22 @@ path_offline (struct path * pp)
 	struct udev_device * parent;
 	char buff[SCSI_STATE_SIZE];
 	int err;
+	const char *subsys_type;
 
-	if (pp->bus != SYSFS_BUS_SCSI)
+	if (pp->bus == SYSFS_BUS_SCSI) {
+		subsys_type = "scsi";
+	}
+	else if (pp->bus == SYSFS_BUS_NVME) {
+		subsys_type = "nvme";
+	}
+	else {
 		return PATH_UP;
+	}
 
 	parent = pp->udev;
 	while (parent) {
 		const char *subsys = udev_device_get_subsystem(parent);
-		if (subsys && !strncmp(subsys, "scsi", 4))
+		if (subsys && !strncmp(subsys, subsys_type, 4))
 			break;
 		parent = udev_device_get_parent(parent);
 	}
@@ -1412,15 +1420,32 @@ path_offline (struct path * pp)
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
-	if (!strncmp(buff, "offline", 7)) {
-		pp->offline = 1;
-		return PATH_DOWN;
+	if (pp->bus == SYSFS_BUS_SCSI) {
+		if (!strncmp(buff, "offline", 7)) {
+			pp->offline = 1;
+			return PATH_DOWN;
+		}
+		pp->offline = 0;
+		if (!strncmp(buff, "blocked", 7) ||
+		    !strncmp(buff, "quiesce", 7))
+			return PATH_PENDING;
+		else if (!strncmp(buff, "running", 7))
+			return PATH_UP;
+
+	}
+	else if (pp->bus == SYSFS_BUS_NVME) {
+		if (!strncmp(buff, "dead", 4)) {
+			pp->offline = 1;
+			return PATH_DOWN;
+		}
+		pp->offline = 0;
+		if (!strncmp(buff, "new", 3) ||
+		    !strncmp(buff, "reconnecting", 12) ||
+		    !strncmp(buff, "resetting", 9))
+			return PATH_PENDING;
+		else if (!strncmp(buff, "live", 4))
+			return PATH_UP;
 	}
-	pp->offline = 0;
-	if (!strncmp(buff, "blocked", 7) || !strncmp(buff, "quiesce", 7))
-		return PATH_PENDING;
-	else if (!strncmp(buff, "running", 7))
-		return PATH_UP;
 
 	return PATH_DOWN;
 }
-- 
2.11.1
