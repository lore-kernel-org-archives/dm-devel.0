From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add INFINIDAT devices to
	hardware table
Date: Tue, 14 Jun 2016 00:46:56 +0200
Message-ID: <1465858016-12175-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 44a4669..650dee6 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1211,6 +1211,28 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = 30,
 	},
 	/*
+	 * Infinidat, Inc.
+	 *
+	 * Maintainer : Christophe Varoqui
+	 * Mail : christophe.varoqui@opensvc.com
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
