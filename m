From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.15 2/3] dm era: support non power-of-2
	blocksize
Date: Thu,  6 Mar 2014 19:47:27 -0500
Message-ID: <1394153248-32217-2-git-send-email-snitzer@redhat.com>
References: <1394153248-32217-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1394153248-32217-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan.Mears@netapp.com, ejt@redhat.com
List-Id: dm-devel.ids

The dm-era target is expected to be paired with the dm-cache target
which has support for non power-of-2 data blocksize.  So dm-era should
also support an origin data device blocksize that is non power-of-2.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-era-target.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index f772351..d7bd7b3 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1080,9 +1080,9 @@ struct era {
 	struct dm_dev *metadata_dev;
 	struct dm_dev *origin_dev;
 
-	uint32_t block_size;
 	dm_block_t nr_blocks;
-	unsigned sectors_per_block_shift;
+	uint32_t sectors_per_block;
+	int sectors_per_block_shift;
 	struct era_metadata *md;
 
 	struct workqueue_struct *wq;
@@ -1113,9 +1113,21 @@ struct rpc {
 /*----------------------------------------------------------------
  * Remapping.
  *---------------------------------------------------------------*/
+static bool block_size_is_power_of_two(struct era *era)
+{
+	return era->sectors_per_block_shift >= 0;
+}
+
 static dm_block_t get_block(struct era *era, struct bio *bio)
 {
-	return bio->bi_iter.bi_sector >> era->sectors_per_block_shift;
+	dm_block_t block_nr = bio->bi_iter.bi_sector;
+
+	if (!block_size_is_power_of_two(era))
+		(void) sector_div(block_nr, era->sectors_per_block);
+	else
+		block_nr >>= era->sectors_per_block_shift;
+
+	return block_nr;
 }
 
 static void remap_to_origin(struct era *era, struct bio *bio)
@@ -1336,7 +1348,7 @@ static void era_destroy(struct era *era)
 
 static dm_block_t calc_nr_blocks(struct era *era)
 {
-	return dm_sector_div_up(era->ti->len, era->block_size);
+	return dm_sector_div_up(era->ti->len, era->sectors_per_block);
 }
 
 /*
@@ -1376,22 +1388,26 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		return -EINVAL;
 	}
 
-	r = sscanf(argv[2], "%u%c", &era->block_size, &dummy);
+	r = sscanf(argv[2], "%u%c", &era->sectors_per_block, &dummy);
 	if (r != 1) {
 		ti->error = "Error parsing block size";
 		era_destroy(era);
 		return -EINVAL;
 	}
-	era->sectors_per_block_shift = __ffs(era->block_size);
 
-	r = dm_set_target_max_io_len(ti, era->block_size);
+	r = dm_set_target_max_io_len(ti, era->sectors_per_block);
 	if (r) {
 		ti->error = "could not set max io len";
 		era_destroy(era);
 		return -EINVAL;
 	}
 
-	md = metadata_open(era->metadata_dev->bdev, era->block_size, true);
+	if (era->sectors_per_block & (era->sectors_per_block - 1))
+		era->sectors_per_block_shift = -1;
+	else
+		era->sectors_per_block_shift = __ffs(era->sectors_per_block);
+
+	md = metadata_open(era->metadata_dev->bdev, era->sectors_per_block, true);
 	if (IS_ERR(md)) {
 		ti->error = "Error reading metadata";
 		era_destroy(era);
@@ -1549,7 +1565,7 @@ static void era_status(struct dm_target *ti, status_type_t type,
 		format_dev_t(buf, era->metadata_dev->bdev->bd_dev);
 		DMEMIT("%s ", buf);
 		format_dev_t(buf, era->origin_dev->bdev->bd_dev);
-		DMEMIT("%s %u", buf, era->block_size);
+		DMEMIT("%s %u", buf, era->sectors_per_block);
 		break;
 	}
 
@@ -1614,12 +1630,12 @@ static void era_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 	/*
 	 * If the system-determined stacked limits are compatible with the
-	 * cache's blocksize (io_opt is a factor) do not override them.
+	 * era device's blocksize (io_opt is a factor) do not override them.
 	 */
-	if (io_opt_sectors < era->block_size ||
-	    do_div(io_opt_sectors, era->block_size)) {
+	if (io_opt_sectors < era->sectors_per_block ||
+	    do_div(io_opt_sectors, era->sectors_per_block)) {
 		blk_limits_io_min(limits, 0);
-		blk_limits_io_opt(limits, era->block_size << SECTOR_SHIFT);
+		blk_limits_io_opt(limits, era->sectors_per_block << SECTOR_SHIFT);
 	}
 }
 
-- 
1.8.1.4
