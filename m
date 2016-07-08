From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/6] multipath-tools: delete prio_args attribute
	when it is equal to default value
Date: Sat,  9 Jul 2016 01:58:44 +0200
Message-ID: <1468022328-5905-3-git-send-email-xose.vazquez@gmail.com>
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

     73                 .prio_args     = NULL,

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 72 --------------------------------------------------
 1 file changed, 72 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6d87cf4..8b742f4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -32,7 +32,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.prio_args     = NULL,
 	},
 	/*
 	 * Apple
@@ -47,7 +46,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	/*
 	 * StorageWorks/HPE
@@ -59,7 +57,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "DEC",
@@ -72,7 +69,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "HP",
@@ -81,7 +77,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.prio_args     = NULL,
 	},
 	{
 		/* MSA 1000/MSA1500 EVA 3000/5000 with old firmware */
@@ -96,7 +91,6 @@ static struct hwentry default_hw[] = {
 		.minio         = 100,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
-		.prio_args     = NULL,
 	},
 	{
 		/* MSA 1000/1500 with new firmware */
@@ -108,7 +102,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
@@ -120,7 +113,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* HP MSA2000 family with old firmware */
@@ -131,7 +123,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
-		.prio_args     = NULL,
 	},
 	{
 		/* HP MSA2000 family with new firmware */
@@ -143,7 +134,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* HP MSA 1040/2040 family */
@@ -155,7 +145,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* HP SVSP */
@@ -168,7 +157,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* HP Smart Array */
@@ -178,7 +166,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.prio_args     = NULL,
 	},
 	{
 		/* HP P2000 family */
@@ -190,7 +177,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	/*
 	 * DDN
@@ -202,7 +188,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	/*
 	 * EMC/DELL
@@ -217,7 +202,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 6,
-		.prio_args     = NULL,
 	},
 	{
 		/* DGC CLARiiON CX/AX and EMC VNX */
@@ -232,7 +216,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.checker_name  = EMC_CLARIION,
 		.prio_name     = PRIO_EMC,
-		.prio_args     = NULL,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
@@ -244,7 +227,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 5,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "XtremIO",
@@ -253,7 +235,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.fast_io_fail  = 5,
-		.prio_args     = NULL,
 	},
 	/*
 	 * Fujitsu
@@ -265,7 +246,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "FUJITSU",
@@ -276,7 +256,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	/*
 	 * Hitachi
@@ -291,7 +270,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "HITACHI",
@@ -302,7 +280,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_HDS,
-		.prio_args     = NULL,
 	},
 	/*
 	 * IBM
@@ -317,7 +294,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM FAStT 1722-600 */
@@ -332,7 +308,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS4100 */
@@ -347,7 +322,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS3200 / DS3300 / DS3400 */
@@ -362,7 +336,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS4400 / DS4500 / FAStT700 */
@@ -376,7 +349,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "IBM",
@@ -390,7 +362,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS4700 */
@@ -404,7 +375,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS4800 */
@@ -418,7 +388,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS5000 */
@@ -432,7 +401,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM Netfinity Fibre Channel RAID Controller Unit */
@@ -446,7 +414,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS4200 / FAStT200 */
@@ -456,7 +423,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
@@ -467,7 +433,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
@@ -478,7 +443,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS6000 */
@@ -490,7 +454,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM DS8000 */
@@ -501,7 +464,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM SAN Volume Controller */
@@ -513,7 +475,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM S/390 ECKD DASD */
@@ -526,7 +487,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM S/390 FBA DASD */
@@ -539,7 +499,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM IPR */
@@ -552,7 +511,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM RSSM */
@@ -564,7 +522,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM XIV Storage System */
@@ -576,7 +533,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 15,
-		.prio_args     = NULL,
 	},
 	/*
 	 * IBM Power Virtual SCSI Devices
@@ -592,7 +548,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.prio_args     = NULL,
 	},
 	{
 		/* IBM 3303 NVDISK */
@@ -602,7 +557,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.prio_args     = NULL,
 	},
 	{
 		/* AIX NVDISK */
@@ -614,7 +568,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	/*
 	 * DELL
@@ -632,7 +585,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* DELL MD32xx/MD36xx */
@@ -647,7 +599,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		/* DELL MD34xx/MD38xx */
@@ -662,7 +613,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	/*
 	 * NETAPP ONTAP family
@@ -682,7 +632,6 @@ static struct hwentry default_hw[] = {
 		.minio         = 128,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
-		.prio_args     = NULL,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
 	},
@@ -697,7 +646,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
-		.prio_args     = NULL,
 	},
 	/*
 	 * NEXENTA
@@ -714,7 +662,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.minio         = 128,
-		.prio_args     = NULL,
 	},
 	/*
 	 * Pillar Data/Oracle
@@ -730,7 +677,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	/*
 	 * SGI
@@ -742,7 +688,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SGI",
@@ -755,7 +700,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SGI",
@@ -769,7 +713,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	/*
 	 * NEC
@@ -784,7 +727,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	/*
 	 * STK/Oracle
@@ -800,7 +742,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	/*
 	 * SUN/Oracle
@@ -812,7 +753,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SUN",
@@ -825,7 +765,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "EUROLOGC",
@@ -834,7 +773,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.prio_args     = NULL,
 	},
 	/*
 	 * Pivot3
@@ -851,7 +789,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 100,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "SUN",
@@ -864,7 +801,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	/* SUN/LSI 2510, 2540, 2530, 2540 */
 	{
@@ -878,7 +814,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	/* StorageTek 6180 */
 	{
@@ -910,7 +845,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 		.detect_prio   = DETECT_PRIO_ON,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 	},
@@ -925,7 +859,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor	       = "Intel",
@@ -936,7 +869,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor	       = "(LIO-ORG|SUSE)",
@@ -948,7 +880,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 12,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor	       = "DataCore",
@@ -958,7 +889,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor	       = "DataCore",
@@ -968,7 +898,6 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "PURE",
@@ -979,7 +908,6 @@ static struct hwentry default_hw[] = {
 		.fast_io_fail  = 10,
 		.no_path_retry = 0,
 		.dev_loss      = 60,
-		.prio_args     = NULL,
 	},
 	{
 		.vendor        = "HUAWEI",
-- 
2.7.4
