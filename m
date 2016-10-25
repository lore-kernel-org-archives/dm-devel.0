From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add support all STK OPENstorage
	rdac arrays
Date: Tue, 25 Oct 2016 14:57:06 +0200
Message-ID: <20161025125706.4131-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

9176, D173, D178, D210, D220, D240 and D280.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1aa9ec3..b56d2bc 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -726,7 +726,7 @@ static struct hwentry default_hw[] = {
 		/* Sun - StorageTek */
 	{
 		.vendor        = "STK",
-		.product       = "OPENstorage D280",
+		.product       = "OPENstorage",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
-- 
2.10.1
