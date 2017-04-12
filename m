From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/2] multipath: Merge the DELL MD3xxx device
	configs
Date: Wed, 12 Apr 2017 17:15:09 -0500
Message-ID: <1492035310-27525-2-git-send-email-bmarzins@redhat.com>
References: <1492035310-27525-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1492035310-27525-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

All of the Dell MD3xxx configs are identical, so we can't just use
one config for them.

Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c944015..54309ef 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -227,31 +227,7 @@ static struct hwentry default_hw[] = {
 		/* MD Series */
 	{
 		.vendor        = "DELL",
-		.product       = "MD3000",
-		.bl_product    = "Universal Xport",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.checker_name  = RDAC,
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.prio_name     = PRIO_RDAC,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 30,
-	},
-	{
-		.vendor        = "DELL",
-		.product       = "(MD32xx|MD36xx)",
-		.bl_product    = "Universal Xport",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.checker_name  = RDAC,
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.prio_name     = PRIO_RDAC,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.no_path_retry = 30,
-	},
-	{
-		.vendor        = "DELL",
-		.product       = "(MD34xx|MD38xx)",
+		.product       = "^MD3",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
-- 
1.8.3.1
