From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: identify some IBM FlashSystem
	arrays
Date: Fri, 19 Aug 2016 18:29:11 +0200
Message-ID: <1471624151-4751-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

System             Vendor Product Multipathing Policy
================== ====== ======= ===================================================================
FlashSystem V840   IBM    2145    ALUA (1 Target Port Group per Controller)
FlashSystem V9000  IBM    2145    ALUA (1 Target Port Group per Controller)
FlashSystem A9000  IBM    2810XIV ALUA (All ports across all controllers in single Target Port Group)
FlashSystem A9000R IBM    2810XIV ALUA (All ports across all controllers in single Target Port Group)

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index eedb360..aaf7480 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -439,7 +439,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
 	{
-		/* Storwize family / SAN Volume Controller / Flex System V7000 */
+		/* Storwize family / SAN Volume Controller / Flex System V7000 / FlashSystem V840/V9000 */
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -481,7 +481,7 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 	},
 	{
-		/* XIV Storage System */
+		/* XIV Storage System / FlashSystem A9000/A9000R */
 		.vendor        = "IBM",
 		.product       = "2810XIV",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
-- 
2.7.4
