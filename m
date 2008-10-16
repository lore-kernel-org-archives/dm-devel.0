From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: [multipath-tools] Add support for couple of IBM
	storage devices
Date: Wed, 15 Oct 2008 17:20:01 -0700
Message-ID: <1224116401.14830.736.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Few of the IBM rdac storage devices are not available in the multipath
tools. This patch adds support for those.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
Index: multipath-tools/libmultipath/hwtable.c
===================================================================
--- multipath-tools.orig/libmultipath/hwtable.c
+++ multipath-tools/libmultipath/hwtable.c
@@ -358,9 +358,9 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS3400 */
+		/* IBM DS4100 */
 		.vendor        = "IBM",
-		.product       = "1726-4xx",
+		.product       = "1724",
 		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
@@ -374,7 +374,23 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4400 / FAStT700 */
+		/* IBM DS3200 / DS3300 / DS3400 */
+		.vendor        = "IBM",
+		.product       = "1726",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 300,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+		/* IBM DS4400 / DS4500 / FAStT700 */
 		.vendor        = "IBM",
 		.product       = "1742",
 		.getuid        = DEFAULT_GETUID,
@@ -422,6 +438,22 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
+	    /* IBM DS5000 */
+		.vendor        = "IBM",
+		.product       = "1818",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
 		/* IBM Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
 		.product       = "3526",
