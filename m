From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 01/13] dm thin: tidy up the cell_release functions
Date: Wed, 29 Feb 2012 09:50:05 -0500
Message-ID: <1330527017-28618-2-git-send-email-snitzer@redhat.com>
References: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330527017-28618-1-git-send-email-snitzer@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Clarify what is expected during each cell release by introducing
variants of __cell_release.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   52 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 920304e..f796afb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -306,22 +306,45 @@ static void cell_release(struct cell *cell, struct bio_list *bios)
  * bio may be in the cell.  This function releases the cell, and also does
  * a sanity check.
  */
+static void __cell_release_singleton(struct cell *cell, struct bio *bio)
+{
+	hlist_del(&cell->list);
+	BUG_ON(cell->holder != bio);
+	BUG_ON(!bio_list_empty(&cell->bios));
+}
+
 static void cell_release_singleton(struct cell *cell, struct bio *bio)
 {
-	struct bio_prison *prison = cell->prison;
-	struct bio_list bios;
-	struct bio *b;
 	unsigned long flags;
-
-	bio_list_init(&bios);
+	struct bio_prison *prison = cell->prison;
 
 	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release(cell, &bios);
+	__cell_release_singleton(cell, bio);
 	spin_unlock_irqrestore(&prison->lock, flags);
+}
+
+/*
+ * Sometimes we don't want the holder, just the additional bios.
+ */
+static void __cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	struct bio_prison *prison = cell->prison;
 
-	b = bio_list_pop(&bios);
-	BUG_ON(b != bio);
-	BUG_ON(!bio_list_empty(&bios));
+	hlist_del(&cell->list);
+	if (inmates)
+		bio_list_merge(inmates, &cell->bios);
+
+	mempool_free(cell, prison->cell_pool);
+}
+
+static void cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	unsigned long flags;
+	struct bio_prison *prison = cell->prison;
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release_no_holder(cell, inmates);
+	spin_unlock_irqrestore(&prison->lock, flags);
 }
 
 static void cell_error(struct cell *cell)
@@ -803,21 +826,16 @@ static void cell_defer(struct thin_c *tc, struct cell *cell,
  * Same as cell_defer above, except it omits one particular detainee,
  * a write bio that covers the block and has already been processed.
  */
-static void cell_defer_except(struct thin_c *tc, struct cell *cell,
-			      struct bio *exception)
+static void cell_defer_except(struct thin_c *tc, struct cell *cell)
 {
 	struct bio_list bios;
-	struct bio *bio;
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
 	bio_list_init(&bios);
-	cell_release(cell, &bios);
 
 	spin_lock_irqsave(&pool->lock, flags);
-	while ((bio = bio_list_pop(&bios)))
-		if (bio != exception)
-			bio_list_add(&pool->deferred_bios, bio);
+	cell_release_no_holder(cell, &pool->deferred_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	wake_worker(pool);
@@ -857,7 +875,7 @@ static void process_prepared_mapping(struct new_mapping *m)
 	 * the bios in the cell.
 	 */
 	if (bio) {
-		cell_defer_except(tc, m->cell, bio);
+		cell_defer_except(tc, m->cell);
 		bio_endio(bio, 0);
 	} else
 		cell_defer(tc, m->cell, m->data_block);
-- 
1.7.1
