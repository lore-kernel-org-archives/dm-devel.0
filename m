From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: configure hitachi ams2000 and
	hus100 as full active arrays
Date: Mon, 14 May 2018 17:30:17 +0200
Message-ID: <20180514153017.7193-1-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEV ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

AMS2000 and HUS100 families are active/active arrays.

Based on https://support.hitachivantara.com/download/epcra/df818913.pdf
and internal hitachi docs.


Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 827e899..9705025 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -398,13 +398,13 @@ static struct hwentry default_hw[] = {
 	 * Mail : matthias.rudolph@hds.com
 	 */
 	{
-		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families */
+		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HP XP */
 		.vendor        = "(HITACHI|HP)",
 		.product       = "^OPEN-",
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* AMS 2000 and HUS 100 families */
+		/* AMS other than AMS 2000 */
 		.vendor        = "HITACHI",
 		.product       = "^DF",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -412,6 +412,12 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_HDS,
 	},
+	{
+		/* AMS 2000 and HUS 100 families */
+		.vendor        = "HITACHI",
+		.product       = "^DF600F",
+		.pgpolicy      = MULTIBUS,
+	},
 	/*
 	 * IBM
 	 *
-- 
2.17.0
