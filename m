From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH resend] multipath-tools: reorder vendors in
	hwtable
Date: Sun, 17 Mar 2019 00:05:06 +0100
Message-ID: <20190316230506.22263-1-xose.vazquez@gmail.com>
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

Xio was acquired by Violin, and add FlashSystem 9100 to Storwize in comments.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 50 ++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index d3a8d9b..3eeadde 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -604,7 +604,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-		/* Storwize family / SAN Volume Controller / Flex System V7000 / FlashSystem V840/V9000 */
+		/* Storwize family / SAN Volume Controller / Flex System V7000 / FlashSystem V840/V9000/9100 */
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
@@ -1099,31 +1099,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	/*
-	 * Xiotech
-	 */
-	{
-		/* Intelligent Storage Elements family */
-		.vendor        = "(XIOTECH|XIOtech)",
-		.product       = "ISE",
-		.pgpolicy      = MULTIBUS,
-		.no_path_retry = 12,
-	},
-	{
-		/* iglu blaze family */
-		.vendor        = "(XIOTECH|XIOtech)",
-		.product       = "IGLU DISK",
-		.pgpolicy      = MULTIBUS,
-		.no_path_retry = 30,
-	},
-	{
-		/* Magnitude family */
-		.vendor        = "(XIOTECH|XIOtech)",
-		.product       = "Magnitude",
-		.pgpolicy      = MULTIBUS,
-		.no_path_retry = 30,
-	},
-	/*
-	 * Violin Memory
+	 * Violin Systems
 	 */
 	{
 		/* 3000 / 6000 Series */
@@ -1148,6 +1124,28 @@ static struct hwentry default_hw[] = {
 		.product       = "CONCERTO ARRAY",
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
+	},
+		/* Xiotech */
+	{
+		/* Intelligent Storage Elements family */
+		.vendor        = "(XIOTECH|XIOtech)",
+		.product       = "ISE",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 12,
+	},
+	{
+		/* iglu blaze family */
+		.vendor        = "(XIOTECH|XIOtech)",
+		.product       = "IGLU DISK",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
+	{
+		/* Magnitude family */
+		.vendor        = "(XIOTECH|XIOtech)",
+		.product       = "Magnitude",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
 	},
 	/*
 	 * Promise Technology
-- 
2.20.1
