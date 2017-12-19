From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 1/5] block: establish request failover callback infrastructure
Date: Tue, 19 Dec 2017 16:05:42 -0500
Message-ID: <20171219210546.65928-2-snitzer@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171219210546.65928-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

If bio sets 'bi_failover_rq' callback it'll get transfered to the
appropriate request's 'failover_rq' using blk_init_request_from_bio().

This callback is expected to use the blk_steal_bios() interface to
transfer a request's bios back to a bio-based request_queue.

This will be used by both NVMe multipath and DM multipath.  Without it
DM multipath cannot get access to NVMe-specific error handling that NVMe
core provides in nvme_complete_rq().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c          | 2 ++
 block/blk-mq.c            | 1 +
 include/linux/blk_types.h | 4 ++++
 include/linux/blkdev.h    | 6 ++++++
 4 files changed, 13 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index b8881750a3ac..95bdc4f2b11d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1872,6 +1872,8 @@ void blk_init_request_from_bio(struct request *req, struct bio *bio)
 	else
 		req->ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
 	req->write_hint = bio->bi_write_hint;
+	if (bio->bi_failover_rq)
+		req->failover_rq = bio->bi_failover_rq;
 	blk_rq_bio_prep(req->q, req, bio);
 }
 EXPORT_SYMBOL_GPL(blk_init_request_from_bio);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 11097477eeab..bb52f8283f07 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -320,6 +320,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
+	rq->failover_rq = NULL;
 	rq->next_rq = NULL;
 
 	data->ctx->rq_dispatched[op_is_sync(op)]++;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a1e628e032da..c3a952991814 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -18,6 +18,9 @@ struct io_context;
 struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *);
 
+struct request;
+typedef void (rq_failover_fn)(struct request *);
+
 /*
  * Block error status values.  See block/blk-core:blk_errors for the details.
  */
@@ -77,6 +80,7 @@ struct bio {
 	atomic_t		__bi_remaining;
 
 	bio_end_io_t		*bi_end_io;
+	rq_failover_fn		*bi_failover_rq;
 
 	void			*bi_private;
 #ifdef CONFIG_BLK_CGROUP
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8089ca17db9a..46bcd782debe 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -237,6 +237,12 @@ struct request {
 	rq_end_io_fn *end_io;
 	void *end_io_data;
 
+	/*
+	 * callback to failover request's bios back to upper layer
+	 * bio-based queue using blk_steal_bios().
+	 */
+	rq_failover_fn *failover_rq;
+
 	/* for bidi */
 	struct request *next_rq;
 };
-- 
2.15.0
