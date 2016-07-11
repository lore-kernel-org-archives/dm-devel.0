From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: change default failback
	from manual to immediate
Date: Mon, 11 Jul 2016 23:12:01 +0200
Message-ID: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
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

Default value is: manual
      1                 .pgfailback    = 15,
      2                 .pgfailback    = 30,
     24                 .pgfailback    = FAILBACK_UNDEF,
     50                 .pgfailback    = -FAILBACK_IMMEDIATE,

manual is not used by any device.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h    |  2 +-
 libmultipath/hwtable.c     | 50 ----------------------------------------------
 multipath/multipath.conf.5 |  2 +-
 3 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index dd6a24b..d7d7dcb 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -8,7 +8,7 @@
 #define DEFAULT_MINIO		1000
 #define DEFAULT_MINIO_RQ	1
 #define DEFAULT_PGPOLICY	FAILOVER
-#define DEFAULT_FAILBACK	-FAILBACK_MANUAL
+#define DEFAULT_FAILBACK	-FAILBACK_IMMEDIATE
 #define DEFAULT_RR_WEIGHT	RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b4656c7..dcf413d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -29,7 +29,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
@@ -94,7 +93,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -105,7 +103,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -116,7 +113,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "MSA2[02]12fc|MSA2012i",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -126,7 +122,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -137,7 +132,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -149,7 +143,6 @@ static struct hwentry default_hw[] = {
 		.product       = "HSVX700",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -169,7 +162,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -207,7 +199,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.checker_name  = EMC_CLARIION,
@@ -244,7 +235,6 @@ static struct hwentry default_hw[] = {
 		.product       = "ETERNUS_DX(H|L|M|400|8000)",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
@@ -267,7 +257,6 @@ static struct hwentry default_hw[] = {
 		.product       = "DF.*",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_HDS,
 	},
@@ -292,7 +281,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
@@ -306,7 +294,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
@@ -320,7 +307,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
@@ -333,7 +319,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -346,7 +331,6 @@ static struct hwentry default_hw[] = {
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -359,7 +343,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -372,7 +355,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -385,7 +367,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -398,7 +379,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -436,7 +416,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1750500",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -455,7 +434,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -488,7 +466,6 @@ static struct hwentry default_hw[] = {
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -497,7 +474,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "1820N00",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = 100,
@@ -524,7 +500,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
@@ -532,7 +507,6 @@ static struct hwentry default_hw[] = {
 		/* IBM 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
@@ -542,7 +516,6 @@ static struct hwentry default_hw[] = {
 		.product       = "NVDISK",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.prio_name     = PRIO_ALUA,
@@ -558,7 +531,6 @@ static struct hwentry default_hw[] = {
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -572,7 +544,6 @@ static struct hwentry default_hw[] = {
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -586,7 +557,6 @@ static struct hwentry default_hw[] = {
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -603,7 +573,6 @@ static struct hwentry default_hw[] = {
 		.product       = "LUN.*",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.flush_on_last_del = FLUSH_ENABLED,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 128,
@@ -616,7 +585,6 @@ static struct hwentry default_hw[] = {
 		.product       = "Nseries.*",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
@@ -632,7 +600,6 @@ static struct hwentry default_hw[] = {
 		.product       = "COMSTAR",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.minio         = 128,
@@ -667,7 +634,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -680,7 +646,6 @@ static struct hwentry default_hw[] = {
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -695,7 +660,6 @@ static struct hwentry default_hw[] = {
 		.product       = "DISK ARRAY",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -708,7 +672,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -729,7 +692,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -762,7 +724,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -775,7 +736,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -788,7 +748,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -806,7 +765,6 @@ static struct hwentry default_hw[] = {
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.checker_name  = RDAC,
@@ -818,7 +776,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -829,7 +786,6 @@ static struct hwentry default_hw[] = {
 		.product       = "Multi-Flex",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
@@ -839,7 +795,6 @@ static struct hwentry default_hw[] = {
 		.product       = "RBD",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -849,7 +804,6 @@ static struct hwentry default_hw[] = {
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
@@ -858,7 +812,6 @@ static struct hwentry default_hw[] = {
 		.vendor	       = "DataCore",
 		.product       = "Virtual Disk",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
@@ -868,7 +821,6 @@ static struct hwentry default_hw[] = {
 		.product       = "FlashArray",
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.fast_io_fail  = 10,
 		.no_path_retry = 0,
 		.dev_loss      = 60,
@@ -877,7 +829,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HUAWEI",
 		.product       = "XSG1",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 	},
 	/*
 	 * Violin Memory
@@ -890,7 +841,6 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.minio         = 100,
 		.rr_weight     = RR_WEIGHT_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.features      = "1 queue_if_no_path",
 		.no_path_retry = 300,
 	},
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 1da2de1..204955c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -385,7 +385,7 @@ another node requested the failover.
 .I values > 0
 Deferred failback (time to defer in seconds).
 .TP
-Default value is: \fBmanual\fR
+Default value is: \fBimmediate\fR
 .RE
 .TP
 .B  rr_min_io
-- 
2.7.4
