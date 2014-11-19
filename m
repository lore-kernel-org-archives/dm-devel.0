From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v3 2/4] dm thin: do not allow thin
	device activation while pool is suspended
Date: Wed, 19 Nov 2014 11:34:45 -0500
Message-ID: <1416414887-23550-2-git-send-email-snitzer@redhat.com>
References: <1416414887-23550-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416414887-23550-1-git-send-email-snitzer@redhat.com>
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

Otherwise IO could be issued to the pool while it is suspended.

Care was taken to properly interlock between the thin and thin-pool
targets when accessing the pool's 'suspended' flag.  The thin_ctr will
not add a new thin device to the pool's active_thins list if the pool is
susepended.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 55 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 64fd4de..f1b53e3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -224,6 +224,7 @@ struct pool {
 
 	struct pool_features pf;
 	bool low_water_triggered:1;	/* A dm event has been sent */
+	bool suspended:1;
 
 	struct dm_bio_prison *prison;
 	struct dm_kcopyd_client *copier;
@@ -2575,6 +2576,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	INIT_LIST_HEAD(&pool->prepared_discards);
 	INIT_LIST_HEAD(&pool->active_thins);
 	pool->low_water_triggered = false;
+	pool->suspended = true;
 
 	pool->shared_read_ds = dm_deferred_set_create();
 	if (!pool->shared_read_ds) {
@@ -3119,12 +3121,36 @@ static void pool_resume(struct dm_target *ti)
 
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->low_water_triggered = false;
+	pool->suspended = false;
 	spin_unlock_irqrestore(&pool->lock, flags);
+
 	requeue_bios(pool);
 
 	do_waker(&pool->waker.work);
 }
 
+static void pool_presuspend(struct dm_target *ti)
+{
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->suspended = true;
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
+static void pool_presuspend_undo(struct dm_target *ti)
+{
+	struct pool_c *pt = ti->private;
+	struct pool *pool = pt->pool;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	pool->suspended = false;
+	spin_unlock_irqrestore(&pool->lock, flags);
+}
+
 static void pool_postsuspend(struct dm_target *ti)
 {
 	struct pool_c *pt = ti->private;
@@ -3592,6 +3618,8 @@ static struct target_type pool_target = {
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
 	.map = pool_map,
+	.presuspend = pool_presuspend,
+	.presuspend_undo = pool_presuspend_undo,
 	.postsuspend = pool_postsuspend,
 	.preresume = pool_preresume,
 	.resume = pool_resume,
@@ -3721,18 +3749,18 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (get_pool_mode(tc->pool) == PM_FAIL) {
 		ti->error = "Couldn't open thin device, Pool is in fail mode";
 		r = -EINVAL;
-		goto bad_thin_open;
+		goto bad_pool;
 	}
 
 	r = dm_pool_open_thin_device(tc->pool->pmd, tc->dev_id, &tc->td);
 	if (r) {
 		ti->error = "Couldn't open thin internal device";
-		goto bad_thin_open;
+		goto bad_pool;
 	}
 
 	r = dm_set_target_max_io_len(ti, tc->pool->sectors_per_block);
 	if (r)
-		goto bad_target_max_io_len;
+		goto bad;
 
 	ti->num_flush_bios = 1;
 	ti->flush_supported = true;
@@ -3747,14 +3775,16 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		ti->split_discard_bios = true;
 	}
 
-	dm_put(pool_md);
-
 	mutex_unlock(&dm_thin_pool_table.mutex);
 
-	atomic_set(&tc->refcount, 1);
-	init_completion(&tc->can_destroy);
-
 	spin_lock_irqsave(&tc->pool->lock, flags);
+	if (tc->pool->suspended) {
+		spin_unlock_irqrestore(&tc->pool->lock, flags);
+		mutex_lock(&dm_thin_pool_table.mutex); /* reacquire for __pool_dec */
+		ti->error = "Unable to activate thin device while pool is suspended";
+		r = -EINVAL;
+		goto bad;
+	}
 	list_add_tail_rcu(&tc->list, &tc->pool->active_thins);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 	/*
@@ -3765,11 +3795,16 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 */
 	synchronize_rcu();
 
+	dm_put(pool_md);
+
+	atomic_set(&tc->refcount, 1);
+	init_completion(&tc->can_destroy);
+
 	return 0;
 
-bad_target_max_io_len:
+bad:
 	dm_pool_close_thin_device(tc->td);
-bad_thin_open:
+bad_pool:
 	__pool_dec(tc->pool);
 bad_pool_lookup:
 	dm_put(pool_md);
-- 
1.9.3
