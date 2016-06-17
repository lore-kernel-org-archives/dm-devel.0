From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 03/10] multipath-tools: add TEGILE devices to
	hardware table
Date: Fri, 17 Jun 2016 16:52:41 +0200
Message-ID: <1466175169-16684-3-git-send-email-xose.vazquez@gmail.com>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 0ea7968..d882f31 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1211,6 +1211,22 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = 30,
 	},
 	/*
+	 * Tegile Systems, Inc.
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
