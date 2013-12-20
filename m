From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 10/20] dm thin: factor out
	check_low_water_mark and use bools
Date: Fri, 20 Dec 2013 18:37:23 -0500
Message-ID: <1387582653-13647-11-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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

From: Joe Thornber <ejt@redhat.com>

Factor check_low_water_mark() out of alloc_data_block().
Change a couple unsigned flags in the pool structure to bool.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 850e7cd..3420ebe5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -163,8 +163,8 @@ struct pool {
 	int sectors_per_block_shift;
 
 	struct pool_features pf;
-	unsigned low_water_triggered:1;	/* A dm event has been sent */
-	unsigned no_free_space:1;	/* A -ENOSPC warning has been issued */
+	bool low_water_triggered:1;	/* A dm event has been sent */
+	bool no_free_space:1;		/* A -ENOSPC warning has been issued */
 
 	struct dm_bio_prison *prison;
 	struct dm_kcopyd_client *copier;
@@ -913,6 +913,20 @@ static int commit(struct pool *pool)
 	return r;
 }
 
+static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
+{
+	unsigned long flags;
+
+	if (free_blocks <= pool->low_water_blocks && !pool->low_water_triggered) {
+		DMWARN("%s: reached low water mark for data device: sending event.",
+		       dm_device_name(pool->pool_md));
+		spin_lock_irqsave(&pool->lock, flags);
+		pool->low_water_triggered = true;
+		spin_unlock_irqrestore(&pool->lock, flags);
+		dm_table_event(pool->ti->table);
+	}
+}
+
 static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 {
 	int r;
@@ -934,14 +948,7 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 	if (r)
 		return r;
 
-	if (free_blocks <= pool->low_water_blocks && !pool->low_water_triggered) {
-		DMWARN("%s: reached low water mark for data device: sending event.",
-		       dm_device_name(pool->pool_md));
-		spin_lock_irqsave(&pool->lock, flags);
-		pool->low_water_triggered = 1;
-		spin_unlock_irqrestore(&pool->lock, flags);
-		dm_table_event(pool->ti->table);
-	}
+	check_low_water_mark(pool, free_blocks);
 
 	if (!free_blocks) {
 		/*
@@ -967,7 +974,7 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
 			DMWARN("%s: no free data space available.",
 			       dm_device_name(pool->pool_md));
 			spin_lock_irqsave(&pool->lock, flags);
-			pool->no_free_space = 1;
+			pool->no_free_space = true;
 			spin_unlock_irqrestore(&pool->lock, flags);
 			return -ENOSPC;
 		}
@@ -1784,8 +1791,8 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	bio_list_init(&pool->deferred_flush_bios);
 	INIT_LIST_HEAD(&pool->prepared_mappings);
 	INIT_LIST_HEAD(&pool->prepared_discards);
-	pool->low_water_triggered = 0;
-	pool->no_free_space = 0;
+	pool->low_water_triggered = false;
+	pool->no_free_space = false;
 	bio_list_init(&pool->retry_on_resume_list);
 
 	pool->shared_read_ds = dm_deferred_set_create();
@@ -2302,8 +2309,8 @@ static void pool_resume(struct dm_target *ti)
 	unsigned long flags;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	pool->low_water_triggered = 0;
-	pool->no_free_space = 0;
+	pool->low_water_triggered = false;
+	pool->no_free_space = false;
 	__requeue_bios(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-- 
1.8.1.4
