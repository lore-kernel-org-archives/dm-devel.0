From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: cosmetic changes in hwtable
Date: Sun, 22 Sep 2019 01:40:39 +0200
Message-ID: <20190921234039.26515-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Tegile IntelliFlash was acquired by DDN, from WD.

HPE Primera is also identified as 3PARdata/VV

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a06872e..7a8f276 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -107,7 +107,7 @@ static struct hwentry default_hw[] = {
 	 * HPE
 	 */
 	{
-		/* 3PAR */
+		/* 3PAR / Primera */
 		.vendor        = "3PARdata",
 		.product       = "VV",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -311,6 +311,16 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.no_path_retry = 30,
 	},
+	{
+		/* Tegile IntelliFlash */
+		.vendor        = "TEGILE",
+		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
+		.hwhandler     = "1 alua",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 10,
+	},
 	/*
 	 * Dell EMC
 	 */
@@ -1074,19 +1084,6 @@ static struct hwentry default_hw[] = {
 		.product       = "K2",
 		.pgpolicy      = MULTIBUS,
 	},
-	/*
-	 * Western Digital (Tegile Systems)
-	 */
-	{
-		/* IntelliFlash */
-		.vendor        = "TEGILE",
-		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
-		.hwhandler     = "1 alua",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.prio_name     = PRIO_ALUA,
-		.no_path_retry = 10,
-	},
 	/*
 	 * Imation/Nexsan
 	 */
-- 
2.23.0
