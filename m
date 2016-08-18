From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/4] multipath-tools: change default failback
	from manual to undefined
Date: Thu, 18 Aug 2016 19:58:15 +0200
Message-ID: <1471543096-11441-3-git-send-email-xose.vazquez@gmail.com>
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

Default value is: manual
     30                 .pgfailback    = FAILBACK_UNDEF,
     45                 .pgfailback    = -FAILBACK_IMMEDIATE,
manual is not used by any device.

I hope it's reasonable. If someone disagrees, drop it.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h    |  2 +-
 libmultipath/hwtable.c     | 32 +-------------------------------
 multipath/multipath.conf.5 |  8 +++++++-
 3 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 9bf27d6..a7c74fe 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -12,7 +12,7 @@
 #define DEFAULT_MINIO		1000
 #define DEFAULT_MINIO_RQ	1
 #define DEFAULT_PGPOLICY	FAILOVER
-#define DEFAULT_FAILBACK	-FAILBACK_MANUAL
+#define DEFAULT_FAILBACK	FAILBACK_UNDEF
 #define DEFAULT_RR_WEIGHT	RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 72b5e1d..c4037d5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -37,7 +37,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "APPLE",
 		.product       = "Xserve RAID",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * HPE
@@ -58,7 +57,6 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
 	},
@@ -67,7 +65,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "A6189A",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 12,
 	},
 	{
@@ -76,7 +73,6 @@ static struct hwentry default_hw[] = {
 		.product       = "(MSA|HSV)1[01]0",
 		.hwhandler     = "1 hp_sw",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 12,
 		.checker_name  = HP_SW,
 		.prio_name     = PRIO_HP_SW,
@@ -104,7 +100,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "(MSA2[02]12fc|MSA2012i)",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 18,
 	},
 	{
@@ -140,7 +135,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 12,
 	},
 	{
@@ -159,7 +153,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DDN",
 		.product       = "SAN DataDirector",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * EMC
@@ -169,7 +162,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 6,
 	},
 	{
@@ -190,14 +182,12 @@ static struct hwentry default_hw[] = {
 		.product       = "Invista",
 		.bl_product    = "LUNZ",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 5,
 	},
 	{
 		.vendor        = "XtremIO",
 		.product       = "XtremApp",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * DELL
@@ -212,7 +202,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
@@ -258,7 +247,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "FSC",
 		.product       = "CentricStor",
 		.pgpolicy      = GROUP_BY_SERIAL,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		.vendor        = "FUJITSU",
@@ -273,7 +261,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(EUROLOGC|EuroLogc)",
 		.product       = "FC2502",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * Hitachi
@@ -286,7 +273,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(HITACHI|HP)",
 		.product       = "^OPEN-",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* AMS 2000 and HUS 100 families */
@@ -307,7 +293,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "ProFibre 4000R",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* DS4300 / FAStT600 */
@@ -444,7 +429,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^3542",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* Enterprise Storage Server / Shark family */
@@ -452,7 +436,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^2105",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* DS6000 */
@@ -469,7 +452,6 @@ static struct hwentry default_hw[] = {
 		.product       = "^2107900",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* Storwize family / SAN Volume Controller / Flex System V7000 */
@@ -487,7 +469,6 @@ static struct hwentry default_hw[] = {
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		.vendor        = "IBM",
@@ -496,7 +477,6 @@ static struct hwentry default_hw[] = {
 		.uid_attribute = "ID_UID",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		/* Power RAID */
@@ -523,7 +503,6 @@ static struct hwentry default_hw[] = {
 		.product       = "2810XIV",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 		/*
 		 * IBM Power Virtual SCSI Devices
@@ -535,14 +514,12 @@ static struct hwentry default_hw[] = {
 		.vendor        = "AIX",
 		.product       = "VDASD",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
 		/* 3303 NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303[ ]+NVDISK",
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
 	{
@@ -602,7 +579,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NEXENTA",
 		.product       = "COMSTAR",
 		.pgpolicy      = GROUP_BY_SERIAL,
-		.pgfailback    = FAILBACK_UNDEF,
 		.no_path_retry = 30,
 	},
 	/*
@@ -612,7 +588,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SGI",
 		.product       = "TP9100",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		.vendor        = "SGI",
@@ -703,7 +678,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		.vendor        = "SUN",
@@ -766,7 +740,6 @@ static struct hwentry default_hw[] = {
 		.product       = "RAIGE VOLUME",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * Intel
@@ -818,7 +791,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "PURE",
 		.product       = "FlashArray",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 		.fast_io_fail  = 10,
 		.dev_loss      = 60,
 	},
@@ -830,7 +802,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(HUAWEI|HUASY)",
 		.product       = "XSG1",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 	/*
 	 * Red Hat
@@ -852,7 +823,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "KOVE",
 		.product       = "XPD",
 		.pgpolicy      = MULTIBUS,
-		.pgfailback    = FAILBACK_UNDEF,
 	},
 #if 0
 	/*
@@ -882,7 +852,7 @@ static struct hwentry default_hw[] = {
 		.hwhandler     = "0",
 		.prio_name     = "const",
 		.prio_args     = "",
-		.pgfailback    = -FAILBACK_MANUAL,
+		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 1000,
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 40df315..466ad94 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -422,6 +422,8 @@ Default value is: \fBmpath\fR
 .TP
 .B failback
 Tell multipathd how to manage path group failback.
+To select \fIimmediate\fR or a \fIvalue\fR, it's mandatory that the device
+has support for a working prioritizer and a 'preferred path'.
 .RS
 .TP 12
 .I immediate
@@ -440,7 +442,11 @@ another node requested the failover.
 .I values > 0
 Deferred failback (time to defer in seconds).
 .TP
-Default value is: \fBmanual\fR
+.\" XXX
+.I <unset>
+??? Undefined.
+.TP
+Default value is: \fB<unset>\fR
 .RE
 .
 .
-- 
2.7.4
