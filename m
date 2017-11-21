From: Joseph Qi <jiangqi903@gmail.com>
Subject: [PATCH v3 2/2] blk-throttle: fix wrong initialization in case of dm
 device
Date: Tue, 21 Nov 2017 09:42:11 +0800
Message-ID: <686ebf99-3c0a-491b-7df5-70740bebceeb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>, qijiang.qj@alibaba-inc.com
List-Id: dm-devel.ids

From: Joseph Qi <qijiang.qj@alibaba-inc.com>

DM device sets QUEUE_FLAG_NONROT after the queue is registered. That is
to mean, the previous initialization in blk_throtl_register_queue is
wrong in this case.
Fix it by checking and then updating the info during root tg
initialization as we don't have a better choice.

Signed-off-by: Joseph Qi <qijiang.qj@alibaba-inc.com>
Reviewed-by: Shaohua Li <shli@kernel.org>
---
 block/blk-throttle.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index bf52035..7150f14 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -541,6 +541,25 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
 	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && blkg->parent)
 		sq->parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
 	tg->td = td;
+
+#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
+	/*
+	 * DM device sets QUEUE_FLAG_NONROT after the queue is registered,
+	 * so the previous initialization is wrong in this case. Check and
+	 * update it here.
+	 */
+	if (blk_queue_nonrot(blkg->q) &&
+	    td->filtered_latency != LATENCY_FILTERED_SSD) {
+		int i;
+
+		td->throtl_slice = DFL_THROTL_SLICE_SSD;
+		td->filtered_latency = LATENCY_FILTERED_SSD;
+		for (i = 0; i < LATENCY_BUCKET_SIZE; i++) {
+			td->avg_buckets[READ][i].latency = 0;
+			td->avg_buckets[WRITE][i].latency = 0;
+		}
+	}
+#endif
 }
 
 /*
-- 
1.9.4
