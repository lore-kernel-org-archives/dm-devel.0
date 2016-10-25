From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: identify STK/SUN array
Date: Tue, 25 Oct 2016 23:01:32 +0200
Message-ID: <20161025210132.3531-1-xose.vazquez@gmail.com>
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

FlexLine FLX380 was renamed to StorageTek 6540

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 8d98800..0199bf8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -738,6 +738,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
+		/* 6540 */
 		.vendor        = "STK",
 		.product       = "FLEXLINE 380",
 		.bl_product    = "Universal Xport",
-- 
2.10.1
