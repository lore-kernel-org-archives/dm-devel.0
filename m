From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 06/15] multipath-tools: SGI/TP9300 is a RDAC array
Date: Wed, 10 Aug 2016 18:20:29 +0200
Message-ID: <1470846038-6590-6-git-send-email-xose.vazquez@gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
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

Confirmed by the original manufacturer(NetApp).

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c101b02..b15020c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -610,13 +610,13 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		.vendor        = "SGI",
-		.product       = "TP9[13]00",
+		.product       = "TP9100",
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
 	{
 		.vendor        = "SGI",
-		.product       = "TP9[45]00",
+		.product       = "TP9[345]00",
 		.bl_product    = "Universal Xport",
 		.hwhandler     = "1 rdac",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.7.4
