From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm thin: make use of
	block_size_is_power_of_two to make code clearer
Date: Fri,  4 Jan 2013 22:22:53 -0500
Message-ID: <1357356174-20661-1-git-send-email-snitzer@redhat.com>
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

Use rather block_size_is_power_of_two() than checking
sectors_per_block_shift directly.  Also introduce local pool variable in
get_bio_block() to eliminate redundant tc->pool dereferences.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 675ae52..abc2c78 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -330,14 +330,20 @@ static void requeue_io(struct thin_c *tc)
  * target.
  */
 
+static bool block_size_is_power_of_two(struct pool *pool)
+{
+	return pool->sectors_per_block_shift >= 0;
+}
+
 static dm_block_t get_bio_block(struct thin_c *tc, struct bio *bio)
 {
+	struct pool *pool = tc->pool;
 	sector_t block_nr = bio->bi_sector;
 
-	if (tc->pool->sectors_per_block_shift < 0)
-		(void) sector_div(block_nr, tc->pool->sectors_per_block);
+	if (block_size_is_power_of_two(pool))
+		block_nr >>= pool->sectors_per_block_shift;
 	else
-		block_nr >>= tc->pool->sectors_per_block_shift;
+		(void) sector_div(block_nr, pool->sectors_per_block);
 
 	return block_nr;
 }
@@ -348,12 +354,12 @@ static void remap(struct thin_c *tc, struct bio *bio, dm_block_t block)
 	sector_t bi_sector = bio->bi_sector;
 
 	bio->bi_bdev = tc->pool_dev->bdev;
-	if (tc->pool->sectors_per_block_shift < 0)
-		bio->bi_sector = (block * pool->sectors_per_block) +
-				 sector_div(bi_sector, pool->sectors_per_block);
-	else
+	if (block_size_is_power_of_two(pool))
 		bio->bi_sector = (block << pool->sectors_per_block_shift) |
 				(bi_sector & (pool->sectors_per_block - 1));
+	else
+		bio->bi_sector = (block * pool->sectors_per_block) +
+				 sector_div(bi_sector, pool->sectors_per_block);
 }
 
 static void remap_to_origin(struct thin_c *tc, struct bio *bio)
@@ -2414,11 +2420,6 @@ static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
 
-static bool block_size_is_power_of_two(struct pool *pool)
-{
-	return pool->sectors_per_block_shift >= 0;
-}
-
 static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 {
 	struct pool *pool = pt->pool;
-- 
1.7.4.4
