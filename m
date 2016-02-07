From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.5 PATCH v2 01/15] dm: fix excessive dm-mq context
	switching
Date: Sun,  7 Feb 2016 10:53:23 -0500
Message-ID: <1454860417-3203-2-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, jmoyer@redhat.com, Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

Request-based DM's blk-mq support (dm-mq) was reported to be 50% slower
than if an underlying null_blk device were used directly.  One of the
reasons for this drop in performance is that blk_insert_clone_request()
was calling blk_mq_insert_request() with @async=true.  This forced the
use of kblockd_schedule_delayed_work_on() to run the blk-mq hw queues
which ushered in ping-ponging between process context (fio in this case)
and kblockd's kworker to submit the cloned request.  The ftrace
function_graph tracer showed:

  kworker-2013  =>   fio-12190
  fio-12190    =>  kworker-2013
  ...
  kworker-2013  =>   fio-12190
  fio-12190    =>  kworker-2013
  ...

Fixing blk_insert_clone_request()'s blk_mq_insert_request() call to
_not_ use kblockd to submit the cloned requests isn't enough to
eliminate the observed context switches.

In addition to this dm-mq specific blk-core fix, there are 2 DM core
fixes to dm-mq that (when paired with the blk-core fix) completely
eliminate the observed context switching:

1)  don't blk_mq_run_hw_queues in blk-mq request completion

    Motivated by desire to reduce overhead of dm-mq, punting to kblockd
    just increases context switches.

    In my testing against a really fast null_blk device there was no benefit
    to running blk_mq_run_hw_queues() on completion (and no other blk-mq
    driver does this).  So hopefully this change doesn't induce the need for
    yet another revert like commit 621739b00e16ca2d !

2)  use blk_mq_complete_request() in dm_complete_request()

    blk_complete_request() doesn't offer the traditional q->mq_ops vs
    .request_fn branching pattern that other historic block interfaces
    do (e.g. blk_get_request).  Using blk_mq_complete_request() for
    blk-mq requests is important for performance.  It should be noted
    that, like blk_complete_request(), blk_mq_complete_request() doesn't
    natively handle partial completions -- but the request-based
    DM-multipath target does provide the required partial completion
    support by dm.c:end_clone_bio() triggering requeueing of the request
    via dm-mpath.c:multipath_end_io()'s return of DM_ENDIO_REQUEUE.

dm-mq fix #2 is _much_ more important than #1 for eliminating the
context switches.
Before: cpu          : usr=15.10%, sys=59.39%, ctx=7905181, majf=0, minf=475
After:  cpu          : usr=20.60%, sys=79.35%, ctx=2008, majf=0, minf=472

With these changes multithreaded async read IOPs improved from ~950K
to ~1350K for this dm-mq stacked on null_blk test-case.  The raw read
IOPs of the underlying null_blk device for the same workload is ~1950K.

Fixes: 7fb4898e0 ("block: add blk-mq support to blk_insert_cloned_request()")
Fixes: bfebd1cdb ("dm: add full blk-mq support to request-based DM")
Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 4.1+
---
 block/blk-core.c |  2 +-
 drivers/md/dm.c  | 13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ab51685..c60e233 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2198,7 +2198,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	if (q->mq_ops) {
 		if (blk_queue_io_stat(q))
 			blk_account_io_start(rq, true);
-		blk_mq_insert_request(rq, false, true, true);
+		blk_mq_insert_request(rq, false, true, false);
 		return 0;
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5df4048..846e1bb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1109,12 +1109,8 @@ static void rq_completed(struct mapped_device *md, int rw, bool run_queue)
 	 * back into ->request_fn() could deadlock attempting to grab the
 	 * queue lock again.
 	 */
-	if (run_queue) {
-		if (md->queue->mq_ops)
-			blk_mq_run_hw_queues(md->queue, true);
-		else
-			blk_run_queue_async(md->queue);
-	}
+	if (!md->queue->mq_ops && run_queue)
+		blk_run_queue_async(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
@@ -1334,7 +1330,10 @@ static void dm_complete_request(struct request *rq, int error)
 	struct dm_rq_target_io *tio = tio_from_request(rq);
 
 	tio->error = error;
-	blk_complete_request(rq);
+	if (!rq->q->mq_ops)
+		blk_complete_request(rq);
+	else
+		blk_mq_complete_request(rq, rq->errors);
 }
 
 /*
-- 
2.5.4 (Apple Git-61)
