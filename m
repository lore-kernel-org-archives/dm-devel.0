From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot: find min chunksize function
Date: Wed, 23 Sep 2009 10:19:18 -0500
Message-ID: <200909231519.n8NFJIWT028740@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-snapshot-find-min-chunksize-function.patch

The origin needs to find minimum chunksize of all snapshots.
This logic is moved to separate function because it will be used at other place
in snapshot merge.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -519,6 +519,25 @@ static int dm_add_exception(void *contex
 	return 0;
 }
 
+#define min_not_zero(l, r) (((l) == 0) ? (r) : (((r) == 0) ? (l) : min(l, r)))
+
+/*
+ * Return a minimum chunk size of all snapshots that have the specified origin.
+ * Return zero if the origin has no snapshots.
+ */
+static sector_t minimum_chunk_size(struct origin *o)
+{
+	struct dm_snapshot *snap;
+	sector_t chunk_size = 0;
+
+	if (o)
+		list_for_each_entry(snap, &o->snapshots, list)
+			chunk_size = min_not_zero(chunk_size,
+						  snap->store->chunk_size);
+
+	return chunk_size;
+}
+
 /*
  * Hard coded magic.
  */
@@ -1378,8 +1397,6 @@ static int origin_map(struct dm_target *
 	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
 
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-
 /*
  * Set the target "split_io" field to the minimum of all the snapshots'
  * chunk sizes.
@@ -1387,19 +1404,14 @@ static int origin_map(struct dm_target *
 static void origin_resume(struct dm_target *ti)
 {
 	struct dm_dev *dev = ti->private;
-	struct dm_snapshot *snap;
 	struct origin *o;
-	chunk_t chunk_size = 0;
 
 	down_read(&_origins_lock);
+
 	o = __lookup_origin(dev->bdev);
-	if (o)
-		list_for_each_entry (snap, &o->snapshots, list)
-			chunk_size = min_not_zero(chunk_size,
-						  snap->store->chunk_size);
-	up_read(&_origins_lock);
+	ti->split_io = minimum_chunk_size(o);
 
-	ti->split_io = chunk_size;
+	up_read(&_origins_lock);
 }
 
 static int origin_status(struct dm_target *ti, status_type_t type, char *result,
