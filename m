From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 15/17] dm thin: remap the bios in a cell
	immediately
Date: Fri, 17 Oct 2014 02:07:05 -0400
Message-ID: <1413526027-21630-16-git-send-email-snitzer@redhat.com>
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

This use of direct submission in process_prepared_mapping() reduces
latency for submitting bios in a cell by avoiding adding those bios to
the deferred list and waiting for the next iteration of the worker.

But this direct submission exposes the potential for a race between
releasing a cell and incrementing deferred set.  Fix this by introducing
dm_cell_visit_release() and refactoring inc_remap_and_issue_cell()
accordingly.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bio-prison.c | 14 ++++++++
 drivers/md/dm-bio-prison.h |  8 +++++
 drivers/md/dm-thin.c       | 85 ++++++++++++++++++++++++++++++----------------
 3 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
index 90a5662..bbe22a5 100644
--- a/drivers/md/dm-bio-prison.c
+++ b/drivers/md/dm-bio-prison.c
@@ -241,6 +241,20 @@ void dm_cell_error(struct dm_bio_prison *prison,
 }
 EXPORT_SYMBOL_GPL(dm_cell_error);
 
+void dm_cell_visit_release(struct dm_bio_prison *prison,
+			   void (*visit_fn)(void *, struct dm_bio_prison_cell *),
+			   void *context,
+			   struct dm_bio_prison_cell *cell)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&prison->lock, flags);
+	visit_fn(context, cell);
+	rb_erase(&cell->node, &prison->cells);
+	spin_unlock_irqrestore(&prison->lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_cell_visit_release);
+
 /*----------------------------------------------------------------*/
 
 #define DEFERRED_SET_SIZE 64
diff --git a/drivers/md/dm-bio-prison.h b/drivers/md/dm-bio-prison.h
index c0cddb1..b039886 100644
--- a/drivers/md/dm-bio-prison.h
+++ b/drivers/md/dm-bio-prison.h
@@ -89,6 +89,14 @@ void dm_cell_release_no_holder(struct dm_bio_prison *prison,
 void dm_cell_error(struct dm_bio_prison *prison,
 		   struct dm_bio_prison_cell *cell, int error);
 
+/*
+ * Visits the cell and then releases.  Guarantees no new inmates are
+ * inserted between the visit and release.
+ */
+void dm_cell_visit_release(struct dm_bio_prison *prison,
+			   void (*visit_fn)(void *, struct dm_bio_prison_cell *),
+			   void *context, struct dm_bio_prison_cell *cell);
+
 /*----------------------------------------------------------------*/
 
 /*
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 507e674..3e1f40d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -343,6 +343,15 @@ static void cell_release(struct pool *pool,
 	dm_bio_prison_free_cell(pool->prison, cell);
 }
 
+static void cell_visit_release(struct pool *pool,
+			       void (*fn)(void *, struct dm_bio_prison_cell *),
+			       void *context,
+			       struct dm_bio_prison_cell *cell)
+{
+	dm_cell_visit_release(pool->prison, fn, context, cell);
+	dm_bio_prison_free_cell(pool->prison, cell);
+}
+
 static void cell_release_no_holder(struct pool *pool,
 				   struct dm_bio_prison_cell *cell,
 				   struct bio_list *bios)
@@ -674,55 +683,70 @@ static void overwrite_endio(struct bio *bio, int err)
  */
 
 /*
- * This sends the bios in the cell back to the deferred_bios list.
+ * This sends the bios in the cell, except the original holder, back
+ * to the deferred_bios list.
  */
-static void cell_defer(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tc->lock, flags);
-	cell_release(pool, cell, &tc->deferred_bio_list);
+	cell_release_no_holder(pool, cell, &tc->deferred_bio_list);
 	spin_unlock_irqrestore(&tc->lock, flags);
 
 	wake_worker(pool);
 }
 
-/*
- * Same as cell_defer above, except it omits the original holder of the cell.
- */
-static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *cell)
+static void thin_defer_bio(struct thin_c *tc, struct bio *bio);
+
+struct remap_info {
+	struct thin_c *tc;
+	struct bio_list bios;
+};
+
+static void __inc_remap_and_issue_cell(void *context,
+				       struct dm_bio_prison_cell *cell)
 {
-	struct pool *pool = tc->pool;
-	unsigned long flags;
+	struct remap_info *info = context;
+	struct bio *bio;
 
-	spin_lock_irqsave(&tc->lock, flags);
-	cell_release_no_holder(pool, cell, &tc->deferred_bio_list);
-	spin_unlock_irqrestore(&tc->lock, flags);
+	while ((bio = bio_list_pop(&cell->bios))) {
+		if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA))
+			thin_defer_bio(info->tc, bio);
+		else {
+			inc_all_io_entry(info->tc->pool, bio);
 
-	wake_worker(pool);
+			/*
+			 * We can't issue the bios with the bio prison lock
+			 * held, so we add them to a list to issue on
+			 * return from this function.
+			 */
+			bio_list_add(&info->bios, bio);
+		}
+	}
 }
 
-static void thin_defer_bio(struct thin_c *tc, struct bio *bio);
-
 static void inc_remap_and_issue_cell(struct thin_c *tc,
 				     struct dm_bio_prison_cell *cell,
 				     dm_block_t block)
 {
 	struct bio *bio;
-	struct bio_list bios;
+	struct remap_info info;
 
-	bio_list_init(&bios);
-	cell_release_no_holder(tc->pool, cell, &bios);
+	info.tc = tc;
+	bio_list_init(&info.bios);
 
-	while ((bio = bio_list_pop(&bios))) {
-		if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA))
-			thin_defer_bio(tc, bio);
-		else {
-			inc_all_io_entry(tc->pool, bio);
-			remap_and_issue(tc, bio, block);
-		}
-	}
+	/*
+	 * We have to be careful to inc any bios we're about to issue
+	 * before the cell is released, and avoid a race with new bios
+	 * being added to the cell.
+	 */
+	cell_visit_release(tc->pool, __inc_remap_and_issue_cell,
+			   &info, cell);
+
+	while ((bio = bio_list_pop(&info.bios)))
+		remap_and_issue(info.tc, bio, block);
 }
 
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
@@ -773,10 +797,13 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 * the bios in the cell.
 	 */
 	if (bio) {
-		cell_defer_no_holder(tc, m->cell);
+		inc_remap_and_issue_cell(tc, m->cell, m->data_block);
 		bio_endio(bio, 0);
-	} else
-		cell_defer(tc, m->cell);
+	} else {
+		inc_all_io_entry(tc->pool, m->cell->holder);
+		remap_and_issue(tc, m->cell->holder, m->data_block);
+		inc_remap_and_issue_cell(tc, m->cell, m->data_block);
+	}
 
 out:
 	list_del(&m->list);
-- 
1.9.3
