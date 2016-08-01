From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: change .pgpolicy and
	.pgfailback to default values in the template
Date: Mon,  1 Aug 2016 17:31:51 +0200
Message-ID: <1470065511-8373-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d65a353..e95db96 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -875,7 +875,7 @@ static struct hwentry default_hw[] = {
 		.product       = "PRODUCT",
 		.revision      = "REVISION",
 		.bl_product    = "BL_PRODUCT",
-		.pgpolicy      = GROUP_BY_PRIO,
+		.pgpolicy      = FAILOVER,
 		.uid_attribute = "ID_SERIAL",
 		.selector      = "service-time 0",
 		.checker_name  = TUR,
@@ -883,7 +883,7 @@ static struct hwentry default_hw[] = {
 		.hwhandler     = "0",
 		.prio_name     = "const",
 		.prio_args     = "",
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = -FAILBACK_MANUAL,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 1000,
-- 
2.7.4
