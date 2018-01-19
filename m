From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] libmultipath: ignore natively multipathed
	NVME devices
Date: Fri, 19 Jan 2018 01:19:43 +0100
Message-ID: <20180119001944.9565-2-mwilck@suse.com>
References: <20180119001944.9565-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119001944.9565-1-mwilck@suse.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Such devices have a parent with SUBSYSTEM="nvme-subsystem", not "nvme".
Furthermore, avoid a possible segfaults NULL checks.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9b22bd94e491..88fc8d732258 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1200,6 +1200,7 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
+	const char *attr;
 
 	attr_path = udev_device_get_sysname(pp->udev);
 	if (!attr_path)
@@ -1209,14 +1210,17 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 		   &pp->sg_id.host_no,
 		   &pp->sg_id.scsi_id) != 2)
 		return 1;
-	pp->sg_id.channel = 0;
-	pp->sg_id.lun = atoi(udev_device_get_sysattr_value(pp->udev, "nsid"));
 
-	parent = udev_device_get_parent(pp->udev);
+	parent = udev_device_get_parent_with_subsystem_devtype(pp->udev,
+							       "nvme", NULL);
 	if (!parent)
 		return 1;
 
-	pp->sg_id.channel = atoi(udev_device_get_sysattr_value(parent, "cntlid"));
+	attr = udev_device_get_sysattr_value(pp->udev, "nsid");
+	pp->sg_id.lun = attr ? atoi(attr) : 0;
+
+	attr = udev_device_get_sysattr_value(parent, "cntlid");
+	pp->sg_id.channel = attr ? atoi(attr) : 0;
 
 	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
 	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s",
-- 
2.15.1
