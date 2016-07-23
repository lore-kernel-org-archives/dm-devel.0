From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/5] multipath-tools: Clarify template rules of
	hwtable
Date: Sat, 23 Jul 2016 02:29:09 +0200
Message-ID: <1469233752-11708-2-git-send-email-xose.vazquez@gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8eec209..6f9adc9 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -762,7 +762,8 @@ static struct hwentry default_hw[] = {
 	 * Copy this TEMPLATE to add new hardware.
 	 *
 	 * Keep only mandatory and modified attributes.
-	 * Standard attributes must be removed.
+	 * Attributes with default values must be removed.
+	 * .vendor and .product are mandatory, all other are optional.
 	 *
 	 * COMPANY_NAME
 	 *
@@ -770,8 +771,8 @@ static struct hwentry default_hw[] = {
 	 * Mail : XXX
 	 */
 	{
-		.vendor        = "VENDOR", (Mandatory)
-		.product       = "PRODUCT", (Mandatory)
+		.vendor        = "VENDOR",
+		.product       = "PRODUCT",
 		.revision      = "REVISION",
 		.bl_product    = "BL_PRODUCT",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.7.4
