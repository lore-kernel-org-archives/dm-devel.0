From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] dm: refactor start_io_acct
Date: Thu, 14 Feb 2019 16:00:03 +0100
Message-ID: <20190214150102.931117000@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=refactor-start-io-acct.patch
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

This patch refactors start_io_acct, so that it doesn't take a pointer to
struct dm_io - so that it could be used in the following patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2019-02-05 12:07:21.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2019-02-05 14:31:56.000000000 +0100
@@ -580,7 +580,10 @@ out:
 	return r;
 }
 
-static void start_io_acct(struct dm_io *io);
+static void start_io_acct(struct mapped_device *md, struct bio *bio)
+{
+	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio), &dm_disk(md)->part0);
+}
 
 static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 {
@@ -604,7 +607,14 @@ static struct dm_io *alloc_io(struct map
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
@@ -668,22 +678,6 @@ static bool md_in_flight(struct mapped_d
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
 static void end_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
