From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 3/4] dm table: stack 'chunk_sectors' limit to
	account for target-specific splitting
Date: Tue, 15 Sep 2020 13:23:56 -0400
Message-ID: <20200915172357.83215-4-snitzer@redhat.com>
References: <20200915172357.83215-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200915172357.83215-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Vijayendra Suman <vijayendra.suman@oracle.com>, Ming Lei <ming.lei@redhat.com>
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
index 5edc3079e7c1..248c5a1074a7 100644
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
@@ -1502,6 +1503,10 @@ int dm_calculate_queue_limits(struct dm_table *table,
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
