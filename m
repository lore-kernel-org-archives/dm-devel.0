From: tang.wenjun3@zte.com.cn
Subject: [PATCH 19/94] multipath-tools: add Oracle FS to hwtable
Date: Fri, 14 Oct 2016 09:56:01 +0800
Message-ID: <1476410236-9368-19-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

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
index e312a6f..ed6e02b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -645,19 +645,27 @@ static struct hwentry default_hw[] = {
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
2.8.1.windows.1
