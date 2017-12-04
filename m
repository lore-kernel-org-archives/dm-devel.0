From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH v2] multipath-tools: output more topology info
	for NVMe discovery
Date: Mon, 4 Dec 2017 21:13:57 +0800
Message-ID: <1512393237-18356-1-git-send-email-guanjunxiong@huawei.com>
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

From: Jie Yang <yangjie65@huawei.com>

Assign sg_id.channel to controller id of the NVMe/NVMf target
and assign sg_id.lun to namespace ID of the target.

Signed-off-by: Jie Yang <yangjie65@huawei.com>
Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>
---


change since V1:
  patch 2/2 --> path V2 becuase this is an independent patch


 libmultipath/discovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index cadf461..4b31dde 100644
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
2.6.4.windows.1
