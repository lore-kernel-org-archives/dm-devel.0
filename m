From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 04/13] dm snapshot: add snapshot-merge target
Date: Thu,  3 Dec 2009 21:23:45 -0500
Message-ID: <1259893434-10792-5-git-send-email-snitzer@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
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

The snapshot-merge target allows a snapshot to be merged back into the
snapshot's origin device.

One expected use of snapshot merging is the rollback of a root
filesystem after system upgrades (e.g.: yum update).  snapshot-merge
enables "system rollback" support for any filesystem that is using the
associated DM devices.

Add snapshot-merge target management to both dm_snapshot_init() and
dm_snapshot_exit().  As an initial place-holder, snapshot-merge is
identical to the snapshot target.

Add "snapshot-merge" to Documentation/device-mapper/snapshot.txt

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/snapshot.txt |   60 +++++++++++++++++++++++++++--
 drivers/md/dm-snap.c                     |   48 ++++++++++++++++++------
 2 files changed, 91 insertions(+), 17 deletions(-)

diff --git a/Documentation/device-mapper/snapshot.txt b/Documentation/device-mapper/snapshot.txt
index a5009c8..e3a77b2 100644
--- a/Documentation/device-mapper/snapshot.txt
+++ b/Documentation/device-mapper/snapshot.txt
@@ -8,13 +8,19 @@ the block device which are also writable without interfering with the
 original content;
 *) To create device "forks", i.e. multiple different versions of the
 same data stream.
+*) To merge a snapshot of a block device back into the snapshot's origin
+device.
 
+In the first two cases, dm copies only the chunks of data that get
+changed and uses a separate copy-on-write (COW) block device for
+storage.
 
-In both cases, dm copies only the chunks of data that get changed and
-uses a separate copy-on-write (COW) block device for storage.
+For snapshot merge the contents of the COW storage are merged back into
+the origin device.
 
 
-There are two dm targets available: snapshot and snapshot-origin.
+There are three dm targets available:
+snapshot, snapshot-origin, and snapshot-merge.
 
 *) snapshot-origin <origin>
 
@@ -40,8 +46,25 @@ The difference is that for transient snapshots less metadata must be
 saved on disk - they can be kept in memory by the kernel.
 
 
-How this is used by LVM2
-========================
+* snapshot-merge <origin> <COW device> <persistent> <chunksize>
+
+takes the same table arguments as the snapshot target except it only
+works with persistent snapshots.  This target assumes the role of the
+"snapshot-origin" target and must not be loaded if the "snapshot-origin"
+is still present for <origin>.
+
+Creates a merging snapshot that takes control of the changed chunks
+stored in the <COW device> of an existing snapshot, through a handover
+procedure, and merges these chunks back into the <origin>.  Once merging
+has started (in the background) the <origin> may be opened and the merge
+will continue while I/O is flowing to it.  Changes to the <origin> are
+deferred until the merging snapshot's corresponding chunk(s) have been
+merged.  Once merging has started the snapshot device, associated with
+the "snapshot" target, will return -EIO when accessed.
+
+
+How snapshot is used by LVM2
+============================
 When you create the first LVM2 snapshot of a volume, four dm devices are used:
 
 1) a device containing the original mapping table of the source volume;
@@ -72,3 +95,30 @@ brw-------  1 root root 254, 12 29 ago 18:15 /dev/mapper/volumeGroup-snap-cow
 brw-------  1 root root 254, 13 29 ago 18:15 /dev/mapper/volumeGroup-snap
 brw-------  1 root root 254, 10 29 ago 18:14 /dev/mapper/volumeGroup-base
 
+
+How snapshot-merge is used by LVM2
+==================================
+A merging snapshot assumes the role of the "snapshot-origin" while
+merging.  As such the "snapshot-origin" is replaced with
+"snapshot-merge".  The "-real" device is not changed and the "-cow"
+device is renamed to <origin name>-cow to aid LVM2's cleanup of the
+merging snapshot after it completes.  The "snapshot" that hands over its
+COW device to the "snapshot-merge" is deactivated (unless using lvchange
+--refresh); but if it is left active it will simply return I/O errors.
+
+A snapshot will merge into its origin with the following command:
+
+lvconvert --merge volumeGroup/snap
+
+we'll now have this situation:
+
+# dmsetup table|grep volumeGroup
+
+volumeGroup-base-real: 0 2097152 linear 8:19 384
+volumeGroup-base-cow: 0 204800 linear 8:19 2097536
+volumeGroup-base: 0 2097152 snapshot-merge 254:11 254:12 P 16
+
+# ls -lL /dev/mapper/volumeGroup-*
+brw-------  1 root root 254, 11 29 ago 18:15 /dev/mapper/volumeGroup-base-real
+brw-------  1 root root 254, 12 29 ago 18:16 /dev/mapper/volumeGroup-base-cow
+brw-------  1 root root 254, 10 29 ago 18:16 /dev/mapper/volumeGroup-base
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index d8180ba..15c29a5 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1668,6 +1668,21 @@ static struct target_type snapshot_target = {
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
+	.postsuspend = snapshot_postsuspend,
+	.preresume  = snapshot_preresume,
+	.resume  = snapshot_resume,
+	.status  = snapshot_status,
+	.iterate_devices = snapshot_iterate_devices,
+};
+
 static int __init dm_snapshot_init(void)
 {
 	int r;
@@ -1679,7 +1694,7 @@ static int __init dm_snapshot_init(void)
 	}
 
 	r = dm_register_target(&snapshot_target);
-	if (r) {
+	if (r < 0) {
 		DMERR("snapshot target register failed %d", r);
 		goto bad_register_snapshot_target;
 	}
@@ -1687,34 +1702,40 @@ static int __init dm_snapshot_init(void)
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
@@ -1728,19 +1749,21 @@ static int __init dm_snapshot_init(void)
 
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
 
@@ -1750,6 +1773,7 @@ static void __exit dm_snapshot_exit(void)
 
 	dm_unregister_target(&snapshot_target);
 	dm_unregister_target(&origin_target);
+	dm_unregister_target(&merge_target);
 
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
-- 
1.6.5.2
