From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: use unsigned integer chunk size
Date: Wed, 30 Sep 2009 10:41:10 -0400
Message-ID: <20090930144110.GA16605@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Use unsigned integer chunk size.

Maximum chunk size is 512kB, there won't ever be need to use 4GB chunk size,
so the number can be 32-bit. This fixes compiler failure on 32-bit systems
with large block devices.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

---
NOTE: this patch was made to go _before_ the snapshot exception
patchset; I'll be sending [v2] of 2 patches from that series.  They
needed small adjustments now that this chunk_size patch comes before
them.
---
 drivers/md/dm-exception-store.c |   23 +++++++++++------------
 drivers/md/dm-exception-store.h |    8 ++++----
 drivers/md/dm-snap-persistent.c |   16 ++++++++--------
 drivers/md/dm-snap.c            |    4 ++--
 4 files changed, 25 insertions(+), 26 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -527,7 +527,7 @@ static int dm_add_exception(void *contex
 static sector_t __minimum_chunk_size(struct origin *o)
 {
 	struct dm_snapshot *snap;
-	sector_t chunk_size = 0;
+	unsigned chunk_size = 0;
 
 	if (o)
 		list_for_each_entry(snap, &o->snapshots, list)
@@ -975,7 +975,7 @@ static void start_copy(struct dm_snap_pe
 
 	src.bdev = bdev;
 	src.sector = chunk_to_sector(s->store, pe->e.old_chunk);
-	src.count = min(s->store->chunk_size, dev_size - src.sector);
+	src.count = min((sector_t)s->store->chunk_size, dev_size - src.sector);
 
 	dest.bdev = s->store->cow->bdev;
 	dest.sector = chunk_to_sector(s->store, pe->e.new_chunk);
Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -141,48 +141,47 @@ EXPORT_SYMBOL(dm_exception_store_type_un
 static int set_chunk_size(struct dm_exception_store *store,
 			  const char *chunk_size_arg, char **error)
 {
-	unsigned long chunk_size_ulong;
+	unsigned chunk_size;
 	char *value;
 
-	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
+	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);
 	if (*chunk_size_arg == '\0' || *value != '\0') {
 		*error = "Invalid chunk size";
 		return -EINVAL;
 	}
 
-	if (!chunk_size_ulong) {
+	if (!chunk_size) {
 		store->chunk_size = store->chunk_mask = store->chunk_shift = 0;
 		return 0;
 	}
 
-	return dm_exception_store_set_chunk_size(store, chunk_size_ulong,
-						 error);
+	return dm_exception_store_set_chunk_size(store, chunk_size, error);
 }
 
 int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
-				      unsigned long chunk_size_ulong,
+				      unsigned chunk_size,
 				      char **error)
 {
 	/* Check chunk_size is a power of 2 */
-	if (!is_power_of_2(chunk_size_ulong)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}
 
 	/* Validate the chunk size against the device block size */
-	if (chunk_size_ulong % (bdev_logical_block_size(store->cow->bdev) >> 9)) {
+	if (chunk_size % (bdev_logical_block_size(store->cow->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
 
-	if (chunk_size_ulong > INT_MAX >> SECTOR_SHIFT) {
+	if (chunk_size > INT_MAX >> SECTOR_SHIFT) {
 		*error = "Chunk size is too high";
 		return -EINVAL;
 	}
 
-	store->chunk_size = chunk_size_ulong;
-	store->chunk_mask = chunk_size_ulong - 1;
-	store->chunk_shift = ffs(chunk_size_ulong) - 1;
+	store->chunk_size = chunk_size;
+	store->chunk_mask = chunk_size - 1;
+	store->chunk_shift = ffs(chunk_size) - 1;
 
 	return 0;
 }
Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -101,9 +101,9 @@ struct dm_exception_store {
 	struct dm_dev *cow;
 
 	/* Size of data blocks saved - must be a power of 2 */
-	chunk_t chunk_size;
-	chunk_t chunk_mask;
-	chunk_t chunk_shift;
+	unsigned chunk_size;
+	unsigned chunk_mask;
+	unsigned chunk_shift;
 
 	void *context;
 };
@@ -169,7 +169,7 @@ int dm_exception_store_type_register(str
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
 int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
-				      unsigned long chunk_size_ulong,
+				      unsigned chunk_size,
 				      char **error);
 
 int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -284,12 +284,13 @@ static int read_header(struct pstore *ps
 {
 	int r;
 	struct disk_header *dh;
-	chunk_t chunk_size;
+	unsigned chunk_size;
 	int chunk_size_supplied = 1;
 	char *chunk_err;
 
 	/*
-	 * Use default chunk size (or hardsect_size, if larger) if none supplied
+	 * Use default chunk size (or logical_block_size, if larger)
+	 * if none supplied
 	 */
 	if (!ps->store->chunk_size) {
 		ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
@@ -334,10 +335,9 @@ static int read_header(struct pstore *ps
 		return 0;
 
 	if (chunk_size_supplied)
-		DMWARN("chunk size %llu in device metadata overrides "
-		       "table chunk size of %llu.",
-		       (unsigned long long)chunk_size,
-		       (unsigned long long)ps->store->chunk_size);
+		DMWARN("chunk size %u in device metadata overrides "
+		       "table chunk size of %u.",
+		       chunk_size, ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
@@ -345,8 +345,8 @@ static int read_header(struct pstore *ps
 	r = dm_exception_store_set_chunk_size(ps->store, chunk_size,
 					      &chunk_err);
 	if (r) {
-		DMERR("invalid on-disk chunk size %llu: %s.",
-		      (unsigned long long)chunk_size, chunk_err);
+		DMERR("invalid on-disk chunk size %u: %s.",
+		      chunk_size, chunk_err);
 		return r;
 	}
 
