From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: use dm_target_offset in targets
Date: Wed, 28 Jul 2010 10:21:31 -0400
Message-ID: <1280326891-1269-1-git-send-email-snitzer@redhat.com>
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

Convert targets over to using dm_target_offset.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c  |    4 ++--
 drivers/md/dm-delay.c  |    4 ++--
 drivers/md/dm-linear.c |    2 +-
 drivers/md/dm-raid1.c  |    2 +-
 drivers/md/dm-stripe.c |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c
+++ linux-2.6/drivers/md/dm-stripe.c
@@ -211,7 +211,7 @@ static void stripe_dtr(struct dm_target 
 static void stripe_map_sector(struct stripe_c *sc, sector_t sector,
 			      uint32_t *stripe, sector_t *result)
 {
-	sector_t offset = sector - sc->ti->begin;
+	sector_t offset = dm_target_offset(sc->ti, sector);
 	sector_t chunk = offset >> sc->chunk_shift;
 	*stripe = sector_div(chunk, sc->stripes);
 	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -1254,7 +1254,7 @@ static int crypt_map(struct dm_target *t
 		return DM_MAPIO_REMAPPED;
 	}
 
-	io = crypt_io_alloc(ti, bio, bio->bi_sector - ti->begin);
+	io = crypt_io_alloc(ti, bio, dm_target_offset(ti, bio->bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_queue_io(io);
@@ -1377,7 +1377,7 @@ static int crypt_merge(struct dm_target 
 		return max_size;
 
 	bvm->bi_bdev = cc->dev->bdev;
-	bvm->bi_sector = cc->start + bvm->bi_sector - ti->begin;
+	bvm->bi_sector = cc->start + dm_target_offset(ti, bvm->bi_sector);
 
 	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
 }
Index: linux-2.6/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-delay.c
+++ linux-2.6/drivers/md/dm-delay.c
@@ -282,14 +282,14 @@ static int delay_map(struct dm_target *t
 		bio->bi_bdev = dc->dev_write->bdev;
 		if (bio_sectors(bio))
 			bio->bi_sector = dc->start_write +
-					 (bio->bi_sector - ti->begin);
+					 dm_target_offset(ti, bio->bi_sector);
 
 		return delay_bio(dc, dc->write_delay, bio);
 	}
 
 	bio->bi_bdev = dc->dev_read->bdev;
 	bio->bi_sector = dc->start_read +
-			 (bio->bi_sector - ti->begin);
+			 dm_target_offset(ti, bio->bi_sector);
 
 	return delay_bio(dc, dc->read_delay, bio);
 }
Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c
+++ linux-2.6/drivers/md/dm-linear.c
@@ -74,7 +74,7 @@ static sector_t linear_map_sector(struct
 {
 	struct linear_c *lc = ti->private;
 
-	return lc->start + (bi_sector - ti->begin);
+	return lc->start + dm_target_offset(ti, bi_sector);
 }
 
 static void linear_map_bio(struct dm_target *ti, struct bio *bio)
Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c
+++ linux-2.6/drivers/md/dm-raid1.c
@@ -445,7 +445,7 @@ static sector_t map_sector(struct mirror
 {
 	if (unlikely(!bio->bi_size))
 		return 0;
-	return m->offset + (bio->bi_sector - m->ms->ti->begin);
+	return m->offset + dm_target_offset(m->ms->ti, bio->bi_sector);
 }
 
 static void map_bio(struct mirror *m, struct bio *bio)
