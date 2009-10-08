From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: add allocated metadata to snapshot
	status
Date: Thu,  8 Oct 2009 11:54:29 -0400
Message-ID: <1255017269-4429-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Add metadata usage to the end of the snapshot's status output.

Renamed dm_exception_store_type's 'fraction_full' to 'usage'.  Renamed
arguments to be clearer about what is being returned.  Also added
'metadata_allocated'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |    6 +++---
 drivers/md/dm-snap-persistent.c |   15 +++++++++------
 drivers/md/dm-snap-transient.c  |   14 ++++++++------
 drivers/md/dm-snap.c            |   17 +++++++++--------
 4 files changed, 29 insertions(+), 23 deletions(-)

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -86,9 +86,9 @@ struct dm_exception_store_type {
 	/*
 	 * Return how full the snapshot is.
 	 */
-	void (*fraction_full) (struct dm_exception_store *store,
-			       sector_t *numerator,
-			       sector_t *denominator);
+	void (*usage) (struct dm_exception_store *store,
+		       sector_t *total, sector_t *total_allocated,
+		       sector_t *metadata_allocated);
 
 	/* For internal device-mapper use only. */
 	struct list_head list;
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -489,11 +489,14 @@ static struct pstore *get_info(struct dm
 	return (struct pstore *) store->context;
 }
 
-static void persistent_fraction_full(struct dm_exception_store *store,
-				     sector_t *numerator, sector_t *denominator)
+static void persistent_usage(struct dm_exception_store *store,
+			     sector_t *total, sector_t *total_allocated,
+			     sector_t *metadata_allocated)
 {
-	*numerator = get_info(store)->next_free * store->chunk_size;
-	*denominator = get_dev_size(store->cow->bdev);
+	struct pstore *ps = get_info(store);
+	*total_allocated = ps->next_free * store->chunk_size;
+	*total = get_dev_size(store->cow->bdev);
+	*metadata_allocated = (ps->current_area + 2) * store->chunk_size;
 }
 
 static void persistent_dtr(struct dm_exception_store *store)
@@ -738,7 +741,7 @@ static struct dm_exception_store_type _p
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.drop_snapshot = persistent_drop_snapshot,
-	.fraction_full = persistent_fraction_full,
+	.usage = persistent_usage,
 	.status = persistent_status,
 };
 
@@ -751,7 +754,7 @@ static struct dm_exception_store_type _p
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.drop_snapshot = persistent_drop_snapshot,
-	.fraction_full = persistent_fraction_full,
+	.usage = persistent_usage,
 	.status = persistent_status,
 };
 
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -59,11 +59,13 @@ static void transient_commit_exception(s
 	callback(callback_context, 1);
 }
 
-static void transient_fraction_full(struct dm_exception_store *store,
-				    sector_t *numerator, sector_t *denominator)
+static void transient_usage(struct dm_exception_store *store,
+			    sector_t *total, sector_t *total_allocated,
+			    sector_t *metadata_allocated)
 {
-	*numerator = ((struct transient_c *) store->context)->next_free;
-	*denominator = get_dev_size(store->cow->bdev);
+	*total_allocated = ((struct transient_c *) store->context)->next_free;
+	*total = get_dev_size(store->cow->bdev);
+	*metadata_allocated = 0;
 }
 
 static int transient_ctr(struct dm_exception_store *store,
@@ -106,7 +108,7 @@ static struct dm_exception_store_type _t
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
-	.fraction_full = transient_fraction_full,
+	.usage = transient_usage,
 	.status = transient_status,
 };
 
@@ -118,7 +120,7 @@ static struct dm_exception_store_type _t
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
-	.fraction_full = transient_fraction_full,
+	.usage = transient_usage,
 	.status = transient_status,
 };
 
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1171,14 +1171,15 @@ static int snapshot_status(struct dm_tar
 		if (!snap->valid)
 			DMEMIT("Invalid");
 		else {
-			if (snap->store->type->fraction_full) {
-				sector_t numerator, denominator;
-				snap->store->type->fraction_full(snap->store,
-								 &numerator,
-								 &denominator);
-				DMEMIT("%llu/%llu",
-				       (unsigned long long)numerator,
-				       (unsigned long long)denominator);
+			if (snap->store->type->usage) {
+				sector_t total, total_allocated, metadata_allocated;
+				snap->store->type->usage(snap->store,
+							 &total, &total_allocated,
+							 &metadata_allocated);
+				DMEMIT("%llu/%llu %llu",
+				       (unsigned long long)total_allocated,
+				       (unsigned long long)total,
+				       (unsigned long long)metadata_allocated);
 			}
 			else
 				DMEMIT("Unknown");
