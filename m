From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/7] dm: use dm_rq_target_io as argument for
	dm_done()
Date: Thu,  5 Jun 2014 15:11:01 +0200
Message-ID: <1401973867-121561-2-git-send-email-hare@suse.de>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1401973867-121561-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

No functional change.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 455e649..de88fac 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -964,17 +964,17 @@ static void start_queue(struct request_queue *q)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-static void dm_done(struct request *clone, int error, bool mapped)
+static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
+		    bool mapped)
 {
-	int r = error;
-	struct dm_rq_target_io *tio = clone->end_io_data;
+	int r = tio->error;
 	dm_request_endio_fn rq_end_io = NULL;
 
 	if (tio->ti) {
 		rq_end_io = tio->ti->type->rq_end_io;
 
 		if (mapped && rq_end_io)
-			r = rq_end_io(tio->ti, clone, error, &tio->info);
+			r = rq_end_io(tio->ti, clone, tio->error, &tio->info);
 	}
 
 	if (r <= 0)
@@ -1004,7 +1004,7 @@ static void dm_softirq_done(struct request *rq)
 	if (rq->cmd_flags & REQ_FAILED)
 		mapped = false;
 
-	dm_done(clone, tio->error, mapped);
+	dm_done(clone, tio, mapped);
 }
 
 /*
-- 
1.7.12.4
