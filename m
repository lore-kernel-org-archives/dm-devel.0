From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/5] block: export blk_update_nr_requests
Date: Sat, 16 Sep 2017 00:44:55 +0800
Message-ID: <20170915164456.9803-5-ming.lei@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

dm-mpath need this API for improving IO scheduling.

The IO schedule is actually done on dm-rq(mpath) queue,
instead of underlying devices.

If we set q->nr_requests as q->queue_depth on underlying
devices, we can get the queue's busy feedback by simply
checking if blk_get_request() returns successfully.

This way will make block layer's I/O schedule more
effective on dm-rq device.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 4 +++-
 block/blk-sysfs.c      | 5 +----
 block/blk.h            | 2 --
 include/linux/blkdev.h | 1 +
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index aebe676225e6..9752aac9821c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1108,7 +1108,8 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
 	struct request_list *rl;
 	int on_thresh, off_thresh;
 
-	WARN_ON_ONCE(q->mq_ops);
+	if (q->mq_ops)
+		return blk_mq_update_nr_requests(q, nr);
 
 	spin_lock_irq(q->queue_lock);
 	q->nr_requests = nr;
@@ -1145,6 +1146,7 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
 	spin_unlock_irq(q->queue_lock);
 	return 0;
 }
+EXPORT_SYMBOL(blk_update_nr_requests);
 
 /**
  * __get_request - get a free request
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b8362c0df51d..2dbef5dbd195 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -77,10 +77,7 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
-	if (q->request_fn)
-		err = blk_update_nr_requests(q, nr);
-	else
-		err = blk_mq_update_nr_requests(q, nr);
+	err = blk_update_nr_requests(q, nr);
 
 	if (err)
 		return err;
diff --git a/block/blk.h b/block/blk.h
index fa4f232afc18..5bf662da2417 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -308,8 +308,6 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 	return q->nr_congestion_off;
 }
 
-extern int blk_update_nr_requests(struct request_queue *, unsigned int);
-
 /*
  * Contribute to IO statistics IFF:
  *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 460294bb0fa5..226b97142999 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1229,6 +1229,7 @@ struct request_queue *blk_alloc_queue(gfp_t);
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 extern void blk_set_queue_dying(struct request_queue *);
+extern int blk_update_nr_requests(struct request_queue *, unsigned int);
 
 /*
  * block layer runtime pm functions
-- 
2.9.5
