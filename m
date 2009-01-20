From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 9 of 12]:
	dm-snapshot-move-ctr-parsing-to-exception-store.patch
Date: Tue, 20 Jan 2009 14:07:52 -0600
Message-ID: <1232482072.19993.41.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

 brassow

First step of having the exception stores parse their own arguments -
generalizing the interface.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -7,6 +7,7 @@
 
 #include "dm-exception-store.h"
 
+#include <linux/ctype.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
@@ -142,49 +143,129 @@ int dm_exception_store_type_unregister(s
 }
 EXPORT_SYMBOL(dm_exception_store_type_unregister);
 
-int dm_exception_store_create(const char *type_name, struct dm_target *ti,
-			      chunk_t chunk_size, chunk_t chunk_mask,
-			      chunk_t chunk_shift, struct dm_dev *cow,
+/*
+ * Round a number up to the nearest 'size' boundary.  size must
+ * be a power of 2.
+ */
+static ulong round_up(ulong n, ulong size)
+{
+	size--;
+	return (n + size) & ~size;
+}
+
+static int set_chunk_size(struct dm_exception_store *store,
+			  const char *chunk_size_arg, char **error)
+{
+	unsigned long chunk_size_ulong;
+	char *value;
+
+	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
+	if (*chunk_size_arg == '\0' || *value != '\0') {
+		*error = "Invalid chunk size";
+		return -EINVAL;
+	}
+
+	if (!chunk_size_ulong) {
+		store->chunk_size = store->chunk_mask = store->chunk_shift = 0;
+		return 0;
+	}
+
+	/*
+	 * Chunk size must be multiple of page size.  Silently
+	 * round up if it's not.
+	 */
+	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
+
+	/* Check chunk_size is a power of 2 */
+	if (!is_power_of_2(chunk_size_ulong)) {
+		*error = "Chunk size is not a power of 2";
+		return -EINVAL;
+	}
+
+	/* Validate the chunk size against the device block size */
+	if (chunk_size_ulong % (bdev_hardsect_size(store->cow->bdev) >> 9)) {
+		*error = "Chunk size is not a multiple of device blocksize";
+		return -EINVAL;
+	}
+
+	store->chunk_size = chunk_size_ulong;
+	store->chunk_mask = chunk_size_ulong - 1;
+	store->chunk_shift = ffs(chunk_size_ulong) - 1;
+
+	return 0;
+}
+
+int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
+			      unsigned *args_used,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
 	struct dm_exception_store_type *type;
 	struct dm_exception_store *tmp_store;
+	char persistent;
+
+	if (argc < 3) {
+		ti->error = "Insufficient exception store arguments";
+		return -EINVAL;
+	}
 
 	tmp_store = kmalloc(sizeof(*tmp_store), GFP_KERNEL);
-	if (!tmp_store)
+	if (!tmp_store) {
+		ti->error = "Exception store allocation failed";
 		return -ENOMEM;
+	}
 
-	type = get_type(type_name);
-	if (!type) {
-		kfree(tmp_store);
+	persistent = toupper(*argv[1]);
+	if (persistent != 'P' && persistent != 'N') {
+		ti->error = "Persistent flag is not P or N";
 		return -EINVAL;
 	}
 
+	type = get_type(argv[1]);
+	if (!type) {
+		ti->error = "Exception store type not recognised";
+		r = -EINVAL;
+		goto bad_type;
+	}
+
 	tmp_store->type = type;
 	tmp_store->ti = ti;
 
-	tmp_store->chunk_size = chunk_size;
-	tmp_store->chunk_mask = chunk_mask;
-	tmp_store->chunk_shift = chunk_shift;
+	r = dm_get_device(ti, argv[0], 0, 0,
+			  FMODE_READ | FMODE_WRITE, &tmp_store->cow);
+	if (r) {
+		ti->error = "Cannot get COW device";
+		goto bad_cow;
+	}
 
-	tmp_store->cow = cow;
+	r = set_chunk_size(tmp_store, argv[2], &ti->error);
+	if (r)
+		goto bad_cow;
 
 	r = type->ctr(tmp_store, 0, NULL);
 	if (r) {
-		put_type(type);
-		kfree(tmp_store);
-		return r;
+		ti->error = "Exception store type constructor failed";
+		goto bad_ctr;
 	}
 
+	*args_used = 3;
 	*store = tmp_store;
 	return 0;
+
+bad_ctr:
+	dm_put_device(ti, tmp_store->cow);
+bad_cow:
+	put_type(type);
+bad_type:
+	kfree(tmp_store);
+	return r;
 }
 EXPORT_SYMBOL(dm_exception_store_create);
 
 void dm_exception_store_destroy(struct dm_exception_store *store)
 {
 	store->type->dtr(store);
+	dm_put_device(store->ti, store->cow);
 	put_type(store->type);
 	kfree(store);
 }
Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -167,9 +167,8 @@ static inline chunk_t sector_to_chunk(st
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
-int dm_exception_store_create(const char *type_name, struct dm_target *ti,
-			      chunk_t chunk_size, chunk_t chunk_mask,
-			      chunk_t chunk_shift, struct dm_dev *cow,
+int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
+			      unsigned *args_used,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/ctype.h>
 #include <linux/device-mapper.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -538,8 +537,7 @@ static int calc_max_buckets(void)
 /*
  * Allocate room for a suitable hash table.
  */
-static int init_hash_tables(struct dm_snapshot *s, chunk_t chunk_shift,
-			    struct dm_dev *cow)
+static int init_hash_tables(struct dm_snapshot *s)
 {
 	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
 
@@ -547,11 +545,11 @@ static int init_hash_tables(struct dm_sn
 	 * Calculate based on the size of the original volume or
 	 * the COW volume...
 	 */
-	cow_dev_size = get_dev_size(cow->bdev);
+	cow_dev_size = get_dev_size(s->store->cow->bdev);
 	origin_dev_size = get_dev_size(s->origin->bdev);
 	max_buckets = calc_max_buckets();
 
-	hash_size = min(origin_dev_size, cow_dev_size) >> chunk_shift;
+	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
@@ -576,59 +574,6 @@ static int init_hash_tables(struct dm_sn
 }
 
 /*
- * Round a number up to the nearest 'size' boundary.  size must
- * be a power of 2.
- */
-static ulong round_up(ulong n, ulong size)
-{
-	size--;
-	return (n + size) & ~size;
-}
-
-static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
-			  chunk_t *chunk_size, chunk_t *chunk_mask, chunk_t *chunk_shift,
-			  struct dm_dev *cow, char **error)
-{
-	unsigned long chunk_size_ulong;
-	char *value;
-
-	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
-	if (*chunk_size_arg == '\0' || *value != '\0') {
-		*error = "Invalid chunk size";
-		return -EINVAL;
-	}
-
-	if (!chunk_size_ulong) {
-		*chunk_size = *chunk_mask = *chunk_shift = 0;
-		return 0;
-	}
-
-	/*
-	 * Chunk size must be multiple of page size.  Silently
-	 * round up if it's not.
-	 */
-	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
-
-	/* Check chunk_size is a power of 2 */
-	if (!is_power_of_2(chunk_size_ulong)) {
-		*error = "Chunk size is not a power of 2";
-		return -EINVAL;
-	}
-
-	/* Validate the chunk size against the device block size */
-	if (chunk_size_ulong % (bdev_hardsect_size(cow->bdev) >> 9)) {
-		*error = "Chunk size is not a multiple of device blocksize";
-		return -EINVAL;
-	}
-
-	*chunk_size = chunk_size_ulong;
-	*chunk_mask = chunk_size_ulong - 1;
-	*chunk_shift = ffs(chunk_size_ulong) - 1;
-
-	return 0;
-}
-
-/*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
@@ -636,55 +581,45 @@ static int snapshot_ctr(struct dm_target
 	struct dm_snapshot *s;
 	int i;
 	int r = -EINVAL;
-	char persistent;
 	char *origin_path;
-	char *cow_path;
-	chunk_t chunk_size, chunk_mask, chunk_shift;
-	struct dm_dev *cow;
+	struct dm_exception_store *store;
+	unsigned args_used;
 
 	if (argc != 4) {
 		ti->error = "requires exactly 4 arguments";
 		r = -EINVAL;
-		goto bad1;
+		goto bad_args;
 	}
 
 	origin_path = argv[0];
-	cow_path = argv[1];
-	persistent = toupper(*argv[2]);
+	argv++;
+	argc--;
 
-	if (persistent != 'P' && persistent != 'N') {
-		ti->error = "Persistent flag is not P or N";
+	r = dm_exception_store_create(ti, argc, argv, &args_used, &store);
+	if (r) {
+		ti->error = "Couldn't create exception store";
 		r = -EINVAL;
-		goto bad1;
+		goto bad_args;
 	}
 
+	argv += args_used;
+	argc -= args_used;
+
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (s == NULL) {
+	if (!s) {
 		ti->error = "Cannot allocate snapshot context private "
 		    "structure";
 		r = -ENOMEM;
-		goto bad1;
+		goto bad_snap;
 	}
 
 	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
-		goto bad2;
+		goto bad_origin;
 	}
 
-	r = dm_get_device(ti, cow_path, 0, 0,
-			  FMODE_READ | FMODE_WRITE, &cow);
-	if (r) {
-		dm_put_device(ti, s->origin);
-		ti->error = "Cannot get COW device";
-		goto bad2;
-	}
-
-	r = set_chunk_size(s, argv[3], &chunk_size, &chunk_mask, &chunk_shift,
-			   cow, &ti->error);
-	if (r)
-		goto bad3;
-
+	s->store = store;
 	s->valid = 1;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
@@ -692,30 +627,22 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for COW data */
-	if (init_hash_tables(s, chunk_shift, cow)) {
+	if (init_hash_tables(s)) {
 		ti->error = "Unable to allocate hash table space";
 		r = -ENOMEM;
-		goto bad3;
-	}
-
-	r = dm_exception_store_create(argv[2], ti, chunk_size, chunk_mask,
-				      chunk_shift, cow, &s->store);
-	if (r) {
-		ti->error = "Couldn't create exception store";
-		r = -EINVAL;
-		goto bad4;
+		goto bad_hash_tables;
 	}
 
 	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
 	if (r) {
 		ti->error = "Could not create kcopyd client";
-		goto bad5;
+		goto bad_kcopyd;
 	}
 
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
-		goto bad6;
+		goto bad_pending_pool;
 	}
 
 	s->tracked_chunk_pool = mempool_create_slab_pool(MIN_IOS,
@@ -757,30 +684,29 @@ static int snapshot_ctr(struct dm_target
 
 	return 0;
 
- bad_load_and_register:
+bad_load_and_register:
 	mempool_destroy(s->tracked_chunk_pool);
 
- bad_tracked_chunk_pool:
+bad_tracked_chunk_pool:
 	mempool_destroy(s->pending_pool);
 
- bad6:
+bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
- bad5:
-	s->store->type->dtr(s->store);
-
- bad4:
+bad_kcopyd:
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
 
- bad3:
-	dm_put_device(ti, cow);
+bad_hash_tables:
 	dm_put_device(ti, s->origin);
 
- bad2:
+bad_origin:
 	kfree(s);
 
- bad1:
+bad_snap:
+	dm_exception_store_destroy(store);
+
+bad_args:
 	return r;
 }
 
@@ -791,8 +717,6 @@ static void __free_exceptions(struct dm_
 
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
-
-	s->store->type->dtr(s->store);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -801,7 +725,6 @@ static void snapshot_dtr(struct dm_targe
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
-	struct dm_dev *cow = s->store->cow;
 
 	flush_workqueue(ksnapd);
 
@@ -829,7 +752,8 @@ static void snapshot_dtr(struct dm_targe
 	mempool_destroy(s->pending_pool);
 
 	dm_put_device(ti, s->origin);
-	dm_put_device(ti, cow);
+
+	dm_exception_store_destroy(s->store);
 
 	kfree(s);
 }
