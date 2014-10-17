From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 07/17] dm thin: throttle incoming IO
Date: Fri, 17 Oct 2014 02:06:57 -0400
Message-ID: <1413526027-21630-8-git-send-email-snitzer@redhat.com>
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

Throttle IO based on the time it's taking the worker to do one loop.
There were reports of hung task timeouts occuring and it was observed
that the excessively long avgqu-sz (as reported by iostat) was
contributing to these hung tasks.

Throttling definitely helps dm-thinp perform better under heavy IO load
(without being detremental by being overzealous).  It reduces avgqu-sz
drastically, e.g.: from 60K to ~6K, and even as low as 150 once metadata
is cached by bufio, when dirty_ratio=5, dirty_background_ratio=2.  And
avgqu-sz stays at or below 30K even with dirty_ratio=20,
dirty_background_ratio=10.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1d25b51..d451ce5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -126,6 +126,53 @@ static void build_virtual_key(struct dm_thin_device *td, dm_block_t b,
 
 /*----------------------------------------------------------------*/
 
+#define THROTTLE_THRESHOLD (1 * HZ)
+
+struct throttle {
+	struct rw_semaphore lock;
+	unsigned long threshold;
+	bool throttle_applied;
+};
+
+static void throttle_init(struct throttle *t)
+{
+	init_rwsem(&t->lock);
+	t->throttle_applied = false;
+}
+
+static void throttle_work_start(struct throttle *t)
+{
+	t->threshold = jiffies + THROTTLE_THRESHOLD;
+}
+
+static void throttle_work_update(struct throttle *t)
+{
+	if (!t->throttle_applied && jiffies > t->threshold) {
+		down_write(&t->lock);
+		t->throttle_applied = true;
+	}
+}
+
+static void throttle_work_complete(struct throttle *t)
+{
+	if (t->throttle_applied) {
+		t->throttle_applied = false;
+		up_write(&t->lock);
+	}
+}
+
+static void throttle_lock(struct throttle *t)
+{
+	down_read(&t->lock);
+}
+
+static void throttle_unlock(struct throttle *t)
+{
+	up_read(&t->lock);
+}
+
+/*----------------------------------------------------------------*/
+
 /*
  * A pool device ties together a metadata device and a data device.  It
  * also provides the interface for creating and destroying internal
@@ -175,6 +222,7 @@ struct pool {
 	struct dm_kcopyd_client *copier;
 
 	struct workqueue_struct *wq;
+	struct throttle throttle;
 	struct work_struct worker;
 	struct delayed_work waker;
 	struct delayed_work no_space_timeout;
@@ -1570,6 +1618,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			pool->process_bio(tc, bio);
 
 		if ((count++ & 127) == 0) {
+			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
 	}
@@ -1657,10 +1706,15 @@ static void do_worker(struct work_struct *ws)
 {
 	struct pool *pool = container_of(ws, struct pool, worker);
 
+	throttle_work_start(&pool->throttle);
 	dm_pool_issue_prefetches(pool->pmd);
+	throttle_work_update(&pool->throttle);
 	process_prepared(pool, &pool->prepared_mappings, &pool->process_prepared_mapping);
+	throttle_work_update(&pool->throttle);
 	process_prepared(pool, &pool->prepared_discards, &pool->process_prepared_discard);
+	throttle_work_update(&pool->throttle);
 	process_deferred_bios(pool);
+	throttle_work_complete(&pool->throttle);
 }
 
 /*
@@ -1893,9 +1947,11 @@ static void thin_defer_bio(struct thin_c *tc, struct bio *bio)
 	unsigned long flags;
 	struct pool *pool = tc->pool;
 
+	throttle_lock(&pool->throttle);
 	spin_lock_irqsave(&tc->lock, flags);
 	bio_list_add(&tc->deferred_bio_list, bio);
 	spin_unlock_irqrestore(&tc->lock, flags);
+	throttle_unlock(&pool->throttle);
 
 	wake_worker(pool);
 }
@@ -2212,6 +2268,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		goto bad_wq;
 	}
 
+	throttle_init(&pool->throttle);
 	INIT_WORK(&pool->worker, do_worker);
 	INIT_DELAYED_WORK(&pool->waker, do_waker);
 	INIT_DELAYED_WORK(&pool->no_space_timeout, do_no_space_timeout);
-- 
1.9.3
