From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/5] dm-mpath: remove annoying message of 'blk_get_request() returned -11'
Date: Sat, 16 Sep 2017 00:44:54 +0800
Message-ID: <20170915164456.9803-4-ming.lei@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

It is very normal to see allocation failure, so not necessary
to dump it and annoy people.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-mpath.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f5a1088a6e79..f57ad8621c4c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -499,8 +499,6 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	if (IS_ERR(clone)) {
 		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
 		bool queue_dying = blk_queue_dying(q);
-		DMERR_LIMIT("blk_get_request() returned %ld%s - requeuing",
-			    PTR_ERR(clone), queue_dying ? " (path offline)" : "");
 		if (queue_dying) {
 			atomic_inc(&m->pg_init_in_progress);
 			activate_or_offline_path(pgpath);
-- 
2.9.5
