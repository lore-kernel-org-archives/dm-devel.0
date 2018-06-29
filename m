From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: make Product Name mandatory and
	add all of them
Date: Fri, 29 Jun 2018 23:22:45 +0200
Message-ID: <20180629212245.16328-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 53 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 07dd6b6..8499c2f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -42,7 +42,7 @@
 	 * Mail : XXX
 	 */
 	{
-		/* If product-ID is different from marketing name add a comment */
+		/* Product Name */
 		.vendor        = "VENDOR",
 		.product       = "PRODUCT",
 		.revision      = "REVISION",
@@ -86,6 +86,7 @@ static struct hwentry default_hw[] = {
 	 * below.
 	 */
 	{
+		/* Generic NVMe */
 		.vendor        = "NVME",
 		.product       = ".*",
 		.uid_attribute = "ID_WWN",
@@ -99,6 +100,7 @@ static struct hwentry default_hw[] = {
 	 * Mail : g.shyamsundar@yahoo.co.in
 	 */
 	{
+		/* Xserve RAID */
 		.vendor        = "APPLE",
 		.product       = "Xserve RAID",
 		.pgpolicy      = MULTIBUS,
@@ -107,6 +109,7 @@ static struct hwentry default_hw[] = {
 	 * HPE
 	 */
 	{
+		/* 3PAR */
 		.vendor        = "3PARdata",
 		.product       = "VV",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -234,6 +237,7 @@ static struct hwentry default_hw[] = {
 	},
 		/* SGI */
 	{
+		/* Total Performance 9100 */
 		.vendor        = "SGI",
 		.product       = "TP9100",
 		.pgpolicy      = MULTIBUS,
@@ -252,7 +256,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* InfiniteStorage family */
+		/* (RDAC) InfiniteStorage */
 		.vendor        = "SGI",
 		.product       = "IS",
 		.bl_product    = "Universal Xport",
@@ -265,7 +269,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* (DDN) */
+		/* (DDN) InfiniteStorage */
 		.vendor        = "SGI",
 		.product       = "^DD[46]A-",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -277,17 +281,20 @@ static struct hwentry default_hw[] = {
 	 * DataDirect Networks
 	 */
 	{
+		/* SAN DataDirector */
 		.vendor        = "DDN",
 		.product       = "SAN DataDirector",
 		.pgpolicy      = MULTIBUS,
 	},
 	{
+		/* EF3010 */
 		.vendor        = "DDN",
 		.product       = "^EF3010",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
 	{
+		/* EF3015 / S2A and SFA families */
 		.vendor        = "DDN",
 		.product       = "^(EF3015|S2A|SFA)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -299,14 +306,14 @@ static struct hwentry default_hw[] = {
 	 * Dell EMC
 	 */
 	{
-		/* Symmetrix / DMX / VMAX */
+		/* Symmetrix / DMX / VMAX / PowerMax */
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 6,
 	},
 	{
-		/* DGC CLARiiON CX/AX / EMC VNX and Unity */
+		/* DGC CLARiiON CX/AX / VNX and Unity */
 		.vendor        = "^DGC",
 		.product       = "^(RAID|DISK|VRAID)",
 		.bl_product    = "LUNZ",
@@ -326,13 +333,14 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 5,
 	},
 	{
+		/* XtremIO */
 		.vendor        = "XtremIO",
 		.product       = "XtremApp",
 		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/*
-		 * Dell SC Series, formerly Compellent
+		 * SC Series, formerly Compellent
 		 *
 		 * Maintainer : Sean McGinnis
 		 * Mail : sean_mcginnis@dell.com
@@ -359,11 +367,13 @@ static struct hwentry default_hw[] = {
 	 * Fujitsu
 	 */
 	{
+		/* CentricStor Virtual Tape */
 		.vendor        = "FSC",
 		.product       = "CentricStor",
 		.pgpolicy      = GROUP_BY_SERIAL,
 	},
 	{
+		/* ETERNUS family */
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_DX(H|L|M|400|8000)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -378,6 +388,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
+		/* ETERNUS 2000, 3000 and 4000 */
 		.vendor        = "FUJITSU",
 		.product       = "E[234]000",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -386,6 +397,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
+		/* ETERNUS 6000 and 8000 */
 		.vendor        = "FUJITSU",
 		.product       = "E[68]000",
 		.pgpolicy      = MULTIBUS,
@@ -425,6 +437,7 @@ static struct hwentry default_hw[] = {
 	 * Mail : hare@suse.de
 	 */
 	{
+		/* ProFibre 4000R */
 		.vendor        = "IBM",
 		.product       = "ProFibre 4000R",
 		.pgpolicy      = MULTIBUS,
@@ -605,6 +618,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
+		/* DS6000/DS8000 DASD ECKD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product    = "S/390",
@@ -613,6 +627,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
+		/* DS6000/DS8000 DASD FBA */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
 		.bl_product    = "S/390",
@@ -668,6 +683,7 @@ static struct hwentry default_hw[] = {
 		 * Mail : brking@linux.vnet.ibm.com
 		 */
 	{
+		/* AIX VDASD */
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
@@ -680,6 +696,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
+		/* AIX NVDISK */
 		.vendor        = "AIX",
 		.product       = "NVDISK",
 		.hwhandler     = "1 alua",
@@ -756,6 +773,7 @@ static struct hwentry default_hw[] = {
 	 * Mail : yacine@alyseo.com
 	 */
 	{
+		/* COMSTAR */
 		.vendor        = "NEXENTA",
 		.product       = "COMSTAR",
 		.pgpolicy      = GROUP_BY_SERIAL,
@@ -783,6 +801,7 @@ static struct hwentry default_hw[] = {
 		 * Mail : srinivas.ramani@oracle.com
 		 */
 	{
+		/* Axiom */
 		.vendor        = "^Pillar",
 		.product       = "^Axiom",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -790,6 +809,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
+		/* FS */
 		.vendor        = "^Oracle",
 		.product       = "^Oracle FS",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -837,12 +857,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* (Dot Hill) 3310, 3320, 3510 and 3511 */
+		/* (Dot Hill) 3120, 3310, 3320, 3510 and 3511 */
 		.vendor        = "SUN",
 		.product       = "StorEdge 3",
 		.pgpolicy      = MULTIBUS,
 	},
 	{
+		/* 6580 and 6780 */
 		.vendor        = "SUN",
 		.product       = "STK6580_6780",
 		.bl_product    = "Universal Xport",
@@ -881,6 +902,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
+		/* 6180 */
 		.vendor        = "SUN",
 		.product       = "SUN_6180",
 		.bl_product    = "Universal Xport",
@@ -893,6 +915,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
+		/* ArrayStorage */
 		.vendor        = "SUN",
 		.product       = "ArrayStorage",
 		.bl_product    = "Universal Xport",
@@ -920,12 +943,14 @@ static struct hwentry default_hw[] = {
 	 * Mail : bartb@pivot3.com
 	 */
 	{
+		/* Raige */
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 	},
 	{
+		/* NexGen / vSTAC */
 		.vendor        = "(NexGen|Pivot3)",
 		.product       = "(TierStore|vSTAC)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -937,6 +962,7 @@ static struct hwentry default_hw[] = {
 	 * Intel
 	 */
 	{
+		/* Multi-Flex */
 		.vendor        = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
 		.bl_product    = "VTrak V-LUN",
@@ -950,6 +976,7 @@ static struct hwentry default_hw[] = {
 	 * Linux-IO Target
 	 */
 	{
+		/* Linux-IO Target */
 		.vendor        = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
 		.hwhandler     = "1 alua",
@@ -962,6 +989,7 @@ static struct hwentry default_hw[] = {
 	 * DataCore
 	 */
 	{
+		/* SANmelody */
 		.vendor        = "DataCore",
 		.product       = "SANmelody",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -982,6 +1010,7 @@ static struct hwentry default_hw[] = {
 	 * Pure Storage
 	 */
 	{
+		/* FlashArray */
 		.vendor        = "PURE",
 		.product       = "FlashArray",
 		.pgpolicy      = MULTIBUS,
@@ -1000,6 +1029,7 @@ static struct hwentry default_hw[] = {
 	 * Kove
 	 */
 	{
+		/* XPD */
 		.vendor        = "KOVE",
 		.product       = "XPD",
 		.pgpolicy      = MULTIBUS,
@@ -1011,6 +1041,7 @@ static struct hwentry default_hw[] = {
 	 * Mail: arnony@infinidat.com
 	 */
 	{
+		/* InfiniBox */
 		.vendor        = "NFINIDAT",
 		.product       = "InfiniBox",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1029,14 +1060,16 @@ static struct hwentry default_hw[] = {
 	 * Kaminario
 	 */
 	{
+		/* K2 */
 		.vendor        = "KMNRIO",
 		.product       = "K2",
 		.pgpolicy      = MULTIBUS,
 	},
 	/*
-	 * Tegile Systems
+	 * Western Digital (Tegile Systems)
 	 */
 	{
+		/* IntelliFlash */
 		.vendor        = "TEGILE",
 		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
 		.hwhandler     = "1 alua",
@@ -1111,6 +1144,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
+		/* 3000 / 6000 Series - ALUA mode */
 		.vendor        = "VIOLIN",
 		.product       = "SAN ARRAY ALUA",
 		.hwhandler     = "1 alua",
@@ -1130,6 +1164,7 @@ static struct hwentry default_hw[] = {
 	 * Promise Technology
 	 */
 	{
+		/* VTrak family */
 		.vendor        = "Promise",
 		.product       = "VTrak",
 		.bl_product    = "VTrak V-LUN",
@@ -1140,6 +1175,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
+		/* Vess family */
 		.vendor        = "Promise",
 		.product       = "Vess",
 		.bl_product    = "Vess V-LUN",
@@ -1214,6 +1250,7 @@ static struct hwentry default_hw[] = {
 	 * EOL
 	 */
 	{
+		/* NULL */
 		.vendor        = NULL,
 		.product       = NULL,
 	},
-- 
2.17.1
