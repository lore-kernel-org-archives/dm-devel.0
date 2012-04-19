From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/12] discovery: Fixup cciss discovery
Date: Thu, 19 Apr 2012 11:09:03 +0200
Message-ID: <1334826546-32039-10-git-send-email-hare@suse.de>
References: <1334826546-32039-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1334826546-32039-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device-mapper Development <dm-devel@redhat.com>
List-Id: dm-devel.ids

We can get the sysfs attributes directly from the parent.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   78 +++++++++++++++++++++++++++------------------
 1 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f45602a..fa8cfa0 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -162,7 +162,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 	int r;
 	unsigned int t;
 
-	if (!pp->udev)
+	if (!pp->udev || pp->bus != SYSFS_BUS_SCSI)
 		return 1;
 
 	parent = pp->udev;
@@ -691,26 +691,56 @@ ccw_sysfs_pathinfo (struct path * pp)
 static int
 cciss_sysfs_pathinfo (struct path * pp)
 {
-	const char * attr_path;
+	const char * attr_path = NULL;
+	struct udev_device *parent;
+
+	parent = pp->udev;
+	while (parent) {
+		if (!strncmp(udev_device_get_subsystem(parent), "cciss", 5)) {
+			attr_path = udev_device_get_sysname(parent);
+			if (!attr_path)
+				break;
+			if (sscanf(attr_path, "c%id%i",
+				   &pp->sg_id.host_no,
+				   &pp->sg_id.scsi_id) == 2)
+				break;
+		}
+		parent = udev_device_get_parent(parent);
+	}
+	if (!attr_path || pp->sg_id.host_no == -1)
+		return 1;
+
+	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
+		return 1;
+
+	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
+
+	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE))
+		return 1;
+
+	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
+
+	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE))
+		return 1;
+
+	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
 	/*
-	 * host / bus / target / lun
+	 * set the hwe configlet pointer
 	 */
-	attr_path = udev_device_get_devpath(pp->udev);
-	if (!attr_path)
-		return 1;
+	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, pp->rev);
 
+	/*
+	 * host / bus / target / lun
+	 */
 	pp->sg_id.lun = 0;
 	pp->sg_id.channel = 0;
-	sscanf(attr_path, "cciss!c%id%i",
-			&pp->sg_id.host_no,
-			&pp->sg_id.scsi_id);
 	condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
-			pp->dev,
-			pp->sg_id.host_no,
-			pp->sg_id.channel,
-			pp->sg_id.scsi_id,
-			pp->sg_id.lun);
+		pp->dev,
+		pp->sg_id.host_no,
+		pp->sg_id.channel,
+		pp->sg_id.scsi_id,
+		pp->sg_id.lun);
 	return 0;
 }
 
@@ -818,23 +848,9 @@ scsi_ioctl_pathinfo (struct path * pp, int mask)
 static int
 cciss_ioctl_pathinfo (struct path * pp, int mask)
 {
-	int ret;
-
-	if (mask & DI_SYSFS) {
-		ret = get_inq(pp->dev, pp->vendor_id, pp->product_id,
-			      pp->rev, pp->fd);
-		if (ret)
-			return ret;
-
-		condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
-		condlog(3, "%s: product = %s", pp->dev, pp->product_id);
-		condlog(3, "%s: revision = %s", pp->dev, pp->rev);
-		/*
-		 * set the hwe configlet pointer
-		 */
-		pp->hwe = find_hwe(conf->hwtable, pp->vendor_id,
-				   pp->product_id, pp->rev);
-
+	if (mask & DI_SERIAL) {
+		get_serial(pp->serial, SERIAL_SIZE, pp->fd);
+		condlog(3, "%s: serial = %s", pp->dev, pp->serial);
 	}
 	return 0;
 }
-- 
1.7.3.4
