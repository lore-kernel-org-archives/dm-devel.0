From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 1/5] block: establish request failover callback
Date: Tue, 26 Dec 2017 22:22:53 -0500
Message-ID: <20171227032257.8182-2-snitzer@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171227032257.8182-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, keith.busch@intel.com
Cc: emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

All requests allocated from a request_queue with this callback set can
failover their requests during completion.

This callback is expected to use the blk_steal_bios() interface to
transfer a request's bios back to an upper-layer bio-based
request_queue.

This will be used by both NVMe multipath and DM multipath.  Without it
DM multipath cannot get access to NVMe-specific error handling that NVMe
core provides in nvme_complete_rq().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8089ca17db9a..f45f5925e100 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -278,6 +278,7 @@ typedef int (lld_busy_fn) (struct request_queue *q);
 typedef int (bsg_job_fn) (struct bsg_job *);
 typedef int (init_rq_fn)(struct request_queue *, struct request *, gfp_t);
 typedef void (exit_rq_fn)(struct request_queue *, struct request *);
+typedef void (failover_rq_fn)(struct request *);
 
 enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
@@ -423,6 +424,11 @@ struct request_queue {
 	exit_rq_fn		*exit_rq_fn;
 	/* Called from inside blk_get_request() */
 	void (*initialize_rq_fn)(struct request *rq);
+	/*
+	 * Callback to failover request's bios back to upper layer
+	 * bio-based request_queue using blk_steal_bios().
+	 */
+	failover_rq_fn		*failover_rq_fn;
 
 	const struct blk_mq_ops	*mq_ops;
 
-- 
2.15.0
