From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 5 of 12]:
	dm-exception-store-move-cow-pointer.patch
Date: Tue, 20 Jan 2009 13:57:43 -0600
Message-ID: <1232481463.19993.26.camel@hydrogen.msp.redhat.com>
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

Move COW device from snapshot to exception store.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.c	2009-01-08 02:25:42.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.c	2009-01-08 02:26:27.000000000 +0000
@@ -144,7 +144,7 @@ EXPORT_SYMBOL(dm_exception_store_type_un
 
 int dm_exception_store_create(const char *type_name, struct dm_target *ti,
 			      chunk_t chunk_size, chunk_t chunk_mask,
-			      chunk_t chunk_shift,
+			      chunk_t chunk_shift, struct dm_dev *cow,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
@@ -168,6 +168,8 @@ int dm_exception_store_create(const char
 	tmp_store->chunk_mask = chunk_mask;
 	tmp_store->chunk_shift = chunk_shift;
 
+	tmp_store->cow = cow;
+
 	r = type->ctr(tmp_store, 0, NULL);
 	if (r) {
 		put_type(type);
Index: linux-2.6.28/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.h	2009-01-08 02:25:42.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.h	2009-01-08 02:26:27.000000000 +0000
@@ -99,6 +99,8 @@ struct dm_exception_store {
 
 	struct dm_snapshot *snap;
 
+	struct dm_dev *cow;
+
 	/* Size of data blocks saved - must be a power of 2 */
 	chunk_t chunk_size;
 	chunk_t chunk_mask;
@@ -155,7 +157,7 @@ int dm_exception_store_type_unregister(s
 
 int dm_exception_store_create(const char *type_name, struct dm_target *ti,
 			      chunk_t chunk_size, chunk_t chunk_mask,
-			      chunk_t chunk_shift,
+			      chunk_t chunk_shift, struct dm_dev *cow,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
Index: linux-2.6.28/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-persistent.c	2009-01-08 02:25:42.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-persistent.c	2009-01-08 02:26:27.000000000 +0000
@@ -189,7 +189,7 @@ static void do_metadata(struct work_stru
 static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
 {
 	struct dm_io_region where = {
-		.bdev = ps->snap->cow->bdev,
+		.bdev = ps->snap->store->cow->bdev,
 		.sector = ps->snap->store->chunk_size * chunk,
 		.count = ps->snap->store->chunk_size,
 	};
@@ -253,7 +253,7 @@ static void zero_memory_area(struct psto
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
 	struct dm_io_region where = {
-		.bdev = ps->snap->cow->bdev,
+		.bdev = ps->snap->store->cow->bdev,
 		.sector = ps->snap->store->chunk_size * area_location(ps, area),
 		.count = ps->snap->store->chunk_size,
 	};
@@ -280,7 +280,7 @@ static int read_header(struct pstore *ps
 	 */
 	if (!ps->snap->store->chunk_size) {
 		ps->snap->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
-		    bdev_hardsect_size(ps->snap->cow->bdev) >> 9);
+		    bdev_hardsect_size(ps->snap->store->cow->bdev) >> 9);
 		ps->snap->store->chunk_mask = ps->snap->store->chunk_size - 1;
 		ps->snap->store->chunk_shift = ffs(ps->snap->store->chunk_size) - 1;
 		chunk_size_supplied = 0;
@@ -475,7 +475,7 @@ static void persistent_fraction_full(str
 				     sector_t *numerator, sector_t *denominator)
 {
 	*numerator = get_info(store)->next_free * store->chunk_size;
-	*denominator = get_dev_size(store->snap->cow->bdev);
+	*denominator = get_dev_size(store->cow->bdev);
 }
 
 static void persistent_dtr(struct dm_exception_store *store)
@@ -564,7 +564,7 @@ static int persistent_prepare_exception(
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
 	chunk_t next_free;
-	sector_t size = get_dev_size(store->snap->cow->bdev);
+	sector_t size = get_dev_size(store->cow->bdev);
 
 	/* Is there enough room ? */
 	if (size < ((ps->next_free + 1) * store->chunk_size))
Index: linux-2.6.28/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-transient.c	2009-01-08 02:26:09.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-transient.c	2009-01-08 02:26:27.000000000 +0000
@@ -40,7 +40,7 @@ static int transient_prepare_exception(s
 				       struct dm_snap_exception *e)
 {
 	struct transient_c *tc = store->context;
-	sector_t size = get_dev_size(store->snap->cow->bdev);
+	sector_t size = get_dev_size(store->cow->bdev);
 
 	if (size < (tc->next_free + store->chunk_size))
 		return -1;
@@ -64,7 +64,7 @@ static void transient_fraction_full(stru
 				    sector_t *numerator, sector_t *denominator)
 {
 	*numerator = ((struct transient_c *) store->context)->next_free;
-	*denominator = get_dev_size(store->snap->cow->bdev);
+	*denominator = get_dev_size(store->cow->bdev);
 }
 
 static int transient_ctr(struct dm_exception_store *store,
Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-08 02:25:42.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-08 02:26:27.000000000 +0000
@@ -468,7 +468,8 @@ static int calc_max_buckets(void)
 /*
  * Allocate room for a suitable hash table.
  */
-static int init_hash_tables(struct dm_snapshot *s, chunk_t chunk_shift)
+static int init_hash_tables(struct dm_snapshot *s, chunk_t chunk_shift,
+			    struct dm_dev *cow)
 {
 	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
 
@@ -476,7 +477,7 @@ static int init_hash_tables(struct dm_sn
 	 * Calculate based on the size of the original volume or
 	 * the COW volume...
 	 */
-	cow_dev_size = get_dev_size(s->cow->bdev);
+	cow_dev_size = get_dev_size(cow->bdev);
 	origin_dev_size = get_dev_size(s->origin->bdev);
 	max_buckets = calc_max_buckets();
 
@@ -516,7 +517,7 @@ static ulong round_up(ulong n, ulong siz
 
 static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
 			  chunk_t *chunk_size, chunk_t *chunk_mask, chunk_t *chunk_shift,
-			  char **error)
+			  struct dm_dev *cow, char **error)
 {
 	unsigned long chunk_size_ulong;
 	char *value;
@@ -545,7 +546,7 @@ static int set_chunk_size(struct dm_snap
 	}
 
 	/* Validate the chunk size against the device block size */
-	if (chunk_size_ulong % (bdev_hardsect_size(s->cow->bdev) >> 9)) {
+	if (chunk_size_ulong % (bdev_hardsect_size(cow->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
@@ -569,6 +570,7 @@ static int snapshot_ctr(struct dm_target
 	char *origin_path;
 	char *cow_path;
 	chunk_t chunk_size, chunk_mask, chunk_shift;
+	struct dm_dev *cow;
 
 	if (argc != 4) {
 		ti->error = "requires exactly 4 arguments";
@@ -601,7 +603,7 @@ static int snapshot_ctr(struct dm_target
 	}
 
 	r = dm_get_device(ti, cow_path, 0, 0,
-			  FMODE_READ | FMODE_WRITE, &s->cow);
+			  FMODE_READ | FMODE_WRITE, &cow);
 	if (r) {
 		dm_put_device(ti, s->origin);
 		ti->error = "Cannot get COW device";
@@ -609,7 +611,7 @@ static int snapshot_ctr(struct dm_target
 	}
 
 	r = set_chunk_size(s, argv[3], &chunk_size, &chunk_mask, &chunk_shift,
-			   &ti->error);
+			   cow, &ti->error);
 	if (r)
 		goto bad3;
 
@@ -620,14 +622,14 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for COW data */
-	if (init_hash_tables(s, chunk_shift)) {
+	if (init_hash_tables(s, chunk_shift, cow)) {
 		ti->error = "Unable to allocate hash table space";
 		r = -ENOMEM;
 		goto bad3;
 	}
 
 	r = dm_exception_store_create(argv[2], ti, chunk_size, chunk_mask,
-				      chunk_shift, &s->store);
+				      chunk_shift, cow, &s->store);
 	if (r) {
 		ti->error = "Couldn't create exception store";
 		r = -EINVAL;
@@ -704,7 +706,7 @@ static int snapshot_ctr(struct dm_target
 	exit_exception_table(&s->complete, exception_cache);
 
  bad3:
-	dm_put_device(ti, s->cow);
+	dm_put_device(ti, cow);
 	dm_put_device(ti, s->origin);
 
  bad2:
@@ -731,6 +733,7 @@ static void snapshot_dtr(struct dm_targe
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
+	struct dm_dev *cow = s->store->cow;
 
 	flush_workqueue(ksnapd);
 
@@ -758,7 +761,7 @@ static void snapshot_dtr(struct dm_targe
 	mempool_destroy(s->pending_pool);
 
 	dm_put_device(ti, s->origin);
-	dm_put_device(ti, s->cow);
+	dm_put_device(ti, cow);
 
 	kfree(s);
 }
@@ -960,7 +963,7 @@ static void start_copy(struct dm_snap_pe
 	src.sector = chunk_to_sector(s, pe->e.old_chunk);
 	src.count = min(s->store->chunk_size, dev_size - src.sector);
 
-	dest.bdev = s->cow->bdev;
+	dest.bdev = s->store->cow->bdev;
 	dest.sector = chunk_to_sector(s, pe->e.new_chunk);
 	dest.count = src.count;
 
@@ -1036,7 +1039,7 @@ __find_pending_exception(struct dm_snaps
 static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
 			    struct bio *bio, chunk_t chunk)
 {
-	bio->bi_bdev = s->cow->bdev;
+	bio->bi_bdev = s->store->cow->bdev;
 	bio->bi_sector = chunk_to_sector(s, dm_chunk_number(e->new_chunk) +
 			 (chunk - e->old_chunk)) +
 			 (bio->bi_sector & s->store->chunk_mask);
@@ -1162,7 +1165,7 @@ static int snapshot_status(struct dm_tar
 		 * make sense.
 		 */
 		snprintf(result, maxlen, "%s %s %s %llu",
-			 snap->origin->name, snap->cow->name,
+			 snap->origin->name, snap->store->cow->name,
 			 snap->store->type->name,
 			 (unsigned long long)snap->store->chunk_size);
 		break;
Index: linux-2.6.28/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.h	2009-01-08 02:25:42.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.h	2009-01-08 02:26:27.000000000 +0000
@@ -27,7 +27,6 @@ struct dm_snapshot {
 	struct rw_semaphore lock;
 
 	struct dm_dev *origin;
-	struct dm_dev *cow;
 
 	/* List of snapshots per Origin */
 	struct list_head list;
