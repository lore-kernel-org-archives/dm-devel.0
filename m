From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 07/11] [dm-thin] Commit every second to prevent
	too much of a position building up.
Date: Thu,  2 Feb 2012 16:39:10 +0000
Message-ID: <1328200754-13642-8-git-send-email-ejt@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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

---
 drivers/md/dm-thin.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6ef03a2..19de11a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -23,6 +23,7 @@
 #define DEFERRED_SET_SIZE 64
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024
+#define COMMIT_PERIOD HZ
 
 /*
  * The block size of the device holding pool data must be
@@ -498,8 +499,10 @@ struct pool {
 
 	struct workqueue_struct *wq;
 	struct work_struct worker;
+	struct delayed_work waker;
 
 	unsigned ref_count;
+	unsigned long last_commit_jiffies;
 
 	spinlock_t lock;
 	struct bio_list deferred_bios;
@@ -1256,6 +1259,12 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 	}
 }
 
+static int need_commit_due_to_time(struct pool *pool)
+{
+	return jiffies < pool->last_commit_jiffies ||
+	       jiffies > pool->last_commit_jiffies + COMMIT_PERIOD;
+}
+
 static void process_deferred_bios(struct pool *pool)
 {
 	unsigned long flags;
@@ -1297,7 +1306,7 @@ static void process_deferred_bios(struct pool *pool)
 	bio_list_init(&pool->deferred_flush_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (bio_list_empty(&bios))
+	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
 		return;
 
 	r = dm_pool_commit_metadata(pool->pmd);
@@ -1308,6 +1317,7 @@ static void process_deferred_bios(struct pool *pool)
 			bio_io_error(bio);
 		return;
 	}
+	pool->last_commit_jiffies = jiffies;
 
 	while ((bio = bio_list_pop(&bios))) {
 		BUG_ON(bio->bi_next);
@@ -1323,6 +1333,17 @@ static void do_worker(struct work_struct *ws)
 	process_deferred_bios(pool);
 }
 
+/*
+ * We want to commit periodically so that not too much
+ * unwritten data builds up.
+ */
+static void do_waker(struct work_struct *ws)
+{
+	struct pool *pool = container_of(to_delayed_work(ws), struct pool, waker);
+	wake_worker(pool);
+	queue_delayed_work(pool->wq, &pool->waker, COMMIT_PERIOD);
+}
+
 /*----------------------------------------------------------------*/
 
 /*
@@ -1532,6 +1553,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	}
 
 	INIT_WORK(&pool->worker, do_worker);
+	INIT_DELAYED_WORK(&pool->waker, do_waker);
 	spin_lock_init(&pool->lock);
 	bio_list_init(&pool->deferred_bios);
 	bio_list_init(&pool->deferred_flush_bios);
@@ -1558,6 +1580,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		goto bad_endio_hook_pool;
 	}
 	pool->ref_count = 1;
+	pool->last_commit_jiffies = jiffies;
 	pool->pool_md = pool_md;
 	pool->md_dev = metadata_dev;
 	__pool_table_insert(pool);
@@ -1887,7 +1910,7 @@ static void pool_resume(struct dm_target *ti)
 	__requeue_bios(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	wake_worker(pool);
+	do_waker(&pool->waker.work);
 }
 
 static void pool_postsuspend(struct dm_target *ti)
@@ -1896,6 +1919,7 @@ static void pool_postsuspend(struct dm_target *ti)
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
 
+	cancel_delayed_work(&pool->waker);
 	flush_workqueue(pool->wq);
 
 	r = dm_pool_commit_metadata(pool->pmd);
-- 
1.7.5.4
