From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] dm-thin: fix discard support
Date: Mon, 16 Jul 2012 14:35:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207161434550.3859@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1207161432310.3859@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207161434300.3859@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1207161434300.3859@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

dm-thin: fix discard support

There is a bug in dm_thin regarding processing discards.
When dm-thin receives a discard request with size equal to block size
that is not aligned on block size boundary, io_overlaps_block returns
true, process_discard treats this discard as a full block discard,
deletes the full block - the result is that some data that shouldn't be
discarded are discarded.

This patch sets the variable "ti->split_discard_requests", so that
device mapper core splits discard requests on a block boundary.

Consequently, a discard request that spans multiple blocks is never sent
to dm-thin. The patch also removes some code in process_discard that
deals with discards that span multiple blocks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: linux-3.5-rc6-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.5-rc6-fast.orig/drivers/md/dm-thin.c	2012-07-16 18:46:18.000000000 +0200
+++ linux-3.5-rc6-fast/drivers/md/dm-thin.c	2012-07-16 20:07:19.000000000 +0200
@@ -1246,17 +1246,10 @@ static void process_discard(struct thin_
 			}
 		} else {
 			/*
-			 * This path is hit if people are ignoring
-			 * limits->discard_granularity.  It ignores any
-			 * part of the discard that is in a subsequent
-			 * block.
+			 * The dm makes sure that the discard doesn't span
+			 * a block boundary. So we submit the discard
+			 * to the appropriate block.
 			 */
-			sector_t offset = pool->sectors_per_block_shift >= 0 ?
-			      bio->bi_sector & (pool->sectors_per_block - 1) :
-			      bio->bi_sector - block * pool->sectors_per_block;
-			unsigned remaining = (pool->sectors_per_block - offset) << SECTOR_SHIFT;
-			bio->bi_size = min(bio->bi_size, remaining);
-
 			cell_release_singleton(cell, bio);
 			cell_release_singleton(cell2, bio);
 			remap_and_issue(tc, bio, lookup_result.block);
@@ -2506,7 +2499,8 @@ static void set_discard_limits(struct po
 
 	/*
 	 * This is just a hint, and not enforced.  We have to cope with
-	 * bios that overlap 2 blocks.
+	 * bios cover a block partially.  A discard that spans a block boundary
+	 * is not sent to this target.
 	 */
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
@@ -2648,6 +2642,8 @@ static int thin_ctr(struct dm_target *ti
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = 1;
 		ti->num_discard_requests = 1;
+		/* Discard requests must be split on a chunk boundary */
+		ti->split_discard_requests = 1;
 	}
 
 	dm_put(pool_md);
