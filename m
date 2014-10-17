From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 17/17] dm thin: sort the deferred
	cells
Date: Fri, 17 Oct 2014 14:37:19 -0400
Message-ID: <1413571039-31986-17-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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

Sort the cells in logical block order before processing each cell in
process_thin_deferred_cells().  This significantly improves the ondisk
layout on rotational storage, whereby improving read performance.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 88 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 0a202f7..cd63180 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 #include <linux/rbtree.h>
 
 #define	DM_MSG_PREFIX	"thin"
@@ -205,6 +206,8 @@ typedef void (*process_bio_fn)(struct thin_c *tc, struct bio *bio);
 typedef void (*process_cell_fn)(struct thin_c *tc, struct dm_bio_prison_cell *cell);
 typedef void (*process_mapping_fn)(struct dm_thin_new_mapping *m);
 
+#define CELL_SORT_ARRAY_SIZE 8192
+
 struct pool {
 	struct list_head list;
 	struct dm_target *ti;	/* Only set if a pool target is bound */
@@ -252,6 +255,8 @@ struct pool {
 
 	process_mapping_fn process_prepared_mapping;
 	process_mapping_fn process_prepared_discard;
+
+	struct dm_bio_prison_cell *cell_sort_array[CELL_SORT_ARRAY_SIZE];
 };
 
 static enum pool_mode get_pool_mode(struct pool *pool);
@@ -1767,12 +1772,48 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 	blk_finish_plug(&plug);
 }
 
+static int cmp_cells(const void *lhs, const void *rhs)
+{
+	struct dm_bio_prison_cell *lhs_cell = *((struct dm_bio_prison_cell **) lhs);
+	struct dm_bio_prison_cell *rhs_cell = *((struct dm_bio_prison_cell **) rhs);
+
+	BUG_ON(!lhs_cell->holder);
+	BUG_ON(!rhs_cell->holder);
+
+	if (lhs_cell->holder->bi_iter.bi_sector < rhs_cell->holder->bi_iter.bi_sector)
+		return -1;
+
+	if (lhs_cell->holder->bi_iter.bi_sector > rhs_cell->holder->bi_iter.bi_sector)
+		return 1;
+
+	return 0;
+}
+
+static unsigned sort_cells(struct pool *pool, struct list_head *cells)
+{
+	unsigned count = 0;
+	struct dm_bio_prison_cell *cell, *tmp;
+
+	list_for_each_entry_safe(cell, tmp, cells, user_list) {
+		if (count >= CELL_SORT_ARRAY_SIZE)
+			break;
+
+		pool->cell_sort_array[count++] = cell;
+		list_del(&cell->user_list);
+	}
+
+	sort(pool->cell_sort_array, count, sizeof(cell), cmp_cells, NULL);
+
+	return count;
+}
+
 static void process_thin_deferred_cells(struct thin_c *tc)
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 	struct list_head cells;
-	struct dm_bio_prison_cell *cell, *tmp;
+	struct dm_bio_prison_cell *cell;
+	unsigned i, j, count;
 
 	// FIXME: push down into per cell processing
 	if (tc->requeue_mode) {
@@ -1789,27 +1830,34 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 	if (list_empty(&cells))
 		return;
 
-	list_for_each_entry_safe(cell, tmp, &cells, user_list) {
-		BUG_ON(!cell->holder);
+	do {
+		count = sort_cells(tc->pool, &cells);
 
-		/*
-		 * If we've got no free new_mapping structs, and processing
-		 * this bio might require one, we pause until there are some
-		 * prepared mappings to process.
-		 */
-		if (ensure_next_mapping(pool)) {
-			spin_lock_irqsave(&tc->lock, flags);
-			list_add(&cell->user_list, &tc->deferred_cells);
-			list_splice(&cells, &tc->deferred_cells);
-			spin_unlock_irqrestore(&tc->lock, flags);
-			break;
-		}
+		for (i = 0; i < count; i++) {
+			cell = pool->cell_sort_array[i];
+			BUG_ON(!cell->holder);
 
-		if (cell->holder->bi_rw & REQ_DISCARD)
-			pool->process_discard_cell(tc, cell);
-		else
-			pool->process_cell(tc, cell);
-	}
+			/*
+			 * If we've got no free new_mapping structs, and processing
+			 * this bio might require one, we pause until there are some
+			 * prepared mappings to process.
+			 */
+			if (ensure_next_mapping(pool)) {
+				for (j = i; j < count; j++)
+					list_add(&pool->cell_sort_array[j]->user_list, &cells);
+
+				spin_lock_irqsave(&tc->lock, flags);
+				list_splice(&cells, &tc->deferred_cells);
+				spin_unlock_irqrestore(&tc->lock, flags);
+				return;
+			}
+
+			if (cell->holder->bi_rw & REQ_DISCARD)
+				pool->process_discard_cell(tc, cell);
+			else
+				pool->process_cell(tc, cell);
+		}
+	} while (!list_empty(&cells));
 }
 
 static void thin_get(struct thin_c *tc);
-- 
1.8.3.1
