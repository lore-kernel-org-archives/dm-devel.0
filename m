From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] dm-rq: do not update rq partially in each ending bio
Date: Fri, 25 Aug 2017 23:27:49 +0800
Message-ID: <20170825152749.14435-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Ming Lei <ming.lei@redhat.com>, Laurence Oberman <loberman@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: dm-devel.ids

We don't need to update orignal dm request partially
when ending each cloned bio, and this patch just
updates orignal dm request once when the whole
cloned request is finished.

Partial request update can be a bit expensive, so
we should try to avoid it, especially it is run
in softirq context.

After this patch is applied, both hard lockup and
soft lockup aren't reproduced any more in one hour
of running Laurence's test[1] on IB/SRP. Without
this patch, the lockup can be reproduced in several
minutes.

BTW, after d4acf3650c7c(block: Make blk_mq_delay_kick_requeue_list()
rerun the queue at a quiet time), we need to make the
test more aggressive for reproducing the lockup:

	1) run hammer_write.sh 32 or 64 concurrently.
	2) write 8M each time

[1] https://marc.info/?l=linux-block&m=150220185510245&w=2

Cc: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c | 15 +++++----------
 drivers/md/dm-rq.h |  1 +
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c6ebc5b1e00e..50cd96c7de45 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -117,9 +117,9 @@ static void end_clone_bio(struct bio *clone)
 	struct dm_rq_clone_bio_info *info =
 		container_of(clone, struct dm_rq_clone_bio_info, clone);
 	struct dm_rq_target_io *tio = info->tio;
-	struct bio *bio = info->orig;
 	unsigned int nr_bytes = info->orig->bi_iter.bi_size;
 	blk_status_t error = clone->bi_status;
+	bool is_last = !clone->bi_next;
 
 	bio_put(clone);
 
@@ -144,21 +144,15 @@ static void end_clone_bio(struct bio *clone)
 	 * I/O for the bio successfully completed.
 	 * Notice the data completion to the upper layer.
 	 */
-
-	/*
-	 * bios are processed from the head of the list.
-	 * So the completing bio should always be rq->bio.
-	 * If it's not, something wrong is happening.
-	 */
-	if (tio->orig->bio != bio)
-		DMERR("bio completion is going in the middle of the request");
+	tio->completed += nr_bytes;
 
 	/*
 	 * Update the original request.
 	 * Do not use blk_end_request() here, because it may complete
 	 * the original request before the clone, and break the ordering.
 	 */
-	blk_update_request(tio->orig, BLK_STS_OK, nr_bytes);
+	if (is_last)
+		blk_update_request(tio->orig, BLK_STS_OK, tio->completed);
 }
 
 static struct dm_rq_target_io *tio_from_request(struct request *rq)
@@ -455,6 +449,7 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
 	tio->clone = NULL;
 	tio->orig = rq;
 	tio->error = 0;
+	tio->completed = 0;
 	/*
 	 * Avoid initializing info for blk-mq; it passes
 	 * target-specific data through info.ptr
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 9813922e4fe5..f43c45460aac 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -29,6 +29,7 @@ struct dm_rq_target_io {
 	struct dm_stats_aux stats_aux;
 	unsigned long duration_jiffies;
 	unsigned n_sectors;
+	unsigned completed;
 };
 
 /*
-- 
2.9.5
