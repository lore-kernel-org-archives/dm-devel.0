From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/6] multipath-tools: delete no_path_retry
	attribute when it is equal to default value
Date: Sat,  9 Jul 2016 01:58:45 +0200
Message-ID: <1468022328-5905-4-git-send-email-xose.vazquez@gmail.com>
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

     28                 .no_path_retry = NO_PATH_RETRY_UNDEF,

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8b742f4..efc1759 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -45,7 +45,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	/*
 	 * StorageWorks/HPE
@@ -56,7 +55,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		.vendor        = "DEC",
@@ -66,7 +64,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
 	},
@@ -187,7 +184,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	/*
 	 * EMC/DELL
@@ -245,7 +241,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		.vendor        = "FUJITSU",
@@ -269,7 +264,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		.vendor        = "HITACHI",
@@ -278,7 +272,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_HDS,
 	},
 	/*
@@ -293,7 +286,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM FAStT 1722-600 */
@@ -422,7 +414,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
@@ -432,7 +423,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM ESS F20 aka Shark */
@@ -442,7 +432,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM DS6000 */
@@ -452,7 +441,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
@@ -463,7 +451,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM SAN Volume Controller */
@@ -473,7 +460,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
@@ -486,7 +472,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM S/390 FBA DASD */
@@ -498,7 +483,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		/* IBM IPR */
@@ -509,7 +493,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
@@ -531,7 +514,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = 15,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 15,
 	},
 	/*
@@ -628,7 +610,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.flush_on_last_del = FLUSH_ENABLED,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.dev_loss      = MAX_DEV_LOSS_TMO,
 		.prio_name     = PRIO_ONTAP,
@@ -643,7 +624,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.prio_name     = PRIO_ONTAP,
 	},
@@ -675,7 +655,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
@@ -687,7 +666,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		.vendor        = "SGI",
@@ -725,7 +703,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.prio_name     = PRIO_ALUA,
 	},
 	/*
@@ -739,7 +716,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
@@ -752,7 +728,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	{
 		.vendor        = "SUN",
@@ -762,7 +737,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
@@ -772,7 +746,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 	},
 	/*
 	 * Pivot3
@@ -787,7 +760,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 100,
 	},
 	{
-- 
2.7.4
