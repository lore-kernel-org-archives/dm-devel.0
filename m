From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: hwtable housekeeping 2016-08-01
Date: Mon,  1 Aug 2016 22:06:32 +0200
Message-ID: <1470081992-3522-1-git-send-email-xose.vazquez@gmail.com>
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

Mainly: arrange some families, clean redundant labels, add missing
vendor header and identify some devices.

No new devices added nor functional changes.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 276 ++++++++++++++++++++++++++-----------------------
 1 file changed, 148 insertions(+), 128 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 127275d..837fa3f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -25,16 +25,6 @@
  */
 static struct hwentry default_hw[] = {
 	/*
-	 * Compellent Technologies/DELL
-	 */
-	{
-		.vendor        = "COMPELNT",
-		.product       = "Compellent Vol",
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-	},
-	/*
 	 * Apple
 	 *
 	 * Maintainer : Shyam Sundar
@@ -47,7 +37,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
-	 * StorageWorks/HPE
+	 * HPE
 	 */
 	{
 		.vendor        = "3PARdata",
@@ -59,6 +49,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 	},
 	{
+		/* RA8000/ESA12000 HSG80 */
 		.vendor        = "DEC",
 		.product       = "HSG80",
 		.features      = "1 queue_if_no_path",
@@ -69,6 +60,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_HP_SW,
 	},
 	{
+		/* VIRTUAL ARRAY 7400 */
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.pgpolicy      = MULTIBUS,
@@ -109,7 +101,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP MSA2000 family with old firmware */
+		/* MSA2000 family with old firmware */
 		.vendor        = "HP",
 		.product       = "(MSA2[02]12fc|MSA2012i)",
 		.pgpolicy      = MULTIBUS,
@@ -118,7 +110,7 @@ static struct hwentry default_hw[] = {
 		.minio         = 100,
 	},
 	{
-		/* HP MSA2000 family with new firmware */
+		/* MSA2000 family with new firmware */
 		.vendor        = "HP",
 		.product       = "(MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -128,7 +120,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP MSA 1040/2040 family */
+		/* MSA 1040/2040 family */
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -138,7 +130,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP SVSP */
+		/* SAN Virtualization Services Platform */
 		.vendor        = "HP",
 		.product       = "HSVX700",
 		.hwhandler     = "1 alua",
@@ -149,7 +141,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* HP Smart Array */
+		/* Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
 		.pgpolicy      = MULTIBUS,
@@ -157,7 +149,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 	},
 	{
-		/* HP P2000 family */
+		/* P2000 family */
 		.vendor        = "HP",
 		.product       = "(P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -167,7 +159,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * DDN
+	 * DataDirect Networks
 	 */
 	{
 		.vendor        = "DDN",
@@ -217,6 +209,56 @@ static struct hwentry default_hw[] = {
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
+		.pgfailback    = FAILBACK_UNDEF,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
+	{
+		/* MD3000 */
+		.vendor        = "DELL",
+		.product       = "MD3000",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
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
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
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
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	/*
 	 * Fujitsu
 	 */
 	{
@@ -234,6 +276,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		/* FibreCAT S80 */
+		.vendor        = "EUROLOGC",
+		.product       = "FC2502",
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+	},
 	/*
 	 * Hitachi
 	 *
@@ -507,54 +556,15 @@ static struct hwentry default_hw[] = {
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
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
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
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
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
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-	},
-	/*
-	 * NETAPP ONTAP family
-	 *
-	 * Maintainer : Martin George
-	 * Mail : marting@netapp.com
+	 * NetApp
 	 */
 	{
+		/*
+		 * ONTAP family
+		 *
+		 * Maintainer : Martin George
+		 * Mail : marting@netapp.com
+		 */
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
@@ -575,8 +585,26 @@ static struct hwentry default_hw[] = {
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
 	},
+	{
+		/*
+		 * RDAC family
+		 *
+		 * Maintainer : Sean Stewart
+		 * Mail : sean.stewart@netapp.com
+		 */
+		.vendor        = "(NETAPP|LSI|ENGENIO)",
+		.product       = "INF-01-00",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
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
@@ -591,19 +619,6 @@ static struct hwentry default_hw[] = {
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
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.prio_name     = PRIO_ALUA,
-	},
-	/*
 	 * SGI
 	 */
 	{
@@ -624,6 +639,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
+		/* InfiniteStorage */
 		.vendor        = "SGI",
 		.product       = "IS.*",
 		.bl_product    = "Universal Xport",
@@ -648,9 +664,23 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
-	 * STK/Oracle
+	 * Oracle
 	 */
 	{
+		/*
+		 * Pillar Data / Oracle FS
+		 *
+		 * Maintainer : Srinivasan Ramani
+		 * Mail : srinivas.ramani@oracle.com
+		 */
+		.vendor        = "Pillar",
+		.product       = "Axiom.*",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+	},
+		/* StorageTek */
+	{
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
 		.bl_product    = "Universal Xport",
@@ -660,9 +690,18 @@ static struct hwentry default_hw[] = {
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
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+		/* SUN */
 	{
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
@@ -680,26 +719,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 	},
 	{
-		.vendor        = "EUROLOGC",
-		.product       = "FC2502",
-		.pgpolicy      = MULTIBUS,
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
+		/* 6140 */
 		.vendor        = "SUN",
 		.product       = "CSM200_R",
 		.bl_product    = "Universal Xport",
@@ -710,8 +730,8 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* SUN/LSI 2510, 2540, 2530, 2540 */
 	{
+		/* 2510 / 2540 / 2530 / 2540 */
 		.vendor        = "SUN",
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
@@ -722,7 +742,6 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* StorageTek 6180 */
 	{
 		.vendor        = "SUN",
 		.product       = "SUN_6180",
@@ -734,34 +753,23 @@ static struct hwentry default_hw[] = {
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
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 30,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-	},
-	{
-		.vendor        = "STK",
-		.product       = "FLEXLINE 380",
-		.bl_product    = "Universal Xport",
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
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
@@ -771,6 +779,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * Linux-IO Target
+	 */
 	{
 		.vendor	       = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
@@ -781,6 +792,9 @@ static struct hwentry default_hw[] = {
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * DataCore
+	 */
 	{
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
@@ -797,6 +811,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * Pure Storage
+	 */
 	{
 		.vendor        = "PURE",
 		.product       = "FlashArray",
@@ -806,6 +823,9 @@ static struct hwentry default_hw[] = {
 		.fast_io_fail  = 10,
 		.dev_loss      = 60,
 	},
+	/*
+	 * Huawei
+	 */
 	{
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
-- 
2.7.4
