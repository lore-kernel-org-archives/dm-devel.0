From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 08/17] dm snapshot: add snapshot-merge target
Date: Tue, 20 Oct 2009 18:46:56 -0400
Message-ID: <1256078825-11331-9-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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

For starters, snapshot-merge is identical to the snapshot target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1f0a57c..d83a26e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1579,6 +1579,19 @@ static struct target_type snapshot_target = {
 	.iterate_devices = snapshot_iterate_devices,
 };
 
+static struct target_type merge_target = {
+	.name    = "snapshot-merge",
+	.version = {1, 9, 0},
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
@@ -1590,7 +1603,7 @@ static int __init dm_snapshot_init(void)
 	}
 
 	r = dm_register_target(&snapshot_target);
-	if (r) {
+	if (r < 0) {
 		DMERR("snapshot target register failed %d", r);
 		goto bad_register_snapshot_target;
 	}
@@ -1598,34 +1611,40 @@ static int __init dm_snapshot_init(void)
 	r = dm_register_target(&origin_target);
 	if (r < 0) {
 		DMERR("Origin target register failed %d", r);
-		goto bad1;
+		goto bad_register_origin_target;
+	}
+
+	r = dm_register_target(&merge_target);
+	if (r < 0) {
+		DMERR("Merge target register failed %d", r);
+		goto bad_register_merge_target;
 	}
 
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
-		goto bad2;
+		goto bad_origin_hash;
 	}
 
 	exception_cache = KMEM_CACHE(dm_exception, 0);
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
@@ -1639,19 +1658,21 @@ static int __init dm_snapshot_init(void)
 
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
+	dm_unregister_target(&merge_target);
+bad_register_merge_target:
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
 
@@ -1661,6 +1682,7 @@ static void __exit dm_snapshot_exit(void)
 
 	dm_unregister_target(&snapshot_target);
 	dm_unregister_target(&origin_target);
+	dm_unregister_target(&merge_target);
 
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
-- 
1.6.5.rc2
