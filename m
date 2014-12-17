From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 4/8] block: mark blk-mq devices as stackable
Date: Tue, 16 Dec 2014 23:00:00 -0500
Message-ID: <1418788804-1982-5-git-send-email-snitzer@redhat.com>
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

Commit 4ee5eaf4 ("block: add a queue flag for request stacking support")
introduced the concept of "STACKABLE" and blk-mq devices fit the
definition in that they establish q->request_fn.  So establish
QUEUE_FLAG_STACKABLE in QUEUE_FLAG_MQ_DEFAULT.

While not strictly needed (DM _could_ just check for q->mq_ops to assume
the device is request-based), request-based DM support for blk-mq devices
benefits from the ability to consistently check for QUEUE_FLAG_STACKABLE
before allowing a device to be stacked into a request-based DM table.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e5f620c..5ff3f5c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -516,6 +516,7 @@ struct request_queue {
 				 (1 << QUEUE_FLAG_ADD_RANDOM))
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
+				 (1 << QUEUE_FLAG_STACKABLE)	|	\
 				 (1 << QUEUE_FLAG_SAME_COMP))
 
 static inline void queue_lockdep_assert_held(struct request_queue *q)
-- 
1.9.3
