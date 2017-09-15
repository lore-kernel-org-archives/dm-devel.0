From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] discovery: sanitize NVMe discovery
Date: Fri, 15 Sep 2017 08:30:27 +0200
Message-ID: <1505457030-119611-2-git-send-email-hare@suse.de>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Bring the output of NVMe discovery inline with the other transports,
and set the sg_id mappings to avoid ugly '#' outputs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3a912d7..95c138b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1194,28 +1194,37 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 static int
 nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
-	struct udev_device *parent, *nvme = NULL;
+	struct udev_device *parent;
+	const char *attr_path = NULL;
 
-	parent = pp->udev;
-	while (parent) {
-		const char *subsys = udev_device_get_subsystem(parent);
+	attr_path = udev_device_get_sysname(pp->udev);
+	if (!attr_path)
+		return 1;
 
-		if (subsys && !strncmp(subsys, "nvme", 4)) {
-			nvme = parent;
-			break;
-		}
-		parent = udev_device_get_parent(parent);
-	}
-	if (!nvme)
+	if (sscanf(attr_path, "nvme%dn%d",
+		   &pp->sg_id.host_no,
+		   &pp->sg_id.scsi_id) != 2)
+		return 1;
+	pp->sg_id.channel = 0;
+	pp->sg_id.lun = 0;
+
+	parent = udev_device_get_parent(pp->udev);
+	if (!parent)
 		return 1;
 
 	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
-	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s", udev_device_get_sysattr_value(nvme, "model"));
-	snprintf(pp->serial, SERIAL_SIZE, "%s", udev_device_get_sysattr_value(nvme, "serial"));
-	snprintf(pp->rev, SCSI_REV_SIZE, "%s", udev_device_get_sysattr_value(nvme, "firmware_rev"));
+	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s",
+		 udev_device_get_sysattr_value(parent, "model"));
+	snprintf(pp->serial, SERIAL_SIZE, "%s",
+		 udev_device_get_sysattr_value(parent, "serial"));
+	snprintf(pp->rev, SCSI_REV_SIZE, "%s",
+		 udev_device_get_sysattr_value(parent, "firmware_rev"));
+
+	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
+	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
+	condlog(3, "%s: serial = %s", pp->dev, pp->serial);
+	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
-	condlog(3, "%s: vendor:%s product:%s serial:%s rev:%s", pp->dev,
-		pp->vendor_id, pp->product_id, pp->serial, pp->rev);
 	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
 
 	return 0;
-- 
1.8.5.6
