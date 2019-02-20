From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 9/9] dm: remove unused _rq_tio_cache and
	_rq_cache
Date: Wed, 20 Feb 2019 16:44:36 -0500
Message-ID: <20190220214436.38476-10-snitzer@redhat.com>
References: <20190220214436.38476-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190220214436.38476-1-snitzer@redhat.com>
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

Also move dm_rq_target_io structure definition from dm-rq.h to dm-rq.c

Fixes: 6a23e05c2fe3c6 ("dm: remove legacy request-based IO path")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-rq.c | 16 ++++++++++++++++
 drivers/md/dm-rq.h | 16 ----------------
 drivers/md/dm.c    | 22 ++--------------------
 3 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a20531e5f3b4..9428cd951e3b 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -12,6 +12,22 @@
 
 #define DM_MSG_PREFIX "core-rq"
 
+/*
+ * One of these is allocated per request.
+ */
+struct dm_rq_target_io {
+	struct mapped_device *md;
+	struct dm_target *ti;
+	struct request *orig, *clone;
+	struct kthread_work work;
+	blk_status_t error;
+	union map_info info;
+	struct dm_stats_aux stats_aux;
+	unsigned long duration_jiffies;
+	unsigned n_sectors;
+	unsigned completed;
+};
+
 #define DM_MQ_NR_HW_QUEUES 1
 #define DM_MQ_QUEUE_DEPTH 2048
 static unsigned dm_mq_nr_hw_queues = DM_MQ_NR_HW_QUEUES;
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index b39245545229..1eea0da641db 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -16,22 +16,6 @@
 
 struct mapped_device;
 
-/*
- * One of these is allocated per request.
- */
-struct dm_rq_target_io {
-	struct mapped_device *md;
-	struct dm_target *ti;
-	struct request *orig, *clone;
-	struct kthread_work work;
-	blk_status_t error;
-	union map_info info;
-	struct dm_stats_aux stats_aux;
-	unsigned long duration_jiffies;
-	unsigned n_sectors;
-	unsigned completed;
-};
-
 /*
  * For request-based dm - the bio clones we allocate are embedded in these
  * structs.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0943913bceca..a58f35d31fd0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -188,9 +188,6 @@ struct table_device {
 	struct dm_dev dm_dev;
 };
 
-static struct kmem_cache *_rq_tio_cache;
-static struct kmem_cache *_rq_cache;
-
 /*
  * Bio-based DM's mempools' reserved IOs set by the user.
  */
@@ -252,20 +249,11 @@ static unsigned dm_get_numa_node(void)
 
 static int __init local_init(void)
 {
-	int r = -ENOMEM;
-
-	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
-	if (!_rq_tio_cache)
-		return r;
-
-	_rq_cache = kmem_cache_create("dm_old_clone_request", sizeof(struct request),
-				      __alignof__(struct request), 0, NULL);
-	if (!_rq_cache)
-		goto out_free_rq_tio_cache;
+	int r;
 
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_rq_cache;
+		return r;
 
 	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
 	if (!deferred_remove_workqueue) {
@@ -287,10 +275,6 @@ static int __init local_init(void)
 	destroy_workqueue(deferred_remove_workqueue);
 out_uevent_exit:
 	dm_uevent_exit();
-out_free_rq_cache:
-	kmem_cache_destroy(_rq_cache);
-out_free_rq_tio_cache:
-	kmem_cache_destroy(_rq_tio_cache);
 
 	return r;
 }
@@ -300,8 +284,6 @@ static void local_exit(void)
 	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
-	kmem_cache_destroy(_rq_cache);
-	kmem_cache_destroy(_rq_tio_cache);
 	unregister_blkdev(_major, _name);
 	dm_uevent_exit();
 
-- 
2.15.0
