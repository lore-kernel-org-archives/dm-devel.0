From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/4] multipath-tools: change default
	path_grouping_policy from failover to multibus
Date: Thu, 18 Aug 2016 19:58:16 +0200
Message-ID: <1471543096-11441-4-git-send-email-xose.vazquez@gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Default value is: failover
      1                 .pgpolicy      = FAILOVER,
      2                 .pgpolicy      = GROUP_BY_SERIAL,
     25                 .pgpolicy      = MULTIBUS,
     47                 .pgpolicy      = GROUP_BY_PRIO,
failover is only used by 1 device: IBM/3303 NVDISK

I hope it's reasonable. If someone disagrees, drop it.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h    |  2 +-
 libmultipath/hwtable.c     | 28 ++--------------------------
 multipath/multipath.conf.5 |  2 +-
 3 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a7c74fe..c1e8e74 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -11,7 +11,7 @@
 #define DEFAULT_HWHANDLER	"0"
 #define DEFAULT_MINIO		1000
 #define DEFAULT_MINIO_RQ	1
-#define DEFAULT_PGPOLICY	FAILOVER
+#define DEFAULT_PGPOLICY	MULTIBUS
 #define DEFAULT_FAILBACK	FAILBACK_UNDEF
 #define DEFAULT_RR_WEIGHT	RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c4037d5..eedb360 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -36,7 +36,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "APPLE",
 		.product       = "Xserve RAID",
-		.pgpolicy      = MULTIBUS,
 	},
 	/*
 	 * HPE
@@ -64,7 +63,6 @@ static struct hwentry default_hw[] = {
 		/* VIRTUAL ARRAY 7400 */
 		.vendor        = "HP",
 		.product       = "A6189A",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 12,
 	},
 	{
@@ -99,7 +97,6 @@ static struct hwentry default_hw[] = {
 		/* MSA2000 family with old firmware */
 		.vendor        = "HP",
 		.product       = "(MSA2[02]12fc|MSA2012i)",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 18,
 	},
 	{
@@ -134,7 +131,6 @@ static struct hwentry default_hw[] = {
 		/* Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 12,
 	},
 	{
@@ -152,7 +148,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "DDN",
 		.product       = "SAN DataDirector",
-		.pgpolicy      = MULTIBUS,
 	},
 	/*
 	 * EMC
@@ -161,7 +156,6 @@ static struct hwentry default_hw[] = {
 		/* Symmetrix / DMX / VMAX */
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 6,
 	},
 	{
@@ -181,13 +175,11 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EMC",
 		.product       = "Invista",
 		.bl_product    = "LUNZ",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 5,
 	},
 	{
 		.vendor        = "XtremIO",
 		.product       = "XtremApp",
-		.pgpolicy      = MULTIBUS,
 	},
 	/*
 	 * DELL
@@ -201,7 +193,6 @@ static struct hwentry default_hw[] = {
 		 */
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
@@ -260,7 +251,6 @@ static struct hwentry default_hw[] = {
 		/* FibreCAT S80 */
 		.vendor        = "(EUROLOGC|EuroLogc)",
 		.product       = "FC2502",
-		.pgpolicy      = MULTIBUS,
 	},
 	/*
 	 * Hitachi
@@ -272,7 +262,6 @@ static struct hwentry default_hw[] = {
 		/* USP-V, HUS VM, VSP, VSP G1000 and VSP GX00 families */
 		.vendor        = "(HITACHI|HP)",
 		.product       = "^OPEN-",
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/* AMS 2000 and HUS 100 families */
@@ -292,7 +281,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "IBM",
 		.product       = "ProFibre 4000R",
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/* DS4300 / FAStT600 */
@@ -428,14 +416,12 @@ static struct hwentry default_hw[] = {
 		/* DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "^3542",
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/* Enterprise Storage Server / Shark family */
 		.vendor        = "IBM",
 		.product       = "^2105",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/* DS6000 */
@@ -451,7 +437,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^2107900",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/* Storwize family / SAN Volume Controller / Flex System V7000 */
@@ -468,7 +453,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "S/390",
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		.vendor        = "IBM",
@@ -476,7 +460,6 @@ static struct hwentry default_hw[] = {
 		.bl_product    = "S/390",
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		/* Power RAID */
@@ -502,7 +485,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "2810XIV",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
 	},
 		/*
 		 * IBM Power Virtual SCSI Devices
@@ -513,7 +495,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "AIX",
 		.product       = "VDASD",
-		.pgpolicy      = MULTIBUS,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
@@ -521,6 +502,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "3303[ ]+NVDISK",
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.pgpolicy      = FAILOVER,
 	},
 	{
 		.vendor        = "AIX",
@@ -587,7 +569,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SGI",
 		.product       = "TP9100",
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		.vendor        = "SGI",
@@ -677,7 +658,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
-		.pgpolicy      = MULTIBUS,
 	},
 	{
 		.vendor        = "SUN",
@@ -739,7 +719,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.pgpolicy      = MULTIBUS,
 	},
 	/*
 	 * Intel
@@ -790,7 +769,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PURE",
 		.product       = "FlashArray",
-		.pgpolicy      = MULTIBUS,
 		.fast_io_fail  = 10,
 		.dev_loss      = 60,
 	},
@@ -801,7 +779,6 @@ static struct hwentry default_hw[] = {
 		/* OceanStor V3 */
 		.vendor        = "(HUAWEI|HUASY)",
 		.product       = "XSG1",
-		.pgpolicy      = MULTIBUS,
 	},
 	/*
 	 * Red Hat
@@ -822,7 +799,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "KOVE",
 		.product       = "XPD",
-		.pgpolicy      = MULTIBUS,
 	},
 #if 0
 	/*
@@ -844,7 +820,7 @@ static struct hwentry default_hw[] = {
 		.product       = "PRODUCT",
 		.revision      = "REVISION",
 		.bl_product    = "BL_PRODUCT",
-		.pgpolicy      = FAILOVER,
+		.pgpolicy      = MULTIBUS,
 		.uid_attribute = "ID_SERIAL",
 		.selector      = "service-time 0",
 		.checker_name  = TUR,
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 466ad94..8c0b47a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -204,7 +204,7 @@ per-multipath option in the configuration file.
 One priority group per target node name. Target node names are fetched
 in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
-Default value is: \fBfailover\fR
+Default value is: \fBmultibus\fR
 .RE
 .
 .
-- 
2.7.4
