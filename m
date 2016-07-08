From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/6] multipath-tools: delete attributes with
	DEFAULT_* values in hwtable.c
Date: Sat,  9 Jul 2016 01:58:43 +0200
Message-ID: <1468022328-5905-2-git-send-email-xose.vazquez@gmail.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
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

     48                 .features      = DEFAULT_FEATURES,
     44                 .hwhandler     = DEFAULT_HWHANDLER,
     28                 .prio_name     = DEFAULT_PRIO,
      1                 .minio         = DEFAULT_MINIO,
      1                 .minio_rq      = DEFAULT_MINIO_RQ,

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 122 -------------------------------------------------
 1 file changed, 122 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a89ea87..6d87cf4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -28,13 +28,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -46,13 +43,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "APPLE.*",
 		.product       = "Xserve RAID",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -61,13 +55,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "3PARdata",
 		.product       = "VV",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -86,13 +77,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "HP",
 		.product       = "A6189A",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -114,8 +102,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/1500 with new firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -128,8 +114,6 @@ static struct hwentry default_hw[] = {
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -142,22 +126,17 @@ static struct hwentry default_hw[] = {
 		/* HP MSA2000 family with old firmware */
 		.vendor        = "HP",
 		.product       = "MSA2[02]12fc|MSA2012i",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		/* HP MSA2000 family with new firmware */
 		.vendor        = "HP",
 		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -170,8 +149,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA 1040/2040 family */
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -184,7 +161,6 @@ static struct hwentry default_hw[] = {
 		/* HP SVSP */
 		.vendor        = "HP",
 		.product       = "HSVX700",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -198,21 +174,16 @@ static struct hwentry default_hw[] = {
 		/* HP Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		/* HP P2000 family */
 		.vendor        = "HP",
 		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -227,13 +198,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "DDN",
 		.product       = "SAN DataDirector",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -245,13 +213,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 6,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -275,25 +240,19 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EMC",
 		.product       = "Invista",
 		.bl_product    = "LUNZ",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 5,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "XtremIO",
 		.product       = "XtremApp",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.fast_io_fail  = 5,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -302,20 +261,16 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "FSC",
 		.product       = "CentricStor",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_DX(H|L|M|400|8000)",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -332,20 +287,16 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "(HITACHI|HP)",
 		.product       = "OPEN-.*",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -362,13 +313,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "IBM",
 		.product       = "ProFibre 4000R",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -421,7 +369,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1742",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -450,7 +397,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -465,7 +411,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -480,7 +425,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -495,7 +439,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^3526",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -509,13 +452,10 @@ static struct hwentry default_hw[] = {
 		/* IBM DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "^3542",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -523,12 +463,10 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2105800",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -536,12 +474,10 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2105F20",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -549,7 +485,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1750500",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -562,12 +497,10 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2107900",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -575,7 +508,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -590,12 +522,10 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "S/390.*",
 		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -605,12 +535,10 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "S/390.*",
 		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
@@ -630,8 +558,6 @@ static struct hwentry default_hw[] = {
 		/* IBM RSSM */
 		.vendor        = "IBM",
 		.product       = "1820N00",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -645,13 +571,11 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "2810XIV",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = 15,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 15,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -664,33 +588,26 @@ static struct hwentry default_hw[] = {
 		/* AIX VDASD */
 		.vendor        = "AIX",
 		.product       = "VDASD",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		/* IBM 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = FAILOVER,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		/* AIX NVDISK */
 		.vendor        = "AIX",
 		.product       = "NVDISK",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -757,7 +674,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.flush_on_last_del = FLUSH_ENABLED,
@@ -775,7 +691,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -794,13 +709,11 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NEXENTA",
 		.product       = "COMSTAR",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.minio         = 128,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -812,8 +725,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -827,20 +738,16 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SGI",
 		.product       = "TP9[13]00",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SGI",
 		.product       = "TP9[45]00",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -871,7 +778,6 @@ static struct hwentry default_hw[] = {
 		/* M-Series */
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -887,7 +793,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -903,20 +808,16 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SUN",
 		.product       = "STK6580_6780",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -929,13 +830,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EUROLOGC",
 		.product       = "FC2502",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	/*
@@ -948,20 +846,17 @@ static struct hwentry default_hw[] = {
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
 		.features      = "1 queue_if_no_path",
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 100,
-		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SUN",
 		.product       = "CSM200_R",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -976,7 +871,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SUN",
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -991,14 +885,11 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SUN",
 		.product       = "SUN_6180",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.minio         = DEFAULT_MINIO,
-		.minio_rq      = DEFAULT_MINIO_RQ,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
@@ -1027,7 +918,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "STK",
 		.product       = "FLEXLINE 380",
 		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1040,7 +930,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "Intel",
 		.product       = "Multi-Flex",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1052,7 +941,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
-		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1065,8 +953,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -1077,8 +963,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "DataCore",
 		.product       = "Virtual Disk",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
@@ -1089,13 +973,10 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PURE",
 		.product       = "FlashArray",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.fast_io_fail  = 10,
-		.prio_name     = DEFAULT_PRIO,
 		.no_path_retry = 0,
 		.dev_loss      = 60,
 		.prio_args     = NULL,
@@ -1103,8 +984,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
@@ -1132,7 +1011,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.selector      = "round-robin 0",
-		.features      = DEFAULT_FEATURES,
 		.pgfailback    = 30,
 		.rr_weight     = RR_WEIGHT_PRIO,
 		.no_path_retry = NO_PATH_RETRY_FAIL,
-- 
2.7.4
