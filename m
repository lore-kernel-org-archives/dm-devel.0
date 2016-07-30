From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 05/18] multipath-tools: add Nimble to hwtable
Date: Sat, 30 Jul 2016 02:28:13 +0200
Message-ID: <1469838506-15689-5-git-send-email-xose.vazquez@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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
http://www.nimblestorage.com/bpg_nimble_storage_linux_fibre_channel.pdf

vendor "Nimble"
product "Server"
prio "alua"
path_grouping_policy group_by_prio
path_checker tur
hardware_handler "1 alua"
features "1 queue_if_no_path"
rr_weight priorities
rr_min_io_rq 20
failback 10
path_selector "round-robin 0"
dev_loss_tmo infinity
fast_io_fail_tmo 1

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bd0bd8c..673148a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -785,6 +785,22 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = DEFAULT_NO_PATH_RETRY,
 	},
+	/*
+	 * Nimble Storage
+	 */
+	{
+		.vendor        = "Nimble",
+		.product       = "Server",
+		.prio_name     = PRIO_ALUA,
+		.hwhandler     = "1 alua",
+		.features      = "1 queue_if_no_path",
+		.rr_weight     = RR_WEIGHT_PRIO,
+		.minio_rq      = 20,
+		.pgfailback    = 10,
+		.selector      = "round-robin 0",
+		.dev_loss      = MAX_DEV_LOSS_TMO,
+		.fast_io_fail  = 1,
+	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.7.4
