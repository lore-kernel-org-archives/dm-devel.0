From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Update hardware table
Date: Wed, 30 Apr 2008 11:04:33 +0200
Message-ID: <20080430090434.1C2DC18C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Update the built-in hardware table with definitions for various
new machines.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/hwtable.c |  135 ++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 107 insertions(+), 28 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d938379..5ed7090 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -84,7 +84,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DIRECTIO,
 		.prio_name     = DEFAULT_PRIO,
@@ -100,7 +100,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
@@ -116,7 +116,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
 		.prio_name     = PRIO_ALUA,
@@ -128,8 +128,8 @@ static struct hwentry default_hw[] = {
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
@@ -137,9 +137,9 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 	},
 	{
-		/* EVA 3000/5000 with new firmware */
+		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.1.*",
+		.product       = "HSV1[01]1|HSV2[01]0|HSV300",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
@@ -147,26 +147,26 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* EVA 4000/6000/8000 */
+		/* HP MSA2000 product family */
 		.vendor        = "HP",
-		.product       = "HSV2.*",
+		.product       = "MSA2[02]12*",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_PRIO,
+		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
-		.prio_name     = PRIO_ALUA,
+		.prio_name     = DEFAULT_PRIO,
 	},
 	{
 		/* HP Smart Array */
@@ -179,9 +179,9 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 12,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = CCISS_TUR,
 		.prio_name     = DEFAULT_PRIO,
 	},
 	/*
@@ -321,19 +321,67 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 	},
 	{
-		/* IBM DS4100 / FAStT100 */
+		/* IBM FAStT 1722-600 */
+		.vendor        = "IBM",
+		.product       = "1722-600",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 300,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+		/* IBM DS4400 / FAStT700 */
 		.vendor        = "IBM",
 		.product       = "1742",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+	    /* IBM DS4700 */
+		.vendor        = "IBM",
+		.product       = "1814",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	{
+	    /* IBM DS4800 */
+		.vendor        = "IBM",
+		.product       = "1815",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
 	{
@@ -342,14 +390,14 @@ static struct hwentry default_hw[] = {
 		.product       = "3526",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = RDAC,
 		.prio_name     = PRIO_RDAC,
 	},
 	{
@@ -449,7 +497,7 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.prio_name     = DEFAULT_PRIO,
 	},
- 	/*
+	/*
 	 * NETAPP controller family
 	 *
 	 * Maintainer : Dave Wysochanski
@@ -470,7 +518,7 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.prio_name     = PRIO_NETAPP,
 	},
- 	/*
+	/*
 	 * IBM NSeries (NETAPP) controller family
 	 *
 	 * Maintainer : Dave Wysochanski
@@ -538,7 +586,7 @@ static struct hwentry default_hw[] = {
 		.product       = "TP9[45]00",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -553,7 +601,7 @@ static struct hwentry default_hw[] = {
 		.product       = "IS.*",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -574,7 +622,7 @@ static struct hwentry default_hw[] = {
 		.product       = "OPENstorage D280",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -605,7 +653,7 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 		.prio_name     = DEFAULT_PRIO,
 	},
- 	/*
+	/*
 	 * Pivot3 RAIGE
 	 *
 	 * Maintainer : Bart Brooks, Pivot3
@@ -626,6 +674,37 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 		.prio_name     = DEFAULT_PRIO,
 	},
+	{
+		.vendor        = "SUN",
+		.product       = "CSM200_R",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
+	/* SUN/LSI 2540 */
+	{
+		.vendor        = "SUN",
+		.product       = "LCSM100_F",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+	},
 	/*
 	 * EOL
 	 */
-- 
1.5.2.4
