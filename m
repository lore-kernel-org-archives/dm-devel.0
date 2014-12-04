From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: [PATCH]libmultipath: Add default hardware table entry
 for IBM DCS3860 with product ID 1813.
Date: Thu, 4 Dec 2014 16:22:10 +0000
Message-ID: <8c81ce8c69dc4c92913c2f1c3c6b50fd@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Adding default hw entry for IBM DCS3860 storage array with product id
1813 and merging similar hw entries together.

Signed-off-by: Shiva Krishna Merla <shivakrishna.merla@netapp.com>
---
 libmultipath/hwtable.c | 34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a9dde7f..927d8ca 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -445,39 +445,9 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-	    /* IBM DS4700 */
+		/* IBM DCS3860 / DS4700 / DS4800 / DS5000 */
 		.vendor        = "IBM",
-		.product       = "^1814",
-		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
-	},
-	{
-	    /* IBM DS4800 */
-		.vendor        = "IBM",
-		.product       = "^1815",
-		.bl_product    = "Universal Xport",
-		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_QUEUE,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
-	},
-	{
-	    /* IBM DS5000 */
-		.vendor        = "IBM",
-		.product       = "^1818",
+		.product       = "^1813|^1814|^1815|^1818",
 		.bl_product    = "Universal Xport",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
--
