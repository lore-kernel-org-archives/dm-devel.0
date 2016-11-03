From: tang.junhui@zte.com.cn
Subject: [PATCH] dm mpath: remove unusable kmultipathd work queue
Date: Thu, 3 Nov 2016 18:29:54 +0800
Message-ID: <1478168994-9376-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

kmultipathd work queue is used to process queued IOs for multipath
target when IOs need to retry, but now these IOs have been requeued
to block queue of DM device, hence this work queue is not useful
anymore, and this patch deletes it.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/dm-mpath.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d376dc8..8f687b9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -117,7 +117,7 @@ typedef int (*action_fn) (struct pgpath *pgpath);
 
 static struct kmem_cache *_mpio_cache;
 
-static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
+static struct workqueue_struct *kmpath_handlerd;
 static void trigger_event(struct work_struct *work);
 static void activate_path(struct work_struct *work);
 static int __pgpath_busy(struct pgpath *pgpath);
@@ -935,7 +935,6 @@ static void flush_multipath_work(struct multipath *m)
 
 	flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
-	flush_workqueue(kmultipathd);
 	flush_work(&m->trigger_event);
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -1737,13 +1736,6 @@ static int __init dm_multipath_init(void)
 		goto bad_register_target;
 	}
 
-	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
-	if (!kmultipathd) {
-		DMERR("failed to create workqueue kmpathd");
-		r = -ENOMEM;
-		goto bad_alloc_kmultipathd;
-	}
-
 	/*
 	 * A separate workqueue is used to handle the device handlers
 	 * to avoid overloading existing workqueue. Overloading the
@@ -1765,8 +1757,6 @@ static int __init dm_multipath_init(void)
 	return 0;
 
 bad_alloc_kmpath_handlerd:
-	destroy_workqueue(kmultipathd);
-bad_alloc_kmultipathd:
 	dm_unregister_target(&multipath_target);
 bad_register_target:
 	kmem_cache_destroy(_mpio_cache);
@@ -1777,7 +1767,6 @@ bad_register_target:
 static void __exit dm_multipath_exit(void)
 {
 	destroy_workqueue(kmpath_handlerd);
-	destroy_workqueue(kmultipathd);
 
 	dm_unregister_target(&multipath_target);
 	kmem_cache_destroy(_mpio_cache);
-- 
2.8.1.windows.1
