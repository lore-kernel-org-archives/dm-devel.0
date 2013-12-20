From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 16/20] dm thin: eliminate the
	no_free_space flag
Date: Fri, 20 Dec 2013 18:37:29 -0500
Message-ID: <1387582653-13647-17-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

The pool's error_if_no_space flag can easily serve the same purpose that
no_free_space did, namely: control whether handle_unserviceable_bio()
will error a bio or requeue it.

This is cleaner since error_if_no_space is established when the pool's
features are processed during table load.  So it avoids managing the
no_free_space flag by taking the pool's spinlock.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f16c3e4..bfae790 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -165,7 +165,6 @@ struct pool {
 
 	struct pool_features pf;
 	bool low_water_triggered:1;	/* A dm event has been sent */
-	bool no_free_space:1;		/* bios will be requeued if set */
 
 	struct dm_bio_prison *prison;
 	struct dm_kcopyd_client *copier;
@@ -995,10 +994,10 @@ static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
 	 */
 	WARN_ON_ONCE(get_pool_mode(pool) != PM_READ_ONLY);
 
-	if (pool->no_free_space)
-		retry_on_resume(bio);
-	else
+	if (pool->pf.error_if_no_space)
 		bio_io_error(bio);
+	else
+		retry_on_resume(bio);
 }
 
 static void retry_bios_on_resume(struct pool *pool, struct dm_bio_prison_cell *cell)
@@ -1441,18 +1440,6 @@ static void set_pool_mode(struct pool *pool, enum pool_mode mode)
 	}
 }
 
-static void set_no_free_space(struct pool *pool)
-{
-	unsigned long flags;
-
-	if (pool->pf.error_if_no_space)
-		return;
-
-	spin_lock_irqsave(&pool->lock, flags);
-	pool->no_free_space = true;
-	spin_unlock_irqrestore(&pool->lock, flags);
-}
-
 /*
  * Rather than calling set_pool_mode directly, use these which describe the
  * reason for mode degradation.
@@ -1461,7 +1448,6 @@ static void out_of_data_space(struct pool *pool)
 {
 	DMERR_LIMIT("%s: no free data space available.",
 		    dm_device_name(pool->pool_md));
-	set_no_free_space(pool);
 	set_pool_mode(pool, PM_READ_ONLY);
 }
 
@@ -1474,11 +1460,9 @@ static void metadata_operation_failed(struct pool *pool, const char *op, int r)
 
 	if (r == -ENOSPC &&
 	    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
-	    !free_blocks) {
+	    !free_blocks)
 		DMERR_LIMIT("%s: no free metadata space available.",
 			    dm_device_name(pool->pool_md));
-		set_no_free_space(pool);
-	}
 
 	set_pool_mode(pool, PM_READ_ONLY);
 }
@@ -1823,7 +1807,6 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	INIT_LIST_HEAD(&pool->prepared_mappings);
 	INIT_LIST_HEAD(&pool->prepared_discards);
 	pool->low_water_triggered = false;
-	pool->no_free_space = false;
 	bio_list_init(&pool->retry_on_resume_list);
 
 	pool->shared_read_ds = dm_deferred_set_create();
@@ -2350,7 +2333,6 @@ static void pool_resume(struct dm_target *ti)
 
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->low_water_triggered = false;
-	pool->no_free_space = false;
 	__requeue_bios(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-- 
1.8.1.4
