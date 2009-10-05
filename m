From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 03/12] dm-snapshot-target-merge
Date: Mon,  5 Oct 2009 15:02:38 -0400
Message-ID: <1254769367-12111-4-git-send-email-snitzer@redhat.com>
References: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Add a new target snapshot-merge.
For now, the target is identical to snapshot.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 275ae33..27b2f22 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1525,6 +1525,19 @@ static struct target_type snapshot_target = {
 	.iterate_devices = snapshot_iterate_devices,
 };
 
+static struct target_type snapshot_merge_target = {
+	.name    = "snapshot-merge",
+	.version = {1, 7, 0},
+	.module  = THIS_MODULE,
+	.ctr     = snapshot_ctr,
+	.dtr     = snapshot_dtr,
+	.map     = snapshot_map,
+	.end_io  = snapshot_end_io,
+	.resume  = snapshot_resume,
+	.status  = snapshot_status,
+	.iterate_devices = snapshot_iterate_devices,
+};
+
 static int __init dm_snapshot_init(void)
 {
 	int r;
@@ -1536,7 +1549,7 @@ static int __init dm_snapshot_init(void)
 	}
 
 	r = dm_register_target(&snapshot_target);
-	if (r) {
+	if (r < 0) {
 		DMERR("snapshot target register failed %d", r);
 		goto bad_register_snapshot_target;
 	}
@@ -1544,34 +1557,40 @@ static int __init dm_snapshot_init(void)
 	r = dm_register_target(&origin_target);
 	if (r < 0) {
 		DMERR("Origin target register failed %d", r);
-		goto bad1;
+		goto bad_register_origin_target;
+	}
+
+	r = dm_register_target(&snapshot_merge_target);
+	if (r < 0) {
+		DMERR("snapshot-merge target register failed %d", r);
+		goto bad_register_snapshot_merge_target;
 	}
 
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
-		goto bad2;
+		goto bad_origin_hash;
 	}
 
 	exception_cache = KMEM_CACHE(dm_snap_exception, 0);
 	if (!exception_cache) {
 		DMERR("Couldn't create exception cache.");
 		r = -ENOMEM;
-		goto bad3;
+		goto bad_exception_cache;
 	}
 
 	pending_cache = KMEM_CACHE(dm_snap_pending_exception, 0);
 	if (!pending_cache) {
 		DMERR("Couldn't create pending cache.");
 		r = -ENOMEM;
-		goto bad4;
+		goto bad_pending_cache;
 	}
 
 	tracked_chunk_cache = KMEM_CACHE(dm_snap_tracked_chunk, 0);
 	if (!tracked_chunk_cache) {
 		DMERR("Couldn't create cache to track chunks in use.");
 		r = -ENOMEM;
-		goto bad5;
+		goto bad_tracked_chunk_cache;
 	}
 
 	ksnapd = create_singlethread_workqueue("ksnapd");
@@ -1585,19 +1604,21 @@ static int __init dm_snapshot_init(void)
 
 bad_pending_pool:
 	kmem_cache_destroy(tracked_chunk_cache);
-bad5:
+bad_tracked_chunk_cache:
 	kmem_cache_destroy(pending_cache);
-bad4:
+bad_pending_cache:
 	kmem_cache_destroy(exception_cache);
-bad3:
+bad_exception_cache:
 	exit_origin_hash();
-bad2:
+bad_origin_hash:
+	dm_unregister_target(&snapshot_merge_target);
+bad_register_snapshot_merge_target:
 	dm_unregister_target(&origin_target);
-bad1:
+bad_register_origin_target:
 	dm_unregister_target(&snapshot_target);
-
 bad_register_snapshot_target:
 	dm_exception_store_exit();
+
 	return r;
 }
 
@@ -1607,6 +1628,7 @@ static void __exit dm_snapshot_exit(void)
 
 	dm_unregister_target(&snapshot_target);
 	dm_unregister_target(&origin_target);
+	dm_unregister_target(&snapshot_merge_target);
 
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
-- 
1.6.2.5
