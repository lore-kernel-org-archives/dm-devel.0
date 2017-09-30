From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/5] dm-mpath: cache ti->clone during requeue
Date: Sat, 30 Sep 2017 19:46:51 +0800
Message-ID: <20170930114652.32441-5-ming.lei@redhat.com>
References: <20170930114652.32441-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170930114652.32441-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

During requeue, block layer won't change the request any
more, such as no merge, so we can cache ti->clone and
let .clone_and_map_rq check if the cache can be hit.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-mpath.c | 31 ++++++++++++++++++++++++-------
 drivers/md/dm-rq.c    | 41 +++++++++++++++++++++++++++++------------
 2 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 9ee223170ee9..52e4730541fd 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -457,6 +457,11 @@ do {									\
 		 dm_noflush_suspending((m)->ti));			\
 } while (0)
 
+static void multipath_release_clone(struct request *clone)
+{
+	blk_put_request(clone);
+}
+
 /*
  * Map cloned requests (request-based multipath)
  */
@@ -470,7 +475,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	struct block_device *bdev;
 	struct dm_mpath_io *mpio = get_mpio(map_context);
 	struct request_queue *q;
-	struct request *clone;
+	struct request *clone = *__clone;
 
 	/* Do we need to select a new pgpath? */
 	pgpath = lockless_dereference(m->current_pgpath);
@@ -493,7 +498,23 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 
 	bdev = pgpath->path.dev->bdev;
 	q = bdev_get_queue(bdev);
-	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
+
+	/*
+	 * This request may be from requeue path, and its clone
+	 * may have been allocated before. We need to check
+	 * if the cached clone can be hit.
+	 */
+	if (clone) {
+		if (clone->q != q) {
+			blk_rq_unprep_clone(clone);
+			multipath_release_clone(clone);
+			clone = NULL;
+		} else
+			goto start_io;
+	}
+
+	if (!clone)
+		clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
 		bool queue_dying = blk_queue_dying(q);
@@ -520,6 +541,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	*__clone = clone;
 
+ start_io:
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
@@ -527,11 +549,6 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	return DM_MAPIO_REMAPPED;
 }
 
-static void multipath_release_clone(struct request *clone)
-{
-	blk_put_request(clone);
-}
-
 /*
  * Map cloned bios (bio-based multipath)
  */
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 46f012185b43..2ef524bddd38 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -221,6 +221,12 @@ static void dm_end_request(struct request *clone, blk_status_t error)
 	blk_rq_unprep_clone(clone);
 	tio->ti->type->release_clone_rq(clone);
 
+	/*
+	 * We move the clearing from tio_init in .queue_rq to here because
+	 * tio->clone may be cached during requeue
+	 */
+	tio->clone = NULL;
+
 	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
 		blk_end_request_all(rq, error);
@@ -267,11 +273,15 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
 	int rw = rq_data_dir(rq);
 	unsigned long delay_ms = delay_requeue ? 100 : 0;
 
+	/*
+	 * This request won't be changed any more during requeue,
+	 * so we cache tio->clone and let .clone_and_map_rq decide
+	 * to use the cached clone or allocate a new clone, and
+	 * the cached clone has to be freed before allocating a
+	 * new one.
+	 */
+
 	rq_end_stats(md, rq);
-	if (tio->clone) {
-		blk_rq_unprep_clone(tio->clone);
-		tio->ti->type->release_clone_rq(tio->clone);
-	}
 
 	if (!rq->q->mq_ops)
 		dm_old_requeue_request(rq, delay_ms);
@@ -448,7 +458,6 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
 {
 	tio->md = md;
 	tio->ti = NULL;
-	tio->clone = NULL;
 	tio->orig = rq;
 	tio->error = 0;
 	tio->completed = 0;
@@ -456,8 +465,12 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
 	 * Avoid initializing info for blk-mq; it passes
 	 * target-specific data through info.ptr
 	 * (see: dm_mq_init_request)
+	 *
+	 * If tio->clone is cached during requeue, we don't
+	 * clear tio->info, and delay the initialization
+	 * to .clone_and_map_rq if the cache isn't hit.
 	 */
-	if (!md->init_tio_pdu)
+	if (!md->init_tio_pdu && !tio->clone)
 		memset(&tio->info, 0, sizeof(tio->info));
 	if (md->kworker_task)
 		kthread_init_work(&tio->work, map_tio_request);
@@ -475,7 +488,8 @@ static int map_request(struct dm_rq_target_io *tio)
 	struct dm_target *ti = tio->ti;
 	struct mapped_device *md = tio->md;
 	struct request *rq = tio->orig;
-	struct request *clone = NULL;
+	struct request *cache = tio->clone;
+	struct request *clone = cache;
 
 	r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
 	switch (r) {
@@ -483,10 +497,13 @@ static int map_request(struct dm_rq_target_io *tio)
 		/* The target has taken the I/O to submit by itself later */
 		break;
 	case DM_MAPIO_REMAPPED:
-		if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
-			/* -ENOMEM */
-			ti->type->release_clone_rq(clone);
-			return DM_MAPIO_REQUEUE;
+		/* cache not hit or not cached */
+		if (!cache || clone != cache) {
+			if (setup_clone(clone, rq, tio, GFP_ATOMIC)) {
+				/* -ENOMEM */
+				ti->type->release_clone_rq(clone);
+				return DM_MAPIO_REQUEUE;
+			}
 		}
 
 		/* The target has remapped the I/O so dispatch it */
@@ -555,7 +572,7 @@ static int __dm_rq_init_rq(struct mapped_device *md, struct request *rq)
 	 * be available in dm_mq_queue_rq.
 	 */
 	tio->md = md;
-
+	tio->clone = NULL;
 	if (md->init_tio_pdu) {
 		/* target-specific per-io data is immediately after the tio */
 		tio->info.ptr = tio + 1;
-- 
2.9.5
