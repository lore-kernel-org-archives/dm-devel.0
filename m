From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/3] dm: move dm_stats_account_io before
	generic_end_io_acct
Date: Fri, 16 Nov 2018 01:04:17 +0100
Message-ID: <20181116000506.568964151@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-stats-ordering.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Make sure that the statistics are not updated while the device is
suspended. So, we move statistics update before generic_end_io_acct.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-dm/drivers/md/dm.c
===================================================================
--- linux-dm.orig/drivers/md/dm.c	2018-11-15 21:56:36.000000000 +0100
+++ linux-dm/drivers/md/dm.c	2018-11-15 21:56:36.000000000 +0100
@@ -674,6 +674,11 @@ static void end_io_acct(struct dm_io *io
 	struct bio *bio = io->orig_bio;
 	unsigned long duration = jiffies - io->start_time;
 
+	if (unlikely(dm_stats_used(&md->stats)))
+		dm_stats_account_io(&md->stats, bio_data_dir(bio),
+				    bio->bi_iter.bi_sector, bio_sectors(bio),
+				    true, duration, &io->stats_aux);
+
 	/*
 	 * make sure that atomic_dec in generic_end_io_acct is not reordered
 	 * with previous writes
@@ -687,11 +692,6 @@ static void end_io_acct(struct dm_io *io
 	 */
 	smp_mb__after_atomic();
 
-	if (unlikely(dm_stats_used(&md->stats)))
-		dm_stats_account_io(&md->stats, bio_data_dir(bio),
-				    bio->bi_iter.bi_sector, bio_sectors(bio),
-				    true, duration, &io->stats_aux);
-
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(waitqueue_active(&md->wait))) {
 		if (!md_in_flight(md))
