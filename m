From: Jan Blunck <jblunck@suse.de>
Subject: [patch 03/11] dm-snap: Remove dead queued_bios code
Date: Fri, 10 Aug 2007 22:02:07 +0200
Message-ID: <15399.1507985213$1186776762@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-snap-remove-queued_bios.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch removes the unused queued_bios handling code.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-snap.c |   33 ---------------------------------
 drivers/md/dm-snap.h |    4 ----
 2 files changed, 37 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -39,9 +39,6 @@
  */
 #define SNAPSHOT_PAGES 256
 
-static struct workqueue_struct *ksnapd;
-static void flush_queued_bios(struct work_struct *work);
-
 struct dm_snap_pending_exception {
 	struct dm_snap_exception e;
 
@@ -511,9 +508,6 @@ static int snapshot_ctr(struct dm_target
 		DMWARN("Snapshot is marked invalid.");
 	}
 
-	bio_list_init(&s->queued_bios);
-	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
-
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
 	if (register_snapshot(s)) {
@@ -563,8 +557,6 @@ static void snapshot_dtr(struct dm_targe
 {
 	struct dm_snapshot *s = ti->private;
 
-	flush_workqueue(ksnapd);
-
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -592,20 +584,6 @@ static void flush_bios(struct bio *bio)
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
 /*
  * Error a list of buffers.
  */
@@ -1249,17 +1227,8 @@ static int __init dm_snapshot_init(void)
 		goto bad5;
 	}
 
-	ksnapd = create_singlethread_workqueue("ksnapd");
-	if (!ksnapd) {
-		DMERR("Failed to create ksnapd workqueue.");
-		r = -ENOMEM;
-		goto bad6;
-	}
-
 	return 0;
 
-      bad6:
-	mempool_destroy(pending_pool);
       bad5:
 	kmem_cache_destroy(pending_cache);
       bad4:
@@ -1277,8 +1246,6 @@ static void __exit dm_snapshot_exit(void
 {
 	int r;
 
-	destroy_workqueue(ksnapd);
-
 	r = dm_unregister_target(&snapshot_target);
 	if (r)
 		DMERR("snapshot unregister failed %d", r);
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -124,10 +124,6 @@ struct dm_snapshot {
 	struct exception_store store;
 
 	struct kcopyd_client *kcopyd_client;
-
-	/* Queue of snapshot writes for ksnapd to flush */
-	struct bio_list queued_bios;
-	struct work_struct queued_bios_work;
 };
 
 /*

-- 
