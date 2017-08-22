From: Arnon Yaari <arnony@infinidat.com>
Subject: [PATCH] libmultipath: update INFINIDAT builtin config
Date: Tue, 22 Aug 2017 16:37:58 +0300
Message-ID: <392CDE41-4C36-41B1-8811-B7EC93F0864C@infinidat.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Based on the manufacturer documentation:
https://support.infinidat.com/hc/en-us/articles/202319222

Signed-off-by: Arnon Yaari <arnony@infinidat.com>
---
 libmultipath/hwtable.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 9e14ec1e..1ea48d58 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -969,8 +969,18 @@ static struct hwentry default_hw[] = {
 		.vendor        = "NFINIDAT",
 		.product       = "InfiniBox",
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.pgfailback    = 30,
 		.prio_name     = PRIO_ALUA,
+		.checker_name  = TUR,
+		.selector      = "round-robin 0",
+		.features      = "0",
+		.rr_weight     = RR_WEIGHT_PRIO,
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.minio         = 1,
+		.minio_rq      = 1,
+		.flush_on_last_del = FLUSH_ENABLED,
+		.fast_io_fail  = 15,
+		.dev_loss      = 15,
 	},
 	/*
 	 * Nimble Storage
-- 
2.11.0
