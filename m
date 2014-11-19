From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v3 4/4] dm thin: suspend/resume active
	thin devices when reloading thin-pool
Date: Wed, 19 Nov 2014 11:34:47 -0500
Message-ID: <1416414887-23550-4-git-send-email-snitzer@redhat.com>
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

Before this change it was expected that userspace would first suspend
all active thin devices, reload/resize the thin-pool target, then resume
all active thin devices.  Now the thin-pool suspend/resume will trigger
the suspend/resume of all active thins via appropriate calls to
dm_internal_suspend and dm_internal_resume.

Store the mapped_device for each thin device in struct thin_c to make
these calls possible.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f1b53e3..e9e9584 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -292,6 +292,8 @@ struct thin_c {
 
 	struct pool *pool;
 	struct dm_thin_device *td;
+	struct mapped_device *thin_md;
+
 	bool requeue_mode:1;
 	spinlock_t lock;
 	struct list_head deferred_cells;
@@ -3113,19 +3115,48 @@ static int pool_preresume(struct dm_target *ti)
 	return 0;
 }
 
+static void pool_suspend_active_thins(struct pool *pool)
+{
+	struct thin_c *tc;
+
+	/* Suspend all active thin devices */
+	tc = get_first_thin(pool);
+	while (tc) {
+		dm_internal_suspend_noflush(tc->thin_md);
+		tc = get_next_thin(pool, tc);
+	}
+}
+
+static void pool_resume_active_thins(struct pool *pool)
+{
+	struct thin_c *tc;
+
+	/* Resume all active thin devices */
+	tc = get_first_thin(pool);
+	while (tc) {
+		dm_internal_resume(tc->thin_md);
+		tc = get_next_thin(pool, tc);
+	}
+}
+
 static void pool_resume(struct dm_target *ti)
 {
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
 	unsigned long flags;
 
+	/*
+	 * Must requeue active_thins' bios and then resume
+	 * active_thins _before_ clearing 'suspend' flag.
+	 */
+	requeue_bios(pool);
+	pool_resume_active_thins(pool);
+
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->low_water_triggered = false;
 	pool->suspended = false;
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	requeue_bios(pool);
-
 	do_waker(&pool->waker.work);
 }
 
@@ -3138,6 +3169,8 @@ static void pool_presuspend(struct dm_target *ti)
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->suspended = true;
 	spin_unlock_irqrestore(&pool->lock, flags);
+
+	pool_suspend_active_thins(pool);
 }
 
 static void pool_presuspend_undo(struct dm_target *ti)
@@ -3146,6 +3179,8 @@ static void pool_presuspend_undo(struct dm_target *ti)
 	struct pool *pool = pt->pool;
 	unsigned long flags;
 
+	pool_resume_active_thins(pool);
+
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->suspended = false;
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -3703,6 +3738,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		r = -ENOMEM;
 		goto out_unlock;
 	}
+	tc->thin_md = dm_table_get_md(ti->table);
 	spin_lock_init(&tc->lock);
 	INIT_LIST_HEAD(&tc->deferred_cells);
 	bio_list_init(&tc->deferred_bio_list);
-- 
1.9.3
