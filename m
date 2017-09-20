From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] dm-mpath: Improve handling of busy paths
Date: Wed, 20 Sep 2017 11:12:12 -0700
Message-ID: <20170920181212.5532-1-bart.vanassche@wdc.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Instead of retrying request allocation after a delay if a path is
busy, wait until the underlying path has completed a request. This
patch avoids that submission of requests to busy paths is delayed and
hence creates more opportunities for merging sequential I/O requests.

Reported-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-mpath.c | 10 +++++++++-
 drivers/md/dm-rq.c    |  3 ++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 11f273d2f018..b60ef655fa0c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -495,7 +495,13 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 
 	bdev = pgpath->path.dev->bdev;
 	q = bdev_get_queue(bdev);
-	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
+	/*
+	 * For blk-mq this code is called from inside dm_mq_queue_rq() and
+	 * sleeping is allowed due to BLK_MQ_F_BLOCKING.  For the legacy block
+	 * layer this code is called from workqueue context. Hence unlocking
+	 * and reacquiring the queue lock is not necessary.
+	 */
+	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_NOIO);
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
 		bool queue_dying = blk_queue_dying(q);
@@ -504,6 +510,8 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 		if (queue_dying) {
 			atomic_inc(&m->pg_init_in_progress);
 			activate_or_offline_path(pgpath);
+		} else {
+			WARN_ON_ONCE(true);
 		}
 		return DM_MAPIO_DELAY_REQUEUE;
 	}
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index eadfcfd106ff..f25a3cdb7f84 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -789,7 +789,8 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	md->tag_set->ops = &dm_mq_ops;
 	md->tag_set->queue_depth = dm_get_blk_mq_queue_depth();
 	md->tag_set->numa_node = md->numa_node_id;
-	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE |
+		BLK_MQ_F_BLOCKING;
 	md->tag_set->nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
 	md->tag_set->driver_data = md;
 
-- 
2.14.1
