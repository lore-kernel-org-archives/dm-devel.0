From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove Sun StorEdge T4(6020,
	6120, 6320) arrays from hwtable
Date: Wed,  9 Aug 2017 19:00:56 +0200
Message-ID: <20170809170056.5015-1-xose.vazquez@gmail.com>
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
Cc: James Cassidy <jcassidy@qfire.net>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Multipathing for these arrays is not supported by multipath-tools.
Only available with Sun StorEdge Traffic Manager software.
Or with a "new" infrastructure: https://marc.info/?l=dm-devel&m=116322662722330

Cc: James Cassidy <jcassidy@qfire.net>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9e14ec1..dd3d12f 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -796,9 +796,9 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 	},
 	{
-		/* 3510 / 6020 and 6120 */
+		/* 3510 */
 		.vendor        = "SUN",
-		.product       = "(StorEdge 3510|T4)",
+		.product       = "StorEdge 3510",
 		.pgpolicy      = MULTIBUS,
 	},
 	{
-- 
2.13.4
