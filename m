From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 2/7] dm rq: leverage blk_mq_queue_busy() to
	check for outstanding IO
Date: Wed,  5 Dec 2018 15:24:28 -0500
Message-ID: <20181205202433.95823-3-snitzer@redhat.com>
References: <20181205202433.95823-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181205202433.95823-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Now that request-based dm-multipath only supports blk-mq, make use of
the newly introduced blk_mq_queue_busy() to check for outstanding IO --
rather than (ab)using the block core's in_flight counters.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1f1fe9a618ea..d2397d8fcbd1 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -130,11 +130,11 @@ static void rq_end_stats(struct mapped_device *md, struct request *orig)
  */
 static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 {
-	atomic_dec(&md->pending[rw]);
-
 	/* nudge anyone waiting on suspend queue */
-	if (!md_in_flight(md))
-		wake_up(&md->wait);
+	if (unlikely(waitqueue_active(&md->wait))) {
+		if (!blk_mq_queue_busy(md->queue))
+			wake_up(&md->wait);
+	}
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
@@ -436,7 +436,6 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
 static void dm_start_request(struct mapped_device *md, struct request *orig)
 {
 	blk_mq_start_request(orig);
-	atomic_inc(&md->pending[rq_data_dir(orig)]);
 
 	if (unlikely(dm_stats_used(&md->stats))) {
 		struct dm_rq_target_io *tio = tio_from_request(orig);
-- 
2.18.0
