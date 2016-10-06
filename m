From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add INFINIDAT arrays to hwtable
Date: Thu,  6 Oct 2016 23:09:14 +0200
Message-ID: <20161006210914.24206-1-xose.vazquez@gmail.com>
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
https://support.infinidat.com/hc/en-us/articles/202319222

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1fc2f24..d3ffbea 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -850,6 +850,16 @@ static struct hwentry default_hw[] = {
 		.product       = "XPD",
 		.pgpolicy      = MULTIBUS,
 	},
+	/*
+	 * Infinidat
+	 */
+	{
+		.vendor        = "NFINIDAT",
+		.product       = "InfiniBox",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.prio_name     = PRIO_ALUA,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.10.1
