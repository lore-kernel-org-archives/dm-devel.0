From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 12/17] dm thin: performance improvement
	to discard processing
Date: Fri, 17 Oct 2014 02:07:02 -0400
Message-ID: <1413526027-21630-13-git-send-email-snitzer@redhat.com>
References: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

When processing a discard bio, if the block is already quiesced do the
discard immediately rather than adding the mapping to a list for the
next iteration of the worker thread.

Discarding a fully provisioned 100G thin volume with 64k block size goes
from 860s to 95s with this change.

Clearly there's something wrong with the worker architecture, more
investigation needed.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b9b6afb..67a11f3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1194,7 +1194,6 @@ static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *c
 static void process_discard(struct thin_c *tc, struct bio *bio)
 {
 	int r;
-	unsigned long flags;
 	struct pool *pool = tc->pool;
 	struct dm_bio_prison_cell *cell, *cell2;
 	struct dm_cell_key key, key2;
@@ -1235,12 +1234,9 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			m->cell2 = cell2;
 			m->bio = bio;
 
-			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list)) {
-				spin_lock_irqsave(&pool->lock, flags);
-				list_add_tail(&m->list, &pool->prepared_discards);
-				spin_unlock_irqrestore(&pool->lock, flags);
-				wake_worker(pool);
-			}
+			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list))
+				pool->process_prepared_discard(m);
+
 		} else {
 			inc_all_io_entry(pool, bio);
 			cell_defer_no_holder(tc, cell);
-- 
1.9.3
