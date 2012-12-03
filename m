From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] dm: Update a source code comment
Date: Mon, 03 Dec 2012 13:32:32 +0100
Message-ID: <50BC9BE0.30108@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Tejun Heo <tj@kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Update a source code comment with the conclusions of the discussion
of the patch that introduced this comment (commit a8c32a5). See also
http://www.redhat.com/archives/dm-devel/2012-November/msg00003.html.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/md/dm.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 77e6eff..0ec0673 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -740,12 +740,7 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
 
-	/*
-	 * Run this off this callpath, as drivers could invoke end_io while
-	 * inside their request_fn (and holding the queue lock). Calling
-	 * back into ->request_fn() could deadlock attempting to grab the
-	 * queue lock again.
-	 */
+	/* run queue asynchronously to minimize time spent in soft-IRQ ctxt */
 	if (run_queue)
 		blk_run_queue_async(md->queue);
 
-- 
1.7.10.4
