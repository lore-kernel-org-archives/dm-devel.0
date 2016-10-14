From: tang.wenjun3@zte.com.cn
Subject: [PATCH 18/94] multipath-tools: SGI/TP9300 is a RDAC array
Date: Fri, 14 Oct 2016 09:56:00 +0800
Message-ID: <1476410236-9368-18-git-send-email-tang.wenjun3@zte.com.cn>
References: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1476410236-9368-1-git-send-email-tang.wenjun3@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 10144149@zte.com.cn
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

Confirmed by the original manufacturer(NetApp).

Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index eda30f6..e312a6f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -602,13 +602,13 @@ static struct hwentry default_hw[] = {
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
2.8.1.windows.1
