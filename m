From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm-zoned: Fix conversion of BIO errors to
	blk_status_t
Date: Wed, 14 Jun 2017 08:22:28 +0900
Message-ID: <20170613232228.24410-1-damien.lemoal@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

Fixed reference to BIO status after free (bio_put() call) of the BIO.
Other changes are small cosmetic fixes to the conversion from errno to
blk_status_t: renamed BIO context error field to status, simplify
dm_zoned_endio() interface and use errno_to_blk_status() where
necessary to convert errnos to BIO status.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c |  6 +++---
 drivers/md/dm-zoned-target.c   | 29 +++++++++++++++--------------
 drivers/md/dm-zoned.h          |  2 +-
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index b8f7d1d..4618441c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -691,14 +691,14 @@ static int dmz_log_dirty_mblocks(struct dmz_metadata *zmd,
 /*
  * Flush dirty metadata blocks.
  */
-blk_status_t dmz_flush_metadata(struct dmz_metadata *zmd)
+int dmz_flush_metadata(struct dmz_metadata *zmd)
 {
 	struct dmz_mblock *mblk;
 	struct list_head write_list;
 	int ret;
 
 	if (WARN_ON(!zmd))
-		return BLK_STS_OK;
+		return 0;
 
 	INIT_LIST_HEAD(&write_list);
 
@@ -769,7 +769,7 @@ blk_status_t dmz_flush_metadata(struct dmz_metadata *zmd)
 	dmz_unlock_flush(zmd);
 	up_write(&zmd->mblk_sem);
 
-	return errno_to_blk_status(ret);
+	return ret;
 }
 
 /*
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index c9fdd02..d25696c 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -20,7 +20,7 @@ struct dmz_bioctx {
 	struct dm_zone		*zone;
 	struct bio		*bio;
 	atomic_t		ref;
-	blk_status_t		error;
+	blk_status_t		status;
 };
 
 /*
@@ -74,12 +74,12 @@ struct dmz_target {
 /*
  * Target BIO completion.
  */
-static inline void dmz_bio_endio(struct bio *bio, blk_status_t *error)
+static inline void dmz_bio_endio(struct bio *bio, blk_status_t status)
 {
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 
-	if (bioctx->error == BLK_STS_OK && *error)
-		bioctx->error = *error;
+	if (bioctx->status == BLK_STS_OK && status != BLK_STS_OK)
+		bioctx->status = status;
 	bio_endio(bio);
 }
 
@@ -90,9 +90,10 @@ static inline void dmz_bio_endio(struct bio *bio, blk_status_t *error)
 static void dmz_read_bio_end_io(struct bio *bio)
 {
 	struct dmz_bioctx *bioctx = bio->bi_private;
+	blk_status_t status = bio->bi_status;
 
 	bio_put(bio);
-	dmz_bio_endio(bioctx->bio, &bio->bi_status);
+	dmz_bio_endio(bioctx->bio, status);
 }
 
 /*
@@ -392,7 +393,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 	struct dmz_metadata *zmd = dmz->metadata;
 	struct dm_zone *zone;
-	blk_status_t ret;
+	int ret;
 
 	/*
 	 * Write may trigger a zone allocation. So make sure the
@@ -435,7 +436,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 	default:
 		dmz_dev_err(dmz->dev, "Unsupported BIO operation 0x%x",
 			    bio_op(bio));
-		ret = BLK_STS_IOERR;
+		ret = -EIO;
 	}
 
 	/*
@@ -445,7 +446,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
 	if (zone)
 		dmz_put_chunk_mapping(zmd, zone);
 out:
-	dmz_bio_endio(bio, &ret);
+	dmz_bio_endio(bio, errno_to_blk_status(ret));
 
 	dmz_unlock_metadata(zmd);
 }
@@ -503,7 +504,7 @@ static void dmz_flush_work(struct work_struct *work)
 {
 	struct dmz_target *dmz = container_of(work, struct dmz_target, flush_work.work);
 	struct bio *bio;
-	blk_status_t ret;
+	int ret;
 
 	/* Flush dirty metadata blocks */
 	ret = dmz_flush_metadata(dmz->metadata);
@@ -517,7 +518,7 @@ static void dmz_flush_work(struct work_struct *work)
 		if (!bio)
 			break;
 
-		dmz_bio_endio(bio, &ret);
+		dmz_bio_endio(bio, errno_to_blk_status(ret));
 	}
 
 	queue_delayed_work(dmz->flush_wq, &dmz->flush_work, DMZ_FLUSH_PERIOD);
@@ -599,7 +600,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
 	bioctx->zone = NULL;
 	bioctx->bio = bio;
 	atomic_set(&bioctx->ref, 1);
-	bioctx->error = BLK_STS_OK;
+	bioctx->status = BLK_STS_OK;
 
 	/* Set the BIO pending in the flush list */
 	if (bio_op(bio) == REQ_OP_FLUSH || (!nr_sectors && bio_op(bio) == REQ_OP_WRITE)) {
@@ -629,14 +630,14 @@ static int dmz_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *error
 {
 	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
 
-	if (bioctx->error == BLK_STS_OK && *error)
-		bioctx->error = *error;
+	if (bioctx->status == BLK_STS_OK && *error)
+		bioctx->status = *error;
 
 	if (!atomic_dec_and_test(&bioctx->ref))
 		return DM_ENDIO_INCOMPLETE;
 
 	/* Done */
-	bio->bi_status = bioctx->error;
+	bio->bi_status = bioctx->status;
 
 	if (bioctx->zone) {
 		struct dm_zone *zone = bioctx->zone;
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 76ebcf8..12419f0 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -169,7 +169,7 @@ void dmz_lock_metadata(struct dmz_metadata *zmd);
 void dmz_unlock_metadata(struct dmz_metadata *zmd);
 void dmz_lock_flush(struct dmz_metadata *zmd);
 void dmz_unlock_flush(struct dmz_metadata *zmd);
-blk_status_t dmz_flush_metadata(struct dmz_metadata *zmd);
+int dmz_flush_metadata(struct dmz_metadata *zmd);
 
 unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone);
 sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone);
-- 
2.9.4
