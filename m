From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: fix discard support
Date: Fri, 31 Aug 2012 17:46:06 -0400
Message-ID: <1346449566-21827-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

The discard limits that were established for a thin-pool or thin device
may have been incompatible with the pool's data device.  Fix this by
checking the discard limits of the pool's data device accordingly.  If
an incompatibility is found then the pool's 'discard passdown' feature
is disabled.

Also, allow discards even if the pool's block size is not a power of 2.
The block layer assumes discard_granularity is a power of 2, so changes
are needed to allow discards when a pool is using a block size that is
not a power of 2.  This patch depends on commit c6e666345e1b79c62b
("block: split discard into aligned requests") to insure properly
aligned discard requests are issued to thinp.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c |  171 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 123 insertions(+), 48 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index af1fc3b..9a1a709 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -509,9 +509,9 @@ enum pool_mode {
 struct pool_features {
 	enum pool_mode mode;
 
-	unsigned zero_new_blocks:1;
-	unsigned discard_enabled:1;
-	unsigned discard_passdown:1;
+	bool zero_new_blocks:1;
+	bool discard_enabled:1;
+	bool discard_passdown:1;
 };
 
 struct thin_c;
@@ -1839,6 +1839,28 @@ static void __requeue_bios(struct pool *pool)
 /*----------------------------------------------------------------
  * Binding of control targets to a pool object
  *--------------------------------------------------------------*/
+static bool data_dev_supports_discard(struct pool_c *pt)
+{
+	struct request_queue *q = bdev_get_queue(pt->data_dev->bdev);
+	return q && blk_queue_discard(q);
+}
+
+static void disable_passdown_if_not_supported(struct pool_c *pt,
+					      struct pool_features *pf)
+{
+	/*
+	 * If discard_passdown was enabled verify that the data device
+	 * supports discards.  Disable discard_passdown if not; otherwise
+	 * -EOPNOTSUPP will be returned.
+	 */
+	if (pf->discard_passdown && !data_dev_supports_discard(pt)) {
+		char buf[BDEVNAME_SIZE];
+		DMWARN("Discard unsupported by data device (%s): Disabling discard passdown.",
+		       bdevname(pt->data_dev->bdev, buf));
+		pf->discard_passdown = false;
+	}
+}
+
 static int bind_control_target(struct pool *pool, struct dm_target *ti)
 {
 	struct pool_c *pt = ti->private;
@@ -1855,23 +1877,9 @@ static int bind_control_target(struct pool *pool, struct dm_target *ti)
 	pool->ti = ti;
 	pool->low_water_blocks = pt->low_water_blocks;
 	pool->pf = pt->pf;
-	set_pool_mode(pool, new_mode);
 
-	/*
-	 * If discard_passdown was enabled verify that the data device
-	 * supports discards.  Disable discard_passdown if not; otherwise
-	 * -EOPNOTSUPP will be returned.
-	 */
-	/* FIXME: pull this out into a sep fn. */
-	if (pt->pf.discard_passdown) {
-		struct request_queue *q = bdev_get_queue(pt->data_dev->bdev);
-		if (!q || !blk_queue_discard(q)) {
-			char buf[BDEVNAME_SIZE];
-			DMWARN("Discard unsupported by data device (%s): Disabling discard passdown.",
-			       bdevname(pt->data_dev->bdev, buf));
-			pool->pf.discard_passdown = 0;
-		}
-	}
+	disable_passdown_if_not_supported(pt, &pool->pf);
+	set_pool_mode(pool, new_mode);
 
 	return 0;
 }
@@ -1889,9 +1897,9 @@ static void unbind_control_target(struct pool *pool, struct dm_target *ti)
 static void pool_features_init(struct pool_features *pf)
 {
 	pf->mode = PM_WRITE;
-	pf->zero_new_blocks = 1;
-	pf->discard_enabled = 1;
-	pf->discard_passdown = 1;
+	pf->zero_new_blocks = true;
+	pf->discard_enabled = true;
+	pf->discard_passdown = true;
 }
 
 static void __pool_destroy(struct pool *pool)
@@ -2119,13 +2127,13 @@ static int parse_pool_features(struct dm_arg_set *as, struct pool_features *pf,
 		argc--;
 
 		if (!strcasecmp(arg_name, "skip_block_zeroing"))
-			pf->zero_new_blocks = 0;
+			pf->zero_new_blocks = false;
 
 		else if (!strcasecmp(arg_name, "ignore_discard"))
-			pf->discard_enabled = 0;
+			pf->discard_enabled = false;
 
 		else if (!strcasecmp(arg_name, "no_discard_passdown"))
-			pf->discard_passdown = 0;
+			pf->discard_passdown = false;
 
 		else if (!strcasecmp(arg_name, "read_only"))
 			pf->mode = PM_READ_ONLY;
@@ -2245,15 +2253,6 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto out_flags_changed;
 	}
 
-	/*
-	 * The block layer requires discard_granularity to be a power of 2.
-	 */
-	if (pf.discard_enabled && !is_power_of_2(block_size)) {
-		ti->error = "Discard support must be disabled when the block size is not a power of 2";
-		r = -EINVAL;
-		goto out_flags_changed;
-	}
-
 	pt->pool = pool;
 	pt->ti = ti;
 	pt->metadata_dev = metadata_dev;
@@ -2261,6 +2260,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->low_water_blocks = low_water_blocks;
 	pt->pf = pf;
 	ti->num_flush_requests = 1;
+
 	/*
 	 * Only need to enable discards if the pool should pass
 	 * them down to the data device.  The thin device's discard
@@ -2268,12 +2268,14 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 */
 	if (pf.discard_enabled && pf.discard_passdown) {
 		ti->num_discard_requests = 1;
+
 		/*
 		 * Setting 'discards_supported' circumvents the normal
 		 * stacking of discard limits (this keeps the pool and
 		 * thin devices' discard limits consistent).
 		 */
 		ti->discards_supported = true;
+		ti->discard_zeroes_data_unsupported = true;
 	}
 	ti->private = pt;
 
@@ -2732,31 +2734,107 @@ static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
 
-static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
+static bool discard_limits_are_compatible(struct pool *pool,
+					  struct queue_limits *data_limits,
+					  const char **reason)
 {
+	sector_t block_size = pool->sectors_per_block << SECTOR_SHIFT;
+
 	/*
-	 * FIXME: these limits may be incompatible with the pool's data device
+	 * All reasons should be relative to the data device,
+	 * e.g.: Data device <reason>
 	 */
-	limits->max_discard_sectors = pool->sectors_per_block;
+	if (data_limits->max_discard_sectors < pool->sectors_per_block) {
+		*reason = "max discard sectors smaller than a block";
+		return false;
+	}
 
+	if (data_limits->discard_granularity > block_size) {
+		*reason = "discard granularity larger than a block";
+		return false;
+	}
+
+	if (block_size & (data_limits->discard_granularity - 1)) {
+		*reason = "discard granularity not a factor of block size";
+		return false;
+	}
+
+	return true;
+}
+
+static bool block_size_is_power_of_2(struct pool *pool)
+{
+	return pool->sectors_per_block_shift >= 0;
+}
+
+#define is_even(x) (((x) & 1) == 0)
+
+static unsigned largest_power_factor(unsigned limit, unsigned min)
+{
 	/*
-	 * This is just a hint, and not enforced.  We have to cope with
-	 * bios that cover a block partially.  A discard that spans a block
-	 * boundary is not sent to this target.
+	 * Determine largest power of 2 that is a factor of @limit
 	 */
-	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
+	while ((min < limit) && is_even(limit / min))
+		min <<= 1;
+
+	return min;
+}
+
+static void set_discard_granularity_no_passdown(struct pool *pool,
+						struct queue_limits *limits)
+{
+	unsigned dg_sectors;
+
+	if (!block_size_is_power_of_2(pool)) {
+		dg_sectors = largest_power_factor(pool->sectors_per_block,
+						  DATA_DEV_BLOCK_SIZE_MIN_SECTORS);
+	} else
+		dg_sectors = pool->sectors_per_block;
+
+	limits->discard_granularity = dg_sectors << SECTOR_SHIFT;
+}
+
+static void set_discard_limits(struct pool *pool,
+			       struct pool_features *pf,
+			       struct queue_limits *data_limits,
+			       struct queue_limits *limits)
+{
+	limits->max_discard_sectors = pool->sectors_per_block;
+
+	if (pf->discard_passdown)
+		limits->discard_granularity = data_limits->discard_granularity;
+	else
+		set_discard_granularity_no_passdown(pool, limits);
 }
 
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
+	const char *reason;
+	struct block_device *data_bdev = pt->data_dev->bdev;
+	struct queue_limits *data_limits = &bdev_get_queue(data_bdev)->limits;
 
 	blk_limits_io_min(limits, 0);
 	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
-	if (pool->pf.discard_enabled)
-		set_discard_limits(pool, limits);
+
+	/*
+	 * pt->pf is used here because it reflects the features configured but
+	 * not yet transfered to the live pool (see: bind_control_target).
+	 */
+	if (pt->pf.discard_enabled) {
+		disable_passdown_if_not_supported(pt, &pt->pf);
+
+		if (pt->pf.discard_passdown &&
+		    !discard_limits_are_compatible(pool, data_limits, &reason)) {
+			char buf[BDEVNAME_SIZE];
+			DMWARN("Data device (%s) %s: Disabling discard passdown.",
+			       bdevname(data_bdev, buf), reason);
+			pt->pf.discard_passdown = false;
+		}
+
+		set_discard_limits(pt->pool, &pt->pf, data_limits, limits);
+	}
 }
 
 static struct target_type pool_target = {
@@ -3045,11 +3123,8 @@ static int thin_iterate_devices(struct dm_target *ti,
 static void thin_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
 	struct thin_c *tc = ti->private;
-	struct pool *pool = tc->pool;
 
-	blk_limits_io_min(limits, 0);
-	blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
-	set_discard_limits(pool, limits);
+	*limits = bdev_get_queue(tc->pool_dev->bdev)->limits;
 }
 
 static struct target_type thin_target = {
-- 
1.7.4.4
