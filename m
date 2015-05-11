From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: remove export for blk_queue_bio
Date: Mon, 11 May 2015 14:06:32 -0400
Message-ID: <1431367592-36546-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

With commit ff36ab345 ("dm: remove request-based logic from
make_request_fn wrapper") DM no longer calls blk_queue_bio() directly,
so remove its export.  Doing so required a forward declaration in
blk-core.c.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 5 +++--
 include/linux/blkdev.h | 2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fd154b9..1638a4f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -732,6 +732,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
+static void blk_queue_bio(struct request_queue *q, struct bio *bio);
+
 struct request_queue *
 blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 			 spinlock_t *lock)
@@ -1576,7 +1578,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-void blk_queue_bio(struct request_queue *q, struct bio *bio)
+static void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
@@ -1684,7 +1686,6 @@ out_unlock:
 		spin_unlock_irq(q->queue_lock);
 	}
 }
-EXPORT_SYMBOL_GPL(blk_queue_bio);	/* for device mapper only */
 
 /*
  * If bio->bi_dev is a partition, remap the location
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
2.3.2 (Apple Git-55)
