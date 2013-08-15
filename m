From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: fix stacking of geometry limits for thinp
	and cache
Date: Thu, 15 Aug 2013 10:29:12 -0400
Message-ID: <20130815142912.GA27908@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Do not blindly override the queue limits (specifically io_min and
io_opt).  Allow traditional stacking of these limits if io_opt is a
factor of each target's block size.

Without this patch mkfs.xfs does not recognize these target provided
limits as a useful geometry (e.g. raid) so these hints are ignored.
This was due to setting io_min to a useless value.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c |   12 ++++++++++--
 drivers/md/dm-thin.c         |   12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

Index: linux/drivers/md/dm-cache-target.c
===================================================================
--- linux.orig/drivers/md/dm-cache-target.c
+++ linux/drivers/md/dm-cache-target.c
@@ -2609,9 +2609,17 @@ static void set_discard_limits(struct ca
 static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct cache *cache = ti->private;
+	unsigned io_opt_sectors = limits->io_opt >> SECTOR_SHIFT;
 
-	blk_limits_io_min(limits, 0);
-	blk_limits_io_opt(limits, cache->sectors_per_block << SECTOR_SHIFT);
+	/*
+	 * If the system-determined stacked limits are compatible with the
+	 * cache's blocksize (io_opt is a factor) do not override them.
+	 */
+	if (io_opt_sectors < cache->sectors_per_block ||
+	    do_div(io_opt_sectors, cache->sectors_per_block)) {
+		blk_limits_io_min(limits, 0);
+		blk_limits_io_opt(limits, cache->sectors_per_block << SECTOR_SHIFT);
+	}
 	set_discard_limits(cache, limits);
 }
 
Index: linux/drivers/md/dm-thin.c
===================================================================
--- linux.orig/drivers/md/dm-thin.c
+++ linux/drivers/md/dm-thin.c
@@ -2648,9 +2648,17 @@ static void pool_io_hints(struct dm_targ
 {
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
+	unsigned io_opt_sectors = limits->io_opt >> SECTOR_SHIFT;
 
-	blk_limits_io_min(limits, 0);
-	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+	/*
+	 * If the system-determined stacked limits are compatible with the
+	 * pool's blocksize (io_opt is a factor) do not override them.
+	 */
+	if (io_opt_sectors < pool->sectors_per_block ||
+	    do_div(io_opt_sectors, pool->sectors_per_block)) {
+		blk_limits_io_min(limits, 0);
+		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
+	}
 
 	/*
 	 * pt->adjusted_pf is a staging area for the actual features to use.
