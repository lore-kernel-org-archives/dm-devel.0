From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 02/10] multipath-tools: add INFINIDAT devices
	to hardware table
Date: Fri, 17 Jun 2016 16:52:40 +0200
Message-ID: <1466175169-16684-2-git-send-email-xose.vazquez@gmail.com>
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

based on documentation provided by the manufacturer:
https://support.infinidat.com/hc/en-us/articles/202319222

  vendor "NFINIDAT"             <----- This is not a bug, it's _NFINIDAT_
  product "InfiniBox.*"
  prio alua
  path_grouping_policy group_by_prio
  path_checker tur
  path_selector "round-robin 0"
  features "0"
  failback 30
  rr_weight priorities
  no_path_retry fail
  rr_min_io 1    # for kernels up to 2.6.31
  rr_min_io_rq 1 # for kernels 2.6.31 or newer
  flush_on_last_del yes
  fast_io_fail_tmo 5
  dev_loss_tmo 30

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 726ee3b..0ea7968 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1192,6 +1192,25 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 300,
 	},
 	/*
+	 * Infinidat, Inc.
+	 */
+	{
+		.vendor        = "NFINIDAT",
+		.product       = "InfiniBox.*",
+		.prio_name     = PRIO_ALUA,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.checker_name  = TUR,
+		.selector      = "round-robin 0",
+		.features      = DEFAULT_FEATURES,
+		.pgfailback    = 30,
+		.rr_weight     = RR_WEIGHT_PRIO,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.minio_rq      = 1,
+		.flush_on_last_del = FLUSH_ENABLED,
+		.fast_io_fail  = 5,
+		.dev_loss      = 30,
+	},
+	/*
 	 * EOL
 	 */
 	{
-- 
2.5.5
