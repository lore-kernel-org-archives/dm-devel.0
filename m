From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/9] multipath-tools: add iSCSI product id for
	TEGILE ZEBI
Date: Tue, 21 Jun 2016 02:35:56 +0200
Message-ID: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
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

Devices running 2.x firmware has a different product id for iSCSI.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 6116124..fb38320 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1195,7 +1195,7 @@ static struct hwentry default_hw[] = {
 	 */
 	{
 		.vendor        = "TEGILE",
-		.product       = "ZEBI-FC|INTELLIFLASH",
+		.product       = "ZEBI-(FC|ISCSI)|INTELLIFLASH",
 		.hwhandler     = "1 alua",
 		.selector      = "round-robin 0",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.5.5
