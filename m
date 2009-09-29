From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 07/18] dm-snapshot-use-allocated-exception-tables
Date: Tue, 29 Sep 2009 18:53:32 -0400
Message-ID: <1254264823-11538-8-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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

From: Jon Brassow <jbrassow@redhat.com>

Change to using exception table pointers vs. just using the
whole struct from within 'stuct dm_snapshot'.  Again, this is
to facilitate extraction of the exception table/cache code from
dm-snap.c.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   61 +++++++++++++++++++++++++++++--------------------
 1 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7d6a02f..cc04760 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -74,8 +74,8 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
-	struct dm_exception_table pending;
-	struct dm_exception_table complete;
+	struct dm_exception_table *pending;
+	struct dm_exception_table *complete;
 
 	/*
 	 * pe_lock protects all pending_exception operations and access
@@ -347,25 +347,32 @@ static void unregister_snapshot(struct dm_snapshot *s)
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
-static int dm_exception_table_init(struct dm_exception_table *et,
-				   uint32_t size, unsigned hash_shift)
+static struct dm_exception_table *
+dm_exception_table_create(uint32_t size, unsigned hash_shift)
 {
 	unsigned int i;
+	struct dm_exception_table *et;
+
+	et = kmalloc(sizeof(*et), GFP_KERNEL);
+	if (!et)
+		return NULL;
 
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
 	et->table = dm_vcalloc(size, sizeof(struct list_head));
-	if (!et->table)
-		return -ENOMEM;
+	if (!et->table) {
+		kfree(et);
+		return NULL;
+	}
 
 	for (i = 0; i < size; i++)
 		INIT_LIST_HEAD(et->table + i);
 
-	return 0;
+	return et;
 }
 
-static void dm_exception_table_exit(struct dm_exception_table *et,
-				    struct kmem_cache *mem)
+static void dm_exception_table_destroy(struct dm_exception_table *et,
+				       struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
@@ -380,6 +387,7 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	}
 
 	vfree(et->table);
+	kfree(et);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
@@ -507,7 +515,7 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	dm_insert_exception(&s->complete, e);
+	dm_insert_exception(s->complete, e);
 
 	return 0;
 }
@@ -562,8 +570,10 @@ static int init_hash_tables(struct dm_snapshot *s)
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
-	if (dm_exception_table_init(&s->complete, hash_size,
-				    DM_CHUNK_CONSECUTIVE_BITS))
+
+	s->complete = dm_exception_table_create(hash_size,
+						DM_CHUNK_CONSECUTIVE_BITS);
+	if (!s->complete)
 		return -ENOMEM;
 
 	/*
@@ -574,8 +584,9 @@ static int init_hash_tables(struct dm_snapshot *s)
 	if (hash_size < 64)
 		hash_size = 64;
 
-	if (dm_exception_table_init(&s->pending, hash_size, 0)) {
-		dm_exception_table_exit(&s->complete, exception_cache);
+	s->pending = dm_exception_table_create(hash_size, 0);
+	if (!s->pending) {
+		dm_exception_table_destroy(s->complete, exception_cache);
 		return -ENOMEM;
 	}
 
@@ -767,8 +778,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	dm_exception_table_exit(&s->pending, pending_cache);
-	dm_exception_table_exit(&s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending, pending_cache);
+	dm_exception_table_destroy(s->complete, exception_cache);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -787,8 +798,8 @@ static void __free_exceptions(struct dm_snapshot *s)
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	dm_exception_table_exit(&s->pending, pending_cache);
-	dm_exception_table_exit(&s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending, pending_cache);
+	dm_exception_table_destroy(s->complete, exception_cache);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -968,7 +979,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	 * Add a proper exception, and remove the
 	 * in-flight exception from the list.
 	 */
-	dm_insert_exception(&s->complete, e);
+	dm_insert_exception(s->complete, e);
 
  out:
 	dm_remove_exception(&pe->e);
@@ -1039,7 +1050,7 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 static struct dm_snap_pending_exception *
 __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 {
-	struct dm_exception *e = dm_lookup_exception(&s->pending, chunk);
+	struct dm_exception *e = dm_lookup_exception(s->pending, chunk);
 
 	if (!e)
 		return NULL;
@@ -1080,7 +1091,7 @@ __find_pending_exception(struct dm_snapshot *s,
 	}
 
 	get_pending_exception(pe);
-	dm_insert_exception(&s->pending, &pe->e);
+	dm_insert_exception(s->pending, &pe->e);
 
 	return pe;
 }
@@ -1127,7 +1138,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = dm_lookup_exception(&s->complete, chunk);
+	e = dm_lookup_exception(s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1151,7 +1162,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 				goto out_unlock;
 			}
 
-			e = dm_lookup_exception(&s->complete, chunk);
+			e = dm_lookup_exception(s->complete, chunk);
 			if (e) {
 				free_pending_exception(pe);
 				remap_exception(s, e, bio, chunk);
@@ -1298,7 +1309,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = dm_lookup_exception(&snap->complete, chunk);
+		e = dm_lookup_exception(snap->complete, chunk);
 		if (e)
 			goto next_snapshot;
 
@@ -1313,7 +1324,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 				goto next_snapshot;
 			}
 
-			e = dm_lookup_exception(&snap->complete, chunk);
+			e = dm_lookup_exception(snap->complete, chunk);
 			if (e) {
 				free_pending_exception(pe);
 				goto next_snapshot;
-- 
1.6.2.5
