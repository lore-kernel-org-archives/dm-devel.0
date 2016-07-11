From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: change default
	path_grouping_policy from failover to group_by_prio
Date: Mon, 11 Jul 2016 23:12:02 +0200
Message-ID: <1468271522-3052-2-git-send-email-xose.vazquez@gmail.com>
References: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
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

Default value is: failover
      5                 .pgpolicy      = GROUP_BY_SERIAL,
     23                 .pgpolicy      = MULTIBUS,
     48                 .pgpolicy      = GROUP_BY_PRIO,

failover is only used by 1 device:
IBM/3303 NVDISK

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h    |  2 +-
 libmultipath/hwtable.c     | 49 +---------------------------------------------
 multipath/multipath.conf.5 |  2 +-
 3 files changed, 3 insertions(+), 50 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index d7d7dcb..9de5914 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -7,7 +7,7 @@
 #define DEFAULT_HWHANDLER	"0"
 #define DEFAULT_MINIO		1000
 #define DEFAULT_MINIO_RQ	1
-#define DEFAULT_PGPOLICY	FAILOVER
+#define DEFAULT_PGPOLICY	GROUP_BY_PRIO
 #define DEFAULT_FAILBACK	-FAILBACK_IMMEDIATE
 #define DEFAULT_RR_WEIGHT	RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index dcf413d..8013b69 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -60,7 +60,6 @@ static struct hwentry default_hw[] = {
 		.product       = "HSG80",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = HP_SW,
@@ -80,7 +79,6 @@ static struct hwentry default_hw[] = {
 		.product       = "(MSA|HSV)1.0.*",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
@@ -92,7 +90,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/1500 with new firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -102,7 +99,6 @@ static struct hwentry default_hw[] = {
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -121,7 +117,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA2000 family with new firmware */
 		.vendor        = "HP",
 		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -131,7 +126,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA 1040/2040 family */
 		.vendor        = "HP",
 		.product       = "MSA (1|2)040 SA(N|S)",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -142,7 +136,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "HSVX700",
 		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -161,7 +154,6 @@ static struct hwentry default_hw[] = {
 		/* HP P2000 family */
 		.vendor        = "HP",
 		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
@@ -198,7 +190,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "LUNZ",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.checker_name  = EMC_CLARIION,
@@ -234,7 +225,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_DX(H|L|M|400|8000)",
 		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 10,
 		.prio_name     = PRIO_ALUA,
@@ -256,7 +246,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
 		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_HDS,
 	},
@@ -280,7 +269,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
@@ -293,7 +281,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
@@ -306,7 +293,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 300,
 		.checker_name  = RDAC,
@@ -318,7 +304,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1742",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -330,7 +315,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -342,7 +326,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -354,7 +337,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -366,7 +348,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -378,7 +359,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^3526",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -415,7 +395,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1750500",
 		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -433,7 +412,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -465,7 +443,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^IPR.*",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -473,7 +450,6 @@ static struct hwentry default_hw[] = {
 		/* IBM RSSM */
 		.vendor        = "IBM",
 		.product       = "1820N00",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = 100,
@@ -509,13 +485,13 @@ static struct hwentry default_hw[] = {
 		.product       = "3303      NVDISK",
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.pgpolicy      = FAILOVER,
 	},
 	{
 		/* AIX NVDISK */
 		.vendor        = "AIX",
 		.product       = "NVDISK",
 		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.prio_name     = PRIO_ALUA,
@@ -530,7 +506,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -543,7 +518,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -556,7 +530,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -572,7 +545,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
 		.features      = "3 queue_if_no_path pg_init_retries 50",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.flush_on_last_del = FLUSH_ENABLED,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 128,
@@ -584,7 +556,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
 		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
@@ -613,7 +584,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
@@ -633,7 +603,6 @@ static struct hwentry default_hw[] = {
 		.product       = "TP9[45]00",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -645,7 +614,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 15,
 		.checker_name  = RDAC,
@@ -659,7 +627,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
 		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.prio_name     = PRIO_ALUA,
 	},
@@ -671,7 +638,6 @@ static struct hwentry default_hw[] = {
 		.product       = "OPENstorage D280",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -691,7 +657,6 @@ static struct hwentry default_hw[] = {
 		.product       = "STK6580_6780",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
@@ -699,7 +664,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EUROLOGC",
 		.product       = "FC2502",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 	},
@@ -723,7 +687,6 @@ static struct hwentry default_hw[] = {
 		.product       = "CSM200_R",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -735,7 +698,6 @@ static struct hwentry default_hw[] = {
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -747,7 +709,6 @@ static struct hwentry default_hw[] = {
 		.product       = "SUN_6180",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -764,7 +725,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 30,
 		.checker_name  = RDAC,
@@ -775,7 +735,6 @@ static struct hwentry default_hw[] = {
 		.product       = "FLEXLINE 380",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.checker_name  = RDAC,
@@ -785,7 +744,6 @@ static struct hwentry default_hw[] = {
 		.vendor	       = "Intel",
 		.product       = "Multi-Flex",
 		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
@@ -794,7 +752,6 @@ static struct hwentry default_hw[] = {
 		.vendor	       = "(LIO-ORG|SUSE)",
 		.product       = "RBD",
 		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
@@ -803,7 +760,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "DataCore",
 		.product       = "SANmelody",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
@@ -811,7 +767,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "DataCore",
 		.product       = "Virtual Disk",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.prio_name     = PRIO_ALUA,
@@ -851,7 +806,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NFINIDAT",
 		.product       = "InfiniBox.*",
 		.prio_name     = PRIO_ALUA,
-		.pgpolicy      = GROUP_BY_PRIO,
 		.selector      = "round-robin 0",
 		.pgfailback    = 30,
 		.rr_weight     = RR_WEIGHT_PRIO,
@@ -867,7 +821,6 @@ static struct hwentry default_hw[] = {
 		.product       = "ZEBI-(FC|ISCSI)|INTELLIFLASH",
 		.hwhandler     = "1 alua",
 		.selector      = "round-robin 0",
-		.pgpolicy      = GROUP_BY_PRIO,
 		.no_path_retry = 10,
 		.dev_loss      = 50,
 		.prio_name     = PRIO_ALUA,
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 204955c..7e0cfd4 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -184,7 +184,7 @@ per-multipath option in the configuration file.
 One priority group per target node name. Target node names are fetched
 in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
-Default value is: \fBfailover\fR
+Default value is: \fBgroup_by_prio\fR
 .RE
 .TP
 .B uid_attribute
-- 
2.7.4
