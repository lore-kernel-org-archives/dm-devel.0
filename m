From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix products names in hwtable
Date: Thu,  5 Jul 2018 20:55:05 +0200
Message-ID: <20180705185505.5920-1-xose.vazquez@gmail.com>
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
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 478bf16..d3a8d9b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -581,7 +581,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* Enterprise Storage Server / Shark family */
+		/* Enterprise Storage Server(ESS) / Shark family */
 		.vendor        = "IBM",
 		.product       = "^2105",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -613,7 +613,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* DS6000/DS8000 DASD ECKD */
+		/* PAV DASD ECKD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product    = "S/390",
@@ -623,7 +623,7 @@ static struct hwentry default_hw[] = {
 		.checker_name  = DIRECTIO,
 	},
 	{
-		/* DS6000/DS8000 DASD FBA */
+		/* PAV DASD FBA */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
 		.bl_product    = "S/390",
-- 
2.17.1
