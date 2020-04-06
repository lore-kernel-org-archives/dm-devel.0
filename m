From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/11] dm-zoned: use device as argument for bio
	handler functions
Date: Mon,  6 Apr 2020 16:35:01 +0200
Message-ID: <20200406143505.133271-8-hare@suse.de>
References: <20200406143505.133271-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200406143505.133271-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of having each function to reference the device for
themselves add it as an argument to the function.
And replace the 'target' pointer in the bio context with the
device pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-target.c | 88 +++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 02ee0ca1f0b0..8ed6d9f2df25 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -17,7 +17,7 @@
  * Zone BIO context.
  */
 struct dmz_bioctx {
-	struct dmz_target	*target;
+	struct dmz_dev		*dev;
 	struct dm_zone		*zone;
 	struct bio		*bio;
 	refcount_t		ref;
@@ -71,6 +71,11 @@ struct dmz_target {
  */
 #define DMZ_FLUSH_PERIOD	(10 * HZ)
 
+struct dmz_dev *dmz_sect_to_dev(struct dmz_target *dmz, sector_t sect)
+{
+	return &dmz->dev[0];
+}
+
 /*
  * Target BIO completion.
  */
@@ -81,7 +86,7 @@ static inline void dmz_bio_endio(struct bio *bio, blk_status_t status)
 	if (status != BLK_STS_OK && bio->bi_status == BLK_STS_OK)
 		bio->bi_status = status;
 	if (bio->bi_status != BLK_STS_OK)
-		bioctx->target->dev->flags |= DMZ_CHECK_BDEV;
+		bioctx->dev->flags |= DMZ_CHECK_BDEV;
 
 	if (refcount_dec_and_test(&bioctx->ref)) {
 		struct dm_zone *zone = bioctx->zone;
@@ -114,18 +119,20 @@ static void dmz_clone_endio(struct bio *clone)
  * Issue a clone of a target BIO. The clone may only partially process the
  * original target BIO.
  */
-static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
-			  struct bio *bio, sector_t chunk_block,
-			  unsigned int nr_blocks)
+static int dmz_submit_bio(struct dmz_target *dmz, struct dmz_dev *dev,
+			  struct dm_zone *zone, struct bio *bio,
+			  sector_t chunk_block, unsigned int nr_blocks)
 {
-	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
+	struct dmz_bioctx *bioctx =
+		dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 	struct bio *clone;
 
 	clone = bio_clone_fast(bio, GFP_NOIO, &dmz->bio_set);
 	if (!clone)
 		return -ENOMEM;
 
-	bio_set_dev(clone, dmz->dev->bdev);
+	bio_set_dev(clone, dev->bdev);
+	bioctx->dev = dev;
 	clone->bi_iter.bi_sector =
 		dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
 	clone->bi_iter.bi_size = dmz_blk2sect(nr_blocks) << SECTOR_SHIFT;
@@ -162,8 +169,8 @@ static void dmz_handle_read_zero(struct dmz_target *dmz, struct bio *bio,
 /*
  * Process a read BIO.
  */
-static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
-			   struct bio *bio)
+static int dmz_handle_read(struct dmz_target *dmz, struct dmz_dev *dev,
+			   struct dm_zone *zone, struct bio *bio)
 {
 	struct dmz_metadata *zmd = dmz->metadata;
 	sector_t chunk_block = dmz_chunk_block(zmd, dmz_bio_block(bio));
@@ -178,7 +185,7 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 		return 0;
 	}
 
-	dmz_dev_debug(dmz->dev, "READ chunk %llu -> %s zone %u, block %llu, %u blocks",
+	dmz_dev_debug(dev, "READ chunk %llu -> %s zone %u, block %llu, %u blocks",
 		      (unsigned long long)dmz_bio_chunk(zmd, bio),
 		      (dmz_is_rnd(zone) ? "RND" : "SEQ"),
 		      dmz_id(zmd, zone),
@@ -218,7 +225,8 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
 		if (nr_blocks) {
 			/* Valid blocks found: read them */
 			nr_blocks = min_t(unsigned int, nr_blocks, end_block - chunk_block);
-			ret = dmz_submit_bio(dmz, rzone, bio, chunk_block, nr_blocks);
+			ret = dmz_submit_bio(dmz, dev, rzone, bio,
+					     chunk_block, nr_blocks);
 			if (ret)
 				return ret;
 			chunk_block += nr_blocks;
@@ -238,6 +246,7 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
  * in place.
  */
 static int dmz_handle_direct_write(struct dmz_target *dmz,
+				   struct dmz_dev *dev,
 				   struct dm_zone *zone, struct bio *bio,
 				   sector_t chunk_block,
 				   unsigned int nr_blocks)
@@ -250,7 +259,7 @@ static int dmz_handle_direct_write(struct dmz_target *dmz,
 		return -EROFS;
 
 	/* Submit write */
-	ret = dmz_submit_bio(dmz, zone, bio, chunk_block, nr_blocks);
+	ret = dmz_submit_bio(dmz, dev, zone, bio, chunk_block, nr_blocks);
 	if (ret)
 		return ret;
 
@@ -271,6 +280,7 @@ static int dmz_handle_direct_write(struct dmz_target *dmz,
  * Called with @zone write locked.
  */
 static int dmz_handle_buffered_write(struct dmz_target *dmz,
+				     struct dmz_dev *dev,
 				     struct dm_zone *zone, struct bio *bio,
 				     sector_t chunk_block,
 				     unsigned int nr_blocks)
@@ -288,7 +298,7 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
 		return -EROFS;
 
 	/* Submit write */
-	ret = dmz_submit_bio(dmz, bzone, bio, chunk_block, nr_blocks);
+	ret = dmz_submit_bio(dmz, dev, bzone, bio, chunk_block, nr_blocks);
 	if (ret)
 		return ret;
 
@@ -306,8 +316,8 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
 /*
  * Process a write BIO.
  */
-static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone,
-			    struct bio *bio)
+static int dmz_handle_write(struct dmz_target *dmz, struct dmz_dev *dev,
+			    struct dm_zone *zone, struct bio *bio)
 {
 	struct dmz_metadata *zmd = dmz->metadata;
 	sector_t chunk_block = dmz_chunk_block(zmd, dmz_bio_block(bio));
@@ -316,7 +326,7 @@ static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone,
 	if (!zone)
 		return -ENOSPC;
 
-	dmz_dev_debug(dmz->dev, "WRITE chunk %llu -> %s zone %u, block %llu, %u blocks",
+	dmz_dev_debug(dev, "WRITE chunk %llu -> %s zone %u, block %llu, %u blocks",
 		      (unsigned long long)dmz_bio_chunk(zmd, bio),
 		      (dmz_is_rnd(zone) ? "RND" : "SEQ"),
 		      dmz_id(zmd, zone),
@@ -328,21 +338,23 @@ static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone,
 		 * and the BIO is aligned to the zone write pointer:
 		 * direct write the zone.
 		 */
-		return dmz_handle_direct_write(dmz, zone, bio, chunk_block, nr_blocks);
+		return dmz_handle_direct_write(dmz, dev, zone, bio,
+					       chunk_block, nr_blocks);
 	}
 
 	/*
 	 * This is an unaligned write in a sequential zone:
 	 * use buffered write.
 	 */
-	return dmz_handle_buffered_write(dmz, zone, bio, chunk_block, nr_blocks);
+	return dmz_handle_buffered_write(dmz, dev, zone, bio,
+					 chunk_block, nr_blocks);
 }
 
 /*
  * Process a discard BIO.
  */
-static int dmz_handle_discard(struct dmz_target *dmz, struct dm_zone *zone,
-			      struct bio *bio)
+static int dmz_handle_discard(struct dmz_target *dmz, struct dmz_dev *dev,
+			      struct dm_zone *zone, struct bio *bio)
 {
 	struct dmz_metadata *zmd = dmz->metadata;
 	sector_t block = dmz_bio_block(bio);
@@ -357,7 +369,7 @@ static int dmz_handle_discard(struct dmz_target *dmz, struct dm_zone *zone,
 	if (dmz_is_readonly(zone))
 		return -EROFS;
 
-	dmz_dev_debug(dmz->dev, "DISCARD chunk %llu -> zone %u, block %llu, %u blocks",
+	dmz_dev_debug(dev, "DISCARD chunk %llu -> zone %u, block %llu, %u blocks",
 		      (unsigned long long)dmz_bio_chunk(zmd, bio),
 		      dmz_id(zmd, zone),
 		      (unsigned long long)chunk_block, nr_blocks);
@@ -382,6 +394,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 {
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 	struct dmz_metadata *zmd = dmz->metadata;
+	struct dmz_dev *dev;
 	struct dm_zone *zone;
 	int ret;
 
@@ -394,11 +407,6 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 
 	dmz_lock_metadata(zmd);
 
-	if (dmz->dev->flags & DMZ_BDEV_DYING) {
-		ret = -EIO;
-		goto out;
-	}
-
 	/*
 	 * Get the data zone mapping the chunk. There may be no
 	 * mapping for read and discard. If a mapping is obtained,
@@ -413,23 +421,30 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 
 	/* Process the BIO */
 	if (zone) {
+		dev = dmz_zone_to_dev(zmd, zone);
 		dmz_activate_zone(zone);
 		bioctx->zone = zone;
+	} else
+		dev = dmz_sect_to_dev(dmz, bio->bi_iter.bi_sector);
+
+	if (dev->flags & DMZ_BDEV_DYING) {
+		ret = -EIO;
+		goto out;
 	}
 
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
-		ret = dmz_handle_read(dmz, zone, bio);
+		ret = dmz_handle_read(dmz, dev, zone, bio);
 		break;
 	case REQ_OP_WRITE:
-		ret = dmz_handle_write(dmz, zone, bio);
+		ret = dmz_handle_write(dmz, dev, zone, bio);
 		break;
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_ZEROES:
-		ret = dmz_handle_discard(dmz, zone, bio);
+		ret = dmz_handle_discard(dmz, dev, zone, bio);
 		break;
 	default:
-		dmz_dev_err(dmz->dev, "Unsupported BIO operation 0x%x",
+		dmz_dev_err(dev, "Unsupported BIO operation 0x%x",
 			    bio_op(bio));
 		ret = -EIO;
 	}
@@ -621,14 +636,14 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dmz_target *dmz = ti->private;
 	struct dmz_metadata *zmd = dmz->metadata;
-	struct dmz_dev *dev = dmz->dev;
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 	sector_t sector = bio->bi_iter.bi_sector;
 	unsigned int nr_sectors = bio_sectors(bio);
+	struct dmz_dev *dev = dmz_sect_to_dev(dmz, sector);
 	sector_t chunk_sector;
 	int ret;
 
-	if (dmz_bdev_is_dying(dmz->dev))
+	if (dmz_bdev_is_dying(dev))
 		return DM_MAPIO_KILL;
 
 	dmz_dev_debug(dev, "BIO op %d sector %llu + %u => chunk %llu, block %llu, %u blocks",
@@ -647,7 +662,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_KILL;
 
 	/* Initialize the BIO context */
-	bioctx->target = dmz;
+	bioctx->dev = NULL;
 	bioctx->zone = NULL;
 	bioctx->bio = bio;
 	refcount_set(&bioctx->ref, 1);
@@ -669,7 +684,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 	/* Now ready to handle this BIO */
 	ret = dmz_queue_chunk_work(dmz, bio);
 	if (ret) {
-		dmz_dev_debug(dmz->dev,
+		dmz_dev_debug(dev,
 			      "BIO op %d, can't process chunk %llu, err %i\n",
 			      bio_op(bio), (u64)dmz_bio_chunk(zmd, bio),
 			      ret);
@@ -926,11 +941,12 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
 static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
 {
 	struct dmz_target *dmz = ti->private;
+	struct dmz_dev *dev = dmz_sect_to_dev(dmz, 0);
 
-	if (!dmz_check_bdev(dmz->dev))
+	if (!dmz_check_bdev(dev))
 		return -EIO;
 
-	*bdev = dmz->dev->bdev;
+	*bdev = dev->bdev;
 
 	return 0;
 }
-- 
2.25.0
