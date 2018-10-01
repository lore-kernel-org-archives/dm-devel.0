From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] libmultipath: allow sysfs_pathinfo to return
	SKIPPED
Date: Mon,  1 Oct 2018 20:45:06 +0200
Message-ID: <20181001184507.4162-2-mwilck@suse.com>
References: <20181001184507.4162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181001184507.4162-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The sysfs_pathinfo() code path can't distinguish between real
failure and a devices that have to be skipped. One example
for this are NVMe native multipath devices. This may cause
lots of irritating log messages.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 86 +++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0b1855dd..0d94b333 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1156,20 +1156,20 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 		parent = udev_device_get_parent(parent);
 	}
 	if (!attr_path || pp->sg_id.host_no == -1)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
-		return 1;
+		return PATHINFO_FAILED;;
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
 	if (sysfs_get_model(parent, pp->product_id, PATH_PRODUCT_SIZE) <= 0)
-		return 1;
+		return PATHINFO_FAILED;;
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
 	if (sysfs_get_rev(parent, pp->rev, PATH_REV_SIZE) < 0)
-		return 1;
+		return PATHINFO_FAILED;;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
@@ -1192,12 +1192,12 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 	 * target node name
 	 */
 	if(sysfs_get_tgt_nodename(pp, pp->tgt_node_name))
-		return 1;
+		return PATHINFO_FAILED;
 
 	condlog(3, "%s: tgt_node_name = %s",
 		pp->dev, pp->tgt_node_name);
 
-	return 0;
+	return PATHINFO_OK;
 }
 
 static int
@@ -1209,17 +1209,17 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 
 	attr_path = udev_device_get_sysname(pp->udev);
 	if (!attr_path)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (sscanf(attr_path, "nvme%dn%d",
 		   &pp->sg_id.host_no,
 		   &pp->sg_id.scsi_id) != 2)
-		return 1;
+		return PATHINFO_FAILED;
 
 	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev,
 							       "nvme", NULL);
 	if (!parent)
-		return 1;
+		return PATHINFO_SKIPPED;
 
 	attr = udev_device_get_sysattr_value(pp->udev, "nsid");
 	pp->sg_id.lun = attr ? atoi(attr) : 0;
@@ -1242,7 +1242,7 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 
 	find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL, pp->hwe);
 
-	return 0;
+	return PATHINFO_OK;
 }
 
 static int
@@ -1260,14 +1260,14 @@ ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
 		parent = udev_device_get_parent(parent);
 	}
 	if (!parent)
-		return 1;
+		return PATHINFO_FAILED;
 
 	sprintf(pp->vendor_id, "IBM");
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
 	if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE) <= 0)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (!strncmp(attr_buff, "3370", 4)) {
 		sprintf(pp->product_id,"S/390 DASD FBA");
@@ -1301,7 +1301,7 @@ ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
 			pp->sg_id.lun);
 	}
 
-	return 0;
+	return PATHINFO_OK;
 }
 
 static int
@@ -1325,20 +1325,20 @@ cciss_sysfs_pathinfo (struct path * pp, vector hwtable)
 		parent = udev_device_get_parent(parent);
 	}
 	if (!attr_path || pp->sg_id.host_no == -1)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
-		return 1;
+		return PATHINFO_FAILED;
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
 	if (sysfs_get_model(parent, pp->product_id, PATH_PRODUCT_SIZE) <= 0)
-		return 1;
+		return PATHINFO_FAILED;
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
 	if (sysfs_get_rev(parent, pp->rev, PATH_REV_SIZE) <= 0)
-		return 1;
+		return PATHINFO_FAILED;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
@@ -1358,7 +1358,8 @@ cciss_sysfs_pathinfo (struct path * pp, vector hwtable)
 		pp->sg_id.channel,
 		pp->sg_id.scsi_id,
 		pp->sg_id.lun);
-	return 0;
+
+	return PATHINFO_OK;
 }
 
 static int
@@ -1367,11 +1368,11 @@ common_sysfs_pathinfo (struct path * pp)
 	dev_t devt;
 
 	if (!pp)
-		return 1;
+		return PATHINFO_FAILED;
 
 	if (!pp->udev) {
 		condlog(4, "%s: udev not initialised", pp->dev);
-		return 1;
+		return PATHINFO_FAILED;
 	}
 	devt = udev_device_get_devnum(pp->udev);
 	snprintf(pp->dev_t, BLK_DEV_SIZE, "%d:%d", major(devt), minor(devt));
@@ -1379,11 +1380,11 @@ common_sysfs_pathinfo (struct path * pp)
 	condlog(3, "%s: dev_t = %s", pp->dev, pp->dev_t);
 
 	if (sysfs_get_size(pp, &pp->size))
-		return 1;
+		return PATHINFO_FAILED;
 
 	condlog(3, "%s: size = %llu", pp->dev, pp->size);
 
-	return 0;
+	return PATHINFO_OK;
 }
 
 int
@@ -1461,8 +1462,10 @@ path_offline (struct path * pp)
 int
 sysfs_pathinfo(struct path * pp, vector hwtable)
 {
-	if (common_sysfs_pathinfo(pp))
-		return 1;
+	int r = common_sysfs_pathinfo(pp);
+
+	if (r != PATHINFO_OK)
+		return r;
 
 	pp->bus = SYSFS_BUS_UNDEF;
 	if (!strncmp(pp->dev,"cciss",5))
@@ -1474,22 +1477,19 @@ sysfs_pathinfo(struct path * pp, vector hwtable)
 	if (!strncmp(pp->dev,"nvme", 4))
 		pp->bus = SYSFS_BUS_NVME;
 
-	if (pp->bus == SYSFS_BUS_UNDEF)
-		return 0;
-	else if (pp->bus == SYSFS_BUS_SCSI) {
-		if (scsi_sysfs_pathinfo(pp, hwtable))
-			return 1;
-	} else if (pp->bus == SYSFS_BUS_CCW) {
-		if (ccw_sysfs_pathinfo(pp, hwtable))
-			return 1;
-	} else if (pp->bus == SYSFS_BUS_CCISS) {
-		if (cciss_sysfs_pathinfo(pp, hwtable))
-			return 1;
-	} else if (pp->bus == SYSFS_BUS_NVME) {
-		if (nvme_sysfs_pathinfo(pp, hwtable))
-			return 1;
+	switch (pp->bus) {
+	case SYSFS_BUS_SCSI:
+		return scsi_sysfs_pathinfo(pp, hwtable);
+	case SYSFS_BUS_CCW:
+		return ccw_sysfs_pathinfo(pp, hwtable);
+	case SYSFS_BUS_CCISS:
+		return cciss_sysfs_pathinfo(pp, hwtable);
+	case SYSFS_BUS_NVME:
+		return nvme_sysfs_pathinfo(pp, hwtable);
+	case SYSFS_BUS_UNDEF:
+	default:
+		return PATHINFO_OK;
 	}
-	return 0;
 }
 
 static int
@@ -1882,8 +1882,12 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	/*
 	 * fetch info available in sysfs
 	 */
-	if (mask & DI_SYSFS && sysfs_pathinfo(pp, conf->hwtable))
-		return PATHINFO_FAILED;
+	if (mask & DI_SYSFS) {
+		int rc = sysfs_pathinfo(pp, conf->hwtable);
+
+		if (rc != PATHINFO_OK)
+			return rc;
+	}
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		if (filter_device(conf->blist_device, conf->elist_device,
-- 
2.19.0
