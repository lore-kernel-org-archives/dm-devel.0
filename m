From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 10/10] multipath-tools: group ONTAP family
Date: Fri, 17 Jun 2016 16:52:48 +0200
Message-ID: <1466175169-16684-10-git-send-email-xose.vazquez@gmail.com>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fbfa917..b67568f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -800,41 +800,39 @@ static struct hwentry default_hw[] = {
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
-	/*
-	 * NEXENTA
-	 *
-	 * Maintainer : Yacine Kheddache
-	 * Mail : yacine@alyseo.com
-	 */
 	{
-		.vendor        = "NEXENTA",
-		.product       = "COMSTAR",
+		/* IBM NSeries(NETAPP) */
+		.vendor        = "IBM",
+		.product       = "Nseries.*",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 30,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.checker_name  = DIRECTIO,
-		.prio_name     = DEFAULT_PRIO,
+		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 	},
 	/*
-	 * IBM NSeries (NETAPP)
+	 * NEXENTA
+	 *
+	 * Maintainer : Yacine Kheddache
+	 * Mail : yacine@alyseo.com
 	 */
 	{
-		.vendor        = "IBM",
-		.product       = "Nseries.*",
+		.vendor        = "NEXENTA",
+		.product       = "COMSTAR",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
-		.pgpolicy      = GROUP_BY_PRIO,
+		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 30,
 		.minio         = 128,
 		.checker_name  = DIRECTIO,
-		.prio_name     = PRIO_ONTAP,
+		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
-- 
2.5.5
