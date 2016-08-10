From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 07/15] multipath-tools: add Oracle FS to hwtable
Date: Wed, 10 Aug 2016 18:20:30 +0200
Message-ID: <1470846038-6590-7-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Based on info from the manufacturer.
And also add ^ to Axiom.

Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index b15020c..f7cd456 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -653,19 +653,27 @@ static struct hwentry default_hw[] = {
 	/*
 	 * Oracle
 	 */
-	{
 		/*
-		 * Pillar Data
+		 * Pillar Data / Oracle FS
 		 *
 		 * Maintainer : Srinivasan Ramani
 		 * Mail : srinivas.ramani@oracle.com
 		 */
-		.vendor        = "Pillar",
-		.product       = "Axiom",
+	{
+		.vendor        = "^Pillar",
+		.product       = "^Axiom",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+	},
+	{
+		.vendor        = "^Oracle",
+		.product       = "^Oracle FS",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.prio_name     = PRIO_ALUA,
 	},
+		/* Sun - StorageTek */
 	{
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
-- 
2.7.4
