From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/14] blk-cgroup: remove a dead check in blk_throtl_bio
Date: Sat, 27 Jun 2020 09:31:59 +0200
Message-ID: <20200627073159.2447325-15-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

bios must have a valid block group by the time they are submitted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-throttle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9d00f62c05ecdf..ad37043297ed58 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2163,7 +2163,7 @@ bool blk_throtl_bio(struct bio *bio)
 	struct request_queue *q = bio->bi_disk->queue;
 	struct blkcg_gq *blkg = bio->bi_blkg;
 	struct throtl_qnode *qn = NULL;
-	struct throtl_grp *tg = blkg_to_tg(blkg ?: q->root_blkg);
+	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_service_queue *sq;
 	bool rw = bio_data_dir(bio);
 	bool throttled = false;
-- 
2.26.2
