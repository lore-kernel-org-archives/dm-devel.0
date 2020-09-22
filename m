From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 5/6] dm table: stack 'chunk_sectors' limit to account for target-specific splitting
Date: Mon, 21 Sep 2020 22:32:50 -0400
Message-ID: <20200922023251.47712-6-snitzer@redhat.com>
References: <20200922023251.47712-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
In-Reply-To: <20200922023251.47712-1-snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

If target set ti->max_io_len it must be used when stacking
DM device's queue_limits to establish a 'chunk_sectors' that is
compatible with the IO stack.

By using lcm_not_zero() care is taken to avoid blindly overriding the
chunk_sectors limit stacked up by blk_stack_limits().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 229f461e7def..3f4e7c7912a2 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
+#include <linux/lcm.h>
 #include <linux/blk-mq.h>
 #include <linux/mount.h>
 #include <linux/dax.h>
@@ -1506,6 +1507,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
 			zone_sectors = ti_limits.chunk_sectors;
 		}
 
+		/* Stack chunk_sectors if target-specific splitting is required */
+		if (ti->max_io_len)
+			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
+							       ti_limits.chunk_sectors);
 		/* Set I/O hints portion of queue limits */
 		if (ti->type->io_hints)
 			ti->type->io_hints(ti, &ti_limits);
-- 
2.15.0
