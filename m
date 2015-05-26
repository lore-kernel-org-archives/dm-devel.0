From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH for 4.1-rc] dm: run queue on re-queue
Date: Tue, 26 May 2015 08:25:54 +0000
Message-ID: <55642E11.6010500@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ja-JP
Content-ID: <8A0BECB8043EA94782AC28E505FB84DB@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Without kicking queue, requeued request may stay forever in
the queue if there are no other I/O activities to the device.

The original error had been in v2.6.39 with commit 7eaceaccab5f
("block: remove per-queue plugging"), which replaced conditional
plugging by periodic runqueue.

Commit 9d1deb83d489 in v4.1-rc1 removed the periodic runqueue
and the problem started to manifest.

Fixes: 9d1deb83d489 ("dm: don't schedule delayed run of the queue if nothing to do")
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a930b72..0bf79a0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1164,6 +1164,7 @@ static void old_requeue_request(struct request *rq)
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, rq);
+	blk_run_queue_async(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
