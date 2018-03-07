From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: reformat and update
	comments in hwtable
Date: Thu,  8 Mar 2018 00:10:00 +0100
Message-ID: <20180307231000.5255-2-xose.vazquez@gmail.com>
References: <20180307231000.5255-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307231000.5255-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 65b7835..fe71d14 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -72,13 +72,13 @@
 		.delay_wait_checks = DELAY_CHECKS_OFF,
 		.skip_kpartx   = SKIP_KPARTX_OFF,
 		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
-		.ghost_delay = GHOST_DELAY_OFF
+		.ghost_delay   = GHOST_DELAY_OFF,
 	},
 #endif
 
 static struct hwentry default_hw[] = {
        /*
-	* Generic NVMe devices
+	* Generic NVMe
 	*
 	* Due to the parsing logic in find_hwe(), generic entries
 	* have to be put on top of this list, and more specific ones
@@ -178,7 +178,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* MSA 1040, 2040 and 2050 families */
+		/* MSA 1040, 1050, 2040 and 2050 families */
 		.vendor        = "HP",
 		.product       = "MSA [12]0[45]0 SA[NS]",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -264,7 +264,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* DDN */
+		/* (DDN) */
 		.vendor        = "SGI",
 		.product       = "^DD[46]A-",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -397,7 +397,7 @@ static struct hwentry default_hw[] = {
 	 * Mail : matthias.rudolph@hds.com
 	 */
 	{
-		/* USP-V, HUS VM, VSP, VSP G1000 and VSP GX00 families */
+		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families */
 		.vendor        = "(HITACHI|HP)",
 		.product       = "^OPEN-",
 		.pgpolicy      = MULTIBUS,
@@ -646,7 +646,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* DDN */
+		/* (DDN) DCS9900, SONAS 2851-DR1 */
 		.vendor        = "IBM",
 		.product       = "^(DCS9900|2851)",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -731,12 +731,12 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 24,
 	},
-	/*
-	 * NetApp NVMe-FC namespace devices: MULTIBUS, queueing preferred
-	 *
-	 * The table is searched backwards, so place this after generic NVMe
-	 */
 	{
+		/*
+		 * NVMe-FC namespace devices: MULTIBUS, queueing preferred
+		 *
+		 * The hwtable is searched backwards, so place this after "Generic NVMe"
+		 */
 		.vendor	       = "NVME",
 		.product       = "^NetApp ONTAP Controller",
 		.uid_attribute = "ID_WWN",
@@ -1158,7 +1158,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	/*
-	 * Dot Hill Systems - Seagate Technology
+	 * Seagate Technology (Dot Hill Systems)
 	 */
 	{
 		/* SANnet family */
-- 
2.14.3
