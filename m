From: Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] block: don't export block_bio_complete tracepoint
Date: Tue, 17 Jan 2012 10:32:08 +0900
Message-ID: <1326763928-1972-3-git-send-email-namhyung.kim@lge.com>
References: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Now bio_endio() contains the tracepoint in it, so we don't
need to have it twice in DM. Plus, as the only external user
of the tracepoint was the DM, we can unexport the symbol.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: dm-devel@redhat.com
---
 block/blk-core.c |    1 -
 drivers/md/dm.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1b4fd93af2c0..399c128f516c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -37,7 +37,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 DEFINE_IDA(blk_queue_ida);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4720f68f817e..01185fa0eb74 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -648,7 +648,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
-- 
1.7.9.rc1.dirty
