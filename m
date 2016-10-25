From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add StorageTek BladeStore to
	hwtable
Date: Wed, 26 Oct 2016 01:25:28 +0200
Message-ID: <20161025232528.7228-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0199bf8..8c3eff7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -725,6 +725,19 @@ static struct hwentry default_hw[] = {
 	},
 		/* Sun - StorageTek */
 	{
+		/* B210, B220, B240 and B280 */
+		.vendor        = "STK",
+		.product       = "BladeCtlr",
+		.bl_product    = "Universal Xport",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.checker_name  = RDAC,
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.prio_name     = PRIO_RDAC,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 30,
+	},
+	{
 		/* 9176, D173, D178, D210, D220, D240 and D280 */
 		.vendor        = "STK",
 		.product       = "OPENstorage",
-- 
2.10.1
