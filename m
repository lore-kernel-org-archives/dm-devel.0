From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 16/16] dm: Kill merge_bvec_fn()
Date: Fri, 25 May 2012 13:25:39 -0700
Message-ID: <1337977539-16977-17-git-send-email-koverstreet@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/dm.c |   58 -------------------------------------------------------
 1 file changed, 58 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 193fb19..a4c5256 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1309,63 +1309,6 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
  * CRUD END
  *---------------------------------------------------------------*/
 
-static int dm_merge_bvec(struct request_queue *q,
-			 struct bvec_merge_data *bvm,
-			 struct bio_vec *biovec)
-{
-	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table(md);
-	struct dm_target *ti;
-	sector_t max_sectors;
-	int max_size = 0;
-
-	if (unlikely(!map))
-		goto out;
-
-	ti = dm_table_find_target(map, bvm->bi_sector);
-	if (!dm_target_is_valid(ti))
-		goto out_table;
-
-	/*
-	 * Find maximum amount of I/O that won't need splitting
-	 */
-	max_sectors = min(max_io_len(bvm->bi_sector, ti),
-			  (sector_t) BIO_MAX_SECTORS);
-	max_size = (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
-	if (max_size < 0)
-		max_size = 0;
-
-	/*
-	 * merge_bvec_fn() returns number of bytes
-	 * it can accept at this offset
-	 * max is precomputed maximal io size
-	 */
-	if (max_size && ti->type->merge)
-		max_size = ti->type->merge(ti, bvm, biovec, max_size);
-	/*
-	 * If the target doesn't support merge method and some of the devices
-	 * provided their merge_bvec method (we know this by looking at
-	 * queue_max_hw_sectors), then we can't allow bios with multiple vector
-	 * entries.  So always set max_size to 0, and the code below allows
-	 * just one page.
-	 */
-	else if (queue_max_hw_sectors(q) <= PAGE_SIZE >> 9)
-
-		max_size = 0;
-
-out_table:
-	dm_table_put(map);
-
-out:
-	/*
-	 * Always allow an entire first page
-	 */
-	if (max_size <= biovec->bv_len && !(bvm->bi_size >> SECTOR_SHIFT))
-		max_size = biovec->bv_len;
-
-	return max_size;
-}
-
 /*
  * The request function that just remaps the bio built up by
  * dm_merge_bvec.
@@ -1766,7 +1709,6 @@ static void dm_init_md_queue(struct mapped_device *md)
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 }
 
 /*
-- 
1.7.9.3.327.g2980b
