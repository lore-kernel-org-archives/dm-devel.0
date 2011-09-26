From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/2] block: don't export block_bio_complete tracepoint
Date: Mon, 26 Sep 2011 13:43:30 +0900
Message-ID: <1317012210-4309-2-git-send-email-namhyung@gmail.com>
References: <1317012210-4309-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317012210-4309-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
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
index d8005ffc480d..5c81ef057e6a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -36,7 +36,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 /*
  * For the allocated request tables
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7b986e77b75e..a8223d92a52b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -636,7 +636,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
-- 
1.7.6
