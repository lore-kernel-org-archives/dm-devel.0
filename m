From: y00378701 <yangjie65@huawei.com>
Subject: [PATCH 2/2] multipath-tools: output more topology info
	for NVMe discovery
Date: Thu, 12 Oct 2017 15:35:30 +0800
Message-ID: <1507793730-13400-1-git-send-email-yangjie65@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: guanjunxiong@huawei.com, niuhaoxin@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Assign sg_id.channel to controller id of the NVMe/NVMf target
and assign sg_id.lun to namespace ID of the target.

Signed-off-by: Jie Yang yangjie65@huawei.com
Reviewed-by: Guan Junxiong guanjunxiong@huawei.com
---
 libmultipath/discovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index efac824..f1d303e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1206,12 +1206,14 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 		   &pp->sg_id.scsi_id) != 2)
 		return 1;
 	pp->sg_id.channel = 0;
-	pp->sg_id.lun = 0;
+	pp->sg_id.lun = atoi(udev_device_get_sysattr_value(pp->udev, "nsid"));
 
 	parent = udev_device_get_parent(pp->udev);
 	if (!parent)
 		return 1;
 
+	pp->sg_id.channel = atoi(udev_device_get_sysattr_value(parent, "cntlid"));
+
 	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
 	snprintf(pp->product_id, SCSI_PRODUCT_SIZE, "%s",
 		 udev_device_get_sysattr_value(parent, "model"));
-- 
2.8.1.windows.1
