From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 08/17] dm thin: adjust max_sectors_kb
	based on thinp blocksize
Date: Fri, 17 Oct 2014 14:37:10 -0400
Message-ID: <1413571039-31986-8-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Allows for filesystems to submit bios that are a factor of the thinp
blocksize, improving dm-thinp efficiency (particularly when the data
volume is RAID).

Also set io_min to max_sectors_kb if it is a factor of the thinp
blocksize.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6057441..3f2b1d1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -11,6 +11,7 @@
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
+#include <linux/log2.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/init.h>
@@ -3234,15 +3235,36 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
-	uint64_t io_opt_sectors = limits->io_opt >> SECTOR_SHIFT;
+	sector_t io_opt_sectors = limits->io_opt >> SECTOR_SHIFT;
+
+	/*
+	 * Adjust max_sectors_kb to highest possible power-of-2
+	 * factor of pool->sectors_per_block.
+	 */
+	if (limits->max_hw_sectors & (limits->max_hw_sectors - 1))
+		limits->max_sectors = rounddown_pow_of_two(limits->max_hw_sectors);
+	else
+		limits->max_sectors = limits->max_hw_sectors;
+
+	if (limits->max_sectors < pool->sectors_per_block) {
+		while (!is_factor(pool->sectors_per_block, limits->max_sectors))
+			limits->max_sectors = rounddown_pow_of_two(limits->max_sectors);
+	} else if (block_size_is_power_of_two(pool)) {
+		/* max_sectors_kb is >= power-of-2 thinp blocksize */
+		while (!is_factor(limits->max_sectors, pool->sectors_per_block))
+			limits->max_sectors = rounddown_pow_of_two(limits->max_sectors);
+	}
 
 	/*
 	 * If the system-determined stacked limits are compatible with the
 	 * pool's blocksize (io_opt is a factor) do not override them.
 	 */
 	if (io_opt_sectors < pool->sectors_per_block ||
-	    do_div(io_opt_sectors, pool->sectors_per_block)) {
-		blk_limits_io_min(limits, pool->sectors_per_block << SECTOR_SHIFT);
+	    !is_factor(io_opt_sectors, pool->sectors_per_block)) {
+		if (is_factor(pool->sectors_per_block, limits->max_sectors))
+			blk_limits_io_min(limits, limits->max_sectors << SECTOR_SHIFT);
+		else
+			blk_limits_io_min(limits, pool->sectors_per_block << SECTOR_SHIFT);
 		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
 	}
 
-- 
1.8.3.1
