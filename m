From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/5] multipath-tools: hwtable housekeeping
Date: Sat, 23 Jul 2016 02:29:12 +0200
Message-ID: <1469233752-11708-5-git-send-email-xose.vazquez@gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
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

Mainly: arrange some families, clean redundant labels, detail IBM devices,
add remaining attributes to last member(NULL) and add missing vendor labels.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 299 +++++++++++++++++++++++++++----------------------
 1 file changed, 162 insertions(+), 137 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 44fc309..1efaeee 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -25,15 +25,6 @@
  */
 static struct hwentry default_hw[] = {
 	/*
-	 * Compellent Technologies/DELL
-	 */
-	{
-		.vendor        = "COMPELNT",
-		.product       = "Compellent Vol",
-		.pgpolicy      = MULTIBUS,
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-	},
-	/*
 	 * Apple
 	 *
 	 * Maintainer : Shyam Sundar
@@ -46,7 +37,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
-	 * StorageWorks/HPE
+	 * HPE
 	 */
 	{
 		.vendor        = "3PARdata",
@@ -99,7 +90,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP MSA2000 family with old firmware */
+		/* MSA2000 family with old firmware */
 		.vendor        = "HP",
 		.product       = "(MSA2[02]12fc|MSA2012i)",
 		.pgpolicy      = MULTIBUS,
@@ -107,7 +98,7 @@ static struct hwentry default_hw[] = {
 		.minio         = 100,
 	},
 	{
-		/* HP MSA2000 family with new firmware */
+		/* MSA2000 family with new firmware */
 		.vendor        = "HP",
 		.product       = "(MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME)",
 		.no_path_retry = 18,
@@ -115,7 +106,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP MSA 1040/2040 family */
+		/* MSA 1040/2040 family */
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
 		.no_path_retry = 18,
@@ -123,7 +114,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP SVSP */
+		/* SVSP */
 		.vendor        = "HP",
 		.product       = "HSVX700",
 		.hwhandler     = "1 alua",
@@ -132,7 +123,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP Smart Array */
+		/* Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
 		.pgpolicy      = MULTIBUS,
@@ -140,7 +131,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 	},
 	{
-		/* HP P2000 family */
+		/* P2000 family */
 		.vendor        = "HP",
 		.product       = "(P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI)",
 		.no_path_retry = 18,
@@ -148,7 +139,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * DDN
+	 * DataDirect Networks
 	 */
 	{
 		.vendor        = "DDN",
@@ -196,6 +187,49 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
+	 * DELL
+	 */
+	{
+		/* Compellent family */
+		.vendor        = "COMPELNT",
+		.product       = "Compellent Vol",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
+	{
+		/* MD3000 */
+		.vendor        = "DELL",
+		.product       = "MD3000",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+		/* MD32xx/MD36xx */
+		.vendor        = "DELL",
+		.product       = "(MD32xx|MD36xx)",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+		/* MD34xx/MD38xx */
+		.vendor        = "DELL",
+		.product       = "(MD34xx|MD38xx)",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	/*
 	 * Fujitsu
 	 */
 	{
@@ -211,6 +245,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
 	},
+		/* FibreCAT S80 */
+	{
+		.vendor        = "EUROLOGC",
+		.product       = "FC2502",
+		.pgfailback    = FAILBACK_UNDEF,
+	},
 	/*
 	 * Hitachi
 	 *
@@ -242,7 +282,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM FAStT 1722-600 */
+		/* DS4300 / FAStT600 */
 		.vendor        = "IBM",
 		.product       = "^1722-600",
 		.bl_product    = "Universal Xport",
@@ -253,7 +293,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4100 */
+		/* DS4100 / FAStT100 */
 		.vendor        = "IBM",
 		.product       = "^1724",
 		.bl_product    = "Universal Xport",
@@ -264,7 +304,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS3200 / DS3300 / DS3400 */
+		/* DS3200 / DS3300 / DS3400 / Boot DS */
 		.vendor        = "IBM",
 		.product       = "^1726",
 		.bl_product    = "Universal Xport",
@@ -275,7 +315,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4400 / DS4500 / FAStT700 */
+		/* DS4400 / DS4500 / FAStT700 / FAStT900 */
 		.vendor        = "IBM",
 		.product       = "^1742",
 		.bl_product    = "Universal Xport",
@@ -285,6 +325,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
+		/* DS3500 / DS3512 / DS3524 */
 		.vendor        = "IBM",
 		.product       = "^(1745|1746)",
 		.bl_product    = "Universal Xport",
@@ -295,7 +336,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4700 */
+		/* DS3950 / DS4200 / DS4700 / DS5020 */
 		.vendor        = "IBM",
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
@@ -305,7 +346,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4800 */
+		/* DS4800 */
 		.vendor        = "IBM",
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
@@ -315,7 +356,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS5000 */
+		/* DS5000 / DS5100 / DS5300 / DCS3700 */
 		.vendor        = "IBM",
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
@@ -325,7 +366,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM Netfinity Fibre Channel RAID Controller Unit */
+		/* Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
 		.product       = "^3526",
 		.bl_product    = "Universal Xport",
@@ -335,14 +376,14 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		/* IBM DS4200 / FAStT200 */
+		/* DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "^3542",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM ESS F20 aka Shark */
+		/* Enterprise Storage Server / Shark 800 */
 		.vendor        = "IBM",
 		.product       = "^2105800",
 		.features      = "1 queue_if_no_path",
@@ -350,7 +391,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM ESS F20 aka Shark */
+		/* Enterprise Storage Server / Shark F20 */
 		.vendor        = "IBM",
 		.product       = "^2105F20",
 		.features      = "1 queue_if_no_path",
@@ -358,14 +399,14 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM DS6000 */
+		/* DS6000 */
 		.vendor        = "IBM",
 		.product       = "^1750500",
 		.features      = "1 queue_if_no_path",
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM DS8000 */
+		/* DS8000 */
 		.vendor        = "IBM",
 		.product       = "^2107900",
 		.features      = "1 queue_if_no_path",
@@ -373,14 +414,14 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM SAN Volume Controller */
+		/* SAN Volume Controller / Storwize */
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM S/390 ECKD DASD */
+		/* S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product    = "S/390.*",
@@ -390,7 +431,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM S/390 FBA DASD */
+		/* S/390 FBA DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
 		.bl_product    = "S/390.*",
@@ -400,7 +441,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* IBM IPR */
+		/* Power RAID (IPR) */
 		.vendor        = "IBM",
 		.product       = "^IPR.*",
 		.features      = "1 queue_if_no_path",
@@ -408,7 +449,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM RSSM */
+		/* SAS RAID Controller Module (RSSM) */
 		.vendor        = "IBM",
 		.product       = "1820N00",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -416,7 +457,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* IBM XIV Storage System */
+		/* XIV Storage System */
 		.vendor        = "IBM",
 		.product       = "2810XIV",
 		.features      = "1 queue_if_no_path",
@@ -438,7 +479,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
-		/* IBM 3303 NVDISK */
+		/* 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
@@ -453,43 +494,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * DELL
-	 */
-	{
-		/* DELL MD3000 */
-		.vendor        = "DELL",
-		.product       = "MD3000",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-	},
-	{
-		/* DELL MD32xx/MD36xx */
-		.vendor        = "DELL",
-		.product       = "(MD32xx|MD36xx)",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-	},
-	{
-		/* DELL MD34xx/MD38xx */
-		.vendor        = "DELL",
-		.product       = "(MD34xx|MD38xx)",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-	},
-	/*
-	 * NETAPP ONTAP family
+	 * NetApp ONTAP family
 	 *
 	 * Maintainer : Martin George
 	 * Mail : marting@netapp.com
@@ -511,8 +516,23 @@ static struct hwentry default_hw[] = {
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
 	},
+	/* LSI/Engenio/NetApp RDAC family
+	 *
+	 * Maintainer : Sean Stewart
+	 * Mail : sean.stewart@netapp.com
+	 */
+	{
+		.vendor        = "(NETAPP|LSI|ENGENIO)",
+		.product       = "INF-01-00",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.no_path_retry = 30,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
 	/*
-	 * NEXENTA
+	 * Nexenta
 	 *
 	 * Maintainer : Yacine Kheddache
 	 * Mail : yacine@alyseo.com
@@ -526,18 +546,6 @@ static struct hwentry default_hw[] = {
 		.minio         = 128,
 	},
 	/*
-	 * Pillar Data/Oracle
-	 *
-	 * Maintainer : Srinivasan Ramani
-	 * Mail : srinivas.ramani@oracle.com
-	 */
-	{
-		.vendor        = "Pillar",
-		.product       = "Axiom.*",
-		.pgfailback    = FAILBACK_UNDEF,
-		.prio_name     = PRIO_ALUA,
-	},
-	/*
 	 * SGI
 	 */
 	{
@@ -576,9 +584,22 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * STK/Oracle
+	 * Oracle
 	 */
 	{
+		/*
+		 * Pillar Data
+		 *
+		 * Maintainer : Srinivasan Ramani
+		 * Mail : srinivas.ramani@oracle.com
+		 */
+		.vendor        = "Pillar",
+		.product       = "Axiom.*",
+		.pgfailback    = FAILBACK_UNDEF,
+		.prio_name     = PRIO_ALUA,
+	},
+		/* StorageTek */
+	{
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
 		.bl_product    = "Universal Xport",
@@ -586,9 +607,16 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/*
-	 * SUN/Oracle
-	 */
+	{
+		.vendor        = "STK",
+		.product       = "FLEXLINE 380",
+		.bl_product    = "Universal Xport",
+		.hwhandler     = "1 rdac",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+		/* SUN */
 	{
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
@@ -604,25 +632,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		.vendor        = "EUROLOGC",
-		.product       = "FC2502",
-		.pgfailback    = FAILBACK_UNDEF,
-	},
-	/*
-	 * Pivot3
-	 *
-	 * Maintainer : Bart Brooks, Pivot3
-	 * Mail : bartb@pivot3.com
-	 */
-	{
-		.vendor        = "PIVOT3",
-		.product       = "RAIGE VOLUME",
-		.features      = "1 queue_if_no_path",
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
-		.minio         = 100,
-	},
-	{
 		.vendor        = "SUN",
 		.product       = "CSM200_R",
 		.bl_product    = "Universal Xport",
@@ -631,8 +640,8 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* SUN/LSI 2510, 2540, 2530, 2540 */
 	{
+		/* 2510 / 2540 / 2530 / 2540 */
 		.vendor        = "SUN",
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
@@ -641,8 +650,8 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* StorageTek 6180 */
 	{
+		/* StorageTek 6180 */
 		.vendor        = "SUN",
 		.product       = "SUN_6180",
 		.bl_product    = "Universal Xport",
@@ -651,30 +660,23 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* LSI/Engenio/NetApp RDAC
+	/*
+	 * Pivot3
 	 *
-	 * Maintainer : Sean Stewart
-	 * Mail : sean.stewart@netapp.com
+	 * Maintainer : Bart Brooks, Pivot3
+	 * Mail : bartb@pivot3.com
 	 */
 	{
-		.vendor        = "(NETAPP|LSI|ENGENIO)",
-		.product       = "INF-01-00",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.no_path_retry = 30,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-	},
-	{
-		.vendor        = "STK",
-		.product       = "FLEXLINE 380",
-		.bl_product    = "Universal Xport",
-		.hwhandler     = "1 rdac",
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
+		.vendor        = "PIVOT3",
+		.product       = "RAIGE VOLUME",
+		.features      = "1 queue_if_no_path",
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.minio         = 100,
 	},
+	/*
+	 * Intel
+	 */
 	{
 		.vendor	       = "Intel",
 		.product       = "Multi-Flex",
@@ -682,6 +684,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * Linux-IO Target
+	 */
 	{
 		.vendor	       = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
@@ -690,6 +695,9 @@ static struct hwentry default_hw[] = {
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * DataCore
+	 */
 	{
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
@@ -702,6 +710,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * Pure Storage
+	 */
 	{
 		.vendor        = "PURE",
 		.product       = "FlashArray",
@@ -710,6 +721,9 @@ static struct hwentry default_hw[] = {
 		.fast_io_fail  = 10,
 		.dev_loss      = 60,
 	},
+	/*
+	 * Huawei
+	 */
 	{
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
@@ -804,18 +818,29 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = NULL,
 		.product       = NULL,
+		.revision      = NULL,
+		.bl_product    = NULL,
+		.pgpolicy      = 0,
+		.uid_attribute = NULL,
+		.selector      = NULL,
+		.checker_name  = NULL,
 		.features      = NULL,
 		.hwhandler     = NULL,
-		.selector      = NULL,
-		.pgpolicy      = 0,
+		.prio_name     = NULL,
+		.prio_args     = NULL,
 		.pgfailback    = 0,
 		.rr_weight     = 0,
 		.no_path_retry = 0,
 		.minio         = 0,
 		.minio_rq      = 0,
-		.checker_name  = NULL,
-		.prio_name     = NULL,
-		.prio_args     = NULL,
+		.flush_on_last_del = 0,
+		.fast_io_fail  = 0,
+		.dev_loss      = 0,
+		.retain_hwhandler = NULL,
+		.detect_prio   = NULL,
+		.deferred_remove = NULL,
+		.delay_watch_checks = 0,
+		.delay_wait_checks = 0,
 	},
 };
 
-- 
2.7.4
