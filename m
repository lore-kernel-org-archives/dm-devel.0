From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 12]:
	dm-snapshot-remove-dm_snap-header-use.patch
Date: Tue, 20 Jan 2009 14:00:16 -0600
Message-ID: <1232481616.19993.29.camel@hydrogen.msp.redhat.com>
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

Move useful functions out of dm-snap.h and stop using dm-snap.h.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.h	2009-01-08 02:45:35.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.h	2009-01-08 02:46:28.000000000 +0000
@@ -97,8 +97,6 @@ struct dm_exception_store {
 	struct dm_exception_store_type *type;
 	struct dm_target *ti;
 
-	struct dm_snapshot *snap;
-
 	struct dm_dev *cow;
 
 	/* Size of data blocks saved - must be a power of 2 */
@@ -152,6 +150,20 @@ static inline void dm_consecutive_chunk_
 
 #  endif
 
+/*
+ * Return the number of sectors in the device.
+ */
+static inline sector_t get_dev_size(struct block_device *bdev)
+{
+	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
+}
+
+static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
+				      sector_t sector)
+{
+	return (sector & ~store->chunk_mask) >> store->chunk_shift;
+}
+
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
Index: linux-2.6.28/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-persistent.c	2009-01-08 02:45:35.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-persistent.c	2009-01-08 02:45:38.000000000 +0000
@@ -6,7 +6,6 @@
  */
 
 #include "dm-exception-store.h"
