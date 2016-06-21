From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/9] multipath-tools: add DELL MD34xx/MD38xx
Date: Tue, 21 Jun 2016 02:36:00 +0200
Message-ID: <1466469364-14446-5-git-send-email-xose.vazquez@gmail.com>
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

New MD34xx/MD38xx family based also on RDAC:
http://downloads.dell.com/manuals/common/md34xx_md38xx_support%20matrix2_en-us.pdf

MD3400   12 Gbps direct attached SAS storage array with 12 drives (3.5 inch)
MD3420   12 Gbps direct attached SAS storage array with 24 drives (2.5 inch)
MD3460   12 Gbps direct attached SAS storage dense array
MD3800i  10 Gbps iSCSI network storage array with 12 drives (3.5 inch)
MD3820i  10 Gbps iSCSI network storage array with 24 drives (2.5 inch)
MD3860i  10 Gbps iSCSI network storage dense array
MD3800f  16 Gbps FC network storage array with 12 drives (3.5 inch)
MD3820f  16 Gbps FC network storage array with 24 drives (2.5 inch)
MD3860f  16 Gbps FC network storage dense array

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 031102c..62e284d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -764,6 +764,21 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_RDAC,
 		.prio_args     = NULL,
 	},
+	{
+		/* DELL MD34xx/MD38xx */
+		.vendor        = "DELL",
+		.product       = "MD34xx|MD38xx",
+		.bl_product    = "Universal Xport",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.checker_name  = RDAC,
+		.prio_name     = PRIO_RDAC,
+		.prio_args     = NULL,
+	},
 	/*
 	 * NETAPP
 	 */
-- 
2.5.5
