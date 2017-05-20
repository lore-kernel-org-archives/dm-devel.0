From: Zou Ming <zouming.zouming@huawei.com>
Subject: [PATCH] multipath-tools: delete vendor name HUASY for
	Huawei devices
Date: Sat, 20 May 2017 08:27:02 +0000
Message-ID: <1495268822-18564-1-git-send-email-zouming.zouming@huawei.com>
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
To: dm-devel@redhat.com
Cc: zouming.zouming@huawei.com, guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

For product XSG1,HUASY is obsolete for Huawei devices,Only HUAWEI is the official vendor name.
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 54309ef..bd8719c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -881,7 +881,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		/* OceanStor V3 */
-		.vendor        = "(HUAWEI|HUASY)",
+		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = MULTIBUS,
 	},
-- 
2.6.4.windows.1
