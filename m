From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Nexsan E-Series and
	SATABeast/SATABoy to hwtable
Date: Sat,  8 Oct 2016 22:58:07 +0200
Message-ID: <20161008205807.13113-1-xose.vazquez@gmail.com>
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

Based on documentation provided by the manufacturer:
http://support2.imation.com/downloads/nxs/crmkb5/Nexsan_Multipathing_Best_Practices_Guide.pdf

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 637be3d..9a968a7 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -905,6 +905,27 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.no_path_retry = 10,
 	},
+	/*
+	 * Imation/Nexsan
+	 */
+	{
+		/* E-Series */
+		.vendor        = "NEXSAN",
+		.product       = "NXS-B0",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 15,
+	},
+	{
+		/* SATABeast / SATABoy */
+		.vendor        = "NEXSAN",
+		.product       = "SATAB",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+		.no_path_retry = 15,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.10.1
