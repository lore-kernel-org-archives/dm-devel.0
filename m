From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 08/10] dm snapshot: Add basic version of
	snapshot-merged target
Date: Tue,  1 Apr 2008 09:32:55 +0200
Message-ID: <1207035177-7156-9-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
	<1207035177-7156-5-git-send-email-markmc@redhat.com>
	<1207035177-7156-6-git-send-email-markmc@redhat.com>
	<1207035177-7156-7-git-send-email-markmc@redhat.com>
	<1207035177-7156-8-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-8-git-send-email-markmc@redhat.com>
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
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Add a very basic version of the snapshot-merged target. The only
arguments required for the target are the origin device path and the
COW device path. The origin device may not be used with another
snapshot-origin target at the same time and the COW device may not be
used with another snapshot target.

The target acts much like a snapshot target exception no new
exceptions are triggered by writes. If an I/O request corresponds to a
chunk which has not already been mapped to the COW device, then the
I/O will always be dispatched to the chunk on the origin
device. However, if it is a write, before dispatching it we will
trigger exceptions in any other associated snapshots much like the
snapshot-origin target does.

Another slight twist is the status() function reports the merging
progress of the target - i.e. if the COW device is full, we report 0%
and if it's empty we report 100%.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |  166 ++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-snap.h |    4 +
 2 files changed, 159 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e4ba02c..5236763 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1326,6 +1326,127 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 	return 0;
 }
 
+/*
+ * Construct a merged snapshot: <origin_dev> <COW-dev>
+ */
+static int merged_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dm_merged *merged;
+	char *origin_path;
+	char *cow_path;
+	int r;
+
+	if (argc != 2) {
+		ti->error = "dm-snapshot: requires exactly 2 arguments";
+		return -EINVAL;
+	}
+
+	origin_path = argv[0];
+	cow_path = argv[1];
+
+	merged = kmalloc(sizeof(struct dm_merged), GFP_KERNEL);
+	if (!merged) {
+		ti->error = "Cannot allocate merged snapshot context private "
+			    "structure";
+		return -ENOMEM;
+	}
+
+	r = snapshot_init(ti, &merged->snap,
+			  origin_path, dm_table_get_mode(ti->table),
+			  cow_path, FMODE_READ | FMODE_WRITE,
+			  'P', 0);
+	if (r) {
+		kfree(merged);
+		return r;
+	}
+
+	ti->private = merged;
+
+	return 0;
+}
+
+static void merged_dtr(struct dm_target *ti)
+{
+	struct dm_merged *merged = ti->private;
+
+	snapshot_destroy(ti, &merged->snap);
+
+	kfree(merged);
+}
+
+static int merged_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
+	struct dm_merged *merged = ti->private;
+	struct dm_snapshot *s = &merged->snap;
+	struct dm_snap_exception *e;
+	chunk_t chunk;
+	int r = DM_MAPIO_REMAPPED;;
+
+	if (unlikely(bio_barrier(bio)))
+		return -EOPNOTSUPP;
+
+	chunk = sector_to_chunk(s, bio->bi_sector);
+
+	down_read(&s->lock);
+
+	if (!s->valid) {
+		up_read(&s->lock);
+		return -EIO;
+	}
+
+	e = lookup_exception(&s->complete, chunk);
+	if (e)
+		remap_exception(s, e, bio, chunk);
+	else {
+		bio->bi_bdev = s->origin->bdev;
+
+		if (bio_rw(bio) == WRITE)
+			r = do_origin(s->origin, bio->bi_sector, bio);
+	}
+
+	up_read(&s->lock);
+
+	return r;
+}
+
+static void merged_resume(struct dm_target *ti)
+{
+	struct dm_merged *merged = ti->private;
+
+	ti->split_io = min_chunk_size(merged->snap.origin);
+}
+
+static int merged_status(struct dm_target *ti, status_type_t type, char *result,
+			 unsigned int maxlen)
+{
+	struct dm_merged *merged = ti->private;
+	struct dm_snapshot *snap = &merged->snap;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		if (!snap->valid)
+			snprintf(result, maxlen, "Invalid");
+		else {
+			sector_t numerator, denominator;
+			snap->store.fraction_full(&snap->store,
+						  &numerator,
+						  &denominator);
+			snprintf(result, maxlen, "%llu/%llu",
+				 (unsigned long long)denominator - numerator,
+				 (unsigned long long)denominator);
+		}
+		break;
+
+	case STATUSTYPE_TABLE:
+		snprintf(result, maxlen, "%s %s",
+			 snap->origin->name, snap->cow->name);
+		break;
+	}
+
+	return 0;
+}
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
 	.version = {1, 6, 0},
