From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: delete rr_weight attribute when
	it is equal to default value
Date: Mon, 11 Jul 2016 23:42:47 +0200
Message-ID: <1468273367-3840-1-git-send-email-xose.vazquez@gmail.com>
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

  71                 .rr_weight     = RR_WEIGHT_NONE,

Defaul value is already RR_WEIGHT_NONE(uniform)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 71 --------------------------------------------------
 1 file changed, 71 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8013b69..5b896ee 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -29,7 +29,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = MULTIBUS,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	/*
@@ -43,7 +42,6 @@ static struct hwentry default_hw[] = {
 		.product       = "Xserve RAID",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	/*
 	 * StorageWorks/HPE
@@ -53,7 +51,6 @@ static struct hwentry default_hw[] = {
 		.product       = "VV",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		.vendor        = "DEC",
@@ -61,7 +58,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
 	},
@@ -70,7 +66,6 @@ static struct hwentry default_hw[] = {
 		.product       = "A6189A",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 	},
 	{
@@ -80,7 +75,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
 		.checker_name  = HP_SW,
@@ -90,7 +84,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/1500 with new firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -99,7 +92,6 @@ static struct hwentry default_hw[] = {
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -109,7 +101,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "MSA2[02]12fc|MSA2012i",
 		.pgpolicy      = MULTIBUS,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
 	},
@@ -117,7 +108,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA2000 family with new firmware */
 		.vendor        = "HP",
 		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -126,7 +116,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA 1040/2040 family */
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -136,7 +125,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "HSVX700",
 		.hwhandler     = "1 alua",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -147,14 +135,12 @@ static struct hwentry default_hw[] = {
 		.product       = "LOGICAL VOLUME.*",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 	},
 	{
 		/* HP P2000 family */
 		.vendor        = "HP",
 		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -167,7 +153,6 @@ static struct hwentry default_hw[] = {
 		.product       = "SAN DataDirector",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	/*
 	 * EMC/DELL
@@ -180,7 +165,6 @@ static struct hwentry default_hw[] = {
 		.product       = "SYMMETRIX",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 6,
 	},
 	{
@@ -190,7 +174,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "LUNZ",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.checker_name  = EMC_CLARIION,
 		.prio_name     = PRIO_EMC,
@@ -201,7 +184,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "LUNZ",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 5,
 	},
 	{
@@ -219,13 +201,11 @@ static struct hwentry default_hw[] = {
 		.product       = "CentricStor",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_DX(H|L|M|400|8000)",
 		.features      = "1 queue_if_no_path",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -240,13 +220,11 @@ static struct hwentry default_hw[] = {
 		.product       = "OPEN-.*",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.features      = "1 queue_if_no_path",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_HDS,
 	},
 	/*
@@ -260,7 +238,6 @@ static struct hwentry default_hw[] = {
 		.product       = "ProFibre 4000R",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM FAStT 1722-600 */
@@ -269,7 +246,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -281,7 +257,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -293,7 +268,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -304,7 +278,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1742",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -315,7 +288,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -326,7 +298,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -337,7 +308,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -348,7 +318,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -359,7 +328,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^3526",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -370,7 +338,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^3542",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
@@ -379,7 +346,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
@@ -388,14 +354,12 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM DS6000 */
 		.vendor        = "IBM",
 		.product       = "^1750500",
 		.features      = "1 queue_if_no_path",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
@@ -405,14 +369,12 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM SAN Volume Controller */
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
@@ -424,7 +386,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM S/390 FBA DASD */
@@ -435,7 +396,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		/* IBM IPR */
@@ -443,14 +403,12 @@ static struct hwentry default_hw[] = {
 		.product       = "^IPR.*",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 alua",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
 		/* IBM RSSM */
 		.vendor        = "IBM",
 		.product       = "1820N00",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -462,7 +420,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = 15,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 15,
 	},
 	/*
@@ -476,14 +433,12 @@ static struct hwentry default_hw[] = {
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
 		/* IBM 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.pgpolicy      = FAILOVER,
 	},
@@ -492,7 +447,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "AIX",
 		.product       = "NVDISK",
 		.hwhandler     = "1 alua",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.prio_name     = PRIO_ALUA,
 	},
@@ -506,7 +460,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -518,7 +471,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -530,7 +482,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -546,7 +497,6 @@ static struct hwentry default_hw[] = {
 		.product       = "LUN.*",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
 		.flush_on_last_del = FLUSH_ENABLED,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 128,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
@@ -556,7 +506,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
 		.features      = "1 queue_if_no_path",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
 	},
@@ -571,7 +520,6 @@ static struct hwentry default_hw[] = {
 		.product       = "COMSTAR",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.minio         = 128,
 	},
@@ -585,7 +533,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
@@ -596,14 +543,12 @@ static struct hwentry default_hw[] = {
 		.product       = "TP9[13]00",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		.vendor        = "SGI",
 		.product       = "TP9[45]00",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -614,7 +559,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -627,7 +571,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
 		.hwhandler     = "1 alua",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
@@ -638,7 +581,6 @@ static struct hwentry default_hw[] = {
 		.product       = "OPENstorage D280",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
@@ -650,14 +592,12 @@ static struct hwentry default_hw[] = {
 		.product       = "(StorEdge 3510|T4)",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	{
 		.vendor        = "SUN",
 		.product       = "STK6580_6780",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
@@ -665,7 +605,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EUROLOGC",
 		.product       = "FC2502",
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 	},
 	/*
 	 * Pivot3
@@ -679,7 +618,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 100,
 	},
 	{
@@ -687,7 +625,6 @@ static struct hwentry default_hw[] = {
 		.product       = "CSM200_R",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -698,7 +635,6 @@ static struct hwentry default_hw[] = {
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -709,7 +645,6 @@ static struct hwentry default_hw[] = {
 		.product       = "SUN_6180",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -725,7 +660,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -735,7 +669,6 @@ static struct hwentry default_hw[] = {
 		.product       = "FLEXLINE 380",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -744,7 +677,6 @@ static struct hwentry default_hw[] = {
 		.vendor	       = "Intel",
 		.product       = "Multi-Flex",
 		.hwhandler     = "1 alua",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -752,7 +684,6 @@ static struct hwentry default_hw[] = {
 		.vendor	       = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
 		.hwhandler     = "1 alua",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
@@ -760,14 +691,12 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
 		.vendor	       = "DataCore",
 		.product       = "Virtual Disk",
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
 	},
-- 
2.7.4
