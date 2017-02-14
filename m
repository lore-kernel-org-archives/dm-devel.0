From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 2/2] Fill NVMe specific path info
Date: Tue, 14 Feb 2017 16:19:14 -0500
Message-ID: <1487107154-24883-2-git-send-email-keith.busch@intel.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
Pat of this is dependent on udev updates. Pull request sent to systemd here:

  https://github.com/systemd/systemd/pull/5348

Can always add that line by hand in the mean time.

 libmultipath/discovery.c | 36 ++++++++++++++++++++++++++++++++++++
 libmultipath/hwtable.c   |  9 +++++++++
 libmultipath/structs.h   |  1 +
 3 files changed, 46 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d1aec31..db7b04a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1187,6 +1187,37 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 }
 
 static int
+nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
+{
+	struct udev_device *parent, *nvme = NULL;
+
+	parent = pp->udev;
+	while (parent) {
+		const char *subsys = udev_device_get_subsystem(parent);
+
+		if (subsys && !strncmp(subsys, "nvme", 4)) {
+			nvme = parent;
+			break;
+		}
+		parent = udev_device_get_parent(parent);
+	}
+	if (!nvme)
+		return 1;
+
+	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
+	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s", udev_device_get_sysattr_value(nvme, "model"));
+	snprintf(pp->serial, SERIAL_SIZE, "%s", udev_device_get_sysattr_value(nvme, "serial"));
+	snprintf(pp->rev, SCSI_REV_SIZE, "%s", udev_device_get_sysattr_value(nvme, "firmware_rev"));
+	snprintf(pp->wwid, WWID_SIZE, "%s", udev_device_get_sysattr_value(pp->udev, "wwid"));
+
+	condlog(3, "%s: vendor:%s product:%s serial:%s rev:%s wwid:%s", pp->dev,
+		pp->vendor_id, pp->product_id, pp->serial, pp->rev, pp->wwid);
+	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
+
+	return 0;
+}
+
+static int
 rbd_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	sprintf(pp->vendor_id, "Ceph");
@@ -1405,6 +1436,8 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 		pp->bus = SYSFS_BUS_SCSI;
 	if (!strncmp(pp->dev,"rbd", 3))
 		pp->bus = SYSFS_BUS_RBD;
+	if (!strncmp(pp->dev,"nvme", 4))
+		pp->bus = SYSFS_BUS_NVME;
 
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
@@ -1420,6 +1453,9 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 	} else if (pp->bus == SYSFS_BUS_RBD) {
 		if (rbd_sysfs_pathinfo(pp, hwtable))
 			return 1;
+	} else if (pp->bus == SYSFS_BUS_NVME) {
+		if (nvme_sysfs_pathinfo(pp, hwtable))
+			return 1;
 	}
 	return 0;
 }
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f5a5f7b..c55998a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1073,6 +1073,15 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 30,
 	},
+	/*
+	 * Generic NVMe devices
+	 */
+	{
+		.vendor	       = "NVME",
+		.product       = ".*",
+		.uid_attribute = "ID_WWN",
+		.checker_name  = DIRECTIO,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 6edd927..dfd65ae 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -53,6 +53,7 @@ enum sysfs_buses {
 	SYSFS_BUS_CCW,
 	SYSFS_BUS_CCISS,
 	SYSFS_BUS_RBD,
+	SYSFS_BUS_NVME,
 };
 
 enum pathstates {
-- 
2.5.5
