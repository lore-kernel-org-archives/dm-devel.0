From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/16] block: account merge of two requests
Date: Wed, 27 May 2020 07:24:15 +0200
Message-ID: <20200527052419.403583-13-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Also rename blk_account_io_merge() into blk_account_io_merge_request() to
distinguish it from merging request and bio.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
[hch: rebased]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6a4538d39efd2..c3beae5c1be71 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -669,18 +669,16 @@ void blk_rq_set_mixed_merge(struct request *rq)
 	rq->rq_flags |= RQF_MIXED_MERGE;
 }
 
-static void blk_account_io_merge(struct request *req)
+static void blk_account_io_merge_request(struct request *req)
 {
 	if (blk_do_io_stat(req)) {
-		struct hd_struct *part;
-
 		part_stat_lock();
-		part = req->part;
-
-		hd_struct_put(part);
+		part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
+		hd_struct_put(req->part);
 		part_stat_unlock();
 	}
 }
+
 /*
  * Two cases of handling DISCARD merge:
  * If max_discard_segments > 1, the driver takes every bio
@@ -792,7 +790,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	/*
 	 * 'next' is going away, so update stats accordingly
 	 */
-	blk_account_io_merge(next);
+	blk_account_io_merge_request(next);
 
 	/*
 	 * ownership of bio passed from next to req, return 'next' for
-- 
2.26.2
