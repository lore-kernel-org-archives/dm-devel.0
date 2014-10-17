From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v2 07/17] dm thin: throttle incoming IO
Date: Fri, 17 Oct 2014 14:37:09 -0400
Message-ID: <1413571039-31986-7-git-send-email-snitzer@redhat.com>
References: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413571039-31986-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141017183119.GA31854@redhat.com>
References: <20141017183119.GA31854@redhat.com>
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
 drivers/md/dm-thin.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1d25b51..6057441 100644
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
@@ -1900,6 +1954,15 @@ static void thin_defer_bio(struct thin_c *tc, struct bio *bio)
 	wake_worker(pool);
 }
 
+static void thin_defer_bio_with_throttle(struct thin_c *tc, struct bio *bio)
+{
+	struct pool *pool = tc->pool;
+
+	throttle_lock(&pool->throttle);
+	thin_defer_bio(tc, bio);
+	throttle_unlock(&pool->throttle);
+}
+
 static void thin_hook_bio(struct thin_c *tc, struct bio *bio)
 {
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
@@ -1937,7 +2000,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	}
 
 	if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)) {
-		thin_defer_bio(tc, bio);
+		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
 
@@ -2212,6 +2275,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		goto bad_wq;
 	}
 
+	throttle_init(&pool->throttle);
 	INIT_WORK(&pool->worker, do_worker);
 	INIT_DELAYED_WORK(&pool->waker, do_waker);
 	INIT_DELAYED_WORK(&pool->no_space_timeout, do_no_space_timeout);
-- 
1.8.3.1
