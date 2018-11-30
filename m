From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Fix target BIO completion handling
Date: Fri, 30 Nov 2018 15:31:48 +0900
Message-ID: <20181130063148.12075-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

struct bioctx includes the ref refcount_t to track the number of I/O
fragments used to process a target BIO as well as ensure that the zone
of the BIO is kept in the active state throughout the lifetime of the
BIO. However, since decrementing of this reference count is done in the
target .end_io method, the function bio_endio() must be called multiple
times for read and write target BIOs, which causes problems with the
value of the __bi_remaining struct bio field for chained BIOs (e.g. the
clone BIO passed by dm core is large and splits into fragments by the
block layer), resulting in incorrect values and inconsistencies with the
BIO_CHAIN flag setting. This is turn triggers the BUG_ON() call:

BUG_ON(atomic_read(&bio->__bi_remaining) <= 0);

in bio_remaining_done() called from bio_endio().

Fix this ensuring that bio_endio() is called only once for any target
BIO by always using internal clone BIOs for processing any read or
write target BIO. This allows reference counting using the target BIO
context counter to trigger the target BIO completion bio_endio() call
once all data, metadata and other zone work triggered by the BIO
complete.

Overall, this simplifies the code too as the target .end_io becomes
unnecessary and differences between read and write BIO issuing and
completion processing disappear.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-target.c | 122 +++++++++++------------------------
 1 file changed, 38 insertions(+), 84 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 981154e59461..6af5babe6837 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -20,7 +20,6 @@ struct dmz_bioctx {
 	struct dm_zone		*zone;
 	struct bio		*bio;
 	refcount_t		ref;
-	blk_status_t		status;
 };
 
 /*
@@ -78,65 +77,66 @@ static inline void dmz_bio_endio(struct bio *bio, blk_status_t status)
 {
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 
-	if (bioctx->status == BLK_STS_OK && status != BLK_STS_OK)
-		bioctx->status = status;
-	bio_endio(bio);
+	if (status != BLK_STS_OK && bio->bi_status == BLK_STS_OK)
+		bio->bi_status = status;
+
+	if (refcount_dec_and_test(&bioctx->ref)) {
+		struct dm_zone *zone = bioctx->zone;
+
+		if (zone) {
+			if (bio->bi_status != BLK_STS_OK &&
+			    bio_op(bio) == REQ_OP_WRITE &&
+			    dmz_is_seq(zone))
+				set_bit(DMZ_SEQ_WRITE_ERR, &zone->flags);
+			dmz_deactivate_zone(zone);
+		}
+		bio_endio(bio);
+	}
 }
 
 /*
- * Partial clone read BIO completion callback. This terminates the
+ * Completion callback for an internally cloned target BIO. This terminates the
  * target BIO when there are no more references to its context.
  */
-static void dmz_read_bio_end_io(struct bio *bio)
+static void dmz_clone_endio(struct bio *clone)
 {
-	struct dmz_bioctx *bioctx = bio->bi_private;
-	blk_status_t status = bio->bi_status;
+	struct dmz_bioctx *bioctx = clone->bi_private;
+	blk_status_t status = clone->bi_status;
 
-	bio_put(bio);
+	bio_put(clone);
 	dmz_bio_endio(bioctx->bio, status);
 }
 
 /*
- * Issue a BIO to a zone. The BIO may only partially process the
+ * Issue a clone of a target BIO. The clone may only partially process the
  * original target BIO.
  */
-static int dmz_submit_read_bio(struct dmz_target *dmz, struct dm_zone *zone,
-			       struct bio *bio, sector_t chunk_block,
-			       unsigned int nr_blocks)
+static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
+			  struct bio *bio, sector_t chunk_block,
+			  unsigned int nr_blocks)
 {
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
-	sector_t sector;
 	struct bio *clone;
 
-	/* BIO remap sector */
-	sector = dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
-
-	/* If the read is not partial, there is no need to clone the BIO */
-	if (nr_blocks == dmz_bio_blocks(bio)) {
-		/* Setup and submit the BIO */
-		bio->bi_iter.bi_sector = sector;
-		refcount_inc(&bioctx->ref);
-		generic_make_request(bio);
-		return 0;
-	}
-
-	/* Partial BIO: we need to clone the BIO */
 	clone = bio_clone_fast(bio, GFP_NOIO, &dmz->bio_set);
 	if (!clone)
 		return -ENOMEM;
 
-	/* Setup the clone */
-	clone->bi_iter.bi_sector = sector;
+	bio_set_dev(clone, dmz->dev->bdev);
+	clone->bi_iter.bi_sector =
+		dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
 	clone->bi_iter.bi_size = dmz_blk2sect(nr_blocks) << SECTOR_SHIFT;
-	clone->bi_end_io = dmz_read_bio_end_io;
+	clone->bi_end_io = dmz_clone_endio;
 	clone->bi_private = bioctx;
 
 	bio_advance(bio, clone->bi_iter.bi_size);
 
-	/* Submit the clone */
 	refcount_inc(&bioctx->ref);
 	generic_make_request(clone);
 
+	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
+		zone->wp_block += nr_blocks;
+
 	return 0;
 }
 
