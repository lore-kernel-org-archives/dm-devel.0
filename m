From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 4/4] dm thin: cleanup some dead code and other
	fluff
Date: Thu,  6 Dec 2012 14:07:06 -0500
Message-ID: <1354820826-31472-1-git-send-email-snitzer@redhat.com>
References: <1354805027-29118-4-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1354805027-29118-4-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Remove dm_cell_release_singleton now that it is unused.
Remove unused @data_block parameter from cell_defer.
Remove unused 'bios' variable in cell_defer_no_holder.
Change thin_bio_map to use many returns rather than setting a variable.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bio-prison.c |   25 -------------------------
 drivers/md/dm-bio-prison.h |    1 -
 drivers/md/dm-thin.c       |   32 +++++++++++---------------------
 3 files changed, 11 insertions(+), 47 deletions(-)

[v3: added missing explicit return in thin_bio_map cleanup]

Index: linux/drivers/md/dm-bio-prison.c
===================================================================
--- linux.orig/drivers/md/dm-bio-prison.c
+++ linux/drivers/md/dm-bio-prison.c
@@ -208,31 +208,6 @@ void dm_cell_release(struct dm_bio_priso
 EXPORT_SYMBOL_GPL(dm_cell_release);
 
 /*
- * There are a couple of places where we put a bio into a cell briefly
- * before taking it out again.  In these situations we know that no other
- * bio may be in the cell.  This function releases the cell, and also does
- * a sanity check.
- */
-static void __cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio)
-{
-	BUG_ON(cell->holder != bio);
-	BUG_ON(!bio_list_empty(&cell->bios));
-
-	__cell_release(cell, NULL);
-}
-
-void dm_cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio)
-{
-	unsigned long flags;
-	struct dm_bio_prison *prison = cell->prison;
-
-	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release_singleton(cell, bio);
-	spin_unlock_irqrestore(&prison->lock, flags);
-}
-EXPORT_SYMBOL_GPL(dm_cell_release_singleton);
-
-/*
  * Sometimes we don't want the holder, just the additional bios.
  */
 static void __cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates)
Index: linux/drivers/md/dm-bio-prison.h
===================================================================
--- linux.orig/drivers/md/dm-bio-prison.h
+++ linux/drivers/md/dm-bio-prison.h
@@ -44,7 +44,6 @@ int dm_bio_detain(struct dm_bio_prison *
 		  struct bio *inmate, struct dm_bio_prison_cell **ref);
 
 void dm_cell_release(struct dm_bio_prison_cell *cell, struct bio_list *bios);
-void dm_cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio); // FIXME: bio arg not needed
 void dm_cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates);
 void dm_cell_error(struct dm_bio_prison_cell *cell);
 
Index: linux/drivers/md/dm-thin.c
===================================================================
--- linux.orig/drivers/md/dm-thin.c
+++ linux/drivers/md/dm-thin.c
@@ -510,8 +510,7 @@ static void overwrite_endio(struct bio *
 /*
  * This sends the bios in the cell back to the deferred_bios list.
  */
-static void cell_defer(struct thin_c *tc, struct dm_bio_prison_cell *cell,
-		       dm_block_t data_block)
+static void cell_defer(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
@@ -529,12 +528,9 @@ static void cell_defer(struct thin_c *tc
 static void cell_defer_no_holder(struct thin_c *tc,
 				 struct dm_bio_prison_cell *cell)
 {
-	struct bio_list bios;
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
-	bio_list_init(&bios);
-
 	spin_lock_irqsave(&pool->lock, flags);
 	dm_cell_release_no_holder(cell, &pool->deferred_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -587,7 +583,7 @@ static void process_prepared_mapping(str
 		cell_defer_no_holder(tc, m->cell);
 		bio_endio(bio, 0);
 	} else
-		cell_defer(tc, m->cell, m->data_block);
+		cell_defer(tc, m->cell);
 
 out:
 	list_del(&m->list);
@@ -1453,8 +1449,7 @@ static int thin_bio_map(struct dm_target
 			 * of doing so.  Just error it.
 			 */
 			bio_io_error(bio);
-			r = DM_MAPIO_SUBMITTED;
-			break;
+			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
 
@@ -1464,21 +1459,16 @@ static int thin_bio_map(struct dm_target
 		 * provide the hint to load the metadata into cache.
 		 */
 		thin_defer_bio(tc, bio);
-		r = DM_MAPIO_SUBMITTED;
-		break;
-
-	default:
-		/*
-		 * Must always call bio_io_error on failure.
-		 * dm_thin_find_block can fail with -EINVAL if the
-		 * pool is switched to fail-io mode.
-		 */
-		bio_io_error(bio);
-		r = DM_MAPIO_SUBMITTED;
-		break;
+		return DM_MAPIO_SUBMITTED;
 	}
 
-	return r;
+	/*
+	 * Must always call bio_io_error on failure.
+	 * dm_thin_find_block can fail with -EINVAL if the
+	 * pool is switched to fail-io mode.
+	 */
+	bio_io_error(bio);
+	return DM_MAPIO_SUBMITTED;
 }
 
 static int pool_is_congested(struct dm_target_callbacks *cb, int bdi_bits)
