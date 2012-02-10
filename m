From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 04/12 v2] dm thin: don't use the bi_next field
	for the holder of a cell
Date: Fri, 10 Feb 2012 13:03:58 -0500
Message-ID: <1328897038-13673-1-git-send-email-snitzer@redhat.com>
References: <1328200754-13642-4-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-4-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

The holder can be passed down to lower devices which may want to use
bi_next themselves.  Also add BUG_ON check to confirm fix.

When releasing bios that have been detained in a cell, fix the order in
which the holder and other cellmates are added to the inmates list:
append holder first followed by the other cellmates.

Clarify what is expected during each cell release by introducing
variants of __cell_release.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   86 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 32 deletions(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c
+++ linux-2.6/drivers/md/dm-thin.c
@@ -124,7 +124,7 @@ struct cell {
 	struct hlist_node list;
 	struct bio_prison *prison;
 	struct cell_key key;
-	unsigned count;
+	struct bio *holder;
 	struct bio_list bios;
 };
 
@@ -220,8 +220,7 @@ static struct cell *__search_bucket(stru
  * This may block if a new cell needs allocating.  You must ensure that
  * cells will be unlocked even if the calling thread is blocked.
  *
- * Returns the number of entries in the cell prior to the new addition
- * or < 0 on failure.
+ * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
  */
 static int bio_detain(struct bio_prison *prison, struct cell_key *key,
 		      struct bio *inmate, struct cell **ref)
@@ -235,7 +234,6 @@ static int bio_detain(struct bio_prison 
 
 	spin_lock_irqsave(&prison->lock, flags);
 	cell = __search_bucket(prison->cells + hash, key);
-
 	if (!cell) {
 		/*
 		 * Allocate a new cell
@@ -249,28 +247,30 @@ static int bio_detain(struct bio_prison 
 		 * nobody else has inserted this cell in the meantime.
 		 */
 		cell = __search_bucket(prison->cells + hash, key);
-
 		if (!cell) {
 			cell = cell2;
 			cell2 = NULL;
 
 			cell->prison = prison;
 			memcpy(&cell->key, key, sizeof(cell->key));
-			cell->count = 0;
+			cell->holder = inmate;
 			bio_list_init(&cell->bios);
 			hlist_add_head(&cell->list, prison->cells + hash);
+			r = 0;
+		} else {
+			mempool_free(cell2, prison->cell_pool);
+			cell2 = NULL;
+			r = 1;
+			bio_list_add(&cell->bios, inmate);
 		}
-	}
 
-	r = cell->count++;
-	bio_list_add(&cell->bios, inmate);
+	} else {
+		r = 1;
+		bio_list_add(&cell->bios, inmate);
+	}
 	spin_unlock_irqrestore(&prison->lock, flags);
 
-	if (cell2)
-		mempool_free(cell2, prison->cell_pool);
-
 	*ref = cell;
-
 	return r;
 }
 
@@ -283,8 +283,10 @@ static void __cell_release(struct cell *
 
 	hlist_del(&cell->list);
 
-	if (inmates)
+	if (inmates) {
+		bio_list_add(inmates, cell->holder);
 		bio_list_merge(inmates, &cell->bios);
+	}
 
 	mempool_free(cell, prison->cell_pool);
 }
@@ -305,22 +307,45 @@ static void cell_release(struct cell *ce
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
 
-	b = bio_list_pop(&bios);
-	BUG_ON(b != bio);
-	BUG_ON(!bio_list_empty(&bios));
+/*
+ * Sometimes we don't want the holder, just the additional bios.
+ */
+static void __cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	struct bio_prison *prison = cell->prison;
+
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
@@ -662,8 +687,10 @@ static void remap_and_issue(struct thin_
 		spin_lock_irqsave(&pool->lock, flags);
 		bio_list_add(&pool->deferred_flush_bios, bio);
 		spin_unlock_irqrestore(&pool->lock, flags);
-	} else
+	} else {
+		BUG_ON(bio->bi_next);
 		generic_make_request(bio);
+	}
 }
 
 /*
@@ -800,21 +827,16 @@ static void cell_defer(struct thin_c *tc
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
@@ -854,7 +876,7 @@ static void process_prepared_mapping(str
 	 * the bios in the cell.
 	 */
 	if (bio) {
-		cell_defer_except(tc, m->cell, bio);
+		cell_defer_except(tc, m->cell);
 		bio_endio(bio, 0);
 	} else
 		cell_defer(tc, m->cell, m->data_block);