@@ -214,7 +214,7 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 		if (nr_blocks) {
 			/* Valid blocks found: read them */
 			nr_blocks = min_t(unsigned int, nr_blocks, end_block - chunk_block);
-			ret = dmz_submit_read_bio(dmz, rzone, bio, chunk_block, nr_blocks);
+			ret = dmz_submit_bio(dmz, rzone, bio, chunk_block, nr_blocks);
 			if (ret)
 				return ret;
 			chunk_block += nr_blocks;
@@ -228,25 +228,6 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 	return 0;
 }
 
-/*
- * Issue a write BIO to a zone.
- */
-static void dmz_submit_write_bio(struct dmz_target *dmz, struct dm_zone *zone,
-				 struct bio *bio, sector_t chunk_block,
-				 unsigned int nr_blocks)
-{
-	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
-
-	/* Setup and submit the BIO */
-	bio_set_dev(bio, dmz->dev->bdev);
-	bio->bi_iter.bi_sector = dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
-	refcount_inc(&bioctx->ref);
-	generic_make_request(bio);
-
-	if (dmz_is_seq(zone))
-		zone->wp_block += nr_blocks;
-}
-
 /*
  * Write blocks directly in a data zone, at the write pointer.
  * If a buffer zone is assigned, invalidate the blocks written
@@ -265,7 +246,9 @@ static int dmz_handle_direct_write(struct dmz_target *dmz,
 		return -EROFS;
 
 	/* Submit write */
-	dmz_submit_write_bio(dmz, zone, bio, chunk_block, nr_blocks);
+	ret = dmz_submit_bio(dmz, zone, bio, chunk_block, nr_blocks);
+	if (ret)
+		return ret;
 
 	/*
 	 * Validate the blocks in the data zone and invalidate
@@ -301,7 +284,9 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
 		return -EROFS;
 
 	/* Submit write */
-	dmz_submit_write_bio(dmz, bzone, bio, chunk_block, nr_blocks);
+	ret = dmz_submit_bio(dmz, bzone, bio, chunk_block, nr_blocks);
+	if (ret)
+		return ret;
 
 	/*
 	 * Validate the blocks in the buffer zone
@@ -600,7 +585,6 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 	bioctx->zone = NULL;
 	bioctx->bio = bio;
 	refcount_set(&bioctx->ref, 1);
-	bioctx->status = BLK_STS_OK;
 
 	/* Set the BIO pending in the flush list */
 	if (!nr_sectors && bio_op(bio) == REQ_OP_WRITE) {
@@ -623,35 +607,6 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_SUBMITTED;
 }
 
-/*
- * Completed target BIO processing.
- */
-static int dmz_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *error)
-{
-	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
-
-	if (bioctx->status == BLK_STS_OK && *error)
-		bioctx->status = *error;
-
-	if (!refcount_dec_and_test(&bioctx->ref))
-		return DM_ENDIO_INCOMPLETE;
-
-	/* Done */
-	bio->bi_status = bioctx->status;
-
-	if (bioctx->zone) {
-		struct dm_zone *zone = bioctx->zone;
-
-		if (*error && bio_op(bio) == REQ_OP_WRITE) {
-			if (dmz_is_seq(zone))
-				set_bit(DMZ_SEQ_WRITE_ERR, &zone->flags);
-		}
-		dmz_deactivate_zone(zone);
-	}
-
-	return DM_ENDIO_DONE;
-}
-
 /*
  * Get zoned device information.
  */
@@ -946,7 +901,6 @@ static struct target_type dmz_type = {
 	.ctr		 = dmz_ctr,
 	.dtr		 = dmz_dtr,
 	.map		 = dmz_map,
-	.end_io		 = dmz_end_io,
 	.io_hints	 = dmz_io_hints,
 	.prepare_ioctl	 = dmz_prepare_ioctl,
 	.postsuspend	 = dmz_suspend,
-- 
2.19.2
