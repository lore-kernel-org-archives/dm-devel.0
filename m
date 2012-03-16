From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 12/14] dm_thin: commit metadata every second
Date: Fri, 16 Mar 2012 15:22:35 +0000
Message-ID: <1331911358-8848-12-git-send-email-ejt@redhat.com>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1331911358-8848-1-git-send-email-ejt@redhat.com>
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

Enhancement.

Released blocks don't become available until after the next commit
(for crash resilience).  Prior to this patch commits were only
triggered by a message to the target or a REQ_{FLUSH,FUA} bio.  This
allowed far too big a position to build up.

The interval is hard-coded to 1 second.  This is a sensible setting.
I'm not making this user configurable, since there isn't much to be
gained by tweaking this - and a lot lost by setting it far too high.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index a1b274b..a3a66af 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -23,6 +23,7 @@
 #define DEFERRED_SET_SIZE 64
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024
+#define COMMIT_PERIOD HZ
 
 /*
  * The block size of the device holding pool data must be
@@ -528,8 +529,10 @@ struct pool {
 
 	struct workqueue_struct *wq;
 	struct work_struct worker;
+	struct delayed_work waker;
 
 	unsigned ref_count;
+	unsigned long last_commit_jiffies;
 
 	spinlock_t lock;
 	struct bio_list deferred_bios;
@@ -1411,6 +1414,12 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
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
@@ -1458,7 +1467,7 @@ static void process_deferred_bios(struct pool *pool)
 	bio_list_init(&pool->deferred_flush_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (bio_list_empty(&bios))
+	if (bio_list_empty(&bios) && !need_commit_due_to_time(pool))
 		return;
 
 	r = dm_pool_commit_metadata(pool->pmd);
@@ -1469,6 +1478,7 @@ static void process_deferred_bios(struct pool *pool)
 			bio_io_error(bio);
 		return;
 	}
+	pool->last_commit_jiffies = jiffies;
 
 	while ((bio = bio_list_pop(&bios)))
 		generic_make_request(bio);
@@ -1483,6 +1493,17 @@ static void do_worker(struct work_struct *ws)
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
@@ -1709,6 +1730,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	}
 
 	INIT_WORK(&pool->worker, do_worker);
+	INIT_DELAYED_WORK(&pool->waker, do_waker);
 	spin_lock_init(&pool->lock);
 	bio_list_init(&pool->deferred_bios);
 	bio_list_init(&pool->deferred_flush_bios);
@@ -1737,6 +1759,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		goto bad_endio_hook_pool;
 	}
 	pool->ref_count = 1;
+	pool->last_commit_jiffies = jiffies;
 	pool->pool_md = pool_md;
 	pool->md_dev = metadata_dev;
 	__pool_table_insert(pool);
@@ -2072,7 +2095,7 @@ static void pool_resume(struct dm_target *ti)
 	__requeue_bios(pool);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	wake_worker(pool);
+	do_waker(&pool->waker.work);
 }
 
 static void pool_postsuspend(struct dm_target *ti)
@@ -2081,6 +2104,7 @@ static void pool_postsuspend(struct dm_target *ti)
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
 
+	cancel_delayed_work(&pool->waker);
 	flush_workqueue(pool->wq);
 
 	r = dm_pool_commit_metadata(pool->pmd);
-- 
1.7.9.1
