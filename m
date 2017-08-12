From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Dot Hill/Seagate arrays to
	hwtable
Date: Sat, 12 Aug 2017 18:30:36 +0200
Message-ID: <20170812163036.11816-1-xose.vazquez@gmail.com>
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
 libmultipath/hwtable.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9d3df11..b0ae466 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1124,6 +1124,34 @@ static struct hwentry default_hw[] = {
 		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
 	/*
+	 * Dot Hill Systems - Seagate Technology
+	 */
+	{
+		/* SANnet family */
+		.vendor        = "DotHill",
+		.product       = "SANnet",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
+	{
+		/* R/Evolution family */
+		.vendor        = "DotHill",
+		.product       = "R/Evo",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
+	{
+		/* AssuredSAN family */
+		.vendor        = "DotHill",
+		.product       = "^DH",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 30,
+	},
+	/*
 	 * EOL
 	 */
 	{
-- 
2.13.4
