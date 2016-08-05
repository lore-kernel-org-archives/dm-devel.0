From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v3 2/2] multipath-tools: inform that regex can be
	used in vendor, product, .revision and bl_product
Date: Sat,  6 Aug 2016 01:25:05 +0200
Message-ID: <1470439505-7156-1-git-send-email-xose.vazquez@gmail.com>
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

Right now some regexes are too wide, for example: "HITACHI"/"DF" or "SGI"/"IS".
They should be used more extensively, at least, in product-ID.
As I did in 34e345e8

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e46a7c2..187c109 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -868,6 +868,7 @@ static struct hwentry default_hw[] = {
 	 * Keep only mandatory and modified attributes.
 	 * Attributes with default values must be removed.
 	 * .vendor and .product are mandatory, all other are optional.
+	 * POSIX Extended regex can be used in .vendor, .product, .revision and .bl_product
 	 *
 	 * COMPANY_NAME
 	 *
-- 
2.7.4
