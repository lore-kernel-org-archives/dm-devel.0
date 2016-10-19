From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add Promise arrays to hwtable
Date: Thu, 20 Oct 2016 00:43:40 +0200
Message-ID: <20161019224340.5143-1-xose.vazquez@gmail.com>
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

and blacklist "VTrak V-LUN" also for ALUA.

Based on info from manufacturer:
https://downloadmirror.intel.com/18617/eng/RHEL6_MPIO_Setup.pdf
http://www.promise.com/media_bank/Download%20Bank/Utility/SUG_v0.85.pdf

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 7f499db..223dc08 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -827,6 +827,7 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor	       = "(Intel|INTEL)",
 		.product       = "Multi-Flex",
+		.bl_product    = "VTrak V-LUN",
 		.hwhandler     = "1 alua",
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -1002,6 +1003,16 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
+	/*
+	 * Promise Technology
+	 */
+	{
+		.vendor        = "Promise",
+		.product       = "VTrak",
+		.bl_product    = "VTrak V-LUN",
+		.pgpolicy      = MULTIBUS,
+		.no_path_retry = 30,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.10.1
