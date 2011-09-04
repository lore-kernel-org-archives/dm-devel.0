From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 3/3] block: don't export block_bio_complete tracepoint
Date: Sun,  4 Sep 2011 22:15:12 +0900
Message-ID: <1315142112-2430-4-git-send-email-namhyung@gmail.com>
References: <1315142112-2430-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1315142112-2430-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Now bio_endio() contains the tracepoint in it, so we don't
need to have it twice in DM. Plus, as the only external user
of the tracepoint was the DM, we can unexport the symbol.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: dm-devel@redhat.com
---
 block/blk-core.c |    1 -
 drivers/md/dm.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d905f3c81ca7..41c8ea897e09 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -36,7 +36,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 static int __make_request(struct request_queue *q, struct bio *bio);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 52b39f335bb3..e9e671303609 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -639,7 +639,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
-- 
1.7.6
