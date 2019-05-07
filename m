From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: format correctly maintainer
	info in hwtable
Date: Tue,  7 May 2019 20:53:09 +0200
Message-ID: <20190507185309.21050-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1d96433..1fade7e 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -38,7 +38,7 @@
 	 *
 	 * COMPANY_NAME
 	 *
-	 * Maintainer: XXX <email>
+	 * Maintainer: NAME <email>
 	 */
 	{
 		/* Product Name */
@@ -708,7 +708,7 @@ static struct hwentry default_hw[] = {
                 /*
 		 * DE Series
 		 *
-		 * Maintainer: ng-eseries-upstream-maintainers@netapp.com
+		 * Maintainer: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
 		 */
                 .vendor        = "LENOVO",
                 .product       = "DE_Series",
-- 
2.21.0
