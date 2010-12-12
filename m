From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] dm-snap: kill unused
	dm_snapshot->queued_bios_work and ksnapd
Date: Sun, 12 Dec 2010 20:10:51 +0100
Message-ID: <1292181055-25696-3-git-send-email-tj@kernel.org>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1292181055-25696-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

dm_snapshot->queued_bios_work isn't used anywhere.  Remove
->queued_bios[_work], the work function and ksnapd.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-snap.c |   38 --------------------------------------
 1 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 53cf79d..0f47698 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -19,7 +19,6 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
-#include <linux/workqueue.h>
 
 #include "dm-exception-store.h"
 
@@ -106,10 +105,6 @@ struct dm_snapshot {
 
 	struct dm_kcopyd_client *kcopyd_client;
 
-	/* Queue of snapshot writes for ksnapd to flush */
-	struct bio_list queued_bios;
-	struct work_struct queued_bios_work;
-
 	/* Wait for events based on state_bits */
 	unsigned long state_bits;
 
@@ -160,9 +155,6 @@ struct dm_dev *dm_snap_cow(struct dm_snapshot *s)
 }
 EXPORT_SYMBOL(dm_snap_cow);
 
-static struct workqueue_struct *ksnapd;
-static void flush_queued_bios(struct work_struct *work);
-
 static sector_t chunk_to_sector(struct dm_exception_store *store,
 				chunk_t chunk)
 {
@@ -1153,9 +1145,6 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
-	bio_list_init(&s->queued_bios);
-	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
-
 	ti->private = s;
 	ti->num_flush_requests = num_flush_requests;
 
@@ -1279,8 +1268,6 @@ static void snapshot_dtr(struct dm_target *ti)
 	struct dm_snapshot *s = ti->private;
 	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
 
-	flush_workqueue(ksnapd);
-
 	down_read(&_origins_lock);
 	/* Check whether exception handover must be cancelled */
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
@@ -1342,20 +1329,6 @@ static void flush_bios(struct bio *bio)
 	}
 }
 
-static void flush_queued_bios(struct work_struct *work)
-{
-	struct dm_snapshot *s =
-		container_of(work, struct dm_snapshot, queued_bios_work);
-	struct bio *queued_bios;
-	unsigned long flags;
-
-	spin_lock_irqsave(&s->pe_lock, flags);
-	queued_bios = bio_list_get(&s->queued_bios);
-	spin_unlock_irqrestore(&s->pe_lock, flags);
-
-	flush_bios(queued_bios);
-}
-
 static int do_origin(struct dm_dev *origin, struct bio *bio);
 
 /*
@@ -2291,17 +2264,8 @@ static int __init dm_snapshot_init(void)
 		goto bad_tracked_chunk_cache;
 	}
 
-	ksnapd = create_singlethread_workqueue("ksnapd");
-	if (!ksnapd) {
-		DMERR("Failed to create ksnapd workqueue.");
-		r = -ENOMEM;
-		goto bad_pending_pool;
-	}
-
 	return 0;
 
-bad_pending_pool:
-	kmem_cache_destroy(tracked_chunk_cache);
 bad_tracked_chunk_cache:
 	kmem_cache_destroy(pending_cache);
 bad_pending_cache:
@@ -2322,8 +2286,6 @@ bad_register_snapshot_target:
 
 static void __exit dm_snapshot_exit(void)
 {
-	destroy_workqueue(ksnapd);
-
 	dm_unregister_target(&snapshot_target);
 	dm_unregister_target(&origin_target);
 	dm_unregister_target(&merge_target);
-- 
1.7.1
