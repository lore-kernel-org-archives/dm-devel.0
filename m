From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: move Nimble and SGI to HPE
	section
Date: Thu,  8 Mar 2018 00:09:59 +0100
Message-ID: <20180307231000.5255-1-xose.vazquez@gmail.com>
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

They were absorbed by HPE time ago.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 106 ++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 55 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6ba70c8..65b7835 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -221,6 +221,57 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		/* Nimble Storage */
+		.vendor        = "Nimble",
+		.product       = "Server",
+		.hwhandler     = "1 alua",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
+		/* SGI */
+	{
+		.vendor        = "SGI",
+		.product       = "TP9100",
+		.pgpolicy      = MULTIBUS,
+	},
+	{
+		/* Total Performance family */
+		.vendor        = "SGI",
+		.product       = "TP9[3457]00",
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
+		/* InfiniteStorage family */
+		.vendor        = "SGI",
+		.product       = "IS",
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
+		/* DDN */
+		.vendor        = "SGI",
+		.product       = "^DD[46]A-",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
 	/*
 	 * DataDirect Networks
 	 */
@@ -706,49 +757,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.no_path_retry = 30,
 	},
-	/*
-	 * SGI
-	 */
-	{
-		.vendor        = "SGI",
-		.product       = "TP9100",
-		.pgpolicy      = MULTIBUS,
-	},
-	{
-		/* Total Performance family */
-		.vendor        = "SGI",
-		.product       = "TP9[3457]00",
-		.bl_product    = "Universal Xport",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.checker_name  = RDAC,
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.prio_name     = PRIO_RDAC,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 30,
-	},
-	{
-		/* InfiniteStorage family */
-		.vendor        = "SGI",
-		.product       = "IS",
-		.bl_product    = "Universal Xport",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.checker_name  = RDAC,
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.prio_name     = PRIO_RDAC,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 30,
-	},
-	{
-		/* DDN */
-		.vendor        = "SGI",
-		.product       = "^DD[46]A-",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.prio_name     = PRIO_ALUA,
-		.no_path_retry = 30,
-	},
 	/*
 	 * NEC
 	 */
@@ -1013,18 +1021,6 @@ static struct hwentry default_hw[] = {
 		.fast_io_fail  = 15,
 		.dev_loss      = 15,
 	},
-	/*
-	 * Nimble Storage
-	 */
-	{
-		.vendor        = "Nimble",
-		.product       = "Server",
-		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.prio_name     = PRIO_ALUA,
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-	},
 	/*
 	 * Kaminario
 	 */
-- 
2.14.3
