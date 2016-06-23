From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/4] multipath-tools: replace TUR with
	DEFAULT_CHECKER in hwtable
Date: Thu, 23 Jun 2016 15:42:19 +0200
Message-ID: <1466689340-5590-4-git-send-email-xose.vazquez@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

DEFAULT_CHECKER already is TUR

Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Cc: Edward Goggin, EMC <egoggin@emc.com>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>
Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
Cc: Yacine Kheddache <yacine@alyseo.com>
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
Cc: Martin George <marting@netapp.com>
Cc: Sean Stewart <sean.stewart@netapp.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 78 +++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index fb334ab..6e73e67 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -34,7 +34,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -125,7 +125,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -140,7 +140,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -155,7 +155,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -170,7 +170,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -185,7 +185,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -200,7 +200,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -214,7 +214,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -229,7 +229,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 18,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -264,7 +264,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 6,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -295,7 +295,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 5,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -307,7 +307,7 @@ static struct hwentry default_hw[] = {
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.fast_io_fail  = 5,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
@@ -337,7 +337,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 10,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -356,7 +356,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -369,7 +369,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_HDS,
 		.prio_args     = NULL,
 	},
@@ -536,7 +536,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -550,7 +550,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -564,7 +564,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -578,7 +578,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -592,7 +592,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -606,7 +606,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -652,7 +652,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -667,7 +667,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -682,7 +682,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 15,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -716,7 +716,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -730,7 +730,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -797,7 +797,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
@@ -855,7 +855,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -916,7 +916,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -996,7 +996,7 @@ static struct hwentry default_hw[] = {
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 100,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
@@ -1089,7 +1089,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -1102,7 +1102,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.minio         = 100,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
@@ -1116,7 +1116,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -1129,7 +1129,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
@@ -1141,7 +1141,7 @@ static struct hwentry default_hw[] = {
 		.selector      = "queue-length 0",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.fast_io_fail  = 10,
 		.prio_name     = DEFAULT_PRIO,
 		.no_path_retry = 0,
@@ -1155,7 +1155,7 @@ static struct hwentry default_hw[] = {
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 	},
 	/*
 	 * Violin Memory
@@ -1166,7 +1166,7 @@ static struct hwentry default_hw[] = {
 		.selector      = "round-robin 0",
 		.pgpolicy      = MULTIBUS,
 		.prio_name     = PRIO_ALUA,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.minio         = 100,
 		.rr_weight     = RR_WEIGHT_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1181,7 +1181,7 @@ static struct hwentry default_hw[] = {
 		.product       = "InfiniBox.*",
 		.prio_name     = PRIO_ALUA,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.selector      = "round-robin 0",
 		.features      = DEFAULT_FEATURES,
 		.pgfailback    = 30,
@@ -1203,7 +1203,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.no_path_retry = 10,
 		.dev_loss      = 50,
-		.checker_name  = TUR,
+		.checker_name  = DEFAULT_CHECKER,
 		.prio_name     = PRIO_ALUA,
 		.pgfailback    = 30,
 		.minio         = 128,
-- 
2.5.5
