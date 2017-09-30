From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/5] dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation failure
Date: Sat, 30 Sep 2017 19:46:50 +0800
Message-ID: <20170930114652.32441-4-ming.lei@redhat.com>
References: <20170930114652.32441-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170930114652.32441-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

blk-mq will rerun queue via RESTART after one request is completed,
so not necessary to wait random time for requeuing, we should trust
blk-mq to do it.

More importantly, we need return BLK_STS_RESOURCE to blk-mq
so that dequeue from I/O scheduler can be stopped, then
I/O merge gets improved.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-mpath.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 97e4bd100fa1..9ee223170ee9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -500,8 +500,20 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 		if (queue_dying) {
 			atomic_inc(&m->pg_init_in_progress);
 			activate_or_offline_path(pgpath);
+			return DM_MAPIO_DELAY_REQUEUE;
 		}
-		return DM_MAPIO_DELAY_REQUEUE;
+
+		/*
+		 * blk-mq's SCHED_RESTART can cover this requeue, so
+		 * we needn't to deal with it by DELAY_REQUEUE. More
+		 * importantly, we have to return DM_MAPIO_REQUEUE
+		 * so that blk-mq can get the queue busy feedback,
+		 * otherwise I/O merge can be hurt.
+		 */
+		if (q->mq_ops)
+			return DM_MAPIO_REQUEUE;
+		else
+			return DM_MAPIO_DELAY_REQUEUE;
 	}
 	clone->bio = clone->biotail = NULL;
 	clone->rq_disk = bdev->bd_disk;
-- 
2.9.5