-#include "dm-snap.h"
 
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -89,7 +88,7 @@ struct commit_callback {
  * The top level structure for a persistent exception store.
  */
 struct pstore {
-	struct dm_snapshot *snap;	/* up pointer to my snapshot */
+	struct dm_exception_store *store;
 	int version;
 	int valid;
 	uint32_t exceptions_per_area;
@@ -141,7 +140,7 @@ static int alloc_area(struct pstore *ps)
 	int r = -ENOMEM;
 	size_t len;
 
-	len = ps->snap->store->chunk_size << SECTOR_SHIFT;
+	len = ps->store->chunk_size << SECTOR_SHIFT;
 
 	/*
 	 * Allocate the chunk_size block of memory that will hold
@@ -189,9 +188,9 @@ static void do_metadata(struct work_stru
 static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
 {
 	struct dm_io_region where = {
-		.bdev = ps->snap->store->cow->bdev,
-		.sector = ps->snap->store->chunk_size * chunk,
-		.count = ps->snap->store->chunk_size,
+		.bdev = ps->store->cow->bdev,
+		.sector = ps->store->chunk_size * chunk,
+		.count = ps->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
 		.bi_rw = rw,
@@ -247,15 +246,15 @@ static int area_io(struct pstore *ps, in
 
 static void zero_memory_area(struct pstore *ps)
 {
-	memset(ps->area, 0, ps->snap->store->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 }
 
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
 	struct dm_io_region where = {
-		.bdev = ps->snap->store->cow->bdev,
-		.sector = ps->snap->store->chunk_size * area_location(ps, area),
-		.count = ps->snap->store->chunk_size,
+		.bdev = ps->store->cow->bdev,
+		.sector = ps->store->chunk_size * area_location(ps, area),
+		.count = ps->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
@@ -278,16 +277,16 @@ static int read_header(struct pstore *ps
 	/*
 	 * Use default chunk size (or hardsect_size, if larger) if none supplied
 	 */
-	if (!ps->snap->store->chunk_size) {
-		ps->snap->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
-		    bdev_hardsect_size(ps->snap->store->cow->bdev) >> 9);
-		ps->snap->store->chunk_mask = ps->snap->store->chunk_size - 1;
-		ps->snap->store->chunk_shift = ffs(ps->snap->store->chunk_size) - 1;
+	if (!ps->store->chunk_size) {
+		ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
+		    bdev_hardsect_size(ps->store->cow->bdev) >> 9);
+		ps->store->chunk_mask = ps->store->chunk_size - 1;
+		ps->store->chunk_shift = ffs(ps->store->chunk_size) - 1;
 		chunk_size_supplied = 0;
 	}
 
-	ps->io_client = dm_io_client_create(sectors_to_pages(ps->snap->
-							     store->chunk_size));
+	ps->io_client = dm_io_client_create(sectors_to_pages(ps->store->
+							     chunk_size));
 	if (IS_ERR(ps->io_client))
 		return PTR_ERR(ps->io_client);
 
@@ -317,22 +316,22 @@ static int read_header(struct pstore *ps
 	ps->version = le32_to_cpu(dh->version);
 	chunk_size = le32_to_cpu(dh->chunk_size);
 
-	if (!chunk_size_supplied || ps->snap->store->chunk_size == chunk_size)
+	if (!chunk_size_supplied || ps->store->chunk_size == chunk_size)
 		return 0;
 
 	DMWARN("chunk size %llu in device metadata overrides "
 	       "table chunk size of %llu.",
 	       (unsigned long long)chunk_size,
-	       (unsigned long long)ps->snap->store->chunk_size);
+	       (unsigned long long)ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
 
-	ps->snap->store->chunk_size = chunk_size;
-	ps->snap->store->chunk_mask = chunk_size - 1;
-	ps->snap->store->chunk_shift = ffs(chunk_size) - 1;
+	ps->store->chunk_size = chunk_size;
+	ps->store->chunk_mask = chunk_size - 1;
+	ps->store->chunk_shift = ffs(chunk_size) - 1;
 
-	r = dm_io_client_resize(sectors_to_pages(ps->snap->store->chunk_size),
+	r = dm_io_client_resize(sectors_to_pages(ps->store->chunk_size),
 				ps->io_client);
 	if (r)
 		return r;
@@ -349,13 +348,13 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->snap->store->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 
 	dh = (struct disk_header *) ps->area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
-	dh->chunk_size = cpu_to_le32(ps->snap->store->chunk_size);
+	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
 	return chunk_io(ps, 0, WRITE, 1);
 }
@@ -507,7 +506,7 @@ static int persistent_read_metadata(stru
 	/*
 	 * Now we know correct chunk_size, complete the initialisation.
 	 */
-	ps->exceptions_per_area = (ps->snap->store->chunk_size << SECTOR_SHIFT) /
+	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
 			sizeof(*ps->callbacks));
@@ -666,7 +665,7 @@ static int persistent_ctr(struct dm_exce
 	if (!ps)
 		return -ENOMEM;
 
-	ps->snap = store->snap;
+	ps->store = store;
 	ps->valid = 1;
 	ps->version = SNAPSHOT_DISK_VERSION;
 	ps->area = NULL;
Index: linux-2.6.28/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-transient.c	2009-01-08 02:45:35.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-transient.c	2009-01-08 02:45:38.000000000 +0000
@@ -6,7 +6,6 @@
  */
 
 #include "dm-exception-store.h"
-#include "dm-snap.h"
 
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -45,7 +44,7 @@ static int transient_prepare_exception(s
 	if (size < (tc->next_free + store->chunk_size))
 		return -1;
 
-	e->new_chunk = sector_to_chunk(store->snap, tc->next_free);
+	e->new_chunk = sector_to_chunk(store, tc->next_free);
 	tc->next_free += store->chunk_size;
 
 	return 0;
Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-08 02:45:35.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-08 02:46:00.000000000 +0000
@@ -636,8 +636,6 @@ static int snapshot_ctr(struct dm_target
 		goto bad4;
 	}
 
-	s->store->snap = s;
-
 	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
 	if (r) {
 		ti->error = "Could not create kcopyd client";
@@ -960,11 +958,11 @@ static void start_copy(struct dm_snap_pe
 	dev_size = get_dev_size(bdev);
 
 	src.bdev = bdev;
-	src.sector = chunk_to_sector(s, pe->e.old_chunk);
+	src.sector = chunk_to_sector(s->store, pe->e.old_chunk);
 	src.count = min(s->store->chunk_size, dev_size - src.sector);
 
 	dest.bdev = s->store->cow->bdev;
-	dest.sector = chunk_to_sector(s, pe->e.new_chunk);
+	dest.sector = chunk_to_sector(s->store, pe->e.new_chunk);
 	dest.count = src.count;
 
 	/* Hand over to kcopyd */
@@ -985,7 +983,7 @@ __find_pending_exception(struct dm_snaps
 {
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe;
-	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
+	chunk_t chunk = sector_to_chunk(s->store, bio->bi_sector);
 
 	/*
 	 * Is there a pending exception for this already ?
@@ -1040,7 +1038,7 @@ static void remap_exception(struct dm_sn
 			    struct bio *bio, chunk_t chunk)
 {
 	bio->bi_bdev = s->store->cow->bdev;
-	bio->bi_sector = chunk_to_sector(s, dm_chunk_number(e->new_chunk) +
+	bio->bi_sector = chunk_to_sector(s->store, dm_chunk_number(e->new_chunk) +
 			 (chunk - e->old_chunk)) +
 			 (bio->bi_sector & s->store->chunk_mask);
 }
@@ -1054,7 +1052,7 @@ static int snapshot_map(struct dm_target
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	chunk = sector_to_chunk(s, bio->bi_sector);
+	chunk = sector_to_chunk(s->store, bio->bi_sector);
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
@@ -1203,7 +1201,7 @@ static int __origin_write(struct list_he
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
-		chunk = sector_to_chunk(snap, bio->bi_sector);
+		chunk = sector_to_chunk(snap->store, bio->bi_sector);
 
 		/*
 		 * Check exception table to see if block
Index: linux-2.6.28/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.h	2009-01-08 02:45:35.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.h	2009-01-08 02:45:38.000000000 +0000
@@ -68,22 +68,10 @@ struct dm_snapshot {
 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
 };
 
-/*
- * Return the number of sectors in the device.
- */
-static inline sector_t get_dev_size(struct block_device *bdev)
+static inline sector_t chunk_to_sector(struct dm_exception_store *store,
+				      chunk_t chunk)
 {
-	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
-}
-
-static inline chunk_t sector_to_chunk(struct dm_snapshot *s, sector_t sector)
-{
-	return (sector & ~s->store->chunk_mask) >> s->store->chunk_shift;
-}
-
-static inline sector_t chunk_to_sector(struct dm_snapshot *s, chunk_t chunk)
-{
-	return chunk << s->store->chunk_shift;
+	return chunk << store->chunk_shift;
 }
 
 static inline int bdev_equal(struct block_device *lhs, struct block_device *rhs)
