From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add TEGILE devices to hardware
	table
Date: Mon, 13 Jun 2016 16:38:50 +0200
Message-ID: <1465828730-11869-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

based on documentation provided by manufacturer:
http://pages.tegile.com/rs/568-BVY-995/images/Oracle%20BPG%201.0.pdf

vendor                  "TEGILE"
product                 "ZEBI-FC|INTELLIFLASH"
hardware_handler        "1 alua"
path_selector           "round- robin 0"
path_grouping_policy    "group_by_prio"
no_path_retry           10
dev_loss_tmo            50
path_checker            tur
prio                    alua
failback                30
rr_min_io               128

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 66b5123..a126b7c 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1176,6 +1176,25 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 	},
 	/*
+	 * Tegile Systems, Inc.
+	 *
+	 * Maintainer : Christophe Varoqui
+	 * Mail : christophe.varoqui@opensvc.com
+	 */
+	{
+		.vendor        = "TEGILE",
+		.product       = "ZEBI-FC|INTELLIFLASH",
+		.hwhandler     = "1 alua",
+		.selector      = "round-robin 0",
+		.pgpolicy      = GROUP_BY_PRIO,
+		.no_path_retry = 10,
+		.dev_loss      = 50,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
+		.pgfailback    = 30,
+		.minio         = 128,
+	},
+	/*
 	 * EOL
 	 */
 	{
-- 
2.5.5
