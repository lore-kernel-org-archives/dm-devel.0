From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add two rdac devices
Date: Sat, 13 Aug 2016 18:05:01 +0200
Message-ID: <1471104301-5702-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

Sun StorEdge 6130 and SGI TP9700.

They were include in the kernel rdac side, but never in mpt:
https://bugzilla.redhat.com/524335
https://marc.info/?l=dm-devel&m=130203604024614

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a489d6c..10d89d7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -613,7 +613,7 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "SGI",
-		.product       = "TP9[345]00",
+		.product       = "TP9[3457]00",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
@@ -715,9 +715,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* 6140 */
+		/* 6130 / 6140 */
 		.vendor        = "SUN",
-		.product       = "CSM200_R",
+		.product       = "CSM[12]00_R",
 		.bl_product    = "Universal Xport",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.checker_name  = RDAC,
-- 
2.7.4
