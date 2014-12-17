From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 3/8] block: add blk-mq support to
	blk_insert_cloned_request()
Date: Tue, 16 Dec 2014 22:59:59 -0500
Message-ID: <1418788804-1982-4-git-send-email-snitzer@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

From: Keith Busch <keith.busch@intel.com>

If the request passed to blk_insert_cloned_request() was allocated by
a blk-mq device it must be submitted using blk_mq_insert_request().

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index b794cd99..7852844 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2029,6 +2029,11 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
 		return -EIO;
 
+	if (q->mq_ops) {
+		blk_mq_insert_request(rq, false, true, true);
+		return 0;
+	}
+
 	spin_lock_irqsave(q->queue_lock, flags);
 	if (unlikely(blk_queue_dying(q))) {
 		spin_unlock_irqrestore(q->queue_lock, flags);
-- 
1.9.3
