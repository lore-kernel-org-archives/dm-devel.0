From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 13/26] raid5: use bio_reset()
Date: Mon, 15 Oct 2012 13:09:16 -0700
Message-ID: <1350331769-14856-43-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>
List-Id: dm-devel.ids

Had to shuffle the code around a bit (where bi_rw and bi_end_io were
set), but shouldn't really be anything tricky here

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7c19dbe..ebe43f7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -561,14 +561,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		bi = &sh->dev[i].req;
 		rbi = &sh->dev[i].rreq; /* For writing to replacement */
 
-		bi->bi_rw = rw;
-		rbi->bi_rw = rw;
-		if (rw & WRITE) {
-			bi->bi_end_io = raid5_end_write_request;
-			rbi->bi_end_io = raid5_end_write_request;
-		} else
-			bi->bi_end_io = raid5_end_read_request;
-
 		rcu_read_lock();
 		rrdev = rcu_dereference(conf->disks[i].replacement);
 		smp_mb(); /* Ensure that if rrdev is NULL, rdev won't be */
@@ -643,7 +635,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
+			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
+			bi->bi_rw = rw;
+			bi->bi_end_io = (rw & WRITE)
+				? raid5_end_write_request
+				: raid5_end_read_request;
+			bi->bi_private = sh;
+
 			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
@@ -657,12 +656,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 				bi->bi_rw |= REQ_FLUSH;
 
-			bi->bi_flags = 1 << BIO_UPTODATE;
-			bi->bi_idx = 0;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
-			bi->bi_next = NULL;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 			generic_make_request(bi);
@@ -674,7 +670,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
+			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
+			rbi->bi_rw = rw;
+			rbi->bi_end_io = (rw & WRITE)
+				? raid5_end_write_request
+				: raid5_end_read_request;
+			rbi->bi_private = sh;
+
 			pr_debug("%s: for %llu schedule op %ld on "
 				 "replacement disc %d\n",
 				__func__, (unsigned long long)sh->sector,
@@ -686,12 +689,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			else
 				rbi->bi_sector = (sh->sector
 						  + rrdev->data_offset);
-			rbi->bi_flags = 1 << BIO_UPTODATE;
-			rbi->bi_idx = 0;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_size = STRIPE_SIZE;
-			rbi->bi_next = NULL;
 			generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
-- 
1.7.12
