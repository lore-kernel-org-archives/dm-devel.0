From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 01/15] multipath-tools: identify more devices at
	hwtable
Date: Wed, 10 Aug 2016 18:20:24 +0200
Message-ID: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 2192d38..1222f47 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -468,7 +468,7 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
-		/* SAN Volume Controller / Storwize */
+		/* Storwize family / SAN Volume Controller / Flex System V7000 */
 		.vendor        = "IBM",
 		.product       = "^2145",
 		.features      = "1 queue_if_no_path",
@@ -811,6 +811,7 @@ static struct hwentry default_hw[] = {
 	 * Huawei
 	 */
 	{
+		/* OceanStor V3 */
 		.vendor        = "(HUAWEI|HUASY)",
 		.product       = "XSG1",
 		.pgpolicy      = MULTIBUS,
-- 
2.7.4
