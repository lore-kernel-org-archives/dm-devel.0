From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 1/4] libmultipath: add rbd discovery
Date: Mon,  8 Aug 2016 07:01:47 -0500
Message-ID: <1470657710-28081-2-git-send-email-mchristi@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

rbd is a block device interface for Ceph. It does not support
any SCSI commands, so this patch adds bus detection and virtual
vendor/product pathinfo.

Changes since v1:
1. Drop ID_UID use and implemented sysfs getuid support.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers.h  |  1 +
 libmultipath/discovery.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/structs.h   |  1 +
 3 files changed, 72 insertions(+)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index ac382d7..8fc8616 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -84,6 +84,7 @@ enum path_check_state {
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
 #define CCISS_TUR    "cciss_tur"
+#define RBD          "rbd"
 
 #define DEFAULT_CHECKER TUR
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1fb4db4..61b389f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1170,6 +1170,21 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 }
 
 static int
+rbd_sysfs_pathinfo (struct path * pp, vector hwtable)
+{
+	sprintf(pp->vendor_id, "Ceph");
+	sprintf(pp->product_id, "RBD");
+
+	condlog(3, "%s: vendor = %s product = %s", pp->dev, pp->vendor_id,
+		pp->product_id);
+	/*
+	 * set the hwe configlet pointer
+	 */
+	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
+	return 0;
+}
+
+static int
 ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	struct udev_device *parent;
@@ -1371,6 +1386,8 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 		pp->bus = SYSFS_BUS_CCW;
 	if (!strncmp(pp->dev,"sd", 2))
 		pp->bus = SYSFS_BUS_SCSI;
+	if (!strncmp(pp->dev,"rbd", 3))
+		pp->bus = SYSFS_BUS_RBD;
 
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
@@ -1383,6 +1400,9 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 	} else if (pp->bus == SYSFS_BUS_CCISS) {
 		if (cciss_sysfs_pathinfo(pp, hwtable))
 			return 1;
+	} else if (pp->bus == SYSFS_BUS_RBD) {
+		if (rbd_sysfs_pathinfo(pp, hwtable))
+			return 1;
 	}
 	return 0;
 }
@@ -1540,6 +1560,53 @@ get_udev_uid(struct path * pp, char *uid_attribute)
 }
 
 static int
+get_rbd_uid(struct path * pp)
+{
+	struct udev_device *rbd_bus_dev;
+	int ret, rbd_bus_id;
+	const char *pool, *image, *snap;
+	char sysfs_path[PATH_SIZE];
+	uint64_t snap_id, max_snap_id = -3;
+
+	ret = sscanf(pp->dev, "rbd%d", &rbd_bus_id);
+	if (ret != 1)
+		return -EINVAL;
+
+	snprintf(sysfs_path, sizeof(sysfs_path), "/sys/bus/rbd/devices/%d",
+		 rbd_bus_id);
+	rbd_bus_dev = udev_device_new_from_syspath(udev, sysfs_path);
+	if (!rbd_bus_dev)
+		return -ENODEV;
+
+	ret = -EINVAL;
+	pool = udev_device_get_sysattr_value(rbd_bus_dev, "pool_id");
+	if (!pool)
+		goto free_dev;
+
+	image = udev_device_get_sysattr_value(rbd_bus_dev, "image_id");
+	if (!image)
+		goto free_dev;
+
+	snap = udev_device_get_sysattr_value(rbd_bus_dev, "snap_id");
+	if (!snap)
+		goto free_dev;
+	snap_id = strtoull(snap, NULL, 19);
+	if (snap_id >= max_snap_id)
+		ret = snprintf(pp->wwid, WWID_SIZE, "%s-%s", pool, image);
+	else
+		ret = snprintf(pp->wwid, WWID_SIZE, "%s-%s-%s", pool,
+			       image, snap);
+	if (ret >= WWID_SIZE) {
+		condlog(0, "%s: wwid overflow", pp->dev);
+		ret = -EOVERFLOW;
+	}
+
+free_dev:
+	udev_device_unref(rbd_bus_dev);
+	return ret;
+}
+
+static int
 get_vpd_uid(struct path * pp)
 {
 	struct udev_device *parent = pp->udev;
@@ -1591,6 +1658,9 @@ get_uid (struct path * pp, int path_state)
 		} else
 			len = strlen(pp->wwid);
 		origin = "callout";
+	} else if (pp->bus == SYSFS_BUS_RBD) {
+		len = get_rbd_uid(pp);
+		origin = "sysfs";
 	} else {
 		int retrigger;
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a87cda6..cb5d532 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -52,6 +52,7 @@ enum sysfs_buses {
 	SYSFS_BUS_IDE,
 	SYSFS_BUS_CCW,
 	SYSFS_BUS_CCISS,
+	SYSFS_BUS_RBD,
 };
 
 enum pathstates {
-- 
2.7.2
