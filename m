From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/6] dm: fix comment in dm_process_bio()
Date: Mon, 21 Sep 2020 22:32:47 -0400
Message-ID: <20200922023251.47712-3-snitzer@redhat.com>
References: <20200922023251.47712-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
In-Reply-To: <20200922023251.47712-1-snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Refer to the correct function (->submit_bio instead of ->queue_bio).
Also, add details about why using blk_queue_split() isn't needed for
dm_wq_work()'s call to dm_process_bio().

Fixes: c62b37d96b6eb ("block: move ->make_request_fn to struct block_device_operations")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d948cd522431..6ed05ca65a0f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1744,9 +1744,11 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 	}
 
 	/*
-	 * If in ->queue_bio we need to use blk_queue_split(), otherwise
+	 * If in ->submit_bio we need to use blk_queue_split(), otherwise
 	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
 	 * won't be imposed.
+	 * If called from dm_wq_work() for deferred bio processing, bio
+	 * was already handled by following code with previous ->submit_bio.
 	 */
 	if (current->bio_list) {
 		if (is_abnormal_io(bio))
-- 
2.15.0
