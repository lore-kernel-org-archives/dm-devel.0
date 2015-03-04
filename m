From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/8] dm: remove request-based logic from
	make_request_fn wrapper
Date: Tue,  3 Mar 2015 19:47:06 -0500
Message-ID: <1425430031-78140-4-git-send-email-snitzer@redhat.com>
References: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425430031-78140-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, jmoyer@redhat.com
List-Id: dm-devel.ids

The old dm_request() method used for q->make_request_fn had a branch for
request-based DM support but it isn't needed given that
dm_init_request_based_queue() sets it to the standard blk_queue_bio()
anyway.

Cleanup dm_init_md_queue() to be DM device-type agnostic and have
dm_setup_md_queue() properly finish queue setup based on DM device-type
(bio-based vs request-based).

Also, remove the export for blk_queue_bio() now that DM no longer calls
it directly.  Doing so required a forward declaration in blk-core.c.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       |  5 +++--
 drivers/md/dm.c        | 29 ++++++++++++-----------------
 include/linux/blkdev.h |  2 --
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 794c3e7..4bcd739 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,6 +719,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
+static void blk_queue_bio(struct request_queue *q, struct bio *bio);
+
 struct request_queue *
 blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 			 spinlock_t *lock)
@@ -1563,7 +1565,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-void blk_queue_bio(struct request_queue *q, struct bio *bio)
+static void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
@@ -1671,7 +1673,6 @@ out_unlock:
 		spin_unlock_irq(q->queue_lock);
 	}
 }
-EXPORT_SYMBOL_GPL(blk_queue_bio);	/* for device mapper only */
 
 /*
  * If bio->bi_dev is a partition, remap the location
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fcc3203..6a85bd4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1690,7 +1690,7 @@ out:
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
  */
-static void _dm_request(struct request_queue *q, struct bio *bio)
+static void dm_make_request(struct request_queue *q, struct bio *bio)
 {
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
@@ -1722,16 +1722,6 @@ int dm_request_based(struct mapped_device *md)
 	return blk_queue_stackable(md->queue);
 }
 
-static void dm_request(struct request_queue *q, struct bio *bio)
-{
-	struct mapped_device *md = q->queuedata;
-
-	if (dm_request_based(md))
-		blk_queue_bio(q, bio);
-	else
-		_dm_request(q, bio);
-}
-
 static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 {
 	int r;
@@ -2097,9 +2087,8 @@ static void dm_init_md_queue(struct mapped_device *md)
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
-	blk_queue_make_request(md->queue, dm_request);
+
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 }
 
 /*
@@ -2330,7 +2319,7 @@ int dm_queue_merge_is_compulsory(struct request_queue *q)
 	if (!q->merge_bvec_fn)
 		return 0;
 
-	if (q->make_request_fn == dm_request) {
+	if (q->make_request_fn == dm_make_request) {
 		dev_md = q->queuedata;
 		if (test_bit(DMF_MERGE_IS_OPTIONAL, &dev_md->flags))
 			return 0;
@@ -2540,9 +2529,15 @@ static int dm_init_request_based_queue(struct mapped_device *md)
  */
 int dm_setup_md_queue(struct mapped_device *md)
 {
-	if (dm_md_type_request_based(md) && !dm_init_request_based_queue(md)) {
-		DMWARN("Cannot initialize queue for request-based mapped device");
-		return -EINVAL;
+	if (dm_md_type_request_based(md)) {
+		if (!dm_init_request_based_queue(md)) {
+			DMWARN("Cannot initialize queue for request-based mapped device");
+			return -EINVAL;
+		}
+	} else {
+		/* bio-based specific initialization */
+		blk_queue_make_request(md->queue, dm_make_request);
+		blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 	}
 
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516..5d93a66 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -821,8 +821,6 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern void blk_queue_bio(struct request_queue *q, struct bio *bio);
-
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
  * congested queues, and wake up anyone who was waiting for requests to be
-- 
1.9.3 (Apple Git-50)
