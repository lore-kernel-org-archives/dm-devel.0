From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/16] block: reduce part_stat_lock() scope
Date: Wed, 27 May 2020 07:24:19 +0200
Message-ID: <20200527052419.403583-17-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

We only need the stats lock (aka preempt_disable()) for updating the
states, not for looking up or dropping the hd_struct reference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 block/blk-core.c  | 5 +++--
 block/blk-merge.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf2f7d4bc0c1c..a01fb2b508f0e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1437,9 +1437,9 @@ void blk_account_io_done(struct request *req, u64 now)
 		update_io_ticks(part, jiffies, true);
 		part_stat_inc(part, ios[sgrp]);
 		part_stat_add(part, nsecs[sgrp], now - req->start_time_ns);
+		part_stat_unlock();
 
 		hd_struct_put(part);
-		part_stat_unlock();
 	}
 }
 
@@ -1448,8 +1448,9 @@ void blk_account_io_start(struct request *rq)
 	if (!blk_do_io_stat(rq))
 		return;
 
-	part_stat_lock();
 	rq->part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
+
+	part_stat_lock();
 	update_io_ticks(rq->part, jiffies, false);
 	part_stat_unlock();
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index c3beae5c1be71..f0b0bae075a0c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -674,8 +674,9 @@ static void blk_account_io_merge_request(struct request *req)
 	if (blk_do_io_stat(req)) {
 		part_stat_lock();
 		part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
-		hd_struct_put(req->part);
 		part_stat_unlock();
+
+		hd_struct_put(req->part);
 	}
 }
 
-- 
2.26.2
