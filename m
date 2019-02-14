From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] dm: refactor end_io_acct
Date: Thu, 14 Feb 2019 16:00:04 +0100
Message-ID: <20190214150104.178508520@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=refactor-end-io-acct.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This patch refactors end_io_acct, so that it doesn't take a pointer to
struct dm_io - so that it could be used in the following patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2019-02-05 14:32:08.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2019-02-05 14:36:13.000000000 +0100
@@ -585,6 +585,15 @@ static void start_io_acct(struct mapped_
 	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio), &dm_disk(md)->part0);
 }
 
+static void end_io_acct(struct mapped_device *md, struct bio *bio, unsigned long start_time)
+{
+	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0, start_time);
+
+	/* nudge anyone waiting on suspend queue */
+	if (unlikely(wq_has_sleeper(&md->wait)))
+		wake_up(&md->wait);
+}
+
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 {
 	struct dm_io *io;
@@ -678,25 +687,6 @@ static bool md_in_flight(struct mapped_d
 		return md_in_flight_bios(md);
 }
 
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
@@ -935,7 +925,15 @@ static void dec_pending(struct dm_io *io
 
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
