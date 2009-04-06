From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 28 of 33] DM Snapshot: get rid of
	init_hash_tables fn
Date: Mon, 6 Apr 2009 16:37:11 -0500
Message-ID: <200904062137.n36LbBXJ021759@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-get-rid-of-init_hash_tables-fn.patch

init_hash_tables is an annoying function that just sets up one
exception table... but it doesn't have a clear counterpart for tearing
down - we simply call dm_exception_table_destroy.  So, let's just get
rid of it and save ourselves the confusion.  [Doing so also makes
future patches easier to read.]

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -373,38 +373,6 @@ static int calc_max_buckets(void)
 }
 
 /*
- * Allocate room for a suitable hash table.
- */
-static int init_hash_tables(struct dm_snapshot *s)
-{
-	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
-
-	/*
-	 * Calculate based on the size of the original volume or
-	 * the COW volume...
-	 */
-	cow_dev_size = get_dev_size(s->store->cow->bdev);
-	origin_dev_size = get_dev_size(s->origin->bdev);
-	max_buckets = calc_max_buckets();
-
-	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
-	hash_size = min(hash_size, max_buckets);
-
-	hash_size = rounddown_pow_of_two(hash_size);
-	hash_size >>= 3;
-	if (hash_size < 64)
-		hash_size = 64;
-
-	s->pending = dm_exception_table_create(hash_size, 0,
-					       alloc_pending_exception, s,
-					       free_pending_exception, NULL);
-	if (!s->pending)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/*
  * create_exception_store
  * @ti
  * @argc
@@ -477,6 +445,7 @@ static int create_exception_store(struct
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
+	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
 	struct dm_snapshot *s;
 	int i;
 	int r = -EINVAL;
@@ -520,11 +489,29 @@ static int snapshot_ctr(struct dm_target
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
-	/* Allocate hash table for COW data */
-	if (init_hash_tables(s)) {
+	/*
+	 * Calculate based on the size of the original volume or
+	 * the COW volume...
+	 */
+	cow_dev_size = get_dev_size(store->cow->bdev);
+	origin_dev_size = get_dev_size(s->origin->bdev);
+	max_buckets = calc_max_buckets();
+
+	hash_size = min(origin_dev_size, cow_dev_size) >> store->chunk_shift;
+	hash_size = min(hash_size, max_buckets);
+
+	hash_size = rounddown_pow_of_two(hash_size);
+	hash_size >>= 3;
+	if (hash_size < 64)
+		hash_size = 64;
+
+	s->pending = dm_exception_table_create(hash_size, 0,
+					       alloc_pending_exception, s,
+					       free_pending_exception, NULL);
+	if (!s->pending) {
 		ti->error = "Unable to allocate hash table space";
 		r = -ENOMEM;
-		goto bad_hash_tables;
+		goto bad_hash_table;
 	}
 
 	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
@@ -579,7 +566,7 @@ bad_pending_pool:
 bad_kcopyd:
 	dm_exception_table_destroy(s->pending);
 
-bad_hash_tables:
+bad_hash_table:
 	dm_put_device(ti, s->origin);
 
 bad_origin:
