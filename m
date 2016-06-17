From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 09/10] multipath-tools: clean up comments at
	hwtable.c
Date: Fri, 17 Jun 2016 16:52:47 +0200
Message-ID: <1466175169-16684-9-git-send-email-xose.vazquez@gmail.com>
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

Remove redundant info and update company names.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 67 ++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bef8d31..fbfa917 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -18,7 +18,7 @@
  */
 static struct hwentry default_hw[] = {
 	/*
-	 * Compellent Technologies, Inc.
+	 * Compellent Technologies/DELL
 	 */
 	{
 		.vendor        = "COMPELNT",
@@ -34,7 +34,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * Apple controller family
+	 * Apple
 	 *
 	 * Maintainer : Shyam Sundar
 	 * Mail : g.shyamsundar@yahoo.co.in
@@ -53,7 +53,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * StorageWorks controller family
+	 * StorageWorks/HPE
 	 */
 	{
 		.vendor        = "3PARdata",
@@ -140,7 +140,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* HP MSA2000 product family with old firmware */
+		/* HP MSA2000 family with old firmware */
 		.vendor        = "HP",
 		.product       = "MSA2[02]12fc|MSA2012i",
 		.features      = DEFAULT_FEATURES,
@@ -155,7 +155,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* HP MSA2000 product family with new firmware */
+		/* HP MSA2000 family with new firmware */
 		.vendor        = "HP",
 		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
 		.features      = DEFAULT_FEATURES,
@@ -170,7 +170,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* HP MSA 1040/2040 product family */
+		/* HP MSA 1040/2040 family */
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
 		.features      = DEFAULT_FEATURES,
@@ -216,7 +216,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* HP P2000 family arrays */
+		/* HP P2000 family */
 		.vendor        = "HP",
 		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
 		.features      = DEFAULT_FEATURES,
@@ -231,7 +231,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * DDN controller family
+	 * DDN
 	 */
 	{
 		.vendor        = "DDN",
@@ -247,7 +247,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * EMC / Clariion controller family
+	 * EMC/DELL
 	 *
 	 * Maintainer : Edward Goggin, EMC
 	 * Mail : egoggin@emc.com
@@ -266,6 +266,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
+		/* DGC CLARiiON CX/AX and EMC VNX */
 		.vendor        = "DGC",
 		.product       = ".*",
 		.bl_product    = "LUNZ",
@@ -309,7 +310,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * Fujitsu controller family
+	 * Fujitsu
 	 */
 	{
 		.vendor        = "FSC",
@@ -338,7 +339,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * Hitachi controller family
+	 * Hitachi
 	 *
 	 * Maintainer : Matthias Rudolph
 	 * Mail : matthias.rudolph@hds.com
@@ -370,7 +371,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * IBM controller family
+	 * IBM
 	 *
 	 * Maintainer : Hannes Reinecke, SuSE
 	 * Mail : hare@suse.de
@@ -463,7 +464,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-	    /* IBM DS4700 */
+		/* IBM DS4700 */
 		.vendor        = "IBM",
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
@@ -478,7 +479,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-	    /* IBM DS4800 */
+		/* IBM DS4800 */
 		.vendor        = "IBM",
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
@@ -493,7 +494,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-	    /* IBM DS5000 */
+		/* IBM DS5000 */
 		.vendor        = "IBM",
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
@@ -668,7 +669,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-	    /* IBM XIV Storage System */
+		/* IBM XIV Storage System */
 		.vendor        = "IBM",
 		.product       = "2810XIV",
 		.features      = "1 queue_if_no_path",
@@ -703,7 +704,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* IBM 3303      NVDISK */
+		/* IBM 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
 		.features      = DEFAULT_FEATURES,
@@ -730,6 +731,9 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
+	/*
+	 * DELL
+	 */
 	{
 		/* DELL MD3000/MD3000i */
 		.vendor        = "DELL",
@@ -776,7 +780,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * NETAPP controller family
+	 * NETAPP
 	 */
 	{
 		.vendor        = "NETAPP",
@@ -797,7 +801,7 @@ static struct hwentry default_hw[] = {
 		.detect_prio   = DETECT_PRIO_ON,
 	},
 	/*
-	 * NEXENTA/COMSTAR controller family
+	 * NEXENTA
 	 *
 	 * Maintainer : Yacine Kheddache
 	 * Mail : yacine@alyseo.com
@@ -817,7 +821,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * IBM NSeries (NETAPP) controller family
+	 * IBM NSeries (NETAPP)
 	 */
 	{
 		.vendor        = "IBM",
@@ -834,7 +838,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * Pillar Data controller family
+	 * Pillar Data/Oracle
 	 *
 	 * Maintainer : Srinivasan Ramani
 	 * Mail : srinivas.ramani@oracle.com
@@ -854,7 +858,7 @@ static struct hwentry default_hw[] = {
 	},
 
 	/*
-	 * SGI arrays
+	 * SGI
 	 */
 	{
 		.vendor        = "SGI",
@@ -897,8 +901,11 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 		.prio_args     = NULL,
 	},
-	/* NEC Storage M Series */
+	/*
+	 * NEC
+	 */
 	{
+		/* Storage M Series */
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
 		.features      = DEFAULT_FEATURES,
@@ -912,7 +919,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * STK arrays
+	 * STK/Oracle
 	 */
 	{
 		.vendor        = "STK",
@@ -929,7 +936,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * SUN arrays
+	 * SUN/Oracle
 	 */
 	{
 		.vendor        = "SUN",
@@ -971,7 +978,7 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	/*
-	 * Pivot3 RAIGE
+	 * Pivot3
 	 *
 	 * Maintainer : Bart Brooks, Pivot3
 	 * Mail : bartb@pivot3.com
@@ -1034,7 +1041,7 @@ static struct hwentry default_hw[] = {
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
-	/* LSI/Engenio/NetApp E-Series RDAC storage
+	/* LSI/Engenio/NetApp RDAC
 	 *
 	 * Maintainer : Sean Stewart
 	 * Mail : sean.stewart@netapp.com
@@ -1147,7 +1154,7 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	/*
-	 * Violin Memory, Inc.
+	 * Violin Memory
 	 */
 	{
 		.vendor        = "VIOLIN",
@@ -1163,7 +1170,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 300,
 	},
 	/*
-	 * Infinidat, Inc.
+	 * Infinidat
 	 */
 	{
 		.vendor        = "NFINIDAT",
@@ -1182,7 +1189,7 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = 30,
 	},
 	/*
-	 * Tegile Systems, Inc.
+	 * Tegile Systems
 	 */
 	{
 		.vendor        = "TEGILE",
-- 
2.5.5
