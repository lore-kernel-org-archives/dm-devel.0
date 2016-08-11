From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 01/11] multipath-tools: add support for all IBM
	Enterprise Storage Server / Shark family
Date: Thu, 11 Aug 2016 20:32:17 +0200
Message-ID: <1470940345-4441-1-git-send-email-xose.vazquez@gmail.com>
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

Only F20 and 800 were included:
2105F20 IBM Enterprise Storage Server Model F20
2105800 IBM TotalStorage Enterprise Storage Server Model 800

Added all of them with just "^2105"
2105E10 IBM Enterprise Storage Server Model E10
2105E20 IBM Enterprise Storage Server Model E20
2105F10 IBM Enterprise Storage Server Model F10
2105750 IBM TotalStorage Enterprise Storage Server Model 750

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index edfd8fe..cd052e4 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -444,17 +444,9 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* Enterprise Storage Server / Shark 800 */
+		/* Enterprise Storage Server / Shark family */
 		.vendor        = "IBM",
-		.product       = "^2105800",
-		.features      = "1 queue_if_no_path",
-		.pgpolicy      = GROUP_BY_SERIAL,
-		.pgfailback    = FAILBACK_UNDEF,
-	},
-	{
-		/* Enterprise Storage Server / Shark F20 */
-		.vendor        = "IBM",
-		.product       = "^2105F20",
+		.product       = "^2105",
 		.features      = "1 queue_if_no_path",
 		.pgpolicy      = GROUP_BY_SERIAL,
 		.pgfailback    = FAILBACK_UNDEF,
-- 
2.7.4
