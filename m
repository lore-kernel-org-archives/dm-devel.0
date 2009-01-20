From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 12]:
	dm-exception-store-move-chunk_fields.patch
Date: Tue, 20 Jan 2009 13:55:23 -0600
Message-ID: <1232481323.19993.22.camel@hydrogen.msp.redhat.com>
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

Move chunk fields from snapshot to exception store.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.c	2009-01-08 02:25:38.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.c	2009-01-08 02:25:42.000000000 +0000
@@ -143,6 +143,8 @@ int dm_exception_store_type_unregister(s
 EXPORT_SYMBOL(dm_exception_store_type_unregister);
 
 int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      chunk_t chunk_size, chunk_t chunk_mask,
+			      chunk_t chunk_shift,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
@@ -162,6 +164,10 @@ int dm_exception_store_create(const char
 	tmp_store->type = type;
 	tmp_store->ti = ti;
 
+	tmp_store->chunk_size = chunk_size;
+	tmp_store->chunk_mask = chunk_mask;
+	tmp_store->chunk_shift = chunk_shift;
+
 	r = type->ctr(tmp_store, 0, NULL);
 	if (r) {
 		put_type(type);
Index: linux-2.6.28/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.h	2009-01-08 02:25:38.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.h	2009-01-08 02:25:42.000000000 +0000
@@ -99,6 +99,11 @@ struct dm_exception_store {
 
 	struct dm_snapshot *snap;
 
+	/* Size of data blocks saved - must be a power of 2 */
+	chunk_t chunk_size;
+	chunk_t chunk_mask;
+	chunk_t chunk_shift;
+
 	void *context;
 };
 
@@ -149,6 +154,8 @@ int dm_exception_store_type_register(str
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
 int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      chunk_t chunk_size, chunk_t chunk_mask,
+			      chunk_t chunk_shift,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
Index: linux-2.6.28/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-persistent.c	2009-01-08 02:25:34.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-persistent.c	2009-01-08 02:25:42.000000000 +0000
@@ -141,7 +141,7 @@ static int alloc_area(struct pstore *ps)
 	int r = -ENOMEM;
 	size_t len;
 
-	len = ps->snap->chunk_size << SECTOR_SHIFT;
+	len = ps->snap->store->chunk_size << SECTOR_SHIFT;
 
 	/*
 	 * Allocate the chunk_size block of memory that will hold
@@ -190,8 +190,8 @@ static int chunk_io(struct pstore *ps, c
 {
 	struct dm_io_region where = {
 		.bdev = ps->snap->cow->bdev,
-		.sector = ps->snap->chunk_size * chunk,
-		.count = ps->snap->chunk_size,
+		.sector = ps->snap->store->chunk_size * chunk,
+		.count = ps->snap->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
 		.bi_rw = rw,
@@ -247,15 +247,15 @@ static int area_io(struct pstore *ps, in
 
 static void zero_memory_area(struct pstore *ps)
 {
-	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->snap->store->chunk_size << SECTOR_SHIFT);
 }
 
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
 	struct dm_io_region where = {
 		.bdev = ps->snap->cow->bdev,
-		.sector = ps->snap->chunk_size * area_location(ps, area),
-		.count = ps->snap->chunk_size,
+		.sector = ps->snap->store->chunk_size * area_location(ps, area),
+		.count = ps->snap->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
@@ -278,16 +278,16 @@ static int read_header(struct pstore *ps
 	/*
 	 * Use default chunk size (or hardsect_size, if larger) if none supplied
 	 */
-	if (!ps->snap->chunk_size) {
-		ps->snap->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
+	if (!ps->snap->store->chunk_size) {
+		ps->snap->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
 		    bdev_hardsect_size(ps->snap->cow->bdev) >> 9);
-		ps->snap->chunk_mask = ps->snap->chunk_size - 1;
-		ps->snap->chunk_shift = ffs(ps->snap->chunk_size) - 1;
+		ps->snap->store->chunk_mask = ps->snap->store->chunk_size - 1;
+		ps->snap->store->chunk_shift = ffs(ps->snap->store->chunk_size) - 1;
 		chunk_size_supplied = 0;
 	}
 
 	ps->io_client = dm_io_client_create(sectors_to_pages(ps->snap->
-							     chunk_size));
+							     store->chunk_size));
 	if (IS_ERR(ps->io_client))
 		return PTR_ERR(ps->io_client);
 
@@ -317,22 +317,22 @@ static int read_header(struct pstore *ps
 	ps->version = le32_to_cpu(dh->version);
 	chunk_size = le32_to_cpu(dh->chunk_size);
 
-	if (!chunk_size_supplied || ps->snap->chunk_size == chunk_size)
+	if (!chunk_size_supplied || ps->snap->store->chunk_size == chunk_size)
 		return 0;
 
 	DMWARN("chunk size %llu in device metadata overrides "
 	       "table chunk size of %llu.",
 	       (unsigned long long)chunk_size,
-	       (unsigned long long)ps->snap->chunk_size);
+	       (unsigned long long)ps->snap->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
 
-	ps->snap->chunk_size = chunk_size;
-	ps->snap->chunk_mask = chunk_size - 1;
-	ps->snap->chunk_shift = ffs(chunk_size) - 1;
+	ps->snap->store->chunk_size = chunk_size;
+	ps->snap->store->chunk_mask = chunk_size - 1;
+	ps->snap->store->chunk_shift = ffs(chunk_size) - 1;
 
-	r = dm_io_client_resize(sectors_to_pages(ps->snap->chunk_size),
+	r = dm_io_client_resize(sectors_to_pages(ps->snap->store->chunk_size),
 				ps->io_client);
 	if (r)
 		return r;
@@ -349,13 +349,13 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->snap->store->chunk_size << SECTOR_SHIFT);
 
 	dh = (struct disk_header *) ps->area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
-	dh->chunk_size = cpu_to_le32(ps->snap->chunk_size);
+	dh->chunk_size = cpu_to_le32(ps->snap->store->chunk_size);
 
 	return chunk_io(ps, 0, WRITE, 1);
 }
@@ -474,7 +474,7 @@ static struct pstore *get_info(struct dm
 static void persistent_fraction_full(struct dm_exception_store *store,
 				     sector_t *numerator, sector_t *denominator)
 {
-	*numerator = get_info(store)->next_free * store->snap->chunk_size;
+	*numerator = get_info(store)->next_free * store->chunk_size;
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
@@ -507,7 +507,7 @@ static int persistent_read_metadata(stru
 	/*
 	 * Now we know correct chunk_size, complete the initialisation.
 	 */
-	ps->exceptions_per_area = (ps->snap->chunk_size << SECTOR_SHIFT) /
+	ps->exceptions_per_area = (ps->snap->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
 			sizeof(*ps->callbacks));
@@ -567,7 +567,7 @@ static int persistent_prepare_exception(
 	sector_t size = get_dev_size(store->snap->cow->bdev);
 
 	/* Is there enough room ? */
-	if (size < ((ps->next_free + 1) * store->snap->chunk_size))
+	if (size < ((ps->next_free + 1) * store->chunk_size))
 		return -ENOSPC;
 
 	e->new_chunk = ps->next_free;
Index: linux-2.6.28/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-transient.c	2009-01-08 02:25:34.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-transient.c	2009-01-08 02:26:09.000000000 +0000
@@ -42,11 +42,11 @@ static int transient_prepare_exception(s
 	struct transient_c *tc = store->context;
 	sector_t size = get_dev_size(store->snap->cow->bdev);
 
-	if (size < (tc->next_free + store->snap->chunk_size))
+	if (size < (tc->next_free + store->chunk_size))
 		return -1;
 
 	e->new_chunk = sector_to_chunk(store->snap, tc->next_free);
-	tc->next_free += store->snap->chunk_size;
+	tc->next_free += store->chunk_size;
 
 	return 0;
 }
Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-08 02:25:38.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-08 02:25:42.000000000 +0000
@@ -468,7 +468,7 @@ static int calc_max_buckets(void)
 /*
  * Allocate room for a suitable hash table.
  */
-static int init_hash_tables(struct dm_snapshot *s)
+static int init_hash_tables(struct dm_snapshot *s, chunk_t chunk_shift)
 {
 	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
 
@@ -480,7 +480,7 @@ static int init_hash_tables(struct dm_sn
 	origin_dev_size = get_dev_size(s->origin->bdev);
 	max_buckets = calc_max_buckets();
 
-	hash_size = min(origin_dev_size, cow_dev_size) >> s->chunk_shift;
+	hash_size = min(origin_dev_size, cow_dev_size) >> chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
@@ -515,19 +515,20 @@ static ulong round_up(ulong n, ulong siz
 }
 
 static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
+			  chunk_t *chunk_size, chunk_t *chunk_mask, chunk_t *chunk_shift,
 			  char **error)
 {
-	unsigned long chunk_size;
+	unsigned long chunk_size_ulong;
 	char *value;
 
-	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);
+	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
 	if (*chunk_size_arg == '\0' || *value != '\0') {
 		*error = "Invalid chunk size";
 		return -EINVAL;
 	}
 
-	if (!chunk_size) {
-		s->chunk_size = s->chunk_mask = s->chunk_shift = 0;
+	if (!chunk_size_ulong) {
+		*chunk_size = *chunk_mask = *chunk_shift = 0;
 		return 0;
 	}
 
@@ -535,23 +536,23 @@ static int set_chunk_size(struct dm_snap
 	 * Chunk size must be multiple of page size.  Silently
 	 * round up if it's not.
 	 */
-	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
+	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
 
 	/* Check chunk_size is a power of 2 */
-	if (!is_power_of_2(chunk_size)) {
+	if (!is_power_of_2(chunk_size_ulong)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}
 
 	/* Validate the chunk size against the device block size */
-	if (chunk_size % (bdev_hardsect_size(s->cow->bdev) >> 9)) {
+	if (chunk_size_ulong % (bdev_hardsect_size(s->cow->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
 
-	s->chunk_size = chunk_size;
-	s->chunk_mask = chunk_size - 1;
-	s->chunk_shift = ffs(chunk_size) - 1;
+	*chunk_size = chunk_size_ulong;
+	*chunk_mask = chunk_size_ulong - 1;
+	*chunk_shift = ffs(chunk_size_ulong) - 1;
 
 	return 0;
 }
@@ -567,6 +568,7 @@ static int snapshot_ctr(struct dm_target
 	char persistent;
 	char *origin_path;
 	char *cow_path;
+	chunk_t chunk_size, chunk_mask, chunk_shift;
 
 	if (argc != 4) {
 		ti->error = "requires exactly 4 arguments";
@@ -606,7 +608,8 @@ static int snapshot_ctr(struct dm_target
 		goto bad2;
 	}
 
-	r = set_chunk_size(s, argv[3], &ti->error);
+	r = set_chunk_size(s, argv[3], &chunk_size, &chunk_mask, &chunk_shift,
+			   &ti->error);
 	if (r)
 		goto bad3;
 
@@ -617,13 +620,14 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for COW data */
-	if (init_hash_tables(s)) {
+	if (init_hash_tables(s, chunk_shift)) {
 		ti->error = "Unable to allocate hash table space";
 		r = -ENOMEM;
 		goto bad3;
 	}
 
-	r = dm_exception_store_create(argv[2], ti, &s->store);
+	r = dm_exception_store_create(argv[2], ti, chunk_size, chunk_mask,
+				      chunk_shift, &s->store);
 	if (r) {
 		ti->error = "Couldn't create exception store";
 		r = -EINVAL;
@@ -679,7 +683,7 @@ static int snapshot_ctr(struct dm_target
 	}
 
 	ti->private = s;
-	ti->split_io = s->chunk_size;
+	ti->split_io = s->store->chunk_size;
 
 	return 0;
 
@@ -954,7 +958,7 @@ static void start_copy(struct dm_snap_pe
 
 	src.bdev = bdev;
 	src.sector = chunk_to_sector(s, pe->e.old_chunk);
-	src.count = min(s->chunk_size, dev_size - src.sector);
+	src.count = min(s->store->chunk_size, dev_size - src.sector);
 
 	dest.bdev = s->cow->bdev;
 	dest.sector = chunk_to_sector(s, pe->e.new_chunk);
@@ -1035,7 +1039,7 @@ static void remap_exception(struct dm_sn
 	bio->bi_bdev = s->cow->bdev;
 	bio->bi_sector = chunk_to_sector(s, dm_chunk_number(e->new_chunk) +
 			 (chunk - e->old_chunk)) +
-			 (bio->bi_sector & s->chunk_mask);
+			 (bio->bi_sector & s->store->chunk_mask);
 }
 
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
@@ -1160,7 +1164,7 @@ static int snapshot_status(struct dm_tar
 		snprintf(result, maxlen, "%s %s %s %llu",
 			 snap->origin->name, snap->cow->name,
 			 snap->store->type->name,
-			 (unsigned long long)snap->chunk_size);
+			 (unsigned long long)snap->store->chunk_size);
 		break;
 	}
 
@@ -1353,7 +1357,7 @@ static void origin_resume(struct dm_targ
 	o = __lookup_origin(dev->bdev);
 	if (o)
 		list_for_each_entry (snap, &o->snapshots, list)
-			chunk_size = min_not_zero(chunk_size, snap->chunk_size);
+			chunk_size = min_not_zero(chunk_size, snap->store->chunk_size);
 	up_read(&_origins_lock);
 
 	ti->split_io = chunk_size;
Index: linux-2.6.28/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.h	2009-01-08 02:25:38.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.h	2009-01-08 02:25:42.000000000 +0000
@@ -32,11 +32,6 @@ struct dm_snapshot {
 	/* List of snapshots per Origin */
 	struct list_head list;
 
-	/* Size of data blocks saved - must be a power of 2 */
-	chunk_t chunk_size;
-	chunk_t chunk_mask;
-	chunk_t chunk_shift;
-
 	/* You can't use a snapshot if this is 0 (e.g. if full) */
 	int valid;
 
@@ -84,12 +79,12 @@ static inline sector_t get_dev_size(stru
 
 static inline chunk_t sector_to_chunk(struct dm_snapshot *s, sector_t sector)
 {
-	return (sector & ~s->chunk_mask) >> s->chunk_shift;
+	return (sector & ~s->store->chunk_mask) >> s->store->chunk_shift;
 }
 
 static inline sector_t chunk_to_sector(struct dm_snapshot *s, chunk_t chunk)
 {
-	return chunk << s->chunk_shift;
+	return chunk << s->store->chunk_shift;
 }
 
 static inline int bdev_equal(struct block_device *lhs, struct block_device *rhs)
