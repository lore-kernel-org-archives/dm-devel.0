From: josef@toxicpanda.com
Subject: [PATCH 2/2] dm-log-writes: fix >512b sectorsize support
Date: Fri, 28 Jul 2017 10:42:25 -0400
Message-ID: <1501252945-20615-2-git-send-email-jbacik@fb.com>
References: <1501252945-20615-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1501252945-20615-1-git-send-email-jbacik@fb.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kernel-team@fb.com, dm-devel@redhat.com
Cc: Josef Bacik <jbacik@fb.com>
List-Id: dm-devel.ids

From: Josef Bacik <jbacik@fb.com>

I screwed up the initial >512b support, I was storing the bio sectors
which are 512b sectors in the log metadata which expects them to be in
sectorsize units of sectors.  I also was assuming device sectors when
assigning the bi_sector for the blocks I was logging in some places.

Fix this up by adding two helpers to convert between bio and dev
sectors, and use these in the appropriate places to fix the problem and
make it clear which units go where.  With this patch I could now
properly use dm-log-writes with 4k devices.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 drivers/md/dm-log-writes.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 9aab510..6f1b954 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -100,6 +100,7 @@ struct log_writes_c {
 	struct dm_dev *logdev;
 	u64 logged_entries;
 	u32 sectorsize;
+	u32 sectorshift;
 	atomic_t io_blocks;
 	atomic_t pending_blocks;
 	sector_t next_sector;
@@ -128,6 +129,18 @@ struct per_bio_data {
 	struct pending_block *block;
 };
 
+static inline sector_t bio_to_dev_sectors(struct log_writes_c *lc,
+					  sector_t sectors)
+{
+	return sectors >> (lc->sectorshift - SECTOR_SHIFT);
+}
+
+static inline sector_t dev_to_bio_sectors(struct log_writes_c *lc,
+					  sector_t sectors)
+{
+	return sectors << (lc->sectorshift - SECTOR_SHIFT);
+}
+
 static void put_pending_block(struct log_writes_c *lc)
 {
 	if (atomic_dec_and_test(&lc->pending_blocks)) {
@@ -253,7 +266,7 @@ static int log_one_block(struct log_writes_c *lc,
 
 	if (!block->vec_cnt)
 		goto out;
-	sector++;
+	sector += dev_to_bio_sectors(lc, 1);
 
 	atomic_inc(&lc->io_blocks);
 	bio = bio_alloc(GFP_KERNEL, min(block->vec_cnt, BIO_MAX_PAGES));
@@ -354,10 +367,10 @@ static int log_writes_kthread(void *arg)
 				goto next;
 
 			sector = lc->next_sector;
-			if (block->flags & LOG_DISCARD_FLAG)
-				lc->next_sector++;
-			else
-				lc->next_sector += block->nr_sectors + 1;
+			if (!(block->flags & LOG_DISCARD_FLAG))
+				lc->next_sector +=
+					dev_to_bio_sectors(lc, block->nr_sectors);
+			lc->next_sector += dev_to_bio_sectors(lc, 1);
 
 			/*
 			 * Apparently the size of the device may not be known
@@ -435,7 +448,6 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_LIST_HEAD(&lc->unflushed_blocks);
 	INIT_LIST_HEAD(&lc->logging_blocks);
 	init_waitqueue_head(&lc->wait);
-	lc->sectorsize = 1 << SECTOR_SHIFT;
 	atomic_set(&lc->io_blocks, 0);
 	atomic_set(&lc->pending_blocks, 0);
 
@@ -455,6 +467,8 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	lc->sectorsize = bdev_logical_block_size(lc->dev->bdev);
+	lc->sectorshift = ilog2(lc->sectorsize);
 	lc->log_kthread = kthread_run(log_writes_kthread, lc, "log-write");
 	if (IS_ERR(lc->log_kthread)) {
 		ret = PTR_ERR(lc->log_kthread);
@@ -464,8 +478,12 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	/* We put the super at sector 0, start logging at sector 1 */
-	lc->next_sector = 1;
+	/*
+	 * next_sector is in 512 sectors to correspond to what bi_sector expects
+	 * to be.  The super starts at sector 0, and the next_sector is the next
+	 * logical one based on the sectorsize of the device.
+	 */
+	lc->next_sector = lc->sectorsize >> SECTOR_SHIFT;
 	lc->logging_enabled = true;
 	lc->end_sector = logdev_last_sector(lc);
 	lc->device_supports_discard = true;
@@ -599,8 +617,8 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	if (discard_bio)
 		block->flags |= LOG_DISCARD_FLAG;
 
-	block->sector = bio->bi_iter.bi_sector;
-	block->nr_sectors = bio_sectors(bio);
+	block->sector = bio_to_dev_sectors(lc, bio->bi_iter.bi_sector);
+	block->nr_sectors = bio_to_dev_sectors(lc, bio_sectors(bio));
 
 	/* We don't need the data, just submit */
 	if (discard_bio) {
@@ -767,9 +785,12 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 
 	if (!q || !blk_queue_discard(q)) {
 		lc->device_supports_discard = false;
-		limits->discard_granularity = 1 << SECTOR_SHIFT;
+		limits->discard_granularity = lc->sectorsize;
 		limits->max_discard_sectors = (UINT_MAX >> SECTOR_SHIFT);
 	}
+	limits->logical_block_size = bdev_logical_block_size(lc->dev->bdev);
+	limits->physical_block_size = bdev_physical_block_size(lc->dev->bdev);
+	limits->io_min = limits->physical_block_size;
 }
 
 static struct target_type log_writes_target = {
-- 
2.7.4
