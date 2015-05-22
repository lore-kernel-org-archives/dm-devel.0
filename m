From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 3/3] block: remove export for
	blk_queue_bio
Date: Fri, 22 May 2015 09:14:05 -0400
Message-ID: <1432300445-9543-3-git-send-email-snitzer@redhat.com>
References: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1432300445-9543-1-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
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
index 986b256..f6ab750 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -736,6 +736,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
+static void blk_queue_bio(struct request_queue *q, struct bio *bio);
+
 struct request_queue *
 blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 			 spinlock_t *lock)
@@ -1589,7 +1591,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
-void blk_queue_bio(struct request_queue *q, struct bio *bio)
+static void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
@@ -1697,7 +1699,6 @@ out_unlock:
 		spin_unlock_irq(q->queue_lock);
 	}
 }
-EXPORT_SYMBOL_GPL(blk_queue_bio);	/* for device mapper only */
 
 /*
  * If bio->bi_dev is a partition, remap the location
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9ded80d..776d2ee 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -788,8 +788,6 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern void blk_queue_bio(struct request_queue *q, struct bio *bio);
-
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
  * congested queues, and wake up anyone who was waiting for requests to be
-- 
2.3.2 (Apple Git-55)
