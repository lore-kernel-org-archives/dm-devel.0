From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/5] dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation failure
Date: Sat, 16 Sep 2017 00:44:53 +0800
Message-ID: <20170915164456.9803-3-ming.lei@redhat.com>
References: <20170915164456.9803-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915164456.9803-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

blk-mq will rerun queue via RESTART after one request is completion,
so not necessary to wait random time for requeuing, it should trust
blk-mq to do it.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 96aedaac2c64..f5a1088a6e79 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -505,7 +505,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 			atomic_inc(&m->pg_init_in_progress);
 			activate_or_offline_path(pgpath);
 		}
-		return DM_MAPIO_DELAY_REQUEUE;
+		return DM_MAPIO_REQUEUE;
 	}
 	clone->bio = clone->biotail = NULL;
 	clone->rq_disk = bdev->bd_disk;
-- 
2.9.5
