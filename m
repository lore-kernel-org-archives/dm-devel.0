From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/8] dm: refactor start_io_acct and end_io_acct
Date: Tue, 19 Feb 2019 17:17:16 -0500
Message-ID: <20190219221721.29830-4-snitzer@redhat.com>
References: <20190219221721.29830-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190219221721.29830-1-snitzer@redhat.com>
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

From: Mikulas Patocka <mpatocka@redhat.com>

This refactoring of start_io_acct() and end_io_acct() eliminates their
dependency on 'struct dm_io' which will not be created for all IO
(following commit introduces the ability for targets to avoid cloning
bios for READ or WRITE bios).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 68 +++++++++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b988e178a523..1b87d20041e7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -580,7 +580,19 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 	return r;
 }
 
-static void start_io_acct(struct dm_io *io);
+static void start_io_acct(struct mapped_device *md, struct bio *bio)
+{
+	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio), &dm_disk(md)->part0);
+}
+
+static void end_io_acct(struct mapped_device *md, struct bio *bio, unsigned long start_time)
+{
+	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0, start_time);
+
+	/* nudge anyone waiting on suspend queue */
+	if (unlikely(wq_has_sleeper(&md->wait)))
+		wake_up(&md->wait);
+}
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 {
@@ -604,7 +616,14 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io->md = md;
 	spin_lock_init(&io->endio_lock);
 
-	start_io_acct(io);
+	io->start_time = jiffies;
+
+	start_io_acct(md, bio);
+
+	if (unlikely(dm_stats_used(&md->stats)))
+		dm_stats_account_io(&md->stats, bio_data_dir(bio),
+				    bio->bi_iter.bi_sector, bio_sectors(bio),
+				    false, 0, &io->stats_aux);
 
 	return io;
 }
@@ -668,41 +687,6 @@ static bool md_in_flight(struct mapped_device *md)
 		return md_in_flight_bios(md);
 }
 
-static void start_io_acct(struct dm_io *io)
-{
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->orig_bio;
-
-	io->start_time = jiffies;
-
-	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
-			      &dm_disk(md)->part0);
-
-	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio_data_dir(bio),
-				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    false, 0, &io->stats_aux);
-}
-
-static void end_io_acct(struct dm_io *io)
-{
-	struct mapped_device *md = io->md;
-	struct bio *bio = io->orig_bio;
-	unsigned long duration = jiffies - io->start_time;
-
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    io->start_time);
-
-	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio_data_dir(bio),
-				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, &io->stats_aux);
-
-	/* nudge anyone waiting on suspend queue */
-	if (unlikely(wq_has_sleeper(&md->wait)))
-		wake_up(&md->wait);
-}
-
 /*
  * Add the bio to the list of deferred io.
  */
@@ -941,7 +925,15 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
 
 		io_error = io->status;
 		bio = io->orig_bio;
-		end_io_acct(io);
+
+		if (unlikely(dm_stats_used(&md->stats))) {
+			unsigned long duration = jiffies - io->start_time;
+			dm_stats_account_io(&md->stats, bio_data_dir(bio),
+					    bio->bi_iter.bi_sector, bio_sectors(bio),
+					    true, duration, &io->stats_aux);
+		}
+
+		end_io_acct(md, bio, io->start_time);
 		free_io(md, io);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
-- 
2.15.0
