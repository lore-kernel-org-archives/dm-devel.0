From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH] [RESEND] hwtable: Add vendor ID and update
 defaults for NetApp E-Series storage
Date: Fri, 29 Mar 2013 18:25:27 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF21FF92518@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

Attempting to resend because it did not seem to go through after several hours.  Please disregard if both went through.
This patch provides hwtable updates for NETAPP/LSI/ENGENIO E-Series arrays, utilizing new features to detect TPGS support, automatically.

Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>

---
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index 4d485a5..2e5500c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1135,9 +1135,13 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* LSI/Engenio/NetApp E-Series RDAC storage */
+	/* LSI/Engenio/NetApp E-Series RDAC storage
+	 *
+	 * Maintainer : Sean Stewart
+	 * Mail : sean.stewart@netapp.com
+	 */
 	{
-		.vendor        = "(LSI|ENGENIO)",
+		.vendor        = "(NETAPP|LSI|ENGENIO)",
 		.product       = "INF-01-00",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
@@ -1145,12 +1149,14 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 15,
+		.no_path_retry = 30,
 		.minio         = DEFAULT_MINIO,
 		.minio_rq      = DEFAULT_MINIO_RQ,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 		.prio_args     = NULL,
+		.detect_prio   = DETECT_PRIO_ON,
+		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 	},
 	{
 		.vendor        = "STK",

--
