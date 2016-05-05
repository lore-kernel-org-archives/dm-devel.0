From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/5] dm thin: remove __bio_inc_remaining() and
	switch to using bio_inc_remaining()
Date: Thu,  5 May 2016 11:54:23 -0400
Message-ID: <1462463665-85312-4-git-send-email-snitzer@redhat.com>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

DM thinp's use of bio_inc_remaining() is critical to ensure the original
parent discard bio isn't completed before sub-discards have.  DM thinp
needs this due to the extra quiescing that occurs, via multiple DM thinp
mappings, while processing large discards.  As such DM thinp must build
the async discard bio chain after some delay -- so bio_inc_remaining()
is used to enable DM thinp to take a reference on the original parent
discard bio for each mapping.  This allows the immediate use of
bio_endio() on that discard bio; but with the understanding that the
actual completion won't occur until each of the sub-discards'
per-mapping references are dropped.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 04e7f3b..da42c49 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1494,17 +1494,6 @@ static void process_discard_cell_no_passdown(struct thin_c *tc,
 		pool->process_prepared_discard(m);
 }
 
-/*
- * __bio_inc_remaining() is used to defer parent bios's end_io until
- * we _know_ all chained sub range discard bios have completed.
- */
-static inline void __bio_inc_remaining(struct bio *bio)
-{
-	bio->bi_flags |= (1 << BIO_CHAIN);
-	smp_mb__before_atomic();
-	atomic_inc(&bio->__bi_remaining);
-}
-
 static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t end,
 				 struct bio *bio)
 {
@@ -1560,7 +1549,7 @@ static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t
 		 * the implicit decrement that occurs via bio_endio() in
 		 * process_prepared_discard_{passdown,no_passdown}.
 		 */
-		__bio_inc_remaining(bio);
+		bio_inc_remaining(bio);
 		if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
 			pool->process_prepared_discard(m);
 
-- 
2.6.4 (Apple Git-63)