@@ -1349,6 +1470,17 @@ static struct target_type snapshot_target = {
 	.status  = snapshot_status,
 };
 
+static struct target_type merged_target = {
+	.name    = "snapshot-merged",
+	.version = {1, 1, 1},
+	.module  = THIS_MODULE,
+	.ctr     = merged_ctr,
+	.dtr     = merged_dtr,
+	.map     = merged_map,
+	.resume  = merged_resume,
+	.status  = merged_status,
+};
+
 static int __init dm_snapshot_init(void)
 {
 	int r;
@@ -1365,53 +1497,61 @@ static int __init dm_snapshot_init(void)
 		goto bad1;
 	}
 
+	r = dm_register_target(&merged_target);
+	if (r < 0) {
+		DMERR("Device mapper: Merged: register failed %d\n", r);
+		goto bad2;
+	}
+
 	r = init_origin_hash();
 	if (r) {
 		DMERR("init_origin_hash failed.");
-		goto bad2;
+		goto bad3;
 	}
 
 	exception_cache = KMEM_CACHE(dm_snap_exception, 0);
 	if (!exception_cache) {
 		DMERR("Couldn't create exception cache.");
 		r = -ENOMEM;
-		goto bad3;
+		goto bad4;
 	}
 
 	pending_cache = KMEM_CACHE(dm_snap_pending_exception, 0);
 	if (!pending_cache) {
 		DMERR("Couldn't create pending cache.");
 		r = -ENOMEM;
-		goto bad4;
+		goto bad5;
 	}
 
 	pending_pool = mempool_create_slab_pool(128, pending_cache);
 	if (!pending_pool) {
 		DMERR("Couldn't create pending pool.");
 		r = -ENOMEM;
-		goto bad5;
+		goto bad6;
 	}
 
 	ksnapd = create_singlethread_workqueue("ksnapd");
 	if (!ksnapd) {
 		DMERR("Failed to create ksnapd workqueue.");
 		r = -ENOMEM;
-		goto bad6;
+		goto bad7;
 	}
 
 	return 0;
 
-      bad6:
+bad7:
 	mempool_destroy(pending_pool);
-      bad5:
+bad6:
 	kmem_cache_destroy(pending_cache);
-      bad4:
+bad5:
 	kmem_cache_destroy(exception_cache);
-      bad3:
+bad4:
 	exit_origin_hash();
-      bad2:
+bad3:
+	dm_unregister_target(&merged_target);
+bad2:
 	dm_unregister_target(&origin_target);
-      bad1:
+bad1:
 	dm_unregister_target(&snapshot_target);
 	return r;
 }
@@ -1430,6 +1570,10 @@ static void __exit dm_snapshot_exit(void)
 	if (r)
 		DMERR("origin unregister failed %d", r);
 
+	r = dm_unregister_target(&merged_target);
+	if (r)
+		DMERR("merged unregister failed %d", r);
+
 	exit_origin_hash();
 	mempool_destroy(pending_pool);
 	kmem_cache_destroy(pending_cache);
diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 8b02a42..8600477 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -188,6 +188,10 @@ struct dm_snapshot {
 	struct work_struct queued_bios_work;
 };
 
+struct dm_merged {
+	struct dm_snapshot snap;
+};
+
 /*
  * Used by the exception stores to load exceptions hen
  * initialising.
-- 
1.5.4.1
