From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 2/3] dm thin: support for non power of 2 pool
	blocksize
Date: Fri,  4 May 2012 23:57:09 -0400
Message-ID: <1336190230-11243-2-git-send-email-snitzer@redhat.com>
References: <1336190230-11243-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336190230-11243-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

Non power of 2 blocksize support is needed to properly align thinp IO
on storage that has non power of 2 optimal IO sizes (e.g. RAID6 10+2).

Use do_div wrappers to support non power of 2 blocksize for the pool's
data device.  do_div provides comparable performance to the power of 2
math that was performed until now (as tested on modern x86_64 hardware).

Eliminate pool structure's 'sectors_per_block', 'block_shift' and
remaining 4 byte holes.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

Index: linux/drivers/md/dm-thin.c
===================================================================
--- linux.orig/drivers/md/dm-thin.c
+++ linux/drivers/md/dm-thin.c
@@ -507,10 +507,8 @@ struct pool {
 	struct block_device *md_dev;
 	struct dm_pool_metadata *pmd;
 
-	uint32_t sectors_per_block;
-	unsigned block_shift;
-	dm_block_t offset_mask;
 	dm_block_t low_water_blocks;
+	uint32_t sectors_per_block;
 
 	struct pool_features pf;
 	unsigned low_water_triggered:1;	/* A dm event has been sent */
@@ -523,8 +521,8 @@ struct pool {
 	struct work_struct worker;
 	struct delayed_work waker;
 
-	unsigned ref_count;
 	unsigned long last_commit_jiffies;
+	unsigned ref_count;
 
 	spinlock_t lock;
 	struct bio_list deferred_bios;
@@ -675,7 +673,7 @@ static void requeue_io(struct thin_c *tc
 
 static dm_block_t get_bio_block(struct thin_c *tc, struct bio *bio)
 {
-	return bio->bi_sector >> tc->pool->block_shift;
+	return dm_do_div(bio->bi_sector, tc->pool->sectors_per_block);
 }
 
 static void remap(struct thin_c *tc, struct bio *bio, dm_block_t block)
@@ -683,8 +681,8 @@ static void remap(struct thin_c *tc, str
 	struct pool *pool = tc->pool;
 
 	bio->bi_bdev = tc->pool_dev->bdev;
-	bio->bi_sector = (block << pool->block_shift) +
-		(bio->bi_sector & pool->offset_mask);
+	bio->bi_sector = (block * pool->sectors_per_block) +
+		dm_do_mod(bio->bi_sector, pool->sectors_per_block);
 }
 
 static void remap_to_origin(struct thin_c *tc, struct bio *bio)
@@ -929,9 +927,8 @@ static void process_prepared(struct pool
  */
 static int io_overlaps_block(struct pool *pool, struct bio *bio)
 {
-	return !(bio->bi_sector & pool->offset_mask) &&
+	return !dm_do_mod(bio->bi_sector, pool->sectors_per_block) &&
 		(bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT));
-
 }
 
 static int io_overwrites_block(struct pool *pool, struct bio *bio)
@@ -1234,8 +1231,8 @@ static void process_discard(struct thin_
 			 * part of the discard that is in a subsequent
 			 * block.
 			 */
-			sector_t offset = bio->bi_sector - (block << pool->block_shift);
-			unsigned remaining = (pool->sectors_per_block - offset) << 9;
+			sector_t offset = bio->bi_sector - (block * pool->sectors_per_block);
+			unsigned remaining = (pool->sectors_per_block - offset) << SECTOR_SHIFT;
 			bio->bi_size = min(bio->bi_size, remaining);
 
 			cell_release_singleton(cell, bio);
@@ -1696,8 +1693,6 @@ static struct pool *pool_create(struct m
 
 	pool->pmd = pmd;
 	pool->sectors_per_block = block_size;
-	pool->block_shift = ffs(block_size) - 1;
-	pool->offset_mask = block_size - 1;
 	pool->low_water_blocks = 0;
 	pool_features_init(&pool->pf);
 	pool->prison = prison_create(PRISON_CELLS);
@@ -1941,7 +1936,7 @@ static int pool_ctr(struct dm_target *ti
 	if (kstrtoul(argv[2], 10, &block_size) || !block_size ||
 	    block_size < DATA_DEV_BLOCK_SIZE_MIN_SECTORS ||
 	    block_size > DATA_DEV_BLOCK_SIZE_MAX_SECTORS ||
-	    !is_power_of_2(block_size)) {
+	    dm_do_mod(block_size, DATA_DEV_BLOCK_SIZE_MIN_SECTORS)) {
 		ti->error = "Invalid block size";
 		r = -EINVAL;
 		goto out;
@@ -2089,7 +2084,7 @@ static int pool_preresume(struct dm_targ
 	if (r)
 		return r;
 
-	data_size = ti->len >> pool->block_shift;
+	data_size = dm_do_div(ti->len, pool->sectors_per_block);
 	r = dm_pool_get_data_dev_size(pool->pmd, &sb_data_size);
 	if (r) {
 		DMERR("failed to retrieve data device size");
@@ -2711,17 +2706,18 @@ static int thin_iterate_devices(struct d
 {
 	dm_block_t blocks;
 	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
 
 	/*
 	 * We can't call dm_pool_get_data_dev_size() since that blocks.  So
 	 * we follow a more convoluted path through to the pool's target.
 	 */
-	if (!tc->pool->ti)
+	if (!pool->ti)
 		return 0;	/* nothing is bound */
 
-	blocks = tc->pool->ti->len >> tc->pool->block_shift;
+	blocks = dm_do_div(pool->ti->len, pool->sectors_per_block);
 	if (blocks)
-		return fn(ti, tc->pool_dev, 0, tc->pool->sectors_per_block * blocks, data);
+		return fn(ti, tc->pool_dev, 0, pool->sectors_per_block * blocks, data);
 
 	return 0;
 }
