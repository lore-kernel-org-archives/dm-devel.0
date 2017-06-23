From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: move up TEMPLATE in hwtable
Date: Fri, 23 Jun 2017 23:13:51 +0200
Message-ID: <20170623211351.31830-1-xose.vazquez@gmail.com>
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

and the 'MD Series' comment to the right place.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 98 +++++++++++++++++++++++++-------------------------
 1 file changed, 50 insertions(+), 48 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 390d143..a77da7e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -26,6 +26,55 @@
  * Moreover, if a device needs a special treatment by the SCSI
  * subsystem it should be included in drivers/scsi/scsi_devinfo.c
  */
+
+#if 0
+	/*
+	 * Copy this TEMPLATE to add new hardware.
+	 *
+	 * Keep only mandatory(.vendor and .product) and modified attributes.
+	 * Attributes with default values must be removed.
+	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex.
+	 *
+	 * COMPANY_NAME
+	 *
+	 * Maintainer : XXX
+	 * Mail : XXX
+	 */
+	{
+		/* If product-ID is different from marketing name add a comment */
+		.vendor        = "VENDOR",
+		.product       = "PRODUCT",
+		.revision      = "REVISION",
+		.bl_product    = "BL_PRODUCT",
+		.pgpolicy      = FAILOVER,
+		.uid_attribute = "ID_SERIAL",
+		.selector      = "service-time 0",
+		.checker_name  = TUR,
+		.alias_prefix  = "mpath",
+		.features      = "0",
+		.hwhandler     = "0",
+		.prio_name     = PRIO_CONST,
+		.prio_args     = "",
+		.pgfailback    = -FAILBACK_MANUAL,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = 1000,
+		.minio_rq      = 1,
+		.flush_on_last_del = FLUSH_DISABLED,
+		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
+		.fast_io_fail  = 5,
+		.dev_loss      = 600,
+		.retain_hwhandler = RETAIN_HWHANDLER_ON,
+		.detect_prio   = DETECT_PRIO_ON,
+		.detect_checker = DETECT_CHECKER_ON,
+		.deferred_remove = DEFERRED_REMOVE_OFF,
+		.delay_watch_checks = DELAY_CHECKS_OFF,
+		.delay_wait_checks = DELAY_CHECKS_OFF,
+		.skip_kpartx   = SKIP_KPARTX_OFF,
+		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
+	},
+#endif
+
 static struct hwentry default_hw[] = {
 	/*
 	 * Apple
@@ -224,8 +273,8 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
-		/* MD Series */
 	{
+		/* MD Series */
 		.vendor        = "DELL",
 		.product       = "^MD3",
 		.bl_product    = "Universal Xport",
@@ -1059,53 +1108,6 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
-#if 0
-	/*
-	 * Copy this TEMPLATE to add new hardware.
-	 *
-	 * Keep only mandatory(.vendor and .product) and modified attributes.
-	 * Attributes with default values must be removed.
-	 * .vendor, .product, .revision and .bl_product are POSIX Extended regex.
-	 *
-	 * COMPANY_NAME
-	 *
-	 * Maintainer : XXX
-	 * Mail : XXX
-	 */
-	{
-		/* If product-ID is different from marketing name add a comment */
-		.vendor        = "VENDOR",
-		.product       = "PRODUCT",
-		.revision      = "REVISION",
-		.bl_product    = "BL_PRODUCT",
-		.pgpolicy      = FAILOVER,
-		.uid_attribute = "ID_SERIAL",
-		.selector      = "service-time 0",
-		.checker_name  = TUR,
-		.alias_prefix  = "mpath",
-		.features      = "0",
-		.hwhandler     = "0",
-		.prio_name     = PRIO_CONST,
-		.prio_args     = "",
-		.pgfailback    = -FAILBACK_MANUAL,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = 1000,
-		.minio_rq      = 1,
-		.flush_on_last_del = FLUSH_DISABLED,
-		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
-		.fast_io_fail  = 5,
-		.dev_loss      = 600,
-		.retain_hwhandler = RETAIN_HWHANDLER_ON,
-		.detect_prio   = DETECT_PRIO_ON,
-		.detect_checker = DETECT_CHECKER_ON,
-		.deferred_remove = DEFERRED_REMOVE_OFF,
-		.delay_watch_checks = DELAY_CHECKS_OFF,
-		.delay_wait_checks = DELAY_CHECKS_OFF,
-		.skip_kpartx = SKIP_KPARTX_OFF,
-		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
-	},
-#endif
 	/*
 	 * EOL
 	 */
-- 
2.13.1
