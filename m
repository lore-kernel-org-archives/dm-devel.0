From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thin: optimize power of two block size
Date: Mon, 18 Jun 2012 10:09:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206181003170.22564@file.rdu.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch should be applied after 
dm-thin-support-for-non-power-of-2-pool-blocksize.patch. It optimizes 
power-of-two blocksize.

Mikulas

---

dm-thin: optimize power of two block size

dm-thin will be most likely used with a block size that is a power of
two. So it should be optimized for this case.

This patch changes division and modulo operations to shifts and bit
masks if block size is a power of two.

A test that bi_sector is divisible by a block size is removed from
io_overlaps_block. Device mapper never sends bios that span block
boundary. Consequently, if we tested that bi_size is equivalent to block
size, bi_sector must already be on a block boundary.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

Index: linux-3.4.2-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.4.2-fast.orig/drivers/md/dm-thin.c	2012-06-18 15:38:53.000000000 +0200
+++ linux-3.4.2-fast/drivers/md/dm-thin.c	2012-06-18 16:06:15.000000000 +0200
@@ -512,6 +512,7 @@ struct pool {
 
 	dm_block_t low_water_blocks;
 	uint32_t sectors_per_block;
+	int sectors_per_block_shift;
 
 	struct pool_features pf;
 	unsigned low_water_triggered:1;	/* A dm event has been sent */
@@ -678,7 +679,10 @@ static dm_block_t get_bio_block(struct t
 {
 	sector_t block_nr = bio->bi_sector;
 
-	(void) sector_div(block_nr, tc->pool->sectors_per_block);
+	if (tc->pool->sectors_per_block_shift < 0)
+		(void) sector_div(block_nr, tc->pool->sectors_per_block);
+	else
+		block_nr >>= tc->pool->sectors_per_block_shift;
 
 	return block_nr;
 }
@@ -689,8 +693,12 @@ static void remap(struct thin_c *tc, str
 	sector_t bi_sector = bio->bi_sector;
 
 	bio->bi_bdev = tc->pool_dev->bdev;
-	bio->bi_sector = (block * pool->sectors_per_block) +
-			 sector_div(bi_sector, pool->sectors_per_block);
+	if (tc->pool->sectors_per_block_shift < 0)
+		bio->bi_sector = (block * pool->sectors_per_block) +
+				 sector_div(bi_sector, pool->sectors_per_block);
+	else
+		bio->bi_sector = (block << pool->sectors_per_block_shift) |
+				(bi_sector & (pool->sectors_per_block - 1));
 }
 
 static void remap_to_origin(struct thin_c *tc, struct bio *bio)
@@ -935,10 +943,7 @@ static void process_prepared(struct pool
  */
 static int io_overlaps_block(struct pool *pool, struct bio *bio)
 {
-	sector_t bi_sector = bio->bi_sector;
-
-	return !sector_div(bi_sector, pool->sectors_per_block) &&
-		(bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT));
+	return bio->bi_size == (pool->sectors_per_block << SECTOR_SHIFT);
 }
 
 static int io_overwrites_block(struct pool *pool, struct bio *bio)
@@ -1241,7 +1246,9 @@ static void process_discard(struct thin_
 			 * part of the discard that is in a subsequent
 			 * block.
 			 */
-			sector_t offset = bio->bi_sector - (block * pool->sectors_per_block);
+			sector_t offset = pool->sectors_per_block_shift >= 0 ?
+			      bio->bi_sector & (pool->sectors_per_block - 1) :
+			      bio->bi_sector - block * pool->sectors_per_block;
 			unsigned remaining = (pool->sectors_per_block - offset) << SECTOR_SHIFT;
 			bio->bi_size = min(bio->bi_size, remaining);
 
@@ -1718,6 +1725,10 @@ static struct pool *pool_create(struct m
 
 	pool->pmd = pmd;
 	pool->sectors_per_block = block_size;
+	if (block_size & (block_size - 1))
+		pool->sectors_per_block_shift = -1;
+	else
+		pool->sectors_per_block_shift = __ffs(block_size);
 	pool->low_water_blocks = 0;
 	pool_features_init(&pool->pf);
 	pool->prison = prison_create(PRISON_CELLS);
