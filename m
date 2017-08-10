From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add support for all arrays from
	Sun StorEdge 3000 family
Date: Thu, 10 Aug 2017 21:18:09 +0200
Message-ID: <20170810191809.9131-1-xose.vazquez@gmail.com>
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

They were made by Dot Hill.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index dd3d12f..bcd24b3 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -796,9 +796,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* 3510 */
+		/* (Dot Hill) 3310, 3320, 3510 and 3511 */
 		.vendor        = "SUN",
-		.product       = "StorEdge 3510",
+		.product       = "StorEdge 3",
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-- 
2.13.4
