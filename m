From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 5/8] [dm-thin] Fix a race condition between
	discard bios and ordinary bios.
Date: Thu, 13 Dec 2012 20:19:13 +0000
Message-ID: <1355429956-22785-6-git-send-email-ejt@redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1355429956-22785-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

The deferred_set entries should not be incremented until the bio
prison cells are held.  Otherwise quiescing a block for discard may
end up waiting for a bio that's held in the discard bios cell.
---
 drivers/md/dm-thin.c |   59 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 504f3d6..8e47f44 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -222,10 +222,28 @@ struct thin_c {
 
 	struct pool *pool;
 	struct dm_thin_device *td;
+
+	/*
+	 * The cell structures are too big to put on the stack, so we have
+	 * a couple here for use by the main mapping function.
+	 */
+	spinlock_t lock;
+	struct dm_bio_prison_cell cell1, cell2;
 };
 
 /*----------------------------------------------------------------*/
 
+/*
+ * wake_worker() is used when new work is queued and when pool_resume is
+ * ready to continue deferred IO processing.
+ */
+static void wake_worker(struct pool *pool)
+{
+	queue_work(pool->wq, &pool->worker);
+}
+
+/*----------------------------------------------------------------*/
+
 static int bio_detain(struct pool *pool, struct dm_cell_key *key, struct bio *bio,
 		      struct dm_bio_prison_cell **result)
 {
@@ -264,6 +282,19 @@ static void cell_release_no_holder(struct pool *pool,
 	dm_bio_prison_free_cell(pool->prison, cell);
 }
 
+static void cell_defer_no_holder_no_free(struct thin_c *tc,
+					 struct dm_bio_prison_cell *cell)
+{
+	struct pool *pool = tc->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	dm_cell_release_no_holder(pool->prison, cell, &pool->deferred_bios);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	wake_worker(pool);
+}
+
 static void cell_error(struct pool *pool,
 		       struct dm_bio_prison_cell *cell)
 {
@@ -467,15 +498,6 @@ static void remap_and_issue(struct thin_c *tc, struct bio *bio,
 	issue(tc, bio);
 }
 
-/*
- * wake_worker() is used when new work is queued and when pool_resume is
- * ready to continue deferred IO processing.
- */
-static void wake_worker(struct pool *pool)
-{
-	queue_work(pool->wq, &pool->worker);
-}
-
 /*----------------------------------------------------------------*/
 
 /*
@@ -1429,8 +1451,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_thin_device *td = tc->td;
 	struct dm_thin_lookup_result result;
-	struct dm_bio_prison_cell *cell1, *cell2;
 	struct dm_cell_key key;
+	struct dm_bio_prison_cell *cell_result;
 
 	thin_hook_bio(tc, bio);
 
@@ -1470,19 +1492,24 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			return DM_MAPIO_SUBMITTED;
 		}
 
+		spin_lock(&tc->lock);
 		build_virtual_key(tc->td, block, &key);
-		if (bio_detain(tc->pool, &key, bio, &cell1))
+		if (dm_bio_detain(tc->pool->prison, &key, bio, &tc->cell1, &cell_result)) {
+			spin_unlock(&tc->lock);
 			return DM_MAPIO_SUBMITTED;
+		}
 
 		build_data_key(tc->td, result.block, &key);
-		if (bio_detain(tc->pool, &key, bio, &cell2)) {
-			cell_defer_no_holder(tc, cell1);
+		if (dm_bio_detain(tc->pool->prison, &key, bio, &tc->cell2, &cell_result)) {
+			cell_defer_no_holder_no_free(tc, &tc->cell1);
+			spin_unlock(&tc->lock);
 			return DM_MAPIO_SUBMITTED;
 		}
 
 		inc_all_io_entry(tc->pool, bio);
-		cell_defer_no_holder(tc, cell2);
-		cell_defer_no_holder(tc, cell1);
+		cell_defer_no_holder_no_free(tc, &tc->cell2);
+		cell_defer_no_holder_no_free(tc, &tc->cell1);
+		spin_unlock(&tc->lock);
 
 		remap(tc, bio, result.block);
 		return DM_MAPIO_REMAPPED;
@@ -2638,6 +2665,8 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (r)
 		goto bad_thin_open;
 
+	spin_lock_init(&tc->lock);
+
 	ti->num_flush_requests = 1;
 	ti->flush_supported = true;
 	ti->per_bio_data_size = sizeof(struct dm_thin_endio_hook);
-- 
1.7.10.4
