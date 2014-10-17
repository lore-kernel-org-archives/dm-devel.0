From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 4/4] block: blk-mq support for cloned requests
Date: Fri, 17 Oct 2014 17:46:38 -0600
Message-ID: <1413589598-17631-5-git-send-email-keith.busch@intel.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Use blk-mq to insert cloned requests if it was allocated from a
multi-queue block driver.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 block/blk-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3abbc04..4c5952b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2031,6 +2031,11 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
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
1.7.10.4
