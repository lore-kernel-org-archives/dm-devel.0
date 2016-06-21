From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/9] multipath-tools: unify DELL MD32xx and MD36xx
Date: Tue, 21 Jun 2016 02:35:59 +0200
Message-ID: <1466469364-14446-4-git-send-email-xose.vazquez@gmail.com>
References: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
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

They belong same family and share FW:
https://downloads.dell.com/manuals/common/md32xx_md36xx_supportmatrix2_en-us.pdf

The main differences are:
MD3200   6 Gbps direct attached SAS storage array with 12 drives (3.5 inch)
MD3220   6 Gbps direct attached SAS storage array with 24 drives (2.5 inch)
MD3260   6 Gbps direct Attached SAS storage dense array
MD3200i  1 Gbps iSCSI network storage array with 12 drives (3.5 inch)
MD3600i 10 Gbps iSCSI network storage array with 12 drives (3.5 inch)
MD3220i  1 Gbps iSCSI network storage array with 24 drives (2.5 inch)
MD3620i 10 Gbps iSCSI network storage array with 24 drives (2.5 inch)
MD3260i  1 Gbps iSCSI network storage dense array
MD3660i 10 Gbps iSCSI network storage dense array
MD3600f  8 Gbps fibre channel network storage array with 12 drives (3.5 inch)
MD3620f  8 Gbps fibre channel network storage array with 24 drives (2.5 inch)
MD3660f  8 Gbps fibre channel network storage dense array

A mandatory ACK from Hannes is required, as he was reluctant to unify them.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a8dc0de..031102c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -735,7 +735,7 @@ static struct hwentry default_hw[] = {
 	 * DELL
 	 */
 	{
-		/* DELL MD3000/MD3000i */
+		/* DELL MD3000 */
 		.vendor        = "DELL",
 		.product       = "MD3000",
 		.bl_product    = "Universal Xport",
@@ -750,24 +750,9 @@ static struct hwentry default_hw[] = {
 		.prio_args     = NULL,
 	},
 	{
-		/* DELL MD32xx/MD32xxi */
+		/* DELL MD32xx/MD36xx */
 		.vendor        = "DELL",
-		.product       = "MD32xx",
-		.bl_product    = "Universal Xport",
-		.features      = "2 pg_init_retries 50",
-		.hwhandler     = "1 rdac",
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 15,
-		.checker_name  = RDAC,
-		.prio_name     = PRIO_RDAC,
-		.prio_args     = NULL,
-	},
-	{
-		/* DELL MD36xxi/MD36xxf */
-		.vendor        = "DELL",
-		.product       = "MD36xx(i|f)",
+		.product       = "MD32xx|MD36xx",
 		.bl_product    = "Universal Xport",
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
-- 
2.5.5
