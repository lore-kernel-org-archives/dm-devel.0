From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH] multipath-tools: don't discard uevent for
	NVMe-Fabrics device
Date: Thu, 13 Jul 2017 15:47:03 +0800
Message-ID: <1499932023-29852-1-git-send-email-guanjunxiong@huawei.com>
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
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com, mwilck@suse.com, keith.busch@intel.com
Cc: philip.yang@huawei.com, zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

The devpath of uevent of NVMe-Fabrics device is like this
"../devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n1" which
doesn't contains the "/block/" string. So when new uvents
of such nvme devices arise, the multipathd daemon still ignores
them, which results the DM-multipath doesn't update the table.
This patch fixes this by introducing a new helper to filter
"/block/" and "nvme-fabrics/ctl".

Signed-off-by: Junxiong Guan <guanjunxiong@huawei.com>
---
 libmultipath/uevent.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 4fbd1dfb..09b86be3 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -143,25 +143,47 @@ uevent_need_merge(void)
 	return need_merge;
 }
 
+static char *uevent_devpath_filter(const char *devpath, const char *filter_str)
+{
+	char *tmp = strstr(devpath, filter_str);
+
+	if (tmp == NULL) {
+		condlog(4, "no '%s' in '%s'", filter_str, devpath);
+		return NULL;
+	}
+	tmp += strlen(filter_str);
+	if (*tmp == '\0')
+		/* just ".../filter_str/" - discard */
+		return NULL;
+
+	return tmp;
+}
+
 static bool
 uevent_can_discard_by_devpath(const char *devpath)
 {
 	static const char BLOCK[] = "/block/";
-	const char *tmp = strstr(devpath, BLOCK);
+	static const char NVME_FABRICS[] = "/nvme-fabrics/ctl/";
+	int flag_nvmf = 0;
+	char *tmp = NULL;
 
+	tmp = uevent_devpath_filter(devpath, BLOCK);
 	if (tmp == NULL) {
-		condlog(4, "no /block/ in '%s'", devpath);
-		return true;
+		flag_nvmf = 1;
+		tmp = uevent_devpath_filter(devpath, NVME_FABRICS);
 	}
-	tmp += sizeof(BLOCK) - 1;
-	if (*tmp == '\0')
-		/* just ".../block/" - discard */
+
+	if (tmp == NULL)
 		return true;
 	/*
-	 * If there are more path elements after ".../block/xyz",
-	 * it's a partition - discard it; but don't discard ".../block/sda/".
+	 * For BLOCK, if there are more path elements after ".../block/sda",
+	 * it's a partition - discard it; or else keep ".../block/sda/".
+	 * For NVME_FABRICS, don't discard "../nvme-fabrics/ctl/nvme0/nvme0n1".
 	 */
 	tmp = strchr(tmp, '/');
+	if (flag_nvmf && tmp != NULL)
+		tmp = strchr(++tmp, '/');
+
 	return tmp != NULL && *(tmp + 1) != '\0';
 }
 
-- 
2.11.1
